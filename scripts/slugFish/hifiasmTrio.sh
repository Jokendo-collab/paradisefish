#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov


# Trio binning assembly
cd /data/okendojo/slugProject/slug/assembly/hifiasm/trio

hifiasm -o hifiasmTrio.asm -t 32  -D 10.0 -c 25 -d 75 --hg-size 1.9g -1 pat.yak -2 mat.yak /data/okendojo/slugProject/slug/PacBio/derLae_hifi.fq.gz 

