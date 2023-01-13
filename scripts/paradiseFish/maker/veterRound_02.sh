#!/bin/bash
#SBATCH --partition=norm
#SBATCH --mem=120g
#SBATCH --ntasks=32
#SBATCH --constraint=x2650
#SBATCH --exclusive
#SBATCH --gres=lscratch:200
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javanokendo@gmail.com
#SBATCH --job-name=003_VT

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


mpiexec -n 32 maker -base maker_003 /home/okendojo/scripts/paradiseFish/maker/vt03_opts.ctl /home/okendojo/scripts/paradiseFish/maker/maker_bopts.ctl /home/okendojo/scripts/paradiseFish/maker/maker_exe.ctl -f 
