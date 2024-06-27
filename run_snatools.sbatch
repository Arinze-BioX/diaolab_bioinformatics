#!/bin/bash
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --mem 80GB

ncore=10
ref="/datacommons/ydiaolab/genome_ref/mm10_BWA_index/mm10.fa" #hg38: "/datacommons/ydiaolab/genome_ref/hg38_BWA_index/hg38.fa"
gsize="/datacommons/ydiaolab/genome_ref/mm10_BWA_index/mm10.chrom.sizes" #hg38: "/datacommons/ydiaolab/yyxu/HLI/scATAC-seq/human/fragment/hg38.chrom.sizes"
tmpfold="./"
logfile="./snaptools.log"
outbam="./sample.bam"
outsnap="./sample.snap"
output="./sample.temp.tsv.gz"
corrected_output="./sample.tsv.gz"
fastq1="/fq/sample_L001_R1_001.fastq.gz"
fastq2="/fq/sample_L001_R2_001.fastq.gz"

export PATH=/datacommons/ydiaolab/yyxu/tools/miniconda3/bin:$PATH
module load BWA/0.7.17
module load samtools/1.12-rhel8

snaptools align-paired-end --input-reference=${ref} --input-fastq1=${fastq1} --input-fastq2=${fastq2} --output-bam=${outbam} --aligner=bwa --read-fastq-command=zcat --min-cov=0 --num-threads=${ncore} --if-sort=True --tmp-folder=${tmpfold} --overwrite=TRUE
snaptools snap-pre --input-file=${outbam} --output-snap=${outsnap} --genome-name=mm10 --genome-size=${gsize} --min-mapq=10 --min-flen=0 --keep-chrm=TRUE --keep-single=False --keep-secondary=False --overwrite=True --max-num=10000000 --verbose=False
snaptools dump-fragment --snap-file=${outsnap} --output-file=${output} --buffer-size=10000 --tmp-folder=${tmpfold} &> ${logfile}
python BarcodeCorrect.py  --fq ${fastq1}  -b scATAC_v2_barcode_list.txt.gz -O barcode_correct.txt
python FragmentCorrect.py -F ${output} -C barcode_correct.txt -O ${corrected_output}
cat ${corrected_output} | sort -V -k1,1 -k2,2n  |  pbgzip -c > ${corrected_output}.gz
tabix -p bed ${corrected_output}.gz

rm -f ${output} barcode_correct.txt ${corrected_output} 



