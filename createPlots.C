{
  //Script tries to make plots from a ttree containing info about project.py jobs
  //Script assumes TFile has already been created (called _file0)

  //gROOT->SetStyle("T2K");

  TTree *tree = (TTree*) _file0->Get("tree");

  //Get job time elapsed first (convert to minutes)

  tree->Draw("job_time_elapsed/60.");
  TH1F *h_jobTimeElapsed = (TH1F*)gPad->GetPrimitive("htemp")->Clone("h_jobTimeElapsed");
  h_jobTimeElapsed->SetTitle("Run time of grid jobs (minutes)");

  h_jobTimeElapsed->GetXaxis()->SetTitle("Job time (minutes)");
  h_jobTimeElapsed->GetYaxis()->SetTitle("No. jobs");


  //LAr CPU time (in minutes)
  tree->Draw("lar_cpu_time/60.");
  TH1F *h_LArCPUTime = (TH1F*) gPad->GetPrimitive("htemp")->Clone("h_LArCPUTime");
  h_LArCPUTime->SetTitle("CPU time of LAr jobs");
  h_LArCPUTime->GetXaxis()->SetTitle("LAr CPU time (minutes)");
  h_LArCPUTime->GetYaxis()->SetTitle("No. jobs");

  //LAr real time (in minutes)
  tree->Draw("lar_real_time/60.");
  TH1F *h_LArRealTime = (TH1F*) gPad->GetPrimitive("htemp")->Clone("h_LArRealTime");
  h_LArRealTime->SetTitle("Real time of LAr jobs");
  h_LArRealTime->GetXaxis()->SetTitle("LAr real time (minutes)");
  h_LArRealTime->GetYaxis()->SetTitle("No. jobs");

  //LAr peak memory (in MB)
  tree->Draw("lar_peak_memory");
  TH1F *h_LArPeakMemory = (TH1F*) gPad->GetPrimitive("htemp")->Clone("h_LArPeakMemory");
  h_LArPeakMemory->SetTitle("Peak memory of LAr jobs");
  h_LArPeakMemory->GetXaxis()->SetTitle("LAr peak memory (MB)");
  h_LArPeakMemory->GetYaxis()->SetTitle("No. jobs");




  //Write the hists to an output file
  TFile *outfile = new TFile("projectpyplots.root","RECREATE");
  h_jobTimeElapsed->Write();
  h_LArCPUTime->Write();
  h_LArRealTime->Write();
  h_LArPeakMemory->Write();
  outfile->Close();
}
