#!/usr/bin/expect -f

#To run this script, you must already have MADGRAPH and set up the process pp->Higgs through a top loop by working through section 3 of https://github.com/cms-tamu/MuJetAnalysis_Samples_13TeV_01/blob/master/README.md .  You will also need to place replace_lifetime_in_LHE.py (https://github.com/cms-tamu/MuJetAnalysis/blob/master/GenProduction/python/replace_lifetime_in_LHE.py) in the BRIDGE directory.

#You will also need to change the filepath on lines 30 and 134.

set timeout 86400

#user inputs
send_user "Mass of GammaD (string): "
expect_user -re "(.*)\n" {set MASS $expect_out(1,string)}

send_user "Mass of GammaD (GeV): "
expect_user -re "(.*)\n" {set GEV $expect_out(1,string)}

send_user "Username: "
expect_user -re "(.*)\n" {set USER $expect_out(1,string)}

stty -echo
send_user "Password: "
expect_user -re "(.*)\n" {set PASSWORD $expect_out(1,string)}

send_user "\n"

################
spawn ssh -X -Y $USER@lxplus.cern.ch
expect "Password: "
send "$PASSWORD\r"
expect "$ "
send "cd /afs/cern.ch/work/b/bmichlin/public/withJamal/CMSSW_7_3_1_patch2/src\r"
expect "$ "
send "cmsenv\r"
expect "$ "
send "cd MG_ME_V4.5.2\r"
expect "$ "
send "cp -r Models/usrmod Models/usrmod_DarkSusy_mH_125_mGammaD_$MASS\r"
expect "$ "
send "sed -i 's/#MODEL EXTENSION/#MODEL EXTENSION\\nn1      n1        F        S      MN1   WN1     S    n1   3000001\\nn2      n2        F        S      MN2   WN2     S    n2   3000002\\nzd      zd        V        W      MZD   WZD     S    zd   3000022\\nmu1-    mu1+      F        S      MMU1  WMU1    S    mu1  3000013\\n/g' Models/usrmod_DarkSusy_mH_125_mGammaD_$MASS/particles.dat\r"
expect "$ "
send "cd Models/usrmod_DarkSusy_mH_125_mGammaD_$MASS\r"
expect "$ "
send "sed -i 's/#   USRVertex/#   USRVertex\\nn2   n2   h    GHN22   QED\\nn2   n1   zd   GZDN12  QED\\nmu1- mu1- zd   GZDL    QED/g' interactions.dat\r"
expect "$ "
send "sed -i 's/ta- ta- h GHTAU QED/#ta- ta- h GHTAU QED/g' interactions.dat\r"
expect "$ "
send "sed -i 's/b   b   h GHBOT QED/#b   b   h GHBOT QED/g' interactions.dat\r"
expect "$ "
send "sed -i 's/t   t   h GHTOP QED/#t   t   h GHTOP QED/g' interactions.dat\r"
expect "$ "
send "sed -i 's/w- w+ h  GWWH  QED/#w- w+ h  GWWH  QED/g' interactions.dat\r"
expect "$ "
send "sed -i 's/z  z  h  GZZH  QED/#z  z  h  GZZH  QED/g' interactions.dat\r"
expect "$ "
#Redefine Model Couplings
send "./ConversionScript.pl\r"
expect "Need to keep old couplings.f and param_card.dat? yes or no: "
send "yes\r"
expect "$ "
send "sed -i 's/GHN22(1)=dcmplx(1d0,Zero)/GHN22(1)=dcmplx(1d-3,Zero)/g' couplings.f\r"
expect "$ "
send "sed -i 's/GHN22(2)=dcmplx(1d0,Zero)/GHN22(2)=dcmplx(1d-3,Zero)/g' couplings.f\r"
expect "$ "
send "sed -i 's/GZDN12(1)=dcmplx(1d0,Zero)/GZDN12(1)=dcmplx(1d-3,Zero)/g' couplings.f\r"
expect "$ "
send "sed -i 's/GZDN12(2)=dcmplx(1d0,Zero)/GZDN12(2)=dcmplx(1d-3,Zero)/g' couplings.f\r"
expect "$ "
send "sed -i 's/GZDL(1)=dcmplx(1d0,Zero)/GZDL(1)=dcmplx(1d-3,Zero)/g' couplings.f\r"
expect "$ "
send "sed -i 's/GZDL(2)=dcmplx(1d0,Zero)/GZDL(2)=dcmplx(1d-3,Zero)/g' couplings.f\r"
expect "$ "
send "sed -i 's/25     1.20000000E+02   # H        mass/25     1.25000000E+02   # H        mass/g' param_card.dat\r"
expect "$ "
send "sed -i 's/3000001     1.00000000e+02   # MN1/3000001     1.00000000e+00   # MN1/g' param_card.dat\r"
expect "$ "
send "sed -i 's/3000002     1.00000000e+02   # MN2/3000002     1.00000000e+01   # MN2/g' param_card.dat\r"
expect "$ "
send "sed -i 's/3000022     1.00000000e+02   # MZD/3000022     $GEV   # MZD/g' param_card.dat\r"
expect "$ "
send "sed -i 's/3000013     1.00000000e+02   # MMU1/3000013     1.05000000e-01   # MMU1/g' param_card.dat\r"
expect "$ "
send "sed -i 's/DECAY   3000001     1.00000000e+00   # WN1/DECAY   3000001     0.00000000e+00   # WN1/g' param_card.dat\r"
expect "$ "
send "sed -i 's/DECAY   3000013     1.00000000e+00   # WMU1/DECAY   3000013     0.00000000e+00   # WMU1/g' param_card.dat\r"
expect "$ "
send "sed -i 's/DECAY        25     6.79485838E-03   # H   width/DECAY        25     1.00000000e+00   # H   width/g' param_card.dat\r"
expect "$ "
#interact
send "make couplings\r"
expect "$ "
send "./couplings\r"
expect "$ "
send "cd ../../BRIDGE/\r"
expect "$ "
send "./runBRI.exe\r"
expect "Would you like to run from a MadGraph Model directory? (Y/N) "
send "Y\r"
expect "What is the name of the model directory(assuming that it is a subdirectory of Models/): "
send "usrmod_DarkSusy_mH_125_mGammaD_$MASS\r"
expect "Do you wish to generate decay tables for all particles listed above or a subset?(type 1 for all, 2 for subset)"
send "2\r"
expect "Please enter particles you wish to create decay tables for, you must explicitly enter antiparticles if you want BRI to generate their decay tables, otherwise use antigrids.pl: (type 'done' when finished)"
send "h\r"
sleep 2
send "n2\r"
sleep 2
send "zd\r"
sleep 2
send "done\r"
expect "Please enter a random number seed or write 'time' to use the time"
send "1234\r"
expect "The default number of Vegas calls is 50000. Would you like to change this? (Y/N) "
send "n\r"
expect "The default max. number of Vegas iterations is 5. Would you like to change this? (Y/N) "
send "n\r"
expect "Would you like to calculate three-body widths even for particles with open 2-body channels? (Y/N) "
send "n\r"
#expect "Decay table appears to already exist. Should we recreate it? Type 'yes' if so, otherwise we will exit."
#send "yes\r"
#expect "Decay table appears to already exist. Should we recreate it? Type 'yes' if so, otherwise we will exit."
#send "yes\r"
#expect "Decay table appears to already exist. Should we recreate it? Type 'yes' if so, otherwise we will exit."
#send "yes\r"
expect "Do you wish to replace the values of the param_card.dat widths, with the values stored in slha.out?(Y/N)"
send "y\r"
expect "Do you wish to keep a copy of the old param_card.dat?(Y/N) "
send "y\r"
expect "$ "
send "./runDGE.exe\r"
expect "Would you like to run from a MadGraph Model directory? (Y/N) "
send "Y\r"
expect "What is the name of the model directory(assuming that it is a subdirectory of Models/): "
send "usrmod_DarkSusy_mH_125_mGammaD_$MASS\r"
expect "What is the name of the input event file(include path if directory is different from where DGE is running)? "
send "/afs/cern.ch/work/b/bmichlin/public/withJamal/CMSSW_7_3_1_patch2/src/MG_ME_V4.5.2/pp_to_Higgs_HEFT_Model/Events/ggToHiggs_mH_125_13TeV_madgraph452_events80k_unweighted_events.lhe\r"
expect "What is the name of the output event file(include path if directory is different from where DGE is running)? "
send "DarkSUSY_mH_125_mGammaD_$MASS\_13TeV-madgraph452_bridge224_events80k.lhe\r"
expect "Please enter a random number seed or write 'time' to use the time"
send "12345\r"
expect "Which mode? "
send "2\r"
expect "Which mode? "
send "2\r"
expect "Enter a final-state particle name, or \"END\" to finish: "
send "mu1+\r"
expect "Enter a final-state particle name, or \"END\" to finish: "
send "mu1-\r" 
expect "Enter a final-state particle name, or \"END\" to finish: "
send "END\r"
expect "Would you like to save the list of final-state particles? (Y/N) "
send "Y\r"
expect "What file name do you want to save to?"
sleep 1
send "DarkSUSY_mH_125_mGammaD_$MASS\_13TeV-madgraph452_bridge224_ListFinalStateParticles.txt\r"
expect "$ "
sleep 1
send "sed -i 's/3000013 /13 /g' DarkSUSY_mH_125_mGammaD_$MASS\_13TeV-madgraph452_bridge224_events80k.lhe\r"
expect "$ "
sleep 1
send "sed -i '/filename =/c \\filename = \"DarkSUSY_mH_125_mGammaD_$MASS\_13TeV-madgraph452_bridge224_events80k.lhe\"' replace_lifetime_in_LHE.py\r"
expect "$ "
sleep 1
send "sed -i 's/ctau_mean_mm = 5.0/ctau_mean_mm = 0.05/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_005_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 0.05/ctau_mean_mm = 0.1/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_010_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 0.1/ctau_mean_mm = 0.2/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_020_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 0.2/ctau_mean_mm = 0.5/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_050_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 0.5/ctau_mean_mm = 1/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_100_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 1/ctau_mean_mm = 2/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_200_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 2/ctau_mean_mm = 3/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_300_madgraph452_bridge224_events80k.lhe\r"
expect "$ "

send "sed -i 's/ctau_mean_mm = 3/ctau_mean_mm = 5.0/g' replace_lifetime_in_LHE.py\r"
expect "$ "
send "python replace_lifetime_in_LHE.py > DarkSUSY_mH_125_mGammaD_$MASS\_13TeV_cT_500_madgraph452_bridge224_events80k.lhe\r"
expect "$ "
