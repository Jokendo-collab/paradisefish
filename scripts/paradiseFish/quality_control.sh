#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=72:00:00
#SBATCH --mail-type=FAIL,END
#sbatch --mail-user=javan.okendo@nih.gov


#Load the required modules
module load trimgalore
module load multiqc


cd /data/okendojo/postdoc_project/maternal
# Run Trim Galore! 

for fastq in *.fastq.gz

do 

trim_galore --quality 25 --fastqc --length 25 --output_dir qc_results $fastq

done

cd qc_results

multiqc .

#=============================================================================
cd /data/okendojo/postdoc_project/paternal

# Run Trim Galore! 

for fastq in *.fastq.gz

do

trim_galore --quality 25 --fastqc --length 25 --output_dir p_qc_results $fastq

done

cd p_qc_results

multiqc .

