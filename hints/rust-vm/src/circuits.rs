use std::collections::HashMap;

use cairo_vm::{
    Felt252,
    hint_processor::builtin_hint_processor::{builtin_hint_processor_definition::HintProcessorData, hint_utils::get_ptr_from_var_name},
    types::{exec_scope::ExecutionScopes, relocatable::Relocatable},
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
};
use pyo3::prelude::*;

use crate::types::ExtensionFieldModuloCircuit;

use super::types::{CairoType, ModuloCircuit, UInt384};

pub const HINT_RUN_MODULO_CIRCUIT: &str = r#"from garaga.hints.io import pack_bigint_ptr, fill_felt_ptr
from hints.python_wrapper.circuits import run_modulo_circuit_hints
inputs = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)

witnesses = run_modulo_circuit_hints(inputs, ids.N_LIMBS, ids.BASE, ids.circuit.name, ids.circuit.curve_id)
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)"#;

pub fn run_modulo_circuit(
    vm: &mut VirtualMachine,
    exec_scopes: &mut ExecutionScopes,
    _hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {

    compute_mod_circuit(vm, exec_scopes, _hint_data, _constants).unwrap();

    Ok(())
}

pub const HINT_RUN_EXTENSION_FIELD_MODULO_CIRCUIT: &str = r#"from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
from hints.python_wrapper.circuits import run_extension_field_modulo_circuit_hints
inputs = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)

witnesses, commitments = run_extension_field_modulo_circuit_hints(inputs, ids.N_LIMBS, ids.BASE, ids.circuit.name, ids.circuit.curve_id)
fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")

#EXTF_MOD_CIRCUIT.print_value_segment()"#;

pub fn run_extension_field_modulo_circuit(
    vm: &mut VirtualMachine,
    exec_scopes: &mut ExecutionScopes,
    _hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    compute_extension_field_mod_circuit(vm, exec_scopes, _hint_data, _constants).unwrap();

    Ok(())
}


/// Packs multiple limbs into a single value using the formula: sum(limb[i] * base^i)
fn bigint_pack_ptr(vm: &VirtualMachine, ptr: Relocatable) -> Result<UInt384, HintError> {
    Ok(UInt384::from_memory(vm, ptr)?)
}

/// Packs multiple groups of limbs into a vector of values
/// Each group consists of n_limbs consecutive values that are packed using bigint_pack_ptr
fn pack_bigint_ptr_vec(vm: &VirtualMachine, ptr: Relocatable, n_limbs: u32, n_elements: usize) -> Result<Vec<UInt384>, HintError> {
    let mut values = Vec::with_capacity(n_elements);

    for i in 0..n_elements {
        let offset = (i * n_limbs as usize) as u32;
        let element_ptr = (ptr + offset).unwrap();
        values.push(bigint_pack_ptr(vm, element_ptr)?);
    }

    Ok(values)
}


/// Adds potential module paths to Python's sys.path to ensure imports work
fn add_module_paths_to_python(py: Python) -> PyResult<()> {
    py.run(
        r#"
import sys, os
import site

# Try to find the module in various locations
paths_to_check = [
    # Current working directory
    os.getcwd(),
    # Up three directories (for direct development)
    os.path.abspath(os.path.join(os.getcwd(), '../../..')),
    # Site packages (for installed packages)
    *site.getsitepackages()
]

# Add all potential paths to sys.path
for path in paths_to_check:
    if path not in sys.path and os.path.exists(path):
        sys.path.insert(0, path)
"#,
        None,
        None,
    )
}

pub fn compute_mod_circuit(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> Result<(), PyErr> {
    let (circuit_input, circuit_id, curve_id, n_limbs, base) = perpare_mod_circuits_python_inputs(vm, _exec_scopes, hint_data, constants);
    let circuit_address = get_ptr_from_var_name("circuit", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let circuit = ModuloCircuit::from_memory(vm, circuit_address).unwrap();
    let range_check_ptr = get_ptr_from_var_name("range_check96_ptr", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();

    let move_amt: usize = (circuit.constants_ptr_len * Felt252::from(n_limbs) + circuit.input_len)
        .try_into()
        .unwrap();
    let witness_target_ptr = (range_check_ptr + move_amt).unwrap();

    Python::with_gil(|py| {
        // Try to import the module directly first
        let import_result = py.import("hints.python_wrapper.circuits");

        if import_result.is_err() {
            add_module_paths_to_python(py)?;
        }

        // Now try the import again
        let all_circuits = py.import("hints.python_wrapper.circuits")?;
        let run_modulo_circuit_hints = all_circuits.getattr("run_modulo_circuit_hints")?;

        let py_input = circuit_input
            .iter()
            .map(|uint384| -> PyResult<PyObject> {
                let bytes = uint384.to_bytes();
                let py_int = py.eval(&format!("int.from_bytes({:?}, 'big')", bytes), None, None)?;

                Ok(py_int.into())
            })
            .collect::<PyResult<Vec<_>>>()?;

        let py_circuit_id = py.eval(&format!("int.from_bytes({:?}, 'big')", circuit_id), None, None)?;
        let witnesses = run_modulo_circuit_hints.call1((py_input, n_limbs, base, py_circuit_id, curve_id))?;

        for (i, witness) in witnesses.iter()?.enumerate() {
            let addr = (witness_target_ptr + i).unwrap();
            let val: u128 = witness.unwrap().extract()?;
            vm.insert_value(addr, Felt252::from(val)).unwrap();
        }

        Ok(())
    })
}

pub fn compute_extension_field_mod_circuit(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> Result<(), PyErr> {
    let (circuit_input, circuit_id, curve_id, n_limbs, base) = perpare_extension_field_mod_circuits_python_inputs(vm, _exec_scopes, hint_data, constants);
    let circuit_address = get_ptr_from_var_name("circuit", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let circuit = ExtensionFieldModuloCircuit::from_memory(vm, circuit_address).unwrap();
    let range_check_ptr = get_ptr_from_var_name("range_check96_ptr", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let move_amt: usize = (circuit.constants_ptr_len * Felt252::from(n_limbs) + circuit.input_len)
        .try_into()
        .unwrap();
    let commitments_target_ptr = (range_check_ptr + move_amt).unwrap();

    let commitments_len: usize = circuit.commitments_len.try_into().unwrap();
    let witnesses_target_ptr = (commitments_target_ptr + commitments_len).unwrap();

    Python::with_gil(|py| {
        // Try to import the module directly first
        let import_result = py.import("hints.python_wrapper.circuits");

        if import_result.is_err() {
            add_module_paths_to_python(py)?;
        }

        // Now try the import again
        let all_circuits = py.import("hints.python_wrapper.circuits")?;
        let run_circuit_hints = all_circuits.getattr("run_extension_field_modulo_circuit_hints")?;

        let py_input = circuit_input
            .iter()
            .map(|uint384| -> PyResult<PyObject> {
                let bytes = uint384.to_bytes();
                let py_int = py.eval(&format!("int.from_bytes({:?}, 'big')", bytes), None, None)?;

                Ok(py_int.into())
            })
            .collect::<PyResult<Vec<_>>>()?;

        let py_circuit_id = py.eval(&format!("int.from_bytes({:?}, 'big')", circuit_id), None, None)?;
        let result = run_circuit_hints.call1((py_input, n_limbs, base, py_circuit_id, curve_id))?;
        // Unpack the tuple returned by the Python function (witnesses, commitments)
        let witnesses = result.get_item(0)?;
        let commitments = result.get_item(1)?;
        // Process commitments
        for (i, commitment) in commitments.iter()?.enumerate() {
            let addr = (commitments_target_ptr + i).unwrap();
            let val: u128 = commitment.unwrap().extract()?;
            vm.insert_value(addr, Felt252::from(val)).unwrap();
        }

        // Process witnesses
        for (i, witness) in witnesses.iter()?.enumerate() {
            let addr = (witnesses_target_ptr + i).unwrap();
            let val: u128 = witness.unwrap().extract()?;
            vm.insert_value(addr, Felt252::from(val)).unwrap();
        }
        Ok(())
    })

}


fn perpare_mod_circuits_python_inputs(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> (Vec<UInt384>, Vec<u8>, u64, u32, u128) {
    let input_ptr = get_ptr_from_var_name("input", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let n_limbs: u32 = constants["definitions.N_LIMBS"].try_into().unwrap();
    let circuit_address = get_ptr_from_var_name("circuit", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let circuit = ModuloCircuit::from_memory(vm, circuit_address).unwrap();
    let input_len: u32 = circuit.input_len.try_into().unwrap();
    let base: u128 = constants["definitions.BASE"].try_into().unwrap();

    let circuit_input = pack_bigint_ptr_vec(vm, input_ptr, n_limbs, input_len as usize / n_limbs as usize).unwrap();
    let circuit_id = circuit.name.to_bytes_be().to_vec();
    let curve_id: u64 = circuit.curve_id.try_into().unwrap();

    (circuit_input, circuit_id, curve_id, n_limbs, base)
}

fn perpare_extension_field_mod_circuits_python_inputs(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    constants: &HashMap<String, Felt252>,
) -> (Vec<UInt384>, Vec<u8>, u64, u32, u128) {
    let input_ptr = get_ptr_from_var_name("input", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let n_limbs: u32 = constants["definitions.N_LIMBS"].try_into().unwrap();
    let circuit_address = get_ptr_from_var_name("circuit", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let circuit = ExtensionFieldModuloCircuit::from_memory(vm, circuit_address).unwrap();
    let input_len: u32 = circuit.input_len.try_into().unwrap();
    let base: u128 = constants["definitions.BASE"].try_into().unwrap();

    let circuit_input = pack_bigint_ptr_vec(vm, input_ptr, n_limbs, input_len as usize / n_limbs as usize).unwrap();
    let circuit_id = circuit.name.to_bytes_be().to_vec();
    let curve_id: u64 = circuit.curve_id.try_into().unwrap();

    (circuit_input, circuit_id, curve_id, n_limbs, base)
}
