#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=k-mer_meryl
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_k-mer_meryl_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_k-mer_meryl_%j.e
#SBATCH --partition=pshort_el8

CONTAINER="/containers/apptainer/merqury_1.3.sif"

apptainer exec $CONTAINER sh /usr/local/share/merqury/best_k.sh 135000000