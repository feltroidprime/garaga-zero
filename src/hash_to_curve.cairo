// %builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.memcpy import memcpy

from hash_to_field import HashToField32
from sha import SHA256, HashUtils
from utils import pow2alloc128
from definitions import G2Point
from ec_ops import add_ec_points_g2
from precompiled_circuits.map_to_curve_g2 import (
    get_MAP_TO_CURVE_G2_FIRST_STEP_circuit,
    get_MAP_TO_CURVE_G2_FIN_QUAD_circuit,
    get_MAP_TO_CURVE_G2_FIN_NON_QUAD_circuit
)
from modulo_circuit import run_modulo_circuit, ModuloCircuit


func hash_to_curve{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    pow2_array: felt*,
    sha256_ptr: felt*,
}(curve_id: felt, msg: Uint256) {
    alloc_locals;
    // First we hash the message to field elements
    let (chunks) = HashUtils.chunk_uint256(msg);
    let (res) = HashToField32.hash_to_field(chunks, 32, 2, 2);

    // The use simple swu to map the field elements to the curve
    let (p1) = map_to_curve_g2(res[0], curve_id);
    print_g2(p1);
    let (p2) = map_to_curve_g2(res[1], curve_id);
    print_g2(p2);

    let (added_points) = add_ec_points_g2(curve_id, p1, p2);

    print_g2(added_points);

    return ();
}

func map_to_curve_g2{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    pow2_array: felt*
    
}(field: UInt384*, curve_id: felt) -> (point: G2Point) {
    alloc_locals;

    %{ print("Printing input fields") %}
    print_field(field[0]);
    print_field(field[1]);
    
    let (circuit) = get_MAP_TO_CURVE_G2_FIRST_STEP_circuit(curve_id);
    let (local input: felt*) = alloc();
    assert input[0] = field[0].d0; // x
    assert input[1] = field[0].d1;
    assert input[2] = field[0].d2;
    assert input[3] = field[0].d3;
    assert input[4] = field[1].d0; // y
    assert input[5] = field[1].d1;
    assert input[6] = field[1].d2;
    assert input[7] = field[1].d3;
    let (output: felt*) = run_modulo_circuit(circuit, input);

    let values = cast(output, UInt384*);
    let g1xx = values[0];
    let g1xy = values[1];
    local is_quad_res: felt;

    %{
        from garaga.hints.io import bigint_pack
        from garaga.algebra import Fp2
        from garaga.definitions import CURVES

        g1x = bigint_pack(ids.g1xx, 4, 2**96)
        g1y = bigint_pack(ids.g1xy, 4, 2**96)

        if Fp2(PyFelt(g1x, CURVES[ids.curve_id].p), PyFelt(g1y, CURVES[ids.curve_id].p)).is_quad_residue():
            print("Quadratic residue")
            ids.is_quad_res = 1
        else:
            print("Non quadratic residue")
            ids.is_quad_res = 0
    %}

    if (is_quad_res == 0) {
        // Non quadratic residue
        // we want [field, gx1, div, num_x1, zeta_u2]
        memcpy(input + 8, output, 32);
        %{
            i = 0
            while i < 40:
                value = hex(memory[ids.input + i + 3] * 2**288 + memory[ids.input + i + 2] * 2**192 + memory[ids.input + i + 1] * 2**96 + memory[ids.input + i])
                print(value)
                i += 4
        %}

        let (circuit) = get_MAP_TO_CURVE_G2_FIN_NON_QUAD_circuit(curve_id);
        let (output: felt*) = run_modulo_circuit(circuit, input);

        return (point=[cast(output, G2Point*)]);
    } else {
        // Quadratic residue
        // we want [field, gx1, div, num_x1]
        memcpy(input + 8, output, 24);
        %{
            i = 0
            while i < 32:
                value = hex(memory[ids.input + i + 3] * 2**288 + memory[ids.input + i + 2] * 2**192 + memory[ids.input + i + 1] * 2**96 + memory[ids.input + i])
                print(value)
                i += 4
        %}
        let (circuit) = get_MAP_TO_CURVE_G2_FIN_QUAD_circuit(curve_id);
        let (output: felt*) = run_modulo_circuit(circuit, input);

        return (point=[cast(output, G2Point*)]);
    }

    

    // return (point=[cast(output, UInt384*)]);

    // return ();

}

func hex_print_field(field: UInt384) {
    %{
        from garaga.hints.io import bigint_pack
        print("Field:")
        print(hex(bigint_pack(ids.field, 4, 2**96)))
    %}
    return ();
}

func print_field(field: UInt384) {
    %{
        from garaga.hints.io import bigint_pack
        print("Field:")
        print(bigint_pack(ids.field, 4, 2**96))
    %}
    return ();
}



func print_g2(point: G2Point) {
    let l0 = point.x0;
    let l1 = point.x1;
    let l2 = point.y0;
    let l3 = point.y1;

    %{
        from garaga.hints.io import bigint_pack
        print("G2Point:")

        print("x0",bigint_pack(ids.l0, 4, 2**96))
        print("x1",bigint_pack(ids.l1, 4, 2**96))
        print("y0",bigint_pack(ids.l2, 4, 2**96))
        print("y1",bigint_pack(ids.l3, 4, 2**96))
        print("________________________________")

    %}

    return ();
}

func hex_print_g2(point: G2Point) {
    let l0 = point.x0;
    let l1 = point.x1;
    let l2 = point.y0;
    let l3 = point.y1;

    %{
        from garaga.hints.io import bigint_pack
        print("G2Point:")

        print("x0", hex(bigint_pack(ids.l0, 4, 2**96)))
        print("x1", hex(bigint_pack(ids.l1, 4, 2**96)))
        print("y0", hex(bigint_pack(ids.l2, 4, 2**96)))
        print("y1", hex(bigint_pack(ids.l3, 4, 2**96)))
        print("________________________________")

    %}

    return ();
}
// func is_on_curve_g1{
//     range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
// }(curve_id: felt, point: G1Point) -> (res: felt) {
//     alloc_locals;
//     let (P) = get_P(curve_id);
//     let (A) = get_a(curve_id);
//     let (B) = get_b(curve_id);
//     let (circuit) = get_IS_ON_CURVE_G1_circuit(curve_id);
//     let (input: UInt384*) = alloc();
//     assert input[0] = point.x;
//     assert input[1] = point.y;
//     assert input[2] = A;
//     assert input[3] = B;
//     let (output: felt*) = run_modulo_circuit(circuit, input);
//     let (check_g1: felt) = is_zero_mod_p([cast(output, UInt384*)], P);
//     return (res=check_g1);
// }

// point: (
// x_affine: QuadExtField { c0: 2843075373688611471290556504186176053275483247291128525980163517764803526616259371130035811825227707920936817728741, c1: 3661712616179456093275454398202160102594067191736010383603184812959944211042529505618295008186663134429283699505891 }
// y_affine: QuadExtField { c0: 2229899020770589661585214900480830515873415727829711460134445858387853696109925143060238999266818473086058450471795, c1: 3127664777588830509127251096086955764006894160737524705993294599144750103128110100147816255502757346871240956727581 }
// // field
// 0xA1D5F7F60126BA84C5A337F4E9AE2D02EF018A7FD34C6EFF78B3BCC327D8CA8F28ED9A9344B3CEF5B6946D0078D34F3
// 0xE7F6F005FA2404BE24F13FC6BF9FACABC9F7B01D4A0FA1DF8695251163C27437AFCCF0D3EB4E611FE8DD14BCD1BB881
// // g1x
// 0xB50831EF20F0B6B45B2ADBAC36CC24FE46A52E323580C4D7243B177B5D9A8AD09DF1CB045BC609A167955AA8978FF0F
// 0x40BC3409116DEA514980214AA660A3EA97B7E37D6BD47662FCDCDF7F4344A9951B78A7AD6AB1F33B2D7E53B6C392A3D
// // div
// 0x1984E26339CAD9A8ABE91E741F0E6172E893EBAB90DF7C1E78D489CD5BA242954F2B0511FE8924CD43F1517DF240773
// 0x119B813348B5C33D44B9632B77E74339C280F1AE8F1B0304F0C5B083C428246888647DE3207E3750DE97BA3BF052E95C
// // numx1
// 0x4690C3AE80850CA76720C3222A4B8366F58745AB7D0A8E9B5D7C3BE7EF5873A3296305B1D114FFB791D9A09441EB8A3
// 0x3201523033E7DA3EF076202B9ADAEF758782760BDE9FAE90B0E41D230CCA42CF62254A19B02882E38544BEC2F01F49D


// Quadratic residue
// 0xa1d5f7f60126ba84c5a337f4e9ae2d02ef018a7fd34c6eff78b3bcc327d8ca8f28ed9a9344b3cef5b6946d0078d34f3
// 0xe7f6f005fa2404be24f13fc6bf9facabc9f7b01d4a0fa1df8695251163c27437afccf0d3eb4e611fe8dd14bcd1bb881
// 0xb50831ef20f0b6b45b2adbac36cc24fe46a52e323580c4d7243b177b5d9a8ad09df1cb045bc609a167955aa8978ff0f
// 0x40bc3409116dea514980214aa660a3ea97b7e37d6bd47662fcdcdf7f4344a9951b78a7ad6ab1f33b2d7e53b6c392a3d
// 0x1984e26339cad9a8abe91e741f0e6172e893ebab90df7c1e78d489cd5ba242954f2b0511fe8924cd43f1517df240773
// 0x119b813348b5c33d44b9632b77e74339c280f1ae8f1b0304f0c5b083c428246888647de3207e3750de97ba3bf052e95c
// 0x4690c3ae80850ca76720c3222a4b8366f58745ab7d0a8e9b5d7c3be7ef5873a3296305b1d114ffb791d9a09441eb8a3
// 0x3201523033e7da3ef076202b9adaef758782760bde9fae90b0e41d230cca42cf62254a19b02882e38544bec2f01f49d

// Map to curve 1
// x0 Fp2 {
//   c0: Fp {
//     value: 2843075373688611471290556504186176053275483247291128525980163517764803526616259371130035811825227707920936817728741n
//   },
//   c1: Fp {
//     value: 3661712616179456093275454398202160102594067191736010383603184812959944211042529505618295008186663134429283699505891n
//   }
// }
// y0 Fp2 {
//   c0: Fp {
//     value: 2229899020770589661585214900480830515873415727829711460134445858387853696109925143060238999266818473086058450471795n
//   },
//   c1: Fp {
//     value: 3127664777588830509127251096086955764006894160737524705993294599144750103128110100147816255502757346871240956727581n
//   }
// }
// Map to curve 2
// x1 Fp2 {
//   c0: Fp {
//     value: 2006413752686223508612366075043722458232321744863932880413784802489452766740742045984482044248764924205010366531647n
//   },
//   c1: Fp {
//     value: 2103918733930157635900741069076788853417130098910518594897125230089087553459780427160470339353748226243766968776215n
//   }
// }
// y1 Fp2 {
//   c0: Fp {
//     value: 2345181275451808874246097791768578660839971403546046193253448677984295781774410213317345275973043584946083029690838n
//   },
//   c1: Fp {
//     value: 491718355885353185704655750809656447183587281146662745649897882009019112506313662303269809992594062560315039747134n
//   }
// }


// x_affine: QuadExtField { 
// c0: 2006413752686223508612366075043722458232321744863932880413784802489452766740742045984482044248764924205010366531647, 
// c1: 2103918733930157635900741069076788853417130098910518594897125230089087553459780427160470339353748226243766968776215 }
// // y_affine: QuadExtField { 
// c0: 2345181275451808874246097791768578660839971403546046193253448677984295781774410213317345275973043584946083029690838, 
// c1: 491718355885353185704655750809656447183587281146662745649897882009019112506313662303269809992594062560315039747134 }


// y: QuadExtField { 
// c0: 2345181275451808874246097791768578660839971403546046193253448677984295781774410213317345275973043584946083029690838, 
// c1: 491718355885353185704655750809656447183587281146662745649897882009019112506313662303269809992594062560315039747134 }
// -y: QuadExtField { 
// c0: 1657228279769858519171692033967325495716911416392961692078609458139735868716427651125342353155972079091811242868949, 
// c1: 3510691199336314207713134074926247709373295538792345139682160254115012537984524202139417819136421601477579232812653 }

// x2 Fp2 {
//   c0: Fp {
//     value: 169519152402139697623491793754012113789032894758910773796231348501731795490199910990796174115277871812568749679080n
//   },
//   c1: Fp {
//     value: 1728095456082680609005278389175634228411286941580472237217092659287996601824281397719739792814994738024437208024916n
//   }
// }
// y2 Fp2 {
//   c0: Fp {
//     value: 921899175962300040840420456901482071750200770271137541308616448315528969776376924836021205171957295791079922974103n
//   },
//   c1: Fp {
//     value: 3684633599184560222490700115577520911020962810206788383522966831012065752604210815152740734710545831758791724608234n
//   }
// }