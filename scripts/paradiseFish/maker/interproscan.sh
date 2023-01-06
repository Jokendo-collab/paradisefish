#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=Ipscan

#Activate the interproscan envs
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh
mamba activate interproscan


cd /data/okendojo/paradisfishProject/annotation/zebrafish


#interproscan.sh -appl Pfam -dp -f TSV -goterms -iprlookup -pa -t p -i maker_round_02.all.maker.proteins.fasta -d iprscan

query=/data/okendojo/paradisfishProject/annotation/zebrafish/br.fasta

interproscan.sh -appl pfam -dp -f TSV -goterms -iprlookup -pa -t p -i ${query} -o brakerProtein.iprscan 


