#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=512g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-user=javan.okendo@nih.gov

cd /data/okendojo/postdoc_project/maternal/m_qc_results

# Trio binning assembly (requiring https://github.com/lh3/yak)
yak count -b37 -t 32 -o pat.yak <(cat pat_1_R1.fq.gz  pat_1_R2.fq.gz) <(cat pat_2_R1.fq.gz  pat_2_R2.fq.gz)
yak count -b37 -t 32 -o mat.yak <(cat mat_1_R1.fq.gz mat_1_R2.fq.gz) <(cat mat_2_R1.fq.gz mat_2.R2.fq.gz)

hifiasm -o hifiasmTrio.asm -t 32 -D 10.0 -c 25 -d 75 --hg-size 0.5g -1 pat.yak -2 mat.yak /data/okendojo/postdoc_project/offspring/*.fastq.gz

mkdir asm_pri
mkdir trio
cp -r *hifiasmTrio.asm* asm_pri
cp -r *hifiasmTrio.asm* mat.yak pat.yak trio

cd asm_pri
# Generating primary and trio binning assembly
hifiasm -o hifiasmTrio.asm -t 32 *.fq.gz 2> hifiasmTrio.asm.pri.log

cd trio

hifiasm -o hifiasmTrio.asm -t 32 -l1 -1 pat.yak -2 mat.yak /dev/null 2> hifiasmTrio.asm.trio.log


