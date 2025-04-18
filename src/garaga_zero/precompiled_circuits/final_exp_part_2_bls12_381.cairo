from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from garaga_zero.modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from garaga_zero.definitions import bn, bls
func get_BLS12_381_FINAL_EXP_PART_2_circuit() -> (circuit: ExtensionFieldModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 8;
    let input_len = 48;
    let commitments_len = 160;
    let witnesses_len = 0;
    let big_Q_len = 64;
    let output_len = 48;
    let continuous_output = 1;
    let add_mod_n = 98;
    let mul_mod_n = 118;
    let n_assert_eq = 2;
    let N_Euclidean_equations = 0;
    let name = 'final_exp_part_2';
    let curve_id = 1;
    local circuit: ExtensionFieldModuloCircuit = ExtensionFieldModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        commitments_len,
        big_Q_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        N_Euclidean_equations,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 11605117395469174891688198422;
    dw 43302359525357855774867078766;
    dw 22497959677678942090347384814;
    dw 1763595377892035876004297323;
    dw 24538776241284729507437128365;
    dw 42550757554255812588943452139;
    dw 30896359077101218988767419092;
    dw 8047903782086192178990825606;
    dw 35566625740316527277988105225;
    dw 37127840730814273605658450223;
    dw 33368165978403992854926148446;
    dw 2068538268313381196677636973;
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
    dw 54880396502181392957329877673;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;

    add_offsets_ptr_loc:
    dw 84;  // None
    dw 20;
    dw 250;
    dw 32;  // Fp6 add coeff 0/5
    dw 56;
    dw 254;
    dw 36;  // Fp6 add coeff 1/5
    dw 60;
    dw 258;
    dw 40;  // Fp6 add coeff 2/5
    dw 64;
    dw 262;
    dw 44;  // Fp6 add coeff 3/5
    dw 68;
    dw 266;
    dw 48;  // Fp6 add coeff 4/5
    dw 72;
    dw 270;
    dw 52;  // Fp6 add coeff 5/5
    dw 76;
    dw 274;
    dw 32;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 326;
    dw 330;
    dw 330;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 334;
    dw 338;
    dw 338;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 342;
    dw 346;
    dw 346;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 350;
    dw 354;
    dw 354;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 358;
    dw 362;
    dw 56;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 366;
    dw 370;
    dw 370;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 374;
    dw 378;
    dw 378;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 382;
    dw 386;
    dw 386;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 390;
    dw 394;
    dw 394;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 398;
    dw 402;
    dw 0;  // LHS_acc
    dw 410;
    dw 414;
    dw 104;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 418;
    dw 422;
    dw 422;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 426;
    dw 430;
    dw 430;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 434;
    dw 438;
    dw 438;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 442;
    dw 446;
    dw 446;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 450;
    dw 454;
    dw 254;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 458;
    dw 462;
    dw 462;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 466;
    dw 470;
    dw 470;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 474;
    dw 478;
    dw 478;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 482;
    dw 486;
    dw 486;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 490;
    dw 494;
    dw 414;  // LHS_acc
    dw 502;
    dw 506;
    dw 510;  // None
    dw 534;
    dw 538;
    dw 514;  // None
    dw 542;
    dw 546;
    dw 518;  // None
    dw 550;
    dw 554;
    dw 522;  // None
    dw 558;
    dw 562;
    dw 526;  // None
    dw 566;
    dw 570;
    dw 530;  // None
    dw 574;
    dw 578;
    dw 176;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 582;
    dw 586;
    dw 586;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 590;
    dw 594;
    dw 594;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 598;
    dw 602;
    dw 602;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 606;
    dw 610;
    dw 24;  // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    dw 614;
    dw 618;
    dw 618;  // Eval sparse poly UnnamedPoly step + 1*z^6
    dw 298;
    dw 622;
    dw 538;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 626;
    dw 630;
    dw 630;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 634;
    dw 638;
    dw 638;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 642;
    dw 646;
    dw 646;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 650;
    dw 654;
    dw 654;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 658;
    dw 662;
    dw 662;  // None
    dw 0;
    dw 670;
    dw 666;  // None
    dw 670;
    dw 674;
    dw 128;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 678;
    dw 682;
    dw 682;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 686;
    dw 690;
    dw 690;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 694;
    dw 698;
    dw 698;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 702;
    dw 706;
    dw 706;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 710;
    dw 714;
    dw 714;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 718;
    dw 722;
    dw 722;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 726;
    dw 730;
    dw 730;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 734;
    dw 738;
    dw 738;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 742;
    dw 746;
    dw 746;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 750;
    dw 754;
    dw 754;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 758;
    dw 762;
    dw 104;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 766;
    dw 770;
    dw 770;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 774;
    dw 778;
    dw 778;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 782;
    dw 786;
    dw 786;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 790;
    dw 794;
    dw 794;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 798;
    dw 802;
    dw 802;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 806;
    dw 810;
    dw 810;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 814;
    dw 818;
    dw 818;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 822;
    dw 826;
    dw 826;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 830;
    dw 834;
    dw 834;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 838;
    dw 842;
    dw 842;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 846;
    dw 850;
    dw 0;  // LHS_acc
    dw 858;
    dw 862;
    dw 196;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 914;
    dw 918;
    dw 918;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 922;
    dw 926;
    dw 926;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 930;
    dw 934;
    dw 934;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 938;
    dw 942;
    dw 942;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 946;
    dw 950;
    dw 950;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 954;
    dw 958;
    dw 958;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 962;
    dw 966;
    dw 966;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 970;
    dw 974;
    dw 974;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 978;
    dw 982;
    dw 982;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 986;
    dw 990;
    dw 24;  // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    dw 994;
    dw 998;
    dw 998;  // Eval sparse poly UnnamedPoly step + 1*z^12
    dw 322;
    dw 1002;
    dw 866;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 1006;
    dw 1010;
    dw 1010;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 1014;
    dw 1018;
    dw 1018;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 1022;
    dw 1026;
    dw 1026;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 1030;
    dw 1034;
    dw 1034;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 1038;
    dw 1042;
    dw 1042;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 1046;
    dw 1050;
    dw 1050;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 1054;
    dw 1058;
    dw 1058;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 1062;
    dw 1066;
    dw 1066;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 1070;
    dw 1074;
    dw 1074;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 1078;
    dw 1082;
    dw 1082;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 1086;
    dw 1090;
    dw 1090;  // None
    dw 0;
    dw 1098;
    dw 1094;  // None
    dw 1098;
    dw 1102;
    dw 0;  // None
    dw 674;
    dw 506;
    dw 0;  // None
    dw 1102;
    dw 862;

    mul_offsets_ptr_loc:
    dw 240;  // None
    dw 240;
    dw 278;
    dw 245;  // Compute z^2
    dw 245;
    dw 282;
    dw 282;  // Compute z^3
    dw 245;
    dw 286;
    dw 286;  // Compute z^4
    dw 245;
    dw 290;
    dw 290;  // Compute z^5
    dw 245;
    dw 294;
    dw 294;  // Compute z^6
    dw 245;
    dw 298;
    dw 298;  // Compute z^7
    dw 245;
    dw 302;
    dw 302;  // Compute z^8
    dw 245;
    dw 306;
    dw 306;  // Compute z^9
    dw 245;
    dw 310;
    dw 310;  // Compute z^10
    dw 245;
    dw 314;
    dw 314;  // Compute z^11
    dw 245;
    dw 318;
    dw 318;  // Compute z^12
    dw 245;
    dw 322;
    dw 36;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 326;
    dw 40;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 334;
    dw 44;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 342;
    dw 48;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 350;
    dw 52;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 358;
    dw 60;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 366;
    dw 64;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 374;
    dw 68;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 382;
    dw 72;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 390;
    dw 76;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 398;
    dw 362;  // None
    dw 402;
    dw 406;
    dw 240;  // ci_XY_of_z
    dw 406;
    dw 410;
    dw 108;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 418;
    dw 112;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 426;
    dw 116;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 434;
    dw 120;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 442;
    dw 124;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 450;
    dw 258;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 458;
    dw 262;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 466;
    dw 266;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 474;
    dw 270;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 482;
    dw 274;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 490;
    dw 454;  // None
    dw 494;
    dw 498;
    dw 278;  // ci_XY_of_z
    dw 498;
    dw 502;
    dw 240;  // None
    dw 80;
    dw 510;
    dw 240;  // None
    dw 84;
    dw 514;
    dw 240;  // None
    dw 88;
    dw 518;
    dw 240;  // None
    dw 92;
    dw 522;
    dw 240;  // None
    dw 96;
    dw 526;
    dw 240;  // None
    dw 100;
    dw 530;
    dw 278;  // None
    dw 80;
    dw 534;
    dw 278;  // None
    dw 250;
    dw 542;
    dw 278;  // None
    dw 88;
    dw 550;
    dw 278;  // None
    dw 92;
    dw 558;
    dw 278;  // None
    dw 96;
    dw 566;
    dw 278;  // None
    dw 100;
    dw 574;
    dw 180;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 582;
    dw 184;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 590;
    dw 188;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 598;
    dw 192;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 606;
    dw 28;  // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 614;
    dw 546;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 626;
    dw 554;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 634;
    dw 562;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 642;
    dw 570;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 650;
    dw 578;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 658;
    dw 610;  // None
    dw 622;
    dw 666;
    dw 132;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 678;
    dw 136;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 686;
    dw 140;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 694;
    dw 144;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 702;
    dw 148;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 710;
    dw 152;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 298;
    dw 718;
    dw 156;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 302;
    dw 726;
    dw 160;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 306;
    dw 734;
    dw 164;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 310;
    dw 742;
    dw 168;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 314;
    dw 750;
    dw 172;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 318;
    dw 758;
    dw 16;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 766;
    dw 108;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 774;
    dw 0;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 782;
    dw 112;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 790;
    dw 0;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 798;
    dw 116;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 298;
    dw 806;
    dw 0;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 302;
    dw 814;
    dw 120;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 306;
    dw 822;
    dw 0;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 310;
    dw 830;
    dw 124;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 314;
    dw 838;
    dw 0;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 318;
    dw 846;
    dw 762;  // None
    dw 850;
    dw 854;
    dw 240;  // ci_XY_of_z
    dw 854;
    dw 858;
    dw 240;  // None
    dw 104;
    dw 866;
    dw 240;  // None
    dw 20;
    dw 870;
    dw 240;  // None
    dw 108;
    dw 874;
    dw 240;  // None
    dw 0;
    dw 878;
    dw 240;  // None
    dw 112;
    dw 882;
    dw 240;  // None
    dw 0;
    dw 886;
    dw 240;  // None
    dw 116;
    dw 890;
    dw 240;  // None
    dw 0;
    dw 894;
    dw 240;  // None
    dw 120;
    dw 898;
    dw 240;  // None
    dw 0;
    dw 902;
    dw 240;  // None
    dw 124;
    dw 906;
    dw 240;  // None
    dw 0;
    dw 910;
    dw 200;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 914;
    dw 204;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 922;
    dw 208;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 930;
    dw 212;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 938;
    dw 216;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 946;
    dw 220;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 298;
    dw 954;
    dw 224;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 302;
    dw 962;
    dw 228;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 306;
    dw 970;
    dw 232;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 310;
    dw 978;
    dw 236;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 314;
    dw 986;
    dw 28;  // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    dw 298;
    dw 994;
    dw 870;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 245;
    dw 1006;
    dw 874;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 282;
    dw 1014;
    dw 878;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 286;
    dw 1022;
    dw 882;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 290;
    dw 1030;
    dw 886;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 294;
    dw 1038;
    dw 890;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 298;
    dw 1046;
    dw 894;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 302;
    dw 1054;
    dw 898;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 306;
    dw 1062;
    dw 902;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 310;
    dw 1070;
    dw 906;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 314;
    dw 1078;
    dw 910;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 318;
    dw 1086;
    dw 990;  // None
    dw 1002;
    dw 1094;

    output_offsets_ptr_loc:
    dw 128;
}
