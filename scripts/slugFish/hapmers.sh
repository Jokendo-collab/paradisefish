#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/slugProject/slug/meryldbs/compressed

$MERQURY/trio/hapmers.sh maternal.meryl/ paternal.meryl/ child.meryl
