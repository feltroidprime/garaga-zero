from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls

func get_MAP_TO_CURVE_G2_FIN_NON_QUAD_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 7;
    let input_len = 40;
    let witnesses_len = 48;
    let output_len = 16;
    let continuous_output = 0;
    let add_mod_n = 43;
    let mul_mod_n = 50;
    let n_assert_eq = 12;
    let name = 'map_to_curve_g2_fin_non_quad';
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
    dw 120;  // Fp2 mul real part end
    dw 124;
    dw 116;
    dw 128;  // Fp2 mul imag part end
    dw 132;
    dw 136;
    dw 144;  // None
    dw 156;
    dw 0;
    dw 164;  // Fp2 mul real part end
    dw 168;
    dw 160;
    dw 172;  // Fp2 mul imag part end
    dw 176;
    dw 180;
    dw 188;  // Fp2 mul real part end
    dw 192;
    dw 184;
    dw 196;  // Fp2 mul imag part end
    dw 200;
    dw 204;
    dw 212;  // Fp2 mul real part end
    dw 216;
    dw 208;
    dw 220;  // Fp2 mul imag part end
    dw 224;
    dw 228;
    dw 20;  // None
    dw 248;
    dw 88;
    dw 20;  // None
    dw 260;
    dw 96;
    dw 276;  // None
    dw 280;
    dw 20;
    dw 88;  // None
    dw 284;
    dw 288;
    dw 292;  // None
    dw 296;
    dw 288;
    dw 20;  // None
    dw 300;
    dw 104;
    dw 20;  // None
    dw 312;
    dw 112;
    dw 328;  // None
    dw 332;
    dw 20;
    dw 104;  // None
    dw 336;
    dw 340;
    dw 344;  // None
    dw 348;
    dw 340;
    dw 296;  // None
    dw 348;
    dw 360;
    dw 360;  // None
    dw 364;
    dw 356;
    dw 364;  // None
    dw 20;
    dw 368;
    dw 376;  // Fp2 mul real part end
    dw 380;
    dw 372;
    dw 384;  // Fp2 mul imag part end
    dw 388;
    dw 392;
    dw 368;  // None
    dw 396;
    dw 20;
    dw 192;  // Fp2 sub real part
    dw 400;
    dw 0;
    dw 204;  // Fp2 sub imag part
    dw 404;
    dw 0;
    dw 412;  // Fp2 mul real part end
    dw 416;
    dw 408;
    dw 420;  // Fp2 mul imag part end
    dw 424;
    dw 428;
    dw 380;  // Fp2 add real part
    dw 416;
    dw 432;
    dw 392;  // Fp2 add imag part
    dw 428;
    dw 436;
    dw 140;  // Fp2 sqrt: assert real part
    dw 156;
    dw 124;
    dw 148;  // Fp2 sqrt: assert imaginary part
    dw 152;
    dw 136;
    dw 216;  // None
    dw 236;
    dw 232;
    dw 240;  // None
    dw 244;
    dw 228;
    dw 0;  // Ensure r0 ∈ {0,1}
    dw 0;
    dw 252;
    dw 256;  // Validate x0 decomposition
    dw 88;
    dw 192;
    dw 0;  // Ensure r1 ∈ {0,1}
    dw 0;
    dw 264;
    dw 268;  // Validate x1 decomposition
    dw 96;
    dw 204;
    dw 0;  // Ensure r0 ∈ {0,1}
    dw 0;
    dw 304;
    dw 308;  // Validate x0 decomposition
    dw 104;
    dw 28;
    dw 0;  // Ensure r1 ∈ {0,1}
    dw 0;
    dw 316;
    dw 320;  // Validate x1 decomposition
    dw 112;
    dw 32;

    mul_offsets_ptr_loc:
    dw 12;  // Fp2 mul start
    dw 36;
    dw 116;
    dw 16;  // None
    dw 40;
    dw 120;
    dw 12;  // None
    dw 40;
    dw 128;
    dw 16;  // None
    dw 36;
    dw 132;
    dw 68;  // Fp2 sqrt: a0*b0
    dw 68;
    dw 140;
    dw 72;  // Fp2 sqrt: a1*b1
    dw 72;
    dw 144;
    dw 68;  // Fp2 sqrt: a0*b1
    dw 72;
    dw 148;
    dw 72;  // Fp2 sqrt: a1*b0
    dw 68;
    dw 152;
    dw 28;  // Fp2 mul start
    dw 68;
    dw 160;
    dw 32;  // None
    dw 72;
    dw 164;
    dw 28;  // None
    dw 72;
    dw 172;
    dw 32;  // None
    dw 68;
    dw 176;
    dw 60;  // Fp2 mul start
    dw 168;
    dw 184;
    dw 64;  // None
    dw 180;
    dw 188;
    dw 60;  // None
    dw 180;
    dw 196;
    dw 64;  // None
    dw 168;
    dw 200;
    dw 60;  // Fp2 mul start
    dw 52;
    dw 208;
    dw 64;  // None
    dw 56;
    dw 212;
    dw 60;  // None
    dw 56;
    dw 220;
    dw 64;  // None
    dw 52;
    dw 224;
    dw 76;  // None
    dw 44;
    dw 232;
    dw 80;  // None
    dw 48;
    dw 236;
    dw 76;  // None
    dw 48;
    dw 240;
    dw 80;  // None
    dw 44;
    dw 244;
    dw 88;  // None
    dw 248;
    dw 252;
    dw 84;  // None
    dw 24;
    dw 256;
    dw 96;  // None
    dw 260;
    dw 264;
    dw 92;  // None
    dw 24;
    dw 268;
    dw 192;  // None
    dw 272;
    dw 20;
    dw 192;  // None
    dw 272;
    dw 276;
    dw 280;  // None
    dw 96;
    dw 284;
    dw 88;  // None
    dw 284;
    dw 292;
    dw 104;  // None
    dw 300;
    dw 304;
    dw 100;  // None
    dw 24;
    dw 308;
    dw 112;  // None
    dw 312;
    dw 316;
    dw 108;  // None
    dw 24;
    dw 320;
    dw 28;  // None
    dw 324;
    dw 20;
    dw 28;  // None
    dw 324;
    dw 328;
    dw 332;  // None
    dw 112;
    dw 336;
    dw 104;  // None
    dw 336;
    dw 344;
    dw 296;  // None
    dw 348;
    dw 352;
    dw 24;  // None
    dw 352;
    dw 356;
    dw 368;  // Fp2 mul start
    dw 192;
    dw 372;
    dw 0;  // None
    dw 204;
    dw 376;
    dw 368;  // None
    dw 204;
    dw 384;
    dw 0;  // None
    dw 192;
    dw 388;
    dw 396;  // Fp2 mul start
    dw 400;
    dw 408;
    dw 0;  // None
    dw 404;
    dw 412;
    dw 396;  // None
    dw 404;
    dw 420;
    dw 0;  // None
    dw 400;
    dw 424;

    output_offsets_ptr_loc:
    dw 76;
    dw 80;
    dw 432;
    dw 436;
}

func get_MAP_TO_CURVE_G2_FIN_QUAD_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 7;
    let input_len = 32;
    let witnesses_len = 48;
    let output_len = 16;
    let continuous_output = 0;
    let add_mod_n = 35;
    let mul_mod_n = 34;
    let n_assert_eq = 12;
    let name = 'map_to_curve_g2_fin_quad';
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
    dw 112;  // None
    dw 124;
    dw 0;
    dw 20;  // None
    dw 144;
    dw 80;
    dw 20;  // None
    dw 156;
    dw 88;
    dw 172;  // None
    dw 176;
    dw 20;
    dw 80;  // None
    dw 180;
    dw 184;
    dw 188;  // None
    dw 192;
    dw 184;
    dw 20;  // None
    dw 196;
    dw 96;
    dw 20;  // None
    dw 208;
    dw 104;
    dw 224;  // None
    dw 228;
    dw 20;
    dw 96;  // None
    dw 232;
    dw 236;
    dw 240;  // None
    dw 244;
    dw 236;
    dw 192;  // None
    dw 244;
    dw 256;
    dw 256;  // None
    dw 260;
    dw 252;
    dw 260;  // None
    dw 20;
    dw 264;
    dw 272;  // Fp2 mul real part end
    dw 276;
    dw 268;
    dw 280;  // Fp2 mul imag part end
    dw 284;
    dw 288;
    dw 264;  // None
    dw 292;
    dw 20;
    dw 60;  // Fp2 sub real part
    dw 296;
    dw 0;
    dw 64;  // Fp2 sub imag part
    dw 300;
    dw 0;
    dw 308;  // Fp2 mul real part end
    dw 312;
    dw 304;
    dw 316;  // Fp2 mul imag part end
    dw 320;
    dw 324;
    dw 276;  // Fp2 add real part
    dw 312;
    dw 328;
    dw 288;  // Fp2 add imag part
    dw 324;
    dw 332;
    dw 108;  // Fp2 sqrt: assert real part
    dw 124;
    dw 36;
    dw 116;  // Fp2 sqrt: assert imaginary part
    dw 120;
    dw 40;
    dw 52;  // None
    dw 132;
    dw 128;
    dw 136;  // None
    dw 140;
    dw 56;
    dw 0;  // Ensure r0 ∈ {0,1}
    dw 0;
    dw 148;
    dw 152;  // Validate x0 decomposition
    dw 80;
    dw 60;
    dw 0;  // Ensure r1 ∈ {0,1}
    dw 0;
    dw 160;
    dw 164;  // Validate x1 decomposition
    dw 88;
    dw 64;
    dw 0;  // Ensure r0 ∈ {0,1}
    dw 0;
    dw 200;
    dw 204;  // Validate x0 decomposition
    dw 96;
    dw 28;
    dw 0;  // Ensure r1 ∈ {0,1}
    dw 0;
    dw 212;
    dw 216;  // Validate x1 decomposition
    dw 104;
    dw 32;

    mul_offsets_ptr_loc:
    dw 60;  // Fp2 sqrt: a0*b0
    dw 60;
    dw 108;
    dw 64;  // Fp2 sqrt: a1*b1
    dw 64;
    dw 112;
    dw 60;  // Fp2 sqrt: a0*b1
    dw 64;
    dw 116;
    dw 64;  // Fp2 sqrt: a1*b0
    dw 60;
    dw 120;
    dw 68;  // None
    dw 44;
    dw 128;
    dw 72;  // None
    dw 48;
    dw 132;
    dw 68;  // None
    dw 48;
    dw 136;
    dw 72;  // None
    dw 44;
    dw 140;
    dw 80;  // None
    dw 144;
    dw 148;
    dw 76;  // None
    dw 24;
    dw 152;
    dw 88;  // None
    dw 156;
    dw 160;
    dw 84;  // None
    dw 24;
    dw 164;
    dw 60;  // None
    dw 168;
    dw 20;
    dw 60;  // None
    dw 168;
    dw 172;
    dw 176;  // None
    dw 88;
    dw 180;
    dw 80;  // None
    dw 180;
    dw 188;
    dw 96;  // None
    dw 196;
    dw 200;
    dw 92;  // None
    dw 24;
    dw 204;
    dw 104;  // None
    dw 208;
    dw 212;
    dw 100;  // None
    dw 24;
    dw 216;
    dw 28;  // None
    dw 220;
    dw 20;
    dw 28;  // None
    dw 220;
    dw 224;
    dw 228;  // None
    dw 104;
    dw 232;
    dw 96;  // None
    dw 232;
    dw 240;
    dw 192;  // None
    dw 244;
    dw 248;
    dw 24;  // None
    dw 248;
    dw 252;
    dw 264;  // Fp2 mul start
    dw 60;
    dw 268;
    dw 0;  // None
    dw 64;
    dw 272;
    dw 264;  // None
    dw 64;
    dw 280;
    dw 0;  // None
    dw 60;
    dw 284;
    dw 292;  // Fp2 mul start
    dw 296;
    dw 304;
    dw 0;  // None
    dw 300;
    dw 308;
    dw 292;  // None
    dw 300;
    dw 316;
    dw 0;  // None
    dw 296;
    dw 320;

    output_offsets_ptr_loc:
    dw 68;
    dw 72;
    dw 328;
    dw 332;
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
    let witnesses_len = 0;
    let output_len = 32;
    let continuous_output = 0;
    let add_mod_n = 50;
    let mul_mod_n = 58;
    let n_assert_eq = 0;
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
    dw 32;
    dw 28;  // None
    dw 36;
    dw 24;
    dw 44;  // None
    dw 44;
    dw 48;
    dw 56;  // Fp2 mul real part end
    dw 60;
    dw 52;
    dw 64;  // Fp2 mul imag part end
    dw 68;
    dw 72;
    dw 60;  // None
    dw 72;
    dw 76;
    dw 72;  // None
    dw 80;
    dw 60;
    dw 88;  // None
    dw 88;
    dw 92;
    dw 84;  // Fp2 add real part
    dw 60;
    dw 96;
    dw 92;  // Fp2 add imag part
    dw 72;
    dw 100;
    dw 96;  // Fp2 sub real part
    dw 104;
    dw 0;
    dw 100;  // Fp2 sub imag part
    dw 108;
    dw 0;
    dw 96;  // Fp2 add real part
    dw 20;
    dw 112;
    dw 100;  // Fp2 add imag part
    dw 0;
    dw 116;
    dw 124;  // Fp2 mul real part end
    dw 128;
    dw 120;
    dw 132;  // Fp2 mul imag part end
    dw 136;
    dw 140;
    dw 148;  // None
    dw 156;
    dw 160;
    dw 164;  // None
    dw 168;
    dw 160;
    dw 168;  // Fp2 sub real part
    dw 172;
    dw 20;
    dw 0;  // Fp2 sub imag part
    dw 176;
    dw 0;
    dw 184;  // Fp2 mul real part end
    dw 188;
    dw 180;
    dw 192;  // Fp2 mul imag part end
    dw 196;
    dw 200;
    dw 208;  // Fp2 mul real part end
    dw 212;
    dw 204;
    dw 216;  // Fp2 mul imag part end
    dw 220;
    dw 224;
    dw 188;  // Fp2 add real part
    dw 212;
    dw 228;
    dw 200;  // Fp2 add imag part
    dw 224;
    dw 232;
    dw 240;  // Fp2 mul real part end
    dw 244;
    dw 236;
    dw 248;  // Fp2 mul imag part end
    dw 252;
    dw 256;
    dw 128;  // None
    dw 140;
    dw 260;
    dw 140;  // None
    dw 264;
    dw 128;
    dw 272;  // None
    dw 272;
    dw 276;
    dw 244;  // None
    dw 256;
    dw 280;
    dw 256;  // None
    dw 284;
    dw 244;
    dw 292;  // None
    dw 292;
    dw 296;
    dw 304;  // Fp2 mul real part end
    dw 308;
    dw 300;
    dw 312;  // Fp2 mul imag part end
    dw 316;
    dw 320;
    dw 328;  // Fp2 mul real part end
    dw 332;
    dw 324;
    dw 336;  // Fp2 mul imag part end
    dw 340;
    dw 344;
    dw 268;  // Fp2 add real part
    dw 332;
    dw 348;
    dw 276;  // Fp2 add imag part
    dw 344;
    dw 352;
    dw 360;  // Fp2 mul real part end
    dw 364;
    dw 356;
    dw 368;  // Fp2 mul imag part end
    dw 372;
    dw 376;
    dw 384;  // Fp2 mul real part end
    dw 388;
    dw 380;
    dw 392;  // Fp2 mul imag part end
    dw 396;
    dw 400;
    dw 364;  // Fp2 add real part
    dw 388;
    dw 404;
    dw 376;  // Fp2 add imag part
    dw 400;
    dw 408;
    dw 412;  // None
    dw 416;
    dw 420;
    dw 432;  // Fp2 Inv imag part end
    dw 436;
    dw 0;
    dw 444;  // Fp2 mul real part end
    dw 448;
    dw 440;
    dw 452;  // Fp2 mul imag part end
    dw 456;
    dw 460;

    mul_offsets_ptr_loc:
    dw 32;  // None
    dw 36;
    dw 40;
    dw 24;  // None
    dw 28;
    dw 44;
    dw 12;  // Fp2 mul start
    dw 40;
    dw 52;
    dw 16;  // None
    dw 48;
    dw 56;
    dw 12;  // None
    dw 48;
    dw 64;
    dw 16;  // None
    dw 40;
    dw 68;
    dw 76;  // None
    dw 80;
    dw 84;
    dw 60;  // None
    dw 72;
    dw 88;
    dw 8;  // Fp2 mul start
    dw 112;
    dw 120;
    dw 8;  // None
    dw 116;
    dw 124;
    dw 8;  // None
    dw 116;
    dw 132;
    dw 8;  // None
    dw 112;
    dw 136;
    dw 104;  // None
    dw 144;
    dw 20;
    dw 104;  // None
    dw 144;
    dw 148;
    dw 108;  // None
    dw 152;
    dw 20;
    dw 108;  // None
    dw 152;
    dw 156;
    dw 148;  // None
    dw 156;
    dw 164;
    dw 172;  // Fp2 mul start
    dw 12;
    dw 180;
    dw 176;  // None
    dw 16;
    dw 184;
    dw 172;  // None
    dw 16;
    dw 192;
    dw 176;  // None
    dw 12;
    dw 196;
    dw 168;  // Fp2 mul start
    dw 104;
    dw 204;
    dw 0;  // None
    dw 108;
    dw 208;
    dw 168;  // None
    dw 108;
    dw 216;
    dw 0;  // None
    dw 104;
    dw 220;
    dw 0;  // Fp2 mul start
    dw 228;
    dw 236;
    dw 4;  // None
    dw 232;
    dw 240;
    dw 0;  // None
    dw 232;
    dw 248;
    dw 4;  // None
    dw 228;
    dw 252;
    dw 260;  // None
    dw 264;
    dw 268;
    dw 128;  // None
    dw 140;
    dw 272;
    dw 280;  // None
    dw 284;
    dw 288;
    dw 244;  // None
    dw 256;
    dw 292;
    dw 244;  // Fp2 mul start
    dw 288;
    dw 300;
    dw 256;  // None
    dw 296;
    dw 304;
    dw 244;  // None
    dw 296;
    dw 312;
    dw 256;  // None
    dw 288;
    dw 316;
    dw 0;  // Fp2 mul start
    dw 288;
    dw 324;
    dw 4;  // None
    dw 296;
    dw 328;
    dw 0;  // None
    dw 296;
    dw 336;
    dw 4;  // None
    dw 288;
    dw 340;
    dw 348;  // Fp2 mul start
    dw 128;
    dw 356;
    dw 352;  // None
    dw 140;
    dw 360;
    dw 348;  // None
    dw 140;
    dw 368;
    dw 352;  // None
    dw 128;
    dw 372;
    dw 8;  // Fp2 mul start
    dw 308;
    dw 380;
    dw 8;  // None
    dw 320;
    dw 384;
    dw 8;  // None
    dw 320;
    dw 392;
    dw 8;  // None
    dw 308;
    dw 396;
    dw 308;  // Fp2 Inv start
    dw 308;
    dw 412;
    dw 320;  // None
    dw 320;
    dw 416;
    dw 420;  // None
    dw 424;
    dw 20;
    dw 308;  // Fp2 Inv real part end
    dw 424;
    dw 428;
    dw 320;  // None
    dw 424;
    dw 432;
    dw 404;  // Fp2 mul start
    dw 428;
    dw 440;
    dw 408;  // None
    dw 436;
    dw 444;
    dw 404;  // None
    dw 436;
    dw 452;
    dw 408;  // None
    dw 428;
    dw 456;

    output_offsets_ptr_loc:
    dw 448;
    dw 460;
    dw 244;
    dw 256;
    dw 128;
    dw 140;
    dw 60;
    dw 72;
}
