#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javanokendo@gmail.com

# Load the module
module load jellyfish/2.3.0



#change to the directory containing the data
cd /data/okendojo/slugProject/slug/PacBio

#run jellyfish
jellyfish count -C -m 21 -s 2000M -t 32  <(zcat derLae_hifi.fq.gz)  -o child.jf

#Export the kmer count histogram
jellyfish histo -t 32 child.jf > child.histo
