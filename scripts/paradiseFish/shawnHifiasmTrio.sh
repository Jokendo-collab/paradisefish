#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javanokendo@gmail.com


#Hifiasm in trio binning mode
cd /data/okendojo/postdoc_project/paradiseFish/paternal

yak count -b37 -t 16 -o pat.yak <(cat HGLGLDSX3_19242448_S7_L001_R1_001.fastq.gz HGLGLDSX3_19242448_S7_L001_R2_001.fastq.gz) <(cat HJ2WYDSX3_19242448_S103_L004_R1_001.fastq.gz HJ2WYDSX3_19242448_S103_L004_R2_001.fastq.gz)

mv pat.yak /data/okendojo/postdoc_project/paradiseFish/assembly_results/hifiasm/trio

cd /data/okendojo/postdoc_project/paradiseFish/maternal

yak count -b37 -t 16 -o mat.yak <(cat HGLGLDSX3_19242446_S3_L001_R1_001.fastq.gz HGLGLDSX3_19242446_S3_L001_R2_001.fastq.gz) <(cat HJ2WYDSX3_19242446_S99_L004_R1_001.fastq.gz HJ2WYDSX3_19242446_S99_L004_R2_001.fastq.gz)

mv mat.yak /data/okendojo/postdoc_project/paradiseFish/assembly_results/hifiasm/trio

cd /data/okendojo/postdoc_project/paradiseFish/assembly_results/hifiasm/trio

hifiasm -o hifiTrio -t 32 -D 10.0 -c 25 -d 75 --hg-size 0.5g -1 pat.yak -2 mat.yak  /data/okendojo/postdoc_project/paradiseFish/offspring/*.fastq.gz

