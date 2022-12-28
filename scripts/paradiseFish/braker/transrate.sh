#! /bin/sh

###############
##HEADER FOR BIOWULF SBATCH SUBMIT
##############

#SBATCH --job-name=transrate
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --partition=norm
#SBATCH --mail-type=FAIL,END
#SBATCH --mem=100G
#SBATCH --gres=lscratch:400
#SBATCH --time=24:00:00
#SBATCH --mail-user=javan.okendo@nih.gov

#######
## ACTIVATE mamba ENVIRONMENT
#######

#move to the dir containing bam files

cd /data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate transrate

transrate --assembly asmTranstrinity.Trinity.fasta --left Sample_10-testis_1.fastq.gz, Sample_2-blastema_1.fastq.gz, Sample_4-kidney_1.fastq.gz, Sample_6-lab_org_1.fastq.gz, Sample_8-ovaries_1.fastq.gz, Sample_1-embryonic_mix_1.fastq.gz, Sample_3-heart_1.fastq.gz, Sample_5-gill_1.fastq.gz, Sample_7-female_brain_1.fastq.gz, Sample_9-male_brain_1.fastq.gz --right Sample_10-testis_2.fastq.gz, Sample_2-blastema_2.fastq.gz, Sample_4-kidney_2.fastq.gz, Sample_6-lab_org_2.fastq.gz, Sample_8-ovaries_2.fastq.gz, Sample_1-embryonic_mix_2.fastq.gz, Sample_3-heart_2.fastq.gz, Sample_5-gill_2.fastq.gz, Sample_7-female_brain_2.fastq.gz, Sample_9-male_brain_2.fastq.gz --threads 32 


