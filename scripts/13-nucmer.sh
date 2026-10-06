#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --job-name=nucmer
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_nucmer_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_nucmer_%j.e
#SBATCH --partition=pshort_el8
 
set -euo pipefail
 
CONTAINER="/containers/apptainer/mummer4_gnuplot.sif"
BIND="--bind /data:/data"
THREADS=16
 
WORKDIR="/data/users/mmahapatra/assembly_annotation_course"
OUTDIR="$WORKDIR/results/nucmer_results"
 
REF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
 
FLYE="$WORKDIR/results/flye_assembler/assembly.fasta"
HIFIASM="$WORKDIR/results/hifiasm_assembler/HIFIO.bp.p_ctg.fa"
LJA="$WORKDIR/results/lja_assembler/assembly.fasta"
 
mkdir -p "$OUTDIR" 
cd "$OUTDIR"
 
compare () {
    local name=$1 ref=$2 query=$3
    echo "== $name"
    apptainer exec $BIND "$CONTAINER" nucmer --prefix="$name" --breaklen 1000 --mincluster 1000 -t "$THREADS" "$ref" "$query"
    apptainer exec $BIND "$CONTAINER" mummerplot -R "$ref" -Q "$query" --filter -t png --large --layout --fat -p "$name" "${name}.delta"
}
 

compare flye_vs_ref    "$REF" "$FLYE"
compare hifiasm_vs_ref "$REF" "$HIFIASM"
compare lja_vs_ref     "$REF" "$LJA"
 

compare flye_vs_hifiasm    "$FLYE"    "$HIFIASM"
compare flye_vs_lja        "$FLYE"    "$LJA"
compare hifiasm_vs_lja     "$HIFIASM" "$LJA"
 
echo "Done. Dotplots (*.png) are in $OUTDIR"