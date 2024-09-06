#!/bin/bash
#SBATCH -A loni_bioinfo01
#SBATCH -p workq
#SBATCH -t 48:00:00
#SBATCH -N 2
#SBATCH -n 128
#SBATCH -o /work/shnsk95/Output_logs/%j_output.log
#SBATCH -e /work/shnsk95/Error_logs/%j_error.log

#Create Job log
JOB_ID=$SLURM_JOB_ID
SCRIPT_NAME="Bowtie2_build_index.sh"
echo "JOB ID: $JOB_ID " > /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT NAME: $SCRIPT_NAME " >> /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT CONTENT: " >> /work/shnsk95/Job_logs/$JOB_ID.txt
cat "$0" >> /work/shnsk95/Job_logs/$JOB_ID.txt


#Setting SECONDS=0 to keep track of execution time
SECONDS=0

echo 'Starting execution'


echo 'Using 2 Nodes and 128 cores with 48 hours wall time'


#Load bowtie2
echo 'Loading Bowtie2'
module load bowtie2

#Gathering paths
echo 'Gathering genomic sequences'
FASTA_FILES_PATH="/work/shnsk95/Downloads/GCF_000001635.27_GRCm39_genomic.fna.gz"

echo 'Building index'
#Build index
bowtie2-build $FASTA_FILES_PATH  /work/shnsk95/Mouse_WG_Small_Index/mm10_GRCm39_reference_index
echo 'Finished building index'


echo 'Unload Bowtie2'
#Unload bowtie2
module unload bowtie2


echo 'End of execution'


#Calculate total time
Execution_time=$SECONDS

#Display execution time
echo "Total execution time in seconds: $Execution_time "


