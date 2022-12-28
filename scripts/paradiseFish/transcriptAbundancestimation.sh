#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=10:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Load the required modules
module load trinity
module load singularity


cd /data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files/trinityasm

fastaFile=/data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files

$TRINITY_HOME/util/align_and_estimate_abundance.pl  --transcripts ${fastaFile}/asmTranstrinity.Trinity.fasta --seqType fq --prep_reference --samples_file sample.txt --est_method salmon --output_dir abundanceEST --trinity_mode --aln_method bowtie2 --thread_count 32 
