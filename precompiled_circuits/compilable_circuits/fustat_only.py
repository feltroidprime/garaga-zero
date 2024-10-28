from dataclasses import dataclass
from random import randint

from garaga.definitions import CURVES, STARK, CurveID, G1Point, G2Point, get_base_field
from garaga.extension_field_modulo_circuit import ExtensionFieldModuloCircuit
from garaga.hints.io import bigint_split, int_to_u384

from garaga.modulo_circuit import WriteOps
from garaga.precompiled_circuits import (
    final_exp,
    multi_miller_loop,
    multi_pairing_check,
)
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseEXTFCircuit,
    BaseModuloCircuit,
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
)
from garaga.precompiled_circuits.ec import DerivePointFromX


class DerivePointFromXCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="derive_point_from_x",
            input_len=3,  # X + b + G
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field(randint(0, STARK - 1)))
        input.append(self.field(CURVES[self.curve_id].a))
        input.append(self.field(CURVES[self.curve_id].b))  # y^2 = x^3 + b
        input.append(self.field(CURVES[self.curve_id].fp_generator))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = DerivePointFromX(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        x, a, b, g = circuit.write_elements(input[0:4], WriteOps.INPUT)
        rhs, grhs, should_be_rhs, should_be_grhs, y_try = circuit._derive_point_from_x(
            x, a, b, g
        )
        circuit.extend_output([rhs, grhs, should_be_rhs, should_be_grhs, y_try])

        return circuit


class FP12MulCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "fp12_mul", 24, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = ExtensionFieldModuloCircuit(
            self.name,
            self.curve_id,
            extension_degree=12,
            init_hash=self.init_hash,
            compilation_mode=self.compilation_mode,
        )
        X = circuit.write_elements(input[0:12], WriteOps.INPUT)
        Y = circuit.write_elements(input[12:24], WriteOps.INPUT)
        xy = circuit.extf_mul([X, Y], 12)
        circuit.extend_output(xy)
        circuit.finalize_circuit()

        return circuit


class FinalExpPart1Circuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "final_exp_part_1", 12, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit: final_exp.FinalExpTorusCircuit = final_exp.GaragaFinalExp[
            CurveID(self.curve_id)
        ](name="final_exp_part_1", init_hash=self.init_hash)
        t0, t1, _sum = circuit.final_exp_part1(input[0:6], input[6:12])
        # for t0_val in t0:
        #     print(f"Final exp Part1 t0 {hex(t0_val.value)}")
        # for t1_val in t1:
        #     print(f"Final exp Part1 t1 {hex(t1_val.value)}")
        # for _sum_val in _sum:
        #     print(f"Final exp Part1 _sum {hex(_sum_val.value)}")
        # Note : output is handled inside final_exp_part1.
        circuit.finalize_circuit()

        return circuit


class FinalExpPart2Circuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "final_exp_part_2", 12, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit: final_exp.FinalExpTorusCircuit = final_exp.GaragaFinalExp[
            CurveID(self.curve_id)
        ](name="final_exp_part_2", hash_input=False, init_hash=self.init_hash)
        res = circuit.final_exp_finalize(input[0:6], input[6:12])
        circuit.extend_output(res)

        return circuit


class MultiMillerLoop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        self.n_pairs = n_pairs
        super().__init__(
            f"multi_miller_loop_{n_pairs}",
            6 * n_pairs,
            curve_id,
            auto_run,
            compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        curve_id = CurveID(self.curve_id)
        order = CURVES[self.curve_id].n
        input = []
        for _ in range(self.n_pairs):
            n1, n2 = randint(1, order), randint(1, order)
            p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
            pair = [p1.x, p1.y, p2.x[0], p2.x[1], p2.y[0], p2.y[1]]
            input.extend([self.field(x) for x in pair])
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        assert (
            len(input) % 6 == 0
        ), f"Input length must be a multiple of 6, got {len(input)}"
        n_pairs = len(input) // 6
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            f"multi_miller_loop_{n_pairs}",
            self.curve_id,
            n_pairs=n_pairs,
            hash_input=True,
        )
        circuit.write_p_and_q_raw(input)

        m = circuit.miller_loop(n_pairs)

        circuit.extend_output(m)
        circuit.finalize_circuit()

        return circuit


class MultiPairingCheck(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        self.n_pairs = n_pairs
        super().__init__(
            f"multi_pairing_check_{n_pairs}",
            6 * n_pairs,
            curve_id,
            auto_run,
            compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:

        input, _ = multi_pairing_check.get_pairing_check_input(
            CurveID(self.curve_id), self.n_pairs
        )
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        assert (
            len(input) % 6 == 0
        ), f"Input length must be a multiple of 6, got {len(input)}"
        n_pairs = len(input) // 6
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit = multi_pairing_check.MultiPairingCheckCircuit(
            f"multi_pairing_check_{n_pairs}",
            self.curve_id,
            n_pairs=n_pairs,
            hash_input=True,
        )
        circuit.write_p_and_q_raw(input)

        m, _, _, _, _ = circuit.multi_pairing_check(n_pairs)

        circuit.extend_output(m)

        circuit.finalize_circuit()

        return circuit
    
@dataclass(slots=True)
class MapToCurveHint:
    gx1_is_square: bool
    y1: PyFelt
    y_flag: bool

    def to_cairo(self) -> str:
        return f"MapToCurveHint {{ gx1_is_square: {str(self.gx1_is_square).lower()}, y1: {int_to_u384(self.y1.value, as_hex=True)}, y_flag: {str(self.y_flag).lower()} }}"

    def to_calldata(self) -> list[int]:
        cd = []
        cd.append(int(self.gx1_is_square))
        cd.extend(bigint_split(self.y1.value))
        cd.append(int(self.y_flag))
        return cd


class MapToCurveCircuit(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]

    def set_consts(self):
        # Standard G2 curve parameters for BLS12-381
        # A = [0, 0]  # The G2 curve has a=0
        # B = [(4 * (1 + i))] = [4, 4]  # 4(1 + i) is the twist of the original b parameter
        # Z = [u, 0] where u is a quadratic non-residue in Fp, typically u = -1

        self.swu_a = [
            self.write_element(circuit.field(0)),  # real part
            self.write_element(circuit.field(240))   # imaginary part
        ]
        
        self.swu_b = [
            self.write_element(circuit.field(1012)),  # real part
            self.write_element(circuit.field(1012))   # imaginary part
        ]
        
        self.swu_z = [
            self.write_element(circuit.field(-2)),  # real part
            self.write_element(circuit.field(-1))    # imaginary part
        ]

        self.one = [
            self.write_element(circuit.field(1)),  # real part
            self.write_element(circuit.field(0))   # imaginary part
        ]

        self.zero = [
            self.write_element(circuit.field(0)),  # real part
            self.write_element(circuit.field(0))   # imaginary part
        ]

    def map_to_curve(self, field_element: PyFelt):
        is_quadratic_hint = self.build_map_to_curve_hint(field_element)
        neg_ta, num_x1 = self._map_to_curve_inner_1(field_element)
        g1x, div = self._map_to_curve_inner_2(neg_ta, num_x1)
        print(f"is_quadratic_hint: {is_quadratic_hint}")


    def _map_to_curve_inner_1(self, field_element: PyFelt):
        u2 = self.fp2_square([self.write_element(field_element), self.write_element(circuit.field(0))])
        zeta_u2 = self.fp2_mul(self.swu_z, u2)
        zeta_u2_square = self.fp2_square(zeta_u2)
        ta = self.fp2_add(zeta_u2_square, zeta_u2)
        neg_ta = self.fp2_sub(self.zero, ta)
        num_x1 = self.fp2_mul(self.swu_b, self.fp2_add(ta, self.one))
        print(f"num_x1: {num_x1}")

        return (neg_ta, num_x1)
    
    def _map_to_curve_inner_2(self, neg_ta: ModuloCircuitElement, num_x1: ModuloCircuitElement):        
        _neg_ta_or_z = self.swu_z if neg_ta == self.write_element(circuit.field(0)) else neg_ta
        div = self.fp2_mul(self.swu_a, _neg_ta_or_z)
        print(f"div: {div}")
        num2_x1 = self.fp2_square(num_x1)
        print(f"num2_x1: {num2_x1}")
        div2 = self.fp2_square(div)
        print(f"div2: {div2}")
        div3 = self.fp2_mul(div, div2)
        print(f"div3: {div3}")

        num_gx1 = self.fp2_add(
            self.fp2_mul(
                self.fp2_add(
                    num2_x1, 
                    self.fp2_mul(self.swu_a, div2)
                ),
                num_x1
            ),
            self.fp2_mul(self.swu_b, div3)
        )
        print(f"num_gx1: {num_gx1}")
        g1x = self.fp2_mul(num_gx1, self.fp2_inv(div3))

        return (g1x, div)
    
    def build_map_to_curve_hint(self, u: PyFelt) -> tuple[G2Point, MapToCurveHint]:
        # field = get_base_field(CurveID.BLS12_381)

        zeta_u2 = self.swu_z * u**2
        ta = zeta_u2**2 + zeta_u2
        num_x1 = self.swu_b * (ta + self.field.one())

        if ta.value == 0:
            div = self.swu_a * self.swu_z
        else:
            div = self.swu_a * -ta

        num2_x1 = num_x1**2
        div2 = div**2
        div3 = div2 * div
        assert div3.value != 0

        num_gx1 = (num2_x1 + self.swu_a * div2) * num_x1 + self.swu_b * div3
        num_x2 = zeta_u2 * num_x1

        gx1 = num_gx1 / div3
        gx1_square = gx1.is_quad_residue()
        if gx1_square:
            y1 = gx1.sqrt(min_root=False)
            assert y1 * y1 == gx1
        else:
            y1 = (self.swu_z * gx1).sqrt(min_root=False)
            assert y1 * y1 == self.swu_z * gx1

        y2 = zeta_u2 * u * y1
        y = y1 if gx1_square else y2
        y_flag = y.value % 2 == u.value % 2

        num_x = num_x1 if gx1_square else num_x2
        x_affine = num_x / div
        y_affine = -y if y.value % 2 != u.value % 2 else y

        point_on_curve = G2Point(
            x_affine.value, y_affine.value, CurveID.BLS12_381, iso_point=True
        )
        return point_on_curve, MapToCurveHint(
            gx1_is_square=gx1_square, y1=y1, y_flag=y_flag
        )
    


# let num_gx1 = 
#   circuit_add(
#       circuit_mul(
#           circuit_add(
#               num2_x1, 
#               circuit_mul(a, div2)
#           ), 
#           num_x1
#       ), 
#       circuit_mul(b, div3)
#   );


if __name__ == "__main__":
    circuit = MapToCurveCircuit("map_to_curve", 1)  # BLS12-381
    
    # Set the constants for BLS12-381 G2 curve
    
    circuit.set_consts()
    circuit.map_to_curve(circuit.field(2))

    # circuit.compile_circuit()


# numerator / num_x1 Fp2 {
#   c0: Fp {
#     value: 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272540559n
#   },
#   c1: Fp { value: 102212n }
# }
# denominator pre-zero Fp2 {
#   c0: Fp { value: 14400n },
#   c1: Fp {
#     value: 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272550187n
#   }
# }
# denominator/div post-zero Fp2 {
#   c0: Fp { value: 14400n },
#   c1: Fp {
#     value: 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272550187n
#   }
# }
# v / div3 Fp2 {
#   c0: Fp {
#     value: 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664036898944559787n
#   },
#   c1: Fp {
#     value: 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664032807040559787n
#   }
# }
# u / num_gx1 Fp2 {
#   c0: Fp { value: 634704433641344n },
#   c1: Fp {
#     value: 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015663178555035037483n
#   }
# }
#  /// Map an arbitrary base field element to a curve point.
#     /// Based on
#     /// <https://github.com/zcash/pasta_curves/blob/main/src/hashtocurve.rs>.
#     fn map_to_curve(element: P::BaseField) -> Result<Affine<P>, HashToCurveError> {
#         // 1. tv1 = inv0(Z^2 * u^4 + Z * u^2)
#         // 2. x1 = (-B / A) * (1 + tv1)
#         // 3. If tv1 == 0, set x1 = B / (Z * A)
#         // 4. gx1 = x1^3 + A * x1 + B
#         //
#         // We use the "Avoiding inversions" optimization in [WB2019, section 4.2]
#         // (not to be confused with section 4.3):
#         //
#         //   here       [WB2019]
#         //   -------    ---------------------------------
#         //   Z          ξ
#         //   u          t
#         //   Z * u^2    ξ * t^2 (called u, confusingly)
#         //   x1         X_0(t)
#         //   x2         X_1(t)
#         //   gx1        g(X_0(t))
#         //   gx2        g(X_1(t))
#         //
#         // Using the "here" names:
#         //    x1 = num_x1/div      = [B*(Z^2 * u^4 + Z * u^2 + 1)] / [-A*(Z^2 * u^4 + Z * u^2]
#         //   gx1 = num_gx1/div_gx1 = [num_x1^3 + A * num_x1 * div^2 + B * div^3] / div^3
#         let a = P::COEFF_A;
#         let b = P::COEFF_B;

#         let zeta_u2 = P::ZETA * element.square();
#         let ta = zeta_u2.square() + zeta_u2;
#         let num_x1 = b * (ta + <P::BaseField as One>::one());
#         let div = a * if ta.is_zero() { P::ZETA } else { -ta };

#         let num2_x1 = num_x1.square();
#         let div2 = div.square();
#         let div3 = div2 * div;
#         let num_gx1 = (num2_x1 + a * div2) * num_x1 + b * div3;

#         // 5. x2 = Z * u^2 * x1
#         let num_x2 = zeta_u2 * num_x1; // same div

#         // 6. gx2 = x2^3 + A * x2 + B  [optimized out; see below]
#         // 7. If is_square(gx1), set x = x1 and y = sqrt(gx1)
#         // 8. Else set x = x2 and y = sqrt(gx2)
#         let gx1_square;
#         let gx1;

#         debug_assert!(
#             !div3.is_zero(),
#             "we have checked that neither a or ZETA are zero. Q.E.D."
#         );
#         let y1: P::BaseField = {
#             gx1 = num_gx1 / div3;
#             if gx1.legendre().is_qr() {
#                 gx1_square = true;
#                 gx1.sqrt()
#                     .expect("We have checked that gx1 is a quadratic residue. Q.E.D")
#             } else {
#                 let zeta_gx1 = P::ZETA * gx1;
#                 gx1_square = false;
#                 zeta_gx1.sqrt().expect(
#                     "ZETA * gx1 is a quadratic residue because legard is multiplicative. Q.E.D",
#                 )
#             }
#         };