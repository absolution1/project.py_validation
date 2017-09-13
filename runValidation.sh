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
echo "Running project.py to get project directory"
#OUTPUTDIR="$(python getOutputDir.py $PARSERCMD)"
OUTPUTDIR=`project.py $PARSERCMD --outdir`
echo "---The project directory is $OUTPUTDIR"
#echo $OUTPUTDIR

#Check that the validation output directory is empty
VALOUTPUTDIR="$OUTPUTDIR/../validation/$STAGE"
echo "---The validation output directory is: $VALOUTPUTDIR"
mkdir -p $VALOUTPUTDIR
DIRCONTENT=`ls -A $VALOUTPUTDIR | wc -l`
if [ $DIRCONTENT -ne 0 ]
then
  echo "Validation output directory is not empty.  Exiting!!!!"
  exit 1
fi

#Now reconstruct the list of job ids from the directory (also reconstructes directory structure)
echo "Running: getAllJobIDs.sh"
getAllJobIDs.sh $OUTPUTDIR

#Get info on the LAr jobs (currently LAr time and memory).  Dumps info to a text file called lar_stats.txt
echo "Running: getLArStats.sh"
getLArStats.sh jobids.txt $OUTPUTDIR

#Now dump the job id and job time elapsed into the text file (called job_time_elapsed.txt)
echo "Running: getJobTimes.sh"
getJobTimes.sh jobids.txt

#Create the output tree which will hold the data
echo "Running: runCreateTree.C"
root -l -b -q runCreateTree.C

#Now create the plots
echo "Running: createPlots.C"
root -l -b -q projectpytree.root createPlots.C

#Now dump the plots to picture files
echo "Running: dumpPlots.C"
root -l -b -q "dumpPlots.C(\"projectpyplots.root\",\"${STAGE}_\")"

#Now copy the stuff to the project.py project directory
echo "Moving output to $VALOUTPUTDIR"
#ifdh cp -D projectpytree.root $VALOUTPUTDIR/.
#ifdh cp -D projectpyplots.root $VALOUTPUTDIR/.
#ifdh cp -D job_time_elapsed.txt $VALOUTPUTDIR/.
#ifdh cp -D jobids.txt $VALOUTPUTDIR/.
##ifdh cp -D jobfolders.txt $VALOUTPUTDIR/.
#ifdh cp -D lar_stats.txt $VALOUTPUTDIR/.

cp projectpytree.root $VALOUTPUTDIR/.
cp projectpyplots.root $VALOUTPUTDIR/.
cp job_time_elapsed.txt $VALOUTPUTDIR/.
cp jobids.txt $VALOUTPUTDIR/.
#ifdh cp -D jobfolders.txt $VALOUTPUTDIR/.
cp lar_stats.txt $VALOUTPUTDIR/.
cp *.pdf $VALOUTPUTDIR/.
cp *.png $VALOUTPUTDIR/.


#Tidy up the directory
rm createTree_C*
rm job_time_elapsed.txt 
rm jobids.txt
#rm jobfolders.txt
rm lar_stats.txt
rm projectpytree.root
rm projectpyplots.root
rm *.pdf
rm *.png
