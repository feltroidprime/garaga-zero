%builtins range_check bitwise range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, ModBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from src.hash_to_field import HashToField
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

    local n_fp2_tests;
    %{
        ids.n_fp2_tests = len(program_input["fp2"])
    %}

    with sha256_ptr, pow2_array {
        test_fp2_hash_to_field(0, n_fp2_tests);
    }

    SHA256.finalize(sha256_ptr_start, sha256_ptr);
    return ();
}

func test_fp2_hash_to_field{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    sha256_ptr: felt*,
    pow2_array: felt*,
}(index: felt, n_tests: felt) {
    alloc_locals;

    if (index == n_tests) {
        return ();
    }

    let (chunks) = alloc();
    local byte_length: felt;
    %{
        print("Running Fixture: ", ids.index)
        input_str = program_input["fp2"][ids.index]["input"]
        chunks = [int(input_str[i:i+8], 16) for i in range(0, len(input_str), 8)]
        segments.write_arg(ids.chunks, chunks)
        ids.byte_length = program_input["fp2"][ids.index]["byteLength"]
    %}

    let (res) = HashToField.hash_to_field(chunks, byte_length, 2, 2);
    let f0 = res[0][0];
    let f1 = res[0][1];
    let f2 = res[1][0];
    let f3 = res[1][1];

    %{
        from garaga.hints.io import bigint_pack
        print("res0", hex(bigint_pack(ids.f0, 4, 2**96)))
        print("exp0", program_input["fp2"][ids.index]["vals"][0][0])
        assert bigint_pack(ids.f0, 4, 2**96) == int(program_input["fp2"][ids.index]["vals"][0][0], 16)
        assert bigint_pack(ids.f1, 4, 2**96) == int(program_input["fp2"][ids.index]["vals"][0][1], 16)
        assert bigint_pack(ids.f2, 4, 2**96) == int(program_input["fp2"][ids.index]["vals"][1][0], 16)
        assert bigint_pack(ids.f3, 4, 2**96) == int(program_input["fp2"][ids.index]["vals"][1][1], 16)
    %}
    return test_fp2_hash_to_field(index + 1, n_tests);
}
