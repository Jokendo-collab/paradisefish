#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00

#move to the working directory
cd /data/okendojo/postdoc_project/assembly_results/qv_estimations


meryl count k=30 /data/okendojo/postdoc_project/maternal/*.fastq.gz output maternal_kmers.meryl

meryl count k=30 /data/okendojo/postdoc_project/paternal/*.fastq.gz output paternal_kmers.meryl


