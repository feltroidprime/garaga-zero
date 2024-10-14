%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, UInt384, one_E12D, E12D
from test_utils import load_random_G1G2_pairs
from bn254.multi_pairing_3 import multi_pairing_3P, G1G2Pair

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let n_pairs = 3;
    let curve_id = bn.CURVE_ID;

    let (local inputs: felt*) = load_random_G1G2_pairs(n_pairs, curve_id);

    let (local res: E12D) = multi_pairing_3P(cast(inputs, G1G2Pair*));
    %{
        res = pack_e12d(ids.res, 4, 2**96)
        #print(f"res: {[hex(x) for x in res]}")
        #print(f"expected: {[hex(x) for x in expected_outputs]}\n")
        assert res == expected_outputs, f"res: {res}, expected: {expected_outputs}"
    %}

    %{ print(f"Test MultiPairing for {CurveID(ids.curve_id).name} and {ids.n_pairs} pairs Passed\n") %}
    return ();
}
