#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc_transcriptome
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_fastqc_transcriptome_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_fastqc_transcriptome_%j.e

WORKDIR="/data/users/mmahapatra/assembly_annotation_course"
OUTDIR="$WORKDIR/results/fastqc_results/RNASeq_Sha"
DATA_DIR="/data"

mkdir -p $OUTDIR

apptainer exec \
--bind $DATA_DIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc \
-t 4 \
-o $OUTDIR \
$WORKDIR/RNAseq_Sha/ERR754081_1.fastq.gz \
$WORKDIR/RNAseq_Sha/ERR754081_2.fastq.gz