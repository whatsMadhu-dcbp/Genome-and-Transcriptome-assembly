#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=busco
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_busco2_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_busco2_%j.e
#SBATCH --partition=pshort_el8

set -euo pipefail
 
CONTAINER="/containers/apptainer/busco_5.7.1.sif"
CPU=16
 
FLYE="/data/users/mmahapatra/assembly_annotation_course/results/flye_assembler/assembly.fasta"
HIFIASM="/data/users/mmahapatra/assembly_annotation_course/results/hifiasm_assembler/HIFIO.bp.p_ctg.fa"      
LJA="/data/users/mmahapatra/assembly_annotation_course/results/lja_assembler/assembly.fasta"
TRINITY="/data/users/mmahapatra/assembly_annotation_course/trinity_out_dir/Trinity.tmp.fasta"

WORKDIR="/data/users/mmahapatra/assembly_annotation_course" 
OUTDIR="$WORKDIR/results/eva2_busco"
DATA_DIR="/data"

mkdir -p "$OUTDIR"
cd "$OUTDIR"       
 

LIN_OPT="--auto-lineage"

 
run_busco () {
    local name=$1 fasta=$2 mode=$3
    apptainer exec \
    --bind $DATA_DIR \
    "$CONTAINER" busco \
        -i "$fasta" \
        -o "busco_${name}" \
        -m "$mode" \
        $LIN_OPT \
        --cpu "$CPU" \
        -f         
}
 
run_busco flye    "$FLYE"    genome
run_busco hifiasm "$HIFIASM" genome
run_busco lja     "$LJA"     genome
run_busco trinity "$TRINITY" transcriptome
 

for d in busco_*/; do
    echo "== $d"
    cat "$d"/short_summary*.txt 2>/dev/null | grep -E "C:|Dataset|lineage" || true
done