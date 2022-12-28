#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Load the required modules
module load maker/3.01.03

## don't load augustus. busco packages its own augustus
## busco config files are not always compatible across versions !
# maker loads busco/3.0.2 and the module creates a 3.0.2 compatible
# config file in ~/busco.config. Let's manually create the right file
# and point an environment variable to it
# also - busco packages it's own augustus so get the right config
# for that as well. Busco 4.1.3 includes augustus 3.3.3
# so we'll want to match that with the augustus on the outside
module load augustus/3.3.3
#mkdir -p config
cp /usr/local/apps/busco/4.1.3/share/config.ini.v4.1.3 config/busco.config-4.1.3
#cp -r /usr/local/apps/busco/4.1.3/share/augustus_config config/augustus-busco-4.1.3
#export BUSCO_CONFIG_FILE=$PWD/config/busco.config-4.1.3
#export AUGUSTUS_CONFIG_PATH=$PWD/config/augustus-busco-4.1.3

module load busco/4.1.3
module load repeatmodeler
module load genometools
module load seqkit
module load bioawk
module load blast/2.13.0+

# maker needs this for repeatmasker
#export REPEATMASKER_LIB_DIR=/usr/local/apps/repeatmasker/4.1.3-p1/Libraries

#======================
###paradisefish genome annotation##
#=====================
#1. Run maker annotation

cd /data/okendojo/paradisfishProject/annotation/zebrafish

mpiexec -n $SLURM_NTASKS maker  -base zfAnnotation_01 maker_opts.ctl maker_bopts.ctl maker_exe.ctl -f 
