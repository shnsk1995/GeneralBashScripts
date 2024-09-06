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
SCRIPT_NAME="Create_Bedfile_RefSeq.sh"
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
Files=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")
Data_path=/work/shnsk95/H3K4Me3/data

#Processing individual bed files
echo 'Processing individual bed files'
for file in "${Files[@]}";do
	echo 'Extracting peak regions'
	awk '{print $1 "\t" $2 "\t" $3}' ${Data_path}/peak_calling/${file}/${file}_peaks.broadPeak >  ${Data_path}/peak_calling/${file}/${file}_peaks.bed 
	echo 'Converting RefSeq accession numbers into chromosome numbers and saving the bed file'
	awk 'NR==FNR {map[$4]=$1; next} {$1 = map[$1]} 1' OFS='\t' ${Data_path}/RefSeq_Chr_Map.txt ${Data_path}/peak_calling/${file}/${file}_peaks.bed > ${Data_path}/peak_calling/${file}/${file}_Chrpeaks.bed
	echo 'Sorting the bedfile'
	sort -k1,1 -k2,2n ${Data_path}/peak_calling/${file}/${file}_peaks.bed	
done
echo 'Finished processing individual bedfiles'


#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate


#Unloading modules
echo 'Unloading modules'
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


