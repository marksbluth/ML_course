#!/bin/bash

# Script to create a Python virtual environment and install requirements

# --- Configuration ---
VENV_NAME="venv_day1"        # Name of the virtual environment directory
REQUIREMENTS_FILE="requirements.txt" # Path to the requirements file
PYTHON_VERSION="python3" # Specify the Python 3 executable (e.g., python3, python3.x)

# --- Functions ---

check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: Command '$1' not found in PATH."
    exit 1
  fi
}

create_venv() {
  echo "Creating virtual environment '$VENV_NAME' using $PYTHON_VERSION..."
  "$PYTHON_VERSION" -m venv "$VENV_NAME"
  if [ $? -ne 0 ]; then
    echo "Error creating virtual environment."
    exit 1
  fi
  echo "Virtual environment created successfully."
}

activate_venv() {
  echo "Activating virtual environment '$VENV_NAME'..."
  source "$VENV_NAME/bin/activate"
  if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$(pwd)/$VENV_NAME" ]; then
    echo "Error activating virtual environment."
    exit 1
  fi
  echo "Virtual environment activated."
}

install_pip() {
  echo "Checking if pip is installed..."
  if ! command -v pip3 &> /dev/null; then
    echo "pip3 not found. Attempting to install pip for Python 3..."
    curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    "$PYTHON_VERSION" get-pip.py
    rm get-pip.py
    if [ $? -ne 0 ]; then
      echo "Error installing pip."
      exit 1
    fi
    echo "pip for Python 3 installed successfully."
  else
    echo "pip is already installed (likely pip3)."
  fi
}

install_requirements() {
  echo "Installing requirements from '$REQUIREMENTS_FILE'..."
  pip install -r "$REQUIREMENTS_FILE"
  if [ $? -ne 0 ]; then
    echo "Error installing requirements from '$REQUIREMENTS_FILE'."
    exit 1
  fi
  echo "Requirements installed successfully."
}

deactivate_venv() {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "Deactivating virtual environment..."
    deactivate
    echo "Virtual environment deactivated."
  fi
}

# --- Main Script ---

# Check if required commands exist
check_command "$PYTHON_VERSION"

# Create the virtual environment
create_venv

# Activate the virtual environment
activate_venv

# Install pip if needed (within the activated venv, so it's the venv's pip)
install_pip

# Install requirements from the file
if [ -f "$REQUIREMENTS_FILE" ]; then
  install_requirements
else
  echo "Warning: Requirements file '$REQUIREMENTS_FILE' not found. Skipping installation."
fi

# Deactivate the virtual environment (optional, but good practice)
deactivate_venv

echo "Script finished."
echo "to activate venv and launch jupyter run this from this directory"
echo "source ./venv_day1/bin/activate"
echo "jupyter lab"