#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=180g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/postdoc_project/paradiseFishRNA/transcriptome_files/qc_results

# Load the module
module load  spades/3.15.5

gzip -c merged.fq.gz > m.fq.gz

rnaspades.py -o rnaSpade -m 180 -k 30 -t 32 --merged /data/okendojo/postdoc_project/paradiseFishRNA/transcriptome_files/qc_results/m.fq.gz


