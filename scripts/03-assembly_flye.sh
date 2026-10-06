#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=flye_assembler
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_flye_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_flye_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/mmahapatra/assembly_annotation_course"
DATA_DIR="/data"                                                  
CONTAINER="/containers/apptainer/flye_2.9.5.sif"
PACBIO_FASTQ="$WORKDIR/Had-6b/ERR11437317.fastq.gz"
OUTDIR="$WORKDIR/results/flye_assembler"


apptainer exec \
--bind $DATA_DIR \
$CONTAINER \
flye --pacbio-hifi $PACBIO_FASTQ --out-dir $OUTDIR --threads 4
