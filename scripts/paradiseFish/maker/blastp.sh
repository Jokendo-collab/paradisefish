#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=BlastpVe

#Load the required modules
module load blast

#======================
###paradisefish genome annotation##
#=====================
#1. Run functional annotation

cd /data/okendojo/paradisfishProject/annotation/zebrafish/attributeAdd/tempData

#prepare the uniprot database
#makeblastdb -in uniprot-8zebrafis.fasta

query=/data/okendojo/paradisfishProject/annotation/zebrafish/brakerprotein.fasta 


blastp -query ${query} -db /data/okendojo/paradisfishProject/annotation/vertebrates/proteinDB/uniprot-Vertebra-2022.12.01.fasta -evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -num_threads 24 -outfmt 6 -out blastp.out
