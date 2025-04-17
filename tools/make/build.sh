#!/bin/bash

process_cairo_file() {
	local cairo_file="$1"
	local filename=$(basename "$cairo_file" .cairo)
	local first_line=$(head -n 1 "$cairo_file")

	if [[ $first_line == "%lang starknet" ]]; then
		echo "Compiling $cairo_file using starknet-compile ..."
		starknet-compile "$cairo_file" --output "build/compiled_cairo_files/$filename.json" --abi "build/compiled_cairo_files/$filename_abi.json"
	else
		cairo-compile "$cairo_file" --output "build/compiled_cairo_files/$filename.json" --cairo_path 'src'
		echo "Compiled $cairo_file using cairo-compile"
	fi
}

export -f process_cairo_file

# Determine directories to search based on mode
if [[ $1 == "tests" ]]; then
	directories="./tests/fustat_programs"
else
	directories="./garaga_zero_src ./tests/fustat_programs"
fi

# Find all .cairo files and process them in parallel
# Using --halt soon,fail=1 to stop at the first failure
find $directories -name "*.cairo" | parallel --halt soon,fail=1 process_cairo_file

# Capture the exit status of parallel
exit_status=$?

# Exit with the captured status
echo "Parallel execution exited with status: $exit_status"
exit $exit_status
