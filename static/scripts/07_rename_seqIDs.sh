#!/bin/bash

# Define directories and files
RESULTS_DIR="/Users/mammalogy/Ecuador_Workshop/03_blastn_results"
MAPPING_FILE="/Users/mammalogy/Ecuador_Workshop/seq_id_mapping.txt"
OUTPUT_DIR="/Users/mammalogy/Ecuador_Workshop/03_blastn_results_with_original_ids"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Loop through each BLAST result file from barcode01 to barcode24
for i in $(seq -f "%02g" 1 24); do
    INPUT_FILE="$RESULTS_DIR/barcode${i}_unaligned_blastn.txt"
    OUTPUT_FILE="$OUTPUT_DIR/barcode${i}_unaligned_blastn_with_original_ids.txt"
    
    # Replace seq_X IDs with original IDs using awk
    awk 'NR==FNR {map[$1]=$2; next} $2 in map {$2=map[$2]}1' $MAPPING_FILE $INPUT_FILE > $OUTPUT_FILE
    
    echo "Processed $INPUT_FILE -> $OUTPUT_FILE"
done
