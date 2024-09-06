#!/bin/bash
#SBATCH -A loni_bioinfo01
#SBATCH -p workq
#SBATCH -t 5:00:00
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -o /work/shnsk95/Output_logs/%j_output.log
#SBATCH -e /work/shnsk95/Error_logs/%j_error.log

#Create Job log
JOB_ID=$SLURM_JOB_ID
SCRIPT_NAME="Deduplicate_Bam.sh"
echo "JOB ID: $JOB_ID " > /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT NAME: $SCRIPT_NAME " >> /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT CONTENT: " >> /work/shnsk95/Job_logs/$JOB_ID.txt
cat "$0" >> /work/shnsk95/Job_logs/$JOB_ID.txt

#Starting execution
SECONDS=0
echo 'Starting execution with 1 Node and 8 Cores'

#Load required modules
echo 'Loading samtools'
module load samtools

#Gathering files and paths
echo 'Gathering files and paths'
Files_path=/work/shnsk95/H3K4Me3/data/alignment_files
Files=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")

#Deduplication of reads in the Bam files
for file in "${Files[@]}"; do
	echo 'Performing the deduplication of reads in the bam file'
	samtools markdup -r -s ${Files_path}/Sorted_${file}.bam ${Files_path}/Sorted_rmdup_${file}.bam
	echo 'Indexing the bam file'
	samtools index ${Files_path}/Sorted_rmdup_${file}.bam
done
echo 'Finished deduplication'


#Unloading modules
echo 'Unloading modules'
module unload samtools

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


