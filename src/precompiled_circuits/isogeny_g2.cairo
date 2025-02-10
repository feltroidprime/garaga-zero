from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls

func get_ISOGENY_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 30;
    let input_len = 16;
    let witnesses_len = 16;
    let output_len = 16;
    let continuous_output = 0;
    let add_mod_n = 50;
    let mul_mod_n = 56;
    let n_assert_eq = 4;
    let name = 'isogeny_g2';
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
    dw 20998772835403013723133745110;
    dw 42309400921263367166527682787;
    dw 22234476406464427060700513322;
    dw 1788423062685820484574739098;
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
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
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
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 76995500396477716984823731974;
    dw 75906307530368008683724219883;
    dw 2298250976105228295691265179;
    dw 6557551229848008443440710027;
    dw 76995500396477716984823731974;
    dw 75906307530368008683724219883;
    dw 2298250976105228295691265179;
    dw 6557551229848008443440710027;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
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
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877243;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 54880396502181392957329877243;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
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
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 156;  // Fp2 mul real part end
    dw 160;
    dw 152;
    dw 164;  // Fp2 mul imag part end
    dw 168;
    dw 172;
    dw 160;  // Fp2 add real part
    dw 16;
    dw 176;
    dw 172;  // Fp2 add imag part
    dw 20;
    dw 180;
    dw 188;  // Fp2 mul real part end
    dw 192;
    dw 184;
    dw 196;  // Fp2 mul imag part end
    dw 200;
    dw 204;
    dw 192;  // Fp2 add real part
    dw 8;
    dw 208;
    dw 204;  // Fp2 add imag part
    dw 12;
    dw 212;
    dw 220;  // Fp2 mul real part end
    dw 224;
    dw 216;
    dw 228;  // Fp2 mul imag part end
    dw 232;
    dw 236;
    dw 224;  // Fp2 add real part
    dw 0;
    dw 240;
    dw 236;  // Fp2 add imag part
    dw 4;
    dw 244;
    dw 252;  // Fp2 mul real part end
    dw 256;
    dw 248;
    dw 260;  // Fp2 mul imag part end
    dw 264;
    dw 268;
    dw 256;  // Fp2 add real part
    dw 40;
    dw 272;
    dw 268;  // Fp2 add imag part
    dw 44;
    dw 276;
    dw 284;  // Fp2 mul real part end
    dw 288;
    dw 280;
    dw 292;  // Fp2 mul imag part end
    dw 296;
    dw 300;
    dw 288;  // Fp2 add real part
    dw 32;
    dw 304;
    dw 300;  // Fp2 add imag part
    dw 36;
    dw 308;
    dw 332;  // Fp2 mul real part end
    dw 336;
    dw 328;
    dw 340;  // Fp2 mul imag part end
    dw 344;
    dw 348;
    dw 336;  // Fp2 add real part
    dw 72;
    dw 352;
    dw 348;  // Fp2 add imag part
    dw 76;
    dw 356;
    dw 364;  // Fp2 mul real part end
    dw 368;
    dw 360;
    dw 372;  // Fp2 mul imag part end
    dw 376;
    dw 380;
    dw 368;  // Fp2 add real part
    dw 64;
    dw 384;
    dw 380;  // Fp2 add imag part
    dw 68;
    dw 388;
    dw 396;  // Fp2 mul real part end
    dw 400;
    dw 392;
    dw 404;  // Fp2 mul imag part end
    dw 408;
    dw 412;
    dw 400;  // Fp2 add real part
    dw 56;
    dw 416;
    dw 412;  // Fp2 add imag part
    dw 60;
    dw 420;
    dw 428;  // Fp2 mul real part end
    dw 432;
    dw 424;
    dw 436;  // Fp2 mul imag part end
    dw 440;
    dw 444;
    dw 432;  // Fp2 add real part
    dw 104;
    dw 448;
    dw 444;  // Fp2 add imag part
    dw 108;
    dw 452;
    dw 460;  // Fp2 mul real part end
    dw 464;
    dw 456;
    dw 468;  // Fp2 mul imag part end
    dw 472;
    dw 476;
    dw 464;  // Fp2 add real part
    dw 96;
    dw 480;
    dw 476;  // Fp2 add imag part
    dw 100;
    dw 484;
    dw 492;  // Fp2 mul real part end
    dw 496;
    dw 488;
    dw 500;  // Fp2 mul imag part end
    dw 504;
    dw 508;
    dw 496;  // Fp2 add real part
    dw 88;
    dw 512;
    dw 508;  // Fp2 add imag part
    dw 92;
    dw 516;
    dw 540;  // Fp2 mul real part end
    dw 544;
    dw 536;
    dw 548;  // Fp2 mul imag part end
    dw 552;
    dw 556;
    dw 240;  // None
    dw 316;
    dw 312;
    dw 320;  // None
    dw 324;
    dw 244;
    dw 416;  // None
    dw 524;
    dw 520;
    dw 528;  // None
    dw 532;
    dw 420;

    mul_offsets_ptr_loc:
    dw 24;  // Fp2 mul start
    dw 120;
    dw 152;
    dw 28;  // None
    dw 124;
    dw 156;
    dw 24;  // None
    dw 124;
    dw 164;
    dw 28;  // None
    dw 120;
    dw 168;
    dw 176;  // Fp2 mul start
    dw 120;
    dw 184;
    dw 180;  // None
    dw 124;
    dw 188;
    dw 176;  // None
    dw 124;
    dw 196;
    dw 180;  // None
    dw 120;
    dw 200;
    dw 208;  // Fp2 mul start
    dw 120;
    dw 216;
    dw 212;  // None
    dw 124;
    dw 220;
    dw 208;  // None
    dw 124;
    dw 228;
    dw 212;  // None
    dw 120;
    dw 232;
    dw 48;  // Fp2 mul start
    dw 120;
    dw 248;
    dw 52;  // None
    dw 124;
    dw 252;
    dw 48;  // None
    dw 124;
    dw 260;
    dw 52;  // None
    dw 120;
    dw 264;
    dw 272;  // Fp2 mul start
    dw 120;
    dw 280;
    dw 276;  // None
    dw 124;
    dw 284;
    dw 272;  // None
    dw 124;
    dw 292;
    dw 276;  // None
    dw 120;
    dw 296;
    dw 136;  // None
    dw 304;
    dw 312;
    dw 140;  // None
    dw 308;
    dw 316;
    dw 136;  // None
    dw 308;
    dw 320;
    dw 140;  // None
    dw 304;
    dw 324;
    dw 80;  // Fp2 mul start
    dw 120;
    dw 328;
    dw 84;  // None
    dw 124;
    dw 332;
    dw 80;  // None
    dw 124;
    dw 340;
    dw 84;  // None
    dw 120;
    dw 344;
    dw 352;  // Fp2 mul start
    dw 120;
    dw 360;
    dw 356;  // None
    dw 124;
    dw 364;
    dw 352;  // None
    dw 124;
    dw 372;
    dw 356;  // None
    dw 120;
    dw 376;
    dw 384;  // Fp2 mul start
    dw 120;
    dw 392;
    dw 388;  // None
    dw 124;
    dw 396;
    dw 384;  // None
    dw 124;
    dw 404;
    dw 388;  // None
    dw 120;
    dw 408;
    dw 112;  // Fp2 mul start
    dw 120;
    dw 424;
    dw 116;  // None
    dw 124;
    dw 428;
    dw 112;  // None
    dw 124;
    dw 436;
    dw 116;  // None
    dw 120;
    dw 440;
    dw 448;  // Fp2 mul start
    dw 120;
    dw 456;
    dw 452;  // None
    dw 124;
    dw 460;
    dw 448;  // None
    dw 124;
    dw 468;
    dw 452;  // None
    dw 120;
    dw 472;
    dw 480;  // Fp2 mul start
    dw 120;
    dw 488;
    dw 484;  // None
    dw 124;
    dw 492;
    dw 480;  // None
    dw 124;
    dw 500;
    dw 484;  // None
    dw 120;
    dw 504;
    dw 144;  // None
    dw 512;
    dw 520;
    dw 148;  // None
    dw 516;
    dw 524;
    dw 144;  // None
    dw 516;
    dw 528;
    dw 148;  // None
    dw 512;
    dw 532;
    dw 144;  // Fp2 mul start
    dw 128;
    dw 536;
    dw 148;  // None
    dw 132;
    dw 540;
    dw 144;  // None
    dw 132;
    dw 548;
    dw 148;  // None
    dw 128;
    dw 552;

    output_offsets_ptr_loc:
    dw 136;
    dw 140;
    dw 544;
    dw 556;
}
