use cairo_vm::vm::errors::hint_errors::HintError;
use pyo3::{PyDowncastError, PyErr};

#[derive(thiserror::Error, Debug)]
pub enum GaragaZeroError {
    #[error("Unknown curve_id: {0}")]
    UnknownCurveId(Box<str>),
    #[error("Python error: {0}")]
    Python(#[from] PyErr),
    #[error("Python downcast error: {0}")]
    PythonDowncast(#[from] PyDowncastError<'static>),
    #[error("Custom error: {0}")]
    Custom(Box<str>),
}

// Then implement the conversion
impl From<GaragaZeroError> for HintError {
    fn from(error: GaragaZeroError) -> Self {
        HintError::CustomHint(error.to_string().into_boxed_str())
    }
}
