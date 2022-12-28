#!/bin/bash
#SBATCH --partition=norm
#SBATCH --mem=120g
#SBATCH --ntasks=32
#SBATCH --constraint=x2650
#SBATCH --exclusive
#SBATCH --gres=lscratch:200
#SBATCH --time=24:00:00
#SBATCH --mail-type=FAIL,END

##==============================================
##Load the star module
##==============================================
module load STAR

#move to the directory containing the raw files

cd /data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files
#loop over the base files and run the star on the paired-end reads.


echo "-----the analysis is beginning" `date`
# define variables
index=/data/okendojo/paradisfishProject/bamFiles/index
# get our data files
FQ_DIR=/data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files


for base in Sample_10-testis Sample_1-embryonic_mix Sample_2-blastema Sample_3-heart Sample_4-kidney Sample_5-gill Sample_6-lab_org Sample_7-female_brain Sample_8-ovaries Sample_9-male_brain
do
  echo $base

  # define R1 fastq filename
  fq1=$FQ_DIR/${base}_1.fastq.gz

 # define R2 fastq filename
  fq2=$FQ_DIR/${base}_2.fastq.gz

 # align with STAR
STAR --runThreadN 32 --genomeDir $index --readFilesIn $fq1 $fq2 --outSAMtype BAM   SortedByCoordinate --quantMode GeneCounts --readFilesCommand zcat --outFileNamePrefix $base"_"

done

echo "done! on" `date`


