%builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin, UInt384

from hash_to_curve import hash_to_curve
from sha import SHA256
from utils import pow2alloc128
from starkware.cairo.common.uint256 import Uint256


func main{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;

    let (sha256_ptr, sha256_ptr_start) = SHA256.init();
    let (pow2_array) = pow2alloc128();

    let input = Uint256(0x1, 0x2);

    with sha256_ptr, pow2_array {
        let (res) = hash_to_curve(1, input);
    }

    SHA256.finalize(sha256_ptr_start, sha256_ptr);
    return ();
}