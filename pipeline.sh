###1. bulk RNA-seq: https://nf-co.re/rnaseq/3.14.0
nextflow run nf-core/rnaseq -c profile.config --input samplesheet.csv --outdir result --fasta /datacommons/ydiaolab/genome_ref/refdata-gex-GRCh38-2020-A/fasta/genome.fa --gtf genes.gtf -profile singularity --skip_pseudo_alignment --featurecounts_group_type gene_name -resume #--fasta and --gtf are provided based on your data, or just provide --genome GRCh38
###2. bulk ATAC-seq: https://nf-co.re/atacseq/2.1.2
nextflow run nf-core/atacseq -profile singularity --input samplesheet.csv --genome GRCh38 --mito_name chrM --bwa_min_score 30 --macs_fdr 0.01 --min_reps_consensus 1 --max_memory 50.GB --max_cpus 6 --narrow_peak
###3. bulk HiCAR: https://github.com/nf-core/hicar
nextflow run jianhong/hicar -profile singularity --genome mm10 -r dev2rc --input samplesheet.csv --skip_fastqc --skip_cutadapt --outdir result -c profile.config --skip_interactions --skip_tads --skip_compartments --skip_diff_analysis --skip_peak_qc --skip_igv --skip_trackhub --skip_circos --pairtools_parse_params "--min-mapq 10 --max-molecule-size 2000 --max-inter-align-gap 50 --walks-policy 5unique --no-flip --drop-seq --drop-sam" -resume
###4. bulk ChIP-seq: https://nf-co.re/chipseq/2.0.0
###5. bulk CUT&RUN and CUT&TAG: https://nf-co.re/cutandrun/3.2.2
###6. single cell RNA-seq (generate seurat input files): https://www.10xgenomics.com/cn/support/software/cell-ranger/latest/analysis/running-pipelines/cr-gex-count; https://satijalab.org/seurat/articles/pbmc3k_tutorial
module load Cell-Ranger/3.1.0
cellranger count --id=output_directory --fastqs=/fastq_directory --sample=sampleID --transcriptome=/datacommons/ydiaolab/genome_ref/refdata-gex-GRCh38-2020-A --localcores=12 --localmem=120 #mm10 transcriptome:/datacommons/ydiaolab/genome_ref/refdata-gex-mm10-2020-A
###7. single cell ATAC-seq (generate ArchR input files) : the sciprts in "scATAC_script" folder