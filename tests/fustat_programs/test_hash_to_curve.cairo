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
        run_fixture_g2();
    }

    SHA256.finalize(sha256_ptr_start, sha256_ptr);
    return ();
}

func run_fixture_g2{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    sha256_ptr: felt*,
    pow2_array: felt*,
}() {
    alloc_locals;

    local n_fixtures: felt;
    %{
        fixtures = program_input
        ids.n_fixtures = len(fixtures)
    %}

    run_fixture_g2_inner(0, n_fixtures);

    return ();
}

func run_fixture_g2_inner{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    sha256_ptr: felt*,
    pow2_array: felt*,
}(index: felt, n_fixtures: felt) {
    alloc_locals;

    if (index == n_fixtures) {
        return ();
    }

    local input: Uint256;
    %{
        print("Running Fixture: ", ids.index)
        high, low = divmod(int(fixtures[ids.index]["input"], 16), 2**128)
        ids.input.low = low
        ids.input.high = high
    %}

    let (res) = hash_to_curve(1, input);
    let x0 = res.x0;
    let x1 = res.x1;
    let y0 = res.y0;
    let y1 = res.y1;

    %{
        from garaga.hints.io import bigint_pack

        assert bigint_pack(ids.x0, 4, 2**96) == int(fixtures[ids.index]["point"]["x0"], 16)
        assert bigint_pack(ids.x1, 4, 2**96) == int(fixtures[ids.index]["point"]["x1"], 16)
        assert bigint_pack(ids.y0, 4, 2**96) == int(fixtures[ids.index]["point"]["y0"], 16)
        assert bigint_pack(ids.y1, 4, 2**96) == int(fixtures[ids.index]["point"]["y1"], 16)
    %}

    return run_fixture_g2_inner(index + 1, n_fixtures);
}
