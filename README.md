# Genome assembly process
- [x] Run jellyfish on the raw illumina reads to assess the genome features such as predicted genome size, heterozygosity/homozygosity, PCR duplication rates
- [x] Run the assemblers which for our case we used hifiasm and verkko to do the trio binning assembly.
- [x] The performance of the above assemblers was compared in trio and none trio mode. The results were then compared to findout which assembler works best on our data
- [x] Assess the assembly quality using Merquiry and T2T polishing: Doing QV estimates on trio and non-trio mode
- [x] Align the long reads to the assembled genomes using winnowmap using the recommended settings
- [ ] Run BUSCO on the data to assess the assembly completeness
- [x] Assess the assembly correctness using IGV

# Genomescope result and interpratation
![geneomeScope](https://github.com/Jokendo-collab/paradisefishGenomeAssembly/blob/main/paternal.png)
> Estimated genome size ~**0.5GB** GB. There are arounf 11% repetitive content in this genome. This means that the genome is easy to assemble and the trio binning could not work properly since the genome is more homozugous. 

# Genome annotation
- [x] Transcriptome aseembly using Trinity pipeline 😂
- [x] We used MAKER and BRAKER 😎
# Using `MAKER` for genome annotatio
You will need the following tools:
  - `RepeatModeler` and `RepeatMasker` with all dependencies (I used NCBI BLAST) and RepBase (version used was 20150807).
  - `MAKER MPI` version 2.31.8 (though any other version 2 releases should be okay).
  - `BUSCO`
  - `AUGUSTUS`
  - `SNAP`
  - `BEDtools`
 ### Required files
 - [x] `Hifiasm` assembled genome. In our case we used the primary assembly from the hifiasm assembler and it must be be in `fasta` format
 - [x] `Trinity` transcriptome assembly in `fasta`
 - [x] Full proteome database of the assembled organism downloaded from either  NCBI or uniprot in `fasta`
 
 # Procedure
#### 1. **_De nove_** repeat identification. It is important to identify repeats de novo from your reference genome using RepeatModeler
```bash
BuildDatabase -name pfish -engine ncbi hifiasmNoTrio.fasta
RepeatModeler -pa 32 -engine ncbi -database pfish 2>&1 | tee repeatmodeler.log
```
#### 2. Initial MAKER analysis. 


