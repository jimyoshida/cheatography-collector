#!/bin/bash
nocolor="\e[0m"
red="\e[1;31m"
green="\e[1;32m"

FILENAME=$1

KEYS=$(echo $FILENAME | sed 's/\.pdf//; s/_/ /')

URL=$(echo $KEYS | awk '{
	printf "https://cheatography.com/%s/cheat-sheets/%s/pdf/\n", $1, $2
}')

echo -e "${green}Downloading $FILENAME...${nocolor}"
wget -O $FILENAME $URL || exit 1

exit 0
