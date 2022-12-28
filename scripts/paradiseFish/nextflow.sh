#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Load the required modules
module load nextflow
module load singularity

cd /data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files/

nextflow run nf-core/rnaseq -resume --input "/data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files/samplesheet.csv" --outdir "/data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files/countmatrix" --fasta "/data/okendojo/paradisfishProject/annotation/anno_round_2.maker.output/paradisefish.maker.transcripts.fasta" --gff "/data/okendojo/paradisfishProject/annotation/anno_round_2.maker.output/paradisefish.maker.all.gff" -profile singularity  
