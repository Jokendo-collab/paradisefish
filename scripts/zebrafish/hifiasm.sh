#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=zf_hifiasm

cd /data/okendojo/zebrafish/assembly_results/hifiasm

hifiData=/data/okendojo/zebrafish/hifi/m54313U_220817_024630.hifi_reads.fastq.gz

hifiasm -o hifi -t 32 -D 10.0 -c 25 -d 75 --hg-size 1.2g  ${hifiData} 2> asm.log  
