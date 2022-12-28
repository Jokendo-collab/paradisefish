#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=200g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/paradisfishProject/assemblies/verkko

module load kat/2.4.2

kat comp -t 32 -p png -h -o verkkopasm '/data/okendojo/paradisfishProject/child/macOpe2_F1.hifi_reads?.fastq.gz' /data/okendojo/paradisfishProject/assemblies/verkko/notrio/assembly.fasta


