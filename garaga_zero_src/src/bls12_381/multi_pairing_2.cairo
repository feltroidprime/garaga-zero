from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from garaga_zero_src.src.definitions import E12D, E6D, G1G2Pair, TRUE, bls

from garaga_zero_src.src.precompiled_circuits.multi_miller_loop_bls12_381_2 import (
    get_BLS12_381_MULTI_MILLER_LOOP_2_circuit,
)

from garaga_zero_src.src.modulo_circuit import (
    run_extension_field_modulo_circuit,
    run_extension_field_modulo_circuit_continuation,
)
from garaga_zero_src.src.bls12_381.final_exp import final_exponentiation
from garaga_zero_src.src.ec_ops import all_g1_g2_pairs_are_on_curve

func multi_pairing_2P{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: G1G2Pair*) -> (res: E12D) {
    alloc_locals;
    let n_pairs = 2;
    let (all_on_curve) = all_g1_g2_pairs_are_on_curve(input, n_pairs, bls.CURVE_ID);
    assert all_on_curve = TRUE;

    let (m) = multi_miller_loop_2P(cast(input, felt*));

    let (f) = final_exponentiation(m);

    return (res=f);
}

func multi_miller_loop_2P{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: felt*) -> (res: E12D*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (circuit) = get_BLS12_381_MULTI_MILLER_LOOP_2_circuit();
    let (output: felt*, _) = run_extension_field_modulo_circuit(circuit, input);
    return (res=cast(output, E12D*));
}
