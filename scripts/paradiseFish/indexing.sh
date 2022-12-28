#!/bin/bash
#SBATCH --partition=norm
#SBATCH --mem=120g
#SBATCH --ntasks=32
#SBATCH --constraint=x2650
#SBATCH --exclusive
#SBATCH --gres=lscratch:200
#SBATCH --time=10:00:00
#SBATCH --mail-type=FAIL,END

module load STAR

cd /data/okendojo/paradisfishProject/bamFiles

fasta="/data/okendojo/paradisfishProject/assemblies/hifiasm/notrio/hifiasmpriasm.fasta"
gff="/data/okendojo/paradisfishProject/annotation/vertebrates/verta_ann_01.maker.output/verta_ann_01.all.gff"
#STAR --runThreadN 16 --genomeSAindexNbases 13 --runMode genomeGenerate --sjdbGTFfile $gff --genomeDir index --genomeFastaFiles $fasta --sjdbOverhang 100

STAR --runThreadN 16 --genomeSAindexNbases 13 --runMode genomeGenerate --genomeDir index --genomeFastaFiles $fasta

