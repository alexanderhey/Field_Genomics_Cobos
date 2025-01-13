---
title: "Nanopore workflow"
date: 2024-10-22
---

</div>

<hr>

## Table of Contents

- <a href="#molecular-procedures">Molecular Procedures</a>
- <a href="#worked-example">Worked Example</a>
- <a href="#real-time-example">Real-Time Example</a>


<br>


## Molecular Procedures

<!-- Buttons to toggle sections -->
<div style="text-align: center; margin-bottom: 20px;">
  <button onclick="toggleSection('dnaExtraction')"> DNA Extraction</button>
  <button onclick="toggleSection('libraryPrep')">Library Preparation</button>
  <button onclick="toggleSection('flowCell')"> Flow Cell Wash and Storage</button>
</div>

<!-- Containers for the PDFs -->
<div style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: space-evenly;">

  <!-- DNA Extraction -->
  <div id="dnaExtraction" class="pdf-section" style="display: none; border: 1px solid #ccc; border-radius: 8px; width: 600px; padding: 15px; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align: center;">
    <h3>DNA Extraction</h3>
    <a href="../procedures/extraction.pdf" target="_blank">Download DNA Extraction Protocol</a>
    <iframe src="../procedures/extraction.pdf" width="100%" height="400" style="border: none; margin-top: 10px;"></iframe>
  </div>

  <!-- Library Preparation -->
  <div id="libraryPrep" class="pdf-section" style="display: none; border: 1px solid #ccc; border-radius: 8px; width: 600px; padding: 15px; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align: center;">
    <h3>Library Preparation</h3>
    <a href="../procedures/lib_prep.pdf" target="_blank">Download Nanopore Native Barcode Library Prep PDF</a>
    <iframe src="../procedures/lib_prep.pdf" width="100%" height="400" style="border: none; margin-top: 10px;"></iframe>
  </div>

  <!-- Flow Cell Wash and Storage -->
  <div id="flowCell" class="pdf-section" style="display: none; border: 1px solid #ccc; border-radius: 8px; width: 600px; padding: 15px; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align: center;">
    <h3>Flow Cell Wash and Storage</h3>
    <a href="../procedures/flow_cell_wash_kit.pdf" target="_blank">Download Flow Cell Wash and Storage Protocol PDF</a>
    <iframe src="../procedures/flow_cell_wash_kit.pdf" width="100%" height="400" style="border: none; margin-top: 10px;"></iframe>
  </div>

</div>

<!-- JavaScript for toggling sections -->
<script>
  function toggleSection(sectionId) {
    var section = document.getElementById(sectionId);
    if (section.style.display === "none" || section.style.display === "") {
      section.style.display = "block";
      section.style.opacity = 0;
      setTimeout(function() { section.style.opacity = 1; }, 10); // Fade in
    } else {
      section.style.opacity = 0;
      setTimeout(function() { section.style.display = "none"; }, 500); // Fade out
    }
  }
</script>

<!-- CSS for fade effect -->
<style>
  .pdf-section {
    transition: opacity 0.5s ease;
  }
</style>

<style>
pre code {
    background-color: #2d2d2d; /* Dark gray background for the code block */
    border: 1px solid #555555; /* Light gray border around the code block */
    border-radius: 5px; /* Rounded corners for the box */
    padding: 10px; /* Adds some space inside the box */
    display: block; /* Ensures it's displayed as a block element */
    white-space: pre-wrap; /* Ensures the code wraps properly if it's too long */
    color: #ffffff; /* White text color for better contrast */
}
</style>

<br>

---
# Worked Example


The goal of this portion of the workshop is to practice the basic bioinformatic workflow required to process Nanopore adaptive sampling sequence data. Specifically, we will map reads to reference sequences, filter out host sequences, and perform homology searches against known pathogen sequences. This workflow uses publicly available data published by [Kipp et al. (2023)](https://www.nature.com/articles/s41598-023-37134-9).

[Kipp et al. (2023)](https://www.nature.com/articles/s41598-023-37134-9) shows how NAS can be used to selectively sequence DNA from multiple bacterial tick-borne pathogens circulating in wild populations of the black-legged tick vector, <i>Ixodes scapularis</i>. They test the consistency of pathogen recovery using NAS enrichment and depletion methods, compared to more traditional Illumina metagenomic sequencing methods. NAS enrichment and depletion methods successfully recovered 4 bacterial tick-borne pathogens (<i>Borellia burgdorferi</i>; <i>Borella miyamotoi</i>; <i>Anaplasma phagocytophilum</i>; and <i>Eherlichia muris</i>) from 8 female <i>I. scapularis</i> ticks, and even resulted in the sequencing of the entire bacterial pathogen genomes. Importantly, their NAS results were consistent with Illumina 16S microbiome data.

For this exercise, we are only working with their depletion dataset, as that workflow is best aligned with the sequencing approach of this workshop.
The goal of this process is to use NAS for real-time metagenomic surveillance, targeting pathogen detection in field-collected samples. This approach allows for selective sequencing of desired genomic regions. By performing these steps, we can efficiently map sequencing reads to reference genomes, filter out host sequences, and perform homology searches against known pathogen databases. This workflow mirrors the methodology described in [Kipp et al. (2023)](https://www.nature.com/articles/s41598-023-37134-9), where Nanopore sequencing was used to study tick-borne bacterial pathogens.


Before starting with Step 1: (1) install the [Required Software](../programs).   (2) make sure you have downloaded Kipp's data as instructed in [Getting Ready](../getting-ready).



<br>

## Step 1: Getting Started

In this step, we are using basic Linux commands to establish our file/folder structure. Mac and Linux users may open a terminal. Windows users should open their Ubuntu terminal via WSL.

Print your working directory (i.e., determine where your terminal window is located within the file structure of your computer):
{{< highlight bash >}}
pwd  # type this command and hit enter
{{< /highlight >}}

Home directory for Windows users via Ubuntu should be:
```bash
\\wsl.localhost\Ubuntu\home\<USERNAME>\field_genomics\data_example  # <USERNAME> was defined when installing Ubuntu
```

Make a directory 
(folder) for this workflow:
{{< highlight python >}}
mkdir field_genomics
{{< /highlight >}}

Navigate into that directory:
{{< highlight bash >}}
cd ~/field_genomics/
{{< /highlight >}}

Create a new subdirectory to store example data:
{{< highlight bash >}}
mkdir data_example
{{< /highlight >}}

Create another subdirectory to store results:
{{< highlight bash >}}
mkdir output_example
{{< /highlight >}}

Create a third subdirectory to store a BLAST database:
{{< highlight bash >}}
mkdir blast_database
{{< /highlight >}}

Create a fourth subdirectory to summarize results from the example:
{{< highlight bash >}}
mkdir summary_example
{{< /highlight >}}

Copy or move the 3 data files from [Getting Ready](../getting-ready) into the data_example/ directory. 
This can be done in a File Manager or Finder window via drag-and-drop or via the command line.
Ensure that the files downloaded are named as follows, as sometimes downloading/extracting zip files from Google Drive can change file names: 
- `Kipp_etal_depletion_reference.fasta`
- `SRR17281099.fasta.gz`
- `Kipp_etal_enrichment_reference.fasta`

	Example code for transferring these files from your `Downloads/` folder to the `data_example/` folder:
```bash
cd Downloads/
mv SRR17281099.fasta.gz /<YOUR_PATH>/field_genomics/
mv Kipp_etal_* <YOUR_PATH>/field_genomics/
```

**Note**: For Windows users, ensure that your computer does not suspend while running analyses. You need to repace `<YOUR_PATH>` with the output of your `pwd` command from above.


<br>

## Step 2: Burrows-Wheeler Aligner (BWA)

[Burrows-Wheeler Alignment](https://github.com/lh3/bwa) (BWA) is a software package that is used to align reads to a reference genome. First, we must index the reference genome. Indexing a reference genome is a process that speeds up sequence alignment by creating a data structure, allowing rapid matching of DNA sequences (reads) to the reference genome. This is how to index a reference genome:

### Variables:
- **Reference Genome Path**: `data_example/Kipp_etal_depletion_reference.fasta`

### Code:
{{< highlight bash >}}
bwa index data_example/Kipp_etal_depletion_reference.fasta
{{< /highlight >}}

<br>



1. **Input: Reference Genome**
   - A FASTA file containing the reference genome sequences.
   - Example:  
     ```
     >chr1  
     AGCTTAGCTAGCTACGATCGATCG  
     >chr2  
     GCTAGCTAGCTAGCTGATCGTACG  
     ```

2. **Indexing with BWA**
   - BWA generates auxiliary files (`.amb`,`.ann`,`.bwt`,`.pac`,`.sa`) such as suffix arrays or FM-indexes, that make the search process more efficient.
   - These files allow the alignment tool to quickly locate where short DNA sequences (reads) map to the genome.

<br>


## Step 3: Align Nanopore Reads to a Reference Genome

**Description**:
This step aligns the Nanopore sequencing reads to the reference genome. BWA-MEM is the algorithm in BWA that is best for aligning long reads (70bp or more).  [SAM](https://samtools.github.io/hts-specs/SAMv1.pdf) files (the ouput file format of this step) are a formatted, plain-text file that contains aligment information for sequences mapped to a reference. SAM files can also contain unmapped sequences. 

<div style="background-color: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center;"> <img src="../procedures/mapping.png" alt="Alignment Process" style="max-width: 100%; height: auto;"/> </div>

Photo credit: [Galaxy](https://usegalaxy.org/)

### Variables:
- **Reference Genome Path**: `data_example/Kipp_etal_depletion_reference.fasta`
- **Nanopore Sequences Path**: `data_example/SRR17281099.fasta.gz`
- **Output SAM File Path**: `output_example/Kipp_etal_alig_depletion.sam`

### Code:
{{< highlight bash >}}

#template command for Nanopore reads: bwa mem -x ont2d <reference_genome.fasta> <raw_reads.fasta.gz> <output.sam>

bwa mem -x ont2d data_example/Kipp_etal_depletion_reference.fasta data_example/SRR17281099.fasta.gz > output_example/Kipp_etal_alig_depletion.sam

# -x is a flag to specify specialized alignment stratagies, in this case, ont2d = Oxford Nanopore Reads

{{< /highlight >}}

<br>

## Step 4: Remove Host Sequence Data

**Description**:
Here, we remove reads that mapped to the host genome, retaining only unmapped sequences in a separate fasta file. These sequences represent reads that are NOT the host (e.g., bacterial DNA, fungal DNA, contamination, etc.).


### Variables:
- **Input SAM File Path**: `output_example/Kipp_etal_alig_depletion.sam`
- **Output Unmapped Reads Path**: `output_example/Kipp_etal_unmapped_depletion.fasta`

### Code:
{{< highlight bash >}}
samtools fasta -f 4 output_example/Kipp_etal_alig_depletion.sam > output_example/Kipp_etal_unmapped_depletion.fasta

#samtools -f is a flag that means "flag." In this case, we specify 4, which translates to filter that fasta file to keep only unmapped sequences

{{< /highlight >}}

<br>

**Description**:
[samtools](https://www.htslib.org/) is a suite of programs used for interacting with high-throughput sequencing data. It consists of samtools, BCFtools, and HTSlib. 


<br>

## Step 5: Basic Local Alignment Search Tool (BLAST)

**Description**: 
Next, we want to build a local database of tick-borne pathogen sequences. We will then compare our unaligned Nanopore reads to that database of reference pathogen sequences and use the percent identity (or percent similarity) to determine which pathogens are present in the Nanopore sequence data. We will use National Center for Biotechnology Information's (NCBI) BLAST (Basic Local Alignment Search Tool) tool to both (1) build the local database of know pathogens and (2) compare our data to it. The pathogen sequences used to build the reference database can be mined from GenBank/SRA, DDBJ, EuPathDB, or other sequence databases. Here, we build a database from the enrichment fasta file from Kipp et al. (2023) that contains 52 partial or complete genomes of tick-borne pathogens (see their [Supplementary Table 1](https://static-content.springer.com/esm/art%3A10.1038%2Fs41598-023-37134-9/MediaObjects/41598_2023_37134_MOESM1_ESM.pdf)).

### Code:

#### Create BLAST Database:
{{< highlight bash >}}
makeblastdb -in data_example/Kipp_etal_enrichment_reference.fasta -parse_seqids -blastdb_version 5 -title "Kipp_etal_enrichment" -dbtype nucl -out blast_database/Kipp_etal_enrichment_reference

#-blastdb_version 5 = Version of blastdb you would like. Version 5 (taxonomy aware) is the default starting with the 2.10.0 release. Value must be 4 or 5.
# -title "Kipp etal_enrichment" = 	Title for BLAST database. If not set, the input file name will be used
# -dbtype nucl = Molecule type of input, values can be nucl or prot.

{{< /highlight >}}

<br>

**Description**:
The above line of code creates a local BLAST database from the sequences in Kipp et al.'s (2023) enrichment fasta file. This database will be used as a reference against which we can compare our Nanopore sequence data to determine what pathogens are present in the sample.

<br>

#### Run BLAST Query:
{{< highlight bash >}}
blastn -query output_example/Kipp_etal_unmapped_depletion.fasta -db blast_database/Kipp_etal_enrichment_reference -out output_example/Kipp_etal_blast_results.txt
{{< /highlight >}}

<br>



**Description**:
This step uses the BLAST algorithm to search for each unmapped Nanopore sequence in the local pathogen reference database, and produce a text file with subject-query matches. In this context, the `subject` is the reference pathogen sequence and the query is the unmapped Nanopore read. A match occurs when there is >70% identity between the subject and query.
<br>

To summarize the BLAST results, run another BLAST query defining a tab-delimited output: -outfmt 6.

```bash
blastn -query output_example/Kipp_etal_unmapped_depletion.fasta -db blast_database/Kipp_etal_enrichment_reference -out output_example/Kipp_etal_blast_results_table.txt -outfmt 6
	#Options supplied to -outfmt (out format) can be customized to include alignment length,      percent identity, etc.
```

BLASTn tabular output format 6 guide:

<img src="../results/blasttab.jpg" alt="Alignment Process" style="max-width: 50%; height: auto; display: block; margin: 0 auto;"/>


<br> 

## Step 6: Summarize the Results

Here, we can take a look at what a small part of our default BLAST query output looks like:

<img src="../results/blast4.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>

<br>

**Lambda, K, H (Ungapped and Gapped)**
- These are statistical parameters used in BLAST to model the alignment scoring system.
- **Lambda**: Describes the expected distribution of alignment scores.
- **K**: Indicates the scale of the search space size.
- **H**: Describes the entropy or complexity of the scoring system.

**Effective Search Space Used**
- The size of the search space after applying any filters or adjustments based on the query and database.

**Query**
- The identifier of the input sequence, for example: `SRR17281099.315`.
- **Length=564**: Refers to the length of the query sequence (in nucleotides or amino acids, depending on the type of BLAST search).

**Sequences Producing Significant Alignments**
- Sequences in the database that have significant matches with the query sequence.
- **Example**: `NC_021880.1_An_ph_str_JM`
- **Length=1481598**: Indicates the length of the subject sequence (in nucleotides or amino acids).

**Score**
- The alignment score in **bits**. Higher scores indicate better alignments.
Score = **821 bits**.

**E-value (Expect Value)**
- The **E-value** measures statistical significance; smaller values indicate more significant alignments.

**Identities**
- Refers to the number and percentage of identical matches between the query and subject.
**532/570 (93%)**, meaning that 532 out of 570 positions are identical.

**Gaps**
- The number of gaps (insertions or deletions) in the alignment.
**23/570 (4%)**, meaning 23 positions out of 570 have gaps.

**Strand**
- Indicates whether the alignment is on the same strand (plus/plus) or opposite strands (plus/minus).

**Alignment**
- The actual sequence alignment between the query and subject:
  - Vertical bars (`|`) indicate identical matches.
  - A gap ( ) indicates an insertion or deletion.

---


**Description**:
Filter matches output from BLAST to retain only the query sequences that matched a reference sequence with >97% identity.

```bash
awk -F'\t' '$3 > 97' output_example/Kipp_etal_blast_results_table.txt > summary_example/Kipp_etal_high_hits.txt

# awk is a text processing command that allows you to filter, extract, and manipulate data from structured text, such as by selecting specific fields from a file based on a delimiter, applying conditions, and performing actions on matching lines
# -F'\t' specifies tabs (\t) as the white-space character delimiting the input file
# Only rows where the value in the third field ($3) is greater than 97 are written to the output file

```


```bash
cut -f1 summary_example/Kipp_etal_high_hits.txt | sort | uniq > summary_example/Kipp_etal_high_hit_headers.txt

cut -f2 summary_example/Kipp_etal_high_hits.txt | sort | uniq > summary_example/Kipp_etal_high_hit_subjects.txt

# cut -f1 extracts the first field from the input file (e.g., HEADERS or individual read IDs), sorts all header names alphanumerically, and removes duplicates
	# cut -f2 extracts the second field from the input file (e.g., SUBJECTS or where the read hit), sorts all subject names alphanumerical, and removes duplicates

```

### Separating sequences with high percentage matching

Initial steps to list the headers of sequences needed:

```bash
zcat data_example/SRR17281099.fasta.gz > data_example/SRR17281099.fasta

#zcat unzips the zipped fasta file 

samtools faidx data_example/SRR17281099.fasta

#samtools faidx indexes 

headers=`cat summary_example/Kipp_etal_high_hit_headers.txt`
```



Obtaining the subset of high perecentage matching sequences from the whole set of sequences.

```bash
samtools faidx data_example/SRR17281099.fasta $headers > summary_example/Kipp_etal_high_hit_sequences.fasta
```

### Step 7: Explore results on NCBI-BLAST (online)


Below is a graph of the number of hits per reference pathogen sequence. Clearly, one sequence (`NC_021880.1_An_ph_str._JM`) is more common than the others.

<img src="../results/hitsperwindows.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>


As an example, below a screenshot of the `Kipp_etal_blast_results_table.txt` output file. The data has been filtered based on % Match (e.g., percent identity) >97% and sorted by descending read length. The longest, high-quality match was also from `NC_021990.1_An_ph_str._JM`. Many of the reads are 200bp or less, and while they may have a higher % Match, the longer reads tend to have higher E value scores, thus are more informative for comparisons to the entire NCBI database. 

<img src="../results/results2.png" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>

Next, copy the read name associated with the longest, highest-quality match (`SRR17281099.418555`). Open the text file `Kipp_etal_high_hit_sequences.fasta` and use `Ctrl-F` to find that read in the file.: 


<img src="../results/finder.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>


Once you've located that read in the `Kipp_etal_high_hit_sequences.fasta` file, copy the sequence and paste the sequence into [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) online (Enter accession number(s), gi(s), or FASTA sequence(s) box in the upper left corner) and press `search`. This will return similar sequences in GenBank, displayed as shown in the image below:




First, we paste out sequence into the nucleotide box: 
<img src="../results/blast1.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>


After searching, a results pane will show you results similar to what we had on the command line, but in a different format. In the top right panel, we can filter our hits by organism, percent identity, E value, and Query Coverage. The bottom panel shows all of the hits, sorted by E value by default. More information about each sequence that hit can be found by clicking the name in the Description column. There are also many options for viewing the alignments, such as in the Graphic Summary and Alignments tabs, or by clicking MSA viewer.

<img src="../results/blast2.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>

NCBI has a neat feature where you can view how your sequence (highlighted in yellow) compares to other uploaded sequences:

<img src="../results/blast3.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>


### Conclusion

In this case, we can see that our longest read maps near-perfectly to a portion of an [Anaplasma phagocytophilum reference genome](https://www.ncbi.nlm.nih.gov/nuccore/CP000235.1), a Gram-negative bacterium that causes multiple diseases in cattle and sheep, as well as zoonoses like [human granulocytic anaplasmosis.](https://www.ncbi.nlm.nih.gov/books/NBK513341/) This result is consistent to those of Kip et. al 2023, which found evidence of the same bacteria in their approach that used the [kraken2](https://github.com/DerrickWood/kraken2) package for metagenomic classification. 

<br>

---
# Real-Time Example

**Description:**
This section contains all of the code we will use to analyze the Nanopore sequence data generated during this workshop. This is not part of the worked example (above).
<br>

What we choose to sequence will depend on the diversity of mammals collected, and will lead to one of two workflows: (1) Pathogen Detection via Host-Depletion or (2) Cryptic species identification via mitogenome enrichment

<style>
  pre {
    font-size: 0.9em; /* Adjust to control the font size of the code */
    background-color: #2e2e2e; /* A subtle background for code */
    color: #f8f8f2;
    padding: 10px;
    border-radius: 4px;
  }

  h2, h3 {
    font-size: 1.5em;
  }

  .tab-button {
    padding: 10px 20px;
    background-color: #007BFF;
    color: black;
    border: none;
    cursor: pointer;
    margin-right: 10px;
    border-radius: 4px;
  }

  .tab-button:hover {
    background-color: #0056b3;
  }
</style>

<div style="margin-bottom: 20px;">
  <button id="windowsButton" class="tab-button" onclick="toggleSection('windows')">Pathogen Detection </button>
  <button id="macButton" class="tab-button" onclick="toggleSection('mac')">Cryptic Species Identification</button>
</div>

<!-- Windows (With Ubuntu) / Linux Installation Section -->
<div id="windows" style="display:none;">

<h2> Depletion of host genomes for bacterial and fungal pathogen identification  </h2>

## 1. Basecalling

**Description:**
	Basecalling is the process of determining the sequence of nucleotide bases from the raw data generated by the sequencer. For Nanopore sequencing, basecalling involves interpreting changes in electral current as single-stranded DNA (or RNA) passes through the Nanopore. Current fluctuations correspond to different nucleotide bases which are decoded into <span style="color: #ff0000;">A's</span>, 
<span style="color: #00ff00;">G's</span>, 
<span style="color: #0000ff;">T's</span>, 
and <span style="color: #ffa500;">C's</span> by the dorado basecalling software.

Bash is a scripting language that XYZ. We can bundle multiple commands together into a script (.sh) file, which is just a plain-text file that can be interpreted and executed by the computer. The code block below contains all of the text in the script file. All Bash scripts must begin with `#! /binbash/` as that line tells the computer where to find the Bash program/executable. Then, variables are defined (base_dir, output_dir, dorado) to make the actual code easier to read.

The code below runs the dorado basecaller on each barcdoe (1 through 24) and produces an output BAM file for each, respectively.

[`Download 01_basecall.sh`](../scripts/01_basecall.sh)

{{< highlight bash >}}
#!/bin/bash
# Base directory for pod5 files
base_dir="/Library/MinKNOW/data/Ecuador_Workshop_Training_Pathogens_Pero/no_sample/20240913_1820_MN40667_FAY96875_60fc85db/pod5_pass"

# Output directory for basecalling results
output_dir="/Users/mammalogy/Ecuador_Workshop/dorado-0.7.3-linux-x64/bin/01_sup_out/"


#dorado path

dorado="/Users/mammalogy/Documents/software/dorado-0.7.0-osx-arm64/bin/dorado"

# Loop through each barcode directory

for barcode in barcode{01..24} 
# this loops over files named barcode01, barcode02, ..., barcode24
# The number of barcode files will depend on the number of individuals multiplexed and being analyzed simultaneously

do
    $dorado basecaller dna_r10.4.1_e8.2_400bps_fast@v5.0.0 "$base_dir/$barcode/" > "$output_dir/${barcode}.bam"
done
{{< /highlight >}}

Names of Dorado models (i.e., Here, we use the basecaller model [`dna_r10.4.1_e8.2_400bps_fast@5.0.0`](https://github.com/nanoporetech/dorado?tab=readme-ov-file#dna-models). Dorado model names are systematically structured, such that each segment corresponds to a different aspect of the model: 

**Analyte Type (dna)**: This denotes the type of analyte being sequenced. For DNA sequencing, it is represented as dna. If you are using a Direct RNA Sequencing Kit, this will be rna002 or rna004, depending on the kit.

**Pore Type (r10.4.1)**: This section corresponds to the type of flow cell used. For instance, FLO-MIN114/FLO-FLG114 is indicated by r10.4.1, while FLO-MIN106D/FLO-FLG001 is signified by r9.4.1.

**Chemistry Type (e8.2)**: This represents the chemistry type, which corresponds to the kit used for sequencing. For example, Kit 14 chemistry is denoted by e8.2 and Kit 10 or Kit 9 are denoted by e8.

**Translocation Speed (400bps)**: This parameter, selected at the run setup in MinKNOW, refers to the speed of translocation. Prior to starting your run, a prompt will ask if you prefer to run at 260 bps or 400 bps. The former yields more accurate results but provides less data. As of MinKNOW version 23.04, the 260 bps option has been deprecated.

**Model Type (hac)**: This represents the size of the model, where larger models yield more accurate basecalls but take more time. The three types of models are fast, hac, and sup. The fast model is the quickest, sup is the most accurate, and hac provides a balance between speed and accuracy. For most users, the hac model is recommended.

**Model Version Number (v5.0.0)**: This denotes the version of the model. Model updates are regularly released, and higher version numbers typically signify greater accuracy.
For more details on decoding dorado model names see [here](https://github.com/nanoporetech/dorado).



<br>

## 2. Align BAM Files to a Reference Genome

In this step, we align Nanopore reads to a reference genome. BAM files contain the same information as a SAM file, but in binary format which is not human readable. BAM files are generally smaller, however, and are therefore more efficient for software to work with. Alignment data is almost always stored as a BAM file and most software that analyzes aligned reads expects a BAM file as input.


[`Download 02_align.sh`](../scripts/02align.sh)

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

<br>

## 3. Extracting Unaligned Reads

Next, we extract the unaligned reads from the BAM files using `samtools`. This step is crucial for isolating reads that did not align to the reference genome, allowing us to focus on non-host sequences.

[`Download 03_unmapped_reads.sh`](../scripts/03_unmapped_reads.sh)

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

<br>

## 4. Renaming Sequence IDs Before Database Creation

Before creating the BLAST database, we rename the sequence IDs in the FASTA file to ensure uniqueness and compatibility. This step is essential for maintaining consistency in downstream analyses.

[`Download 03.5_shorten_fasta_header.sh`](../scripts/03.5_shorten_fasta_header.sh)

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

<br>

## 5. Creating a BLAST Database

With the sequence IDs renamed, we now create a BLAST database from the reference FASTA file. This database will be used for identifying the unaligned sequences.

[`Download 04_blast_db_creation.sh`](../scripts/04_blast_db_creation.sh)

{{< highlight bash >}}
#!/bin/bash

# Make the database
makeblastdb -in /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/shortened_unique_ids.fasta -dbtype nucl -out /Users/mammalogy/Ecuador_Workshop/Pathogen_Ref/bvbrc_pathogen_db -title "Pathogen Genomes DB" -parse_seqids

# Print success message
echo "BLAST database created successfully: $DB_NAME"
{{< /highlight >}}

<br>

## 6. Converting BAM to FASTA

Before running BLAST, we need to convert the unaligned BAM files into FASTA format. This step prepares the sequences for the BLAST search.

[`Download 05_convert_bam_to_fasta.sh`](../scripts/05_convert_bam_to_fasta.sh)

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

<br>

## 7. Running BLAST on FASTA Files

The converted FASTA files are then subjected to BLAST search against the created database to identify possible pathogenic sequences.

[`Download 06_blast_fastas.sh`](../scripts/06_blast_fastas.sh)

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

<br>

## 8. Renaming Sequence IDs in BLAST Results

Finally, the sequence IDs in the BLAST output are renamed to match their original identifiers, providing clear traceability of the sequences.

[`Download 07_rename_seqIDs.sh`](../scripts/07_rename_seqIDs.sh)

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


</div>


<!--Cryptic Species ID -->
<div id="mac" style="display:none;">
  <h2>Molecular species ID through mitochondrial genome enrichment </h2>

## 1. Basecalling

**Description:**
	Basecalling is the process of determining the sequence of nucleotide bases from the raw data generated by the sequencer. For Nanopore sequencing, basecalling involves interpreting changes in electral current as single-stranded DNA (or RNA) passes through the Nanopore. Current fluctuations correspond to different nucleotide bases which are decoded into <span style="color: #ff0000;">A's</span>, 
<span style="color: #00ff00;">G's</span>, 
<span style="color: #0000ff;">T's</span>, 
and <span style="color: #ffa500;">C's</span> by the dorado basecalling software.

Bash is a scripting language that XYZ. We can bundle multiple commands together into a script (.sh) file, which is just a plain-text file that can be interpreted and executed by the computer. The code block below contains all of the text in the script file. All Bash scripts must begin with `#! /binbash/` as that line tells the computer where to find the Bash program/executable. Then, variables are defined (base_dir, output_dir, dorado) to make the actual code easier to read.

The code below runs the dorado basecaller on each barcdoe (1 through 24) and produces an output BAM file for each, respectively.

[`Download 01_basecall.sh`](../scripts/01_basecall.sh)

{{< highlight bash >}}
#!/bin/bash
# Base directory for pod5 files
base_dir="/Library/MinKNOW/data/Ecuador_Workshop_Training_Pathogens_Pero/no_sample/20240913_1820_MN40667_FAY96875_60fc85db/pod5_pass"

# Output directory for basecalling results
output_dir="/Users/mammalogy/field_genomics/"


#dorado path

dorado="/Users/mammalogy/Documents/software/dorado-0.7.0-osx-arm64/bin/dorado"

# Loop through each barcode directory

for barcode in barcode{01..24} 
# this loops over files named barcode01, barcode02, ..., barcode24
# The number of barcode files will depend on the number of individuals multiplexed and being analyzed simultaneously

do
    $dorado basecaller dna_r10.4.1_e8.2_400bps_fast@v5.0.0 "$base_dir/$barcode/" > "$output_dir/${barcode}.bam"
done
{{< /highlight >}}

Names of Dorado models (i.e., Here, we use the basecaller model [`dna_r10.4.1_e8.2_400bps_fast@5.0.0`](https://github.com/nanoporetech/dorado?tab=readme-ov-file#dna-models). Dorado model names are systematically structured, such that each segment corresponds to a different aspect of the model: 

**Analyte Type (dna)**: This denotes the type of analyte being sequenced. For DNA sequencing, it is represented as dna. If you are using a Direct RNA Sequencing Kit, this will be rna002 or rna004, depending on the kit.

**Pore Type (r10.4.1)**: This section corresponds to the type of flow cell used. For instance, FLO-MIN114/FLO-FLG114 is indicated by r10.4.1, while FLO-MIN106D/FLO-FLG001 is signified by r9.4.1.

**Chemistry Type (e8.2)**: This represents the chemistry type, which corresponds to the kit used for sequencing. For example, Kit 14 chemistry is denoted by e8.2 and Kit 10 or Kit 9 are denoted by e8.

**Translocation Speed (400bps)**: This parameter, selected at the run setup in MinKNOW, refers to the speed of translocation. Prior to starting your run, a prompt will ask if you prefer to run at 260 bps or 400 bps. The former yields more accurate results but provides less data. As of MinKNOW version 23.04, the 260 bps option has been deprecated.

**Model Type (hac)**: This represents the size of the model, where larger models yield more accurate basecalls but take more time. The three types of models are fast, hac, and sup. The fast model is the quickest, sup is the most accurate, and hac provides a balance between speed and accuracy. For most users, the hac model is recommended.

**Model Version Number (v5.0.0)**: This denotes the version of the model. Model updates are regularly released, and higher version numbers typically signify greater accuracy.
For more details on decoding dorado model names see [here](https://github.com/nanoporetech/dorado).


## 2. Convert each BAM file to a FASTA format

{{< highlight bash >}}

#!/bin/bash
# Base directory for output
base_dir="/Users/mammalogy/Ecuador_Workshop/01_sup_out"

# Output directory for basecalling results
output_dir="/Users/mammalogy/Ecuador_Workshop/02_convert_bams_out/"

mkdir $output_dir -p

for barcode in barcode{01..24} 
# this loops over files named barcode01, barcode02, ..., barcode24
# The number of barcode files will depend on the number of individuals multiplexed and being analyzed simultaneously

do
    samtools fastq "$base_dir/$barcode.bam" > "$output_dir/${barcode}.fastq"
done

{{< /highlight >}}







<br>


</div>




## 2. Run Flye

**Description**:
[FLYE](https://github.com/mikolmogorov/Flye) is a software tool used to assemble genomes from long DNA sequences without a reference file to base the alignments off of. It pieces together overlapping DNA reads to form a continuous sequence, even if the data is noisy or has gaps. For mitogenomes, FLYE helps combine these long reads into a complete mitochondrial genome, and sometimes reads may span the entire mitogenome, making FLYE's aligning pretty easy. 

{{< highlight bash >}}

#!/bin/bash
# Base directory for output
base_dir="/Users/mammalogy/Ecuador_Workshop/02_convert_bams_out"

# Output directory for basecalling results
output_dir="/Users/mammalogy/Ecuador_Workshop/03_flye_out"

mkdir $output_dir -p

conda activate base

for barcode in barcode{01..24} 
# this loops over files named barcode01, barcode02, ..., barcode24
# The number of barcode files will depend on the number of individuals multiplexed and being analyzed simultaneously

do
  flye --genome-size 16000 --nano-hq $base_dir/$barcode.fastq --out-dir $output_dir/$barcode
done

{{< /highlight >}}

<br>


</div>


## 3. Align your mitochondrial genomes using Dorado

**Desription**: The dorado package is a suite of tools tailored for working with long read, Nanopore sequence data. This is the aligning function in Nanopore in which we provide a reference genome or an idea of what the genome should look like. The reads are then aligned to that reference to create a file for each individual's reads.

{{< highlight bash >}}


#!/bin/bash
# Base directory for output

#path for where you installed Dorado
dorado="/Users/mammalogy/Documents/software/dorado-0.7.0-osx-arm64/bin/dorado"

base_dir="/Users/mammalogy/Ecuador_Workshop/01_sup_out"

# Output directory for basecalling results
output_dir="/Users/mammalogy/Ecuador_Workshop/03_dorado_align_out/"

#Path to the reference file you want to align to
reference_path="/Users/mammalogy/Ecuador_Workshop/Peromyscus_mito/pero_mito.txt"

mkdir $output_dir -p

for barcode in barcode{01..24} 

do
  $dorado aligner $reference_path $base_dir/$barcode.bam | samtools sort > $output_dir/$barcode.bam 
done

# The " | " is a pipe command. It sends the output of the alignment into the samtools sort funtion. This function puts our reads in order so we can create a consensus sequence on the next step. 

{{< /highlight >}}


## Create a Consensus Sequence using samtools

{{< highlight bash >}}

for barcode in barcode{01..24} 

do

# Pull consensus sequence sequence of the sample out of the alignment (BAM) file
  samtools consensus -a --min-MQ 10 --min-BQ 10 $output_dir/$barcode.bam > $output_dir/$barcode.fasta
#-a include all positions
#-min-MQ minimum mapping quality
#-min-BQ minimum base quality
done

{{< /highlight >}}

## 4. Converting our consensus sequence into a format for alignment

**Description**:
Rename the header in each fasta file by the name of the fasta file

{{< highlight bash >}}

# Loop through a series of barcode numbers from 01 to 24
for barcode in barcode{01..24} 

do
    # For each barcode, find lines in the file that start with ">", which indicates the name of a sequence in a FASTA file.
    # Replace this part (">") with a new name that includes the barcode number (e.g., barcode01, barcode02, etc.).
    # This will rename the sequences based on their barcode and save them to a new file.
    sed 's/^>.*/>'${barcode}'/' $output_dir/$barcode.fasta > $output_dir/$barcode.rename.fasta

done

# Combine (concatenate) all the renamed sequences into a single file called "concatenated.fasta"
cat $output_dir/*.rename.fasta > $output_dir/concatanated.fasta

{{< /highlight >}}


## 5. Use MEGA to bring in concatanated fasta file, align the sequences, and build a tree

**Description**: [MEGA](https://www.megasoftware.net/) (Molecular Evolutionary Genetics Analysis) is a bioinformatics software suite used to analyze and visualize molecular sequence data to study evolutionary relationships. It provides tools for constructing phylogenetic trees, estimating divergence times, and testing evolutionary hypotheses using nucleotide and protein sequences.

<br>

Here, we imported `concatanated.fasta` into the MEGA Alignment explorer. Each barcode is a row and in that row are all of the nucleotide bases in order, alinged to eachother. Each base is a different color, with N's representing bases of unknown identity. 

<img src="../results/mega1.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 0 auto;"/>


<div style="margin-top: 20px;">
    It can be seen here that the mitochondrial genomes match each other near perfectly, but how does each sequence relate to the rest? For that answer, we can use the MEGA tree explorer on the same file. It will display the same sequences, but group them as a tree, with individuals with more similar sequences being placed closer to each other on the tree.
</div>


<br>

<img src="../results/mega2.jpg" alt="Alignment Process" style="max-width: 100%; height: auto; display: block; margin: 20px auto;"/>

