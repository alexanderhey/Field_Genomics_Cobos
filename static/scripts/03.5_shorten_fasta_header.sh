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
