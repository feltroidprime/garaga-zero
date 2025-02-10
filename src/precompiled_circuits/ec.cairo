from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls
// Available functions:
// - get_ACC_EVAL_POINT_CHALLENGE_SIGNED_circuit
// - get_ACC_FUNCTION_CHALLENGE_DUPL_circuit
// - get_ADD_EC_POINTS_G2_circuit
// - get_ADD_EC_POINT_circuit
// - get_DECOMPRESS_G1_POINT_circuit
// - get_DERIVE_POINT_FROM_X_circuit
// - get_DOUBLE_EC_POINT_circuit
// - get_EVAL_FN_CHALLENGE_DUPL_1P_circuit
// - get_EVAL_FN_CHALLENGE_DUPL_2P_circuit
// - get_EVAL_FN_CHALLENGE_DUPL_3P_circuit
// - get_EVAL_FN_CHALLENGE_DUPL_4P_circuit
// - get_FINALIZE_FN_CHALLENGE_DUPL_circuit
// - get_INIT_FN_CHALLENGE_DUPL_5P_circuit
// - get_IS_ON_CURVE_G1_G2_circuit
// - get_IS_ON_CURVE_G1_circuit
// - get_RHS_FINALIZE_ACC_circuit
// - get_SLOPE_INTERCEPT_SAME_POINT_circuit

func get_FULL_ECIP_BATCHED_circuit(curve_id: felt, n_points: felt) -> (circuit: ModuloCircuit*) {
    tempvar offset = 2 * (n_points - 1) + 1;
    jmp rel offset;

    jmp circuit_1;

    jmp circuit_2;

    circuit_1:
    let curve_id = [fp - 4];
    return get_FULL_ECIP_1P_circuit(curve_id);

    circuit_2:
    let curve_id = [fp - 4];
    return get_FULL_ECIP_2P_circuit(curve_id);
}

func get_INIT_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt, n_points: felt) -> (
    circuit: ModuloCircuit*
) {
    tempvar offset = 2 * (n_points - 1) + 1;
    jmp rel offset;

    jmp circuit_5;

    circuit_5:
    let curve_id = [fp - 4];
    return get_INIT_FN_CHALLENGE_DUPL_5P_circuit(curve_id);
}

func get_EVAL_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt, n_points: felt) -> (
    circuit: ModuloCircuit*
) {
    tempvar offset = 2 * (n_points - 1) + 1;
    jmp rel offset;

    jmp circuit_1;

    jmp circuit_2;

    jmp circuit_3;

    jmp circuit_4;

    circuit_1:
    let curve_id = [fp - 4];
    return get_EVAL_FN_CHALLENGE_DUPL_1P_circuit(curve_id);

    circuit_2:
    let curve_id = [fp - 4];
    return get_EVAL_FN_CHALLENGE_DUPL_2P_circuit(curve_id);

    circuit_3:
    let curve_id = [fp - 4];
    return get_EVAL_FN_CHALLENGE_DUPL_3P_circuit(curve_id);

    circuit_4:
    let curve_id = [fp - 4];
    return get_EVAL_FN_CHALLENGE_DUPL_4P_circuit(curve_id);
}

func get_FULL_ECIP_2P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 80;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 23;
    let mul_mod_n = 28;
    let n_assert_eq = 0;
    let name = 'eval_fn_challenge_dupl_1P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 80;
    dw 84;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 88;
    dw 92;
    dw 32;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 96;
    dw 100;
    dw 48;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 108;
    dw 112;
    dw 44;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 116;
    dw 120;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 124;
    dw 128;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 132;
    dw 136;
    dw 64;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 140;
    dw 144;
    dw 60;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 148;
    dw 152;
    dw 56;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 156;
    dw 160;
    dw 104;  // None
    dw 168;
    dw 172;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 176;
    dw 180;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 184;
    dw 188;
    dw 32;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 192;
    dw 196;
    dw 48;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 204;
    dw 208;
    dw 44;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 212;
    dw 216;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 220;
    dw 224;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 228;
    dw 232;
    dw 64;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 236;
    dw 240;
    dw 60;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 244;
    dw 248;
    dw 56;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 252;
    dw 256;
    dw 200;  // None
    dw 264;
    dw 268;
    dw 276;  // None
    dw 280;
    dw 272;

    mul_offsets_ptr_loc:
    dw 28;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 80;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 88;
    dw 92;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 96;
    dw 100;  // None
    dw 104;
    dw 84;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 108;
    dw 112;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 116;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 124;
    dw 128;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 132;
    dw 136;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 140;
    dw 144;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 148;
    dw 152;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 156;
    dw 160;  // None
    dw 164;
    dw 120;
    dw 4;  // None
    dw 164;
    dw 168;
    dw 28;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 176;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 184;
    dw 188;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 192;
    dw 196;  // None
    dw 200;
    dw 180;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 204;
    dw 208;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 212;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 220;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 228;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 236;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 244;
    dw 248;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 252;
    dw 256;  // None
    dw 260;
    dw 216;
    dw 12;  // None
    dw 260;
    dw 264;
    dw 16;  // None
    dw 172;
    dw 272;
    dw 20;  // None
    dw 268;
    dw 276;

    output_offsets_ptr_loc:
    dw 280;
}

func get_EVAL_FN_CHALLENGE_DUPL_2P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 96;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 31;
    let mul_mod_n = 36;
    let n_assert_eq = 0;
    let name = 'eval_fn_challenge_dupl_2P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 28;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 96;
    dw 100;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 104;
    dw 108;
    dw 44;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 112;
    dw 116;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 120;
    dw 124;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 128;
    dw 132;
    dw 60;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 140;
    dw 144;
    dw 56;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 148;
    dw 152;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 156;
    dw 160;
    dw 88;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 164;
    dw 168;
    dw 84;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 172;
    dw 176;
    dw 80;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 180;
    dw 184;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 188;
    dw 192;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 196;
    dw 200;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 204;
    dw 208;
    dw 136;  // None
    dw 216;
    dw 220;
    dw 28;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 224;
    dw 228;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 232;
    dw 236;
    dw 44;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 240;
    dw 244;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 248;
    dw 252;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 256;
    dw 260;
    dw 60;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 268;
    dw 272;
    dw 56;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 276;
    dw 280;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 284;
    dw 288;
    dw 88;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 292;
    dw 296;
    dw 84;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 300;
    dw 304;
    dw 80;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 308;
    dw 312;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 316;
    dw 320;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 324;
    dw 328;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 332;
    dw 336;
    dw 264;  // None
    dw 344;
    dw 348;
    dw 356;  // None
    dw 360;
    dw 352;

    mul_offsets_ptr_loc:
    dw 32;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 96;
    dw 100;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 104;
    dw 48;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 112;
    dw 116;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 120;
    dw 124;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 128;
    dw 132;  // None
    dw 136;
    dw 108;
    dw 64;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 140;
    dw 144;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 148;
    dw 152;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 156;
    dw 92;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 164;
    dw 168;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 172;
    dw 176;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 180;
    dw 184;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 188;
    dw 192;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 196;
    dw 200;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 204;
    dw 208;  // None
    dw 212;
    dw 160;
    dw 4;  // None
    dw 212;
    dw 216;
    dw 32;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 224;
    dw 228;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 232;
    dw 48;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 240;
    dw 244;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 248;
    dw 252;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 256;
    dw 260;  // None
    dw 264;
    dw 236;
    dw 64;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 268;
    dw 272;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 276;
    dw 280;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 284;
    dw 92;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 292;
    dw 296;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 300;
    dw 304;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 308;
    dw 312;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 316;
    dw 320;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 324;
    dw 328;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 332;
    dw 336;  // None
    dw 340;
    dw 288;
    dw 12;  // None
    dw 340;
    dw 344;
    dw 16;  // None
    dw 220;
    dw 352;
    dw 20;  // None
    dw 348;
    dw 356;

    output_offsets_ptr_loc:
    dw 360;
}


func get_IS_ON_CURVE_G1_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 3;
    let mul_mod_n = 4;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 28;  // None
    dw 12;
    dw 32;
    dw 24;  // None
    dw 32;
    dw 36;
    dw 36;  // None
    dw 40;
    dw 16;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 8;
    dw 16;

    dw 0;  // None
    dw 0;
    dw 20;
    dw 0;  // None
    dw 20;
    dw 24;
    dw 8;  // None
    dw 0;
    dw 28;

    output_offsets_ptr_loc:
    dw 40;
}

func get_SLOPE_INTERCEPT_SAME_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 2;
    let input_len = 12;
    let witnesses_len = 0;
    let output_len = 32;
    let continuous_output = 0;
    let add_mod_n = 17;
    let mul_mod_n = 12;
    let n_assert_eq = 0;
    let name = 'slope_intercept_same_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 24;  // None
    dw 16;
    dw 28;
    dw 12;  // None
    dw 12;
    dw 32;
    dw 40;  // None
    dw 44;
    dw 12;
    dw 8;  // None
    dw 8;
    dw 52;
    dw 52;  // None
    dw 56;
    dw 48;
    dw 56;  // None
    dw 60;
    dw 8;
    dw 12;  // None
    dw 68;
    dw 64;
    dw 68;  // None
    dw 72;
    dw 4;
    dw 12;  // None
    dw 76;
    dw 72;
    dw 8;  // None
    dw 80;
    dw 56;
    dw 72;  // None
    dw 72;
    dw 92;
    dw 56;  // None
    dw 96;
    dw 8;
    dw 88;  // None
    dw 88;
    dw 112;
    dw 112;  // None
    dw 116;
    dw 16;
    dw 108;  // None
    dw 116;
    dw 120;
    dw 84;  // None
    dw 84;
    dw 128;
    dw 124;  // None
    dw 128;
    dw 132;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 8;
    dw 20;
    dw 0;  // None
    dw 20;
    dw 24;
    dw 32;  // None
    dw 36;
    dw 28;
    dw 8;  // None
    dw 36;
    dw 40;
    dw 36;  // None
    dw 36;
    dw 48;
    dw 36;  // None
    dw 60;
    dw 64;
    dw 80;  // None
    dw 84;
    dw 76;
    dw 84;  // None
    dw 72;
    dw 88;
    dw 92;  // None
    dw 96;
    dw 100;
    dw 56;  // None
    dw 56;
    dw 104;
    dw 0;  // None
    dw 104;
    dw 108;
    dw 120;  // None
    dw 124;
    dw 100;

    output_offsets_ptr_loc:
    dw 36;
    dw 44;
    dw 8;
    dw 12;
    dw 56;
    dw 72;
    dw 132;
    dw 124;
}

func get_INIT_FN_CHALLENGE_DUPL_5P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 128;
    let witnesses_len = 0;
    let output_len = 40;
    let continuous_output = 0;
    let add_mod_n = 52;
    let mul_mod_n = 68;
    let n_assert_eq = 0;
    let name = 'init_fn_challenge_dupl_5P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 8;  // Eval sumdlogdiv_a_num step + (coeff_1 * xA0^1)
    dw 192;
    dw 196;
    dw 196;  // Eval sumdlogdiv_a_num step + (coeff_2 * xA0^2)
    dw 200;
    dw 204;
    dw 204;  // Eval sumdlogdiv_a_num step + (coeff_3 * xA0^3)
    dw 208;
    dw 212;
    dw 212;  // Eval sumdlogdiv_a_num step + (coeff_4 * xA0^4)
    dw 216;
    dw 220;
    dw 220;  // Eval sumdlogdiv_a_num step + (coeff_5 * xA0^5)
    dw 224;
    dw 228;
    dw 32;  // Eval sumdlogdiv_a_den step + (coeff_1 * xA0^1)
    dw 232;
    dw 236;
    dw 236;  // Eval sumdlogdiv_a_den step + (coeff_2 * xA0^2)
    dw 240;
    dw 244;
    dw 244;  // Eval sumdlogdiv_a_den step + (coeff_3 * xA0^3)
    dw 248;
    dw 252;
    dw 252;  // Eval sumdlogdiv_a_den step + (coeff_4 * xA0^4)
    dw 256;
    dw 260;
    dw 260;  // Eval sumdlogdiv_a_den step + (coeff_5 * xA0^5)
    dw 264;
    dw 268;
    dw 268;  // Eval sumdlogdiv_a_den step + (coeff_6 * xA0^6)
    dw 272;
    dw 276;
    dw 60;  // Eval sumdlogdiv_b_num step + (coeff_1 * xA0^1)
    dw 280;
    dw 284;
    dw 284;  // Eval sumdlogdiv_b_num step + (coeff_2 * xA0^2)
    dw 288;
    dw 292;
    dw 292;  // Eval sumdlogdiv_b_num step + (coeff_3 * xA0^3)
    dw 296;
    dw 300;
    dw 300;  // Eval sumdlogdiv_b_num step + (coeff_4 * xA0^4)
    dw 304;
    dw 308;
    dw 308;  // Eval sumdlogdiv_b_num step + (coeff_5 * xA0^5)
    dw 312;
    dw 316;
    dw 316;  // Eval sumdlogdiv_b_num step + (coeff_6 * xA0^6)
    dw 320;
    dw 324;
    dw 88;  // Eval sumdlogdiv_b_den step + (coeff_1 * xA0^1)
    dw 328;
    dw 332;
    dw 332;  // Eval sumdlogdiv_b_den step + (coeff_2 * xA0^2)
    dw 336;
    dw 340;
    dw 340;  // Eval sumdlogdiv_b_den step + (coeff_3 * xA0^3)
    dw 344;
    dw 348;
    dw 348;  // Eval sumdlogdiv_b_den step + (coeff_4 * xA0^4)
    dw 352;
    dw 356;
    dw 356;  // Eval sumdlogdiv_b_den step + (coeff_5 * xA0^5)
    dw 360;
    dw 364;
    dw 364;  // Eval sumdlogdiv_b_den step + (coeff_6 * xA0^6)
    dw 368;
    dw 372;
    dw 372;  // Eval sumdlogdiv_b_den step + (coeff_7 * xA0^7)
    dw 376;
    dw 380;
    dw 380;  // Eval sumdlogdiv_b_den step + (coeff_8 * xA0^8)
    dw 384;
    dw 388;
    dw 388;  // Eval sumdlogdiv_b_den step + (coeff_9 * xA0^9)
    dw 392;
    dw 396;
    dw 8;  // Eval sumdlogdiv_a_num step + (coeff_1 * xA2^1)
    dw 400;
    dw 404;
    dw 404;  // Eval sumdlogdiv_a_num step + (coeff_2 * xA2^2)
    dw 408;
    dw 412;
    dw 412;  // Eval sumdlogdiv_a_num step + (coeff_3 * xA2^3)
    dw 416;
    dw 420;
    dw 420;  // Eval sumdlogdiv_a_num step + (coeff_4 * xA2^4)
    dw 424;
    dw 428;
    dw 428;  // Eval sumdlogdiv_a_num step + (coeff_5 * xA2^5)
    dw 432;
    dw 436;
    dw 32;  // Eval sumdlogdiv_a_den step + (coeff_1 * xA2^1)
    dw 440;
    dw 444;
    dw 444;  // Eval sumdlogdiv_a_den step + (coeff_2 * xA2^2)
    dw 448;
    dw 452;
    dw 452;  // Eval sumdlogdiv_a_den step + (coeff_3 * xA2^3)
    dw 456;
    dw 460;
    dw 460;  // Eval sumdlogdiv_a_den step + (coeff_4 * xA2^4)
    dw 464;
    dw 468;
    dw 468;  // Eval sumdlogdiv_a_den step + (coeff_5 * xA2^5)
    dw 472;
    dw 476;
    dw 476;  // Eval sumdlogdiv_a_den step + (coeff_6 * xA2^6)
    dw 480;
    dw 484;
    dw 60;  // Eval sumdlogdiv_b_num step + (coeff_1 * xA2^1)
    dw 488;
    dw 492;
    dw 492;  // Eval sumdlogdiv_b_num step + (coeff_2 * xA2^2)
    dw 496;
    dw 500;
    dw 500;  // Eval sumdlogdiv_b_num step + (coeff_3 * xA2^3)
    dw 504;
    dw 508;
    dw 508;  // Eval sumdlogdiv_b_num step + (coeff_4 * xA2^4)
    dw 512;
    dw 516;
    dw 516;  // Eval sumdlogdiv_b_num step + (coeff_5 * xA2^5)
    dw 520;
    dw 524;
    dw 524;  // Eval sumdlogdiv_b_num step + (coeff_6 * xA2^6)
    dw 528;
    dw 532;
    dw 88;  // Eval sumdlogdiv_b_den step + (coeff_1 * xA2^1)
    dw 536;
    dw 540;
    dw 540;  // Eval sumdlogdiv_b_den step + (coeff_2 * xA2^2)
    dw 544;
    dw 548;
    dw 548;  // Eval sumdlogdiv_b_den step + (coeff_3 * xA2^3)
    dw 552;
    dw 556;
    dw 556;  // Eval sumdlogdiv_b_den step + (coeff_4 * xA2^4)
    dw 560;
    dw 564;
    dw 564;  // Eval sumdlogdiv_b_den step + (coeff_5 * xA2^5)
    dw 568;
    dw 572;
    dw 572;  // Eval sumdlogdiv_b_den step + (coeff_6 * xA2^6)
    dw 576;
    dw 580;
    dw 580;  // Eval sumdlogdiv_b_den step + (coeff_7 * xA2^7)
    dw 584;
    dw 588;
    dw 588;  // Eval sumdlogdiv_b_den step + (coeff_8 * xA2^8)
    dw 592;
    dw 596;
    dw 596;  // Eval sumdlogdiv_b_den step + (coeff_9 * xA2^9)
    dw 600;
    dw 604;

    mul_offsets_ptr_loc:
    dw 0;  // xA0^2
    dw 0;
    dw 128;
    dw 4;  // xA2^2
    dw 4;
    dw 132;
    dw 128;  // xA0^3
    dw 0;
    dw 136;
    dw 132;  // xA2^3
    dw 4;
    dw 140;
    dw 136;  // xA0^4
    dw 0;
    dw 144;
    dw 140;  // xA2^4
    dw 4;
    dw 148;
    dw 144;  // xA0^5
    dw 0;
    dw 152;
    dw 148;  // xA2^5
    dw 4;
    dw 156;
    dw 152;  // xA0^6
    dw 0;
    dw 160;
    dw 156;  // xA2^6
    dw 4;
    dw 164;
    dw 160;  // xA0^7
    dw 0;
    dw 168;
    dw 164;  // xA2^7
    dw 4;
    dw 172;
    dw 168;  // xA0^8
    dw 0;
    dw 176;
    dw 172;  // xA2^8
    dw 4;
    dw 180;
    dw 176;  // xA0^9
    dw 0;
    dw 184;
    dw 180;  // xA2^9
    dw 4;
    dw 188;
    dw 12;  // Eval sumdlogdiv_a_num step coeff_1 * xA0^1
    dw 0;
    dw 192;
    dw 16;  // Eval sumdlogdiv_a_num step coeff_2 * xA0^2
    dw 128;
    dw 200;
    dw 20;  // Eval sumdlogdiv_a_num step coeff_3 * xA0^3
    dw 136;
    dw 208;
    dw 24;  // Eval sumdlogdiv_a_num step coeff_4 * xA0^4
    dw 144;
    dw 216;
    dw 28;  // Eval sumdlogdiv_a_num step coeff_5 * xA0^5
    dw 152;
    dw 224;
    dw 36;  // Eval sumdlogdiv_a_den step coeff_1 * xA0^1
    dw 0;
    dw 232;
    dw 40;  // Eval sumdlogdiv_a_den step coeff_2 * xA0^2
    dw 128;
    dw 240;
    dw 44;  // Eval sumdlogdiv_a_den step coeff_3 * xA0^3
    dw 136;
    dw 248;
    dw 48;  // Eval sumdlogdiv_a_den step coeff_4 * xA0^4
    dw 144;
    dw 256;
    dw 52;  // Eval sumdlogdiv_a_den step coeff_5 * xA0^5
    dw 152;
    dw 264;
    dw 56;  // Eval sumdlogdiv_a_den step coeff_6 * xA0^6
    dw 160;
    dw 272;
    dw 64;  // Eval sumdlogdiv_b_num step coeff_1 * xA0^1
    dw 0;
    dw 280;
    dw 68;  // Eval sumdlogdiv_b_num step coeff_2 * xA0^2
    dw 128;
    dw 288;
    dw 72;  // Eval sumdlogdiv_b_num step coeff_3 * xA0^3
    dw 136;
    dw 296;
    dw 76;  // Eval sumdlogdiv_b_num step coeff_4 * xA0^4
    dw 144;
    dw 304;
    dw 80;  // Eval sumdlogdiv_b_num step coeff_5 * xA0^5
    dw 152;
    dw 312;
    dw 84;  // Eval sumdlogdiv_b_num step coeff_6 * xA0^6
    dw 160;
    dw 320;
    dw 92;  // Eval sumdlogdiv_b_den step coeff_1 * xA0^1
    dw 0;
    dw 328;
    dw 96;  // Eval sumdlogdiv_b_den step coeff_2 * xA0^2
    dw 128;
    dw 336;
    dw 100;  // Eval sumdlogdiv_b_den step coeff_3 * xA0^3
    dw 136;
    dw 344;
    dw 104;  // Eval sumdlogdiv_b_den step coeff_4 * xA0^4
    dw 144;
    dw 352;
    dw 108;  // Eval sumdlogdiv_b_den step coeff_5 * xA0^5
    dw 152;
    dw 360;
    dw 112;  // Eval sumdlogdiv_b_den step coeff_6 * xA0^6
    dw 160;
    dw 368;
    dw 116;  // Eval sumdlogdiv_b_den step coeff_7 * xA0^7
    dw 168;
    dw 376;
    dw 120;  // Eval sumdlogdiv_b_den step coeff_8 * xA0^8
    dw 176;
    dw 384;
    dw 124;  // Eval sumdlogdiv_b_den step coeff_9 * xA0^9
    dw 184;
    dw 392;
    dw 12;  // Eval sumdlogdiv_a_num step coeff_1 * xA2^1
    dw 4;
    dw 400;
    dw 16;  // Eval sumdlogdiv_a_num step coeff_2 * xA2^2
    dw 132;
    dw 408;
    dw 20;  // Eval sumdlogdiv_a_num step coeff_3 * xA2^3
    dw 140;
    dw 416;
    dw 24;  // Eval sumdlogdiv_a_num step coeff_4 * xA2^4
    dw 148;
    dw 424;
    dw 28;  // Eval sumdlogdiv_a_num step coeff_5 * xA2^5
    dw 156;
    dw 432;
    dw 36;  // Eval sumdlogdiv_a_den step coeff_1 * xA2^1
    dw 4;
    dw 440;
    dw 40;  // Eval sumdlogdiv_a_den step coeff_2 * xA2^2
    dw 132;
    dw 448;
    dw 44;  // Eval sumdlogdiv_a_den step coeff_3 * xA2^3
    dw 140;
    dw 456;
    dw 48;  // Eval sumdlogdiv_a_den step coeff_4 * xA2^4
    dw 148;
    dw 464;
    dw 52;  // Eval sumdlogdiv_a_den step coeff_5 * xA2^5
    dw 156;
    dw 472;
    dw 56;  // Eval sumdlogdiv_a_den step coeff_6 * xA2^6
    dw 164;
    dw 480;
    dw 64;  // Eval sumdlogdiv_b_num step coeff_1 * xA2^1
    dw 4;
    dw 488;
    dw 68;  // Eval sumdlogdiv_b_num step coeff_2 * xA2^2
    dw 132;
    dw 496;
    dw 72;  // Eval sumdlogdiv_b_num step coeff_3 * xA2^3
    dw 140;
    dw 504;
    dw 76;  // Eval sumdlogdiv_b_num step coeff_4 * xA2^4
    dw 148;
    dw 512;
    dw 80;  // Eval sumdlogdiv_b_num step coeff_5 * xA2^5
    dw 156;
    dw 520;
    dw 84;  // Eval sumdlogdiv_b_num step coeff_6 * xA2^6
    dw 164;
    dw 528;
    dw 92;  // Eval sumdlogdiv_b_den step coeff_1 * xA2^1
    dw 4;
    dw 536;
    dw 96;  // Eval sumdlogdiv_b_den step coeff_2 * xA2^2
    dw 132;
    dw 544;
    dw 100;  // Eval sumdlogdiv_b_den step coeff_3 * xA2^3
    dw 140;
    dw 552;
    dw 104;  // Eval sumdlogdiv_b_den step coeff_4 * xA2^4
    dw 148;
    dw 560;
    dw 108;  // Eval sumdlogdiv_b_den step coeff_5 * xA2^5
    dw 156;
    dw 568;
    dw 112;  // Eval sumdlogdiv_b_den step coeff_6 * xA2^6
    dw 164;
    dw 576;
    dw 116;  // Eval sumdlogdiv_b_den step coeff_7 * xA2^7
    dw 172;
    dw 584;
    dw 120;  // Eval sumdlogdiv_b_den step coeff_8 * xA2^8
    dw 180;
    dw 592;
    dw 124;  // Eval sumdlogdiv_b_den step coeff_9 * xA2^9
    dw 188;
    dw 600;

    output_offsets_ptr_loc:
    dw 228;
    dw 276;
    dw 324;
    dw 396;
    dw 436;
    dw 484;
    dw 532;
    dw 604;
    dw 160;
    dw 164;
}

func get_EVAL_FN_CHALLENGE_DUPL_1P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 80;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 23;
    let mul_mod_n = 28;
    let n_assert_eq = 0;
    let name = 'eval_fn_challenge_dupl_1P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 80;
    dw 84;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 88;
    dw 92;
    dw 32;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 96;
    dw 100;
    dw 48;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 108;
    dw 112;
    dw 44;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 116;
    dw 120;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 124;
    dw 128;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 132;
    dw 136;
    dw 64;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 140;
    dw 144;
    dw 60;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 148;
    dw 152;
    dw 56;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 156;
    dw 160;
    dw 104;  // None
    dw 168;
    dw 172;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 176;
    dw 180;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 184;
    dw 188;
    dw 32;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 192;
    dw 196;
    dw 48;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 204;
    dw 208;
    dw 44;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 212;
    dw 216;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 220;
    dw 224;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 228;
    dw 232;
    dw 64;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 236;
    dw 240;
    dw 60;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 244;
    dw 248;
    dw 56;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 252;
    dw 256;
    dw 200;  // None
    dw 264;
    dw 268;
    dw 276;  // None
    dw 280;
    dw 272;

    mul_offsets_ptr_loc:
    dw 28;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 80;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 88;
    dw 92;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 96;
    dw 100;  // None
    dw 104;
    dw 84;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 108;
    dw 112;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 116;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 124;
    dw 128;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 132;
    dw 136;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 140;
    dw 144;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 148;
    dw 152;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 156;
    dw 160;  // None
    dw 164;
    dw 120;
    dw 4;  // None
    dw 164;
    dw 168;
    dw 28;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 176;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 184;
    dw 188;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 192;
    dw 196;  // None
    dw 200;
    dw 180;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 204;
    dw 208;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 212;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 220;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 228;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 236;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 244;
    dw 248;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 252;
    dw 256;  // None
    dw 260;
    dw 216;
    dw 12;  // None
    dw 260;
    dw 264;
    dw 16;  // None
    dw 172;
    dw 272;
    dw 20;  // None
    dw 268;
    dw 276;

    output_offsets_ptr_loc:
    dw 280;
}

func get_FINALIZE_FN_CHALLENGE_DUPL_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 48;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 3;
    let mul_mod_n = 8;
    let n_assert_eq = 0;
    let name = 'finalize_fn_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 48;  // a(x0) + y0 b(x0)
    dw 56;
    dw 60;
    dw 64;  // a(x2) + y2 b(x2)
    dw 72;
    dw 76;
    dw 84;  // None
    dw 88;
    dw 80;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 48;
    dw 0;
    dw 12;  // None
    dw 52;
    dw 8;
    dw 32;  // None
    dw 52;
    dw 56;
    dw 20;  // None
    dw 64;
    dw 16;
    dw 28;  // None
    dw 68;
    dw 24;
    dw 36;  // None
    dw 68;
    dw 72;
    dw 40;  // None
    dw 60;
    dw 80;
    dw 44;  // None
    dw 76;
    dw 84;

    output_offsets_ptr_loc:
    dw 88;
}

func get_EVAL_FN_CHALLENGE_DUPL_2P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 96;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 31;
    let mul_mod_n = 36;
    let n_assert_eq = 0;
    let name = 'eval_fn_challenge_dupl_2P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 28;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 96;
    dw 100;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 104;
    dw 108;
    dw 44;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 112;
    dw 116;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 120;
    dw 124;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 128;
    dw 132;
    dw 60;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 140;
    dw 144;
    dw 56;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 148;
    dw 152;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 156;
    dw 160;
    dw 88;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 164;
    dw 168;
    dw 84;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 172;
    dw 176;
    dw 80;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 180;
    dw 184;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 188;
    dw 192;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 196;
    dw 200;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 204;
    dw 208;
    dw 136;  // None
    dw 216;
    dw 220;
    dw 28;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 224;
    dw 228;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 232;
    dw 236;
    dw 44;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 240;
    dw 244;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 248;
    dw 252;
    dw 36;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 256;
    dw 260;
    dw 60;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 268;
    dw 272;
    dw 56;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 276;
    dw 280;
    dw 52;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 284;
    dw 288;
    dw 88;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 292;
    dw 296;
    dw 84;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 300;
    dw 304;
    dw 80;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 308;
    dw 312;
    dw 76;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 316;
    dw 320;
    dw 72;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 324;
    dw 328;
    dw 68;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 332;
    dw 336;
    dw 264;  // None
    dw 344;
    dw 348;
    dw 356;  // None
    dw 360;
    dw 352;

    mul_offsets_ptr_loc:
    dw 32;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 96;
    dw 100;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 104;
    dw 48;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 112;
    dw 116;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 120;
    dw 124;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 128;
    dw 132;  // None
    dw 136;
    dw 108;
    dw 64;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 140;
    dw 144;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 148;
    dw 152;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 156;
    dw 92;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 164;
    dw 168;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 172;
    dw 176;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 180;
    dw 184;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 188;
    dw 192;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 196;
    dw 200;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 204;
    dw 208;  // None
    dw 212;
    dw 160;
    dw 4;  // None
    dw 212;
    dw 216;
    dw 32;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 224;
    dw 228;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 232;
    dw 48;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 240;
    dw 244;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 248;
    dw 252;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 256;
    dw 260;  // None
    dw 264;
    dw 236;
    dw 64;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 268;
    dw 272;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 276;
    dw 280;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 284;
    dw 92;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 292;
    dw 296;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 300;
    dw 304;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 308;
    dw 312;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 316;
    dw 320;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 324;
    dw 328;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 332;
    dw 336;  // None
    dw 340;
    dw 288;
    dw 12;  // None
    dw 340;
    dw 344;
    dw 16;  // None
    dw 220;
    dw 352;
    dw 20;  // None
    dw 348;
    dw 356;

    output_offsets_ptr_loc:
    dw 360;
}

func get_ADD_EC_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 0;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 6;
    let mul_mod_n = 3;
    let n_assert_eq = 0;
    let name = 'add_ec_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 12;  // None
    dw 16;
    dw 4;
    dw 8;  // None
    dw 20;
    dw 0;
    dw 0;  // None
    dw 32;
    dw 28;
    dw 8;  // None
    dw 36;
    dw 32;
    dw 36;  // None
    dw 40;
    dw 0;
    dw 4;  // None
    dw 48;
    dw 44;

    mul_offsets_ptr_loc:
    dw 20;  // None
    dw 24;
    dw 16;
    dw 24;  // None
    dw 24;
    dw 28;
    dw 24;  // None
    dw 40;
    dw 44;

    output_offsets_ptr_loc:
    dw 36;
    dw 48;
}

func get_EVAL_FN_CHALLENGE_DUPL_3P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 112;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 39;
    let mul_mod_n = 44;
    let n_assert_eq = 0;
    let name = 'eval_fn_challenge_dupl_3P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 32;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 112;
    dw 116;
    dw 28;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 120;
    dw 124;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 128;
    dw 132;
    dw 52;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 136;
    dw 140;
    dw 48;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 144;
    dw 148;
    dw 44;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 152;
    dw 156;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 160;
    dw 164;
    dw 72;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 172;
    dw 176;
    dw 68;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 180;
    dw 184;
    dw 64;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 188;
    dw 192;
    dw 60;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 196;
    dw 200;
    dw 104;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 204;
    dw 208;
    dw 100;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 212;
    dw 216;
    dw 96;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 220;
    dw 224;
    dw 92;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 228;
    dw 232;
    dw 88;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 236;
    dw 240;
    dw 84;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 244;
    dw 248;
    dw 80;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 252;
    dw 256;
    dw 168;  // None
    dw 264;
    dw 268;
    dw 32;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 272;
    dw 276;
    dw 28;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 280;
    dw 284;
    dw 24;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 288;
    dw 292;
    dw 52;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 296;
    dw 300;
    dw 48;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 304;
    dw 308;
    dw 44;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 312;
    dw 316;
    dw 40;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 320;
    dw 324;
    dw 72;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 332;
    dw 336;
    dw 68;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 340;
    dw 344;
    dw 64;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 348;
    dw 352;
    dw 60;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 356;
    dw 360;
    dw 104;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 364;
    dw 368;
    dw 100;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 372;
    dw 376;
    dw 96;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 380;
    dw 384;
    dw 92;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 388;
    dw 392;
    dw 88;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 396;
    dw 400;
    dw 84;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 404;
    dw 408;
    dw 80;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 412;
    dw 416;
    dw 328;  // None
    dw 424;
    dw 428;
    dw 436;  // None
    dw 440;
    dw 432;

    mul_offsets_ptr_loc:
    dw 36;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 112;
    dw 116;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 120;
    dw 124;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 0;
    dw 128;
    dw 56;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 136;
    dw 140;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 144;
    dw 148;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 152;
    dw 156;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 0;
    dw 160;
    dw 164;  // None
    dw 168;
    dw 132;
    dw 76;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 172;
    dw 176;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 180;
    dw 184;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 188;
    dw 192;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 0;
    dw 196;
    dw 108;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 204;
    dw 208;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 212;
    dw 216;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 220;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 228;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 236;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 244;
    dw 248;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 0;
    dw 252;
    dw 256;  // None
    dw 260;
    dw 200;
    dw 4;  // None
    dw 260;
    dw 264;
    dw 36;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 272;
    dw 276;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 280;
    dw 284;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 8;
    dw 288;
    dw 56;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 296;
    dw 300;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 304;
    dw 308;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 312;
    dw 316;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 8;
    dw 320;
    dw 324;  // None
    dw 328;
    dw 292;
    dw 76;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 332;
    dw 336;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 340;
    dw 344;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 348;
    dw 352;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 8;
    dw 356;
    dw 108;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 364;
    dw 368;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 372;
    dw 376;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 380;
    dw 384;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 388;
    dw 392;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 396;
    dw 400;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 404;
    dw 408;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 8;
    dw 412;
    dw 416;  // None
    dw 420;
    dw 360;
    dw 12;  // None
    dw 420;
    dw 424;
    dw 16;  // None
    dw 268;
    dw 432;
    dw 20;  // None
    dw 428;
    dw 436;

    output_offsets_ptr_loc:
    dw 440;
}

func get_ACC_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 64;
    let witnesses_len = 0;
    let output_len = 40;
    let continuous_output = 0;
    let add_mod_n = 8;
    let mul_mod_n = 16;
    let n_assert_eq = 0;
    let name = 'acc_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 0;  // None
    dw 64;
    dw 68;
    dw 4;  // None
    dw 76;
    dw 80;
    dw 8;  // None
    dw 84;
    dw 88;
    dw 12;  // None
    dw 104;
    dw 108;
    dw 16;  // None
    dw 112;
    dw 116;
    dw 20;  // None
    dw 124;
    dw 128;
    dw 24;  // None
    dw 132;
    dw 136;
    dw 28;  // None
    dw 152;
    dw 156;

    mul_offsets_ptr_loc:
    dw 48;  // None
    dw 40;
    dw 64;
    dw 40;  // None
    dw 32;
    dw 72;
    dw 52;  // None
    dw 72;
    dw 76;
    dw 56;  // None
    dw 72;
    dw 84;
    dw 72;  // None
    dw 32;
    dw 92;
    dw 92;  // None
    dw 32;
    dw 96;
    dw 96;  // None
    dw 32;
    dw 100;
    dw 60;  // None
    dw 100;
    dw 104;
    dw 48;  // None
    dw 44;
    dw 112;
    dw 44;  // None
    dw 36;
    dw 120;
    dw 52;  // None
    dw 120;
    dw 124;
    dw 56;  // None
    dw 120;
    dw 132;
    dw 120;  // None
    dw 36;
    dw 140;
    dw 140;  // None
    dw 36;
    dw 144;
    dw 144;  // None
    dw 36;
    dw 148;
    dw 60;  // None
    dw 148;
    dw 152;

    output_offsets_ptr_loc:
    dw 68;
    dw 80;
    dw 88;
    dw 108;
    dw 116;
    dw 128;
    dw 136;
    dw 156;
    dw 72;
    dw 120;
}

func get_FULL_ECIP_1P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 5;
    let input_len = 168;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 95;
    let mul_mod_n = 88;
    let n_assert_eq = 0;
    let name = 'full_ecip_1P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 66632300;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 4361599596;
    dw 0;
    dw 0;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;

    add_offsets_ptr_loc:
    dw 192;  // None
    dw 92;
    dw 196;
    dw 88;  // None
    dw 88;
    dw 200;
    dw 208;  // None
    dw 212;
    dw 88;
    dw 84;  // None
    dw 84;
    dw 220;
    dw 220;  // None
    dw 224;
    dw 216;
    dw 224;  // None
    dw 228;
    dw 84;
    dw 88;  // None
    dw 236;
    dw 232;
    dw 236;  // None
    dw 240;
    dw 4;
    dw 88;  // None
    dw 244;
    dw 240;
    dw 84;  // None
    dw 248;
    dw 224;
    dw 240;  // None
    dw 240;
    dw 260;
    dw 224;  // None
    dw 264;
    dw 84;
    dw 256;  // None
    dw 256;
    dw 280;
    dw 280;  // None
    dw 284;
    dw 92;
    dw 276;  // None
    dw 284;
    dw 288;
    dw 252;  // None
    dw 252;
    dw 296;
    dw 292;  // None
    dw 296;
    dw 300;
    dw 108;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 304;
    dw 308;
    dw 104;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 312;
    dw 316;
    dw 100;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 320;
    dw 324;
    dw 128;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 328;
    dw 332;
    dw 124;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 336;
    dw 340;
    dw 120;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 344;
    dw 348;
    dw 116;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 352;
    dw 356;
    dw 148;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 364;
    dw 368;
    dw 144;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 372;
    dw 376;
    dw 140;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 380;
    dw 384;
    dw 136;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 388;
    dw 392;
    dw 180;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 396;
    dw 400;
    dw 176;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 404;
    dw 408;
    dw 172;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 412;
    dw 416;
    dw 168;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 420;
    dw 424;
    dw 164;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 428;
    dw 432;
    dw 160;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 436;
    dw 440;
    dw 156;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 444;
    dw 448;
    dw 360;  // None
    dw 456;
    dw 460;
    dw 108;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 464;
    dw 468;
    dw 104;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 472;
    dw 476;
    dw 100;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 480;
    dw 484;
    dw 128;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 488;
    dw 492;
    dw 124;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 496;
    dw 500;
    dw 120;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 504;
    dw 508;
    dw 116;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 512;
    dw 516;
    dw 148;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 524;
    dw 528;
    dw 144;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 532;
    dw 536;
    dw 140;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 540;
    dw 544;
    dw 136;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 548;
    dw 552;
    dw 180;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 556;
    dw 560;
    dw 176;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 564;
    dw 568;
    dw 172;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 572;
    dw 576;
    dw 168;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 580;
    dw 584;
    dw 164;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 588;
    dw 592;
    dw 160;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 596;
    dw 600;
    dw 156;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 604;
    dw 608;
    dw 520;  // None
    dw 616;
    dw 620;
    dw 628;  // None
    dw 632;
    dw 624;
    dw 20;  // None
    dw 636;
    dw 84;
    dw 640;  // None
    dw 212;
    dw 644;
    dw 644;  // None
    dw 648;
    dw 24;
    dw 24;  // None
    dw 652;
    dw 4;
    dw 644;  // None
    dw 656;
    dw 652;
    dw 668;  // None
    dw 680;
    dw 684;
    dw 4;  // None
    dw 684;
    dw 688;
    dw 60;  // None
    dw 692;
    dw 84;
    dw 696;  // None
    dw 212;
    dw 700;
    dw 64;  // None
    dw 704;
    dw 4;
    dw 700;  // None
    dw 708;
    dw 704;
    dw 688;  // None
    dw 712;
    dw 716;
    dw 20;  // None
    dw 720;
    dw 84;
    dw 724;  // None
    dw 212;
    dw 728;
    dw 728;  // None
    dw 732;
    dw 24;
    dw 24;  // None
    dw 736;
    dw 4;
    dw 728;  // None
    dw 740;
    dw 736;
    dw 752;  // None
    dw 764;
    dw 768;
    dw 4;  // None
    dw 768;
    dw 772;
    dw 68;  // None
    dw 776;
    dw 84;
    dw 780;  // None
    dw 212;
    dw 784;
    dw 72;  // None
    dw 788;
    dw 4;
    dw 784;  // None
    dw 792;
    dw 788;
    dw 772;  // None
    dw 796;
    dw 800;
    dw 76;  // None
    dw 804;
    dw 84;
    dw 808;  // None
    dw 212;
    dw 812;
    dw 812;  // None
    dw 816;
    dw 80;
    dw 80;  // None
    dw 820;
    dw 4;
    dw 812;  // None
    dw 824;
    dw 820;
    dw 836;  // None
    dw 848;
    dw 852;
    dw 4;  // None
    dw 852;
    dw 856;
    dw 76;  // None
    dw 860;
    dw 84;
    dw 864;  // None
    dw 212;
    dw 868;
    dw 80;  // None
    dw 872;
    dw 4;
    dw 868;  // None
    dw 876;
    dw 872;
    dw 856;  // None
    dw 880;
    dw 884;
    dw 896;  // None
    dw 900;
    dw 908;
    dw 908;  // None
    dw 904;
    dw 912;
    dw 912;  // None
    dw 916;
    dw 632;

    mul_offsets_ptr_loc:
    dw 84;  // None
    dw 84;
    dw 188;
    dw 0;  // None
    dw 188;
    dw 192;
    dw 200;  // None
    dw 204;
    dw 196;
    dw 84;  // None
    dw 204;
    dw 208;
    dw 204;  // None
    dw 204;
    dw 216;
    dw 204;  // None
    dw 228;
    dw 232;
    dw 248;  // None
    dw 252;
    dw 244;
    dw 252;  // None
    dw 240;
    dw 256;
    dw 260;  // None
    dw 264;
    dw 268;
    dw 224;  // None
    dw 224;
    dw 272;
    dw 0;  // None
    dw 272;
    dw 276;
    dw 288;  // None
    dw 292;
    dw 268;
    dw 112;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 84;
    dw 304;
    dw 308;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 84;
    dw 312;
    dw 316;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 84;
    dw 320;
    dw 132;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 328;
    dw 332;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 336;
    dw 340;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 344;
    dw 348;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 352;
    dw 356;  // None
    dw 360;
    dw 324;
    dw 152;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 364;
    dw 368;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 372;
    dw 376;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 380;
    dw 384;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 388;
    dw 184;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 396;
    dw 400;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 404;
    dw 408;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 412;
    dw 416;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 420;
    dw 424;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 428;
    dw 432;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 436;
    dw 440;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 444;
    dw 448;  // None
    dw 452;
    dw 392;
    dw 88;  // None
    dw 452;
    dw 456;
    dw 112;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 224;
    dw 464;
    dw 468;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 224;
    dw 472;
    dw 476;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 224;
    dw 480;
    dw 132;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 488;
    dw 492;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 496;
    dw 500;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 504;
    dw 508;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 512;
    dw 516;  // None
    dw 520;
    dw 484;
    dw 152;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 524;
    dw 528;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 532;
    dw 536;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 540;
    dw 544;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 548;
    dw 184;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 556;
    dw 560;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 564;
    dw 568;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 572;
    dw 576;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 580;
    dw 584;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 588;
    dw 592;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 596;
    dw 600;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 604;
    dw 608;  // None
    dw 612;
    dw 552;
    dw 240;  // None
    dw 612;
    dw 616;
    dw 300;  // None
    dw 460;
    dw 624;
    dw 292;  // None
    dw 620;
    dw 628;
    dw 204;  // None
    dw 20;
    dw 640;
    dw 36;  // None
    dw 28;
    dw 660;
    dw 648;  // None
    dw 664;
    dw 636;
    dw 660;  // None
    dw 664;
    dw 668;
    dw 40;  // None
    dw 32;
    dw 672;
    dw 656;  // None
    dw 676;
    dw 636;
    dw 672;  // None
    dw 676;
    dw 680;
    dw 204;  // None
    dw 60;
    dw 696;
    dw 708;  // None
    dw 712;
    dw 692;
    dw 204;  // None
    dw 20;
    dw 724;
    dw 52;  // None
    dw 44;
    dw 744;
    dw 732;  // None
    dw 748;
    dw 720;
    dw 744;  // None
    dw 748;
    dw 752;
    dw 56;  // None
    dw 48;
    dw 756;
    dw 740;  // None
    dw 760;
    dw 720;
    dw 756;  // None
    dw 760;
    dw 764;
    dw 204;  // None
    dw 68;
    dw 780;
    dw 792;  // None
    dw 796;
    dw 776;
    dw 204;  // None
    dw 76;
    dw 808;
    dw 16;  // None
    dw 8;
    dw 828;
    dw 816;  // None
    dw 832;
    dw 804;
    dw 828;  // None
    dw 832;
    dw 836;
    dw 16;  // None
    dw 12;
    dw 840;
    dw 824;  // None
    dw 844;
    dw 804;
    dw 840;  // None
    dw 844;
    dw 848;
    dw 204;  // None
    dw 76;
    dw 864;
    dw 876;  // None
    dw 880;
    dw 860;
    dw 96;  // None
    dw 96;
    dw 888;
    dw 888;  // None
    dw 96;
    dw 892;
    dw 716;  // None
    dw 96;
    dw 896;
    dw 800;  // None
    dw 888;
    dw 900;
    dw 884;  // None
    dw 892;
    dw 904;

    output_offsets_ptr_loc:
    dw 916;
}

func get_FULL_ECIP_1P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 5;
    let input_len = 168;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 95;
    let mul_mod_n = 88;
    let n_assert_eq = 0;
    let name = 'full_ecip_1P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 66632300;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 4361599596;
    dw 0;
    dw 0;
    dw 32324006162389411176778628422;
    dw 57042285082623239461879769745;
    dw 3486998266802970665;
    dw 0;

    add_offsets_ptr_loc:
    dw 192;  // None
    dw 92;
    dw 196;
    dw 88;  // None
    dw 88;
    dw 200;
    dw 208;  // None
    dw 212;
    dw 88;
    dw 84;  // None
    dw 84;
    dw 220;
    dw 220;  // None
    dw 224;
    dw 216;
    dw 224;  // None
    dw 228;
    dw 84;
    dw 88;  // None
    dw 236;
    dw 232;
    dw 236;  // None
    dw 240;
    dw 4;
    dw 88;  // None
    dw 244;
    dw 240;
    dw 84;  // None
    dw 248;
    dw 224;
    dw 240;  // None
    dw 240;
    dw 260;
    dw 224;  // None
    dw 264;
    dw 84;
    dw 256;  // None
    dw 256;
    dw 280;
    dw 280;  // None
    dw 284;
    dw 92;
    dw 276;  // None
    dw 284;
    dw 288;
    dw 252;  // None
    dw 252;
    dw 296;
    dw 292;  // None
    dw 296;
    dw 300;
    dw 108;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 304;
    dw 308;
    dw 104;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 312;
    dw 316;
    dw 100;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 320;
    dw 324;
    dw 128;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 328;
    dw 332;
    dw 124;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 336;
    dw 340;
    dw 120;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 344;
    dw 348;
    dw 116;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 352;
    dw 356;
    dw 148;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 364;
    dw 368;
    dw 144;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 372;
    dw 376;
    dw 140;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 380;
    dw 384;
    dw 136;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 388;
    dw 392;
    dw 180;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 396;
    dw 400;
    dw 176;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 404;
    dw 408;
    dw 172;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 412;
    dw 416;
    dw 168;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 420;
    dw 424;
    dw 164;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 428;
    dw 432;
    dw 160;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 436;
    dw 440;
    dw 156;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 444;
    dw 448;
    dw 360;  // None
    dw 456;
    dw 460;
    dw 108;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 464;
    dw 468;
    dw 104;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 472;
    dw 476;
    dw 100;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 480;
    dw 484;
    dw 128;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 488;
    dw 492;
    dw 124;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 496;
    dw 500;
    dw 120;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 504;
    dw 508;
    dw 116;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 512;
    dw 516;
    dw 148;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 524;
    dw 528;
    dw 144;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 532;
    dw 536;
    dw 140;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 540;
    dw 544;
    dw 136;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 548;
    dw 552;
    dw 180;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 556;
    dw 560;
    dw 176;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 564;
    dw 568;
    dw 172;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 572;
    dw 576;
    dw 168;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 580;
    dw 584;
    dw 164;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 588;
    dw 592;
    dw 160;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 596;
    dw 600;
    dw 156;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 604;
    dw 608;
    dw 520;  // None
    dw 616;
    dw 620;
    dw 628;  // None
    dw 632;
    dw 624;
    dw 20;  // None
    dw 636;
    dw 84;
    dw 640;  // None
    dw 212;
    dw 644;
    dw 644;  // None
    dw 648;
    dw 24;
    dw 24;  // None
    dw 652;
    dw 4;
    dw 644;  // None
    dw 656;
    dw 652;
    dw 668;  // None
    dw 680;
    dw 684;
    dw 4;  // None
    dw 684;
    dw 688;
    dw 60;  // None
    dw 692;
    dw 84;
    dw 696;  // None
    dw 212;
    dw 700;
    dw 64;  // None
    dw 704;
    dw 4;
    dw 700;  // None
    dw 708;
    dw 704;
    dw 688;  // None
    dw 712;
    dw 716;
    dw 20;  // None
    dw 720;
    dw 84;
    dw 724;  // None
    dw 212;
    dw 728;
    dw 728;  // None
    dw 732;
    dw 24;
    dw 24;  // None
    dw 736;
    dw 4;
    dw 728;  // None
    dw 740;
    dw 736;
    dw 752;  // None
    dw 764;
    dw 768;
    dw 4;  // None
    dw 768;
    dw 772;
    dw 68;  // None
    dw 776;
    dw 84;
    dw 780;  // None
    dw 212;
    dw 784;
    dw 72;  // None
    dw 788;
    dw 4;
    dw 784;  // None
    dw 792;
    dw 788;
    dw 772;  // None
    dw 796;
    dw 800;
    dw 76;  // None
    dw 804;
    dw 84;
    dw 808;  // None
    dw 212;
    dw 812;
    dw 812;  // None
    dw 816;
    dw 80;
    dw 80;  // None
    dw 820;
    dw 4;
    dw 812;  // None
    dw 824;
    dw 820;
    dw 836;  // None
    dw 848;
    dw 852;
    dw 4;  // None
    dw 852;
    dw 856;
    dw 76;  // None
    dw 860;
    dw 84;
    dw 864;  // None
    dw 212;
    dw 868;
    dw 80;  // None
    dw 872;
    dw 4;
    dw 868;  // None
    dw 876;
    dw 872;
    dw 856;  // None
    dw 880;
    dw 884;
    dw 896;  // None
    dw 900;
    dw 908;
    dw 908;  // None
    dw 904;
    dw 912;
    dw 912;  // None
    dw 916;
    dw 632;

    mul_offsets_ptr_loc:
    dw 84;  // None
    dw 84;
    dw 188;
    dw 0;  // None
    dw 188;
    dw 192;
    dw 200;  // None
    dw 204;
    dw 196;
    dw 84;  // None
    dw 204;
    dw 208;
    dw 204;  // None
    dw 204;
    dw 216;
    dw 204;  // None
    dw 228;
    dw 232;
    dw 248;  // None
    dw 252;
    dw 244;
    dw 252;  // None
    dw 240;
    dw 256;
    dw 260;  // None
    dw 264;
    dw 268;
    dw 224;  // None
    dw 224;
    dw 272;
    dw 0;  // None
    dw 272;
    dw 276;
    dw 288;  // None
    dw 292;
    dw 268;
    dw 112;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 84;
    dw 304;
    dw 308;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 84;
    dw 312;
    dw 316;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 84;
    dw 320;
    dw 132;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 328;
    dw 332;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 336;
    dw 340;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 344;
    dw 348;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 84;
    dw 352;
    dw 356;  // None
    dw 360;
    dw 324;
    dw 152;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 364;
    dw 368;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 372;
    dw 376;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 380;
    dw 384;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 84;
    dw 388;
    dw 184;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 396;
    dw 400;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 404;
    dw 408;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 412;
    dw 416;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 420;
    dw 424;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 428;
    dw 432;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 436;
    dw 440;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 84;
    dw 444;
    dw 448;  // None
    dw 452;
    dw 392;
    dw 88;  // None
    dw 452;
    dw 456;
    dw 112;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 224;
    dw 464;
    dw 468;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 224;
    dw 472;
    dw 476;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 224;
    dw 480;
    dw 132;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 488;
    dw 492;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 496;
    dw 500;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 504;
    dw 508;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 224;
    dw 512;
    dw 516;  // None
    dw 520;
    dw 484;
    dw 152;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 524;
    dw 528;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 532;
    dw 536;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 540;
    dw 544;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 224;
    dw 548;
    dw 184;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 556;
    dw 560;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 564;
    dw 568;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 572;
    dw 576;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 580;
    dw 584;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 588;
    dw 592;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 596;
    dw 600;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 224;
    dw 604;
    dw 608;  // None
    dw 612;
    dw 552;
    dw 240;  // None
    dw 612;
    dw 616;
    dw 300;  // None
    dw 460;
    dw 624;
    dw 292;  // None
    dw 620;
    dw 628;
    dw 204;  // None
    dw 20;
    dw 640;
    dw 36;  // None
    dw 28;
    dw 660;
    dw 648;  // None
    dw 664;
    dw 636;
    dw 660;  // None
    dw 664;
    dw 668;
    dw 40;  // None
    dw 32;
    dw 672;
    dw 656;  // None
    dw 676;
    dw 636;
    dw 672;  // None
    dw 676;
    dw 680;
    dw 204;  // None
    dw 60;
    dw 696;
    dw 708;  // None
    dw 712;
    dw 692;
    dw 204;  // None
    dw 20;
    dw 724;
    dw 52;  // None
    dw 44;
    dw 744;
    dw 732;  // None
    dw 748;
    dw 720;
    dw 744;  // None
    dw 748;
    dw 752;
    dw 56;  // None
    dw 48;
    dw 756;
    dw 740;  // None
    dw 760;
    dw 720;
    dw 756;  // None
    dw 760;
    dw 764;
    dw 204;  // None
    dw 68;
    dw 780;
    dw 792;  // None
    dw 796;
    dw 776;
    dw 204;  // None
    dw 76;
    dw 808;
    dw 16;  // None
    dw 8;
    dw 828;
    dw 816;  // None
    dw 832;
    dw 804;
    dw 828;  // None
    dw 832;
    dw 836;
    dw 16;  // None
    dw 12;
    dw 840;
    dw 824;  // None
    dw 844;
    dw 804;
    dw 840;  // None
    dw 844;
    dw 848;
    dw 204;  // None
    dw 76;
    dw 864;
    dw 876;  // None
    dw 880;
    dw 860;
    dw 96;  // None
    dw 96;
    dw 888;
    dw 888;  // None
    dw 96;
    dw 892;
    dw 716;  // None
    dw 96;
    dw 896;
    dw 800;  // None
    dw 888;
    dw 900;
    dw 884;  // None
    dw 892;
    dw 904;

    output_offsets_ptr_loc:
    dw 916;
}

func get_FULL_ECIP_2P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 5;
    let input_len = 224;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 117;
    let mul_mod_n = 110;
    let n_assert_eq = 0;
    let name = 'full_ecip_2P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 66632300;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 4361599596;
    dw 0;
    dw 0;
    dw 32324006162389411176778628422;
    dw 57042285082623239461879769745;
    dw 3486998266802970665;
    dw 0;

    add_offsets_ptr_loc:
    dw 248;  // None
    dw 132;
    dw 252;
    dw 128;  // None
    dw 128;
    dw 256;
    dw 264;  // None
    dw 268;
    dw 128;
    dw 124;  // None
    dw 124;
    dw 276;
    dw 276;  // None
    dw 280;
    dw 272;
    dw 280;  // None
    dw 284;
    dw 124;
    dw 128;  // None
    dw 292;
    dw 288;
    dw 292;  // None
    dw 296;
    dw 4;
    dw 128;  // None
    dw 300;
    dw 296;
    dw 124;  // None
    dw 304;
    dw 280;
    dw 296;  // None
    dw 296;
    dw 316;
    dw 280;  // None
    dw 320;
    dw 124;
    dw 312;  // None
    dw 312;
    dw 336;
    dw 336;  // None
    dw 340;
    dw 132;
    dw 332;  // None
    dw 340;
    dw 344;
    dw 308;  // None
    dw 308;
    dw 352;
    dw 348;  // None
    dw 352;
    dw 356;
    dw 152;  // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    dw 360;
    dw 364;
    dw 148;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 368;
    dw 372;
    dw 144;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 376;
    dw 380;
    dw 140;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 384;
    dw 388;
    dw 176;  // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    dw 392;
    dw 396;
    dw 172;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 400;
    dw 404;
    dw 168;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 408;
    dw 412;
    dw 164;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 416;
    dw 420;
    dw 160;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 424;
    dw 428;
    dw 200;  // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    dw 436;
    dw 440;
    dw 196;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 444;
    dw 448;
    dw 192;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 452;
    dw 456;
    dw 188;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 460;
    dw 464;
    dw 184;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 468;
    dw 472;
    dw 236;  // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    dw 476;
    dw 480;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 484;
    dw 488;
    dw 228;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 492;
    dw 496;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 500;
    dw 504;
    dw 220;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 508;
    dw 512;
    dw 216;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 516;
    dw 520;
    dw 212;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 524;
    dw 528;
    dw 208;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 532;
    dw 536;
    dw 432;  // None
    dw 544;
    dw 548;
    dw 152;  // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    dw 552;
    dw 556;
    dw 148;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 560;
    dw 564;
    dw 144;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 568;
    dw 572;
    dw 140;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 576;
    dw 580;
    dw 176;  // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    dw 584;
    dw 588;
    dw 172;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 592;
    dw 596;
    dw 168;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 600;
    dw 604;
    dw 164;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 608;
    dw 612;
    dw 160;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 616;
    dw 620;
    dw 200;  // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    dw 628;
    dw 632;
    dw 196;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 636;
    dw 640;
    dw 192;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 644;
    dw 648;
    dw 188;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 652;
    dw 656;
    dw 184;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 660;
    dw 664;
    dw 236;  // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    dw 668;
    dw 672;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 676;
    dw 680;
    dw 228;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 684;
    dw 688;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 692;
    dw 696;
    dw 220;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 700;
    dw 704;
    dw 216;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 708;
    dw 712;
    dw 212;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 716;
    dw 720;
    dw 208;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 724;
    dw 728;
    dw 624;  // None
    dw 736;
    dw 740;
    dw 748;  // None
    dw 752;
    dw 744;
    dw 20;  // None
    dw 756;
    dw 124;
    dw 760;  // None
    dw 268;
    dw 764;
    dw 764;  // None
    dw 768;
    dw 24;
    dw 24;  // None
    dw 772;
    dw 4;
    dw 764;  // None
    dw 776;
    dw 772;
    dw 788;  // None
    dw 800;
    dw 804;
    dw 4;  // None
    dw 804;
    dw 808;
    dw 28;  // None
    dw 812;
    dw 124;
    dw 816;  // None
    dw 268;
    dw 820;
    dw 820;  // None
    dw 824;
    dw 32;
    dw 32;  // None
    dw 828;
    dw 4;
    dw 820;  // None
    dw 832;
    dw 828;
    dw 844;  // None
    dw 856;
    dw 860;
    dw 808;  // None
    dw 860;
    dw 864;
    dw 100;  // None
    dw 868;
    dw 124;
    dw 872;  // None
    dw 268;
    dw 876;
    dw 104;  // None
    dw 880;
    dw 4;
    dw 876;  // None
    dw 884;
    dw 880;
    dw 864;  // None
    dw 888;
    dw 892;
    dw 20;  // None
    dw 896;
    dw 124;
    dw 900;  // None
    dw 268;
    dw 904;
    dw 904;  // None
    dw 908;
    dw 24;
    dw 24;  // None
    dw 912;
    dw 4;
    dw 904;  // None
    dw 916;
    dw 912;
    dw 928;  // None
    dw 940;
    dw 944;
    dw 4;  // None
    dw 944;
    dw 948;
    dw 28;  // None
    dw 952;
    dw 124;
    dw 956;  // None
    dw 268;
    dw 960;
    dw 960;  // None
    dw 964;
    dw 32;
    dw 32;  // None
    dw 968;
    dw 4;
    dw 960;  // None
    dw 972;
    dw 968;
    dw 984;  // None
    dw 996;
    dw 1000;
    dw 948;  // None
    dw 1000;
    dw 1004;
    dw 108;  // None
    dw 1008;
    dw 124;
    dw 1012;  // None
    dw 268;
    dw 1016;
    dw 112;  // None
    dw 1020;
    dw 4;
    dw 1016;  // None
    dw 1024;
    dw 1020;
    dw 1004;  // None
    dw 1028;
    dw 1032;
    dw 116;  // None
    dw 1036;
    dw 124;
    dw 1040;  // None
    dw 268;
    dw 1044;
    dw 1044;  // None
    dw 1048;
    dw 120;
    dw 120;  // None
    dw 1052;
    dw 4;
    dw 1044;  // None
    dw 1056;
    dw 1052;
    dw 1068;  // None
    dw 1080;
    dw 1084;
    dw 4;  // None
    dw 1084;
    dw 1088;
    dw 116;  // None
    dw 1092;
    dw 124;
    dw 1096;  // None
    dw 268;
    dw 1100;
    dw 120;  // None
    dw 1104;
    dw 4;
    dw 1100;  // None
    dw 1108;
    dw 1104;
    dw 1088;  // None
    dw 1112;
    dw 1116;
    dw 1128;  // None
    dw 1132;
    dw 1140;
    dw 1140;  // None
    dw 1136;
    dw 1144;
    dw 1144;  // None
    dw 1148;
    dw 752;

    mul_offsets_ptr_loc:
    dw 124;  // None
    dw 124;
    dw 244;
    dw 0;  // None
    dw 244;
    dw 248;
    dw 256;  // None
    dw 260;
    dw 252;
    dw 124;  // None
    dw 260;
    dw 264;
    dw 260;  // None
    dw 260;
    dw 272;
    dw 260;  // None
    dw 284;
    dw 288;
    dw 304;  // None
    dw 308;
    dw 300;
    dw 308;  // None
    dw 296;
    dw 312;
    dw 316;  // None
    dw 320;
    dw 324;
    dw 280;  // None
    dw 280;
    dw 328;
    dw 0;  // None
    dw 328;
    dw 332;
    dw 344;  // None
    dw 348;
    dw 324;
    dw 156;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 360;
    dw 364;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 368;
    dw 372;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 376;
    dw 380;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 384;
    dw 180;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 392;
    dw 396;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 400;
    dw 404;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 408;
    dw 412;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 416;
    dw 420;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 424;
    dw 428;  // None
    dw 432;
    dw 388;
    dw 204;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 436;
    dw 440;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 444;
    dw 448;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 452;
    dw 456;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 460;
    dw 464;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 468;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 476;
    dw 480;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 484;
    dw 488;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 492;
    dw 496;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 500;
    dw 504;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 508;
    dw 512;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 516;
    dw 520;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 524;
    dw 528;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 532;
    dw 536;  // None
    dw 540;
    dw 472;
    dw 128;  // None
    dw 540;
    dw 544;
    dw 156;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 552;
    dw 556;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 560;
    dw 564;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 568;
    dw 572;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 576;
    dw 180;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 584;
    dw 588;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 592;
    dw 596;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 600;
    dw 604;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 608;
    dw 612;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 616;
    dw 620;  // None
    dw 624;
    dw 580;
    dw 204;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 628;
    dw 632;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 636;
    dw 640;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 644;
    dw 648;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 652;
    dw 656;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 660;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 668;
    dw 672;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 676;
    dw 680;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 684;
    dw 688;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 692;
    dw 696;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 700;
    dw 704;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 708;
    dw 712;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 716;
    dw 720;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 724;
    dw 728;  // None
    dw 732;
    dw 664;
    dw 296;  // None
    dw 732;
    dw 736;
    dw 356;  // None
    dw 548;
    dw 744;
    dw 348;  // None
    dw 740;
    dw 748;
    dw 260;  // None
    dw 20;
    dw 760;
    dw 44;  // None
    dw 36;
    dw 780;
    dw 768;  // None
    dw 784;
    dw 756;
    dw 780;  // None
    dw 784;
    dw 788;
    dw 48;  // None
    dw 40;
    dw 792;
    dw 776;  // None
    dw 796;
    dw 756;
    dw 792;  // None
    dw 796;
    dw 800;
    dw 260;  // None
    dw 28;
    dw 816;
    dw 60;  // None
    dw 52;
    dw 836;
    dw 824;  // None
    dw 840;
    dw 812;
    dw 836;  // None
    dw 840;
    dw 844;
    dw 64;  // None
    dw 56;
    dw 848;
    dw 832;  // None
    dw 852;
    dw 812;
    dw 848;  // None
    dw 852;
    dw 856;
    dw 260;  // None
    dw 100;
    dw 872;
    dw 884;  // None
    dw 888;
    dw 868;
    dw 260;  // None
    dw 20;
    dw 900;
    dw 76;  // None
    dw 68;
    dw 920;
    dw 908;  // None
    dw 924;
    dw 896;
    dw 920;  // None
    dw 924;
    dw 928;
    dw 80;  // None
    dw 72;
    dw 932;
    dw 916;  // None
    dw 936;
    dw 896;
    dw 932;  // None
    dw 936;
    dw 940;
    dw 260;  // None
    dw 28;
    dw 956;
    dw 92;  // None
    dw 84;
    dw 976;
    dw 964;  // None
    dw 980;
    dw 952;
    dw 976;  // None
    dw 980;
    dw 984;
    dw 96;  // None
    dw 88;
    dw 988;
    dw 972;  // None
    dw 992;
    dw 952;
    dw 988;  // None
    dw 992;
    dw 996;
    dw 260;  // None
    dw 108;
    dw 1012;
    dw 1024;  // None
    dw 1028;
    dw 1008;
    dw 260;  // None
    dw 116;
    dw 1040;
    dw 16;  // None
    dw 8;
    dw 1060;
    dw 1048;  // None
    dw 1064;
    dw 1036;
    dw 1060;  // None
    dw 1064;
    dw 1068;
    dw 16;  // None
    dw 12;
    dw 1072;
    dw 1056;  // None
    dw 1076;
    dw 1036;
    dw 1072;  // None
    dw 1076;
    dw 1080;
    dw 260;  // None
    dw 116;
    dw 1096;
    dw 1108;  // None
    dw 1112;
    dw 1092;
    dw 136;  // None
    dw 136;
    dw 1120;
    dw 1120;  // None
    dw 136;
    dw 1124;
    dw 892;  // None
    dw 136;
    dw 1128;
    dw 1032;  // None
    dw 1120;
    dw 1132;
    dw 1116;  // None
    dw 1124;
    dw 1136;

    output_offsets_ptr_loc:
    dw 1148;
}

func get_FULL_ECIP_2P_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 5;
    let input_len = 224;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 117;
    let mul_mod_n = 110;
    let n_assert_eq = 0;
    let name = 'full_ecip_2P';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 66632300;
    dw 0;
    dw 0;
    dw 12528508628158887531275213211;
    dw 4361599596;
    dw 0;
    dw 0;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;

    add_offsets_ptr_loc:
    dw 248;  // None
    dw 132;
    dw 252;
    dw 128;  // None
    dw 128;
    dw 256;
    dw 264;  // None
    dw 268;
    dw 128;
    dw 124;  // None
    dw 124;
    dw 276;
    dw 276;  // None
    dw 280;
    dw 272;
    dw 280;  // None
    dw 284;
    dw 124;
    dw 128;  // None
    dw 292;
    dw 288;
    dw 292;  // None
    dw 296;
    dw 4;
    dw 128;  // None
    dw 300;
    dw 296;
    dw 124;  // None
    dw 304;
    dw 280;
    dw 296;  // None
    dw 296;
    dw 316;
    dw 280;  // None
    dw 320;
    dw 124;
    dw 312;  // None
    dw 312;
    dw 336;
    dw 336;  // None
    dw 340;
    dw 132;
    dw 332;  // None
    dw 340;
    dw 344;
    dw 308;  // None
    dw 308;
    dw 352;
    dw 348;  // None
    dw 352;
    dw 356;
    dw 152;  // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    dw 360;
    dw 364;
    dw 148;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 368;
    dw 372;
    dw 144;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 376;
    dw 380;
    dw 140;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 384;
    dw 388;
    dw 176;  // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    dw 392;
    dw 396;
    dw 172;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 400;
    dw 404;
    dw 168;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 408;
    dw 412;
    dw 164;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 416;
    dw 420;
    dw 160;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 424;
    dw 428;
    dw 200;  // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    dw 436;
    dw 440;
    dw 196;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 444;
    dw 448;
    dw 192;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 452;
    dw 456;
    dw 188;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 460;
    dw 464;
    dw 184;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 468;
    dw 472;
    dw 236;  // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    dw 476;
    dw 480;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 484;
    dw 488;
    dw 228;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 492;
    dw 496;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 500;
    dw 504;
    dw 220;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 508;
    dw 512;
    dw 216;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 516;
    dw 520;
    dw 212;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 524;
    dw 528;
    dw 208;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 532;
    dw 536;
    dw 432;  // None
    dw 544;
    dw 548;
    dw 152;  // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    dw 552;
    dw 556;
    dw 148;  // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    dw 560;
    dw 564;
    dw 144;  // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    dw 568;
    dw 572;
    dw 140;  // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    dw 576;
    dw 580;
    dw 176;  // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    dw 584;
    dw 588;
    dw 172;  // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    dw 592;
    dw 596;
    dw 168;  // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    dw 600;
    dw 604;
    dw 164;  // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    dw 608;
    dw 612;
    dw 160;  // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    dw 616;
    dw 620;
    dw 200;  // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    dw 628;
    dw 632;
    dw 196;  // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    dw 636;
    dw 640;
    dw 192;  // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    dw 644;
    dw 648;
    dw 188;  // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    dw 652;
    dw 656;
    dw 184;  // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    dw 660;
    dw 664;
    dw 236;  // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    dw 668;
    dw 672;
    dw 232;  // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    dw 676;
    dw 680;
    dw 228;  // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    dw 684;
    dw 688;
    dw 224;  // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    dw 692;
    dw 696;
    dw 220;  // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    dw 700;
    dw 704;
    dw 216;  // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    dw 708;
    dw 712;
    dw 212;  // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    dw 716;
    dw 720;
    dw 208;  // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    dw 724;
    dw 728;
    dw 624;  // None
    dw 736;
    dw 740;
    dw 748;  // None
    dw 752;
    dw 744;
    dw 20;  // None
    dw 756;
    dw 124;
    dw 760;  // None
    dw 268;
    dw 764;
    dw 764;  // None
    dw 768;
    dw 24;
    dw 24;  // None
    dw 772;
    dw 4;
    dw 764;  // None
    dw 776;
    dw 772;
    dw 788;  // None
    dw 800;
    dw 804;
    dw 4;  // None
    dw 804;
    dw 808;
    dw 28;  // None
    dw 812;
    dw 124;
    dw 816;  // None
    dw 268;
    dw 820;
    dw 820;  // None
    dw 824;
    dw 32;
    dw 32;  // None
    dw 828;
    dw 4;
    dw 820;  // None
    dw 832;
    dw 828;
    dw 844;  // None
    dw 856;
    dw 860;
    dw 808;  // None
    dw 860;
    dw 864;
    dw 100;  // None
    dw 868;
    dw 124;
    dw 872;  // None
    dw 268;
    dw 876;
    dw 104;  // None
    dw 880;
    dw 4;
    dw 876;  // None
    dw 884;
    dw 880;
    dw 864;  // None
    dw 888;
    dw 892;
    dw 20;  // None
    dw 896;
    dw 124;
    dw 900;  // None
    dw 268;
    dw 904;
    dw 904;  // None
    dw 908;
    dw 24;
    dw 24;  // None
    dw 912;
    dw 4;
    dw 904;  // None
    dw 916;
    dw 912;
    dw 928;  // None
    dw 940;
    dw 944;
    dw 4;  // None
    dw 944;
    dw 948;
    dw 28;  // None
    dw 952;
    dw 124;
    dw 956;  // None
    dw 268;
    dw 960;
    dw 960;  // None
    dw 964;
    dw 32;
    dw 32;  // None
    dw 968;
    dw 4;
    dw 960;  // None
    dw 972;
    dw 968;
    dw 984;  // None
    dw 996;
    dw 1000;
    dw 948;  // None
    dw 1000;
    dw 1004;
    dw 108;  // None
    dw 1008;
    dw 124;
    dw 1012;  // None
    dw 268;
    dw 1016;
    dw 112;  // None
    dw 1020;
    dw 4;
    dw 1016;  // None
    dw 1024;
    dw 1020;
    dw 1004;  // None
    dw 1028;
    dw 1032;
    dw 116;  // None
    dw 1036;
    dw 124;
    dw 1040;  // None
    dw 268;
    dw 1044;
    dw 1044;  // None
    dw 1048;
    dw 120;
    dw 120;  // None
    dw 1052;
    dw 4;
    dw 1044;  // None
    dw 1056;
    dw 1052;
    dw 1068;  // None
    dw 1080;
    dw 1084;
    dw 4;  // None
    dw 1084;
    dw 1088;
    dw 116;  // None
    dw 1092;
    dw 124;
    dw 1096;  // None
    dw 268;
    dw 1100;
    dw 120;  // None
    dw 1104;
    dw 4;
    dw 1100;  // None
    dw 1108;
    dw 1104;
    dw 1088;  // None
    dw 1112;
    dw 1116;
    dw 1128;  // None
    dw 1132;
    dw 1140;
    dw 1140;  // None
    dw 1136;
    dw 1144;
    dw 1144;  // None
    dw 1148;
    dw 752;

    mul_offsets_ptr_loc:
    dw 124;  // None
    dw 124;
    dw 244;
    dw 0;  // None
    dw 244;
    dw 248;
    dw 256;  // None
    dw 260;
    dw 252;
    dw 124;  // None
    dw 260;
    dw 264;
    dw 260;  // None
    dw 260;
    dw 272;
    dw 260;  // None
    dw 284;
    dw 288;
    dw 304;  // None
    dw 308;
    dw 300;
    dw 308;  // None
    dw 296;
    dw 312;
    dw 316;  // None
    dw 320;
    dw 324;
    dw 280;  // None
    dw 280;
    dw 328;
    dw 0;  // None
    dw 328;
    dw 332;
    dw 344;  // None
    dw 348;
    dw 324;
    dw 156;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 360;
    dw 364;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 368;
    dw 372;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 376;
    dw 380;  // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    dw 124;
    dw 384;
    dw 180;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 392;
    dw 396;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 400;
    dw 404;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 408;
    dw 412;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 416;
    dw 420;  // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    dw 124;
    dw 424;
    dw 428;  // None
    dw 432;
    dw 388;
    dw 204;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 436;
    dw 440;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 444;
    dw 448;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 452;
    dw 456;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 460;
    dw 464;  // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    dw 124;
    dw 468;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 476;
    dw 480;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 484;
    dw 488;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 492;
    dw 496;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 500;
    dw 504;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 508;
    dw 512;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 516;
    dw 520;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 524;
    dw 528;  // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    dw 124;
    dw 532;
    dw 536;  // None
    dw 540;
    dw 472;
    dw 128;  // None
    dw 540;
    dw 544;
    dw 156;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 552;
    dw 556;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 560;
    dw 564;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 568;
    dw 572;  // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    dw 280;
    dw 576;
    dw 180;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 584;
    dw 588;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 592;
    dw 596;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 600;
    dw 604;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 608;
    dw 612;  // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    dw 280;
    dw 616;
    dw 620;  // None
    dw 624;
    dw 580;
    dw 204;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 628;
    dw 632;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 636;
    dw 640;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 644;
    dw 648;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 652;
    dw 656;  // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    dw 280;
    dw 660;
    dw 240;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 668;
    dw 672;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 676;
    dw 680;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 684;
    dw 688;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 692;
    dw 696;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 700;
    dw 704;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 708;
    dw 712;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 716;
    dw 720;  // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    dw 280;
    dw 724;
    dw 728;  // None
    dw 732;
    dw 664;
    dw 296;  // None
    dw 732;
    dw 736;
    dw 356;  // None
    dw 548;
    dw 744;
    dw 348;  // None
    dw 740;
    dw 748;
    dw 260;  // None
    dw 20;
    dw 760;
    dw 44;  // None
    dw 36;
    dw 780;
    dw 768;  // None
    dw 784;
    dw 756;
    dw 780;  // None
    dw 784;
    dw 788;
    dw 48;  // None
    dw 40;
    dw 792;
    dw 776;  // None
    dw 796;
    dw 756;
    dw 792;  // None
    dw 796;
    dw 800;
    dw 260;  // None
    dw 28;
    dw 816;
    dw 60;  // None
    dw 52;
    dw 836;
    dw 824;  // None
    dw 840;
    dw 812;
    dw 836;  // None
    dw 840;
    dw 844;
    dw 64;  // None
    dw 56;
    dw 848;
    dw 832;  // None
    dw 852;
    dw 812;
    dw 848;  // None
    dw 852;
    dw 856;
    dw 260;  // None
    dw 100;
    dw 872;
    dw 884;  // None
    dw 888;
    dw 868;
    dw 260;  // None
    dw 20;
    dw 900;
    dw 76;  // None
    dw 68;
    dw 920;
    dw 908;  // None
    dw 924;
    dw 896;
    dw 920;  // None
    dw 924;
    dw 928;
    dw 80;  // None
    dw 72;
    dw 932;
    dw 916;  // None
    dw 936;
    dw 896;
    dw 932;  // None
    dw 936;
    dw 940;
    dw 260;  // None
    dw 28;
    dw 956;
    dw 92;  // None
    dw 84;
    dw 976;
    dw 964;  // None
    dw 980;
    dw 952;
    dw 976;  // None
    dw 980;
    dw 984;
    dw 96;  // None
    dw 88;
    dw 988;
    dw 972;  // None
    dw 992;
    dw 952;
    dw 988;  // None
    dw 992;
    dw 996;
    dw 260;  // None
    dw 108;
    dw 1012;
    dw 1024;  // None
    dw 1028;
    dw 1008;
    dw 260;  // None
    dw 116;
    dw 1040;
    dw 16;  // None
    dw 8;
    dw 1060;
    dw 1048;  // None
    dw 1064;
    dw 1036;
    dw 1060;  // None
    dw 1064;
    dw 1068;
    dw 16;  // None
    dw 12;
    dw 1072;
    dw 1056;  // None
    dw 1076;
    dw 1036;
    dw 1072;  // None
    dw 1076;
    dw 1080;
    dw 260;  // None
    dw 116;
    dw 1096;
    dw 1108;  // None
    dw 1112;
    dw 1092;
    dw 136;  // None
    dw 136;
    dw 1120;
    dw 1120;  // None
    dw 136;
    dw 1124;
    dw 892;  // None
    dw 136;
    dw 1128;
    dw 1032;  // None
    dw 1120;
    dw 1132;
    dw 1116;  // None
    dw 1124;
    dw 1136;

    output_offsets_ptr_loc:
    dw 1148;
}

func get_IS_ON_CURVE_G1_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 40;
    let witnesses_len = 0;
    let output_len = 12;
    let continuous_output = 1;
    let add_mod_n = 16;
    let mul_mod_n = 13;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1_g2';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 48;  // None
    dw 28;
    dw 52;
    dw 16;  // None
    dw 20;
    dw 56;
    dw 20;  // None
    dw 60;
    dw 16;
    dw 68;  // None
    dw 68;
    dw 72;
    dw 8;  // None
    dw 12;
    dw 76;
    dw 12;  // None
    dw 80;
    dw 8;
    dw 88;  // None
    dw 88;
    dw 92;
    dw 100;  // Fp2 mul real part end
    dw 104;
    dw 96;
    dw 108;  // Fp2 mul imag part end
    dw 112;
    dw 116;
    dw 120;  // None
    dw 32;
    dw 128;
    dw 124;  // None
    dw 36;
    dw 132;
    dw 104;  // None
    dw 128;
    dw 136;
    dw 116;  // None
    dw 132;
    dw 140;
    dw 52;  // None
    dw 144;
    dw 40;
    dw 136;  // None
    dw 148;
    dw 64;
    dw 140;  // None
    dw 152;
    dw 72;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 40;
    dw 0;  // None
    dw 0;
    dw 44;
    dw 0;  // None
    dw 44;
    dw 48;
    dw 56;  // None
    dw 60;
    dw 64;
    dw 16;  // None
    dw 20;
    dw 68;
    dw 76;  // None
    dw 80;
    dw 84;
    dw 8;  // None
    dw 12;
    dw 88;
    dw 8;  // Fp2 mul start
    dw 84;
    dw 96;
    dw 12;  // None
    dw 92;
    dw 100;
    dw 8;  // None
    dw 92;
    dw 108;
    dw 12;  // None
    dw 84;
    dw 112;
    dw 24;  // None
    dw 8;
    dw 120;
    dw 24;  // None
    dw 12;
    dw 124;

    output_offsets_ptr_loc:
    dw 144;
}

func get_ACC_EVAL_POINT_CHALLENGE_SIGNED_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 40;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 7;
    let mul_mod_n = 7;
    let n_assert_eq = 0;
    let name = 'acc_eval_point_challenge_signed';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 44;
    dw 16;
    dw 48;  // None
    dw 12;
    dw 52;
    dw 52;  // None
    dw 56;
    dw 24;
    dw 24;  // None
    dw 60;
    dw 0;
    dw 52;  // None
    dw 64;
    dw 60;
    dw 76;  // None
    dw 88;
    dw 92;
    dw 4;  // None
    dw 92;
    dw 96;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 20;
    dw 48;
    dw 36;  // None
    dw 28;
    dw 68;
    dw 56;  // None
    dw 72;
    dw 44;
    dw 68;  // None
    dw 72;
    dw 76;
    dw 40;  // None
    dw 32;
    dw 80;
    dw 64;  // None
    dw 84;
    dw 44;
    dw 80;  // None
    dw 84;
    dw 88;

    output_offsets_ptr_loc:
    dw 96;
}

func get_RHS_FINALIZE_ACC_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 24;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 5;
    let mul_mod_n = 2;
    let n_assert_eq = 0;
    let name = 'rhs_finalize_acc';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 28;
    dw 16;
    dw 32;  // None
    dw 12;
    dw 36;
    dw 24;  // None
    dw 40;
    dw 0;
    dw 36;  // None
    dw 44;
    dw 40;
    dw 4;  // None
    dw 48;
    dw 52;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 20;
    dw 32;
    dw 44;  // None
    dw 48;
    dw 28;

    output_offsets_ptr_loc:
    dw 52;
}

func get_DERIVE_POINT_FROM_X_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 8;
    let output_len = 20;
    let continuous_output = 0;
    let add_mod_n = 2;
    let mul_mod_n = 6;
    let n_assert_eq = 0;
    let name = 'derive_point_from_x';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 32;  // None
    dw 8;
    dw 36;
    dw 28;  // None
    dw 36;
    dw 40;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 24;
    dw 0;  // None
    dw 24;
    dw 28;
    dw 4;  // None
    dw 0;
    dw 32;
    dw 12;  // None
    dw 40;
    dw 44;
    dw 16;  // None
    dw 16;
    dw 48;
    dw 20;  // None
    dw 20;
    dw 52;

    output_offsets_ptr_loc:
    dw 40;
    dw 44;
    dw 48;
    dw 52;
    dw 16;
}

func get_DOUBLE_EC_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 12;
    let witnesses_len = 0;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 6;
    let mul_mod_n = 5;
    let n_assert_eq = 0;
    let name = 'double_ec_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 12;
    dw 24;
    dw 8;  // None
    dw 8;
    dw 28;
    dw 4;  // None
    dw 40;
    dw 36;
    dw 4;  // None
    dw 44;
    dw 40;
    dw 44;  // None
    dw 48;
    dw 4;
    dw 8;  // None
    dw 56;
    dw 52;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 16;
    dw 0;  // None
    dw 16;
    dw 20;
    dw 28;  // None
    dw 32;
    dw 24;
    dw 32;  // None
    dw 32;
    dw 36;
    dw 32;  // None
    dw 48;
    dw 52;

    output_offsets_ptr_loc:
    dw 44;
    dw 56;
}

func get_IS_ON_CURVE_G1_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 40;
    let witnesses_len = 0;
    let output_len = 12;
    let continuous_output = 1;
    let add_mod_n = 16;
    let mul_mod_n = 13;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1_g2';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 48;  // None
    dw 28;
    dw 52;
    dw 16;  // None
    dw 20;
    dw 56;
    dw 20;  // None
    dw 508;
    dw 516;

    output_offsets_ptr_loc:
    dw 520;
}
