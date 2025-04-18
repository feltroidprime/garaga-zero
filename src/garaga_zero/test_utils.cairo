from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.registers import get_fp_and_pc
from garaga_zero.definitions import N_LIMBS, BASE

func load_random_G1G2_pairs(n_pairs: felt, curve_id: felt) -> (pairs: felt*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local inputs: felt*) = alloc();
    let (local expected_outputs: felt*) = alloc();
    %{
        from garaga.definitions import CURVES, PyFelt, CurveID, get_base_field, tower_to_direct, G1Point, G2Point, G1G2Pair
        from garaga.hints.io import bigint_split, flatten, pack_e12d
        import random
        random.seed(0)

        n_pairs = ids.n_pairs
        curve_id = CurveID(ids.curve_id)

        n1s, n2s = [], []
        order = CURVES[curve_id.value].n
        for _ in range(n_pairs):
            n1s.append(random.randint(1, order))
            n2s.append(random.randint(1, order))

        def prepare_inputs_and_expected_outputs(curve_id, n_pairs):
            order = CURVES[curve_id.value].n
            field = get_base_field(curve_id.value)
            pair_list = []
            pairs = []
            for i in range(n_pairs):
                n1, n2 = n1s[i], n2s[i]
                p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
                pair_list.append(G1G2Pair(p1, p2))
                pairs.extend([p1.x, p1.y, p2.x[0], p2.x[1], p2.y[0], p2.y[1]])

            inputs = flatten([bigint_split(x, ids.N_LIMBS, ids.BASE) for x in pairs])
            ET = G1G2Pair.pair(pair_list).value_coeffs
            ET = [field(x) for x in ET]
            ED = tower_to_direct(ET, curve_id.value, 12)

            expected_outputs=[x.value for x in ED]
            return inputs, expected_outputs

        inputs, expected_outputs = prepare_inputs_and_expected_outputs(curve_id, ids.n_pairs)

        segments.write_arg(ids.inputs, inputs)
    %}
    return (inputs,);
}

// Return flattened G1G2Pair list such that Π(P_i, Q_i) = 1
func load_pairing_check_inputs(n_pairs: felt, curve_id: felt) -> (inputs: felt*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local inputs: felt*) = alloc();
    %{
        from garaga.definitions import CURVES, PyFelt, CurveID, get_base_field, tower_to_direct, G1Point, G2Point, G1G2Pair
        from garaga.hints.io import bigint_split, flatten, pack_e12d
        import random
        random.seed(0)
        from garaga.precompiled_circuits.multi_pairing_check import get_pairing_check_input

        curve_id = CurveID(ids.curve_id)
        inputs, _ = get_pairing_check_input(curve_id, ids.n_pairs)
        inputs = flatten([bigint_split(x, ids.N_LIMBS, ids.BASE) for x in inputs])
        segments.write_arg(ids.inputs, inputs)
    %}
    return (inputs,);
}
