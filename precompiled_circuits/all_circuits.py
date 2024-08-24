from enum import Enum

from garaga.definitions import CurveID
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    cairo1_tests_header,
    compilation_mode_to_file_header,
    format_cairo_files_in_parallel,
    to_snake_case,
)
from garaga.precompiled_circuits.compilable_circuits.common_cairo_fustat_circuits import (
    AccumulateEvalPointChallengeSignedCircuit,
    AccumulateFunctionChallengeDuplCircuit,
    AddECPointCircuit,
    DoubleECPointCircuit,
    DummyCircuit,
    EvalFunctionChallengeDuplCircuit,
    FinalizeFunctionChallengeDuplCircuit,
    InitFunctionChallengeDuplCircuit,
    IsOnCurveG1Circuit,
    IsOnCurveG1G2Circuit,
    RHSFinalizeAccCircuit,
    SlopeInterceptSamePointCircuit,
)
from precompiled_circuits.compilable_circuits.fustat_only import (
    DerivePointFromXCircuit,
    FinalExpPart1Circuit,
    FinalExpPart2Circuit,
    FP12MulCircuit,
    MultiMillerLoop,
    MultiPairingCheck,
)


class CircuitID(Enum):
    DUMMY = int.from_bytes(b"dummy", "big")
    FP12_MUL = int.from_bytes(b"fp12_mul", "big")
    FP12_SUB = int.from_bytes(b"fp12_sub", "big")
    FINAL_EXP_PART_1 = int.from_bytes(b"final_exp_part_1", "big")
    FINAL_EXP_PART_2 = int.from_bytes(b"final_exp_part_2", "big")
    MULTI_MILLER_LOOP = int.from_bytes(b"multi_miller_loop", "big")
    MULTI_PAIRING_CHECK = int.from_bytes(b"multi_pairing_check", "big")
    IS_ON_CURVE_G1_G2 = int.from_bytes(b"is_on_curve_g1_g2", "big")
    IS_ON_CURVE_G1 = int.from_bytes(b"is_on_curve_g1", "big")
    IS_ON_CURVE_G2 = int.from_bytes(b"is_on_curve_g2", "big")
    DERIVE_POINT_FROM_X = int.from_bytes(b"derive_point_from_x", "big")
    SLOPE_INTERCEPT_SAME_POINT = int.from_bytes(b"slope_intercept_same_point", "big")
    ACC_EVAL_POINT_CHALLENGE_SIGNED = int.from_bytes(b"acc_eval_point_challenge", "big")
    RHS_FINALIZE_ACC = int.from_bytes(b"rhs_finalize_acc", "big")
    EVAL_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"eval_function_challenge_dupl", "big"
    )
    INIT_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"init_function_challenge_dupl", "big"
    )
    ACC_FUNCTION_CHALLENGE_DUPL = int.from_bytes(b"acc_function_challenge_dupl", "big")
    FINALIZE_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"finalize_function_challenge_dupl", "big"
    )
    ADD_EC_POINT = int.from_bytes(b"add_ec_point", "big")
    DOUBLE_EC_POINT = int.from_bytes(b"double_ec_point", "big")
    MP_CHECK_BIT0_LOOP = int.from_bytes(b"mp_check_bit0_loop", "big")
    MP_CHECK_BIT00_LOOP = int.from_bytes(b"mp_check_bit00_loop", "big")
    MP_CHECK_BIT1_LOOP = int.from_bytes(b"mp_check_bit1_loop", "big")
    MP_CHECK_PREPARE_PAIRS = int.from_bytes(b"mp_check_prepare_pairs", "big")
    MP_CHECK_PREPARE_LAMBDA_ROOT = int.from_bytes(
        b"mp_check_prepare_lambda_root", "big"
    )
    MP_CHECK_INIT_BIT = int.from_bytes(b"mp_check_init_bit", "big")
    MP_CHECK_FINALIZE_BN = int.from_bytes(b"mp_check_finalize_bn", "big")
    MP_CHECK_FINALIZE_BLS = int.from_bytes(b"mp_check_finalize_bls", "big")
    FP12_MUL_ASSERT_ONE = int.from_bytes(b"fp12_mul_assert_one", "big")
    EVAL_E12D = int.from_bytes(b"eval_e12d", "big")


def find_best_circuit_id_from_int(circuit_id: int) -> CircuitID:
    try:
        return CircuitID(circuit_id)
    except ValueError:

        circuit_name = circuit_id.to_bytes(
            (circuit_id.bit_length() + 7) // 8, "big"
        ).decode()

        # print(f"trying to find best circuit id from {circuit_name}")
        best_match = None
        best_score = -1
        for circuit_id in CircuitID:
            score = sum(
                a == b for a, b in zip(circuit_name.lower(), circuit_id.name.lower())
            )
            if score > best_score:
                best_score = score
                best_match = circuit_id
        # print(f"best match = {best_match}")
        return best_match


# All the circuits that are going to be compiled to Cairo Zero.
ALL_FUSTAT_CIRCUITS = {
    CircuitID.DUMMY: {"class": DummyCircuit, "params": None, "filename": "dummy"},
    CircuitID.IS_ON_CURVE_G1_G2: {
        "class": IsOnCurveG1G2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.IS_ON_CURVE_G1: {
        "class": IsOnCurveG1Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DERIVE_POINT_FROM_X: {
        "class": DerivePointFromXCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.SLOPE_INTERCEPT_SAME_POINT: {
        "class": SlopeInterceptSamePointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.ACC_EVAL_POINT_CHALLENGE_SIGNED: {
        "class": AccumulateEvalPointChallengeSignedCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.RHS_FINALIZE_ACC: {
        "class": RHSFinalizeAccCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.EVAL_FUNCTION_CHALLENGE_DUPL: {
        "class": EvalFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [1, 2, 3, 4]],
        "filename": "ec",
    },
    CircuitID.INIT_FUNCTION_CHALLENGE_DUPL: {
        "class": InitFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [5]],
        "filename": "ec",
    },
    CircuitID.ACC_FUNCTION_CHALLENGE_DUPL: {
        "class": AccumulateFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.FINALIZE_FUNCTION_CHALLENGE_DUPL: {
        "class": FinalizeFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.FP12_MUL: {
        "class": FP12MulCircuit,
        "params": None,
        "filename": "extf_mul",
    },
    CircuitID.FINAL_EXP_PART_1: {
        "class": FinalExpPart1Circuit,
        "params": None,
        "filename": "final_exp",
    },
    CircuitID.FINAL_EXP_PART_2: {
        "class": FinalExpPart2Circuit,
        "params": None,
        "filename": "final_exp",
    },
    CircuitID.MULTI_MILLER_LOOP: {
        "class": MultiMillerLoop,
        "params": [{"n_pairs": k} for k in [1, 2, 3]],
        "filename": "multi_miller_loop",
    },
    CircuitID.MULTI_PAIRING_CHECK: {
        "class": MultiPairingCheck,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.ADD_EC_POINT: {
        "class": AddECPointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DOUBLE_EC_POINT: {
        "class": DoubleECPointCircuit,
        "params": None,
        "filename": "ec",
    },
}


def build_selector_function(
    circuit_id: Enum,
    circuit_instances: list[BaseModuloCircuit],
    params: list[dict],
) -> str:

    struct_name = circuit_instances[0].circuit.class_name
    selectors = []
    if circuit_instances[0].circuit.generic_circuit and params is None:
        selectors.append("")
    elif circuit_instances[0].circuit.generic_circuit and params is not None:
        param_name = list(params[0].keys())[0]
        selector_function = f"""
        func get_{circuit_id.name}_circuit(curve_id:felt, {param_name}:felt) -> (circuit:{struct_name}*){{
        tempvar offset = 2 * ({list(params[0].keys())[0]} - 1) + 1;
        jmp rel offset;
        """
        for param in params:
            selector_function += f"""
            jmp circuit_{param[param_name]};
            """

        for circuit_instance, param in zip(circuit_instances, params):
            # print(f"param = {param}, circuit_instance.name = {circuit_instance.name}")
            selector_function += f"""
            circuit_{param[param_name]}:
            let curve_id = [fp - 4];
            return get_{circuit_instance.name.upper()}_circuit(curve_id);
            """
        selector_function += "\n}\n"
        selectors.append(selector_function)
    else:
        if circuit_instances[0].generic_over_curve and params is not None:
            curve_name = CurveID(circuit_instances[0].curve_id).name
            param_name = list(params[0].keys())[0]
            selector_function_curve = f"""
        func get_{circuit_id.name}_circuit(curve_id:felt, {param_name}:felt) -> (circuit:{struct_name}*){{
            if (curve_id == bn.CURVE_ID) {{
                return get_BN254_{circuit_id.name}_circuit({param_name});
            }}
            if (curve_id == bls.CURVE_ID) {{
                return get_BLS12_381_{circuit_id.name}_circuit({param_name});
            }}
            return get_void_{to_snake_case(struct_name)}();
            }}\n
        """
            selectors.append(selector_function_curve)

            param_name = list(params[0].keys())[0]
            selector_function_param = f"""
            func get_{curve_name}_{circuit_id.name}_circuit({param_name}:felt) -> (circuit:{struct_name}*){{
        tempvar offset = 2 * ({list(params[0].keys())[0]} - 1) + 1;
            jmp rel offset;
            """
            for param in params:
                selector_function_param += f"""
            jmp circuit_{param[param_name]};
            """

            for circuit_instance, param in zip(circuit_instances, params):
                # print(
                #     f"param = {param}, circuit_instance.name = {circuit_instance.name}"
                # )
                selector_function_param += f"""
                circuit_{param[param_name]}:
                return get_{CurveID(circuit_instance.curve_id).name}_{circuit_instance.name.upper()}_circuit();
                """
            selector_function_param += "\n}\n"
            selectors.append(selector_function_param)
        else:
            selector_function = f"""
            func get_{circuit_id.name}_circuit(curve_id:felt) -> (circuit:{struct_name}*){{
                if (curve_id == bn.CURVE_ID) {{
                    return get_BN254_{circuit_id.name}_circuit();
                }}
                if (curve_id == bls.CURVE_ID) {{
                    return get_BLS12_381_{circuit_id.name}_circuit();
                }}
                return get_void_{to_snake_case(struct_name)}();
                }}
                """
            selectors.append(selector_function)

    return selectors


def compile_circuit(
    curve_id: CurveID,
    circuit_class: BaseModuloCircuit,
    circuit_id: Enum,
    params: list[dict],
    compilation_mode: int,
) -> tuple[list[str], str]:
    # print(
    #     f"Compiling {curve_id.name}:{circuit_class.__name__} {f'with params {params}' if params else ''}..."
    # )

    circuits: list[BaseModuloCircuit] = []
    compiled_circuits: list[str] = []

    if params is None:
        circuit_instance = circuit_class(
            curve_id=curve_id.value, compilation_mode=compilation_mode
        )
        circuits.append(circuit_instance)
    else:
        for param in params:
            circuit_instance = circuit_class(
                curve_id=curve_id.value, compilation_mode=compilation_mode, **param
            )
            circuits.append(circuit_instance)

    selector_function = build_selector_function(circuit_id, circuits, params)

    for i, circuit_instance in enumerate(circuits):
        function_name = (
            f"{circuit_instance.name.upper()}"
            if circuit_instance.circuit.generic_circuit
            else f"{curve_id.name}_{circuit_instance.name.upper()}"
        )
        compiled_circuit, _ = circuit_instance.circuit.compile_circuit(
            function_name=function_name
        )

        compiled_circuits.append(compiled_circuit)

    return compiled_circuits, selector_function


def main(
    PRECOMPILED_CIRCUITS_DIR: str,
    CIRCUITS_TO_COMPILE: dict[CircuitID, dict],
    compilation_mode: int = 0,
):
    """Compiles and writes all circuits to .cairo files"""

    # Ensure the 'codes' dict keys match the filenames used for file creation.
    # Using sets to remove potential duplicates
    filenames_used = set([v["filename"] for v in CIRCUITS_TO_COMPILE.values()])
    codes = {filename: set() for filename in filenames_used}
    selector_functions = {filename: set() for filename in filenames_used}
    cairo1_tests_functions = {filename: set() for filename in filenames_used}
    cairo1_full_function_names = {filename: set() for filename in filenames_used}

    files = {
        f: open(f"{PRECOMPILED_CIRCUITS_DIR}{f}.cairo", "w") for f in filenames_used
    }

    # Write the header to each file
    HEADER = compilation_mode_to_file_header(compilation_mode)

    for file in files.values():
        file.write(HEADER)

    # Instantiate and compile circuits for each curve

    for circuit_id, circuit_info in CIRCUITS_TO_COMPILE.items():
        for curve_id in circuit_info.get(
            "curve_ids", [CurveID.BN254, CurveID.BLS12_381]
        ):
            filename_key = circuit_info["filename"]
            compiled_circuits, selectors = compile_circuit(
                curve_id,
                circuit_info["class"],
                circuit_id,
                circuit_info["params"],
                compilation_mode,
            )
            codes[filename_key].update(compiled_circuits)
            selector_functions[filename_key].update(selectors)

    # Write selector functions and compiled circuit codes to their respective files
    print(f"Writing circuits and selectors to .cairo files...")
    for filename in filenames_used:
        if filename in files:
            # Write the selector functions for this file
            for selector_function in sorted(selector_functions[filename]):
                files[filename].write(selector_function)
            # Write the compiled circuit codes
            for compiled_circuit in sorted(codes[filename]):
                files[filename].write(compiled_circuit + "\n")

            if compilation_mode == 1:
                files[filename].write(cairo1_tests_header() + "\n")
                fns_to_import = sorted(cairo1_full_function_names[filename])
                if "" in fns_to_import:
                    fns_to_import.remove("")
                files[filename].write(f"use super::{{{','.join(fns_to_import)}}};\n")
                for cairo1_test in sorted(cairo1_tests_functions[filename]):
                    files[filename].write(cairo1_test + "\n")
                files[filename].write("}\n")

        else:
            print(f"Warning: No file associated with filename '{filename}'")

    # Close all files
    for file in files.values():
        file.close()

    format_cairo_files_in_parallel(
        filenames_used, compilation_mode, PRECOMPILED_CIRCUITS_DIR
    )
    return None


if __name__ == "__main__":
    import random

    random.seed(0)

    print(f"Compiling Fustat circuits...")
    main(
        PRECOMPILED_CIRCUITS_DIR="src/precompiled_circuits/",
        CIRCUITS_TO_COMPILE=ALL_FUSTAT_CIRCUITS,
        compilation_mode=0,
    )
