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

# Create virtual environment
if ! uv sync; then
	echo "Failed to create virtual environment with uv"
	exit 1
fi

# Install the commit hooks (black, isort)
pre-commit install

echo "Applying patch to instances.py..."
patch .venv/lib/python3.10/site-packages/starkware/cairo/lang/instances.py <tools/make/instances.patch

echo "WARNING: You need to apply the patch anytime you run uv sync again after this script"
echo "All done!"
