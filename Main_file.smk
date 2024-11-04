import glob
import os
import pandas as pd

input_files = glob.glob("tcga_data_files/*/*.rna_seq.augmented_star_gene_counts.tsv")

rule all:
    input: "outp_file/final_data_file.tsv","outp_file/sample_sheet.tsv","outp_file/box_plot.png"

rule Extracting_tpm:
    input: input_files
    output: "outp_file/final_data_file.tsv"
    run:
        with open("outp_file/final_data_file.tsv", 'w') as out_f:
            for input_file in input_files:
                dir_name = os.path.basename(os.path.dirname(input_file))
                with open(input_file) as f:
                    for line in f:
                        fields = line.strip().split()
                        if len(fields) > 1 and fields[1] == "NKX2-1":
                            out_f.write(f"{dir_name}\t{fields[6]}\n")
        

rule Sample_sheet:
    input:
        A = "outp_file/final_data_file.tsv"
    output:
        "outp_file/sample_sheet.tsv"
    run:
        df = pd.read_csv(input.A, sep='\t', header=None)
        dfb= pd.read_csv(f"gdc_sample_sheet.tsv", sep='\t')

        df.columns = ['File ID', 'Tpm_val']	

        df_final = dfb.merge(df,on='File ID')
        df_final =df_final[df_final['Sample Type'].isin(['Solid Tissue Normal','Primary Tumor'])]

        df_final = df_final[['File ID','Sample Type','Tpm_val']]

        df_final.to_csv("outp_file/sample_sheet.tsv",sep='\t',index=False)	
                    
rule Final_plotting:
    input:
        "outp_file/sample_sheet.tsv"
    output:
        "outp_file/box_plot.png"
    shell:
        """
        Rscript --vanilla ploting_data.R {input} {output}
        """		
