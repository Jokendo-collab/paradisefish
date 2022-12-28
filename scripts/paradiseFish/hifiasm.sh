#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov


#Hifiasm without binning with 

#Normal assembly without triobinning;# Assemble heterozygous genomes with built-in duplication purging
cd /data/okendojo/paradisfishProject/assemblies/hifiasm/notrio

hifiasm -o hifiasmNoTrio.asm -t 32 -D 10.0 -c 25 -d 75 --hg-size 0.5g -l1 /data/okendojo/paradisfishProject/child/*.fastq.gz


