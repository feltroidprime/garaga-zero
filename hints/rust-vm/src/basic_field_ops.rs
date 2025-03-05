use std::collections::HashMap;

use cairo_vm::{
    Felt252,
    hint_processor::builtin_hint_processor::{
        builtin_hint_processor_definition::HintProcessorData,
        hint_utils::{get_ptr_from_var_name, get_relocatable_from_var_name, insert_value_into_ap},
    },
    types::exec_scope::ExecutionScopes,
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
};
use num_bigint::BigUint;

use super::types::{CairoType, UInt384};

pub const HINT_UINT384_IS_LE: &str = r#"from garaga.hints.io import bigint_pack
a = bigint_pack(ids.a, 4, 2**96)
b = bigint_pack(ids.b, 4, 2**96)
memory[ap] = int(a <= b)"#;

pub fn hint_uint384_is_le(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let a_ptr = get_relocatable_from_var_name("a", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();
    let b_ptr = get_relocatable_from_var_name("b", vm, &hint_data.ids_data, &hint_data.ap_tracking).unwrap();

    let a = UInt384::from_memory(vm, a_ptr).unwrap();
    let b = UInt384::from_memory(vm, b_ptr).unwrap();

    let flag = a.0 <= b.0;
    insert_value_into_ap(vm, Felt252::from(flag))
}

pub const HINT_ADD_MOD_CIRCUIT: &str = r#"from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner
assert builtin_runners["add_mod_builtin"].instance_def.batch_size == 1

ModBuiltinRunner.fill_memory(
    memory=memory,
    add_mod=(ids.add_mod_ptr.address_, builtin_runners["add_mod_builtin"], 1),
    mul_mod=None,
)"#;

pub fn hint_add_mod_circuit(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let add_mod_ptr = get_ptr_from_var_name("add_mod_ptr", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    vm.mod_builtin_fill_memory(Some((add_mod_ptr, 1)), None, Some(1))
        .map_err(HintError::Internal)
}

pub const HINT_NOT_ZERO_MOD_P: &str = r#"from garaga.hints.io import bigint_split, bigint_pack
p = bigint_pack(ids.p, 4, 2**96)
x = bigint_pack(ids.x, 4, 2**96)
x_inv = pow(x, -1, p)
limbs = bigint_split(x_inv)
ids.x_inv_d0 = limbs[0]
ids.x_inv_d1 = limbs[1]
ids.x_inv_d2 = limbs[2]
ids.x_inv_d3 = limbs[3]"#;

pub fn hint_not_zero_mod_p(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let x_ptr = get_relocatable_from_var_name("x", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let p_ptr = get_relocatable_from_var_name("p", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let x = UInt384::from_memory(vm, x_ptr).unwrap();
    let p = UInt384::from_memory(vm, p_ptr).unwrap();

    // Calculate modular inverse of x with respect to p
    let x_inv = UInt384(x.0.modinv(&p.0).unwrap());
    let x_inv_addr = get_relocatable_from_var_name("x_inv_d0", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let _ = x_inv.to_memory(vm, x_inv_addr);

    Ok(())
}

pub const HINT_IS_ZERO_MOD_P: &str = r#"from garaga.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
memory[ap] = int(x % p == 0)"#;

pub fn hint_is_zero_mod_p(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let x_ptr = get_relocatable_from_var_name("x", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let p_ptr = get_relocatable_from_var_name("p", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let x = UInt384::from_memory(vm, x_ptr).unwrap();
    let p = UInt384::from_memory(vm, p_ptr).unwrap();

    let is_zero = x.0 % p.0 == BigUint::ZERO;
    insert_value_into_ap(vm, Felt252::from(is_zero))
}

pub const HINT_ASSERT_NEQ_MOD_P: &str = r#"from garaga.hints.io import bigint_split, bigint_pack
p = bigint_pack(ids.p, 4, 2**96)
x = bigint_pack(ids.x, 4, 2**96)
y = bigint_pack(ids.y, 4, 2**96)
diff = (x - y) % p
diff_inv = pow(diff, -1, p)
limbs = bigint_split(diff_inv)
ids.diff_inv_d0 = limbs[0]
ids.diff_inv_d1 = limbs[1]
ids.diff_inv_d2 = limbs[2]
ids.diff_inv_d3 = limbs[3]"#;

pub fn hint_assert_neq_mod_p(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let x_ptr = get_relocatable_from_var_name("x", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let y_ptr = get_relocatable_from_var_name("y", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let p_ptr = get_relocatable_from_var_name("p", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let x = UInt384::from_memory(vm, x_ptr).unwrap();
    let y = UInt384::from_memory(vm, y_ptr).unwrap();
    let p = UInt384::from_memory(vm, p_ptr).unwrap();

    let diff = (x.0 - y.0) % &p.0;
    let diff_inv = UInt384(diff.modinv(&p.0).unwrap());

    let diff_inv_addr = get_relocatable_from_var_name("diff_inv_d0", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let _ = diff_inv.to_memory(vm, diff_inv_addr);

    Ok(())
}

pub const HINT_IS_OPPOSITE_MOD_P: &str = r#"from garaga.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
y = bigint_pack(ids.y, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
memory[ap] = int(x % p == -y % p)"#;

pub fn hint_is_opposite_mod_p(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let x_ptr = get_relocatable_from_var_name("x", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let y_ptr = get_relocatable_from_var_name("y", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let p_ptr = get_relocatable_from_var_name("p", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let x = UInt384::from_memory(vm, x_ptr).unwrap();
    let y = UInt384::from_memory(vm, y_ptr).unwrap();
    let p = UInt384::from_memory(vm, p_ptr).unwrap();

    let is_opposite = x.0 % p.0.clone() == (BigUint::ZERO - y.0) % p.0;
    insert_value_into_ap(vm, Felt252::from(is_opposite))
}

pub const HINT_IS_EQ_MOD_P: &str = r#"from garaga.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
y = bigint_pack(ids.y, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
memory[ap] = int(x % p == y % p)"#;

pub fn hint_is_eq_mod_p(
    vm: &mut VirtualMachine,
    _exec_scopes: &mut ExecutionScopes,
    hint_data: &HintProcessorData,
    _constants: &HashMap<String, Felt252>,
) -> Result<(), HintError> {
    let x_ptr = get_relocatable_from_var_name("x", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let y_ptr = get_relocatable_from_var_name("y", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;
    let p_ptr = get_relocatable_from_var_name("p", vm, &hint_data.ids_data, &hint_data.ap_tracking)?;

    let x = UInt384::from_memory(vm, x_ptr).unwrap();
    let y = UInt384::from_memory(vm, y_ptr).unwrap();
    let p = UInt384::from_memory(vm, p_ptr).unwrap();

    let is_eq = x.0 % p.0.clone() == y.0 % p.0;
    insert_value_into_ap(vm, Felt252::from(is_eq))
}
