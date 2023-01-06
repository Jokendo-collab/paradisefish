#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javanokendo@gmail.com
#SBATCH --job-name=chatGPT

module load python

cd /data/okendojo/paradisfishProject/annotation/zebrafish

./chatGPT.py
