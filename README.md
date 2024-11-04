# Project Overview

This Snakemake pipeline, specified in `Main_file.smk`, performs a four-step analysis to search for the `NKX2-1` gene across multiple directories, extract relevant expression values, categorize the samples, and generate a box plot. 

## Workflow Description

The main Snakemake file contains four rules:

1. **Rule `all`**  
   - This rule specifies the final target outputs of the pipeline, ensuring all preceding rules are completed as dependencies.

2. **Rule `Extract_TPM`**  
   - Searches for the `NKX2-1` gene across different directories.
   - For each directory containing the gene, extracts the TPM value from column 7 of the relevant file.
   - Retrieves the directory name, which serves as the specific ID for the sample, and uses this ID to extract the sample category (e.g., 'Solid Tissue Normal', 'Primary Tumor') from `gdc_sample_sheet.tsv`.
   - Saves the results into `outp_file/final_data_file.tsv`.

3. **Rule `Sample_sheet`**  
   - Reads `final_data_file.tsv` and uses it to retrieve the sample category from `gdc_sample_sheet.tsv`.
   - Appends the category information to each sample entry, saving the output in `outp_file/sample_sheet.tsv`.

4. **Rule `Final_plotting`**  
   - Takes `outp_file/sample_sheet.tsv` as input and uses `plotting_data.R` to generate a box plot.
   - The R script leverages the `ggplot2` library to create the visualization.

## Running the Pipeline

To execute the pipeline, first activate the Snakemake environment:

```bash
conda activate snakemake_env
```

Then, run Snakemake with the following command, which forces the execution of all rules:

```bash
snakemake --cores 2 --snakefile Main_file.smk --forcerun all
```

This setup will generate the final processed and categorized data as well as a box plot based on the extracted gene expression values.
