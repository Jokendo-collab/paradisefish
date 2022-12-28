#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCG --mail-user=javan.okendo@nih.gov

#Load the required modules
module load python/3.9
module load snakemake/7.7.0
module load R/4.2.0
module load bedtools/2.30.0
module load samtools/1.9
module load winnowmap/2.03

#change to the directory where the mapping results will be located
cd /data/okendojo/paradisfishProject/genomeAlignments

#Mapping pacbio-hifi reads on hifiasm assembly
winnowmap -W /data/okendojo/paradisfishProject/meryldbs/secuncompressed -ax map-pb /data/okendojo/paradisfishProject/assemblies/hifiasm/notrio/hifiasmpriasm.fasta /data/okendojo/paradisfishProject/child/macOpe2_F1.hifi_reads1.fastq.gz > hifiasmNoTrioRead1.sam

winnowmap -W /data/okendojo/paradisfishProject/meryldbs/secuncompressed -ax map-pb /data/okendojo/paradisfishProject/assemblies/hifiasm/notrio/hifiasmpriasm.fasta /data/okendojo/paradisfishProject/child/macOpe2_F1.hifi_reads2.fastq.gz > hifiasmNoTrioRead2.sam

module load samtools/1.9
#====================================================================
samtools view -S -b hifiasmNoTrioRead1.sam > hifiasmNoTrioRead1.bam

samtools sort hifiasmNoTrioRead1.bam -o hifiasmNoTrioRead1.sorted.bam

samtools index hifiasmNoTrioRead1.sorted.bam

#=================================================================
samtools view -S -b hifiasmNoTrioRead2.sam > hifiasmNoTrioRead2.bam

samtools sort hifiasmNoTrioRead2.bam -o hifiasmNoTrioRead2.sorted.bam

samtools index hifiasmNoTrioRead2.sorted.bam


