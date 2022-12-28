#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/paradisfishProject/assemblies/quastresults

module load quast

#quast.py -o res/ -l "hifiasmHap1, hifiasmHap2, hifiasmpriasm, verkkoprisam" haplotype1.fasta  haplotype2.fasta hifiNoTriopriasm.fasta verkkoNoTrioassembly.fasta --k-mer-stats  --plots-format png -t 32 --circos  --est-ref-size 1274001410

quast.py -o results/ -l "verkkopriasm, hifipriasm, verkko_hap1, verkko_hap2, hifi_hap1, hifi_hap2" assembly.fasta hifiasmpriasm.fasta assembly.haplotype1.fasta assembly.haplotype2.fasta hap1.fasta hap2.fasta --plots-format png --est-ref-size 409220091
