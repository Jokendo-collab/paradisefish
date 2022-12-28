#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=180g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=zebrafish


#Load the modules
module load verkko/1.1
module load snakemake/7.7.0
module load R/4.2.0
module load bedtools/2.30.0
module load samtools/1.9
module load gcc/9.2.0
module load python/3.7
#move to the asm dir
cd /data/okendojo/zebrafish/assembly_results

#Run verkko
hifiReads=/data/okendojo/zebrafish/hifi/m54313U_220817_024630.hifi_reads.fastq.gz
ontData=/data/okendojo/zebrafish/ontData/*.gz


verkko -d vk --hifi ${hifiReads} --nano ${ontData} --slurm --graphaligner --mbg 


