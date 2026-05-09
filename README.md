# cheatography-collector

A tool to automatically fetch the specified cheat cheets from Cheatography.com and combine them to a single PDF.

## Prerequisites

* Git for Windows (provides bash and Unix utilities)
* make (via Chocolatey etc.)
* qpdf (via Chocolatey etc.)

## Usage

Edit `targets` to list the target cheat sheets by their expected file names.
Then, run `make`.

The output file is `out/cheat-set.pdf`.
