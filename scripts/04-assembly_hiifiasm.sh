#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --job-name=hifiasm_assembler
#SBATCH --output=/data/users/mmahapatra/assembly_annotation_course/log/output_hifiasm_%j.o
#SBATCH --error=/data/users/mmahapatra/assembly_annotation_course/log/error_hifiasm_%j.e
#SBATCH --partition=pshort_el8

WORKDIR="/data/users/mmahapatra/assembly_annotation_course"
DATA_DIR="/data"                                                  
CONTAINER="/containers/apptainer/hifiasm_0.25.0.sif"
PACBIO_FASTQ="$WORKDIR/Had-6b/ERR11437317.fastq.gz"
OUTDIR="$WORKDIR/results/hifiasm_assembler"

apptainer exec \
--bind $DATA_DIR \
$CONTAINER \
hifiasm -o ${OUTDIR}/HIFIO -t 16 $PACBIO_FASTQ

awk '/^S/{print ">"$2;print $3}' ${OUTDIR}/HIFIO.bp.p_ctg.gfa > ${OUTDIR}/HIFIO.bp.p_ctg.fa