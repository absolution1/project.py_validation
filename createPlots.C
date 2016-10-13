{
  //Script tries to make plots from a ttree containing info about project.py jobs
  //Script assumes TFile has already been created (called _file0)

  //gROOT->SetStyle("T2K");

  TTree *tree = (TTree*) _file0->Get("tree");

  //Get job time elapsed first (convert to minutes)

  tree->Draw("job_time_elapsed/60.");
  TH1F *h_jobTimeElapsed = (TH1F*)gPad->GetPrimitive("htemp");
  h_jobTimeElapsed->SetName("h_jobTimeElapsed");
  h_jobTimeElapsed->SetTitle("Run time of grid jobs (minutes)");

  h_jobTimeElapsed->GetXaxis()->SetTitle("Job time (minutes)");
  h_jobTimeElapsed->GetYaxis()->SetTitle("No. jobs");

  //Write the hists to an output file
  TFile *outfile = new TFile("projectpyplots.root","RECREATE");
  h_jobTimeElapsed->Write();
  outfile->Close();
}
