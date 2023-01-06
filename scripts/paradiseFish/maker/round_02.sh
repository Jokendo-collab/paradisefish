#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=02_ZF

#Load the required modules
module load maker
module load augustus
module load busco
module load blast
module load genometools
module load seqkit
module load bioawk

#======================
###paradisefish genome annotation##
#=====================
#1. Run maker annotation

cd /data/okendojo/paradisfishProject/annotation/zebrafish

mpiexec -n 32 maker -base maker_round_02 maker2_opts.ctl maker_bopts.ctl maker_exe.ctl -f 
