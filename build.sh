#!/bin/bash
set -euo pipefail

OUTFILE="out/cheat-set.pdf"
TARGETS_FILE="targets"

if [ "${1:-}" = "clean" ]; then
    rm -rf out downloads
    exit 0
fi

if [ ! -f "$TARGETS_FILE" ]; then
    echo "error: $TARGETS_FILE not found" >&2
    exit 1
fi

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
        bash fetch.sh "$path"
    fi
done

mkdir -p out
qpdf --empty --pages "${PAGE_FILES[@]}" -- "$OUTFILE"
