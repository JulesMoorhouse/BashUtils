#!/usr/bin/env bash
# Load all library components
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source every .sh file in the lib/ subdirectory
for file in "$SCRIPT_DIR"/lib/*.sh; do
    [[ -f "$file" ]] && source "$file"
done
