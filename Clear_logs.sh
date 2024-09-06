#!/bin/bash

#Ensure atleast one argument is given

if [ "$#" -eq 0 ]; then
	echo "No files specified for deletion."

	exit 1

fi


#Iterate over each value to delete output logs

echo "Deleting output logs"
for file in "$@"; do
	if [ -e "/work/shnsk95/Output_logs/${file}_output.log" ]; then
		rm "/work/shnsk95/Output_logs/${file}_output.log"
		echo "Deleted: ${file}_output.log"
	else
		echo "File not found: ${file}_output.log"
	fi
done




#Iterate over each value to delete error logs

echo "Deleting error logs"
for file in "$@"; do
        if [ -e "/work/shnsk95/Error_logs/${file}_error.log" ]; then
                rm "/work/shnsk95/Error_logs/${file}_error.log"
                echo "Deleted: ${file}_error.log"
        else
                echo "File not found: ${file}_error.log"
        fi
done




#Iterate over each value to delete job logs

echo "Deleting job logs"
for file in "$@"; do
        if [ -e "/work/shnsk95/Job_logs/${file}.txt" ]; then
                rm "/work/shnsk95/Job_logs/${file}.txt"
                echo "Deleted: ${file}.txt"
        else
                echo "File not found: ${file}.txt"
        fi
done


echo "Finished"
