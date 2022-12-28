#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=180g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/paradisfishProject/RNA_seq_data/transcriptome_files

# Load the module
module load trinity/2.14.0

mkdir trinityasm

Trinity --seqType fq --max_memory 180G  --samples_file sample.txt --trimmomatic  --monitoring --monitor_sec 30 --CPU 32 --output trinityasm 


