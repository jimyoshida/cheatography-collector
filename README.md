# cheatography-collector

Automatically download the targeted cheat cheets from Cheatography.com and combine them to a single PDF.
Tested in Ubuntu-18.04.

## Prerequisites

* make
* qpdf
* wget

## Usage

Run these commands. 

```bash
vim targets # to list the target cheat sheets by their expected file names
make
```

The output file is `__cheat-set.pdf`.
