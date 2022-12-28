#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=80g
#SBATCH --ntasks-per-core=1
#SBATCH --time=72:00:00
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov

#Load the required modules
module load trimgalore
module load multiqc


cd /data/okendojo/postdoc_project/paradiseFishRNA/transcriptome_files
mkdir qc_results

# Run Trim Galore! 

for fastq in *.fastqsanger.gz

do 

trim_galore --quality 20 --fastqc --length 25 --output_dir qc_results $fastq

done

cd qc_results

multiqc .

