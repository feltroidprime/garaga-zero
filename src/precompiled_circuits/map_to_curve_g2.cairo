from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls

func get_MAP_TO_CURVE_G2_ADJ_Y_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 7;
    let input_len = 16;
    let witnesses_len = 48;
    let output_len = 16;
    let continuous_output = 0;
    let add_mod_n = 40;
    let mul_mod_n = 34;
    let n_assert_eq = 12;
    let name = 'map_to_curve_g2_adj_y';
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
    dw 240;
    dw 0;
    dw 0;
    dw 0;
    dw 1012;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877673;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 92;
    dw 48;
    dw 20;  // None
    dw 104;
    dw 56;
    dw 60;  // None
    dw 116;
    dw 20;
    dw 28;  // None
    dw 20;
    dw 120;
    dw 60;  // None
    dw 136;
    dw 20;
    dw 48;  // None
    dw 140;
    dw 144;
    dw 148;  // None
    dw 152;
    dw 144;
    dw 140;  // None
    dw 156;
    dw 20;
    dw 160;  // None
    dw 164;
    dw 168;
    dw 20;  // None
    dw 172;
    dw 72;
    dw 20;  // None
    dw 184;
    dw 80;
    dw 84;  // None
    dw 196;
    dw 20;
    dw 36;  // None
    dw 20;
    dw 200;
    dw 84;  // None
    dw 216;
    dw 20;
    dw 72;  // None
    dw 220;
    dw 224;
    dw 228;  // None
    dw 232;
    dw 224;
    dw 220;  // None
    dw 236;
    dw 20;
    dw 240;  // None
    dw 244;
    dw 248;
    dw 152;  // None
    dw 232;
    dw 260;
    dw 260;  // None
    dw 264;
    dw 256;
    dw 264;  // None
    dw 20;
    dw 268;
    dw 276;  // Fp2 mul real part end
    dw 280;
    dw 272;
    dw 284;  // Fp2 mul imag part end
    dw 288;
    dw 292;
    dw 268;  // None
    dw 296;
    dw 20;
    dw 28;  // Fp2 sub coeff 0/1
    dw 300;
    dw 0;
    dw 32;  // Fp2 sub coeff 1/1
    dw 304;
    dw 0;
    dw 312;  // Fp2 mul real part end
    dw 316;
    dw 308;
    dw 320;  // Fp2 mul imag part end
    dw 324;
    dw 328;
    dw 280;  // Fp2 add coeff 0/1
    dw 316;
    dw 332;
    dw 292;  // Fp2 add coeff 1/1
    dw 328;
    dw 336;
    dw 0;  // Ensure r0 ∈ {0,1}
    dw 0;
    dw 96;
    dw 100;  // Validate x0 decomposition
    dw 48;
    dw 28;
    dw 0;  // Ensure r1 ∈ {0,1}
    dw 0;
    dw 108;
    dw 112;  // Validate x1 decomposition
    dw 56;
    dw 32;
    dw 128;  // None
    dw 132;
    dw 20;
    dw 0;  // Ensure r0 ∈ {0,1}
    dw 0;
    dw 176;
    dw 180;  // Validate x0 decomposition
    dw 72;
    dw 36;
    dw 0;  // Ensure r1 ∈ {0,1}
    dw 0;
    dw 188;
    dw 192;  // Validate x1 decomposition
    dw 80;
    dw 40;
    dw 208;  // None
    dw 212;
    dw 20;

    mul_offsets_ptr_loc:
    dw 48;  // None
    dw 92;
    dw 96;
    dw 44;  // None
    dw 24;
    dw 100;
    dw 56;  // None
    dw 104;
    dw 108;
    dw 52;  // None
    dw 24;
    dw 112;
    dw 28;  // None
    dw 64;
    dw 124;
    dw 60;  // None
    dw 124;
    dw 128;
    dw 116;  // None
    dw 120;
    dw 132;
    dw 136;  // None
    dw 56;
    dw 140;
    dw 48;  // None
    dw 140;
    dw 148;
    dw 44;  // None
    dw 156;
    dw 160;
    dw 52;  // None
    dw 140;
    dw 164;
    dw 72;  // None
    dw 172;
    dw 176;
    dw 68;  // None
    dw 24;
    dw 180;
    dw 80;  // None
    dw 184;
    dw 188;
    dw 76;  // None
    dw 24;
    dw 192;
    dw 36;  // None
    dw 88;
    dw 204;
    dw 84;  // None
    dw 204;
    dw 208;
    dw 196;  // None
    dw 200;
    dw 212;
    dw 216;  // None
    dw 80;
    dw 220;
    dw 72;  // None
    dw 220;
    dw 228;
    dw 68;  // None
    dw 236;
    dw 240;
    dw 76;  // None
    dw 220;
    dw 244;
    dw 152;  // None
    dw 232;
    dw 252;
    dw 24;  // None
    dw 252;
    dw 256;
    dw 268;  // Fp2 mul start
    dw 28;
    dw 272;
    dw 0;  // None
    dw 32;
    dw 276;
    dw 268;  // None
    dw 32;
    dw 284;
    dw 0;  // None
    dw 28;
    dw 288;
    dw 296;  // Fp2 mul start
    dw 300;
    dw 308;
    dw 0;  // None
    dw 304;
    dw 312;
    dw 296;  // None
    dw 304;
    dw 320;
    dw 0;  // None
    dw 300;
    dw 324;
    dw 60;  // flag ∈ {0,1}
    dw 116;
    dw 0;
    dw 84;  // flag ∈ {0,1}
    dw 196;
    dw 0;

    output_offsets_ptr_loc:
    dw 332;
    dw 336;
    dw 248;
    dw 168;
}

func get_MAP_TO_CURVE_G2_FIRST_STEP_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 6;
    let input_len = 8;
    let witnesses_len = 16;
    let output_len = 32;
    let continuous_output = 0;
    let add_mod_n = 56;
    let mul_mod_n = 62;
    let n_assert_eq = 4;
    let name = 'map_to_curve_g2_first_step';
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
    dw 240;
    dw 0;
    dw 0;
    dw 0;
    dw 1012;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877673;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 1;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 24;  // None
    dw 28;
    dw 48;
    dw 28;  // None
    dw 52;
    dw 24;
    dw 60;  // None
    dw 60;
    dw 64;
    dw 72;  // Fp2 mul real part end
    dw 76;
    dw 68;
    dw 80;  // Fp2 mul imag part end
    dw 84;
    dw 88;
    dw 76;  // None
    dw 88;
    dw 92;
    dw 88;  // None
    dw 96;
    dw 76;
    dw 104;  // None
    dw 104;
    dw 108;
    dw 100;  // Fp2 add coeff 0/1
    dw 76;
    dw 112;
    dw 108;  // Fp2 add coeff 1/1
    dw 88;
    dw 116;
    dw 112;  // Fp2 sub coeff 0/1
    dw 120;
    dw 0;
    dw 116;  // Fp2 sub coeff 1/1
    dw 124;
    dw 0;
    dw 112;  // Fp2 add coeff 0/1
    dw 20;
    dw 128;
    dw 116;  // Fp2 add coeff 1/1
    dw 0;
    dw 132;
    dw 140;  // Fp2 mul real part end
    dw 144;
    dw 136;
    dw 148;  // Fp2 mul imag part end
    dw 152;
    dw 156;
    dw 32;  // None
    dw 160;
    dw 20;
    dw 120;  // None
    dw 20;
    dw 164;
    dw 40;  // None
    dw 180;
    dw 20;
    dw 124;  // None
    dw 20;
    dw 184;
    dw 32;  // None
    dw 40;
    dw 200;
    dw 204;  // None
    dw 208;
    dw 200;
    dw 208;  // Fp2 sub coeff 0/1
    dw 212;
    dw 20;
    dw 0;  // Fp2 sub coeff 1/1
    dw 216;
    dw 0;
    dw 224;  // Fp2 mul real part end
    dw 228;
    dw 220;
    dw 232;  // Fp2 mul imag part end
    dw 236;
    dw 240;
    dw 248;  // Fp2 mul real part end
    dw 252;
    dw 244;
    dw 256;  // Fp2 mul imag part end
    dw 260;
    dw 264;
    dw 228;  // Fp2 add coeff 0/1
    dw 252;
    dw 268;
    dw 240;  // Fp2 add coeff 1/1
    dw 264;
    dw 272;
    dw 280;  // Fp2 mul real part end
    dw 284;
    dw 276;
    dw 288;  // Fp2 mul imag part end
    dw 292;
    dw 296;
    dw 144;  // None
    dw 156;
    dw 300;
    dw 156;  // None
    dw 304;
    dw 144;
    dw 312;  // None
    dw 312;
    dw 316;
    dw 284;  // None
    dw 296;
    dw 320;
    dw 296;  // None
    dw 324;
    dw 284;
    dw 332;  // None
    dw 332;
    dw 336;
    dw 344;  // Fp2 mul real part end
    dw 348;
    dw 340;
    dw 352;  // Fp2 mul imag part end
    dw 356;
    dw 360;
    dw 368;  // Fp2 mul real part end
    dw 372;
    dw 364;
    dw 376;  // Fp2 mul imag part end
    dw 380;
    dw 384;
    dw 308;  // Fp2 add coeff 0/1
    dw 372;
    dw 388;
    dw 316;  // Fp2 add coeff 1/1
    dw 384;
    dw 392;
    dw 400;  // Fp2 mul real part end
    dw 404;
    dw 396;
    dw 408;  // Fp2 mul imag part end
    dw 412;
    dw 416;
    dw 424;  // Fp2 mul real part end
    dw 428;
    dw 420;
    dw 432;  // Fp2 mul imag part end
    dw 436;
    dw 440;
    dw 404;  // Fp2 add coeff 0/1
    dw 428;
    dw 444;
    dw 416;  // Fp2 add coeff 1/1
    dw 440;
    dw 448;
    dw 452;  // None
    dw 456;
    dw 460;
    dw 472;  // Fp2 Inv imag part end
    dw 476;
    dw 0;
    dw 484;  // Fp2 mul real part end
    dw 488;
    dw 480;
    dw 492;  // Fp2 mul imag part end
    dw 496;
    dw 500;
    dw 172;  // None
    dw 176;
    dw 20;
    dw 192;  // None
    dw 196;
    dw 20;

    mul_offsets_ptr_loc:
    dw 48;  // None
    dw 52;
    dw 56;
    dw 24;  // None
    dw 28;
    dw 60;
    dw 12;  // Fp2 mul start
    dw 56;
    dw 68;
    dw 16;  // None
    dw 64;
    dw 72;
    dw 12;  // None
    dw 64;
    dw 80;
    dw 16;  // None
    dw 56;
    dw 84;
    dw 92;  // None
    dw 96;
    dw 100;
    dw 76;  // None
    dw 88;
    dw 104;
    dw 8;  // Fp2 mul start
    dw 128;
    dw 136;
    dw 8;  // None
    dw 132;
    dw 140;
    dw 8;  // None
    dw 132;
    dw 148;
    dw 8;  // None
    dw 128;
    dw 152;
    dw 120;  // None
    dw 36;
    dw 168;
    dw 32;  // None
    dw 168;
    dw 172;
    dw 160;  // None
    dw 164;
    dw 176;
    dw 124;  // None
    dw 44;
    dw 188;
    dw 40;  // None
    dw 188;
    dw 192;
    dw 180;  // None
    dw 184;
    dw 196;
    dw 32;  // None
    dw 40;
    dw 204;
    dw 212;  // Fp2 mul start
    dw 12;
    dw 220;
    dw 216;  // None
    dw 16;
    dw 224;
    dw 212;  // None
    dw 16;
    dw 232;
    dw 216;  // None
    dw 12;
    dw 236;
    dw 208;  // Fp2 mul start
    dw 120;
    dw 244;
    dw 0;  // None
    dw 124;
    dw 248;
    dw 208;  // None
    dw 124;
    dw 256;
    dw 0;  // None
    dw 120;
    dw 260;
    dw 0;  // Fp2 mul start
    dw 268;
    dw 276;
    dw 4;  // None
    dw 272;
    dw 280;
    dw 0;  // None
    dw 272;
    dw 288;
    dw 4;  // None
    dw 268;
    dw 292;
    dw 300;  // None
    dw 304;
    dw 308;
    dw 144;  // None
    dw 156;
    dw 312;
    dw 320;  // None
    dw 324;
    dw 328;
    dw 284;  // None
    dw 296;
    dw 332;
    dw 284;  // Fp2 mul start
    dw 328;
    dw 340;
    dw 296;  // None
    dw 336;
    dw 344;
    dw 284;  // None
    dw 336;
    dw 352;
    dw 296;  // None
    dw 328;
    dw 356;
    dw 0;  // Fp2 mul start
    dw 328;
    dw 364;
    dw 4;  // None
    dw 336;
    dw 368;
    dw 0;  // None
    dw 336;
    dw 376;
    dw 4;  // None
    dw 328;
    dw 380;
    dw 388;  // Fp2 mul start
    dw 144;
    dw 396;
    dw 392;  // None
    dw 156;
    dw 400;
    dw 388;  // None
    dw 156;
    dw 408;
    dw 392;  // None
    dw 144;
    dw 412;
    dw 8;  // Fp2 mul start
    dw 348;
    dw 420;
    dw 8;  // None
    dw 360;
    dw 424;
    dw 8;  // None
    dw 360;
    dw 432;
    dw 8;  // None
    dw 348;
    dw 436;
    dw 348;  // Fp2 Inv start
    dw 348;
    dw 452;
    dw 360;  // None
    dw 360;
    dw 456;
    dw 460;  // None
    dw 464;
    dw 20;
    dw 348;  // Fp2 Inv real part end
    dw 464;
    dw 468;
    dw 360;  // None
    dw 464;
    dw 472;
    dw 444;  // Fp2 mul start
    dw 468;
    dw 480;
    dw 448;  // None
    dw 476;
    dw 484;
    dw 444;  // None
    dw 476;
    dw 492;
    dw 448;  // None
    dw 468;
    dw 496;
    dw 32;  // flag ∈ {0,1}
    dw 160;
    dw 0;
    dw 40;  // flag ∈ {0,1}
    dw 180;
    dw 0;

    output_offsets_ptr_loc:
    dw 488;
    dw 500;
    dw 284;
    dw 296;
    dw 144;
    dw 156;
    dw 76;
    dw 88;
}

func get_MAP_TO_CURVE_G2_NON_QUAD_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 6;
    let input_len = 40;
    let witnesses_len = 16;
    let output_len = 24;
    let continuous_output = 0;
    let add_mod_n = 13;
    let mul_mod_n = 24;
    let n_assert_eq = 4;
    let name = 'map_to_curve_g2_non_quad';
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
    dw 240;
    dw 0;
    dw 0;
    dw 0;
    dw 1012;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877673;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 1;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 84;  // Fp2 mul real part end
    dw 88;
    dw 80;
    dw 92;  // Fp2 mul imag part end
    dw 96;
    dw 100;
    dw 108;  // None
    dw 120;
    dw 0;
    dw 128;  // Fp2 mul real part end
    dw 132;
    dw 124;
    dw 136;  // Fp2 mul imag part end
    dw 140;
    dw 144;
    dw 152;  // Fp2 mul real part end
    dw 156;
    dw 148;
    dw 160;  // Fp2 mul imag part end
    dw 164;
    dw 168;
    dw 176;  // Fp2 mul real part end
    dw 180;
    dw 172;
    dw 184;  // Fp2 mul imag part end
    dw 188;
    dw 192;
    dw 104;  // Fp2 sqrt: assert real part
    dw 120;
    dw 88;
    dw 112;  // Fp2 sqrt: assert imaginary part
    dw 116;
    dw 100;
    dw 180;  // None
    dw 200;
    dw 196;
    dw 204;  // None
    dw 208;
    dw 192;

    mul_offsets_ptr_loc:
    dw 12;  // Fp2 mul start
    dw 32;
    dw 80;
    dw 16;  // None
    dw 36;
    dw 84;
    dw 12;  // None
    dw 36;
    dw 92;
    dw 16;  // None
    dw 32;
    dw 96;
    dw 64;  // Fp2 sqrt: a0*b0
    dw 64;
    dw 104;
    dw 68;  // Fp2 sqrt: a1*b1
    dw 68;
    dw 108;
    dw 64;  // Fp2 sqrt: a0*b1
    dw 68;
    dw 112;
    dw 68;  // Fp2 sqrt: a1*b0
    dw 64;
    dw 116;
    dw 24;  // Fp2 mul start
    dw 64;
    dw 124;
    dw 28;  // None
    dw 68;
    dw 128;
    dw 24;  // None
    dw 68;
    dw 136;
    dw 28;  // None
    dw 64;
    dw 140;
    dw 56;  // Fp2 mul start
    dw 132;
    dw 148;
    dw 60;  // None
    dw 144;
    dw 152;
    dw 56;  // None
    dw 144;
    dw 160;
    dw 60;  // None
    dw 132;
    dw 164;
    dw 56;  // Fp2 mul start
    dw 48;
    dw 172;
    dw 60;  // None
    dw 52;
    dw 176;
    dw 56;  // None
    dw 52;
    dw 184;
    dw 60;  // None
    dw 48;
    dw 188;
    dw 72;  // None
    dw 40;
    dw 196;
    dw 76;  // None
    dw 44;
    dw 200;
    dw 72;  // None
    dw 44;
    dw 204;
    dw 76;  // None
    dw 40;
    dw 208;

    output_offsets_ptr_loc:
    dw 72;
    dw 76;
    dw 156;
    dw 168;
    dw 24;
    dw 28;
}

func get_MAP_TO_CURVE_G2_QUAD_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 6;
    let input_len = 32;
    let witnesses_len = 16;
    let output_len = 24;
    let continuous_output = 0;
    let add_mod_n = 5;
    let mul_mod_n = 8;
    let n_assert_eq = 4;
    let name = 'map_to_curve_g2_quad';
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
    dw 240;
    dw 0;
    dw 0;
    dw 0;
    dw 1012;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877673;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 1;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 76;  // None
    dw 88;
    dw 0;
    dw 72;  // Fp2 sqrt: assert real part
    dw 88;
    dw 32;
    dw 80;  // Fp2 sqrt: assert imaginary part
    dw 84;
    dw 36;
    dw 48;  // None
    dw 96;
    dw 92;
    dw 100;  // None
    dw 104;
    dw 52;

    mul_offsets_ptr_loc:
    dw 56;  // Fp2 sqrt: a0*b0
    dw 56;
    dw 72;
    dw 60;  // Fp2 sqrt: a1*b1
    dw 60;
    dw 76;
    dw 56;  // Fp2 sqrt: a0*b1
    dw 60;
    dw 80;
    dw 60;  // Fp2 sqrt: a1*b0
    dw 56;
    dw 84;
    dw 64;  // None
    dw 40;
    dw 92;
    dw 68;  // None
    dw 44;
    dw 96;
    dw 64;  // None
    dw 44;
    dw 100;
    dw 68;  // None
    dw 40;
    dw 104;

    output_offsets_ptr_loc:
    dw 64;
    dw 68;
    dw 56;
    dw 60;
    dw 24;
    dw 28;
}
