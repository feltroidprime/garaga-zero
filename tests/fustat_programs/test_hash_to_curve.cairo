%builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from src.hash_to_curve import hash_to_curve
from src.sha import SHA256, HashUtils
from src.utils import pow2alloc128

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

    with sha256_ptr, pow2_array {
        test_32_bytes_msg_1();
    }

    SHA256.finalize(sha256_ptr_start, sha256_ptr);
    return ();
}

func test_32_bytes_msg_1{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    sha256_ptr: felt*,
    pow2_array: felt*,
}() {
    alloc_locals;

    // This is the signing root of sepl block 5800064
    let value = Uint256(
        low=0x135aa063454c6023e1fbafd896f89df9, high=0x18b90e7987b9393d878786da78fa13fd
    );
    let (chunks) = HashUtils.chunk_uint256(value);
    let (res) = hash_to_curve(1, value);
    let x0 = res.x0;
    let x1 = res.x1;
    let y0 = res.y0;
    let y1 = res.y1;

    %{
        from garaga.hints.io import bigint_pack

        assert bigint_pack(ids.x0, 4, 2**96) == 0x06fd28e02e2bd8c5d1d3a8d98a44454ca701eea859db2b05c74d1642fe6acb8c6b0c6c95636df4489997a8f0c75747b3
        assert bigint_pack(ids.x1, 4, 2**96) == 0x1361e963a16aa10cc23d8061977b83722d31adc850b61a992915cb135a0760c623a8fb5281cbb607f7184c5c9b9c2ab2
        assert bigint_pack(ids.y0, 4, 2**96) == 0x094e4da1e925991a4dd2c87269a633751adb1acfc7bb836b5a734483f24847c291e1ca11914b0ab6a34285c268f1db06
        assert bigint_pack(ids.y1, 4, 2**96) == 0x0362a0bdcbf2c423f7353331f9b2f6dc03dd7cff5b4c28e6bd172a2d631b8661ec6a1640aa16de1e351c3c44a635da99
    %}
    return ();
}