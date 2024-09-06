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
SCRIPT_NAME="Peak_Calling.sh"
echo "JOB ID: $JOB_ID " > /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT NAME: $SCRIPT_NAME " >> /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT CONTENT: " >> /work/shnsk95/Job_logs/$JOB_ID.txt
cat "$0" >> /work/shnsk95/Job_logs/$JOB_ID.txt

#Starting execution
SECONDS=0
echo 'Starting execution with 1 Node and 8 Cores'

#Load required modules
echo 'Loading conda'
module load conda

#Initializing Conda
echo 'Initializing conda '
conda init
source ~/.bashrc

#Activate conda environment
echo 'Activating conda environment'
conda activate MACS

#Gathering files and paths
echo 'Gathering files and paths'
Files=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")
Data_path=/work/shnsk95/H3K4Me3/data


#Creating required directories
echo 'Creating required directories'
mkdir ${Data_path}/peak_calling

#Peak calling
for file in "${Files[@]}";do
	echo 'Creating directory for saving results'
	mkdir ${Data_path}/peak_calling/${file}
	echo 'Performing peak calling'
	macs2 callpeak -t ${Data_path}/alignment_files/Sorted_rmdup_${file}.bam --broad -g mm -n ${file} --outdir ${Data_path}/peak_calling/${file}/
done
echo 'Finished peak calling for all files'

#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate

#Unloading modules
echo 'Unloading modules'
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


