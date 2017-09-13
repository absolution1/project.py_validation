void dumpPlots(TString input_file_name, TString name_prepend){

  TFile *file = new TFile(input_file_name,"READ");
  //TTree *tree = (TTree*) file->Get("tree");

  //Get job time elapsed first (convert to minutes)

  TCanvas *c1 = new TCanvas("c1","c1");
  /*
  tree->Draw("job_time_elapsed/60.");
  TH1F *h_jobTimeElapsed = (TH1F*)gPad->GetPrimitive("htemp")->Clone("h_jobTimeElapsed");
  h_jobTimeElapsed->SetTitle("Run time of grid jobs (minutes)");
  h_jobTimeElapsed->GetXaxis()->SetTitle("Job time (minutes)");
  h_jobTimeElapsed->GetYaxis()->SetTitle("No. jobs");
  */
  TH1F *h_jobTimeElapsed = (TH1F*) file->Get("h_jobTimeElapsed");
  h_jobTimeElapsed->Draw();
  c1->SaveAs(name_prepend+"h_jobTimeElapsed.png");
  c1->SaveAs(name_prepend+"h_jobTimeElapsed.pdf");



  //LAr CPU time (in minutes)
  /*
  tree->Draw("lar_cpu_time/60.");
  TH1F *h_LArCPUTime = (TH1F*) gPad->GetPrimitive("htemp")->Clone("h_LArCPUTime");
  h_LArCPUTime->SetTitle("CPU time of LAr jobs");
  h_LArCPUTime->GetXaxis()->SetTitle("LAr CPU time (minutes)");
  h_LArCPUTime->GetYaxis()->SetTitle("No. jobs");
  */
  TH1F *h_LArCPUTime = (TH1F*) file->Get("h_LArCPUTime");

  h_LArCPUTime->Draw();
  c1->SaveAs(name_prepend+"h_LArCPUTime.png");
  c1->SaveAs(name_prepend+"h_LArCPUTime.pdf");


  //LAr real time (in minutes)
  /*
  tree->Draw("lar_real_time/60.");
  TH1F *h_LArRealTime = (TH1F*) gPad->GetPrimitive("htemp")->Clone("h_LArRealTime");
  h_LArRealTime->SetTitle("Real time of LAr jobs");
  h_LArRealTime->GetXaxis()->SetTitle("LAr real time (minutes)");
  h_LArRealTime->GetYaxis()->SetTitle("No. jobs");
  */
  TH1F *h_LArRealTime = (TH1F*) file->Get("h_LArRealTime");

  h_LArRealTime->Draw();
  c1->SaveAs(name_prepend+"h_LArRealTime.png");
  c1->SaveAs(name_prepend+"h_LArRealTime.pdf");


  //LAr peak memory (in MB)
  /*
  tree->Draw("lar_peak_memory");
  TH1F *h_LArPeakMemory = (TH1F*) gPad->GetPrimitive("htemp")->Clone("h_LArPeakMemory");
  h_LArPeakMemory->SetTitle("Peak memory of LAr jobs");
  h_LArPeakMemory->GetXaxis()->SetTitle("LAr peak memory (MB)");
  h_LArPeakMemory->GetYaxis()->SetTitle("No. jobs");
  */
  TH1F *h_LArPeakMemory = (TH1F*) file->Get("h_LArPeakMemory");

  h_LArPeakMemory->Draw();
  c1->SaveAs(name_prepend+"h_LArPeakMemory.png");
  c1->SaveAs(name_prepend+"h_LArPeakMemory.pdf");





  //Write the hists to an output file
  file->Close();


  return;
}
