#!/bin/bash

# Exit on any error
set -e

# Resolve the absolute path to this script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PATCHED_PKG_DIR="$SCRIPT_DIR/dev/ODEInterfaceDiffEq"

echo "=== Developing patched ODEInterfaceDiffEq inside active project ==="
echo "Path: $PATCHED_PKG_DIR"

# Run Julia Pkg.develop pointing to the local dev copy
julia --project -e "import Pkg; Pkg.develop(path=\"$PATCHED_PKG_DIR\"); Pkg.resolve(); Pkg.precompile()"

echo "=== Done! ODEInterfaceDiffEq is now linked and patched. ==="
