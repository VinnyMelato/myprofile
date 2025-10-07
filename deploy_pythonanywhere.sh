#!/bin/bash
# deploy_pythonanywhere.sh
# Usage on PythonAnywhere (Bash console):
#   bash deploy_pythonanywhere.sh
# This script assumes you're running it on PythonAnywhere and will:
# - create a virtualenv
# - install requirements
# - run migrations
# - collectstatic
# Adjust PYTHON_CMD if you need a different python version.

set -euo pipefail

# ---------------------------
# Configuration (edit if needed)
# ---------------------------
PYPROJECT_DIR="$HOME/myprofile"                # directory which contains manage.py
VENV_DIR="$HOME/.virtualenvs/myprofile-venv"   # virtualenv location
PYTHON_CMD="python3.11"                        # python executable on PythonAnywhere; change if unavailable
REQUIREMENTS_FILE="$PYPROJECT_DIR/requirements.txt"

# ---------------------------
# Helpers
# ---------------------------
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# prefer PYTHON_CMD, fall back to available python
if ! command_exists "$PYTHON_CMD"; then
  if command_exists python3.10; then
    PYTHON_CMD=python3.10
  elif command_exists python3.8; then
    PYTHON_CMD=python3.8
  elif command_exists python3; then
    PYTHON_CMD=python3
  else
    echo "No suitable python found. Install or change PYTHON_CMD in this script." >&2
    exit 1
  fi
fi

echo "Using Python: $(which $PYTHON_CMD) ($($PYTHON_CMD --version 2>&1))"

# Create virtualenv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtualenv at $VENV_DIR"
  $PYTHON_CMD -m venv "$VENV_DIR"
fi

# Activate virtualenv
source "$VENV_DIR/bin/activate"

# Upgrade pip and install requirements
pip install --upgrade pip
if [ -f "$REQUIREMENTS_FILE" ]; then
  echo "Installing requirements from $REQUIREMENTS_FILE"
  pip install -r "$REQUIREMENTS_FILE"
else
  echo "No requirements.txt found at $REQUIREMENTS_FILE" >&2
fi

# Run migrations and collectstatic
cd "$PYPROJECT_DIR"
python manage.py migrate --noinput
python manage.py collectstatic --noinput

echo "Deployment steps finished. Please go to the PythonAnywhere Web tab and:
 - set the source directory to: $PYPROJECT_DIR
 - set the WSGI file to use the snippet provided in the repository README or below
 - set the virtualenv path to: $VENV_DIR
 - add environment variables (SECRET_KEY, DEBUG=False, and any API keys like CLOUDINARY_URL)
 - add a static files mapping: URL /static/ -> $PYPROJECT_DIR/staticfiles
Then reload the web app in the PythonAnywhere Web tab."
