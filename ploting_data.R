library(ggplot2)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
    stop("Please provide input and output file paths.")
}

input_file <- args[1]
output_file <- args[2]

data <- read.csv(input_file, sep = '\t')
colnames(data) <- c("File_ID","Sample_type",'TPM_val')
head(data)

data$TPM_val <- as.numeric(data$TPM_val)

# Count data per sample type
count_data <- data %>%
    group_by(Sample_type) %>%
    summarize(n = n(), max_TPM = max(log2(TPM_val + 1), na.rm = TRUE))

# Plotting
p <- ggplot(data, aes(x = Sample_type, y = log2(TPM_val + 1))) +
    geom_boxplot() +
    geom_text(data = count_data, aes(x = Sample_type, y = max_TPM, label = paste("n=", n)), vjust = -0.5) +
    theme_bw() +
    xlab("Cell Type") +
    ylab("log2(TPM + 1)") +
    ggtitle("Lung Adenocarcinoma")

# Saving the plot
ggsave(output_file, plot = p, width = 8, height = 6)

