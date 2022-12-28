#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=64g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=jellyfish

# Load the module
module load jellyfish/2.3.0

cd /data/okendojo/zebrafish/hifi

#Count kmers using jellyfish
jellyfish count -C -m 21 -s 2000M -t 32  <(zcat m54313U_220817_024630.hifi_reads.fastq.gz)  -o hifi.jf

#Export the kmer count histogram
jellyfish histo -t 32 hifi.jf > hifi.histo
	


