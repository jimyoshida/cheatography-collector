# cheatography-collector

Automatically fetch the targeted cheat cheets from Cheatography.com and combine them to a single PDF.
Tested with Git for Windows environment.

## Prerequisites

Install these modules by Chocolatey.

* make
* qpdf
* wget

## Usage

Edit `targets` to list the target cheat sheets by their expected file names.
Then, run `make`.

The output file is `out/cheat-set.pdf`.
