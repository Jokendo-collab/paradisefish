#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javanokendo@gmail.com

cd /data/okendojo/slugProject/slug/253BVM

yak count -b 37 -t 32 -o mat.yak <(cat mat_slug253B_trimmed_R1.fq.gz  mat_slug253B_trimmed_R2.fq.gz)

cd /data/okendojo/slugProject/slug/253AVM

yak count -b 37 -t 16 -o pat.yak <(cat pat_slug253A_trimmed_R1.fq.gz  pat_slug253A_trimmed_R2.fq.gz)
