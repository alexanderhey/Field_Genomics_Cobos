
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
