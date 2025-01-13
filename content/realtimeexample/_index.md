---
title: "Nanopore workflow"
date: 2024-09-24
---
<div style="text-align: center;">

This is the worked example we will be performing in the field.

The first step involves super accurate basecalling (sup) using the Dorado aligner. Once bam files are generated from that step, we start at step 2, aligning:

</div>

## 1. Basecalling
[Download 01_basecall.sh](../scripts/01_basecall.sh)

{{< highlight bash >}}
#!/bin/bash
# Base directory for pod5 files
base_dir="/Library/MinKNOW/data/Ecuador_Workshop_Training_Pathogens_Pero/no_sample/20240913_1820_MN40667_FAY96875_60fc85db/pod5_pass"

# Output directory for basecalling results
output_dir="/Users/mammalogy/Ecuador_Workshop/dorado-0.7.3-linux-x64/bin/01_sup_out/"


#dorado path

dorado="/Users/mammalogy/Documents/software/dorado-0.7.0-osx-arm64/bin/dorado"

# Loop through each barcode directory

for barcode in barcode01 barcode02 barcode03 barcode04 barcode05 barcode06 barcode07 barcode08 barcode09 barcode10 barcode11 barcode12 barcode13 barcode14 barcode15 barcode16 barcode17 barcode18 barcode19 barcode20 barcode21 barcode22 barcode23 barcode24
do
    $dorado basecaller dna_r10.4.1_e8.2_400bps_fast@v5.0.0 "$base_dir/$barcode/" > "$output_dir/${barcode}.bam"
done
{{< /highlight >}}


## 2. Aligning BAM Files to a Reference Genome

[Download 02align.sh](../scripts/02align.sh)

{{< highlight bash >}}
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
{{< /highlight >}}

## 3. Extracting Unaligned Reads

Next, we extract the unaligned reads from the BAM files using `samtools`. This step is crucial for isolating reads that did not align to the reference genome, allowing us to focus on non-host sequences.

[Download 03_unmapped_reads.sh](../scripts/03_unmapped_reads.sh)

{{< highlight bash >}}
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
{{< /highlight >}}

## 4. Renaming Sequence IDs Before Database Creation

Before creating the BLAST database, we rename the sequence IDs in the FASTA file to ensure uniqueness and compatibility. This step is essential for maintaining consistency in downstream analyses.

[Download 03.5_shorten_fasta_header.sh](../scripts/03.5_shorten_fasta_header.sh)

{{< highlight bash >}}
#!/bin/bash

awk '
BEGIN {FS=" "; OFS=" "} 
/^>/ {
    id=substr($1, 2, 40); # Get the first 40 characters of the ID
    count[id]++;          # Count occurrences of this ID
    if (count[id] > 1) {  # If the ID is a duplicate, add a suffix
        id=id "_" count[id];
    }
    print ">" id;         # Print the modified ID
    next;
}
{print}' /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/bvbrc_nsamer_good_comp_noplant_veupathbd_allbut_vecthost_pathogen_genomes_04092024.fasta > /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/shortened_unique_ids.fasta
{{< /highlight >}}

## 5. Creating a BLAST Database

With the sequence IDs renamed, we now create a BLAST database from the reference FASTA file. This database will be used for identifying the unaligned sequences.

[Download 04_blast_db_creation.sh](../scripts/04_blast_db_creation.sh)

{{< highlight bash >}}
#!/bin/bash

# Make the database
makeblastdb -in /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/shortened_unique_ids.fasta -dbtype nucl -out /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/bvbrc_pathogen_db -title "Pathogen Genomes DB" -parse_seqids

# Print success message
echo "BLAST database created successfully: $DB_NAME"
{{< /highlight >}}

## 6. Converting BAM to FASTA

Before running BLAST, we need to convert the unaligned BAM files into FASTA format. This step prepares the sequences for the BLAST search.

[Download 05_convert_bam_to_fasta.sh](../scripts/05_convert_bam_to_fasta.sh)

{{< highlight bash >}}
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
{{< /highlight >}}

## 7. Running BLAST on FASTA Files

The converted FASTA files are then subjected to BLAST search against the created database to identify possible pathogenic sequences.

[Download 06_blast_fastas.sh](../scripts/06_blast_fastas.sh)

{{< highlight bash >}}
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
{{< /highlight >}}

## 8. Renaming Sequence IDs in BLAST Results

Finally, the sequence IDs in the BLAST output are renamed to match their original identifiers, providing clear traceability of the sequences.

[Download 07_rename_seqIDs.sh](../scripts/07_rename_seqIDs.sh)

{{< highlight bash >}}
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
{{< /highlight >}}
