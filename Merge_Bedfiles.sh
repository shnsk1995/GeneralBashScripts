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
SCRIPT_NAME="Merge_Bedfiles.sh"
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

#Initializing conda
echo 'Initializing conda'
conda init
source ~/.bashrc

#Activate conda environment
echo 'Activating conda environment'
conda activate bedtools

#Gathering files and paths
echo 'Gathering files and paths'
Data_path=/work/shnsk95/H3K4Me3/data
Files=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289") 

#Creating a merged bed file
echo 'Creating a merged bed file'
touch ${Data_path}/Merged_Bedfile.bed

#Merging bed files
for file in "${Files[@]}"; do
	cat ${Data_path}/peak_calling/${file}/${file}_Chrpeaks.bed >> ${Data_path}/Merged_Bedfile.bed
done

#Filter merged bedfile
awk '$1 ~ /^chr[0-9XY]+$/ {print}' ${Data_path}/Merged_Bedfile.bed > ${Data_path}/Filtered_M_Bedfile.bed


#Sort merged bedfile
echo 'Sorting merged bedfile'
sort -k1,1 -k2,2n ${Data_path}/Filtered_M_Bedfile.bed > ${Data_path}/Sorted_F_M_Bedfile.bed


#Merging overlapped regions
echo 'Merging overlapped regions'
bedtools merge -i ${Data_path}/Sorted_F_M_Bedfile.bed > ${Data_path}/Final_Merged_Bedfile.bed 

#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate

#Unloading modules
echo 'Unloading modules'
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


