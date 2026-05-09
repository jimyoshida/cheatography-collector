#!/bin/bash
nocolor="\e[0m"
red="\e[1;31m"
green="\e[1;32m"

DRY_RUN=0
if [ "$1" = "--dry-run" ]; then
    DRY_RUN=1
    shift
fi

FILENAME=$1
KEYS=$(sed -e 's/^.*\///; s/\.pdf//; s/_/ /' <<< $FILENAME)
URL=$(awk '{printf "https://cheatography.com/%s/cheat-sheets/%s/pdf/\n", $1, $2}' <<< $KEYS)

if [ "$DRY_RUN" = "1" ]; then
    echo "$URL"
    exit 0
fi

echo -e "${green}Downloading $FILENAME...${nocolor}"
echo -e "${red}Keys = $KEYS${nocolor}"
mkdir -p downloads
curl -f -o $FILENAME $URL || exit 1

exit 0
