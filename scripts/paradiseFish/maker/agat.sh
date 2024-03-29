#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=agat

cd /data/okendojo/paradisfishProject/annotation/zebrafish/attributeAdd

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate interproscan

gtf=/data/okendojo/paradisfishProject/annotation/zebrafish/braker.gff


#agat_sp_extract_sequences.pl -g ${gtf} -f hifiasmpriasm.fasta -p -t cds --cfs --cis -o brakerCDS.fasta


#agat_convert_sp_gff2bed.pl --gff maker_round_03.homo.gff -o maker_round_03.homo.bed

agat_sp_statistics.pl  --gff maker_round_03.hom.gff -p --gs 411228032 -o zfishHomo.txt 

#agat_sp_manage_functional_annotation.pl -f maker_round_02.all.gff -b blast2.out -d uniProtedb/uniprot-8zebrafis-2022.12.01.fasta -i iprscan/maker_round_02.all.maker.proteins.fasta.tsv -id G -o agat4
