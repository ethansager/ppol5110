# PPOL 5110 Project

## Project Overview

This repository contains the analysis, data, and documentation for the Sierra Leone Decentralization Transfer Project.

## Repository Structure

```
├── analysis/           # Analysis files and outputs
│   ├── 00_dta/        # Processed data files
│   ├── 01_scripts/    # Analysis scripts (R, Python, etc.)
│   ├── 02_output/     # Generated outputs (plots, tables, etc.)
│   └── 03_docs/       # Documentation and reports
├── communication/     # Team communication materials
│   └── team_bios.md  # Team member information
├── raw_data/         # Raw data files (see raw_data/README.md)
└── writeups/         # Final paper and reports
```

## Getting Started

### Prerequisites
- R and Stata 
- Access to the shared OneDrive folder for raw data

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ethansager/ppol5110.git
   cd ppol5110
   ```

2. **Set up raw data:**
   - Follow instructions in `raw_data/README.md` to download data from OneDrive
   - Place all raw data files in the `raw_data/` directory

3. **Install dependencies:**
   - For R: Install required packages as specified in analysis scripts
   - For Stata: A basic edition is sufficient for running the scripts

## Important Notes

- Raw data files are not committed to the repository
- Follow consistent naming conventions for files and variables
    - Use snake_case for file names and variables
    - Include dates in file names where applicable
    - Avoid spaces and special characters in file names