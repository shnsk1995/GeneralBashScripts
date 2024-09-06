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
SCRIPT_NAME="ChIPseq_Heatmap_Grid.sh"
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
Files=("SRR15415286" "SRR15415288" "SRR15415289" "SRR15415287")
Data_path=/work/shnsk95/H3K4Me3/data
File_paths=()


#Creating file paths
for file in "${Files[@]}"; do
	File_paths+=("${Data_path}/bigwig_files/${file}.bigwig")
done

#Creating required directories
echo 'Creating required directories'
mkdir ${Data_path}/matrix_grid
mkdir ${Data_path}/heatmaps_grid


#Using computeMatrix function to obtain comprehensive gzipped table
echo 'Using computeMatrix function to obtain comprehensive gzipped table'
computeMatrix reference-point -S "${File_paths[@]}" -R ${Data_path}/RefSeq_Final_Merged_Bedfile.bed -out H3K4Me3_Auxin_matrix.gz  --referencePoint center  -a 5000 -b 5000
	mv H3K4Me3_Auxin_matrix.gz ${Data_path}/matrix_grid/
echo 'Comprehensive matrix file generated!'


#Using plotHeatmap function to obtain heatmap grid plot
echo 'Using plotHeatmap function to obtain heatmap grid plot'
plotHeatmap -m ${Data_path}/matrix_grid/H3K4Me3_Auxin_matrix.gz --outFileName H3K4Me3_Auxin_heatmap --zMin 0 --zMax 120 --yMin 0 --yMax 100 --xAxisLabel "Position (kb)" --yAxisLabel "ChIP-seq enrichment" --samplesLabel "0 h" "2 h" "8 h" "24 h" --refPointLabel TSS --plotTitle H3K4me3
	mv H3K4Me3_Auxin_heatmap.png ${Data_path}/heatmaps_grid/
echo 'Heatmap grid generated!'


#Deactivate conda environment
echo 'Deactivating conda environment'
conda deactivate


#Unloading modules
echo 'Unloading modules'
module unload conda

#Calculate execution time
echo "Total execution time in seconds: $SECONDS"


