#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=72:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov


#Load the module
cd /data/okendojo/slugProject/slug/assembly/buscoresults/hifiasm/hap1

mkdir results

module load busco/5.0.0

busco -i /data/okendojo/slugProject/slug/assembly/combinedasms/haplotype1.fasta -o haplotype1 -m genome --auto-lineage-euk -f --cpu 32 --out_path results

cd /data/okendojo/slugProject/slug/assembly/buscoresults/hifiasm/hap2
mkdir results

busco -i /data/okendojo/slugProject/slug/assembly/combinedasms/haplotype2.fasta -o haplotype2 -m genome --auto-lineage-euk -f --cpu 32 --out_path results


