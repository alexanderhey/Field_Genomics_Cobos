---
title: "Getting Ready"
date: 2024-10-02
---

<hr>

<br>

## What to Bring
  - **Field gear**: pants, long sleeve shirts, gloves (leather or gardening), headlamp, rain gear (jacket, pants), sunscreen, hat, bug spray, personal medication/toiletries, as needed
  - **Footwear**: tall rubber boots and/or snake gaiters
  - **Technology**: Laptop computer for the bioinformatic component of the workshop. As we get closer to the start of the workshop, we will email instructions with a list of software and files to download before arrival. Please ensure you have the necessary software by visiting the [Software Installation page](../programs).

<br>

## What to Prepare
  No prior experience in molecular biology or bioinformatics is necessary for the workshop, but familiarity with basic concepts will be helpful. Ensure that all required software is installed prior to the start of the workshop.

  You will also have an opportunity to share your background in bioinformatics during informal discussions. Be ready to briefly introduce yourself and share the following information:
  - **Name**, position/title/career stage, organization
  - **Motivation** for taking the bioinformatics component of the workshop
  - **Research interests**
  - **Expectations** or specific goals for the bioinformatics training
  - **Rabies vaccination status**: Only participants who have had a rabies vaccine (or proof of adequate rabies titers within the last 4 months) will be able to work with bats. Others will work with rodents and eulipotyphlans.

<br>

## Download Reference Files and Read Data

Before starting the alignment process, make sure to download the necessary reference files and Nanopore reads. These files are required to follow along with the workflow.

### Files to Download:
- **Kipp_et_al_depletion_reference.fasta** (2.08 GB): This file contains the depletion reference for alignment.
- **Kipp_et_al_enrichment_reference.fasta** (14.2 MB): This file contains the enrichment reference for BLAST queries.
- **SRR17281099.fasta.gz** (132.2 MB): Nanopore reads in compressed FASTA format for alignment.

You can download all the files from the shared Google Drive folder using the following link:

[Download Reference Files and Read Data](https://drive.google.com/drive/folders/1I4eXk8tMN98TJyeog8P7g4RCcRbeOBVx?usp=drive_link)

<hr>

<br>

  <!-- Image Carousel -->
  <div id="carouselExample" class="carousel slide" data-bs-ride="carousel" style="max-width: 800px; margin: 0 auto;">
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img src="/getting_ready/dannyriver.jpg" class="d-block w-100" alt="Danny by the river">
      </div>
      <div class="carousel-item">
        <img src="/getting_ready/dannysmile.jpg" class="d-block w-100" alt="Danny smiling">
      </div>
      <div class="carousel-item">
        <img src="/getting_ready/group.jpg" class="d-block w-100" alt="Group photo">
      </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Next</span>
    </button>
  </div>

</div>

<style>
  .tab-button {
    background-color: #f1f1f1;
    border: 1px solid #ccc;
    color: #333;
    padding: 10px 20px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-right: 10px;
    border-radius: 5px;
  }

  .tab-button.active {
    background-color: #007bff;
    color: white;
    border-color: #007bff;
  }

  h3, h4 {
    margin-top: 20px;
    margin-bottom: 10px;
    font-size: 1.5em;
  }

  ul {
    margin-top: 5px;
  }

  li {
    margin-bottom: 5px;
  }

  /* Carousel styling */
  .carousel-inner img {
    max-height: 500px;
    object-fit: cover;
  }
</style>

<script>
  function showSection(section) {
    document.getElementById('combined').style.display = 'none';

    document.getElementById('fieldButton').classList.remove('active');

    if(section === 'combined') {
      document.getElementById('combined').style.display = 'block';
      document.getElementById('fieldButton').classList.add('active');
    }
  }

  // Set default section to display
  showSection('combined');
</script>

