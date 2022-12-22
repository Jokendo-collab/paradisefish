#=======================================================
#===== verkko genome assembler based on trio binning====
# the build is based on ubuntu:20.04.2


#Set the base image to ubuntu
FROM python:slim

#File maintainer 

MAINTAINER Javan Okendo "javan.okendo@nih.gov"

#set the working directory

WORKDIR /root

#set noninteractive debian image
ARG DEBIAN_FRONTEND=noninteractive

###############Begin installation###################

# Install base utilities

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends python3 default-jre git wget g++ snakemake make  ca-certificates && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && mkdir /root/.conda && bash Miniconda3-latest-Linux-x86_64.sh -b && rm -f Miniconda3-latest-Linux-x86_64.sh && echo "Running $(conda --version)" && conda init bash && . /root/.bashrc && conda update conda && conda create -n python-app && conda activate python-app && conda install python=3.6 pip && echo 'print("Hello World!")' > python-app.py

RUN echo 'conda activate python-app \n\
alias python-app="python python-app.py"' >> /root/.bashrc

# Istall Graphaligner and MBG
RUN conda install -c bioconda graphaligner
RUN conda install -c bioconda mbg

# Install verkko
RUN conda install -c conda-forge -c bioconda -c defaults verkko 

ENTRYPOINT ["verkko"]
















