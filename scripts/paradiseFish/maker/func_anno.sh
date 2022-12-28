#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=func_ann

#Load the required modules
module load maker
module load augustus
module load busco
module load blast
module load genometools
module load seqkit
module load bioawk
module load interproscan
#======================
###paradisefish genome annotation##
#=====================
#1. Run functional annotation

cd /data/okendojo/paradisfishProject/annotation/zebrafish

#makerProtein=/data/okendojo/paradisfishProject/annotation/zebrafish/round_02.all.maker.proteins.fasta
#zebrafishUniprot=/data/okendojo/paradisfishProject/annotation/proteindbs/uniprot-8zebrafis-2022.12.01.fasta

#makeblastdb -in round_02.all.maker.proteins.fasta -dbtype prot

blastp -query round_02.all.maker.proteins.fasta -db uniProtedb/uniprot-8zebrafis-2022.12.01.fasta -evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -outfmt 6 -out round_02.all.maker.proteins.fasta.blastp

#Running interproscan on HPC
interproscan -appl pfam -goterms -iprlookup -pa -t p round_02.all.maker.proteins.fasta test 500

#interproscan -appl pfam  -f TSV -goterms -iprlookup -pa -t p -i round_02.all.maker.proteins.fasta -o round_02.all.maker.proteins.fasta.iprscan
