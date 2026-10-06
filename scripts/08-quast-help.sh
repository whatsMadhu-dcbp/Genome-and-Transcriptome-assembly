#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --job-name=help-quast
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_quast_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_quast_%j.e
#SBATCH --partition=pshort_el8

apptainer exec /containers/apptainer/quast_5.2.0.sif quast.py --help