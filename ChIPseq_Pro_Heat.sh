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
SCRIPT_NAME="ChIPseq_Pro_Heat.sh"
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
conda activate deeptools


#Gathering files and paths
echo 'Gathering files and paths'
Files=("SRR15415286" "SRR15415287" "SRR15415288" "SRR15415289")
Data_path=/work/shnsk95/H3K4Me3/data

#Creating required directories
echo 'Creating required directories'
mkdir ${Data_path}/bigwig_files
mkdir ${Data_path}/matrix_files
mkdir ${Data_path}/profile_plots
mkdir ${Data_path}/heatmaps

#Using bamCoverage function to obtain bigwig files
echo 'Using bamCoverage function to obtain bigwig files'
for file in "${Files[@]}"; do
	bamCoverage --bam ${Data_path}/alignment_files/Sorted_rmdup_${file}.bam --outFileName ${file}.bigwig --outFileFormat bigwig --blackListFileName ${Data_path}/mm10_Blacklist.bed -p max --effectiveGenomeSize 2654621783 --normalizeUsing RPGC -e 72 --centerReads
	mv ${file}.bigwig ${Data_path}/bigwig_files/
done
echo 'All bigwig files generated!'


#Using computeMatrix function to obtain gzipped tables
echo 'Using computeMatrix function to obtain gzipped tables'
for file in "${Files[@]}"; do
        computeMatrix reference-point -S ${Data_path}/bigwig_files/${file}.bigwig -R ${Data_path}/RefSeq_Final_Merged_Bedfile.bed -out ${file}_matrix.gz  --referencePoint center  -a 5000 -b 5000
	mv ${file}_matrix.gz ${Data_path}/matrix_files/
done
echo 'All matrix files generated!'


#Using plotProfile and plotHeatmap functions to obtain profile and heatmap plots
echo 'Using plotProfile and plotHeatmap functions to obtain profile and heatmap plots'
for file in "${Files[@]}"; do
	plotProfile -m ${Data_path}/matrix_files/${file}_matrix.gz --outFileName ${file}
	mv ${file}.png ${Data_path}/profile_plots/
	plotHeatmap -m ${Data_path}/matrix_files/${file}_matrix.gz --outFileName ${file} --zMin 0 --zMax 120 --yMin 0 --yMax 100
	mv ${file}.png ${Data_path}/heatmaps/
done
echo 'All profile and heatmap plots generated!'


#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate


#Unloading modules
echo 'Unloading modules'
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


