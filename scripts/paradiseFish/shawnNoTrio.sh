#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javanokendo@gmail.com


#Hifiasm in trio binning mode
cd /data/okendojo/postdoc_project/offspring/shawnHifiTrio/shawnNoTrio

hifiasm -o hifiNoTrio -t 32 -D 10.0 -c 25 -d 75 --hg-size 0.5g /data/okendojo/postdoc_project/offspring/*.fastq.gz

