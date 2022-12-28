#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov


# Load the module
module load jellyfish/2.3.0

cd /data/okendojo/paradisfishProject/maternal
#Count kmers using jellyfish
jellyfish count -C -m 21 -s 2000M -t 32  <(zcat HGLGLDSX3_19242446_S3_L001_R1_001.fastq.gz HGLGLDSX3_19242446_S3_L001_R2_001.fastq.gz) <(zcat HJ2WYDSX3_19242446_S99_L004_R1_001.fastq.gz HJ2WYDSX3_19242446_S99_L004_R2_001.fastq.gz) -o maternal.jf

#Export the kmer count histogram
jellyfish histo -t 32 maternal.jf > maternal.histo

cd /data/okendojo/paradisfishProject/paternal

jellyfish count -C -m 21 -s 2000M -t 32  <(zcat HGLGLDSX3_19242448_S7_L001_R1_001.fastq.gz HGLGLDSX3_19242448_S7_L001_R2_001.fastq.gz ) <(zcat HJ2WYDSX3_19242448_S103_L004_R1_001.fastq.gz HJ2WYDSX3_19242448_S103_L004_R2_001.fastq.gz) -o paternal.jf

jellyfish histo -t 32 paternal.jf > paternal.histo

cd /data/okendojo/paradisfishProject/child

#Count kmers using jellyfish
jellyfish count -C -m 21 -s 2000M -t 32  <(zcat macOpe2_F1.hifi_reads1.fastq.gz  macOpe2_F1.hifi_reads2.fastq.gz) -o child.jf

#Export the kmer count histogram
jellyfish histo -t 32 child.jf > child.histo
	


