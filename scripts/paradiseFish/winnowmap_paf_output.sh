#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00

#Load the required modules
module load python/3.9
module load snakemake/7.7.0
module load R/4.2.0
module load bedtools/2.30.0
module load samtools/1.9
module load winnowmap/2.03

#change to the directory where the mapping results will be located
cd /data/okendojo/postdoc_project/assembly_results/winnowmap_results

#Mapping pacbio-hifi reads on hifiasm assembly
winnowmap -W /data/okendojo/postdoc_project/assembly_results/hifiasm_repetitive_k15.txt -ax map-pb /data/okendojo/postdoc_project/assembly_results/hifiasm/paradiseF_hifiasm.p_ctg.fa /data/okendojo/postdoc_project/offspring/*.fastq.gz > Hifiasm.paf


#mapping reads on verkko (trio and no trio binned data)

winnowmap -W /data/okendojo/postdoc_project/assembly_results/Trio_verkko_repetitive_k15.txt -ax map-pb /data/okendojo/postdoc_project/assembly_results/verkko_Trio_assembly/assembly.fasta /data/okendojo/postdoc_project/offspring/*.fastq.gz > verkkoTriobinned.paf

winnowmap -W /data/okendojo/postdoc_project/assembly_results/verkkoNO_Trio_repetitive_k15.txt -ax map-pb /data/okendojo/postdoc_project/assembly_results/verkko_No_Trio_assembly/assembly.fasta /data/okendojo/postdoc_project/offspring/*.fastq.gz > verkkoNobinning.paf


