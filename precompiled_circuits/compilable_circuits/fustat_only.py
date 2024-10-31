from random import randint

from garaga.definitions import CURVES, STARK, CurveID, G1Point, G2Point, ISOGENY_MAP_G2
from garaga.extension_field_modulo_circuit import ExtensionFieldModuloCircuit
import garaga.modulo_circuit_structs as structs

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
from garaga.algebra import Fp2


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
    
class IsogenyMapG2Circuit(ModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name="bls12_381_isogeny_map_g2",
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]
        if auto_run:
            self.input = self.build_input()
            self.circuit: ModuloCircuit = self._run_circuit_inner(self.input.copy())

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def set_consts(self):
        # Isogeny map constants
        iso_map = ISOGENY_MAP_G2[self.curve_id]

        self.iso_x_num = [[self.write_element(self.field(x[0])), self.write_element(self.field(x[1]))] for x in iso_map["x_map_num"]]
        self.iso_x_den = [[self.write_element(self.field(x[0])), self.write_element(self.field(x[1]))] for x in iso_map["x_map_den"]]
        self.iso_y_num = [[self.write_element(self.field(x[0])), self.write_element(self.field(x[1]))] for x in iso_map["y_map_num"]]
        self.iso_y_den = [[self.write_element(self.field(x[0])), self.write_element(self.field(x[1]))] for x in iso_map["y_map_den"]]
        
   
    def _run_circuit_inner(self, x: list[ModuloCircuitElement], y: list[ModuloCircuitElement]):
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            compilation_mode=self.compilation_mode,
        )

        p_x = self.write_elements([x[0].felt, x[1].felt], WriteOps.INPUT)
        p_y = self.write_elements([y[0].felt, y[1].felt], WriteOps.INPUT)

        x_affine_num = self.fp2_eval_horner(self.iso_x_num, p_x, "x_num")
        x_affine_den = self.fp2_eval_horner(self.iso_x_den, p_x, "x_den")
        x_affine = self.fp2_div(x_affine_num, x_affine_den)
        y_affine_num = self.fp2_eval_horner(self.iso_y_num, p_x, "y_num")
        y_affine_den = self.fp2_eval_horner(self.iso_y_den, p_x, "y_den")
        y_affine_eval = self.fp2_div(y_affine_num, y_affine_den)
        y_affine = self.fp2_mul(y_affine_eval, p_y)

        print(f"x_affine: {x_affine}")
        print(f"y_affine: {y_affine}")


        circuit.extend_struct_output(
            structs.G2PointCircuit(name="res", elmts=[x_affine[0], x_affine[1], y_affine[0], y_affine[1]])
        )

        # circuit.finalize_circuit()

        return circuit
    
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
        # is_quadratic_hint = self.build_map_to_curve_hint(field_element)
        field = self.write_elements([field_element, self.field(0)], WriteOps.INPUT)
        zeta_u2, neg_ta, num_x1 = self._map_to_curve_inner_1(field)

        g1x, div = self._map_to_curve_inner_2(neg_ta, num_x1)
        print(f"g1x: {g1x}")


        # flag = self.one if Fp2(g1x[0].felt, g1x[1].felt).is_quad_residue() else self.zero
        # y1 = self.fp2_add(
        #     self.fp2_mul(flag, self.fp2_sqrt(g1x)), # g1x is a quadratic residue
        #     self.fp2_mul(self.fp2_sub(self.one, flag), self.fp2_sqrt(self.fp2_mul(self.swu_z, g1x))) # g1x is not a quadratic residue
        # )
        if Fp2(g1x[0].felt, g1x[1].felt).is_quad_residue():
            print("Quadratic residue")
            (x_affine, y) = self._map_to_curve_final_quad_res(g1x, num_x1, div)
        else:
            print("Non quadratic residue")
            (x_affine, y) = self._map_to_curve_final_non_quad_res(g1x, field, zeta_u2, num_x1, div)

    
        y_parity = self.fp2_parity(y)
        element_parity = self.fp2_parity(field)

        same_parity = [
            # XOR implementation: a + b - 2ab
            self.sub(
                self.add(y_parity[0], element_parity[0]),
                self.mul(
                    self.set_or_get_constant(2),
                    self.mul(y_parity[0], element_parity[0])
                )
            ),
            self.zero[0]  # imaginary part is 0
        ]

        y_affine = self.fp2_add(
            self.fp2_mul([same_parity[0], same_parity[1]], y),  # Keep y if different parity
            self.fp2_mul(
                [self.sub(self.one[0], same_parity[0]), self.zero[0]],  # [1 - same_parity, 0]
                self.fp2_sub(self.zero, y)  # -y
            )
        )

        return (x_affine, y_affine)


    def _map_to_curve_inner_1(self, field: list[ModuloCircuitElement]):
        u2 = self.fp2_square(field)
        zeta_u2 = self.fp2_mul(self.swu_z, u2)
        zeta_u2_square = self.fp2_square(zeta_u2)
        ta = self.fp2_add(zeta_u2_square, zeta_u2)
        neg_ta = self.fp2_sub(self.zero, ta)
        num_x1 = self.fp2_mul(self.swu_b, self.fp2_add(ta, self.one))

        return (zeta_u2, neg_ta, num_x1)
    
    def _map_to_curve_inner_2(self, neg_ta: ModuloCircuitElement, num_x1: ModuloCircuitElement):        
        _neg_ta_or_z = self.swu_z if neg_ta == self.write_element(circuit.field(0)) else neg_ta
        div = self.fp2_mul(self.swu_a, _neg_ta_or_z)
        num2_x1 = self.fp2_square(num_x1)
        div2 = self.fp2_square(div)
        div3 = self.fp2_mul(div, div2)

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
        g1x = self.fp2_mul(num_gx1, self.fp2_inv(div3))

        return (g1x, div)
    
    def _map_to_curve_final_quad_res(self, g1x: list[ModuloCircuitElement], num_x: list[ModuloCircuitElement], div: list[ModuloCircuitElement]):
        # If g1x is not a quadratic residue, this function will fail
        y = self.fp2_sqrt(g1x)
        x_affine = self.fp2_div(num_x, div)
        return (x_affine, y)

    def _map_to_curve_final_non_quad_res(self, g1x: list[ModuloCircuitElement], field: list[ModuloCircuitElement], zeta_u2: list[ModuloCircuitElement], num_x1: list[ModuloCircuitElement], div: list[ModuloCircuitElement]):
        # since swu_z is non-quadratic, this computation will only work, if g1x is non-quadratic
        y1 = self.fp2_sqrt(self.fp2_mul(self.swu_z, g1x))
        y = self.fp2_mul(zeta_u2, self.fp2_mul(field, y1))
        num_x = self.fp2_mul(zeta_u2, num_x1)
        x_affine = self.fp2_div(num_x, div)
        return (x_affine, y)

if __name__ == "__main__":
    circuit = MapToCurveCircuit("map_to_curve", 1)  # BLS12-381
    
    # Set the constants for BLS12-381 G2 curve
    
    circuit.set_consts()
    print("Mapping to curve")
    x, y = circuit.map_to_curve(circuit.field(0x18b90e7987b9393d878786da78fa13fd135aa063454c6023e1fbafd896f89df9))
    print(f"x: {x}")
    print(f"y: {y}")
    iso = Bls12_381IsogenyMapG2(1)
    iso.set_consts()
    iso._run_circuit_inner(x, y)




# x3 Fp2 {
#   c0: Fp {
#     value: 1372134176899860246244028516176065174866312977811315874569338461204206165587225531748079341806405957630388037148009n
#   },
#   c1: Fp {
#     value: 1675787217455407539471851906599310197818787504174977641596286786595904597312088147111339379080022864241847095389122n
#   }
# }
# y3 Fp2 {
#   c0: Fp {
#     value: 3711533319878567715055713840509005867072034515100332812742479883189714261245212038232516066280029143524678170330340n
#   },
#   c1: Fp {
#     value: 3141422123896915690912042140687125495903819382357920373233870178540155061525451021134201937269664919097938688977016n
#   }
# }