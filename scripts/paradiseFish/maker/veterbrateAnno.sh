#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=VT_round_03


#Load the required modules
module load maker
module load augustus
module load blast
module load genometools
module load seqkit
module load bioawk

#======================
###paradisefish genome annotation##
#=====================
#1. Run maker annotation

cd /data/okendojo/paradisfishProject/annotation/vertebrates


mpiexec -n 32 maker -base round_03 /home/okendojo/scripts/paradiseFish/maker/vt02_opts.ctl /home/okendojo/scripts/paradiseFish/maker/maker_bopts.ctl /home/okendojo/scripts/paradiseFish/maker/maker_exe.ctl -f 
