use std::{collections::HashMap, str::FromStr};

use ark_bls12_381::{Fq as Bls12_381Fq, Fq2 as Bls12_381Fq2};
use ark_ff::Field;
use cairo_vm::{
    hint_processor::builtin_hint_processor::{
        builtin_hint_processor_definition::HintProcessorData, hint_utils::get_relocatable_from_var_name,
    },
    types::exec_scope::ExecutionScopes,
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
    Felt252,
};
use num_bigint::BigUint;

use super::types::{CairoType, UInt384};
use crate::error::GaragaZeroError;

pub const HINT_MAP_TO_CURVE_G2: &str = r#"from garaga.hints.io import bigint_pack
from garaga.algebra import Fp2
from garaga.definitions import CURVES, PyFelt

g1x = bigint_pack(ids.g1xx, 4, 2**96)
g1y = bigint_pack(ids.g1xy, 4, 2**96)

if Fp2(PyFelt(g1x, CURVES[ids.curve_id].p), PyFelt(g1y, CURVES[ids.curve_id].p)).is_quad_residue():
    ids.is_quad_res = 1
else:
    ids.is_quad_res = 0"#;

pub fn hint_map_to_curve_g2(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    // Get the pointers to the values we need from the VM
    let g1xx_ptr = get_relocatable_from_var_name("g1xx", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let g1xy_ptr = get_relocatable_from_var_name("g1xy", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let curve_id_ptr = get_relocatable_from_var_name("curve_id", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    // Read the values from memory
    let g1xx = UInt384::from_memory(vm, g1xx_ptr)?;
    let g1xy = UInt384::from_memory(vm, g1xy_ptr)?;

    // Get the curve_id
    let curve_id = vm.get_integer(curve_id_ptr)?;

    // Check if it's a quadratic residue based on the curve_id
    let is_quad_res = match curve_id.to_string().as_str() {
        "1" => {
            // BLS12-381 curve
            is_quadratic_residue_bls12_381(&g1xx.0, &g1xy.0)?
        }
        // Add other curves as needed
        _ => return Err(GaragaZeroError::Custom(format!("Unknown curve_id: {}", curve_id).into()).into()),
    };

    // Set the result in the VM
    let is_quad_res_ptr = get_relocatable_from_var_name("is_quad_res", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    vm.insert_value(is_quad_res_ptr, Felt252::from(if is_quad_res { 1 } else { 0 }))?;

    Ok(())
}

// Check if an element is a quadratic residue in the Fq2 field of BLS12-381
fn is_quadratic_residue_bls12_381(real: &BigUint, imaginary: &BigUint) -> Result<bool, GaragaZeroError> {
    // Convert BigUint to field elements in Fq
    let real_str = real.to_str_radix(10);
    let imag_str = imaginary.to_str_radix(10);

    let real_fq = Bls12_381Fq::from_str(&real_str)
        .map_err(|_| GaragaZeroError::Custom(format!("Failed to convert real part to Fq: {}", real_str).into()))?;

    let imag_fq = Bls12_381Fq::from_str(&imag_str)
        .map_err(|_| GaragaZeroError::Custom(format!("Failed to convert imaginary part to Fq: {}", imag_str).into()))?;

    // Create an Fq2 element
    let element = Bls12_381Fq2::new(real_fq, imag_fq);

    // Check if it's a quadratic residue
    // In a finite field, an element is a quadratic residue if it has a square root
    Ok(element.legendre().is_qr())
}
