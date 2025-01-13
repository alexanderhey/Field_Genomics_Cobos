#!/bin/bash

# Load samtools (if needed)
# module load samtools

# Set paths
BAM_DIR="/Users/mammalogy/Ecuador_Workshop/03_unmapped_out"
FASTA_DIR="/Users/mammalogy/Ecuador_Workshop/03_unmapped_fasta_out"
DB_NAME="/Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/bvbrc_pathogen_db"

# Create output directory for FASTA files if it doesn't exist
mkdir -p $FASTA_DIR

# Convert BAM files to FASTA
for BAM_FILE in $BAM_DIR/*.bam; do
    BASENAME=$(basename $BAM_FILE .bam)
    samtools fasta $BAM_FILE > $FASTA_DIR/${BASENAME}.fasta
    echo "Converted $BAM_FILE to FASTA format"
done
