pub mod error;
pub mod hint_processor;

use cairo_vm::{
    cairo_run::{self, cairo_run_program},
    types::{layout_name::LayoutName, program::Program},
};
use error::Error;
use hint_processor::CustomHintProcessor;

fn main() -> Result<(), Error> {
    // Init CairoRunConfig
    let cairo_run_config = cairo_run::CairoRunConfig {
        allow_missing_builtins: Some(true),
        layout: LayoutName::all_cairo,
        ..Default::default()
    };

    let program_file = std::fs::read("cairo/compiled_cairo.json").map_err(Error::IO)?;

    // Load the Program
    let program = Program::from_bytes(&program_file, Some(cairo_run_config.entrypoint))?;

    let mut hint_processor = CustomHintProcessor::default();
    let cairo_runner = cairo_run_program(&program, &cairo_run_config, &mut hint_processor).unwrap();

    println!("{:?}", cairo_runner.get_execution_resources());

    Ok(())
}
