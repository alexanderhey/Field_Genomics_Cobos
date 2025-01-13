#!/bin/bash

# Path to samtools (ensure samtools is installed and accessible in your PATH)
SAMTOOLS_PATH="/opt/homebrew/bin/samtools"

# Base directory for input BAM files (update this to the correct directory)
INPUT_DIR="/Users/mammalogy/Ecuador_Workshop/02_align_out"

# Output directory for unaligned BAM files
OUTPUT_DIR="/Users/mammalogy/Ecuador_Workshop/03_unmapped_out"

# Loop over barcode01.bam to barcode24.bam
for i in $(seq -w 1 24); do
    # Define input and output file names
    INPUT_BAM="${INPUT_DIR}/barcode${i}_aligned.bam"
    OUTPUT_BAM="${OUTPUT_DIR}/barcode${i}_unaligned.bam"

    # Extract unaligned reads using samtools
    echo "Extracting unaligned reads from ${INPUT_BAM}..."
    $SAMTOOLS_PATH view -b -f 4 $INPUT_BAM > $OUTPUT_BAM

    echo "Finished extracting unaligned reads for barcode${i}.bam"
done
