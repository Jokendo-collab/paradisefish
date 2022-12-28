#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#check if the affected nodes are remediated
#if [ ! -f "/remediated_vf" ] ; then
 #       echo "Node $HOSTNAME has not yet been remediated for the /vf problem, sorry for the inconvenience...exiting"
  #      exit 1
#fi

#Move to the directory where the results will be written
cd /data/okendojo/slugProject/slug/assembly/hifiasm/notrio

hifiasm -o hifiasmNoTrio.asm -t 32 -D 10.0 -c 25 -d 75 --hg-size 1.9g -l1 /data/okendojo/slugProject/slug/PacBio/derLae_hifi.fq.gz 


