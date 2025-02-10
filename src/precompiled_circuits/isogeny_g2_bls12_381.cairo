from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls
func get_BLS12_381_ISOGENY_G2_circuit() -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 19;
    let input_len = 16;
    let witnesses_len = 16;
    let output_len = 16;
    let continuous_output = 0;
    let add_mod_n = 50;
    let mul_mod_n = 56;
    let n_assert_eq = 4;
    let name = 'isogeny_g2';
    let curve_id = 1;
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
    dw 20998772835403013723133745110;
    dw 42309400921263367166527682787;
    dw 22234476406464427060700513322;
    dw 1788423062685820484574739098;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 62996318506209041169401235226;
    dw 47700040249525763906039098025;
    dw 66703429219393281182101539967;
    dw 5365269188057461453724217294;
    dw 62996318506209041169401235230;
    dw 47700040249525763906039098025;
    dw 66703429219393281182101539967;
    dw 5365269188057461453724217294;
    dw 71112240510236689381472592781;
    dw 63464101381895050749791524180;
    dw 33351714609696640591050769983;
    dw 2682634594028730726862108647;
    dw 4766928827347717298991029969;
    dw 10781278656524793479022830477;
    dw 9709743111593370649258102954;
    dw 7153692250743281938298956393;
    dw 54880396502181392957329877603;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 12;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877663;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 76995500396477716984823731974;
    dw 75906307530368008683724219883;
    dw 2298250976105228295691265179;
    dw 6557551229848008443440710027;
    dw 20998772835403013723133745086;
    dw 42309400921263367166527682787;
    dw 22234476406464427060700513322;
    dw 1788423062685820484574739098;
    dw 62996318506209041169401235228;
    dw 47700040249525763906039098025;
    dw 66703429219393281182101539967;
    dw 5365269188057461453724217294;
    dw 71112240510236689381472592783;
    dw 63464101381895050749791524180;
    dw 33351714609696640591050769983;
    dw 2682634594028730726862108647;
    dw 26882032721644041326484884240;
    dw 54751607069736325100460378490;
    dw 70409175287137352358884958854;
    dw 5663339698505098201153340477;
    dw 54880396502181392957329877243;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 54880396502181392957329877459;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 18;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877657;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;

    add_offsets_ptr_loc:
    dw 112;  // Fp2 mul real part end
    dw 116;
    dw 108;
    dw 120;  // Fp2 mul imag part end
    dw 124;
    dw 128;
    dw 116;  // Fp2 add coeff 0/1
    dw 12;
    dw 132;
    dw 128;  // Fp2 add coeff 1/1
    dw 16;
    dw 136;
    dw 144;  // Fp2 mul real part end
    dw 148;
    dw 140;
    dw 152;  // Fp2 mul imag part end
    dw 156;
    dw 160;
    dw 148;  // Fp2 add coeff 0/1
    dw 4;
    dw 164;
    dw 160;  // Fp2 add coeff 1/1
    dw 8;
    dw 168;
    dw 176;  // Fp2 mul real part end
    dw 180;
    dw 172;
    dw 184;  // Fp2 mul imag part end
    dw 188;
    dw 192;
    dw 180;  // Fp2 add coeff 0/1
    dw 0;
    dw 196;
    dw 192;  // Fp2 add coeff 1/1
    dw 0;
    dw 200;
    dw 208;  // Fp2 mul real part end
    dw 212;
    dw 204;
    dw 216;  // Fp2 mul imag part end
    dw 220;
    dw 224;
    dw 212;  // Fp2 add coeff 0/1
    dw 28;
    dw 228;
    dw 224;  // Fp2 add coeff 1/1
    dw 32;
    dw 232;
    dw 240;  // Fp2 mul real part end
    dw 244;
    dw 236;
    dw 248;  // Fp2 mul imag part end
    dw 252;
    dw 256;
    dw 244;  // Fp2 add coeff 0/1
    dw 4;
    dw 260;
    dw 256;  // Fp2 add coeff 1/1
    dw 24;
    dw 264;
    dw 288;  // Fp2 mul real part end
    dw 292;
    dw 284;
    dw 296;  // Fp2 mul imag part end
    dw 300;
    dw 304;
    dw 292;  // Fp2 add coeff 0/1
    dw 48;
    dw 308;
    dw 304;  // Fp2 add coeff 1/1
    dw 52;
    dw 312;
    dw 320;  // Fp2 mul real part end
    dw 324;
    dw 316;
    dw 328;  // Fp2 mul imag part end
    dw 332;
    dw 336;
    dw 324;  // Fp2 add coeff 0/1
    dw 4;
    dw 340;
    dw 336;  // Fp2 add coeff 1/1
    dw 44;
    dw 344;
    dw 352;  // Fp2 mul real part end
    dw 356;
    dw 348;
    dw 360;  // Fp2 mul imag part end
    dw 364;
    dw 368;
    dw 356;  // Fp2 add coeff 0/1
    dw 40;
    dw 372;
    dw 368;  // Fp2 add coeff 1/1
    dw 40;
    dw 376;
    dw 384;  // Fp2 mul real part end
    dw 388;
    dw 380;
    dw 392;  // Fp2 mul imag part end
    dw 396;
    dw 400;
    dw 388;  // Fp2 add coeff 0/1
    dw 68;
    dw 404;
    dw 400;  // Fp2 add coeff 1/1
    dw 72;
    dw 408;
    dw 416;  // Fp2 mul real part end
    dw 420;
    dw 412;
    dw 424;  // Fp2 mul imag part end
    dw 428;
    dw 432;
    dw 420;  // Fp2 add coeff 0/1
    dw 4;
    dw 436;
    dw 432;  // Fp2 add coeff 1/1
    dw 64;
    dw 440;
    dw 448;  // Fp2 mul real part end
    dw 452;
    dw 444;
    dw 456;  // Fp2 mul imag part end
    dw 460;
    dw 464;
    dw 452;  // Fp2 add coeff 0/1
    dw 60;
    dw 468;
    dw 464;  // Fp2 add coeff 1/1
    dw 60;
    dw 472;
    dw 496;  // Fp2 mul real part end
    dw 500;
    dw 492;
    dw 504;  // Fp2 mul imag part end
    dw 508;
    dw 512;
    dw 196;  // None
    dw 272;
    dw 268;
    dw 276;  // None
    dw 280;
    dw 200;
    dw 372;  // None
    dw 480;
    dw 476;
    dw 484;  // None
    dw 488;
    dw 376;

    mul_offsets_ptr_loc:
    dw 20;  // Fp2 mul start
    dw 76;
    dw 108;
    dw 4;  // None
    dw 80;
    dw 112;
    dw 20;  // None
    dw 80;
    dw 120;
    dw 4;  // None
    dw 76;
    dw 124;
    dw 132;  // Fp2 mul start
    dw 76;
    dw 140;
    dw 136;  // None
    dw 80;
    dw 144;
    dw 132;  // None
    dw 80;
    dw 152;
    dw 136;  // None
    dw 76;
    dw 156;
    dw 164;  // Fp2 mul start
    dw 76;
    dw 172;
    dw 168;  // None
    dw 80;
    dw 176;
    dw 164;  // None
    dw 80;
    dw 184;
    dw 168;  // None
    dw 76;
    dw 188;
    dw 36;  // Fp2 mul start
    dw 76;
    dw 204;
    dw 4;  // None
    dw 80;
    dw 208;
    dw 36;  // None
    dw 80;
    dw 216;
    dw 4;  // None
    dw 76;
    dw 220;
    dw 228;  // Fp2 mul start
    dw 76;
    dw 236;
    dw 232;  // None
    dw 80;
    dw 240;
    dw 228;  // None
    dw 80;
    dw 248;
    dw 232;  // None
    dw 76;
    dw 252;
    dw 92;  // None
    dw 260;
    dw 268;
    dw 96;  // None
    dw 264;
    dw 272;
    dw 92;  // None
    dw 264;
    dw 276;
    dw 96;  // None
    dw 260;
    dw 280;
    dw 56;  // Fp2 mul start
    dw 76;
    dw 284;
    dw 4;  // None
    dw 80;
    dw 288;
    dw 56;  // None
    dw 80;
    dw 296;
    dw 4;  // None
    dw 76;
    dw 300;
    dw 308;  // Fp2 mul start
    dw 76;
    dw 316;
    dw 312;  // None
    dw 80;
    dw 320;
    dw 308;  // None
    dw 80;
    dw 328;
    dw 312;  // None
    dw 76;
    dw 332;
    dw 340;  // Fp2 mul start
    dw 76;
    dw 348;
    dw 344;  // None
    dw 80;
    dw 352;
    dw 340;  // None
    dw 80;
    dw 360;
    dw 344;  // None
    dw 76;
    dw 364;
    dw 36;  // Fp2 mul start
    dw 76;
    dw 380;
    dw 4;  // None
    dw 80;
    dw 384;
    dw 36;  // None
    dw 80;
    dw 392;
    dw 4;  // None
    dw 76;
    dw 396;
    dw 404;  // Fp2 mul start
    dw 76;
    dw 412;
    dw 408;  // None
    dw 80;
    dw 416;
    dw 404;  // None
    dw 80;
    dw 424;
    dw 408;  // None
    dw 76;
    dw 428;
    dw 436;  // Fp2 mul start
    dw 76;
    dw 444;
    dw 440;  // None
    dw 80;
    dw 448;
    dw 436;  // None
    dw 80;
    dw 456;
    dw 440;  // None
    dw 76;
    dw 460;
    dw 100;  // None
    dw 468;
    dw 476;
    dw 104;  // None
    dw 472;
    dw 480;
    dw 100;  // None
    dw 472;
    dw 484;
    dw 104;  // None
    dw 468;
    dw 488;
    dw 100;  // Fp2 mul start
    dw 84;
    dw 492;
    dw 104;  // None
    dw 88;
    dw 496;
    dw 100;  // None
    dw 88;
    dw 504;
    dw 104;  // None
    dw 84;
    dw 508;

    output_offsets_ptr_loc:
    dw 92;
    dw 96;
    dw 500;
    dw 512;
}
