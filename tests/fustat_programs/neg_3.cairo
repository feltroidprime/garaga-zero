%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, G1Point
from utils import scalar_to_base_neg3_le, neg_3_pow_alloc_80, scalar_to_epns
from modulo_circuit import ExtensionFieldModuloCircuit

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (p1, n1, ps1, ns1) = scalar_to_base_neg3_le(2 ** 127);
    let (p2, n2, ps2, ns2) = scalar_to_epns(2 ** 127);

    // assert p1 = p2;
    // assert n1 = n2;
    // assert ps1 = ps2;
    // assert ns1 = ns2;
    return ();
}
