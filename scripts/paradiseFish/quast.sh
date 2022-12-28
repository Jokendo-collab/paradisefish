#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=36:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=quast

#Activate mamba environment
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate QUAST

outdir=/data/okendojo/paradisfishProject/sergeData/quastRes
refGenome=/data/okendojo/paradisfishProject/closeRtveGeno/Betta_splendens.fBetSpl5.2.dna.toplevel.fa


quast.py -o ${outdir}  -L -t 32 --eukaryote  --est-ref-size 411228032  --plots-format png /data/okendojo/paradisfishProject/sergeData/HifiasmPriasm/hifiasmpriasm.fasta /data/okendojo/paradisfishProject/sergeData/VerkkoPriasm/assembly.fasta /data/okendojo/paradisfishProject/sergeData/VerkkoHap1/assembly.haplotype1andunassigned.fasta /data/okendojo/paradisfishProject/sergeData/VerkkoHap2/assembly.haplotype2andunassigned.fasta  

