use cairo_vm::{
    types::relocatable::{MaybeRelocatable, Relocatable},
    vm::{errors::hint_errors::HintError, vm_core::VirtualMachine},
    Felt252,
};
use num_bigint::BigUint;
use num_traits::{One, Zero};
use pyo3::{types::PyList, PyAny};

use crate::error::GaragaZeroError;

#[derive(Debug, Clone)]
pub struct UInt384(pub BigUint);

impl UInt384 {
    pub fn from_python_list(py_list: &PyAny) -> Result<Self, HintError> {
        // Convert PyAny to PyList
        let py_list = py_list.downcast::<PyList>().unwrap();

        // Check if we have exactly 4 limbs
        assert_eq!(py_list.len(), 4, "Expected exactly 4 limbs");

        // Extract the limbs as u128 values
        let d0_val: u128 = py_list
            .get_item(0)
            .map_err(GaragaZeroError::Python)?
            .extract()
            .map_err(GaragaZeroError::Python)?;
        let d1_val: u128 = py_list
            .get_item(1)
            .map_err(GaragaZeroError::Python)?
            .extract()
            .map_err(GaragaZeroError::Python)?;
        let d2_val: u128 = py_list
            .get_item(2)
            .map_err(GaragaZeroError::Python)?
            .extract()
            .map_err(GaragaZeroError::Python)?;
        let d3_val: u128 = py_list
            .get_item(3)
            .map_err(GaragaZeroError::Python)?
            .extract()
            .map_err(GaragaZeroError::Python)?;

        // Create the BigUint from the limbs
        let mut value = BigUint::zero();
        value += BigUint::from(d3_val) << 288;
        value += BigUint::from(d2_val) << 192;
        value += BigUint::from(d1_val) << 96;
        value += BigUint::from(d0_val);

        Ok(Self(value))
    }

    pub fn to_bytes(&self) -> Vec<u8> {
        self.0.to_bytes_be()
    }

    pub fn to_limbs(&self) -> [Vec<u8>; 4] {
        let mask = BigUint::from(2u128).pow(96) - BigUint::one();

        let d0: BigUint = &self.0 & &mask;
        let d1: BigUint = (&self.0 >> 96) & &mask;
        let d2: BigUint = (&self.0 >> 192) & &mask;
        let d3: BigUint = (&self.0 >> 288) & &mask;

        [d0.to_bytes_be(), d1.to_bytes_be(), d2.to_bytes_be(), d3.to_bytes_be()]
    }
}

impl CairoType for UInt384 {
    fn from_memory(vm: &VirtualMachine, address: Relocatable) -> Result<Self, HintError> {
        let d0 = BigUint::from_bytes_be(&vm.get_integer((address + 0)?)?.to_bytes_be());
        let d1 = BigUint::from_bytes_be(&vm.get_integer((address + 1)?)?.to_bytes_be());
        let d2 = BigUint::from_bytes_be(&vm.get_integer((address + 2)?)?.to_bytes_be());
        let d3 = BigUint::from_bytes_be(&vm.get_integer((address + 3)?)?.to_bytes_be());
        let bigint = d3 << 288 | d2 << 192 | d1 << 96 | d0;
        Ok(Self(bigint))
    }

    fn to_memory(&self, vm: &mut VirtualMachine, address: Relocatable) -> Result<Relocatable, HintError> {
        let limbs = self.to_limbs();

        vm.insert_value((address + 0)?, Felt252::from_bytes_be_slice(&limbs[0]))?;
        vm.insert_value((address + 1)?, Felt252::from_bytes_be_slice(&limbs[1]))?;
        vm.insert_value((address + 2)?, Felt252::from_bytes_be_slice(&limbs[2]))?;
        vm.insert_value((address + 3)?, Felt252::from_bytes_be_slice(&limbs[3]))?;

        Ok((address + 4)?)
    }

    fn n_fields() -> usize {
        4
    }
}

#[derive(Debug, Clone)]
pub struct ModuloCircuit {
    pub constants_ptr: Relocatable,
    pub add_offsets_ptr: Relocatable,
    pub mul_offsets_ptr: Relocatable,
    pub output_offsets_ptr: Relocatable,
    pub constants_ptr_len: Felt252,
    pub input_len: Felt252,
    pub witnesses_len: Felt252,
    pub output_len: Felt252,
    pub continuous_output: Felt252,
    pub add_mod_n: Felt252,
    pub mul_mod_n: Felt252,
    pub n_assert_eq: Felt252,
    pub name: Felt252,
    pub curve_id: Felt252,
}

impl CairoType for ModuloCircuit {
    fn from_memory(vm: &VirtualMachine, address: Relocatable) -> Result<Self, HintError> {
        Ok(Self {
            constants_ptr: vm.get_relocatable((address + 0)?)?,
            add_offsets_ptr: vm.get_relocatable((address + 1)?)?,
            mul_offsets_ptr: vm.get_relocatable((address + 2)?)?,
            output_offsets_ptr: vm.get_relocatable((address + 3)?)?,
            constants_ptr_len: *vm.get_integer((address + 4)?)?,
            input_len: *vm.get_integer((address + 5)?)?,
            witnesses_len: *vm.get_integer((address + 6)?)?,
            output_len: *vm.get_integer((address + 7)?)?,
            continuous_output: *vm.get_integer((address + 8)?)?,
            add_mod_n: *vm.get_integer((address + 9)?)?,
            mul_mod_n: *vm.get_integer((address + 10)?)?,
            n_assert_eq: *vm.get_integer((address + 11)?)?,
            name: *vm.get_integer((address + 12)?)?,
            curve_id: *vm.get_integer((address + 13)?)?,
        })
    }

    fn to_memory(&self, vm: &mut VirtualMachine, address: Relocatable) -> Result<Relocatable, HintError> {
        vm.insert_value((address + 0)?, MaybeRelocatable::from(self.constants_ptr))?;
        vm.insert_value((address + 1)?, MaybeRelocatable::from(self.add_offsets_ptr))?;
        vm.insert_value((address + 2)?, MaybeRelocatable::from(self.mul_offsets_ptr))?;
        vm.insert_value((address + 3)?, MaybeRelocatable::from(self.output_offsets_ptr))?;
        vm.insert_value((address + 4)?, self.constants_ptr_len)?;
        vm.insert_value((address + 5)?, self.input_len)?;
        vm.insert_value((address + 6)?, self.witnesses_len)?;
        vm.insert_value((address + 7)?, self.output_len)?;
        vm.insert_value((address + 8)?, MaybeRelocatable::from(self.continuous_output))?;
        vm.insert_value((address + 9)?, self.add_mod_n)?;
        vm.insert_value((address + 10)?, self.mul_mod_n)?;
        vm.insert_value((address + 11)?, self.n_assert_eq)?;
        vm.insert_value((address + 12)?, self.name)?;
        vm.insert_value((address + 13)?, self.curve_id)?;
        Ok((address + 14)?)
    }

    fn n_fields() -> usize {
        14
    }
}

#[derive(Debug, Clone)]
pub struct ExtensionFieldModuloCircuit {
    pub constants_ptr: Relocatable,
    pub add_offsets_ptr: Relocatable,
    pub mul_offsets_ptr: Relocatable,
    pub output_offsets_ptr: Relocatable,
    pub constants_ptr_len: Felt252,
    pub input_len: Felt252,
    pub commitments_len: Felt252,
    pub big_q_len: Felt252,
    pub witnesses_len: Felt252,
    pub output_len: Felt252,
    pub continuous_output: Felt252,
    pub add_mod_n: Felt252,
    pub mul_mod_n: Felt252,
    pub n_assert_eq: Felt252,
    pub n_euclidean_equations: Felt252,
    pub name: Felt252,
    pub curve_id: Felt252,
}

impl CairoType for ExtensionFieldModuloCircuit {
    fn from_memory(vm: &VirtualMachine, address: Relocatable) -> Result<Self, HintError> {
        Ok(Self {
            constants_ptr: vm.get_relocatable((address + 0)?)?,
            add_offsets_ptr: vm.get_relocatable((address + 1)?)?,
            mul_offsets_ptr: vm.get_relocatable((address + 2)?)?,
            output_offsets_ptr: vm.get_relocatable((address + 3)?)?,
            constants_ptr_len: *vm.get_integer((address + 4)?)?,
            input_len: *vm.get_integer((address + 5)?)?,
            commitments_len: *vm.get_integer((address + 6)?)?,
            big_q_len: *vm.get_integer((address + 7)?)?,
            witnesses_len: *vm.get_integer((address + 8)?)?,
            output_len: *vm.get_integer((address + 9)?)?,
            continuous_output: *vm.get_integer((address + 10)?)?,
            add_mod_n: *vm.get_integer((address + 11)?)?,
            mul_mod_n: *vm.get_integer((address + 12)?)?,
            n_assert_eq: *vm.get_integer((address + 13)?)?,
            n_euclidean_equations: *vm.get_integer((address + 14)?)?,
            name: *vm.get_integer((address + 15)?)?,
            curve_id: *vm.get_integer((address + 16)?)?,
        })
    }

    fn to_memory(&self, vm: &mut VirtualMachine, address: Relocatable) -> Result<Relocatable, HintError> {
        vm.insert_value((address + 0)?, MaybeRelocatable::from(self.constants_ptr))?;
        vm.insert_value((address + 1)?, MaybeRelocatable::from(self.add_offsets_ptr))?;
        vm.insert_value((address + 2)?, MaybeRelocatable::from(self.mul_offsets_ptr))?;
        vm.insert_value((address + 3)?, MaybeRelocatable::from(self.output_offsets_ptr))?;
        vm.insert_value((address + 4)?, self.constants_ptr_len)?;
        vm.insert_value((address + 5)?, self.input_len)?;
        vm.insert_value((address + 6)?, self.commitments_len)?;
        vm.insert_value((address + 7)?, self.big_q_len)?;
        vm.insert_value((address + 8)?, self.witnesses_len)?;
        vm.insert_value((address + 9)?, self.output_len)?;
        vm.insert_value((address + 10)?, self.continuous_output)?;
        vm.insert_value((address + 11)?, self.add_mod_n)?;
        vm.insert_value((address + 12)?, self.mul_mod_n)?;
        vm.insert_value((address + 13)?, self.n_assert_eq)?;
        vm.insert_value((address + 14)?, self.n_euclidean_equations)?;
        vm.insert_value((address + 15)?, self.name)?;
        vm.insert_value((address + 16)?, self.curve_id)?;
        Ok((address + 17)?)
    }

    fn n_fields() -> usize {
        17
    }
}

pub trait CairoType: Sized {
    fn from_memory(vm: &VirtualMachine, address: Relocatable) -> Result<Self, HintError>;
    fn to_memory(&self, vm: &mut VirtualMachine, address: Relocatable) -> Result<Relocatable, HintError>;
    fn n_fields() -> usize;
}
