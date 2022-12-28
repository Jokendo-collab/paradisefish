#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov


#Activate busco environment
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate busco

cd /data/okendojo/paradisfishProject/sergeData/hap1

mkdir results

busco -i /data/okendojo/paradisfishProject/sergeData/assembly.haplotype1andunassigned.fasta -o haplotype_1 -m genome --long --tar --augustus_species paradise_fish --auto-lineage-euk -f --cpu 32 --augustus --out_path results

cd /data/okendojo/paradisfishProject/sergeData/hap2

mkdir results

busco -i /data/okendojo/paradisfishProject/sergeData/assembly.haplotype2andunassigned.fasta -o haplotype_2 -m genome --long --tar --auto-lineage-euk -f --cpu 32 --augustus --augustus_species paradise_fish  --out_path results


