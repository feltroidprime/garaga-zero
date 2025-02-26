use std::{cmp::Ordering, collections::HashMap};

use cairo_vm::{
    Felt252,
    hint_processor::builtin_hint_processor::{
        builtin_hint_processor_definition::HintProcessorData,
        hint_utils::{get_integer_from_var_name, insert_value_into_ap},
    },
    types::{exec_scope::ExecutionScopes, relocatable::Relocatable},
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
};

pub fn print_address_range(
    vm: &VirtualMachine,
    address: Relocatable,
    depth: usize,
    padding: Option<usize>,
) {
    let padding = padding.unwrap_or(0); // Default to 20 if not specified
    let start_offset = if address.offset >= padding {
        address.offset - padding
    } else {
        0
    };
    let end_offset = address.offset + depth + padding;

    println!(
        "\nFull memory segment range for segment {}:",
        address.segment_index
    );
    println!("----------------------------------------");
    for i in start_offset..end_offset {
        let addr = Relocatable {
            segment_index: address.segment_index,
            offset: i,
        };
        match vm.get_maybe(&addr) {
            Some(value) => println!("Offset {}: {:?}", i, value),
            None => println!("Offset {}: <empty>", i),
        }
    }
    println!("----------------------------------------\n");
}

pub const HINT_RETRIEVE_OUTPUT: &str = r#"index = memory[ids.output_offsets_ptr+ids.i]
# print(f"Output {ids.i}/{ids.n} Index : {index}")
memory[ap] = 1 if ids.i == ids.n else 0"#;

pub fn hint_retrieve_output(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let i = get_integer_from_var_name("i", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let n = get_integer_from_var_name("n", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let insert = match (i - n).cmp(&Felt252::ZERO) {
        Ordering::Equal => Felt252::ONE,
        _ => Felt252::ZERO,
    };

    insert_value_into_ap(vm, insert)
}
