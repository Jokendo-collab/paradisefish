#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=zfishBlastp

#Load the required modules
module load blast

#======================
###paradisefish genome annotation##
#=====================
#1. Run functional annotation

cd /data/okendojo/paradisfishProject/annotation/zebrafish

#prepare the uniprot database
#makeblastdb -in uniprot-8zebrafis-2022.12.01.fasta -dbtype prot

#blastp -query maker_round_02.all.maker.proteins.fasta -db uniProtedb/uniprot-8zebrafis-2022.12.01.fasta  -show_gis -num_threads 16 -evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -outfmt 6 -out blast2.out 
 
#==========Second try========
#blastp -db uniProtedb/uniprot-8zebrafis-2022.12.01.fasta -query maker_round_02.all.maker.proteins.fasta -out blast2.out  -evalue  .000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true  -show_gis  -lcase_masking -max_hsps 1

query=/data/okendojo/paradisfishProject/annotation/zebrafish/cds.fasta

blastp -query ${query} -db uniProtedb/uniprot-8zebrafis-2022.12.01.fasta -evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -outfmt 6 -out brakerProtein.blastp

