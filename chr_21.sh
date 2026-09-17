#!/bin/bash

#BTEC_640_Human_Chromosome_21_Analysis

#Bash codes used to analyze human chromosome 21 RefSeq annotation and FASTA sequences

#1: Created a working directory

mkdir -p chr21_analysis

#2: Download the hg38 NCBI RefSec GTF

curl -o hg38.ncbiRefSeq.gtf.gz "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz"

#3: Unzip the GTF file

gunzip hg38.ncbiRefSeq.gtf.gz

#4: Inspect the beginning and end of the GTF file.

head hg38.ncbiRefSeq.gtf

tail hg38.ncbiRefSeq.gtf

#5: Create an analysis directory for our data so not to mess with the original file.

mkdir -p analysis

#-move to directory

cd analysis

#6: Create the link to GTF

ln -s ../input_data/hg38.ncbiRefSeq.gtf

#7: Extract data from chromosome 21

grep "chr21" hg38.ncbiRefSeq.gtf

#8: Count the number of chromosome 21 in records.

grep -c "chr21" hg38.ncbiRefSeq.gtf

#9: Save this to a new file.

grep "chr21" hg38.ncbiRefSeq.gtf > chr21.gtf

#10: Select the transcripts that are only for protein coding (NM_)

grep "NM_" chr21.gtf > refseq_chr21.gtf

#11: Print the ninth column in GTF

awk -F '\t' '{print $9}' refseq_chr21.gtf | head

#12: Get the gene name and accession info

awk -F '\t' '{print $9}' refseq_chr21.gtf | awk -F '"' '{print $2, $4}' | head

#13: Pair the gene and accession file

awk -F '\t' '{print $9}' refseq_chr21.gtf | awk -F'"' '!seen[$2]++ {print $2, $4}' > gene_accession.txt

#14: Count these unique pairs

wc -l gene_accession.txt

#15: Double check the header of the gene and accession file

head gene_accession.txt

#16: Select the first 10 genes and download into FASTA file

head -n 10 gene_accession.txt > 10_genes.txt

cat 10_genes.txt

#17: Read and display the FASTA sequence from the 10 genes on NCBI

while read -r gene accession
do
curl -o "${gene}.fasta" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}&rettype=fasta&retmode=text"
done < 10_genes.txt

#18: List the FASTA files and sizes and inspect

ls -l *.fasta

head LSS.fasta
