#!/bin/bash

#Make the database
makeblastdb -in /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/renamed_sequences.fasta -dbtype nucl -out /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/bvbrc_pathogen_db -title "Pathogen Genomes DB" -parse_seqids

# Print success message
echo "BLAST database created successfully: $DB_NAME"
