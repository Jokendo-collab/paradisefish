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

outdir=/data/okendojo/zebrafish/assembly_results/quastResults
refGenome=/data/okendojo/zebrafish/refGenome/GRCz11_genomic.fasta
gff=/data/okendojo/zebrafish/refGenome/GRCz11_genomic.gff
feature=/data/okendojo/zebrafish/refGenome/GCF_000002035.6_GRCz11_genomic.gtf

#vk=/data/okendojo/zebrafish/assembly_results/Verkko/assembly.fasta

quast.py -o ${outdir} -r ${refGenome} --debug --fragmented -L -t 32 --eukaryote  --circos --est-ref-size 1456394440  --plots-format png /data/okendojo/zebrafish/assembly_results/Verkko/assembly.fasta /data/okendojo/zebrafish/assembly_results/serge/beta_asm_notrio/assembly.fasta /data/okendojo/zebrafish/assembly_results/Hifiasm/hifiasmpasm.fasta

