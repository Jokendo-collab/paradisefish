# Genome assembly process
- [x] Run jellyfish on the raw illumina reads to assess the genome features such as predicted genome size, heterozygosity/homozygosity, PCR duplication rates
- [x] Run the assemblers which for our case we used hifiasm and verkko to do the trio binning assembly.
- [x] The performance of the above assemblers was compared in trio and none trio mode. The results were then compared to findout which assembler works best on our data
- [x] Assess the assembly quality using Merquiry and T2T polishing: Doing QV estimates on trio and non-trio mode
- [x] Align the long reads to the assembled genomes using winnowmap using the recommended settings
- [ ] Run BUSCO on the data to assess the assembly completeness
- [x] Assess the assembly correctness using IGV

# Genomescope result and interpratation
![geneomeScope](https://github.com/Jokendo-collab/GenomeAssembly_1/blob/main/transformed_linear_plot.png)
> First, I notice is that the genome size for these two are being predicted to be around 1.5GB which is a higher than I was expecting since I was expecting **0.5GB** GB. Second, I notice that there are around 62% unique 21-mers suggesting this genome has around 38% repetitive content. This means the genome could be challenging to assemble with short reads. **_the heterozygosity of the white abalone is much lower than that of black abalone. This also makes sense. The white abalone samples were acquired from a white abalone farm, where as the black abalone were obtained from the wild._**
