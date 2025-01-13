---
title: "Software"
date: 2024-10-22
---

</div>

<hr>

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
  <button id="windowsButton" class="tab-button" onclick="toggleSection('windows')">Windows (With Ubuntu) / Linux</button>
  <button id="macButton" class="tab-button" onclick="toggleSection('mac')">Mac</button>
</div>

<!-- Windows (With Ubuntu) / Linux Installation Section -->
<div id="windows" style="display:none;">
  <h2>Install Linux on Windows</h2>
  <p>If you’re using Windows, it’s highly recommended to set up a Linux environment (such as Ubuntu) through the Windows Subsystem for Linux (WSL). Follow these steps to get started:</p>

  <h3>Step 1: Open Command Prompt and Run WSL Installation</h3>
  <pre><code>
wsl --install
  </code></pre>
  <ul>
    <li>Follow the instructions to install the WSL virtual machine.</li>
    <li>You’ll be required to restart your computer during this process.</li>
    <li>After restarting, a terminal should appear.</li>
    <li>Set up a username and password for your new Ubuntu environment.</li>
  </ul>
  <p>If you need more details, visit the official website: <a href="https://learn.microsoft.com/en-us/windows/wsl/install">Install WSL</a></p>

  <h3>Step 2: Install Required Software Elements</h3>
  <p>Run the following commands to set up your session:</p>

  <h4>Add a complete library repository for Ubuntu</h4>
  <pre><code>
sudo add-apt-repository universe
sudo apt update
  </code></pre>

  <h4>Install the needed libraries</h4>
  <p>Use the following commands to install git, bzip2, bwa, samtools, and blast:</p>
  <pre><code>
sudo apt install git-all -y
sudo apt install bzip2 -y
sudo apt install bwa -y
sudo apt install samtools -y
sudo apt install ncbi-blast+ -y
  </code></pre>

  <p>You are all set. Continue to the <a href="../workflows">Workflow page</a> to begin the Worked Example.</p>
</div>

<!-- Mac Installation Section -->
<div id="mac" style="display:none;">
  <h2>Program Installation on a Mac using Homebrew</h2>

  <h3>Step 1: Install Homebrew</h3>
  <p>Homebrew ("brew" for short) is an open-source software package management system that simplifies the installation of software on MacOS. For more details visit <a href="https://brew.sh/">Homebrew</a>. To install Homebrew on your Mac, run the following command:</p>
  <pre><code>
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  </code></pre>

  <p>Once installed, Homebrew will encourage you to "add it to your path". Use the commands provided by Homebrew, which look similar to these:</p>
  <pre><code>
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/<USERNAME>/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
  </code></pre>

  <h3>Step 2: Program Installation</h3>
  <p>You can now install `samtools`, `blastn`, and `bwa` using the following commands:</p>
  <pre><code>
brew install samtools
brew install blast
brew install bwa
  </code></pre>

  <p>To manually install BLAST, download the latest disk image (dmg) from the following link: <a href="https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/">NCBI BLAST+ Download</a></p>

  <p>You are all set. We will begin the Worked Example in the field starting on the <a href="../workflows">Workflow page</a>.</p>
</div>

<script>
function toggleSection(section) {
  const windows = document.getElementById('windows');
  const mac = document.getElementById('mac');

  // Hide the other section
  if (section === 'windows') {
    mac.style.display = 'none';
  } else {
    windows.style.display = 'none';
  }

  // Toggle the selected section
  const selectedSection = document.getElementById(section);
  if (selectedSection.style.display === 'none' || selectedSection.style.display === '') {
    selectedSection.style.display = 'block';
  } else {
    selectedSection.style.display = 'none';
  }
}
</script>



</div>

<div style="margin-bottom: 20px;">
  <button id="realtimeButton" class="tab-button" onclick="showSection('realtime')">Real-time analysis programs information</button>
  <button id="workedExampleButton" class="tab-button" onclick="showSection('workedExample')">Worked Example programs information</button>
</div>

<!-- Real-time Analysis Programs Section -->
<div id="realtime" style="display:none;">

  **Description**: These are the programs you may need if you wish to replicate the analysis performed in the field on the data we generate with the Nanopore run. The participants do not need Dorado for the Worked Example they will be performing on their computers.

  ## Dorado

  **Description**: Dorado is a basecalling and alignment tool used for processing Oxford Nanopore sequencing data.

  **Website**: [Dorado GitHub](https://github.com/nanoporetech/dorado)

  **Installation**:

<pre><code>
# For Linux (generic)
  wget https://github.com/nanoporetech/dorado/releases/download/v0.7.3/dorado-0.7.3-linux-x64.tar.gz
  tar -xvzf dorado-0.7.3-linux-x64.tar.gz
  cd dorado-0.7.3-linux-x64/bin/
  export PATH=$PATH:$PWD

  # For MacOS (with Homebrew)
  brew install dorado

  # For MacOS (without Homebrew)
  wget https://github.com/nanoporetech/dorado/releases/download/v0.7.3/dorado-0.7.3-macos-x64.tar.gz
  tar -xzvf dorado-0.7.3-macos-x64.tar.gz
  cd dorado-0.7.3-macos-x64/bin/
  export PATH=$PATH:$PWD

  # For Windows (using WSL)
  wget https://github.com/nanoporetech/dorado/releases/download/v0.7.3/dorado-0.7.3-linux-x64.tar.gz
  tar -xvzf dorado-0.7.3-linux-x64.tar.gz
  cd dorado-0.7.3-linux-x64/bin/
  export PATH=$PATH:$PWD
</code></pre>

</div>

<!-- Program Information Section -->
<div id="workedExample" style="display:none;">

  **Description**: These are the programs everyone will need to complete the example that workshop participants will walk through.

  ## Program Information

  ## Samtools
  **Description**: Samtools is a suite of programs for interacting with high-throughput sequencing data. It is used for extracting unaligned reads and converting BAM files to FASTA.
  
  **Website**: [Samtools Website](http://www.htslib.org/)

  ## BLAST+
  **Description**: BLAST+ is a suite of tools to perform similarity searches against nucleotide and protein databases. It is widely used in bioinformatics for comparing sequence similarity.

  **Website**: [BLAST+ NCBI](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)

  ## BWA
  **Description**: BWA (Burrows-Wheeler Aligner) is a software package for mapping low-divergent sequences against a large reference genome. It is commonly used in genome assembly and variant calling.

  **Website**: [BWA GitHub](https://github.com/lh3/bwa)

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
</style>

<script>
  function showSection(section) {
    document.getElementById('windows').style.display = 'none';
    document.getElementById('mac').style.display = 'none';
    document.getElementById('realtime').style.display = 'none';
    document.getElementById('workedExample').style.display = 'none';

    document.getElementById('windowsButton').classList.remove('active');
    document.getElementById('macButton').classList.remove('active');
    document.getElementById('realtimeButton').classList.remove('active');
    document.getElementById('workedExampleButton').classList.remove('active');

    if(section === 'windows') {
      document.getElementById('windows').style.display = 'block';
      document.getElementById('windowsButton').classList.add('active');
    } else if(section === 'mac') {
      document.getElementById('mac').style.display = 'block';
      document.getElementById('macButton').classList.add('active');
    } else if(section === 'realtime') {
      document.getElementById('realtime').style.display = 'block';
      document.getElementById('realtimeButton').classList.add('active');
    } else if(section === 'workedExample') {
      document.getElementById('workedExample').style.display = 'block';
      document.getElementById('workedExampleButton').classList.add('active');
    }
  }

  // Set default section to display
  showSection('windows');
</script>

<br>


# Optional Programs
RStudio may be optionally used in the workshop for visualizatioin on the results of the worked example. 
## Install RStudio

RStudio is a powerful IDE for R. Follow these steps to install it:

- Download RStudio from POSIT: [Download RStudio](https://posit.co/download/rstudio-desktop/)
- Follow the installation instructions for your operating system (Windows, macOS, Linux).

