#!/bin/bash
set -euo pipefail

nocolor="\e[0m"
red="\e[1;31m"
green="\e[1;32m"

# Download a single cheat sheet PDF from Cheatography.
# Usage: fetch_file [--dry-run] <downloads/author_sheet-name.pdf>
# Filename encodes author and sheet name: "author_sheet-name.pdf" →
#   https://cheatography.com/author/cheat-sheets/sheet-name/pdf/
fetch_file() {
    local dry_run=0
    if [ "${1:-}" = "--dry-run" ]; then
        dry_run=1
        shift
    fi
    local filename="$1"
    # Strip directory and extension, then split "author_sheet-name" into two words
    local keys
    keys=$(sed -e 's/^.*\///; s/\.pdf//; s/_/ /' <<< "$filename")
    local url
    url=$(awk '{printf "https://cheatography.com/%s/cheat-sheets/%s/pdf/\n", $1, $2}' <<< "$keys")

    if [ "$dry_run" = "1" ]; then
        echo "$url"
        return 0
    fi

    echo -e "${green}Downloading $filename...${nocolor}"
    echo -e "${red}Keys = $keys${nocolor}"
    mkdir -p downloads
    curl -f -o "$filename" "$url"
}

# When sourced (e.g. by tests), expose only the functions above and stop here
[[ "${BASH_SOURCE[0]}" != "$0" ]] && return 0

OUTFILE="out/cheat-set.pdf"
TARGETS_FILE="targets"

# Subcommand: download a single file (used by tests and manual runs)
if [ "${1:-}" = "fetch" ]; then
    shift
    fetch_file "$@"
    exit $?
fi

# Subcommand: remove all generated files
if [ "${1:-}" = "clean" ]; then
    rm -rf out downloads
    exit 0
fi

if [ ! -f "$TARGETS_FILE" ]; then
    echo "error: $TARGETS_FILE not found" >&2
    exit 1
fi

# Read targets, ignoring blank lines and comments
mapfile -t PAGE_IDS < <(grep -vE '^\s*(#|$)' "$TARGETS_FILE")

if [ "${#PAGE_IDS[@]}" -eq 0 ]; then
    echo "error: no entries in $TARGETS_FILE" >&2
    exit 1
fi

PAGE_FILES=()
for id in "${PAGE_IDS[@]}"; do
    path="downloads/$id"
    PAGE_FILES+=("$path")
    if [ ! -f "$path" ]; then
        fetch_file "$path"
    fi
done

mkdir -p out
qpdf --empty --pages "${PAGE_FILES[@]}" -- "$OUTFILE"
