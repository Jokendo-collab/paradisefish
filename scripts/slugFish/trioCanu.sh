#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#move to the working directory
cd /data/okendojo/postdoc_project/slugFishProject/p_fishMerylDBs/compressed

#Load the right module
module load canu/2.0

canu -d asm -p canuTrio genomeSize='1.9g' useGrid=true -haplotypeMAT /data/okendojo/postdoc_project/slugFishProject/maternal/*.fq.gz -haplotypePAT /data/okendojo/postdoc_project/slugFishProject/paternal/*.fq.gz -pacbio-hifi /data/okendojo/postdoc_project/slugFishProject/offspring/*.fq.gz  
