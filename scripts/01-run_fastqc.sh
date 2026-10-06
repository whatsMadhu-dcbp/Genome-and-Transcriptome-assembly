#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastqc
#SBATCH --partition=pshort_el8

WORKDIR=/data/users/mmahapatra/assembly_annotation_course

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc \
--help
