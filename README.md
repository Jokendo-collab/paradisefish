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
