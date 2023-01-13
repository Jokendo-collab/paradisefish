#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=AGAT_VE

cd /data/okendojo/paradisfishProject/annotation/vertebrates

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate interproscan

#agat_sp_extract_sequences.pl -g round_03.all.gff -f hifiasmpriasm.fasta -p -t cds -o maker_final_fixed.faa

agat_sp_manage_functional_annotation.pl -f round_03.all.gff -b round_03.all.maker.proteins.fasta.blastp -d proteinDB/uniprot-Vertebra-2022.12.01.fasta -i iprscan/round_03.all.maker.proteins.fasta.tsv -a  --id CGTU -o iprResult2
