#!/bin/bash

# Set paths
FASTA_DIR="/Users/mammalogy/Ecuador_Workshop/03_unmapped_fasta_out"
DB_NAME="/Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/bvbrc_pathogen_db"
OUTPUT_DIR="/Users/mammalogy/Ecuador_Workshop/03_blastn_results"

# Create output directory for BLAST results if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run BLAST for each FASTA file
for FASTA_FILE in $FASTA_DIR/*.fasta; do
    BASENAME=$(basename $FASTA_FILE .fasta)
    blastn -query $FASTA_FILE -db $DB_NAME -out $OUTPUT_DIR/${BASENAME}_blastn.txt -outfmt 6 -num_threads 16
    echo "BLAST completed for $FASTA_FILE"
done

