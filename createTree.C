#include <map>
#include <vector>
#include <iterator>
#include <iostream>
#include <fstream>

#include "TString.h"
#include "TFile.h"
#include "TTree.h"
#include "TSystem.h"
void createTree(){
  TString dir = gSystem->UnixPathName(__FILE__);
  dir.ReplaceAll("createTree.C","");
  dir.ReplaceAll("/./","/");
  ifstream inJobTime;
  inJobTime.open(Form("%sjob_time_elapsed.txt",dir.Data()));

  TString jobid;
  int job_start_time, job_end_time, job_time_elapsed;

  std::map<TString,std::vector<int> > jobTimeMap;
  while (    inJobTime >> jobid >> job_start_time >> job_end_time >> job_time_elapsed) {
    jobTimeMap[jobid].push_back(job_start_time);
    jobTimeMap[jobid].push_back(job_end_time);
    jobTimeMap[jobid].push_back(job_time_elapsed);
  }

  //Create a TFile and TTree to hold the values
  TFile *file = new TFile("projectpytree.root","RECREATE");
  TTree *tree = new TTree("tree","tree"); 
  tree->Branch("job_start_time",&job_start_time);
  tree->Branch("job_end_time",&job_end_time);
  tree->Branch("job_time_elapsed",&job_time_elapsed);

  for (std::map<TString,std::vector<int> >::const_iterator jobTimeIt = jobTimeMap.begin(); jobTimeIt != jobTimeMap.end(); jobTimeIt++){
    job_start_time = (*jobTimeIt).second[0];
    job_end_time = (*jobTimeIt).second[1];
    job_time_elapsed = (*jobTimeIt).second[2];

    tree->Fill();

  }

  tree->Write();
  file->Close();

}
