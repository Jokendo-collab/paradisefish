#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#move to the working directory

cd /data/okendojo/paradisfishProject/assemblies/verkko

#Load the modules
module load verkko/1.1
module load python/3.9
module load snakemake/7.7.0
module load R/4.2.0
module load bedtools/2.30.0
module load samtools/1.9

#Run verkko
verkko -d notrio --hifi /data/okendojo/paradisfishProject/child/*.fastq.gz --no-nano --slurm --graphaligner --mbg 


