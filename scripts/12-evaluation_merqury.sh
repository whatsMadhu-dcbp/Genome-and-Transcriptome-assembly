#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=merqury
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_merqury_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_merqury_%j.e
#SBATCH --partition=pshort_el8

set -euo pipefail
 
CONTAINER="/containers/apptainer/merqury_1.3.sif"
 
export MERQURY="/usr/local/share/merqury"
 
FLYE="/data/users/mmahapatra/assembly_annotation_course/results/flye_assembler/assembly.fasta"
HIFIASM="/data/users/mmahapatra/assembly_annotation_course/results/hifiasm_assembler/HIFIO.bp.p_ctg.fa"      
LJA="/data/users/mmahapatra/assembly_annotation_course/results/lja_assembler/assembly.fasta"
 
BIND="--bind /data:/data"
WORKDIR="/data/users/mmahapatra/assembly_annotation_course" 
OUTDIR="$WORKDIR/results/meryl_db"
DB=$OUTDIR/reads.meryl
 
if [ ! -d "$DB" ]; then
    echo "ERROR: $DB not found. Run 1_meryl_db.sh first (from the same directory)." >&2
    exit 1
fi
 
cd "$OUTDIR"
 
run_merqury () {
    local name=$1 asm=$2
    mkdir -p "merqury_${name}"
    cd "merqury_${name}"
    ln -sfn "$DB" reads.meryl
     apptainer exec $BIND "$CONTAINER" merqury.sh \
        reads.meryl "$asm" "$name"
    cd ..
}
 
run_merqury flye    "$FLYE"
run_merqury hifiasm "$HIFIASM"
run_merqury lja     "$LJA"
 
for n in flye hifiasm lja; do
    echo "== $n"
    echo "QV:";           cat merqury_${n}/${n}.qv
    echo "Completeness:"; cat merqury_${n}/${n}.completeness.stats
done