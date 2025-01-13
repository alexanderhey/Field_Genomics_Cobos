#!/bin/bash

# Path to the reference genome
REFERENCE_PATH="/Library/MinKNOW/data/References/Ecusdor_ref/pema_only_09092024.fasta"

# Base directory for input BAM files 
INPUT_DIR="/Users/mammalogy/Ecuador_Workshop/01_sup_out"

# Output directory for aligned BAM files
OUTPUT_DIR="/Users/mammalogy/Ecuador_Workshop/02_align_out"

# Loop over barcode01.bam to barcode24.bam
for i in $(seq -w 1 10); do
    # Define input and output file names
    INPUT_BAM="${INPUT_DIR}/barcode${i}.bam"
    OUTPUT_BAM="${OUTPUT_DIR}/barcode${i}_aligned.bam"

    # Run dorado aligner
    echo "Aligning ${INPUT_BAM}..."
    dorado aligner $REFERENCE_PATH $INPUT_BAM > $OUTPUT_BAM

    echo "Finished aligning barcode${i}.bam"
done