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
SCRIPT_NAME="Download_SRA.sh"
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


#Activate sra conda environment
echo 'Activating conda environment sra'
conda activate sra

#Setting SRA Number limits
echo 'Setting start and end SRA numbers'
SRR_START_NUMBER=15415213
SRR_END_NUMBER=15415297

#Gathering output path
echo 'Gathering output path'
Output_path=/work/shnsk95/H3K4Me3/data/fastq


#Downloading and extracting fastq files
echo 'Starting download'
while  [ $SRR_START_NUMBER -le $SRR_END_NUMBER  ]; do

	echo "Downloading SRR${SRR_START_NUMBER}"

	prefetch "SRR${SRR_START_NUMBER}"

	echo "Creating output directory SRR${SRR_START_NUMBER}"

	mkdir $Output_path/"SRR${SRR_START_NUMBER}"

	echo "Extracting fastq files for SRR${SRR_START_NUMBER}"

	fasterq-dump "SRR${SRR_START_NUMBER}" --outdir $Output_path/"SRR${SRR_START_NUMBER}"/

	SRR_START_NUMBER=$((SRR_START_NUMBER + 1))
done	
echo 'Finished downloading and extracting fastq files for all'

#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate


#Unloading modules
echo 'Unloading modules'
module unload conda


#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


