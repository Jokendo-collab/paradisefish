#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#move to the working directory
#cd /data/okendojo/postdoc_project/maternal
#activate verkko and mamba environments

module load verkko/1.1
#$MERQURY/_submit_build.sh -c 21 maternal.fofn maternal_compress
#$MERQURY/_submit_build.sh maternal.fofn maternal_Nocompress

#mv maternal_compress /data/okendojo/postdoc_project/offspring

#cd /data/okendojo/postdoc_project/paternal

#$MERQURY/_submit_build.sh -c 21 paternal.fofn paternal_compress
#$MERQURY/_submit_build.sh paternal.fofn paternal_Nocompress

#mv paternal_compress /data/okendojo/postdoc_project/offspring

cd /data/okendojo/postdoc_project/offspring

#$MERQURY/_submit_build.sh -c 21 child.fofn  child_compress
#$MERQURY/_submit_build.sh child.fofn  child_Nocompress

#$MERQURY/trio/hapmers.sh maternal_compress.k21.meryl paternal_compress.k21.meryl child_compress.k21.meryl


verkko -d asm --hifi /data/okendojo/postdoc_project/offspring/*.fastq.gz --no-nano --slurm --hap-kmers /data/okendojo/postdoc_project/pfishMerylDBs/compressed/maternal_compress.k21.hapmer.meryl  /data/okendojo/postdoc_project/pfishMerylDBs/compressed/paternal_compress.k21.hapmer.meryl trio
