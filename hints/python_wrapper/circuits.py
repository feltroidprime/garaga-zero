from garaga.hints.io import bigint_split, flatten
from precompiled_circuits.all_circuits import (
    ALL_FUSTAT_CIRCUITS,
    find_best_circuit_id_from_int,
)


def run_modulo_circuit_hints(
    circuit_input: list[int], N_LIMBS: int, BASE: int, circuit_id: int, curve_id: int
) -> list[int]:
    # print(f"circuit.name = {circuit_id}")
    circuit_id = find_best_circuit_id_from_int(circuit_id)
    # print(f"best_match = {circuit_id.name}")
    MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[circuit_id]["class"](curve_id, auto_run=False)
    MOD_CIRCUIT = MOD_CIRCUIT.run_circuit(circuit_input)

    witnesses = flatten(
        [bigint_split(x.value, N_LIMBS, BASE) for x in MOD_CIRCUIT.witnesses]
    )
    return witnesses


def run_extension_field_modulo_circuit_hints(
    circuit_input: list[int], N_LIMBS: int, BASE: int, circuit_id: int, curve_id: int
) -> tuple[list[int], list[int]]:
    circuit_id = find_best_circuit_id_from_int(circuit_id)
    EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[circuit_id]["class"](
        curve_id, auto_run=False
    )
    EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(circuit_input)

    witnesses = flatten(
        [bigint_split(x.value, N_LIMBS, BASE) for x in EXTF_MOD_CIRCUIT.witnesses]
    )

    commitments = flatten(
        [bigint_split(x.value, N_LIMBS, BASE) for x in EXTF_MOD_CIRCUIT.commitments]
    )

    return witnesses, commitments
