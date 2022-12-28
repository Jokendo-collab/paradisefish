#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javanokendo@gmail.com

cd /data/okendojo/paradisfishProject/maternal

yak count -b 37 -t 32 -o pat.yak <(cat HGLGLDSX3_19242446_S3_L001_R1_001.fastq.gz HGLGLDSX3_19242446_S3_L001_R2_001.fastq.gz) <(cat HJ2WYDSX3_19242446_S99_L004_R1_001.fastq.gz HJ2WYDSX3_19242446_S99_L004_R2_001.fastq.gz)

cd /data/okendojo/paradisfishProject/paternal

yak count -b37 -t16 -o mat.yak <(cat HGLGLDSX3_19242448_S7_L001_R1_001.fastq.gz HGLGLDSX3_19242448_S7_L001_R2_001.fastq.gz) <(cat HJ2WYDSX3_19242448_S103_L004_R1_001.fastq.gz HJ2WYDSX3_19242448_S103_L004_R2_001.fastq.gz)
