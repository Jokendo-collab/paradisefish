#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=80g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#move to the working directory

#Load the modules
module load merqury/1.3

cd /data/okendojo/paradisfishProject/meryldbs/uncompressed

meryl count k=21 /data/okendojo/paradisfishProject/child/*.fastq.gz output child.meryl
meryl count k=21 /data/okendojo/paradisfishProject/maternal/*.fastq.gz output maternal.meryl
meryl count k=21 /data/okendojo/paradisfishProject/paternal/*.fastq.gz output paternal.meryl


