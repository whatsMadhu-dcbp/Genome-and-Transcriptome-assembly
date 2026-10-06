#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=meryl_db
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_meryl_db_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_meryl_db_%j.e
#SBATCH --partition=pshort_el8

set -euo pipefail
 
CONTAINER="/containers/apptainer/merqury_1.3.sif"
THREADS=16
MEM=60          
 
READS="/data/users/mmahapatra/assembly_annotation_course/Had-6b/ERR11437317.fastq.gz"
 
K=18
 
BIND="--bind /data:/data"
WORKDIR="/data/users/mmahapatra/assembly_annotation_course" 
OUTDIR="$WORKDIR/results/meryl_db"
mkdir -p "$OUTDIR"
cd "$OUTDIR"
 
i=0
DBS=()
for r in "${READS[@]}"; do
    i=$((i+1))
    apptainer exec $BIND "$CONTAINER" meryl \
        k=$K count threads=$THREADS memory=$MEM \
        "$r" output "reads_part${i}.meryl"
    DBS+=("reads_part${i}.meryl")
done
 
if [ "${#DBS[@]}" -gt 1 ]; then
    apptainer exec $BIND "$CONTAINER" meryl union-sum \
        threads=$THREADS output reads.meryl "${DBS[@]}"
else
    mv "${DBS[0]}" reads.meryl
fi
 
echo "Done. Database: $OUTDIR/reads.meryl"