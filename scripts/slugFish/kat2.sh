#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=200g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/slugProject/slug/redownload/trimmed_mat

module load kat/2.4.2


kat comp -t 32 -p png -m 35 -o combinedParents '/data/okendojo/slugProject/slug/253BVM/mat_slug253B_trimmed_R?.fq.gz /data/okendojo/slugProject/slug/253AVM/pat_slug253A_trimmed_R?.fq.gz' /data/okendojo/slugProject/slug/assembly/hifiasm/notrio/hifipriasm.fasta
