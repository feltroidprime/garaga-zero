pub fn run_modulo_circuit_hints(
    vm: &mut VirtualMachine,
    input_ptr: Felt252,
    n_limbs: Felt252,
    base: Felt252,
    circuit: &Relocatable,
) -> Result<Vec<Felt252>, HintError> {
    // Your existing code to compute witnesses

    // Get the destination address for writing witnesses
    let constants_ptr_len = vm.get_field_from_struct(circuit, "constants_ptr_len")?.to_usize()?;
    let input_len = vm.get_field_from_struct(circuit, "input_len")?.to_usize()?;
    let range_check96_ptr = vm.get_local_variable("range_check96_ptr")?.get_relocatable()?;

    // Calculate the destination address for writing witnesses
    let dest_addr = range_check96_ptr.add_usize(constants_ptr_len * n_limbs.to_usize()? + input_len)?;

    // Write each witness value to memory
    for (i, value) in witnesses.iter().enumerate() {
        let addr = dest_addr.add_usize(i)?;
        vm.insert_value(&addr, value)?;
    }

    Ok(witnesses)
}
