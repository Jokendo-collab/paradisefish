#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=36:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=repeatID


#Load the required modules
module load maker
module load augustus
module load busco
module load snap
module load bedtools
module load repeatmodeler
#module load repeatmasker
module load genometools
module load seqkit

cd /data/okendojo/paradisfishProject/annotation/zebrafish

#1. De Novo Repeat Identification
# build new RepeatModeler BLAST database
BuildDatabase -name paradisefish -engine ncbi hifiasmpriasm.fasta

# now run RepeatModeler with 32 cores (we have alot of resourcee), you may have to scale it according to your resources
RepeatModeler -pa 32 -engine ncbi -database paradisefish 2>&1 | tee 00_repeatmodeler.log

