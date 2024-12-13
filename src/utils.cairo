from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.uint256 import Uint256
from definitions import STARK_MIN_ONE_D2, N_LIMBS, BASE, bls, UInt384, get_min_one
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from starkware.cairo.common.math import assert_le_felt

// Continue sponge construction from the latest poseidon builin state for an array of UInt384.
func hash_efelt_transcript{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt, curve_id: felt
) -> (_s0: felt, _s1: felt, _s2: felt) {
    if (curve_id == bls.CURVE_ID) {
        let (_s0, _s1, _s2) = hash_full_transcript_and_get_Z_4_LIMBS(limbs_ptr, n);
        return (_s0, _s1, _s2);
    } else {
        let (_s0, _s1, _s2) = hash_full_transcript_and_get_Z_3_LIMBS(limbs_ptr, n);
        return (_s0, _s1, _s2);
    }
}
func hash_full_transcript_and_get_Z_3_LIMBS{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt
) -> (_s0: felt, _s1: felt, _s2: felt) {
    alloc_locals;
    local BASE = 2 ** 96;
    // %{
    //     from garaga.hints.io import pack_bigint_ptr
    //     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
    //     for e in to_hash:
    //         print(f"Will Hash {hex(e)}")
    // %}

    let elements_end = &limbs_ptr[n * N_LIMBS];

    tempvar elements = limbs_ptr;
    tempvar pos_ptr = cast(poseidon_ptr, felt*);

    loop:
    if (nondet %{ ids.elements_end - ids.elements >= 6*ids.N_LIMBS %} != 0) {
        // %{
        //     from garaga.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 6)
        //     for e in to_hash:
        //         print(f"\t Will Hash {hex(e)}")
        // %}

        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        assert [pos_ptr + 6] = [pos_ptr + 3] + elements[4] + (BASE) * elements[5];
        assert [pos_ptr + 7] = [pos_ptr + 4] + elements[6];
        assert [pos_ptr + 8] = [pos_ptr + 5];

        assert [pos_ptr + 12] = [pos_ptr + 9] + elements[8] + (BASE) * elements[9];
        assert [pos_ptr + 13] = [pos_ptr + 10] + elements[10];
        assert [pos_ptr + 14] = [pos_ptr + 11];

        assert [pos_ptr + 18] = [pos_ptr + 15] + elements[12] + (BASE) * elements[13];
        assert [pos_ptr + 19] = [pos_ptr + 16] + elements[14];
        assert [pos_ptr + 20] = [pos_ptr + 17];

        assert [pos_ptr + 24] = [pos_ptr + 21] + elements[16] + (BASE) * elements[17];
        assert [pos_ptr + 25] = [pos_ptr + 22] + elements[18];
        assert [pos_ptr + 26] = [pos_ptr + 23];

        assert [pos_ptr + 30] = [pos_ptr + 27] + elements[20] + (BASE) * elements[21];
        assert [pos_ptr + 31] = [pos_ptr + 28] + elements[22];
        assert [pos_ptr + 32] = [pos_ptr + 29];

        let pos_ptr = pos_ptr + 6 * PoseidonBuiltin.SIZE;
        tempvar elements = &elements[6 * N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    if (nondet %{ ids.elements_end - ids.elements >= ids.N_LIMBS %} != 0) {
        // %{
        //     from garaga.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
        //     for e in to_hash:
        //         print(f"\t\t Will Hash {e}")
        // %}
        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        let pos_ptr = pos_ptr + PoseidonBuiltin.SIZE;

        tempvar elements = &elements[N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    assert cast(elements_end, felt) = cast(elements, felt);

    tempvar poseidon_ptr = poseidon_ptr + n * PoseidonBuiltin.SIZE;
    let res_ptr = poseidon_ptr - PoseidonBuiltin.SIZE;
    tempvar s0 = [res_ptr].output.s0;
    tempvar s1 = [res_ptr].output.s1;
    tempvar s2 = [res_ptr].output.s2;
    return (_s0=s0, _s1=s1, _s2=s2);
}

func hash_full_transcript_and_get_Z_4_LIMBS{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt
) -> (_s0: felt, _s1: felt, _s2: felt) {
    alloc_locals;
    local BASE = 2 ** 96;
    // %{
    //     from garaga.hints.io import pack_bigint_ptr
    //     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
    //     for e in to_hash:
    //         print(f"Will Hash {hex(e)}")
    // %}
    let elements_end = &limbs_ptr[n * N_LIMBS];

    tempvar elements = limbs_ptr;
    tempvar pos_ptr = cast(poseidon_ptr, felt*);

    loop:
    if (nondet %{ ids.elements_end - ids.elements >= 6*ids.N_LIMBS %} != 0) {
        // %{
        //     from garaga.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 6)
        //     for e in to_hash:
        //         print(f"\t Will Hash {hex(e)}")
        // %}

        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2] + (BASE) * elements[3];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        assert [pos_ptr + 6] = [pos_ptr + 3] + elements[4] + (BASE) * elements[5];
        assert [pos_ptr + 7] = [pos_ptr + 4] + elements[6] + (BASE) * elements[7];
        assert [pos_ptr + 8] = [pos_ptr + 5];

        assert [pos_ptr + 12] = [pos_ptr + 9] + elements[8] + (BASE) * elements[9];
        assert [pos_ptr + 13] = [pos_ptr + 10] + elements[10] + (BASE) * elements[11];
        assert [pos_ptr + 14] = [pos_ptr + 11];

        assert [pos_ptr + 18] = [pos_ptr + 15] + elements[12] + (BASE) * elements[13];
        assert [pos_ptr + 19] = [pos_ptr + 16] + elements[14] + (BASE) * elements[15];
        assert [pos_ptr + 20] = [pos_ptr + 17];

        assert [pos_ptr + 24] = [pos_ptr + 21] + elements[16] + (BASE) * elements[17];
        assert [pos_ptr + 25] = [pos_ptr + 22] + elements[18] + (BASE) * elements[19];
        assert [pos_ptr + 26] = [pos_ptr + 23];

        assert [pos_ptr + 30] = [pos_ptr + 27] + elements[20] + (BASE) * elements[21];
        assert [pos_ptr + 31] = [pos_ptr + 28] + elements[22] + (BASE) * elements[23];
        assert [pos_ptr + 32] = [pos_ptr + 29];

        let pos_ptr = pos_ptr + 6 * PoseidonBuiltin.SIZE;
        tempvar elements = &elements[6 * N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    if (nondet %{ ids.elements_end - ids.elements >= ids.N_LIMBS %} != 0) {
        // %{
        //     from garaga.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
        //     for e in to_hash:
        //         print(f"\t\t Will Hash {hex(e)}")
        // %}
        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2] + (BASE) * elements[3];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        let pos_ptr = pos_ptr + PoseidonBuiltin.SIZE;

        tempvar elements = &elements[N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    assert cast(elements_end, felt) = cast(elements, felt);

    tempvar poseidon_ptr = poseidon_ptr + n * PoseidonBuiltin.SIZE;
    tempvar res_ptr = poseidon_ptr - PoseidonBuiltin.SIZE;
    tempvar s0 = [res_ptr].output.s0;
    tempvar s1 = [res_ptr].output.s1;
    tempvar s2 = [res_ptr].output.s2;
    // %{ print(f"res {hex(ids.res)}") %}
    return (_s0=s0, _s1=s1, _s2=s2);
}

// Decompose n felt252 into n valid UInt384 and write them to the value segment.
func write_felts_to_value_segment{range_check96_ptr: felt*}(values_start: felt*, n: felt) -> () {
    alloc_locals;
    local stark_min_1_d2 = STARK_MIN_ONE_D2;
    local n_rc_per_felt = N_LIMBS + 1;

    %{ i=0 %}
    tempvar values = values_start;
    tempvar rc_96_ptr = range_check96_ptr;

    loop:
    let values = cast([ap - 2], felt*);
    let rc_96_ptr = cast([ap - 1], felt*);
    %{
        memory[ap] = 1 if i == ids.n else 0
        i+=1
    %}
    jmp end if [ap] != 0, ap++;

    let d0 = [rc_96_ptr];
    let d1 = [rc_96_ptr + 1];
    let d2 = [rc_96_ptr + 2];
    %{
        from garaga.hints.io import bigint_split
        felt_val = memory[ids.values_start+i-1]
        limbs = bigint_split(felt_val, ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]
    %}
    assert [rc_96_ptr + 3] = 0;
    assert [rc_96_ptr + 4] = stark_min_1_d2 - d2;
    assert [values] = (d0 + d1 * BASE + d2 * BASE ** 2);
    if (d2 == stark_min_1_d2) {
        // Take advantage of Cairo prime structure. STARK_MIN_ONE = 0 + 0 * BASE + stark_min_1_d2 * (BASE)**2.
        assert d0 = 0;
        assert d1 = 0;
        [ap] = values + 1, ap++;
        [ap] = rc_96_ptr + n_rc_per_felt, ap++;
    } else {
        [ap] = values + 1, ap++;
        [ap] = rc_96_ptr + n_rc_per_felt, ap++;
    }
    jmp loop;

    end:
    assert n = cast(values, felt) - cast(values_start, felt);
    tempvar range_check96_ptr = rc_96_ptr;

    return ();
}

func felt_to_UInt384{range_check96_ptr: felt*}(x: felt) -> (res: UInt384) {
    let d0 = [range_check96_ptr];
    let d1 = [range_check96_ptr + 1];
    let d2 = [range_check96_ptr + 2];
    %{
        from garaga.hints.io import bigint_split
        limbs = bigint_split(ids.x, ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]
    %}
    assert [range_check96_ptr + 3] = STARK_MIN_ONE_D2 - d2;
    assert x = d0 + d1 * BASE + d2 * BASE ** 2;
    if (d2 == STARK_MIN_ONE_D2) {
        // Take advantage of Cairo prime structure. STARK_MIN_ONE = 0 + 0 * BASE + stark_min_1_d2 * (BASE)**2.
        assert d0 = 0;
        assert d1 = 0;
        tempvar range_check96_ptr = range_check96_ptr + 4;
        return (res=UInt384(d0, d1, d2, 0));
    } else {
        tempvar range_check96_ptr = range_check96_ptr + 4;
        return (res=UInt384(d0, d1, d2, 0));
    }
}

func sign_to_UInt384(sign: felt, curve_id: felt) -> (res: UInt384) {
    if (sign == -1) {
        return get_min_one(curve_id);
    } else {
        return (res=UInt384(1, 0, 0, 0));
    }
}

func retrieve_output{}(
    values_segment: felt*, output_offsets_ptr: felt*, n: felt, continuous_output: felt
) -> (output: felt*) {
    if (continuous_output != 0) {
        let offset = output_offsets_ptr[0];
        // %{ print(f"Continuous output! start value : {hex(memory[ids.values_segment + ids.offset])} Size: {ids.n//4} offset:{ids.offset}") %}
        return (cast(values_segment + offset, felt*),);
    }
    alloc_locals;
    let (local output: felt*) = alloc();
    local one = 1;
    local two = 2;
    local three = 3;

    tempvar i = 0;
    tempvar output_offsets = output_offsets_ptr;

    loop:
    let i = [ap - 2];
    let output_offsets = cast([ap - 1], felt*);
    %{
        index = memory[ids.output_offsets_ptr+ids.i]
        # print(f"Output {ids.i}/{ids.n} Index : {index}")
        memory[ap] = 1 if ids.i == ids.n else 0
    %}
    jmp end if [ap] != 0, ap++;

    tempvar i_plus_one = i + one;
    tempvar i_plus_two = i + two;
    tempvar i_plus_three = i + three;

    assert output[i] = values_segment[[output_offsets]];
    assert output[i_plus_one] = values_segment[[output_offsets] + one];
    assert output[i_plus_two] = values_segment[[output_offsets] + two];
    assert output[i_plus_three] = values_segment[[output_offsets] + three];

    [ap] = i + 4, ap++;
    [ap] = output_offsets + 1, ap++;
    jmp loop;

    end:
    assert i = n;
    return (output=output);
}

func scalars_to_epns_low_high{range_check_ptr}(scalars: Uint256*, n: felt, neg_3_pow: felt*) -> (
    epns_low: felt*, epns_high: felt*
) {
    alloc_locals;
    let (local epns_low: felt*) = alloc();
    let (local epns_high: felt*) = alloc();

    scalars_to_epns_low_high_inner(scalars, 0, n, neg_3_pow, epns_low, epns_high);
    return (epns_low, epns_high);
}

func scalars_to_epns_low_high_inner{range_check_ptr}(
    scalars: Uint256*, index: felt, n: felt, neg_3_pow: felt*, epns_low: felt*, epns_high: felt*
) {
    alloc_locals;

    if (index == n) {
        return ();
    } else {
        let (epi_low, eni_low, p_sign_low, n_sign_low) = scalar_to_base_neg3_le(
            scalars[index].low, neg_3_pow
        );
        let (epi_high, eni_high, p_sign_high, n_sign_high) = scalar_to_base_neg3_le(
            scalars[index].high, neg_3_pow
        );
        assert [epns_low] = epi_low;
        assert [epns_low + 1] = eni_low;
        assert [epns_low + 2] = p_sign_low;
        assert [epns_low + 3] = n_sign_low;
        assert [epns_high] = epi_high;
        assert [epns_high + 1] = eni_high;
        assert [epns_high + 2] = p_sign_high;
        assert [epns_high + 3] = n_sign_high;
        return scalars_to_epns_low_high_inner(
            scalars, index + 1, n, neg_3_pow, epns_low + 4, epns_high + 4
        );
    }
}

// Returns the sign of value: -1 if value < 0, 1 if value > 0.
// value is considered positive if it is in [0, STARK//2[
// value is considered negative if it is in ]STARK//2, STARK[
// If value == 0, returned value can be either 0 or 1 (undetermined).
func sign{range_check_ptr}(value) -> felt {
    const STARK_DIV_2_PLUS_ONE = (-1) / 2 + 1;  // == prime//2 + 1
    const STARK_DIV_2_MIN_ONE = (-1) / 2 - 1;  // == prime//2 - 1
    tempvar is_positive: felt;
    %{
        from starkware.cairo.common.math_utils import as_int
        ids.is_positive = 1 if as_int(ids.value, PRIME) >= 0 else 0
    %}
    if (is_positive != 0) {
        assert_le_felt(value, STARK_DIV_2_MIN_ONE);
        return 1;
    } else {
        assert_le_felt(STARK_DIV_2_PLUS_ONE, value);
        return -1;
    }
}

// From a 128 bit scalar, decomposes it into base (-3) such that
// scalar = sum(digits[i] * (-3)^i for i in [0, 81])
// scalar = sum_p - sum_n
// Where sum_p = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==1)
// And sum_n = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==-1)
// Returns (abs(sum_p), abs(sum_n), p_sign, n_sign)
func scalar_to_base_neg3_le{range_check_ptr}(scalar: felt, neg_3_pow: felt*) -> (
    sum_p: felt, sum_n: felt, p_sign: felt, n_sign: felt
) {
    alloc_locals;
    let (local digits: felt*) = alloc();
    %{
        from garaga.hints.neg_3 import neg_3_base_le, positive_negative_multiplicities
        assert 0 <= ids.scalar < 2**128
        digits = neg_3_base_le(ids.scalar)
        digits = digits + [0] * (82-len(digits))
        segments.write_arg(ids.digits, digits)
    %}
    let sum_p = 0;
    let sum_n = 0;
    if (digits[0] != 0) {
        if (digits[0] == 1) {
            tempvar sum_p = 1;
            tempvar sum_n = sum_n;
            tempvar i = 1;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = 1;
            tempvar i = 1;
        }
    } else {
        tempvar sum_p = sum_p;
        tempvar sum_n = sum_n;
        tempvar i = 1;
    }

    loop:
    let i = [ap - 1];
    let sum_n = [ap - 2];
    let sum_p = [ap - 3];
    %{ memory[ap] = 1 if ids.i == 82 else 0 %}
    jmp end if [ap] != 0, ap++;
    // %{
    //     print(f"{memory[ids.digits+ids.i]=}")
    //     print(f"\t {ids.sum_p=}")
    //     print(f"\t {ids.sum_n=}")
    // %}
    if (digits[i] != 0) {
        tempvar pow = neg_3_pow[i];
        if (digits[i] == 1) {
            tempvar sum_p = sum_p + pow;
            tempvar sum_n = sum_n;
            tempvar i = i + 1;
            jmp loop;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + pow;
            tempvar i = i + 1;
            jmp loop;
        }
    } else {
        tempvar sum_p = sum_p;
        tempvar sum_n = sum_n;
        tempvar i = i + 1;
        jmp loop;
    }

    end:
    let i = [ap - 2];
    let sum_n = [ap - 3];
    let sum_p = [ap - 4];
    assert i = 82;

    // %{
    //     from starkware.cairo.common.math_utils import as_int
    //     print(f"{as_int(ids.sum_p, PRIME)=}")
    //     print(f"{as_int(ids.sum_n, PRIME)=}")
    // %}
    assert scalar = sum_p - sum_n;

    let p_sign = sign(sum_p);
    let n_sign = sign(sum_n);

    return (p_sign * sum_p, n_sign * sum_n, p_sign, n_sign);
}

struct Neg3Digits {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
    d4: felt,
    d5: felt,
    d6: felt,
    d7: felt,
    d8: felt,
    d9: felt,
    d10: felt,
    d11: felt,
    d12: felt,
    d13: felt,
    d14: felt,
    d15: felt,
    d16: felt,
    d17: felt,
    d18: felt,
    d19: felt,
    d20: felt,
    d21: felt,
    d22: felt,
    d23: felt,
    d24: felt,
    d25: felt,
    d26: felt,
    d27: felt,
    d28: felt,
    d29: felt,
    d30: felt,
    d31: felt,
    d32: felt,
    d33: felt,
    d34: felt,
    d35: felt,
    d36: felt,
    d37: felt,
    d38: felt,
    d39: felt,
    d40: felt,
    d41: felt,
    d42: felt,
    d43: felt,
    d44: felt,
    d45: felt,
    d46: felt,
    d47: felt,
    d48: felt,
    d49: felt,
    d50: felt,
    d51: felt,
    d52: felt,
    d53: felt,
    d54: felt,
    d55: felt,
    d56: felt,
    d57: felt,
    d58: felt,
    d59: felt,
    d60: felt,
    d61: felt,
    d62: felt,
    d63: felt,
    d64: felt,
    d65: felt,
    d66: felt,
    d67: felt,
    d68: felt,
    d69: felt,
    d70: felt,
    d71: felt,
    d72: felt,
    d73: felt,
    d74: felt,
    d75: felt,
    d76: felt,
    d77: felt,
    d78: felt,
    d79: felt,
    d80: felt,
    d81: felt,
}

func scalar_to_epns{range_check_ptr}(scalar: felt) -> (
    sum_p: felt, sum_n: felt, p_sign: felt, n_sign: felt
) {
    alloc_locals;
    local digits: Neg3Digits;

    %{
        from garaga.hints.neg_3 import neg_3_base_le, positive_negative_multiplicities

        digits = neg_3_base_le(ids.scalar)
        digits = digits + [0] * (82-len(digits))
        for i in range(82):
            setattr(ids.digits, f"d{i}", digits[i])
    %}

    if (digits.d0 != 0) {
        if (digits.d0 == 1) {
            tempvar sum_p = 1;
            tempvar sum_n = 0;
        } else {
            tempvar sum_p = 0;
            tempvar sum_n = 1;
        }
    } else {
        tempvar sum_p = 0;
        tempvar sum_n = 0;
    }

    if (digits.d1 != 0) {
        if (digits.d1 == 1) {
            tempvar sum_p = sum_p + (-3);
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3);
        }
    }

    if (digits.d2 != 0) {
        if (digits.d2 == 1) {
            tempvar sum_p = sum_p + (-3) ** 2;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 2;
        }
    }

    if (digits.d3 != 0) {
        if (digits.d3 == 1) {
            tempvar sum_p = sum_p + (-3) ** 3;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 3;
        }
    }
    if (digits.d4 != 0) {
        if (digits.d4 == 1) {
            tempvar sum_p = sum_p + (-3) ** 4;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 4;
        }
    }
    if (digits.d5 != 0) {
        if (digits.d5 == 1) {
            tempvar sum_p = sum_p + (-3) ** 5;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 5;
        }
    }
    if (digits.d6 != 0) {
        if (digits.d6 == 1) {
            tempvar sum_p = sum_p + (-3) ** 6;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 6;
        }
    }
    if (digits.d7 != 0) {
        if (digits.d7 == 1) {
            tempvar sum_p = sum_p + (-3) ** 7;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 7;
        }
    }
    if (digits.d8 != 0) {
        if (digits.d8 == 1) {
            tempvar sum_p = sum_p + (-3) ** 8;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 8;
        }
    }
    if (digits.d9 != 0) {
        if (digits.d9 == 1) {
            tempvar sum_p = sum_p + (-3) ** 9;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 9;
        }
    }
    if (digits.d10 != 0) {
        if (digits.d10 == 1) {
            tempvar sum_p = sum_p + (-3) ** 10;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 10;
        }
    }
    if (digits.d11 != 0) {
        if (digits.d11 == 1) {
            tempvar sum_p = sum_p + (-3) ** 11;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 11;
        }
    }
    if (digits.d12 != 0) {
        if (digits.d12 == 1) {
            tempvar sum_p = sum_p + (-3) ** 12;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 12;
        }
    }
    if (digits.d13 != 0) {
        if (digits.d13 == 1) {
            tempvar sum_p = sum_p + (-3) ** 13;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 13;
        }
    }
    if (digits.d14 != 0) {
        if (digits.d14 == 1) {
            tempvar sum_p = sum_p + (-3) ** 14;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 14;
        }
    }
    if (digits.d15 != 0) {
        if (digits.d15 == 1) {
            tempvar sum_p = sum_p + (-3) ** 15;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 15;
        }
    }
    if (digits.d16 != 0) {
        if (digits.d16 == 1) {
            tempvar sum_p = sum_p + (-3) ** 16;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 16;
        }
    }
    if (digits.d17 != 0) {
        if (digits.d17 == 1) {
            tempvar sum_p = sum_p + (-3) ** 17;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 17;
        }
    }
    if (digits.d18 != 0) {
        if (digits.d18 == 1) {
            tempvar sum_p = sum_p + (-3) ** 18;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 18;
        }
    }
    if (digits.d19 != 0) {
        if (digits.d19 == 1) {
            tempvar sum_p = sum_p + (-3) ** 19;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 19;
        }
    }
    if (digits.d20 != 0) {
        if (digits.d20 == 1) {
            tempvar sum_p = sum_p + (-3) ** 20;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 20;
        }
    }
    if (digits.d21 != 0) {
        if (digits.d21 == 1) {
            tempvar sum_p = sum_p + (-3) ** 21;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 21;
        }
    }
    if (digits.d22 != 0) {
        if (digits.d22 == 1) {
            tempvar sum_p = sum_p + (-3) ** 22;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 22;
        }
    }
    if (digits.d23 != 0) {
        if (digits.d23 == 1) {
            tempvar sum_p = sum_p + (-3) ** 23;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 23;
        }
    }
    if (digits.d24 != 0) {
        if (digits.d24 == 1) {
            tempvar sum_p = sum_p + (-3) ** 24;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 24;
        }
    }
    if (digits.d25 != 0) {
        if (digits.d25 == 1) {
            tempvar sum_p = sum_p + (-3) ** 25;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 25;
        }
    }
    if (digits.d26 != 0) {
        if (digits.d26 == 1) {
            tempvar sum_p = sum_p + (-3) ** 26;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 26;
        }
    }
    if (digits.d27 != 0) {
        if (digits.d27 == 1) {
            tempvar sum_p = sum_p + (-3) ** 27;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 27;
        }
    }
    if (digits.d28 != 0) {
        if (digits.d28 == 1) {
            tempvar sum_p = sum_p + (-3) ** 28;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 28;
        }
    }
    if (digits.d29 != 0) {
        if (digits.d29 == 1) {
            tempvar sum_p = sum_p + (-3) ** 29;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 29;
        }
    }
    if (digits.d30 != 0) {
        if (digits.d30 == 1) {
            tempvar sum_p = sum_p + (-3) ** 30;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 30;
        }
    }
    if (digits.d31 != 0) {
        if (digits.d31 == 1) {
            tempvar sum_p = sum_p + (-3) ** 31;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 31;
        }
    }
    if (digits.d32 != 0) {
        if (digits.d32 == 1) {
            tempvar sum_p = sum_p + (-3) ** 32;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 32;
        }
    }
    if (digits.d33 != 0) {
        if (digits.d33 == 1) {
            tempvar sum_p = sum_p + (-3) ** 33;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 33;
        }
    }
    if (digits.d34 != 0) {
        if (digits.d34 == 1) {
            tempvar sum_p = sum_p + (-3) ** 34;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 34;
        }
    }
    if (digits.d35 != 0) {
        if (digits.d35 == 1) {
            tempvar sum_p = sum_p + (-3) ** 35;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 35;
        }
    }
    if (digits.d36 != 0) {
        if (digits.d36 == 1) {
            tempvar sum_p = sum_p + (-3) ** 36;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 36;
        }
    }
    if (digits.d37 != 0) {
        if (digits.d37 == 1) {
            tempvar sum_p = sum_p + (-3) ** 37;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 37;
        }
    }
    if (digits.d38 != 0) {
        if (digits.d38 == 1) {
            tempvar sum_p = sum_p + (-3) ** 38;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 38;
        }
    }
    if (digits.d39 != 0) {
        if (digits.d39 == 1) {
            tempvar sum_p = sum_p + (-3) ** 39;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 39;
        }
    }
    if (digits.d40 != 0) {
        if (digits.d40 == 1) {
            tempvar sum_p = sum_p + (-3) ** 40;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 40;
        }
    }
    if (digits.d41 != 0) {
        if (digits.d41 == 1) {
            tempvar sum_p = sum_p + (-3) ** 41;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 41;
        }
    }
    if (digits.d42 != 0) {
        if (digits.d42 == 1) {
            tempvar sum_p = sum_p + (-3) ** 42;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 42;
        }
    }
    if (digits.d43 != 0) {
        if (digits.d43 == 1) {
            tempvar sum_p = sum_p + (-3) ** 43;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 43;
        }
    }
    if (digits.d44 != 0) {
        if (digits.d44 == 1) {
            tempvar sum_p = sum_p + (-3) ** 44;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 44;
        }
    }
    if (digits.d45 != 0) {
        if (digits.d45 == 1) {
            tempvar sum_p = sum_p + (-3) ** 45;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 45;
        }
    }
    if (digits.d46 != 0) {
        if (digits.d46 == 1) {
            tempvar sum_p = sum_p + (-3) ** 46;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 46;
        }
    }
    if (digits.d47 != 0) {
        if (digits.d47 == 1) {
            tempvar sum_p = sum_p + (-3) ** 47;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 47;
        }
    }
    if (digits.d48 != 0) {
        if (digits.d48 == 1) {
            tempvar sum_p = sum_p + (-3) ** 48;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 48;
        }
    }
    if (digits.d49 != 0) {
        if (digits.d49 == 1) {
            tempvar sum_p = sum_p + (-3) ** 49;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 49;
        }
    }
    if (digits.d50 != 0) {
        if (digits.d50 == 1) {
            tempvar sum_p = sum_p + (-3) ** 50;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 50;
        }
    }
    if (digits.d51 != 0) {
        if (digits.d51 == 1) {
            tempvar sum_p = sum_p + (-3) ** 51;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 51;
        }
    }
    if (digits.d52 != 0) {
        if (digits.d52 == 1) {
            tempvar sum_p = sum_p + (-3) ** 52;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 52;
        }
    }
    if (digits.d53 != 0) {
        if (digits.d53 == 1) {
            tempvar sum_p = sum_p + (-3) ** 53;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 53;
        }
    }
    if (digits.d54 != 0) {
        if (digits.d54 == 1) {
            tempvar sum_p = sum_p + (-3) ** 54;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 54;
        }
    }
    if (digits.d55 != 0) {
        if (digits.d55 == 1) {
            tempvar sum_p = sum_p + (-3) ** 55;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 55;
        }
    }
    if (digits.d56 != 0) {
        if (digits.d56 == 1) {
            tempvar sum_p = sum_p + (-3) ** 56;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 56;
        }
    }
    if (digits.d57 != 0) {
        if (digits.d57 == 1) {
            tempvar sum_p = sum_p + (-3) ** 57;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 57;
        }
    }
    if (digits.d58 != 0) {
        if (digits.d58 == 1) {
            tempvar sum_p = sum_p + (-3) ** 58;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 58;
        }
    }
    if (digits.d59 != 0) {
        if (digits.d59 == 1) {
            tempvar sum_p = sum_p + (-3) ** 59;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 59;
        }
    }
    if (digits.d60 != 0) {
        if (digits.d60 == 1) {
            tempvar sum_p = sum_p + (-3) ** 60;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 60;
        }
    }
    if (digits.d61 != 0) {
        if (digits.d61 == 1) {
            tempvar sum_p = sum_p + (-3) ** 61;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 61;
        }
    }
    if (digits.d62 != 0) {
        if (digits.d62 == 1) {
            tempvar sum_p = sum_p + (-3) ** 62;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 62;
        }
    }
    if (digits.d63 != 0) {
        if (digits.d63 == 1) {
            tempvar sum_p = sum_p + (-3) ** 63;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 63;
        }
    }
    if (digits.d64 != 0) {
        if (digits.d64 == 1) {
            tempvar sum_p = sum_p + (-3) ** 64;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 64;
        }
    }
    if (digits.d65 != 0) {
        if (digits.d65 == 1) {
            tempvar sum_p = sum_p + (-3) ** 65;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 65;
        }
    }
    if (digits.d66 != 0) {
        if (digits.d66 == 1) {
            tempvar sum_p = sum_p + (-3) ** 66;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 66;
        }
    }
    if (digits.d67 != 0) {
        if (digits.d67 == 1) {
            tempvar sum_p = sum_p + (-3) ** 67;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 67;
        }
    }
    if (digits.d68 != 0) {
        if (digits.d68 == 1) {
            tempvar sum_p = sum_p + (-3) ** 68;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 68;
        }
    }
    if (digits.d69 != 0) {
        if (digits.d69 == 1) {
            tempvar sum_p = sum_p + (-3) ** 69;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 69;
        }
    }
    if (digits.d70 != 0) {
        if (digits.d70 == 1) {
            tempvar sum_p = sum_p + (-3) ** 70;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 70;
        }
    }
    if (digits.d71 != 0) {
        if (digits.d71 == 1) {
            tempvar sum_p = sum_p + (-3) ** 71;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 71;
        }
    }
    if (digits.d72 != 0) {
        if (digits.d72 == 1) {
            tempvar sum_p = sum_p + (-3) ** 72;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 72;
        }
    }
    if (digits.d73 != 0) {
        if (digits.d73 == 1) {
            tempvar sum_p = sum_p + (-3) ** 73;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 73;
        }
    }
    if (digits.d74 != 0) {
        if (digits.d74 == 1) {
            tempvar sum_p = sum_p + (-3) ** 74;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 74;
        }
    }
    if (digits.d75 != 0) {
        if (digits.d75 == 1) {
            tempvar sum_p = sum_p + (-3) ** 75;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 75;
        }
    }
    if (digits.d76 != 0) {
        if (digits.d76 == 1) {
            tempvar sum_p = sum_p + (-3) ** 76;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 76;
        }
    }
    if (digits.d77 != 0) {
        if (digits.d77 == 1) {
            tempvar sum_p = sum_p + (-3) ** 77;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 77;
        }
    }
    if (digits.d78 != 0) {
        if (digits.d78 == 1) {
            tempvar sum_p = sum_p + (-3) ** 78;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 78;
        }
    }
    if (digits.d79 != 0) {
        if (digits.d79 == 1) {
            tempvar sum_p = sum_p + (-3) ** 79;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 79;
        }
    }
    if (digits.d80 != 0) {
        if (digits.d80 == 1) {
            tempvar sum_p = sum_p + (-3) ** 80;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 80;
        }
    }
    if (digits.d81 != 0) {
        if (digits.d81 == 1) {
            tempvar sum_p = sum_p + (-3) ** 81;
            tempvar sum_n = sum_n;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + (-3) ** 81;
        }
    }

    // %{
    //     from starkware.cairo.common.math_utils import as_int
    //     print(f"{as_int(ids.sum_p, PRIME)=}")
    //     print(f"{as_int(ids.sum_n, PRIME)=}")
    // %}
    assert scalar = sum_p - sum_n;

    let p_sign = sign(sum_p);
    let n_sign = sign(sum_n);

    return (p_sign * sum_p, n_sign * sum_n, p_sign, n_sign);
}

// Utility to get a pointer on an array of (-3)^i for i in [0, 81].
func neg_3_pow_alloc_80() -> (array: felt*) {
    let (data_address) = get_label_location(data);
    return (data_address,);

    data:
    dw 1;
    dw (-3) ** 1;
    dw (-3) ** 2;
    dw (-3) ** 3;
    dw (-3) ** 4;
    dw (-3) ** 5;
    dw (-3) ** 6;
    dw (-3) ** 7;
    dw (-3) ** 8;
    dw (-3) ** 9;
    dw (-3) ** 10;
    dw (-3) ** 11;
    dw (-3) ** 12;
    dw (-3) ** 13;
    dw (-3) ** 14;
    dw (-3) ** 15;
    dw (-3) ** 16;
    dw (-3) ** 17;
    dw (-3) ** 18;
    dw (-3) ** 19;
    dw (-3) ** 20;
    dw (-3) ** 21;
    dw (-3) ** 22;
    dw (-3) ** 23;
    dw (-3) ** 24;
    dw (-3) ** 25;
    dw (-3) ** 26;
    dw (-3) ** 27;
    dw (-3) ** 28;
    dw (-3) ** 29;
    dw (-3) ** 30;
    dw (-3) ** 31;
    dw (-3) ** 32;
    dw (-3) ** 33;
    dw (-3) ** 34;
    dw (-3) ** 35;
    dw (-3) ** 36;
    dw (-3) ** 37;
    dw (-3) ** 38;
    dw (-3) ** 39;
    dw (-3) ** 40;
    dw (-3) ** 41;
    dw (-3) ** 42;
    dw (-3) ** 43;
    dw (-3) ** 44;
    dw (-3) ** 45;
    dw (-3) ** 46;
    dw (-3) ** 47;
    dw (-3) ** 48;
    dw (-3) ** 49;
    dw (-3) ** 50;
    dw (-3) ** 51;
    dw (-3) ** 52;
    dw (-3) ** 53;
    dw (-3) ** 54;
    dw (-3) ** 55;
    dw (-3) ** 56;
    dw (-3) ** 57;
    dw (-3) ** 58;
    dw (-3) ** 59;
    dw (-3) ** 60;
    dw (-3) ** 61;
    dw (-3) ** 62;
    dw (-3) ** 63;
    dw (-3) ** 64;
    dw (-3) ** 65;
    dw (-3) ** 66;
    dw (-3) ** 67;
    dw (-3) ** 68;
    dw (-3) ** 69;
    dw (-3) ** 70;
    dw (-3) ** 71;
    dw (-3) ** 72;
    dw (-3) ** 73;
    dw (-3) ** 74;
    dw (-3) ** 75;
    dw (-3) ** 76;
    dw (-3) ** 77;
    dw (-3) ** 78;
    dw (-3) ** 79;
    dw (-3) ** 80;
    dw (-3) ** 81;
}

// Returns q and r such that:
//  0 <= q < rc_bound, 0 <= r < div and value = q * div + r.
//
// Assumption: 0 < div <= PRIME / rc_bound.
// Prover assumption: value / div < rc_bound.
// Modified version of unsigned_div_rem with inlined range checks.
func felt_divmod{range_check_ptr}(value, div) -> (q: felt, r: felt) {
    let r = [range_check_ptr];
    let q = [range_check_ptr + 1];
    %{
        from starkware.cairo.common.math_utils import assert_integer
        assert_integer(ids.div)
        assert 0 < ids.div <= PRIME // range_check_builtin.bound, \
            f'div={hex(ids.div)} is out of the valid range.'
        ids.q, ids.r = divmod(ids.value, ids.div)
    %}
    assert [range_check_ptr + 2] = div - 1 - r;
    let range_check_ptr = range_check_ptr + 3;

    assert value = q * div + r;
    return (q, r);
}

// Utility to get a pointer on an array of 2^i from i = 0 to 128.
func pow2alloc128() -> (array: felt*) {
    let (data_address) = get_label_location(data);
    return (data_address,);

    data:
    dw 0x1;
    dw 0x2;
    dw 0x4;
    dw 0x8;
    dw 0x10;
    dw 0x20;
    dw 0x40;
    dw 0x80;
    dw 0x100;
    dw 0x200;
    dw 0x400;
    dw 0x800;
    dw 0x1000;
    dw 0x2000;
    dw 0x4000;
    dw 0x8000;
    dw 0x10000;
    dw 0x20000;
    dw 0x40000;
    dw 0x80000;
    dw 0x100000;
    dw 0x200000;
    dw 0x400000;
    dw 0x800000;
    dw 0x1000000;
    dw 0x2000000;
    dw 0x4000000;
    dw 0x8000000;
    dw 0x10000000;
    dw 0x20000000;
    dw 0x40000000;
    dw 0x80000000;
    dw 0x100000000;
    dw 0x200000000;
    dw 0x400000000;
    dw 0x800000000;
    dw 0x1000000000;
    dw 0x2000000000;
    dw 0x4000000000;
    dw 0x8000000000;
    dw 0x10000000000;
    dw 0x20000000000;
    dw 0x40000000000;
    dw 0x80000000000;
    dw 0x100000000000;
    dw 0x200000000000;
    dw 0x400000000000;
    dw 0x800000000000;
    dw 0x1000000000000;
    dw 0x2000000000000;
    dw 0x4000000000000;
    dw 0x8000000000000;
    dw 0x10000000000000;
    dw 0x20000000000000;
    dw 0x40000000000000;
    dw 0x80000000000000;
    dw 0x100000000000000;
    dw 0x200000000000000;
    dw 0x400000000000000;
    dw 0x800000000000000;
    dw 0x1000000000000000;
    dw 0x2000000000000000;
    dw 0x4000000000000000;
    dw 0x8000000000000000;
    dw 0x10000000000000000;
    dw 0x20000000000000000;
    dw 0x40000000000000000;
    dw 0x80000000000000000;
    dw 0x100000000000000000;
    dw 0x200000000000000000;
    dw 0x400000000000000000;
    dw 0x800000000000000000;
    dw 0x1000000000000000000;
    dw 0x2000000000000000000;
    dw 0x4000000000000000000;
    dw 0x8000000000000000000;
    dw 0x10000000000000000000;
    dw 0x20000000000000000000;
    dw 0x40000000000000000000;
    dw 0x80000000000000000000;
    dw 0x100000000000000000000;
    dw 0x200000000000000000000;
    dw 0x400000000000000000000;
    dw 0x800000000000000000000;
    dw 0x1000000000000000000000;
    dw 0x2000000000000000000000;
    dw 0x4000000000000000000000;
    dw 0x8000000000000000000000;
    dw 0x10000000000000000000000;
    dw 0x20000000000000000000000;
    dw 0x40000000000000000000000;
    dw 0x80000000000000000000000;
    dw 0x100000000000000000000000;
    dw 0x200000000000000000000000;
    dw 0x400000000000000000000000;
    dw 0x800000000000000000000000;
    dw 0x1000000000000000000000000;
    dw 0x2000000000000000000000000;
    dw 0x4000000000000000000000000;
    dw 0x8000000000000000000000000;
    dw 0x10000000000000000000000000;
    dw 0x20000000000000000000000000;
    dw 0x40000000000000000000000000;
    dw 0x80000000000000000000000000;
    dw 0x100000000000000000000000000;
    dw 0x200000000000000000000000000;
    dw 0x400000000000000000000000000;
    dw 0x800000000000000000000000000;
    dw 0x1000000000000000000000000000;
    dw 0x2000000000000000000000000000;
    dw 0x4000000000000000000000000000;
    dw 0x8000000000000000000000000000;
    dw 0x10000000000000000000000000000;
    dw 0x20000000000000000000000000000;
    dw 0x40000000000000000000000000000;
    dw 0x80000000000000000000000000000;
    dw 0x100000000000000000000000000000;
    dw 0x200000000000000000000000000000;
    dw 0x400000000000000000000000000000;
    dw 0x800000000000000000000000000000;
    dw 0x1000000000000000000000000000000;
    dw 0x2000000000000000000000000000000;
    dw 0x4000000000000000000000000000000;
    dw 0x8000000000000000000000000000000;
    dw 0x10000000000000000000000000000000;
    dw 0x20000000000000000000000000000000;
    dw 0x40000000000000000000000000000000;
    dw 0x80000000000000000000000000000000;
    dw 0x100000000000000000000000000000000;
}
