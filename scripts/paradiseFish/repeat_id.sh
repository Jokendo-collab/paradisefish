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
#======================
###Repeat annotation##
#=====================
cd /data/okendojo/paradisfishProject/annotation/annotate_repeats

#1. De Novo Repeat Identification
# build new RepeatModeler BLAST database
BuildDatabase -name paradisefish -engine ncbi reference-genome.fasta

# now run RepeatModeler with 32 cores (we have alot of resourcee), you may have to scale it according to your resources
RepeatModeler -pa 32 -engine ncbi -database paradisefish 2>&1 | tee 00_repeatmodeler.log

#Split the library into the elements that are known and unknown
cat reference-genome-families.fa | seqkit fx2tab | grep -v "Unknown" | seqkit tab2fx > reference-genome-families.prefix.fa.known
cat reference-genome-families.fa | seqkit fx2tab | grep "Unknown" | seqkit tab2fx > reference-genome-families.prefix.fa.unknown

#Quantify known and unknown elements

# quantify number of classified elements
grep -c ">" reference-genome-families.prefix.fa.known
# quantify number of unknown elements
grep -c ">" reference-genome-families.prefix.fa.unknown

#run repeatclasifier 
repclassifier -t 32 -d paradisefish -u reference-genome-families.prefix.fa.unknown -k reference-genome-families.prefix.fa.known -a reference-genome-families.prefix.fa.unknown -o round_1_repbase_self

repclassifier -t 32 -u round_1_repbase_self/round_1_repbase_self.unknown -k round_1_repbase_self/round_1_repbase_self.known -a round_1_repbase_self/round_1_repbase_self.known -o round-2_Self 

#create the required directories
mkdir -p logs 01_simple_out 02_tetrapoda_out 03_known_out 04_unknown_out

# round 1: annotate/mask simple repeats
RepeatMasker -pa 32 -a -e ncbi -dir 01_simple_out -noint -xsmall reference-genome.fasta 2>&1 | tee logs/01_simplemask.log

# round 1: rename outputs
rename fasta simple_mask 01_simple_out/reference-genome*
rename .masked .masked.fasta 01_simple_out/reference-genome*

# round 2: annotate/mask paradisefish elements sourced from Repbase using output from 1st round of RepeatMasker
RepeatMasker -pa 32 -a -e ncbi -dir 02_tetrapoda_out -nolow -species paradisefish 01_simple_out/reference-genome.simple_mask.masked.fasta 2>&1 | tee logs/02_tetrapodamask.log

# round 2: rename outputs
rename simple_mask.masked.fasta paradisefish_mask 02_tetrapoda_out/reference-genome*
rename .masked .masked.fasta 02_tetrapoda_out/reference-genome*

# round 3: annotate/mask known elements sourced from species-specific de novo repeat library using output froom 2nd round of RepeatMasker
RepeatMasker -pa 16 -a -e ncbi -dir 03_known_out -nolow -lib round-1_RepbaseTetrapoda-Self/round-1_RepbaseTetrapoda-Self.known \
02_tetrapoda_out/reference-genome.tetrapoda_mask.masked.fasta 2>&1 | tee logs/03_knownmask.log
# round 3: rename outputs
rename tetrapoda_mask.masked.fasta known_mask 03_known_out/reference-genome*
rename .masked .masked.fasta 03_known_out/reference-genome*

























































