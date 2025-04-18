%builtins range_check bitwise
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from garaga_zero_src.src.sha import SHA256, sha256, HashUtils
from garaga_zero_src.src.utils import pow2alloc128

func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (sha256_ptr, sha256_ptr_start) = SHA256.init();
    let (pow2_array) = pow2alloc128();
    local length: felt;

    %{
        import random
        import os

        def generate_hex_array(N):
            hex_array = [os.urandom(i).hex() for i in range(1, N + 1)]
            return hex_array

        preimages = generate_hex_array(150)
        print(preimages)

        ids.length = len(preimages)
    %}

    with sha256_ptr, pow2_array {
        run_test(index=length - 1);
    }

    SHA256.finalize(sha256_start_ptr=sha256_ptr_start, sha256_end_ptr=sha256_ptr);

    return ();
}

func run_test{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*, pow2_array: felt*}(
    index: felt
) {
    alloc_locals;

    if (index == 0) {
        return ();
    }

    let (input: felt*) = alloc();
    local n_bytes: felt;
    local expected: Uint256;
    %{
        import hashlib
        # This function chunks from MSB to LSB
        def hex_to_chunks_32(hex_string: str):
            # Remove '0x' prefix if present
            if hex_string.startswith(('0x', '0X')):
                hex_string = hex_string[2:]

            # if we have an odd number of characters, prepend a 0
            if len(hex_string) % 2 == 1:
                hex_string = '0' + hex_string

            # Now split into 8-character (32-bit) chunks
            chunks = [int(hex_string[i:i+8], 16) for i in range(0, len(hex_string), 8)]
            return chunks


        preimage = int(preimages[ids.index], 16)
        ids.n_bytes = (preimage.bit_length() + 7) // 8

        expected = hashlib.sha256(preimage.to_bytes(length=ids.n_bytes, byteorder='big')).hexdigest()
        ids.expected.high, ids.expected.low = divmod(int(expected, 16), 2**128)

        chunks = hex_to_chunks_32(hex(preimage))
        segments.write_arg(ids.input, chunks)
    %}

    with sha256_ptr, pow2_array {
        let (output) = sha256(data=input, n_bytes=n_bytes);
        let hash = HashUtils.chunks_to_uint256(output=output);
        assert hash.high = expected.high;
        assert hash.low = expected.low;
    }

    return run_test(index=index - 1);
}
