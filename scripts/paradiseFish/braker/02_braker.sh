#! /bin/sh

###############
##HEADER FOR BIOWULF SBATCH SUBMIT
##############

#SBATCH --job-name=bkr2_annot
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --partition=norm
#SBATCH --mail-type=FAIL,END
#SBATCH --mem=100G
#SBATCH --gres=lscratch:400
#SBATCH --time=240:00:00
#SBATCH --mail-user=javan.okendo@nih.gov

#######
## ACTIVATE mamba ENVIRONMENT
#######

#move to the dir containing bam files

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate BRAKER

export GENEMARK_PATH=/home/okendojo/software/geneMark/gmes_linux_64
#export AUGUSTUS_BIN_PATH=/home/okendojo/software/config

#export AUGUSTUS_BIN_PATH=/data/okendojo/conda/envs/BRAKER/bin/


########
## DEFINE FILES AND FILE LOCATIONS
########

## number of cores to use; set THREADS to a multiple of 4; should match SBATCH
## max memory to use; should match SBATCH
THREADS=32
MEM=100G



##HOME_DIR is where you will direct outputs

HOME_DIR="/data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files"

##GENOME is the source of the genome FASTA

GENOME="/data/okendojo/paradisfishProject/annotation/rmLibDB/05_full_out/soft_hard_maskedgenome/reference.soft_masked.fasta"

## Transcripts aligned to genome in BAM format

TRANSCRIPT_BAM="Sample_10-testis_Aligned.sortedByCoord.out.bam, Sample_4-kidney_Aligned.sortedByCoord.out.bam, Sample_8-ovaries_Aligned.sortedByCoord.out.bam, Sample_1-embryonic_mix_Aligned.sortedByCoord.out.bam, Sample_5-gill_Aligned.sortedByCoord.out.bam, Sample_9-male_brain_Aligned.sortedByCoord.out.bam, Sample_2-blastema_Aligned.sortedByCoord.out.bam, Sample_6-lab_org_Aligned.sortedByCoord.out.bam, Sample_3-heart_Aligned.sortedByCoord.out.bam, Sample_7-female_brain_Aligned.sortedByCoord.out.bam"

##SPECIES_NAME should be the name you want the project files to be under

SPECIES_NAME="paradisefish"
	
#############
## script commands below
#############

cd ${HOME_DIR}



## BRAKER
## Running the first round of braker with 


echo "----- beginning braker 2 at" `date`

braker.pl --cores=$THREADS --species=$SPECIES_NAME  --genome=$GENOME --bam=$TRANSCRIPT_BAM --BAMTOOLS_PATH=/data/okendojo/conda/envs/BRAKER/bin/ --softmasking --skipAllTraining 

echo "----- finished braker_2 at" `date`

