#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=02:00:00
#SBATCH --job-name=k-mer
#SBATCH --output=/data/users/mmahapatra/output_k-mer_%j.o
#SBATCH --error=/data/users/mmahapatra/error_k-mer_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/mmahapatra/assembly_annotation_course"
DATA_DIR="/data"                                                  
CONTAINER="/containers/apptainer/jellyfish-2.2.6--0.sif"
PACBIO_FASTQ="$WORKDIR/Had-6b/ERR11437317.fastq.gz"
OUTDIR="$WORKDIR/results/k_mer_counting"
OUT_JELLYFISH="$OUTDIR/reads.jf"
OUT_JELLY_HISTO="$OUTDIR/reads.histo"


apptainer exec \
--bind $DATA_DIR \
$CONTAINER \
jellyfish count -C -m 21 -s 5G -t 4 -o $OUT_JELLYFISH <(zcat $PACBIO_FASTQ)

apptainer exec \
--bind $DATA_DIR \
$CONTAINER \
jellyfish histo -t 4 $OUT_JELLYFISH > $OUT_JELLY_HISTO 
