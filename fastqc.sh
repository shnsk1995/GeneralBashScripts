#!/bin/bash
#SBATCH -A loni_bioinfo01
#SBATCH -p workq
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -o /work/shnsk95/Output_logs/%j_output.log
#SBATCH -e /work/shnsk95/Error_logs/%j_error.log

#Create Job log
JOB_ID=$SLURM_JOB_ID
SCRIPT_NAME="fastqc.sh"
echo "JOB ID: $JOB_ID " > /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT NAME: $SCRIPT_NAME " >> /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT CONTENT: " >> /work/shnsk95/Job_logs/$JOB_ID.txt
cat "$0" >> /work/shnsk95/Job_logs/$JOB_ID.txt

#Starting execution
SECONDS=0
echo 'Starting execution with 1 Node and 1 Core'

#Load conda
echo 'Loading conda'
module load conda

#Initializing conda
echo 'Initializing conda'
conda init
source ~/.bashrc

#Activate fastqc conda environment
echo 'Activating fastqc conda environment'
conda activate fastqc

#Gathering file paths
echo 'Gathering fastq files path'
Fastq_files_path=/work/shnsk95/H3K4Me3/data/fastq
Fastq_files_list=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")
Output_path=/work/shnsk95/H3K4Me3/data

#Create directory to save fastqc results
mkdir $Output_path/fastqQC/trimmed

#Running fastqc on the specified files
echo 'Running fastqc on the specified files'
for file in "${Fastq_files_list[@]}"; do
	fastqc ${Fastq_files_path}/${file}/${file}_trimmed.fastq --outdir $Output_path/fastqQC/trimmed/
done
echo 'Finished running fastqc on all specified files'

#Deactivate fastqc conda environment and unloading conda
echo 'Deactivating fastqc conda environment and unloading conda'
conda deactivate
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"

