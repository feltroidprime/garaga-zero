%builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from src.hash_to_field import HashToField32
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
        test_32_bytes_msg();
    }

    SHA256.finalize(sha256_ptr_start, sha256_ptr);
    return ();
}

func test_32_bytes_msg{
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
    let (res) = HashToField32.hash_to_field(chunks, 32, 2, 2);
    let f0 = res[0][0];
    let f1 = res[0][1];
    let f2 = res[1][0];
    let f3 = res[1][1];

    %{
        from garaga.hints.io import bigint_pack

        assert bigint_pack(ids.f0, 4, 2**96) == 0xc5103029faaf3369e638d7aaaba45eb8ae899038d6417ab9e39ce42db5eae1c6a483f2280a1c232d2eddf0d646bda31
        assert bigint_pack(ids.f1, 4, 2**96) == 0x863addcc3d140f28b567768e1a7914966055715f389a15ce9a1f0e7dd9a2232c05d9da1ee62bb814b1b020402aa24ba
        assert bigint_pack(ids.f2, 4, 2**96) == 0x10eba413385deaf700acc7abd69fa0cae6c40dbafbbf6efa49cf85e38f650392f3f43a8b38ace82c23178f2f14613549
        assert bigint_pack(ids.f3, 4, 2**96) == 0x17cd6387987d0ad3118d8901c0b9e4472a48f80d05c1fdcabe97468abec494770f8792e2c74c1663f99ea600fb4ee620
    %}
    return ();
}
