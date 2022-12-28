#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00

#move to the working directory
cd /data/okendojo/postdoc_project/assembly_results

meryl count k=30 ../offspring/*.fastq.gz output offpring_kmers.meryl

