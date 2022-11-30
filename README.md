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
# classifying unknowns (-u): run with 3 threads/cores (-t) and using only the known elements (-k) from the 
# same reference genome; append newly identified elements to the existing known element library (-a) and 
# write results to an output directory (-o). No Repbase classification is used here.
repclassifier -t 3 -u round-1_RepbaseTetrapoda-Self/round-1_RepbaseTetrapoda-Self.unknown \
-k round-1_RepbaseTetrapoda-Self/round-1_RepbaseTetrapoda-Self.known \
-a round-1_RepbaseTetrapoda-Self/round-1_RepbaseTetrapoda-Self.known -o round-2_Self
```
