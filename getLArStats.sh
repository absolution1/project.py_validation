#!/bin/bash

#Script takes a list of job ids and an output directory and extracts info about the lar jobs run (currently pulls out time and memory use).  Info dumped to a text file called lar_stats.txt


if [ -z "$1" ]
then
  echo "$0: No argument passed.  Exiting!"
  exit 1
fi

if [ -n "$3" ]
then
 echo "$0: Too many arguments passed.  The script takes a text file and a single directory as arguments.  Exiting!"
 exit 1
fi


#check if the output file we are going to make already exists.  If it does, delete it
if [ -f lar_stats.txt ]
then
 echo "$0: lar_stats.txt already exists.  Deleting!"
 rm lar_stats.txt
fi

#Assume the first input is the folder structure for the jobs
JOBIDS="$1"
#Assume the second input is the output directory
OUTPUTDIR="$2"

#Loop over the folders
for JOBID in $(cat $JOBIDS)
do
  #Reconstruct the folder directory from the job directory
  JOBIDARRAY=(${JOBID//./ })
  CLUSTER=${JOBIDARRAY[0]}
  PROCESSARRAY=(${JOBIDARRAY[1]//@/ })
  PROCESS="${PROCESSARRAY[0]}"
  FOLDER="$OUTPUTDIR/${CLUSTER}_${PROCESS}"
  #Easiest to shove the contents of lar.out into a new text file that we can interrogate (will mean we aren't hammering dcache too much)
  cat $FOLDER/larStage0.out > temp_lar.out

  #Get time stuff
  TIMELINE=`cat temp_lar.out | grep "TimeReport CPU"`
  TIMELINEARRAY=(${TIMELINE// / })
  CPUTIME="${TIMELINEARRAY[3]}"
  REALTIME="${TIMELINEARRAY[6]}"

  #Get memory stuff
#PEAKMEMORYLINE=`cat temp_lar.out | grep "Peak virtual memory usage (VmPeak)"`
#PEAKMEMORYLINEARRAY=(${PEAKMEMORYLINE// / })
#PEAKMEMORY="${PEAKMEMORYLINEARRAY[5]}"
  PEAKMEMORY=`cat temp_lar.out | grep "Peak virtual memory usage (VmPeak)" | awk -F':' '{print $2}' | awk -F' ' '{print $1}'`

  #Check if the variables are empty
  if [ -z "$CPUTIME" ]
  then
    echo "For JOBID: $JOBID, CPUTIME IS EMPTY.  SET EQUAL TO -1"
    CPUTIME="-1"
  fi
  if [ -z "$REALTIME" ]
  then
    echo "For JOBID: $JOBID, REALTIME IS EMPTY.  SET EQUAL TO -1"
    REALTIME="-1"
  fi
  if [ -z "$PEAKMEMORY" ]
  then
    echo "For JOBID: $JOBID, PEAKMEMORY IS EMPTY.  SET EQUAL TO -1"
    PEAKMEMORY="-1"
  fi

  #DUMP IT ALL!!!
  echo "$JOBID $CPUTIME $REALTIME $PEAKMEMORY" >> lar_stats.txt


  #Remove the temporary file we just made
  rm temp_lar.out
done



