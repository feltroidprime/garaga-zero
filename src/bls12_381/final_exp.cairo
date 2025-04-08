from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from definitions import E12D, E6D, is_zero_E6D, one_E6D, one_E12D, bls, TRUE, FALSE

from precompiled_circuits.final_exp_part_1_bls12_381 import get_BLS12_381_FINAL_EXP_PART_1_circuit
from precompiled_circuits.final_exp_part_2_bls12_381 import get_BLS12_381_FINAL_EXP_PART_2_circuit

from modulo_circuit import (
    run_extension_field_modulo_circuit,
    run_extension_field_modulo_circuit_continuation,
)
func final_exponentiation{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: E12D*) -> (res: E12D) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local num: E6D = E6D(
        v0=input.w0, v1=input.w2, v2=input.w4, v3=input.w6, v4=input.w8, v5=input.w10
    );
    local den: E6D = E6D(
        v0=input.w1, v1=input.w3, v2=input.w5, v3=input.w7, v4=input.w9, v5=input.w11
    );
    let (local circuit_input: felt*) = alloc();

    let (num_is_zero) = is_zero_E6D(num, bls.CURVE_ID);
    if (num_is_zero == TRUE) {
        let (one_E12: E12D) = one_E12D();
        return (res=one_E12);
    } else {
        memcpy(dst=circuit_input, src=cast(&num, felt*), len=24);
    }

    let (den_is_zero) = is_zero_E6D(den, bls.CURVE_ID);
    if (den_is_zero == TRUE) {
        let (local one_E6: E6D) = one_E6D();
        memcpy(dst=circuit_input + 24, src=cast(&one_E6, felt*), len=24);
    } else {
        memcpy(dst=circuit_input + 24, src=cast(&den, felt*), len=24);
    }

    let (local circuit) = get_BLS12_381_FINAL_EXP_PART_1_circuit();
    let (output: felt*, Z: felt) = run_extension_field_modulo_circuit(circuit, circuit_input);
    // %{
    //     part1 = pack_bigint_ptr(memory, ids.output, 4, 2**96, ids.circuit.output_len//4)
    //     for x in part1:
    //         print(f"T0/T2/_SUM = {hex(x)}")
    // %}
    let _sum = [cast(output + 2 * E6D.SIZE, E6D*)];
    let (_sum_is_zero) = is_zero_E6D(_sum, bls.CURVE_ID);

    if (_sum_is_zero == FALSE) {
        if (den_is_zero == FALSE) {
            let (circuit) = get_BLS12_381_FINAL_EXP_PART_2_circuit();
            let (output: felt*, _: felt) = run_extension_field_modulo_circuit_continuation(
                circuit, output, Z
            );
            return (res=[cast(output, E12D*)]);
        } else {
            let (one_E12: E12D) = one_E12D();
            return (res=one_E12);
        }
    } else {
        let (one_E12: E12D) = one_E12D();
        return (res=one_E12);
    }
}
