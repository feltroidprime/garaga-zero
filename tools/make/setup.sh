#!/bin/bash

# Function to install GNU parallel
install_parallel() {
    case "$OSTYPE" in
        linux-gnu*)
            # Linux
            if command -v apt-get >/dev/null; then
                # Debian/Ubuntu
                sudo apt-get update && sudo apt-get install -y parallel
            elif command -v dnf >/dev/null; then
                # Fedora
                sudo dnf install -y parallel
            else
                echo "Unsupported Linux distribution for automatic parallel installation."
                exit 1
            fi
            ;;
        darwin*)
            # macOS
            if command -v brew >/dev/null; then
                brew install parallel
            else
                echo "Homebrew is not installed. Please install Homebrew and try again."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system for automatic parallel installation."
            exit 1
            ;;
    esac
}

# Check if parallel is installed, if not, attempt to install it
if ! command -v parallel >/dev/null; then
    echo "GNU parallel not found. Attempting to install..."
    install_parallel
else
    echo "GNU parallel is already installed."
fi

# Check if python3.10 is installed
if ! command -v python3.10 >/dev/null; then
    echo "python3.10 is not installed. Please install Python 3.10 and try again."
    case "$OSTYPE" in
        linux-gnu*)
            echo "On Debian/Ubuntu, you can install it with: sudo apt-get install python3.10"
            echo "On Fedora, you can install it with: sudo dnf install python3.10"
            ;;
        darwin*)
            echo "On macOS, you can install it with Homebrew: brew install python@3.10"
            ;;
        *)
            echo "Please refer to your operating system's documentation for installing Python 3.10."
            ;;
    esac
    exit 1
fi

# Check if venv module is available
if ! python3.10 -m venv --help >/dev/null 2>&1; then
    echo "The venv module is not available in your Python 3.10 installation."
    case "$OSTYPE" in
        linux-gnu*)
            echo "On Debian/Ubuntu, you can install it with: sudo apt-get install python3.10-venv"
            echo "On Fedora, you can install it with: sudo dnf install python3.10-venv"
            ;;
        darwin*)
            echo "On macOS, ensure your Python 3.10 installation includes the venv module."
            ;;
        *)
            echo "Please refer to your operating system's documentation for installing the venv module."
            ;;
    esac
    exit 1
fi

# Create virtual environment
if ! python3.10 -m venv venv; then
    echo "Failed to create virtual environment with python3.10"
    exit 1
fi

echo 'export PYTHONPATH="$PWD:$PYTHONPATH"' >> venv/bin/activate
echo 'export PYTHONPYCACHEPREFIX="$PWD/venv/build/__pycache__"' >> venv/bin/activate
echo "PROJECT_ROOT=$PWD" > .env
source venv/bin/activate
pip install uv
uv pip compile pyproject.toml --output-file tools/make/requirements.txt -q
uv pip install -r tools/make/requirements.txt

# Install the commit hooks (black, isort)
pre-commit install

echo "Applying patch to instances.py..."
patch venv/lib/python3.10/site-packages/starkware/cairo/lang/instances.py < tools/make/instances.patch

echo "All done!"
