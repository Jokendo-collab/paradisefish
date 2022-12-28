#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
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
module load seqkit
module load bioawk
module load seqtk
module load datamash
cd /data/okendojo/paradisfishProject/annotation/rmLibDB

#round 1
##repclassifier -t 32 -d paradisefish -u reference-genome-families.prefix.fa.unknown -k reference-genome-families.prefix.fa.known -a reference-genome-families.prefix.fa.unknown -o round_1_classified_reps 

# round 1: annotate/mask simple repeats
##RepeatMasker -pa 32 -a -e ncbi -dir 01_simple_out -noint -xsmall reference-genome.fasta 2>&1 | tee logs/01_simplemask.log

# round 1: rename outputs
##rename fasta simple_mask 01_simple_out/reference-genome*
##rename .masked .masked.fasta 01_simple_out/reference-genome*

# round 2: annotate/mask paradisefish elements sourced from Repbase using output from 1st round of RepeatMasker
##RepeatMasker -pa 32 -a -e ncbi -dir 02_paradisefish_out -nolow -species paradisefish 01_simple_out/reference-genome.simple_mask.masked.fasta 2>&1 | tee logs/02_tetrapodamask.log

# round 2: rename outputs
##rename simple_mask.masked.fasta paradisefish_mask 02_paradisefish_out/reference-genome*
##rename .masked .masked.fasta 02_paradisefish_out/reference-genome*

# round 3: annotate/mask known elements sourced from species-specific de novo repeat library using output froom 2nd round of RepeatMasker

##RepeatMasker -pa 32 -a -e ncbi -dir 03_known_out -nolow -lib round_1_classified_reps/round_1_classified_reps.known 02_paradisefish_out/reference-genome.paradisefish_mask.masked.fasta 2>&1 | tee logs/03_knownmask.log

# round 3: rename outputs
##rename paradisefish_mask.masked.fasta known_mask 03_known_out/reference-genome*
##rename .masked .masked.fasta 03_known_out/reference-genome*

# round 4: annotate/mask unknown elements sourced from species-specific de novo repeat library using output froom 3nd round of RepeatMasker
##RepeatMasker -pa 32 -a -e ncbi -dir 04_unknown_out -nolow -lib round_1_classified_reps/round_1_classified_reps.unknown 03_known_out/reference-genome.known_mask.masked.fasta 2>&1 | tee logs/04_unknownmask.log

# round 4: rename outputs
#rename known_mask.masked.fasta unknown_mask 04_unknown_out/reference-genome*
#rename .masked .masked.fasta 04_unknown_out/reference-genome*


# resummarize repeat compositions from combined analysis of all RepeatMasker rounds
#ProcessRepeats -a -species paradisefish 05_full_out/reference-genome.full_mask.cat.gz 2>&1 | tee logs/05_fullmask.log
allLen=`seqtk comp reference-genome.fasta | datamash sum 2`; parseRM.pl -v -i 05_full_out/reference-genome.full_mask.align -p -g ${allLen} -l 50,1 2>&1 | tee logs/06_parserm.log





















































