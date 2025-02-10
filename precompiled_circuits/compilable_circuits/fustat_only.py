from random import randint

import garaga.modulo_circuit_structs as structs
from garaga.definitions import CURVES, STARK, CurveID, G1Point, G2Point
from garaga.extension_field_modulo_circuit import ExtensionFieldModuloCircuit
from garaga.modulo_circuit import WriteOps
from garaga.precompiled_circuits import (
    final_exp,
    multi_miller_loop,
    multi_pairing_check,
)
from garaga.precompiled_circuits.cofactor_clearing import FastG2CofactorClearing
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseEXTFCircuit,
    BaseModuloCircuit,
    ModuloCircuit,
    PyFelt,
)
from garaga.precompiled_circuits.ec import (
    BasicECG2,
    DecompressG1Point,
    DerivePointFromX,
)
from garaga.precompiled_circuits.isogeny import IsogenyG2
from garaga.precompiled_circuits.map_to_curve import MapToCurveG2


class DerivePointFromXCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="derive_point_from_x",
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


class DecompressG1PointCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="decompress_g1_point",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field(CURVES[self.curve_id].b))  # y^2 = x^3 + b
        input.append(self.field(G1Point.gen_random_point(CurveID(self.curve_id)).x))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = DecompressG1Point(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        b, x = circuit.write_elements(input[0:2], WriteOps.INPUT)
        y, y_neg = circuit.derive_y_from_x(b, x)

        circuit.extend_output([y, y_neg])

        return circuit


class FP12MulCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__("fp12_mul", curve_id, auto_run, init_hash, compilation_mode)

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(24)]

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
            "final_exp_part_1", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(12)]

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
            "final_exp_part_2", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(12)]

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


class MapToCurveG2Part1Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0, auto_run: bool = True):
        super().__init__(
            name="map_to_curve_g2_first_step",
            curve_id=curve_id,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, 1000000)), self.field(0)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MapToCurveG2(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )

        circuit.set_consts()
        input_value = circuit.write_elements(input, WriteOps.INPUT)
        intermediate_values = circuit.map_to_curve_part_1(input_value)
        circuit.extend_output(intermediate_values[0])  # g1x
        circuit.extend_output(intermediate_values[1])  # div
        circuit.extend_output(intermediate_values[2])  # num_x1
        circuit.extend_output(intermediate_values[3])  # zeta_u2

        return circuit


class MapToCurveG2ComputeInialCoordinatesQuadratic(BaseModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0, auto_run: bool = True):
        super().__init__(
            name="map_to_curve_g2_quad",
            curve_id=curve_id,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [
            self.field(randint(0, 1000000)),  # field
            self.field(1),  # 0
            self.field(1012),  # g1x
            self.field(17),  # 0
            self.field(randint(0, 1000000)),  # div
            self.field(1),  # 0
            self.field(randint(0, 1000000)),  # num_x1
            self.field(1),  # 0
        ]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MapToCurveG2(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )

        circuit.set_consts()
        field = circuit.write_elements(input[0:2], WriteOps.INPUT)
        g1x = circuit.write_elements(input[2:4], WriteOps.INPUT)
        div = circuit.write_elements(input[4:6], WriteOps.INPUT)
        num_x1 = circuit.write_elements(input[6:8], WriteOps.INPUT)
        intermediate_values = circuit.compute_initial_coordinates_quadratic(
            field, g1x, div, num_x1
        )

        circuit.extend_output(intermediate_values[0])  # x_affine
        circuit.extend_output(intermediate_values[1])  # y_initial
        circuit.extend_output(intermediate_values[2])  # field
        return circuit


class MapToCurveG2ComputeInitialCoordinatesNonQuadratic(BaseModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0, auto_run: bool = True):
        super().__init__(
            name="map_to_curve_g2_non_quad",
            curve_id=curve_id,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [
            self.field(randint(0, 1000000)),  # field
            self.field(1),  # 0
            self.field(-2),  # g1x
            self.field(-1),  # 0
            self.field(randint(0, 1000000)),  # div
            self.field(1),  # 0
            self.field(randint(0, 1000000)),  # num_x1
            self.field(1),  # 0
            self.field(randint(0, 1000000)),  # zeta_u2
            self.field(1),  # 0
        ]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MapToCurveG2(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )

        circuit.set_consts()
        field = circuit.write_elements(input[0:2], WriteOps.INPUT)
        g1x = circuit.write_elements(input[2:4], WriteOps.INPUT)
        div = circuit.write_elements(input[4:6], WriteOps.INPUT)
        num_x1 = circuit.write_elements(input[6:8], WriteOps.INPUT)
        zeta_u2 = circuit.write_elements(input[8:10], WriteOps.INPUT)
        intermediate_values = circuit.compute_initial_coordinates_non_quadratic(
            field, g1x, div, num_x1, zeta_u2
        )

        circuit.extend_output(intermediate_values[0])  # x_affine
        circuit.extend_output(intermediate_values[1])  # y_initial
        circuit.extend_output(intermediate_values[2])  # field
        return circuit


class MapToCurveG2AdjustYSign(BaseModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0, auto_run: bool = True):
        super().__init__(
            name="map_to_curve_g2_adj_y",
            curve_id=curve_id,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [
            self.field(randint(0, 1000000)),  # field
            self.field(1),  # 0
            self.field(randint(0, 1000000)),  # y_initial
            self.field(1),  # 0
        ]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MapToCurveG2(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )
        circuit.set_consts()
        field = circuit.write_elements(input[0:2], WriteOps.INPUT)
        y_initial = circuit.write_elements(input[2:4], WriteOps.INPUT)

        intermediate_values = circuit.adjust_y_sign(field, y_initial)

        circuit.extend_output(intermediate_values[0])  # y_affine
        circuit.extend_output([intermediate_values[1]])  # qfield
        circuit.extend_output([intermediate_values[2]])  # qy

        return circuit


class IsogenyG2Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0, auto_run: bool = True):
        super().__init__(
            name="isogeny_g2",
            curve_id=curve_id,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [
            self.field(randint(0, 1000000)),
            self.field(0),
            self.field(randint(0, 1000000)),
            self.field(0),
        ]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = IsogenyG2(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )

        px0, px1, py0, py1 = circuit.write_struct(
            structs.G2PointCircuit(name="pt", elmts=input)
        )
        affine_x, affine_y = circuit.run_isogeny([px0, px1], [py0, py1])

        circuit.extend_struct_output(
            structs.G2PointCircuit(
                name="res", elmts=[affine_x[0], affine_x[1], affine_y[0], affine_y[1]]
            )
        )

        return circuit


class AddECPointsG2Circuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        super().__init__(
            f"add_ec_points_g2",
            curve_id,
            auto_run,
            compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        P = G2Point.gen_random_point(CurveID(self.curve_id))
        Q = G2Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(P.x[0]))
        input.append(self.field(P.x[1]))
        input.append(self.field(P.y[0]))
        input.append(self.field(P.y[1]))
        input.append(self.field(Q.x[0]))
        input.append(self.field(Q.x[1]))
        input.append(self.field(Q.y[0]))
        input.append(self.field(Q.y[1]))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = BasicECG2(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )

        px0, px1, py0, py1 = circuit.write_struct(
            structs.G2PointCircuit("p", input[0:4]), WriteOps.INPUT
        )
        qx0, qx1, qy0, qy1 = circuit.write_struct(
            structs.G2PointCircuit("q", input[4:8]), WriteOps.INPUT
        )

        xR, yR = circuit.add_points(([px0, px1], [py0, py1]), ([qx0, qx1], [qy0, qy1]))
        circuit.extend_struct_output(
            structs.G2PointCircuit("r", [xR[0], xR[1], yR[0], yR[1]])
        )

        return circuit


class FastG2CofactorClearingCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, compilation_mode: int = 0, auto_run: bool = True):
        super().__init__(
            "g2_cofactor_clearing",
            curve_id,
            auto_run,
            compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(
            self.field(
                3789617024712504402204306620295003375951143917889162928515122476381982967144814366712031831841518399614182231387665
            )
        )
        input.append(
            self.field(
                1467567314213963969852279817989131104935039564231603908576814773321528757289376676761397368853965316423532584391899
            )
        )
        input.append(
            self.field(
                1292375129422168617658520396283100687686347104559592203462491249161639006037671760603453326853098986903549775136448
            )
        )
        input.append(
            self.field(
                306655960768766438834866368706782505873384691666290681181893693450298456233972904889955517117016529975705729523733
            )
        )
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = FastG2CofactorClearing(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )

        px0, px1, py0, py1 = circuit.write_struct(
            structs.G2PointCircuit("p", input[0:4]), WriteOps.INPUT
        )
        xR, yR = circuit.clear_cofactor(([px0, px1], [py0, py1]))
        circuit.extend_struct_output(
            structs.G2PointCircuit("r", [xR[0], xR[1], yR[0], yR[1]])
        )

        return circuit
