#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=buscoTrain

#Activate busco environment
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate busco

cd /data/okendojo/paradisfishProject/annotation/zebrafish

mkdir results

busco -i all.maker.transcripts1000.fasta -o zfishHomology -m genome --long --augustus_parameters='--progress=true'  --augustus_species paradise_fish --auto-lineage-euk -f --cpu 32 --augustus --out_path results
