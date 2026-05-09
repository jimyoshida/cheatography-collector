#!/bin/bash
nocolor="\e[0m"
red="\e[1;31m"
green="\e[1;32m"

FILENAME=$1
echo -e "${green}Downloading $FILENAME...${nocolor}"

KEYS=$(sed -e 's/^.*\///; s/\.pdf//; s/_/ /' <<< $FILENAME)
echo -e "${red}Keys = $KEYS${nocolor}"

URL=$(awk '{
	printf "https://cheatography.com/%s/cheat-sheets/%s/pdf/\n", $1, $2
}' <<< $KEYS)

mkdir -p downloads
curl -f -o $FILENAME $URL || exit 1

exit 0
