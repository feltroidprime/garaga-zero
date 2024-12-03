// %builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.memcpy import memcpy

from hash_to_field import HashToField
from sha import SHA256, HashUtils
from utils import pow2alloc128
from definitions import G2Point
from ec_ops import add_ec_points_g2
from precompiled_circuits.map_to_curve_g2 import (
    get_MAP_TO_CURVE_G2_FIRST_STEP_circuit,
    get_MAP_TO_CURVE_G2_FIN_QUAD_circuit,
    get_MAP_TO_CURVE_G2_FIN_NON_QUAD_circuit
)
from precompiled_circuits.isogeny_g2 import get_ISOGENY_G2_circuit
from precompiled_circuits.cofactor_clearing import get_G2_COFACTOR_CLEARING_circuit
from modulo_circuit import run_modulo_circuit, ModuloCircuit

func hash_to_curve{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    pow2_array: felt*,
    sha256_ptr: felt*,
}(curve_id: felt, msg: Uint256) -> (curve_point: G2Point) {
    alloc_locals;
    // First we hash the message to field elements
    let (chunks) = HashUtils.chunk_uint256(msg);
    let (res) = HashToField.hash_to_field(chunks, 32, 2, 2);

    // The use simple swu to map the field elements to the curve
    let (p1) = map_to_curve_g2(res[0], curve_id);
    let (p2) = map_to_curve_g2(res[1], curve_id);

    let (added_points) = add_ec_points_g2(curve_id, p1, p2);
    let (isogeny_points) = apply_isogeny_g2(curve_id, added_points);
    let (cleared_points) = clear_cofactor_g2(curve_id, isogeny_points);

    return (curve_point=cleared_points);
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
            ids.is_quad_res = 1
        else:
            ids.is_quad_res = 0
    %}

    if (is_quad_res == 0) {
        // Non quadratic residue
        // we want [field, gx1, div, num_x1, zeta_u2]
        memcpy(input + 8, output, 32);

        let (circuit) = get_MAP_TO_CURVE_G2_FIN_NON_QUAD_circuit(curve_id);
        let (output: felt*) = run_modulo_circuit(circuit, input);

        return (point=[cast(output, G2Point*)]);
    } else {
        // Quadratic residue
        // we want [field, gx1, div, num_x1]
        memcpy(input + 8, output, 24);
        let (circuit) = get_MAP_TO_CURVE_G2_FIN_QUAD_circuit(curve_id);
        let (output: felt*) = run_modulo_circuit(circuit, input);

        return (point=[cast(output, G2Point*)]);
    }
}

func apply_isogeny_g2{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(curve_id: felt, point: G2Point) -> (point: G2Point) {
    alloc_locals;

    let (circuit) = get_ISOGENY_G2_circuit(curve_id);
    let (input: felt*) = alloc();
    assert input[0] = point.x0.d0;
    assert input[1] = point.x0.d1;
    assert input[2] = point.x0.d2;
    assert input[3] = point.x0.d3;
    assert input[4] = point.x1.d0;
    assert input[5] = point.x1.d1;
    assert input[6] = point.x1.d2;
    assert input[7] = point.x1.d3;
    assert input[8] = point.y0.d0;
    assert input[9] = point.y0.d1;
    assert input[10] = point.y0.d2;
    assert input[11] = point.y0.d3;
    assert input[12] = point.y1.d0;
    assert input[13] = point.y1.d1;
    assert input[14] = point.y1.d2;
    assert input[15] = point.y1.d3;

    let (output) = run_modulo_circuit(circuit, input);

    return (point=[cast(output, G2Point*)]);
}

func clear_cofactor_g2{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(curve_id: felt, point: G2Point) -> (point: G2Point) {
    let (circuit) = get_G2_COFACTOR_CLEARING_circuit(curve_id);
    let (input: felt*) = alloc();
    assert input[0] = point.x0.d0;
    assert input[1] = point.x0.d1;
    assert input[2] = point.x0.d2;
    assert input[3] = point.x0.d3;
    assert input[4] = point.x1.d0;
    assert input[5] = point.x1.d1;
    assert input[6] = point.x1.d2;
    assert input[7] = point.x1.d3;
    assert input[8] = point.y0.d0;
    assert input[9] = point.y0.d1;
    assert input[10] = point.y0.d2;
    assert input[11] = point.y0.d3;
    assert input[12] = point.y1.d0;
    assert input[13] = point.y1.d1;
    assert input[14] = point.y1.d2;
    assert input[15] = point.y1.d3;

    let (output) = run_modulo_circuit(circuit, input);

    return (point=[cast(output, G2Point*)]);

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
