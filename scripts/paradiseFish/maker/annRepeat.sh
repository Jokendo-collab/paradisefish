#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=36:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=repeatAnno

cd /data/okendojo/paradisfishProject/annotation/zebrafish/repAnn

RepeatMasker -pa 32 -species paradisefish -e ncbi -dir macOpe2_mask ../hifiasmpriasm.fasta

