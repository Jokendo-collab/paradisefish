#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Load the required modules
module load maker
module load augustus
module load busco
module load snap
module load bedtools
module load repeatmodeler
module load repeatmasker
module load genometools
module load funannotate
module load seqkit
module load bioawk

cd /data/okendojo/paradisfishProject/annotation/repeatdb

# round 2: annotate/mask Tetrapoda elements sourced from Repbase using output from 1st round of RepeatMasker
##RepeatMasker -pa 32 -a -e ncbi -dir 02_tetrapoda_out -nolow -species paradisefish 01_simple_out/reference-genome.simple_mask.masked.fasta 2>&1 | tee logs/02_tetrapodamask.log

# round 2: rename outputs
##rename simple_mask.masked.fasta tetrapoda_mask 02_tetrapoda_out/reference-genome*
##rename .masked .masked.fasta 02_tetrapoda_out/reference-genome*

# round 3: annotate/mask known elements sourced from species-specific de novo repeat library using output froom 2nd round of RepeatMasker
##RepeatMasker -pa 32 -a -e ncbi -dir 03_known_out -nolow -lib temp/temp.known 02_tetrapoda_out/reference-genome.tetrapoda_mask.masked.fasta 2>&1 | tee logs/03_knownmask.log

# round 3: rename outputs
##rename tetrapoda_mask.masked.fasta known_mask 03_known_out/reference-genome*
##rename .masked .masked.fasta 03_known_out/reference-genome*

# round 4: annotate/mask unknown elements sourced from species-specific de novo repeat library using output froom 3nd round of RepeatMasker
RepeatMasker -pa 32 -a -e ncbi -dir 04_unknown_out -nolow -lib temp/temp.unknown 03_known_out/reference-genome.known_mask.masked.fasta 2>&1 | tee logs/04_unknownmask.log

# round 4: rename outputs
rename known_mask.masked.fasta unknown_mask 04_unknown_out/reference-genome*
rename .masked .masked.fasta 04_unknown_out/reference-genome* 
