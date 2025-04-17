from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from garaga_zero_src.src.modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from garaga_zero_src.src.definitions import bn, bls
func get_BN254_FINAL_EXP_PART_2_circuit() -> (circuit: ExtensionFieldModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 10;
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
    let curve_id = 0;
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
    dw 52029209312474596632727321930;
    dw 20282885079442097227983633477;
    dw 1727392991374983226;
    dw 0;
    dw 35077268726521024975406259100;
    dw 7710187015875351603804077565;
    dw 911609717210363318;
    dw 0;
    dw 53496612365073116422123552767;
    dw 27817892214164604861749027825;
    dw 0;
    dw 0;
    dw 25887856965658863858427727295;
    dw 43090343555689186965775966723;
    dw 1187840055424275042;
    dw 0;
    dw 46988802293647173226506273025;
    dw 2103450114795955940866893283;
    dw 48405681784978803;
    dw 0;
    dw 32324006162389411176778628422;
    dw 57042285082623239461879769745;
    dw 3486998266802970665;
    dw 0;
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 82;
    dw 0;
    dw 0;
    dw 0;
    dw 32324006162389411176778628405;
    dw 57042285082623239461879769745;
    dw 3486998266802970665;
    dw 0;

    add_offsets_ptr_loc:
    dw 92;  // None
    dw 28;
    dw 258;
    dw 40;  // Fp6 add coeff 0/5
    dw 64;
    dw 262;
    dw 44;  // Fp6 add coeff 1/5
    dw 68;
    dw 266;
    dw 48;  // Fp6 add coeff 2/5
    dw 72;
    dw 270;
    dw 52;  // Fp6 add coeff 3/5
    dw 76;
    dw 274;
    dw 56;  // Fp6 add coeff 4/5
    dw 80;
    dw 278;
    dw 60;  // Fp6 add coeff 5/5
    dw 84;
    dw 282;
    dw 40;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 334;
    dw 338;
    dw 338;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 342;
    dw 346;
    dw 346;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 350;
    dw 354;
    dw 354;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 358;
    dw 362;
    dw 362;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 366;
    dw 370;
    dw 64;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 374;
    dw 378;
    dw 378;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 382;
    dw 386;
    dw 386;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 390;
    dw 394;
    dw 394;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 398;
    dw 402;
    dw 402;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 406;
    dw 410;
    dw 0;  // LHS_acc
    dw 418;
    dw 422;
    dw 112;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 426;
    dw 430;
    dw 430;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 434;
    dw 438;
    dw 438;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 442;
    dw 446;
    dw 446;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 450;
    dw 454;
    dw 454;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 458;
    dw 462;
    dw 262;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 466;
    dw 470;
    dw 470;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 474;
    dw 478;
    dw 478;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 482;
    dw 486;
    dw 486;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 490;
    dw 494;
    dw 494;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 498;
    dw 502;
    dw 422;  // LHS_acc
    dw 510;
    dw 514;
    dw 518;  // None
    dw 542;
    dw 546;
    dw 522;  // None
    dw 550;
    dw 554;
    dw 526;  // None
    dw 558;
    dw 562;
    dw 530;  // None
    dw 566;
    dw 570;
    dw 534;  // None
    dw 574;
    dw 578;
    dw 538;  // None
    dw 582;
    dw 586;
    dw 184;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 590;
    dw 594;
    dw 594;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 598;
    dw 602;
    dw 602;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 606;
    dw 610;
    dw 610;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 614;
    dw 618;
    dw 32;  // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    dw 622;
    dw 626;
    dw 626;  // Eval sparse poly UnnamedPoly step + 1*z^6
    dw 306;
    dw 630;
    dw 546;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 634;
    dw 638;
    dw 638;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 642;
    dw 646;
    dw 646;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 650;
    dw 654;
    dw 654;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 658;
    dw 662;
    dw 662;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 666;
    dw 670;
    dw 670;  // None
    dw 0;
    dw 678;
    dw 674;  // None
    dw 678;
    dw 682;
    dw 136;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 686;
    dw 690;
    dw 690;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 694;
    dw 698;
    dw 698;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 702;
    dw 706;
    dw 706;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 710;
    dw 714;
    dw 714;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 718;
    dw 722;
    dw 722;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 726;
    dw 730;
    dw 730;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 734;
    dw 738;
    dw 738;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 742;
    dw 746;
    dw 746;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 750;
    dw 754;
    dw 754;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 758;
    dw 762;
    dw 762;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 766;
    dw 770;
    dw 112;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 774;
    dw 778;
    dw 778;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 782;
    dw 786;
    dw 786;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 790;
    dw 794;
    dw 794;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 798;
    dw 802;
    dw 802;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 806;
    dw 810;
    dw 810;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 814;
    dw 818;
    dw 818;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 822;
    dw 826;
    dw 826;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 830;
    dw 834;
    dw 834;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 838;
    dw 842;
    dw 842;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 846;
    dw 850;
    dw 850;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 854;
    dw 858;
    dw 0;  // LHS_acc
    dw 866;
    dw 870;
    dw 204;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 922;
    dw 926;
    dw 926;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 930;
    dw 934;
    dw 934;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 938;
    dw 942;
    dw 942;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 946;
    dw 950;
    dw 950;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 954;
    dw 958;
    dw 958;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 962;
    dw 966;
    dw 966;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 970;
    dw 974;
    dw 974;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 978;
    dw 982;
    dw 982;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 986;
    dw 990;
    dw 990;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 994;
    dw 998;
    dw 32;  // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    dw 1002;
    dw 1006;
    dw 1006;  // Eval sparse poly UnnamedPoly step + 1*z^12
    dw 330;
    dw 1010;
    dw 874;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 1014;
    dw 1018;
    dw 1018;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 1022;
    dw 1026;
    dw 1026;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 1030;
    dw 1034;
    dw 1034;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 1038;
    dw 1042;
    dw 1042;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 1046;
    dw 1050;
    dw 1050;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 1054;
    dw 1058;
    dw 1058;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 1062;
    dw 1066;
    dw 1066;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 1070;
    dw 1074;
    dw 1074;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 1078;
    dw 1082;
    dw 1082;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 1086;
    dw 1090;
    dw 1090;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 1094;
    dw 1098;
    dw 1098;  // None
    dw 0;
    dw 1106;
    dw 1102;  // None
    dw 1106;
    dw 1110;
    dw 0;  // None
    dw 682;
    dw 514;
    dw 0;  // None
    dw 1110;
    dw 870;

    mul_offsets_ptr_loc:
    dw 248;  // None
    dw 248;
    dw 286;
    dw 253;  // Compute z^2
    dw 253;
    dw 290;
    dw 290;  // Compute z^3
    dw 253;
    dw 294;
    dw 294;  // Compute z^4
    dw 253;
    dw 298;
    dw 298;  // Compute z^5
    dw 253;
    dw 302;
    dw 302;  // Compute z^6
    dw 253;
    dw 306;
    dw 306;  // Compute z^7
    dw 253;
    dw 310;
    dw 310;  // Compute z^8
    dw 253;
    dw 314;
    dw 314;  // Compute z^9
    dw 253;
    dw 318;
    dw 318;  // Compute z^10
    dw 253;
    dw 322;
    dw 322;  // Compute z^11
    dw 253;
    dw 326;
    dw 326;  // Compute z^12
    dw 253;
    dw 330;
    dw 44;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 334;
    dw 48;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 342;
    dw 52;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 350;
    dw 56;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 358;
    dw 60;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 366;
    dw 68;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 374;
    dw 72;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 382;
    dw 76;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 390;
    dw 80;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 398;
    dw 84;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 406;
    dw 370;  // None
    dw 410;
    dw 414;
    dw 248;  // ci_XY_of_z
    dw 414;
    dw 418;
    dw 116;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 426;
    dw 120;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 434;
    dw 124;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 442;
    dw 128;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 450;
    dw 132;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 458;
    dw 266;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 466;
    dw 270;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 474;
    dw 274;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 482;
    dw 278;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 490;
    dw 282;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 498;
    dw 462;  // None
    dw 502;
    dw 506;
    dw 286;  // ci_XY_of_z
    dw 506;
    dw 510;
    dw 248;  // None
    dw 88;
    dw 518;
    dw 248;  // None
    dw 92;
    dw 522;
    dw 248;  // None
    dw 96;
    dw 526;
    dw 248;  // None
    dw 100;
    dw 530;
    dw 248;  // None
    dw 104;
    dw 534;
    dw 248;  // None
    dw 108;
    dw 538;
    dw 286;  // None
    dw 88;
    dw 542;
    dw 286;  // None
    dw 258;
    dw 550;
    dw 286;  // None
    dw 96;
    dw 558;
    dw 286;  // None
    dw 100;
    dw 566;
    dw 286;  // None
    dw 104;
    dw 574;
    dw 286;  // None
    dw 108;
    dw 582;
    dw 188;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 590;
    dw 192;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 598;
    dw 196;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 606;
    dw 200;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 614;
    dw 36;  // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 622;
    dw 554;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 634;
    dw 562;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 642;
    dw 570;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 650;
    dw 578;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 658;
    dw 586;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 666;
    dw 618;  // None
    dw 630;
    dw 674;
    dw 140;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 686;
    dw 144;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 694;
    dw 148;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 702;
    dw 152;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 710;
    dw 156;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 718;
    dw 160;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 306;
    dw 726;
    dw 164;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 310;
    dw 734;
    dw 168;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 314;
    dw 742;
    dw 172;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 318;
    dw 750;
    dw 176;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 322;
    dw 758;
    dw 180;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 326;
    dw 766;
    dw 24;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 774;
    dw 116;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 782;
    dw 0;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 790;
    dw 120;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 798;
    dw 0;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 806;
    dw 124;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 306;
    dw 814;
    dw 0;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 310;
    dw 822;
    dw 128;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 314;
    dw 830;
    dw 0;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 318;
    dw 838;
    dw 132;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 322;
    dw 846;
    dw 0;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 326;
    dw 854;
    dw 770;  // None
    dw 858;
    dw 862;
    dw 248;  // ci_XY_of_z
    dw 862;
    dw 866;
    dw 248;  // None
    dw 112;
    dw 874;
    dw 248;  // None
    dw 28;
    dw 878;
    dw 248;  // None
    dw 116;
    dw 882;
    dw 248;  // None
    dw 0;
    dw 886;
    dw 248;  // None
    dw 120;
    dw 890;
    dw 248;  // None
    dw 0;
    dw 894;
    dw 248;  // None
    dw 124;
    dw 898;
    dw 248;  // None
    dw 0;
    dw 902;
    dw 248;  // None
    dw 128;
    dw 906;
    dw 248;  // None
    dw 0;
    dw 910;
    dw 248;  // None
    dw 132;
    dw 914;
    dw 248;  // None
    dw 0;
    dw 918;
    dw 208;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 922;
    dw 212;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 930;
    dw 216;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 938;
    dw 220;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 946;
    dw 224;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 954;
    dw 228;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 306;
    dw 962;
    dw 232;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 310;
    dw 970;
    dw 236;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 314;
    dw 978;
    dw 240;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 318;
    dw 986;
    dw 244;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 322;
    dw 994;
    dw 36;  // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    dw 306;
    dw 1002;
    dw 878;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 253;
    dw 1014;
    dw 882;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 290;
    dw 1022;
    dw 886;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 294;
    dw 1030;
    dw 890;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 298;
    dw 1038;
    dw 894;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 302;
    dw 1046;
    dw 898;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 306;
    dw 1054;
    dw 902;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 310;
    dw 1062;
    dw 906;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 314;
    dw 1070;
    dw 910;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 318;
    dw 1078;
    dw 914;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 322;
    dw 1086;
    dw 918;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 326;
    dw 1094;
    dw 998;  // None
    dw 1010;
    dw 1102;

    output_offsets_ptr_loc:
    dw 136;
}
