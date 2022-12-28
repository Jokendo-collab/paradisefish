#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=40:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=VTRMGFF3


#Load the required modules
module load maker/3.01.03
module load augustus/3.3.3
module load busco/4.1.3
module load blast/2.13.0+
module load repeatmodeler
module load genometools
module load seqkit
module load bioawk

#======================
###paradisefish genome annotation##
#=====================
#1. Run maker annotation

cd /data/okendojo/paradisfishProject/annotation/vertebrates

#export AUGUSTUS_CONFIG_PATH=/data/okendojo/paradisfishProject/geneModels/

mpiexec -n 32 maker -base vatRMGFF3_anno_01 /home/okendojo/scripts/paradiseFish/maker/vt01_opts.ctl /home/okendojo/scripts/paradiseFish/maker/maker_bopts.ctl /home/okendojo/scripts/paradiseFish/maker/maker_exe.ctl -f 
