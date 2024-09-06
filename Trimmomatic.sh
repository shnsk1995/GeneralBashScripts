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
SCRIPT_NAME="Trimmomatic.sh"
echo "JOB ID: $JOB_ID " > /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT NAME: $SCRIPT_NAME " >> /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT CONTENT: " >> /work/shnsk95/Job_logs/$JOB_ID.txt
cat "$0" >> /work/shnsk95/Job_logs/$JOB_ID.txt

#Starting execution
SECONDS=0
echo 'Starting execution with 1 Node and 1 core'

#Load required modules
echo 'Loading conda'
module load conda

#Initialize conda
echo 'Initializing conda'
conda init

#Activate conda environment
echo 'Activating conda environment trimmomatic'
conda activate trimmomatic

#Gathering files and paths
echo 'Gathering files and paths'
Fastq_files_path=/work/shnsk95/H3K4Me3/data/fastq
Fastq_files_list=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")
Trimmomatic_jar_path="/home/shnsk95/conda_pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2/trimmomatic.jar"

#Trimming reads
echo 'Trimming reads'
for file in "${Fastq_files_list[@]}"; do
       java -jar $Trimmomatic_jar_path SE ${Fastq_files_path}/${file}/${file}.fastq ${Fastq_files_path}/${file}/${file}_trimmed.fastq CROP:72 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
done
echo 'Finished trimming reads'

#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate

#Unloading modules
echo 'Unloading modules'
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


