#!/bin/bash
#SBATCH --partition=norm
#SBATCH --mem=120g
#SBATCH --ntasks=32
#SBATCH --constraint=x2650
#SBATCH --exclusive
#SBATCH --gres=lscratch:200
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END

#Load the required modules
module load nextflow
module load singularity

#Activate the bbmap environment
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh
mamba activate bbmap

cd /data/okendojo/paradisfishProject/maternal

bbsplit.sh in=HGLGLDSX3_19242446_S3_L001_R1_001.fastq.gz in2=HGLGLDSX3_19242446_S3_L001_R2_001.fastq.gz ref=cleaned.fasta,macOpe2_mito.fasta basename=out_%.fastq.gz outu1=mat1.fastq.gz outu2=mat2.fastq.gz

bbsplit.sh in=HJ2WYDSX3_19242446_S99_L004_R1_001.fastq.gz in2=HJ2WYDSX3_19242446_S99_L004_R2_001.fastq.gz ref=cleaned.fasta,macOpe2_mito.fasta basename=out2_%.fastq.gz outu1=mat11.fastq.gz outu2=mat22.fastq.gz

reformat.sh in=out_cleaned.fastq.gz out1=mat_1_R1.fastq.gz out2=mat_1_R2.fastq.gz
reformat.sh in=out2_cleaned.fastq.gz out1=mat_2_R1.fastq.gz out2=mat_2_R2.fastq.gz

cd /data/okendojo/paradisfishProject/paternal

bbsplit.sh in=HGLGLDSX3_19242448_S7_L001_R1_001.fastq.gz in2=HGLGLDSX3_19242448_S7_L001_R2_001.fastq.gz ref=cleaned.fasta,macOpe2_mito.fasta basename=out_%.fastq.gz outu1=mat1.fastq.gz outu2=mat2.fastq.gz

reformat.sh in=out_cleaned.fastq.gz out1=mat_1_R1.fastq.gz out2=mat_1_R2.fastq.gz

bbsplit.sh in=HJ2WYDSX3_19242448_S103_L004_R1_001.fastq.gz in2=HJ2WYDSX3_19242448_S103_L004_R2_001.fastq.gz ref=cleaned.fasta,macOpe2_mito.fasta basename=out2_%.fastq.gz outu1=mat1.fastq.gz outu2=mat2.fastq.gz

reformat.sh in=out2_cleaned.fastq.gz out1=mat_2_R1.fastq.gz out2=mat_2_R2.fastq.gz







