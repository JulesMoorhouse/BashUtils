#!/usr/bin/env bash
# xcode-dump.sh – Dump Xcode/Swift package source files.
# Source this file in your scripts to use the functions.
#
# Core function:
#   xcode_dump <output_file> <dir1> [dir2 ...]
#     Dumps Swift, plist, entitlements, project.pbxproj, and Package.swift files
#     from the given directories into the output file.
#
# Helper:
#   xcode_dump_project <project_root> [output_file]
#     Dumps a whole Xcode project or Swift package by automatically including
#     the root, Sources/, Tests/, and any .xcodeproj/.xcworkspace bundles.
#
# Examples:
#   # Dump a single target (output defaults to "HardcodedNumbersFixer-dump.txt")
#   xcode_dump_project /path/to/HardcodedNumbersFixer
#
#   # Dump a target plus a shared support directory
#   xcode_dump /tmp/myapp_dump.txt \
#       /path/to/HardcodedNumbersFixer \
#       /path/to/AppsSupportCommon
#
#   # Dump multiple directories including support subfolders
#   xcode_dump ~/Desktop/code.txt \
#       HardcodedNumbersFixer \
#       ../AppsSupportCommon/Sources \
#       ../AppsSupportCommon/AppsSupportCommon
#
#   # In your original script:
#   source ~/BashUtils/lib/xcode-dump.sh
#   PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
#   SUPPORT_DIR="$PROJECT_ROOT/../AppsSupportCommon"
#   xcode_dump "$PROJECT_ROOT/codedump_HardcodedNumbersFixer.txt" \
#       "$PROJECT_ROOT/HardcodedNumbersFixer" \
#       "$SUPPORT_DIR/Sources" \
#       "$SUPPORT_DIR/AppsSupportCommon" \
#       "$PROJECT_ROOT"/*.xcodeproj \
#       "$PROJECT_ROOT"/*.xcworkspace

# Core function: dump given directories
xcode_dump() {
    local output="$1"
    shift
    > "$output"
    for dir in "$@"; do
        [[ -d "$dir" ]] || continue
        find "$dir" -type f \( \
            -name "*.swift" -o \
            -name "*.plist" -o \
            -name "*.entitlements" -o \
            -name "project.pbxproj" -o \
            -name "Package.swift" \) \
            -print0 2>/dev/null | while IFS= read -r -d '' file; do
                echo "// File: $file" >> "$output"
                cat "$file" >> "$output"
                echo "" >> "$output"
            done
    done
    echo "✅ Dumped to $output"
}

# Helper: dump a whole Xcode project or Swift package
xcode_dump_project() {
    local project_root="$1"
    local output="${2:-${project_root##*/}-dump.txt}"
    local dirs=("$project_root")

    # Add common source locations if they exist
    [[ -d "$project_root/Sources" ]] && dirs+=("$project_root/Sources")
    [[ -d "$project_root/Tests" ]] && dirs+=("$project_root/Tests")
    [[ -d "$project_root"/*.xcodeproj ]] && dirs+=("$project_root"/*.xcodeproj)
    [[ -d "$project_root"/*.xcworkspace ]] && dirs+=("$project_root"/*.xcworkspace)

    xcode_dump "$output" "${dirs[@]}"
}
