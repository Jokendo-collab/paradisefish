# Genome assembly
1. Genome features assessments using jellyfish
2. Quality assessement of the reeads using fastqc
3. Assembly using hifiasm in non-trio mode because the organism is highly inbred
4. Assembly quality assessment  using Mequiry and KAT


# Genome Annotation using MAKER
A detailed genome repeat annotation can be found [here](https://darencard.net/blog/2022-07-09-genome-repeat-annotation/) 

# Simplified procedure
1. Identify repeats de novo from your reference genome using `RepeatModeler` using the following command. This may take sometime to run and patience is highly advised 🥳.
```bash
# build new RepeatModeler BLAST database
BuildDatabase -name paradisefish -engine ncbi reference-genome.fasta
# now run RepeatModeler with 32 cores (we have alot of resourcee), you may have to scale it according to your resources
RepeatModeler -pa 32 -engine ncbi -database paradisefish 2>&1 | tee 00_repeatmodeler.log
```
2. split my library into elements that were successfully classified and those that remain as unclassified or unknown elements. 
```bash
#Split the library into the elements that are known and unknown
cat reference-genome-families.fa | seqkit fx2tab | grep -v "Unknown" | seqkit tab2fx > reference-genome-families.prefix.fa.known
cat reference-genome-families.fa | seqkit fx2tab | grep "Unknown" | seqkit tab2fx > reference-genome-families.prefix.fa.unknown
```
3. Quantify the of ok known and unknown repeats
```bash
# quantify number of classified elements
grep -c ">" reference-genome-families.prefix.fa.known
  =494
# quantify number of unknown elements
grep -c ">" reference-genome-families.prefix.fa.unknown
  =813
```
4. Reclasify the unkown repeats using `repclassifier` from the [GenomeAnnatation](https://github.com/darencard/GenomeAnnotation). I followed the two paths to identify and annotate simple and complex repears using [tutorial1](https://darencard.net/blog/2022-07-09-genome-repeat-annotation/) and [tutorial2](https://darencard.net/blog/2017-05-16-maker-genome-annotation/).

```bash
**Round 1**
# classifying unknowns (-u): run with 3 threads/cores (-t) and using the Tetrapoda elements (-d) from Repbase 
# and known elements (-k) from the same reference genome; append newly identified elements to the existing known 
# element library (-a) and write results to an output directory (-o)
repclassifier -t 3 -d paradisefish -u reference-genome-families.prefix.fa.unknown -k reference-genome-families.prefix.fa.known -a reference-genome families.prefix.fa.unknown -o round_1_classified_reps
```

```bash
**Round 2** 
# classifying unknowns (-u): run with 3 threads/cores (-t) and using only the known elements (-k) from the 
# same reference genome; append newly identified elements to the existing known element library (-a) and 
# write results to an output directory (-o). No Repbase classification is used here.
repclassifier -t 3 -u round_1_classified_reps/round_1_classified_reps.unknown -k round_1_classified_reps/round_1_classified_reps.known \
-a round_1_classified_reps/round_1_classified_reps.known -o round-2_Self
```
It is recommended that you separate the known and unknown repeats and annotate them separately

#Full Repeat Annotation and Masking

## create the directories
`mkdir -p logs 01_simple_out 02_tetrapoda_out 03_known_out 04_unknown_out`

```bash
# round 1: annotate/mask simple repeats
RepeatMasker -pa 32 -a -e ncbi -dir 01_simple_out -noint -xsmall reference-genome.fasta 2>&1 | tee logs/01_simplemask.log

# round 1: rename outputs
rename fasta simple_mask 01_simple_out/reference-genome*
rename .masked .masked.fasta 01_simple_out/reference-genome*
```

```bash
# round 2: annotate/mask Tetrapoda elements sourced from Repbase using output from 1st round of RepeatMasker
RepeatMasker -pa 16 -a -e ncbi -dir 02_tetrapoda_out -nolow  -species tetrapoda 01_simple_out/reference-genome.simple_mask.masked.fasta 2>&1 | tee logs/02_tetrapodamask.log

# round 2: rename outputs
rename simple_mask.masked.fasta tetrapoda_mask 02_tetrapoda_out/reference-genome*
rename .masked .masked.fasta 02_tetrapoda_out/reference-genome*

# round 3: annotate/mask known elements sourced from species-specific de novo repeat library using output froom 2nd round of RepeatMasker
RepeatMasker -pa 16 -a -e ncbi -dir 03_known_out -nolow  -lib round-1_RepbaseTetrapoda-Self/round-1_RepbaseTetrapoda-Self.known \
02_tetrapoda_out/reference-genome.tetrapoda_mask.masked.fasta 2>&1 | tee logs/03_knownmask.log

# round 3: rename outputs
rename tetrapoda_mask.masked.fasta known_mask 03_known_out/reference-genome*
rename .masked .masked.fasta 03_known_out/reference-genome*

# round 4: annotate/mask unknown elements sourced from species-specific de novo repeat library using output froom 3nd round of RepeatMasker
RepeatMasker -pa 16 -a -e ncbi -dir 04_unknown_out -nolow -lib round-1_RepbaseTetrapoda-Self/round-1_RepbaseTetrapoda-Self.unknown \
03_known_out/reference-genome.known_mask.masked.fasta 2>&1 | tee logs/04_unknownmask.log

# round 4: rename outputs
rename known_mask.masked.fasta unknown_mask 04_unknown_out/reference-genome*
rename .masked .masked.fasta 04_unknown_out/reference-genome*
```

```bash
# create directory for full results
mkdir -p 05_full_out

# combine full RepeatMasker result files - .cat.gz
cat 01_simple_out/reference-genome.simple_mask.cat.gz 02_tetrapoda_out/reference-genome.tetrapoda_mask.cat.gz 03_known_out/reference-genome.known_mask.cat.gz 04_unknown_out/reference-genome.unknown_mask.cat.gz > 05_full_out/reference-genome.full_mask.cat.gz

# combine RepeatMasker tabular files for all repeats - .out
cat 01_simple_out/reference-genome.simple_mask.out <(cat 02_tetrapoda_out/reference-genome.tetrapoda_mask.out | tail -n +4) <(cat 03_known_out/reference-genome.known_mask.out | tail -n +4) <(cat 04_unknown_out/reference-genome.unknown_mask.out | tail -n +4) > 05_full_out/reference-genome.full_mask.out

# copy RepeatMasker tabular files for simple repeats - .out
cat 01_simple_out/reference-genome.simple_mask.out > 05_full_out/reference-genome.simple_mask.out

# combine RepeatMasker tabular files for complex, interspersed repeats - .out
cat 02_tetrapoda_out/reference-genome.tetrapoda_mask.out <(cat 03_known_out/reference-genome.known_mask.out | tail -n +4) <(cat 04_unknown_out/reference-genome.unknown_mask.out | tail -n +4) > 05_full_out/reference-genome.complex_mask.out

# combine RepeatMasker repeat alignments for all repeats - .align
cat 01_simple_outreference-genome.simple_mask.align 02_tetrapoda_out/reference-genome.tetrapoda_mask.align 03_known_out/reference-genome.known_mask.align 04_unknown_out/reference-genome.unknown_mask.align > 05_full_out/reference-genome.full_mask.align
```

```bash
# calculate the length of the genome sequence in the FASTA
allLen=`seqtk comp reference-genome.fasta | datamash sum 2`; 
# calculate the length of the N sequence in the FASTA
nLen=`seqtk comp reference-genome.fasta | datamash sum 9`; 
# tabulate repeats per subfamily with total bp and proportion of genome masked
cat 05_full_out/reference-genome.full_mask.out | tail -n +4 | awk -v OFS="\t" '{ print $6, $7, $11 }' | 
awk -F '[\t/]' -v OFS="\t" '{ if (NF == 3) print $3, "NA", $2 - $1 +1; else print $3, $4, $2 - $1 +1 }' | 
datamash -sg 1,2,3 sum 4 | grep -v "\?" | 
awk -v OFS="\t" -v genomeLen="${allLen}" '{ print $0, $4 / genomeLen }' > 05_full_out/reference-genome.full_mask.tabulate
```

```bash
# use Daren's custom script to convert .out to .gff3 for all repeats, simple repeats only, and complex repeats only
rmOutToGFF3custom -o 05_full_out/reference-genome.full_mask.out > 05_full_out/reference-genome.full_mask.gff3
rmOutToGFF3custom -o 05_full_out/reference-genome.simple_mask.out > 05_full_out/reference-genome.simple_mask.gff3
rmOutToGFF3custom -o 05_full_out/reference-genome.complex_mask.out > 05_full_out/reference-genome.complex_mask.gff3
```

```bash
# create masked genome FASTA files
# create simple repeat soft-masked genome
bedtools maskfasta -soft -fi reference-genome.fasta -bed 05_full_out/reference-genome.simple_mask.gff3 -fo 05_full_out/reference-genome.fasta.simple_mask.soft.fasta
# create complex repeat hard-masked genome
bedtools maskfasta -fi 05_full_out/reference-genome.simple_mask.soft.fasta -bed 05_full_out/reference-genome.complex_mask.gff3 -fo 05_full_out/reference-genome.simple_mask.soft.complex_mask.hard.fasta
```

```bash
# reformat to work with MAKER
cat reference-genome.full_mask.gff3 | perl -ane '$id; if(!/^\#/){@F = split(/\t/, $_); chomp $F[-1];$id++; $F[-1] .= "\;ID=$id"; $_ = join("\t", @F)."\n"} print $_' > reference-genome.full_mask.reformat.gff3
```
Identify the ancestral repeat element proliferation by using variation across the elements in the repeat alignments to date the relative timing

```bash
allLen=`seqtk comp reference-genome.fasta | datamash sum 2`;
parseRM.pl -v -i 05_full_out/reference-genome.full_mask.align -p -g ${allLen} -l 50,1 2>&1 | tee logs/06_parserm.log
```

# Training Gene Prediction Software (SNAP)
SNAP is pretty quick and easy to train. Issuing the following commands will perform the training. It is best to put some thought into what kind of gene models you use from MAKER. In this case, we use models with an AED of 0.25 or better and a length of 50 or more amino acids, which helps get rid of junky models.

```bash
mkdir snap
mkdir snap/round1
cd snap/round1
# export 'confident' gene models from MAKER and rename to something meaningful
maker2zff -x 0.25 -l 50 -d ../../Bcon_rnd1.maker.output/Bcon_rnd1_master_datastore_index.log
rename 's/genome/Bcon_rnd1.zff.length50_aed0.25/g' *
# gather some stats and validate
fathom Bcon_rnd1.zff.length50_aed0.25.ann Bcon_rnd1.zff.length50_aed0.25.dna -gene-stats > gene-stats.log 2>&1
fathom Bcon_rnd1.zff.length50_aed0.25.ann Bcon_rnd1.zff.length50_aed0.25.dna -validate > validate.log 2>&1
# collect the training sequences and annotations, plus 1000 surrounding bp for training
fathom Bcon_rnd1.zff.length50_aed0.25.ann Bcon_rnd1.zff.length50_aed0.25.dna -categorize 1000 > categorize.log 2>&1
fathom uni.ann uni.dna -export 1000 -plus > uni-plus.log 2>&1
# create the training parameters
mkdir params
cd params
forge ../export.ann ../export.dna > ../forge.log 2>&1
cd ..
# assembly the HMM
hmm-assembler.pl Bcon_rnd1.zff.length50_aed0.25 params > Bcon_rnd1.zff.length50_aed0.25.hmm

```





