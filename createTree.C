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

  ifstream inLArStats;
//inLArStats.open(Form("%slar_stats.txt",dir.Data()));
  inLArStats.open("lar_stats.txt");

  double lar_cpu_time, lar_real_time, lar_peak_memory;
  std::map<TString, std::vector<double> > larStatsMap;
  while ( inLArStats >> jobid >> lar_cpu_time >> lar_real_time >> lar_peak_memory){
    larStatsMap[jobid].push_back(lar_cpu_time);
    larStatsMap[jobid].push_back(lar_real_time);
    larStatsMap[jobid].push_back(lar_peak_memory);
  }


  //Create a TFile and TTree to hold the values
  TFile *file = new TFile("projectpytree.root","RECREATE");
  TTree *tree = new TTree("tree","tree"); 
  tree->Branch("job_start_time",&job_start_time);
  tree->Branch("job_end_time",&job_end_time);
  tree->Branch("job_time_elapsed",&job_time_elapsed);
  tree->Branch("lar_cpu_time",&lar_cpu_time);
  tree->Branch("lar_real_time",&lar_real_time);
  tree->Branch("lar_peak_memory",&lar_peak_memory);

  for (std::map<TString,std::vector<int> >::const_iterator jobTimeIt = jobTimeMap.begin(); jobTimeIt != jobTimeMap.end(); jobTimeIt++){
    job_start_time = (*jobTimeIt).second[0];
    job_end_time = (*jobTimeIt).second[1];
    job_time_elapsed = (*jobTimeIt).second[2];

    //Now extract the lar stuff using the map key
    TString key = (*jobTimeIt).first;

    lar_cpu_time = larStatsMap[key][0];
    lar_real_time = larStatsMap[key][1];
    lar_peak_memory = larStatsMap[key][2];

    tree->Fill();
  }

  tree->Write();
  file->Close();

}
