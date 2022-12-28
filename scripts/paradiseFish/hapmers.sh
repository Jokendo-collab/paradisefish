#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=24g
#SBATCH --ntasks-per-core=1
#SBATCH --time=02:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/paradisfishProject/meryldbs/nomitodna

$MERQURY/trio/hapmers.sh maternal.meryl paternal.meryl child.meryl
