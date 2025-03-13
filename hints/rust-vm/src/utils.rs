use std::{cmp::Ordering, collections::HashMap};

use cairo_vm::{
    Felt252,
    hint_processor::builtin_hint_processor::{
        builtin_hint_processor_definition::HintProcessorData,
        hint_utils::{
            get_integer_from_var_name, get_ptr_from_var_name,
            insert_value_into_ap,
        },
    },
    types::{exec_scope::ExecutionScopes, relocatable::Relocatable},
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
};
use num_bigint::BigUint;

use crate::types::UInt384;

pub fn print_address_range(vm: &VirtualMachine, address: Relocatable, depth: usize, padding: Option<usize>) {
    let padding = padding.unwrap_or(0); // Default to 20 if not specified
    let start_offset = if address.offset >= padding { address.offset - padding } else { 0 };
    let end_offset = address.offset + depth + padding;

    println!("\nFull memory segment range for segment {}:", address.segment_index);
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

pub const HINT_HASH_FULL_TRANSCRIPT_AND_GET_Z_4_LIMBS_1: &str =
    "memory[ap] = to_felt_or_relocatable(ids.elements_end - ids.elements >= 6*ids.N_LIMBS)";
pub fn hint_hash_full_transcript_and_get_z_4_limbs_1(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let elements_end = get_ptr_from_var_name("elements_end", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let elements = get_ptr_from_var_name("elements", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let n_limbs = constants.get("definitions.N_LIMBS").unwrap();

    let result = Felt252::from((elements_end - elements)?) >= Felt252::from(6) * n_limbs;

    insert_value_into_ap(vm, Felt252::from(result))
}

pub const HINT_HASH_FULL_TRANSCRIPT_AND_GET_Z_4_LIMBS_2: &str =
    "memory[ap] = to_felt_or_relocatable(ids.elements_end - ids.elements >= ids.N_LIMBS)";
pub fn hint_hash_full_transcript_and_get_z_4_limbs_2(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let elements_end = get_ptr_from_var_name("elements_end", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let elements = get_ptr_from_var_name("elements", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let n_limbs = constants.get("definitions.N_LIMBS").unwrap();

    let result = Felt252::from((elements_end - elements)?) >= *n_limbs;
    insert_value_into_ap(vm, Felt252::from(result))
}

pub const HINT_WRITE_FELTS_TO_VALUE_SEGMENT_1: &str = "i=0";
pub fn hint_write_felts_to_value_segment_1(
    _vm: &mut VirtualMachine,
    exec_scopes: &mut ExecutionScopes,
    _hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    exec_scopes.insert_value("i", 0_usize);
    Ok(())
}

pub const HINT_WRITE_FELTS_TO_VALUE_SEGMENT_2: &str = "memory[ap] = 1 if i == ids.n else 0\ni+=1";
pub fn hint_write_felts_to_value_segment_2(
    vm: &mut VirtualMachine,
    exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let i = exec_scopes.get_ref::<usize>("i")?;
    let n = get_integer_from_var_name("n", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let result = if Felt252::from(*i) == n { Felt252::ONE } else { Felt252::ZERO };

    // Increment i for next iteration - use the same type as initialization (usize)
    *exec_scopes.get_mut_ref::<usize>("i")? += 1;

    insert_value_into_ap(vm, result)
}

pub const HINT_WRITE_FELTS_TO_VALUE_SEGMENT_3: &str = r#"from garaga.hints.io import bigint_split
felt_val = memory[ids.values_start+i-1]
limbs = bigint_split(felt_val, ids.N_LIMBS, ids.BASE)
assert limbs[3] == 0
ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]"#;
pub fn hint_write_felts_to_value_segment_3(
    vm: &mut VirtualMachine,
    exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let i = *exec_scopes.get_ref::<usize>("i")?;
    let values_start = get_ptr_from_var_name("values_start", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let value = vm.get_integer((values_start + (i - 1))?)?;

    let limbs = UInt384(BigUint::from_bytes_be(&value.to_bytes_be()))
        .to_limbs()
        .map(|limb| Felt252::from_bytes_be_slice(&limb));

    assert_eq!(limbs[3], Felt252::ZERO);
    let rc_96_ptr = get_ptr_from_var_name("rc_96_ptr", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    // So we need to update the values at these memory locations
    vm.insert_value(rc_96_ptr, limbs[0])?;
    vm.insert_value((rc_96_ptr + 1)?, limbs[1])?;
    vm.insert_value((rc_96_ptr + 2)?, limbs[2])?;
    Ok(())
}
