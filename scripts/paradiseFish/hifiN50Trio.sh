#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javanokendo@gmail.com


#Hifiasm in trio binning mode
cd /data/okendojo/paradisfishProject/assemblies/hifiasm/trio

hifiasm -o hifiTrio -t 32 -D 10.0 -c 25 -d 75 --hg-size 0.5g -1 /data/okendojo/paradisfishProject/paternal/pat.yak -2 /data/okendojo/paradisfishProject/maternal/mat.yak /data/okendojo/paradisfishProject/child/*.fastq.gz

