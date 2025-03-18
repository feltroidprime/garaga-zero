# 🚀 Garaga Zero Rust VM Example

This repository demonstrates how to use the Garaga Zero Rust VM implementation. It provides a simple example to help you get started with the VM.

## 📋 Prerequisites

- Rust toolchain
- Cairo compiler
- Python environment

## 🔧 Setup & Installation

First, set up the environment from the root directory:

```bash
make setup && source venv/bin/activate
```

## 🏃‍♂️ Running the Example

### 1. Navigate to the example directory

```bash
cd hints/rust-vm/example
```

### 2. Build the Cairo program

```bash
cairo-compile cairo/main.cairo --cairo_path ../../../src --output cairo/compiled_cairo.json
```

### 3. Run using the Rust VM

```bash
cargo run
```

### 4. Alternative: Run using the Python VM

If you prefer to use the Python implementation:

```bash
cairo-run --program=cairo/compiled_cairo.json --layout=all_cairo
```
