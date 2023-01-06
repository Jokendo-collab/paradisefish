#! /usr/bin/env python

import os
import subprocess

# Set the paths to the BLASTP, InterProScan, and MAKER executables
blastp_path = "/usr/local/apps/blast/ncbi-blast-2.13.0+/bin/blastp"
interproscan_path = "/data/okendojo/conda/envs/interproscan/bin/interproscan.sh"
maker_path = "/usr/local/apps/maker/3.01.03/maker/bin/maker"

# Set the paths to the input genome and the protein database to search
genome_path = "/data/okendojo/paradisfishProject/assemblies/hifiasm/hifiasmNoTrio/hifiasmpriasm.fasta"
database_path = "/data/okendojo/paradisfishProject/annotation/proteindbs/uniprot-8zebrafis-2022.12.01.fasta"

# Run BLASTP to search for matches to known protein sequences in the genome
blastp_output_path = "blastp_output.txt"
blastp_command = [blastp_path, "-query", genome_path, "-subject", database_path, "-outfmt", "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore"]
subprocess.run(blastp_command, stdout=open(blastp_output_path, "w"))

# Parse the BLASTP output to extract the matches and store them in a format that can be used by InterProScan
parsed_matches_path = "parsed_matches.txt"
with open(blastp_output_path, "r") as blastp_output_file, open(parsed_matches_path, "w") as parsed_matches_file:
  for line in blastp_output_file:
    # Extract the relevant fields from the BLASTP output and write them to the parsed_matches_file
    fields = line.strip().split("\t")
    query_id = fields[0]
    subject_id = fields[1]
    evalue = fields[10]
    parsed_matches_file.write("\t".join([query_id, subject_id, evalue]) + "\n")

# Use InterProScan to identify the functional domains and other features present in the protein sequences
interproscan_output_path = "interproscan_output.txt"
interproscan_command = [interproscan_path, "-i", parsed_matches_path, "-f", "tsv", "-o", interproscan_output_path]
subprocess.run(interproscan_command)

# Use MAKER to incorporate the results from BLASTP and InterProScan into a comprehensive annotation of the genome
annotation_path = "/data/okendojo/paradisfishProject/annotation/zebrafish/maker_round_03.all.gff"
maker_command = [maker_path, "-genome", genome_path, "-blast", blastp_output_path, "-ipr", interproscan_output_path, "-gff", annotation_path]
subprocess.run(maker_command)

