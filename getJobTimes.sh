#!/bin/bash

#Script which takes a list of job ids as input and calculate the job time elapsed in seconds

if [ -z "$1" ]
then
  echo "$0: No argument passed.  Exiting!"
  exit 1
fi

if [ -n "$2" ]
then
 echo "$0: Too many arguments passed.  The script takes a single directory as an argument.  Exiting!"
 exit 1
fi

#We will need the user group for fetching the history
GROUP=`groups`

#check if the output file we are going to make already exists.  If it does, delete it
if [ -f job_time_elapsed.txt ]
then
 echo "$0: job_time_elapsed.txt already exists.  Deleting!"
 rm job_time_elapsed.txt
fi

#Assume the only input passed is a text file which contains jobids
JOBIDS="$1"

#Loop over the job ids
for JOBID in $(cat $JOBIDS)
do
  #call jobsub_history for the job id, pipe that into grep (also using the job id)
  HISTORYLINE=`jobsub_history -G $GROUP --user=$USER --jobid=$JOBID | grep $JOBID`
  NHISTORYLINE=`echo $HISTORYLINE | wc -l`
  if [ $NHISTORYLINE -ne 1 ]
  then 
    echo "$0: Could not find history for $JOBID.  Store start time, end time and  time elapsed as -1"
    echo "$JOBID -1 -1 -1" >> job_time_elapsed.txt
  fi
  HISTORYLINEARRAY=(${HISTORYLINE// / })
  #The start date and start time of the job are elements 2 and 3 respectively
  #Convert this time into seconds
  STARTTIME=`date -d ${HISTORYLINEARRAY[2]}T${HISTORYLINEARRAY[3]} +%s`
  #Similarly, end date and end time are elements 4 and 5 respectively
  #Convert to seconds
  ENDTIME=`date -d ${HISTORYLINEARRAY[4]}T${HISTORYLINEARRAY[5]} +%s`
  #Now work out the time elapsed
  TIMEELAPSED=$(( $ENDTIME-$STARTTIME ))
  echo "$JOBID $STARTTIME $ENDTIME $TIMEELAPSED" >> job_time_elapsed.txt
done
