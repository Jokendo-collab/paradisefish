#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=12:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Assessing the Read Content of the Transcriptome Assembly
#In order to comprehensively capture read alignments, we run the process below. Bowtie2 is used to align the reads to the transcriptome and then we count the number of proper pairs and improper or orphan read alignments.

#load the required modules
module load samtools
module load bowtie/2

cd /data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files

#1.0: First, build a bowtie2 index for the transcriptome:
bowtie2-build asmTranstrinity.Trinity.fasta asmTranstrinity.Trinity.fasta

#2.0: Then perform the alignment to just capture the read alignment statistics.
bowtie2 -p 32 -q --no-unal -k 20 -x asmTranstrinity.Trinity.fasta -1 *_1.fastq.gz -2 *_2.fastq.gz 2>align_stats.txt| samtools view -@10 -Sb -o bowtie2.bam

#Visualize read support using IGV

##Sort the alignments by coordinate
samtools sort bowtie2.bam -o bowtie2.coordSorted.bam

##Index the coordinate-sorted bam file
samtools index bowtie2.coordSorted.bam

##Index the Trinity.fasta file
samtools faidx asmTranstrinity.Trinity.fasta 
