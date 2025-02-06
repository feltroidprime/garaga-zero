%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, G1Point, get_P

from basic_field_ops import (
    add_mod_p,
    sub_mod_p,
    assert_zero_mod_P,
    assert_not_zero_mod_P,
    is_zero_mod_p,
    assert_eq_mod_p,
    assert_neq_mod_p,
    is_eq_mod_p,
    assert_opposite_mod_p,
    assert_not_opposite_mod_p,
    uint384_is_le,
)

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (P) = get_P(0);
    let zero = UInt384(0, 0, 0, 0);
    let four = UInt384(4, 0, 0, 0);
    let eight = UInt384(8, 0, 0, 0);
    let twelve = UInt384(12, 0, 0, 0);
    let (res) = add_mod_p(four, eight, P);

    assert res = twelve;

    let (res) = sub_mod_p(eight, four, P);
    assert res = four;

    assert_zero_mod_P(zero, P);
    assert_not_zero_mod_P(four, P);

    let (true) = is_zero_mod_p(zero, P);
    let (false) = is_zero_mod_p(four, P);

    assert true = 1;
    assert false = 0;

    assert_eq_mod_p(four, four, P);
    assert_neq_mod_p(four, eight, P);

    let (true) = is_eq_mod_p(four, four, P);
    let (false) = is_eq_mod_p(four, eight, P);

    assert true = 1;
    assert false = 0;

    assert_opposite_mod_p(zero, zero, P);

    assert_not_opposite_mod_p(four, eight, P);

    let (true0) = uint384_is_le(four, eight, P);
    let (true1) = uint384_is_le(four, four, P);
    let (false) = uint384_is_le(eight, four, P);

    assert true0 = 1;
    assert true1 = 1;
    assert false = 0;

    return ();
}
