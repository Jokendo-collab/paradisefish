#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=80g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#move to the working directory

#check if the affected nodes are remediated
if [! -f "/remediated_vf" ] ; then
        echo "Node $HOSTNAME has not yer been remediated for the /vf problem...exiting"
        exit 1
fi

#Load the modules
module load merqury/1.3

cd /data/okendojo/slugProject/slug/meryldbs/uncompressed

meryl count k=21 /data/okendojo/slugProject/slug/PacBio/*.fq.gz output child.meryl
meryl count k=21 /data/okendojo/slugProject/slug/253BVM/*.fq.gz output maternal.meryl
meryl count k=21 /data/okendojo/slugProject/slug/253AVM/*.fq.gz output paternal.meryl


