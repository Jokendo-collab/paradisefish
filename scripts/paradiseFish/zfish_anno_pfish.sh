#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=170:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Load the required modules
module load maker
module load augustus
module load busco
module load snap
module load bedtools
module load repeatmodeler
#module load repeatmasker
module load genometools
module load seqkit
module load bioawk

#======================
###paradisefish genome annotation##
#=====================
#1. Run maker annotation

cd /data/okendojo/paradisfishProject/annotation/

mpiexec -n 32 maker -base zfish_ann_pfish_01 zebrafish_opts.ctl maker_bopts.ctl maker_exe.ctl -f 
