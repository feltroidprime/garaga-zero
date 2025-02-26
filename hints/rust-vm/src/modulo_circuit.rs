use std::collections::HashMap;

use super::types::{CairoType, ModuloCircuit, UInt384};
use cairo_vm::{
    Felt252,
    hint_processor::builtin_hint_processor::{
        builtin_hint_processor_definition::HintProcessorData,
        hint_utils::get_ptr_from_var_name,
    },
    types::{exec_scope::ExecutionScopes, relocatable::Relocatable},
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
};
use pyo3::prelude::*;

pub const RUN_MODULO_CIRCUIT: &str = r#"from hints.modulo_circuit import run_modulo_circuit_hints
witnesses = run_modulo_circuit_hints(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit)
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)"#;

/// Packs multiple limbs into a single value using the formula: sum(limb[i] * base^i)
fn bigint_pack_ptr(vm: &VirtualMachine, ptr: Relocatable) -> Result<UInt384, HintError> {
    Ok(UInt384::from_memory(vm, ptr)?)
}

/// Packs multiple groups of limbs into a vector of values
/// Each group consists of n_limbs consecutive values that are packed using bigint_pack_ptr
fn pack_bigint_ptr_vec(
    vm: &VirtualMachine,
    ptr: Relocatable,
    n_limbs: u32,
    n_elements: usize,
) -> Result<Vec<UInt384>, HintError> {
    let mut values = Vec::with_capacity(n_elements);

    for i in 0..n_elements {
        let offset = (i * n_limbs as usize) as u32;
        let element_ptr = (ptr + offset).unwrap();
        values.push(bigint_pack_ptr(vm, element_ptr)?);
    }

    Ok(values)
}

pub fn run_modulo_circuit(
    vm: &mut VirtualMachine,
    exec_scopes: &mut ExecutionScopes,
    _hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    println!("Running modulo circuit");

    compute_mod_circuit(vm, exec_scopes, _hint_data, _constants).unwrap();

    Ok(())
}

pub fn compute_mod_circuit(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> Result<(), PyErr> {
    let (circuit_input, circuit_id, curve_id, n_limbs, base) =
        perpare_python_inputs(vm, _exec_scopes, hint_data, constants);
    let circuit_address =
        get_ptr_from_var_name("circuit", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let circuit = ModuloCircuit::from_memory(vm, circuit_address).unwrap();
    let range_check_ptr = get_ptr_from_var_name(
        "range_check96_ptr",
        vm,
        &hint_data.ids_data,
        &hint_data.ap_tracking,
    )
    .unwrap();

    let move_amt: usize = (circuit.constants_ptr_len * Felt252::from(n_limbs) + circuit.input_len)
        .try_into()
        .unwrap();
    let witness_target_ptr = (range_check_ptr + move_amt).unwrap();

    Python::with_gil(|py| {
        let py_input = circuit_input
            .iter()
            .map(|uint384| -> PyResult<PyObject> {
                let bytes = uint384.to_bytes();
                let py_int = py.eval(&format!("int.from_bytes({:?}, 'big')", bytes), None, None)?;

                Ok(py_int.into())
            })
            .collect::<PyResult<Vec<_>>>()?;

        let py_circuit_id = py.eval(
            &format!("int.from_bytes({:?}, 'big')", circuit_id),
            None,
            None,
        )?;
        let all_circuits = py.import("hints.modulo_circuit")?;
        let run_modulo_circuit_hints = all_circuits.getattr("run_modulo_circuit_hints")?;
        let witnesses =
            run_modulo_circuit_hints.call1((py_input, n_limbs, base, py_circuit_id, curve_id))?;
        println!("got witnesses: {:?}", witnesses);

        for (i, witness) in witnesses.iter()?.enumerate() {
            let addr = (witness_target_ptr + i).unwrap();
            let val: u128 = witness.unwrap().extract()?;
            vm.insert_value(addr, Felt252::from(val)).unwrap();
        }

        Ok(())
    })
}

fn perpare_python_inputs(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> (Vec<UInt384>, Vec<u8>, u64, u32, u128) {
    let input_ptr =
        get_ptr_from_var_name("input", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let n_limbs: u32 = constants["definitions.N_LIMBS"].try_into().unwrap();
    let circuit_address =
        get_ptr_from_var_name("circuit", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let circuit = ModuloCircuit::from_memory(vm, circuit_address).unwrap();
    let input_len: u32 = circuit.input_len.try_into().unwrap();
    let base: u128 = constants["definitions.BASE"].try_into().unwrap();

    let circuit_input = pack_bigint_ptr_vec(
        vm,
        input_ptr,
        n_limbs,
        input_len as usize / n_limbs as usize,
    )
    .unwrap();
    let circuit_id = circuit.name.to_bytes_be().to_vec();
    let curve_id: u64 = circuit.curve_id.try_into().unwrap();

    (circuit_input, circuit_id, curve_id, n_limbs, base)
}
