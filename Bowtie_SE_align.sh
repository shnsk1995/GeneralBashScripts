#!/bin/bash
#SBATCH -A loni_bioinfo01
#SBATCH -p workq
#SBATCH -t 24:00:00
#SBATCH -N 2
#SBATCH -n 128
#SBATCH -o /work/shnsk95/Output_logs/%j_output.log
#SBATCH -e /work/shnsk95/Error_logs/%j_error.log

#Create Job log
JOB_ID=$SLURM_JOB_ID
SCRIPT_NAME="Bowtie_SE_align.sh"
echo "JOB ID: $JOB_ID " > /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT NAME: $SCRIPT_NAME " >> /work/shnsk95/Job_logs/$JOB_ID.txt
echo "SCRIPT CONTENT: " >> /work/shnsk95/Job_logs/$JOB_ID.txt
cat "$0" >> /work/shnsk95/Job_logs/$JOB_ID.txt


#Begin execution and set SECONDS=0
SECONDS=0
echo 'Starting Execution'
echo 'Using 2 Nodes and 128 cores'

#Load required modules
echo 'Loading bowtie2'
module load bowtie2
echo 'Loading samtools'
module load samtools


#Setting file paths
echo 'Gathering files and paths'
Index_path=$MOUSE_WG_SMALL_INDEX
Reads_path=/work/shnsk95/H3K4Me3/data/fastq
Fastq_files_list=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")
Output_path=/work/shnsk95/H3K4Me3/data/alignment_files



for file in "${Fastq_files_list[@]}";do
	#Aligning sequences to the genome
	echo 'Aligning sequences to the genome'
	bowtie2 -x $Index_path -U ${Reads_path}/${file}/${file}_trimmed.fastq -S $Output_path/${file}.sam
	#Convert sam file to bam file
	echo 'Converting sam file to bam file'
	samtools view -S -b $Output_path/${file}.sam -o $Output_path/${file}.bam
	#Sorting aligned reads
	echo 'Sorting aligned reads'
	samtools sort $Output_path/${file}.bam -o $Output_path/Sorted_${file}.bam
	#Index the bam file
	echo 'Indexing the bam file'
	samtools index $Output_path/Sorted_${file}.bam
done
echo 'Finished aligning sequences to the genome'


#Unloading modules
echo 'Unloading modules'
module unload bowtie2
module unload samtools

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"
