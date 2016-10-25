#!/bin/bash

#Short script which takes a project.py directory and tries to work out the grid job ids for every job run
#Takes only one argument

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

#Assume the one argument which is the output directory of a project.py job
OUTPUTDIR="$1"

#This script will produce a text file called jobids.txt.  If it already exists, delete it
if [ -f jobids.txt ]
then
 echo "$0: jobids.txt already exists.  Deleting!"
 rm jobids.txt
fi

#This script will produce a text file called jobfolders.txt.  If it already exists, delete it
if [ -f jobfolders.txt ]
then
 echo "$0: jobfolders.txt already exists.  Deleting!"
 rm jobfolders.txt
fi


#There should be a jobids.list folder in this directory

if [ ! -f $OUTPUTDIR/jobids.list ]
then
  echo "$0: no jobids.list found in $OUTPUTDIR"
  echo "Exiting!"
  exit 1
fi

#Last time I checked, jobids.list should only ever have 1 entry which is the first grid job id.  So get that then we can cut it up and build the job id list

FIRSTJOBID=`cat $OUTPUTDIR/jobids.list`

#example job id is 14044890.0@fifebatch2.fnal.gov
#The aim is to extract 14044890 (the cluster ID)
#Split the job id by the . and take the first element in the subsequent array
JOBIDARRAYPERIOD=(${FIRSTJOBID//./ })
CLUSTERID=${JOBIDARRAYPERIOD[0]}

#We are also going to need the fifebatch address to construct the full jobid
#Follow the above routine but split on @
JOBIDARRAYAT=(${FIRSTJOBID//@/ })
BATCHADDRESS=${JOBIDARRAYAT[1]}

#Unless project.py changes, the output directory should contain a bunch of folders named $CLUSTERID_*.  Loop over the folders and extract the process ID for each job
for PATH_CLUSTER_PROCESS in $(ls -d  $OUTPUTDIR/${CLUSTERID}_*)
do
  #Get just the folder name (using base name
  CLUSTER_PROCESS=`basename $PATH_CLUSTER_PROCESS`
  #Now split the CLUSTER_PROCESS string on the _
  CLUSTER_PROCESS_ARRAY=(${CLUSTER_PROCESS//_/ })
  PROCESSID=${CLUSTER_PROCESS_ARRAY[1]}

  JOBID="$CLUSTERID.$PROCESSID@$BATCHADDRESS"
  echo "$JOBID" >> jobids.txt

#echo ${OUTPUTDIR}/${CLUSTERID}_${PROCESSID} >> jobfolders.txt
done
