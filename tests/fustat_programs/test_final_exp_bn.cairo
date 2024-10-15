%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, UInt384, N_LIMBS, BASE, E12D
from bn254.final_exp import final_exponentiation

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local input: felt*) = alloc();
    %{
        from random import randint
        import random
        from garaga.definitions import CURVES, PyFelt, CurveID, get_base_field, tower_to_direct, G1Point, G2Point, G1G2Pair
        from garaga.hints.io import bigint_split, flatten, pack_e12d
        random.seed(0)

        curve_id = CurveID(ids.bn.CURVE_ID)
        order = CURVES[curve_id.value].n
        field = get_base_field(curve_id.value)
        pairs = []
        n_pairs = 1
        for _ in range(n_pairs):
            n1, n2 = randint(1, order), randint(1, order)
            p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
            pairs.append(G1G2Pair(p1, p2))

        XT = G1G2Pair.miller(pairs).value_coeffs
        ET = G1G2Pair.pair(pairs).value_coeffs
        XT = [field(x) for x in XT]
        ET = [field(x) for x in ET]
        XD = tower_to_direct(XT, curve_id.value, 12)
        ED = tower_to_direct(ET, curve_id.value, 12)
        inputs = XD
        expected_output = [x.value for x in ED]

        segments.write_arg(ids.input, flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in inputs]))
    %}

    let (local res: E12D) = final_exponentiation(cast(input, E12D*));

    %{
        res = pack_e12d(ids.res, 4, 2**96)
        assert res == expected_output
    %}

    %{ print(f"Test Passed\n") %}
    return ();
}
