%builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin, UInt384

from hash_to_curve import hash_to_curve
from sha import SHA256
from utils import pow2alloc128
from starkware.cairo.common.uint256 import Uint256
from debug import print_string, print_uint384

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

    let input = Uint256(0x4662d4bed86f8dcb6fe512eb3a3dd9d9, 0x78bae696b73a50a536530bb189feb6e9);

    with sha256_ptr, pow2_array {
        let (res) = hash_to_curve(1, input);
        print_uint384(res.x0);
        print_uint384(res.x1);
        print_uint384(res.y0);
        print_uint384(res.y1);
        SHA256.finalize(sha256_ptr_start, sha256_ptr);
    }

    return ();
}