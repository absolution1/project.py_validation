#!/bin/bash

#Get the command line arguments
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
  --xml)
  XML="$2"
  shift
  ;;
  --stage)
  STAGE="$2"
  shift
  ;;
  --project)
  PROJECT="$2"
  shift
  ;;
  *)

  ;;
esac
shift
done

#xml and stage are required arguments so check they exist
if [ -z "$XML" ]
then
  echo "No xml file specified.  Specify one with --xml XMLFILE"
  exit 1
fi

if [ -z "$STAGE" ]
then
  echo "No stage specified.  Specify one with --stage STAGENAME"
  exit 1
fi

#Create the command to give to the parser
PARSERCMD="--xml $XML --stage $STAGE"
if [ -n "$PROJECT" ]
then
  PARSERCMD="$PARSERCMD --project $PROJECT"
fi



#Now call the parser using the created command to get the output DIR
echo "Running: getOutputDir.py"
OUTPUTDIR="$(python getOutputDir.py $PARSERCMD)"

#Now reconstruct the list of job ids from the directory
echo "Running: getAllJobIDs.sh"
getAllJobIDs.sh $OUTPUTDIR

#Now dump the job id and job time elapsed into the text file (called job_time_elapsed.txt)
echo "Running: getJobTimes.sh"
getJobTimes.sh jobids.txt

#Create the output tree which will hold the data
echo "Running: runCreateTree.C"
root -l -q runCreateTree.C

#Now create the plots
root -l -q projectpytree.root createPlots.C

#Tidy up the directory
rm createTree_C*
rm job_time_elapsed.txt 
rm jobids.txt
