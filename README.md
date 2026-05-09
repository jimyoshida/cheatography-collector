# cheatography-collector

A tool to automatically fetch the specified cheat cheets from Cheatography.com and combine them to a single PDF.

## Prerequisites

* WSL Ubuntu (provides bash and Unix utilities)
* make (`sudo apt install make`)
* qpdf (`sudo apt install qpdf`)
* curl (`sudo apt install curl`)

## Usage

Edit `targets` to list the target cheat sheets by their expected file names.
Then, run `make` inside WSL.

The output file is `out/cheat-set.pdf`.

### How It Works

The `Makefile` orchestrates the entire process:

1. Reads file names from `targets`
2. Calls `fetch.sh` for each file to download PDFs from Cheatography.com
3. Combines all downloaded PDFs into a single output file using `qpdf`

The `fetch.sh` script handles individual file downloads by parsing the filename and constructing the appropriate Cheatography URL.

## Development

No additional dependencies needed - Perl comes pre-installed on Ubuntu.

### Test Plan

The test suite (`test-fetch.pl`) verifies:

- **File download**: Downloads files with correct names using curl
- **Directory structure**: Creates `downloads/` directory for PDF files
- **Filename parsing**: Converts underscores to spaces (e.g., `Python_Basics.pdf` → `Python Basics`)
- **URL construction**: Builds correct Cheatography URLs from parsed filenames
- **Error handling**: Gracefully handles missing files or download failures
- **Multiple files**: Processes multiple files as Makefile would call
- **Directory management**: Maintains proper directory structure

Run tests in WSL:
```bash
perl test-fetch.pl
```
