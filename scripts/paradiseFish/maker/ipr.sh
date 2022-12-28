#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=36:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=iprScan


#Load the required modules
module load maker
module load augustus
module load busco
module load snap
module load bedtools
module load repeatmodeler
#module load repeatmasker
module load genometools
module load seqkit

cd /data/okendojo/paradisfishProject/annotation

# See here for latest db available: https://github.com/ebi-pf-team/interproscan or http://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/
# Set versions
version_major=5.59
version_minor=91.0
CONDA_PREFIX=/data/okendojo/conda/envs/interproscan

# get the md5 of the databases
wget http://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${version_major}-${version_minor}/interproscan-${version_major}-${version_minor}-64-bit.tar.gz.md5
# get the databases (with core because much faster to download)
wget http://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${version_major}-${version_minor}/interproscan-${version_major}-${version_minor}-64-bit.tar.gz
# checksum
md5sum -c interproscan-${version_major}-${version_minor}-64-bit.tar.gz.md5
# untar gz
tar xvzf interproscan-${version_major}-${version_minor}-64-bit.tar.gz
# remove the sample DB bundled by default
rm -rf $CONDA_PREFIX/share/InterProScan/data/
# copy the new db
cp -r interproscan-${version_major}-${version_minor}/data $CONDA_PREFIX/share/InterProScan/

