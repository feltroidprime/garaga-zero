from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.modulo import run_mod_p_circuit

from garaga_zero.definitions import get_P, BASE, N_LIMBS, is_curve_id_supported, SUPPORTED_CURVE_ID
from garaga_zero.utils import write_felts_to_value_segment, retrieve_output, hash_efelt_transcript

struct ExtensionFieldModuloCircuit {
    constants_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_offsets_ptr: felt*,
    output_offsets_ptr: felt*,
    constants_ptr_len: felt,
    input_len: felt,
    commitments_len: felt,
    big_Q_len: felt,
    witnesses_len: felt,
    output_len: felt,
    continuous_output: felt,
    add_mod_n: felt,
    mul_mod_n: felt,
    n_assert_eq: felt,
    N_Euclidean_equations: felt,
    name: felt,
    curve_id: felt,
}

struct ModuloCircuit {
    constants_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_offsets_ptr: felt*,
    output_offsets_ptr: felt*,
    constants_ptr_len: felt,
    input_len: felt,
    witnesses_len: felt,
    output_len: felt,
    continuous_output: felt,
    add_mod_n: felt,
    mul_mod_n: felt,
    n_assert_eq: felt,
    name: felt,
    curve_id: felt,
}

func get_void_modulo_circuit() -> (circuit: ModuloCircuit*) {
    return (cast(-1, ModuloCircuit*),);
}
func get_void_extension_field_modulo_circuit() -> (circuit: ExtensionFieldModuloCircuit*) {
    return (cast(-1, ExtensionFieldModuloCircuit*),);
}

func run_modulo_circuit{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(circuit: ModuloCircuit*, input: felt*) -> (output: felt*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let p: UInt384 = get_P(circuit.curve_id);
    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(
        dst=range_check96_ptr, src=circuit.constants_ptr, len=circuit.constants_ptr_len * N_LIMBS
    );  // write(Constants)
    memcpy(
        dst=range_check96_ptr + circuit.constants_ptr_len * N_LIMBS,
        src=input,
        len=circuit.input_len,
    );  // write(Input)

    %{
        from precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID, find_best_circuit_id_from_int
        from garaga.hints.io import pack_bigint_ptr, fill_felt_ptr, flatten, bigint_split
        from garaga.definitions import CURVES, PyFelt
        p = CURVES[ids.circuit.curve_id].p
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
        # Convert the int value back to a string and print it
        circuit_name = ids.circuit.name.to_bytes((ids.circuit.name.bit_length() + 7) // 8, 'big').decode()
        #print(f"circuit.name = {circuit_name}")
        circuit_id = find_best_circuit_id_from_int(ids.circuit.name)
        # print(f"best_match = {circuit_id.name}")
        MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[circuit_id]['class'](ids.circuit.curve_id, auto_run=False)
        MOD_CIRCUIT = MOD_CIRCUIT.run_circuit(circuit_input)

        witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in MOD_CIRCUIT.witnesses])

        fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
        #MOD_CIRCUIT.print_value_segment()
    %}

    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=circuit.add_offsets_ptr,
        add_mod_n=circuit.add_mod_n,
        mul_mod_offsets_ptr=circuit.mul_offsets_ptr,
        mul_mod_n=circuit.mul_mod_n,
    );

    tempvar range_check96_ptr = range_check96_ptr + circuit.input_len + circuit.witnesses_len + (
        circuit.constants_ptr_len + circuit.add_mod_n + circuit.mul_mod_n - circuit.n_assert_eq
    ) * N_LIMBS;

    let (output: felt*) = retrieve_output(
        values_segment=values_ptr,
        output_offsets_ptr=circuit.output_offsets_ptr,
        n=circuit.output_len,
        continuous_output=circuit.continuous_output,
    );
    return (output=output);
}

func run_extension_field_modulo_circuit{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(circuit: ExtensionFieldModuloCircuit*, input: felt*) -> (output: felt*, Z: felt) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (status) = is_curve_id_supported(circuit.curve_id);
    if (status != SUPPORTED_CURVE_ID) {
        return (cast(-1, felt*), 0);
    }
    let p: UInt384 = get_P(circuit.curve_id);

    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(
        dst=range_check96_ptr, src=circuit.constants_ptr, len=circuit.constants_ptr_len * N_LIMBS
    );  // write(Constants)

    memcpy(
        dst=range_check96_ptr + circuit.constants_ptr_len * N_LIMBS,
        src=input,
        len=circuit.input_len,
    );  // write(Input)

    %{
        from precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID, find_best_circuit_id_from_int
        from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
        circuit_id = find_best_circuit_id_from_int(ids.circuit.name)
        EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[circuit_id]['class'](ids.circuit.curve_id, auto_run=False)

        EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(circuit_input)
        print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")

        commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
        witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
        fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
        fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
        print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")

        #EXTF_MOD_CIRCUIT.print_value_segment()
    %}

    let n_elmts_to_hash_without_Q = (
        circuit.commitments_len + circuit.input_len - circuit.big_Q_len
    ) / N_LIMBS;
    %{ print(f"n_elmts_to_hash_without_Q = {ids.n_elmts_to_hash_without_Q}") %}

    assert poseidon_ptr[0].input.s0 = circuit.name;
    assert poseidon_ptr[0].input.s1 = 0;
    assert poseidon_ptr[0].input.s2 = 1;

    let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE;

    // The initial state is implicitely set up by the previous permutation just above.
    let (local continuable_hash: felt, local c0: felt, local s2: felt) = hash_efelt_transcript(
        limbs_ptr=cast(values_ptr, felt*) + circuit.constants_ptr_len * N_LIMBS,
        n=n_elmts_to_hash_without_Q,
        curve_id=circuit.curve_id,
    );
    %{ print(f"I C0 CAIRO: {hex(ids.c0)}") %}
    // The intermediate state is already computed by the previous call to hash_efelt_transcript
    // It is (continuable_hash, c0, s2)
    let (local Z: felt, _, _) = hash_efelt_transcript(
        limbs_ptr=cast(values_ptr, felt*) + (
            circuit.constants_ptr_len + n_elmts_to_hash_without_Q
        ) * N_LIMBS,
        n=circuit.big_Q_len / N_LIMBS,
        curve_id=circuit.curve_id,
    );
    // let (local Z: felt, local RLC_coeffs: felt*) = get_Z_and_RLC_from_transcript(
    //     transcript_start=cast(values_ptr, felt*) + circuit.constants_ptr_len * N_LIMBS,
    //     poseidon_indexes_ptr=circuit.poseidon_indexes_ptr,
    //     n_elements_in_transcript=(circuit.commitments_len + circuit.input_len) / N_LIMBS,
    //     n_equations=circuit.N_Euclidean_equations,
    //     init_hash=circuit.name,
    //     curve_id=circuit.curve_id,
    // );
    %{ print(f"\tZ = Hash(Input|Commitments) = Poseidon({(ids.circuit.input_len+ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384]) computed") %}
    %{ print(f"\tN={ids.circuit.N_Euclidean_equations} felt252 from Poseidon transcript retrieved.") %}

    %{
        # Sanity Check :
        assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"
    %}

    tempvar range_check96_ptr = range_check96_ptr + circuit.constants_ptr_len * N_LIMBS +
        circuit.input_len + circuit.commitments_len + circuit.witnesses_len;

    write_felts_to_value_segment(values_start=&c0, n=1);
    write_felts_to_value_segment(values_start=&Z, n=1);
    %{ print(f"\tbase random coeff c0&Z written to value segment") %}
    %{ print(f"\tRunning ModuloBuiltin circuit...") %}
    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=circuit.add_offsets_ptr,
        add_mod_n=circuit.add_mod_n,
        mul_mod_offsets_ptr=circuit.mul_offsets_ptr,
        mul_mod_n=circuit.mul_mod_n,
    );

    tempvar range_check96_ptr = range_check96_ptr + (
        circuit.add_mod_n + circuit.mul_mod_n - circuit.n_assert_eq
    ) * N_LIMBS;

    let (output: felt*) = retrieve_output(
        values_segment=values_ptr,
        output_offsets_ptr=circuit.output_offsets_ptr,
        n=circuit.output_len,
        continuous_output=circuit.continuous_output,
    );
    return (output=output, Z=Z);
}

// Same as run_modulo_circuit, but doesen't hash the inputs and starts with
// an initial hash.
func run_extension_field_modulo_circuit_continuation{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(circuit: ExtensionFieldModuloCircuit*, input: felt*, init_hash: felt) -> (
    output: felt*, Z: felt
) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (status) = is_curve_id_supported(circuit.curve_id);
    if (status != SUPPORTED_CURVE_ID) {
        return (cast(-1, felt*), 0);
    }
    let p: UInt384 = get_P(circuit.curve_id);

    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(
        dst=range_check96_ptr, src=circuit.constants_ptr, len=circuit.constants_ptr_len * N_LIMBS
    );  // write(Constants)

    memcpy(
        dst=range_check96_ptr + circuit.constants_ptr_len * N_LIMBS,
        src=input,
        len=circuit.input_len,
    );  // write(Input)

    %{
        from precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID, find_best_circuit_id_from_int
        from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
        circuit_id = find_best_circuit_id_from_int(ids.circuit.name)
        EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[circuit_id]['class'](ids.circuit.curve_id, auto_run=False, init_hash=ids.init_hash)

        EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(input=circuit_input)
        print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")

        commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
        witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
        fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
        fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
        # print(f"continuation segment:, init_hash={hex(ids.init_hash)}")
        #EXTF_MOD_CIRCUIT.print_value_segment()
        print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")
    %}

    %{ print(f"\tZ = Hash(Init_Hash|Commitments) = Poseidon(Init_Hash, Poseidon({(ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384])) computed") %}

    let n_elmts_to_hash_without_Q = (circuit.commitments_len - circuit.big_Q_len) / N_LIMBS;

    assert poseidon_ptr[0].input.s0 = init_hash;
    assert poseidon_ptr[0].input.s1 = 0;
    assert poseidon_ptr[0].input.s2 = 1;

    let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE;

    // The initial state is implicitely set up by the previous permutation.

    let start_hash_at = cast(values_ptr, felt*) + circuit.constants_ptr_len * N_LIMBS +
        circuit.input_len;

    let (local continuable_hash: felt, local c0: felt, local s2: felt) = hash_efelt_transcript(
        limbs_ptr=start_hash_at, n=n_elmts_to_hash_without_Q, curve_id=circuit.curve_id
    );
    %{ print(f"II C0 CAIRO: {hex(ids.c0)}") %}
    // The intermediate state is already computed by the previous call to hash_efelt_transcript
    // It is (continuable_hash, c0, s2)
    let (local Z: felt, _, _) = hash_efelt_transcript(
        limbs_ptr=start_hash_at + n_elmts_to_hash_without_Q * N_LIMBS,
        n=circuit.big_Q_len / N_LIMBS,
        curve_id=circuit.curve_id,
    );

    %{
        # Sanity Check :
        assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"
    %}

    tempvar range_check96_ptr = range_check96_ptr + circuit.constants_ptr_len * N_LIMBS +
        circuit.input_len + circuit.commitments_len + circuit.witnesses_len;

    write_felts_to_value_segment(values_start=&c0, n=1);
    write_felts_to_value_segment(values_start=&Z, n=1);
    %{ print(f"\tbase random coeff c0&Z written to value segment") %}
    %{ print(f"\tRunning ModuloBuiltin circuit...") %}
    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=circuit.add_offsets_ptr,
        add_mod_n=circuit.add_mod_n,
        mul_mod_offsets_ptr=circuit.mul_offsets_ptr,
        mul_mod_n=circuit.mul_mod_n,
    );
    tempvar range_check96_ptr = range_check96_ptr + (
        circuit.add_mod_n + circuit.mul_mod_n - circuit.n_assert_eq
    ) * N_LIMBS;

    let (output: felt*) = retrieve_output(
        values_segment=values_ptr,
        output_offsets_ptr=circuit.output_offsets_ptr,
        n=circuit.output_len,
        continuous_output=circuit.continuous_output,
    );
    return (output=output, Z=Z);
}
