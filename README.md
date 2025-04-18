# Garaga Zero

Cairo Zero version library of [garaga](https://github.com/keep-starknet-strange/garaga).
Made for the most efficient local proving performance.

## Setup

```
git clone https://github.com/feltroidprime/garaga-zero.git
cd garaga-zero
make setup
source .venv/bin/activate
```

## Compile

```
cairo-compile tests/fustat_programs/test_mpc_bls_2.cairo --proof_mode --cairo_path 'src' --output main.json
```

## Generate trace

```
cairo-run --program main.json --layout=all_cairo --proof_mode --print_info --air_public_input public.json --air_private_input private.json
```

## Generate proof

...
