#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=lja_assembler
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_lja_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_lja_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/mmahapatra/assembly_annotation_course"
DATA_DIR="/data"                                                  
CONTAINER="/containers/apptainer/lja-0.2.sif"
PACBIO_FASTQ="$WORKDIR/Had-6b/ERR11437317.fastq.gz"
OUTDIR="$WORKDIR/results/lja_assembler"

apptainer exec \
--bind $DATA_DIR \
$CONTAINER \
lja -o $OUTDIR --reads $PACBIO_FASTQ