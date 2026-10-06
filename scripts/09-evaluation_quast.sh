#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=quast
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_quast_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_quast_%j.e
#SBATCH --partition=pshort_el8

set -euo pipefail
 
CONTAINER="/containers/apptainer/quast_5.2.0.sif"
THREADS=16
 
FLYE="/data/users/mmahapatra/assembly_annotation_course/results/flye_assembler/assembly.fasta"
HIFIASM="/data/users/mmahapatra/assembly_annotation_course/results/hifiasm_assembler/HIFIO.bp.p_ctg.fa"      
LJA="/data/users/mmahapatra/assembly_annotation_course/results/lja_assembler/assembly.fasta"
 
REFDIR="/data/courses/assembly-annotation-course/references"
REF=$REFDIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa         
GFF=$REFDIR/TAIR10_GFF3_genes.gff    

DATA_DIR="/data"
 
GENOME_SIZE=135000000
 
WORKDIR="/data/users/mmahapatra/assembly_annotation_course" 
OUTDIR="$WORKDIR/results/eva_quast"
mkdir -p "$OUTDIR"
 
apptainer exec \
--bind $DATA_DIR \
    "$CONTAINER" quast.py \
    "$FLYE" "$HIFIASM" "$LJA" \
    --labels flye,hifiasm,LJA \
    -r "$REF" \
    --features "$GFF" \
    --eukaryote \
    --large \
    --threads "$THREADS" \
    -o "$OUTDIR/quast_with_ref"
 
apptainer exec \
--bind $DATA_DIR \
    "$CONTAINER" quast.py \
    "$FLYE" "$HIFIASM" "$LJA" \
    --labels flye,hifiasm,LJA \
    --est-ref-size "$GENOME_SIZE" \
    --eukaryote \
    --large \
    --threads "$THREADS" \
    -o "$OUTDIR/quast_no_ref"
 
echo "Done. Reports: $OUTDIR/quast_with_ref/report.html and $OUTDIR/quast_no_ref/report.html"