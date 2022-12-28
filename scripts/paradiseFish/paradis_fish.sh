#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00



# Trio binning assembly
# count k-mers from maternal and paternal reads 

cd /data/okendojo/postdoc_project/paternal #move to the directory containing paternal reads

yak count -b37 -t16 -o pat.yak <(cat HGLGLDSX3_19242448_S7_L001_R1_001.fastq.gz HGLGLDSX3_19242448_S7_L001_R2_001.fastq.gz) <(cat HJ2WYDSX3_19242448_S103_L004_R1_001.fastq.gz HJ2WYDSX3_19242448_S103_L004_R2_001.fastq.gz)

cp pat.yak /data/okendojo/postdoc_project/offspring

cd /data/okendojo/postdoc_project/maternal #move the the directory containing maternal reads
yak count -b37 -t16 -o mat.yak <(cat HGLGLDSX3_19242446_S3_L001_R1_001.fastq.gz HGLGLDSX3_19242446_S3_L001_R2_001.fastq.gz) <(cat HJ2WYDSX3_19242446_S99_L004_R1_001.fastq.gz HJ2WYDSX3_19242446_S99_L004_R2_001.fastq.gz)

cp mat.yak /data/okendojo/postdoc_project/offspring #move yaf file to the analysis folder

cd /data/okendojo/postdoc_project/offspring

hifiasm -o paradise.asm -t32 -1 pat.yak -2 mat.yak macOpe2_F1.hifi_reads1.fastq.gz  macOpe2_F1.hifi_reads2.fastq.gz


