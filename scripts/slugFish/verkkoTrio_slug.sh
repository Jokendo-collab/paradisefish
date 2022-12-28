#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=200g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#move to the working directory

cd /data/okendojo/slugProject/slug/meryldbs/compressed

module load verkko/1.1
module load python/3.9
module load snakemake/7.7.0
module load R/4.2.0
module load bedtools/2.30.0
module load samtools/1.9

#Run verkko
verkko -d /data/okendojo/slugProject/slug/assembly/verkkoHiFiONT --hifi /data/okendojo/slugProject/slug/PacBio/*.fq.gz --nano /data/okendojo/slugProject/slug/PacBio/*.fq.gz --slurm --hap-kmers maternal.hapmer.meryl paternal.hapmer.meryl trio
