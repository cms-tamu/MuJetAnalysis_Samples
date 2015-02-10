# MuJet Analysis Samples 13 TeV - Part 1

# Instructions

## 1. Set up new process with Madgraph

### 1.1. Download archive with pre-compiled Madgraph from github

<code>wget https://github.com/cms-tamu/MuJetAnalysis_Samples_13TeV_01/blob/master/MG_ME_V4.5.2_CompiledBackup/MG_ME_V4.5.2_CompiledBackup.tar.gz?raw=true -O MG_ME_V4.5.2_CompiledBackup.tar.gz</code>

### 1.2. Unzip and rename it to MG_ME_V4.5.2

<code>tar -xzf MG_ME_V4.5.2_CompiledBackup.tar.gz</code>

<code>mv MG_ME_V4.5.2_CompiledBackup MG_ME_V4.5.2</code>

### 1.3. Go to Madgraph folder:

<code>cd MG_ME_V4.5.2</code>

### 1.4. Create template for the process

Copy the <code>Template</code> directory to directory with new name, for example <code>pp_to_Higgs_HEFT_Model</code>, in order to keep a clean copy of the <code>Template</code>:

<code>cp -r Template pp_to_Higgs_HEFT_Model</code>

### 1.5. Set up process pp -> Higgs through a top loop

See details in http://madgraph.hep.uiuc.edu/EXAMPLES/Cards/proc_card_4.dat on Madgraph web http://madgraph.hep.uiuc.edu/EXAMPLES/proc_card_examples.html

Edit the file <code>pp_to_Higgs_HEFT_Model/Cards/proc_card.dat</code>:

> <code>pp>h  @1           # First Process</code>
> <br><code>QCD=99             # Max QCD couplings</code>
> <br><code>QED=0              # Max QED couplings</code>
> <br><code>HIG=1              # Max HIGGS EFT coupling: (now max is 1)</code>
> <br><code>end_coup           # End the couplings input</code>

NOTE: Don't forget to specify choice of model. In our test case it is <code>heft</code>:

> <code># Begin MODEL  # This is TAG. Do not modify this line</code>
> <br><code>heft</code>
> <br><code># End   MODEL  # This is TAG. Do not modify this line</code>

### 1.6. Setup the specified process

<code>cd pp_to_Higgs_HEFT_Model/bin</code>

<code>./newprocess</code>

NOTE: this will replace the file <code>pp_to_Higgs_HEFT_Model/Cards/param_card.dat</code> by the original <code>param_card.dat</code> for the model. In our case model is <code>"heft"</code>, so the original file is <code>MG_ME_V4.5.2/Models/heft/param_card.dat</code>.

### 1.7. Check the specified process

Use your web browser, by looking at <code>index.html</code> in the <code>pp_to_Higgs_HEFT_Model folder</code>:

<code>firefox pp_to_Higgs_HEFT_Model/index.html</code>

### 1.8. Specify the model parameters

The model parameters include masses and widths for particles and coupling constants. They are defined in file <code>param_card.dat</code> in the <code>MG_ME_V4.5.2/pp_to_Higgs_HEFT_Model/Cards</code> folder.

In our case adjust mass of Higgs to 125 GeV:

> <code>25     1.25000000E+02   # H        mass</code>

## 2. Generate Higgs events with Madgraph

### 2.1. Set generation parameters

Set beam type to protons, beam energy (6.5 TeV in this example), number of events and random seed in the file <code>pp_to_Higgs_HEFT_Model/Cards/run_card.dat</code>:

> <code> #*********************************************************************</code>
> <br><code> # Number of events and rnd seed                                      *</code>
> <br><code> #*********************************************************************</code>
> <br><code>     800000   = nevents ! Number of unweighted events requested </code>
> <br><code>     1234     = iseed   ! rnd seed (0=assigned automatically=default))</code>
> <br><code> #*********************************************************************</code>
> <br><code> # Collider type and energy                                           *</code>
> <br><code> #*********************************************************************</code>
> <br><code>        1     = lpp1  ! beam 1 type (0=NO PDF)</code>
> <br><code>        1     = lpp2  ! beam 2 type (0=NO PDF)</code>
> <br><code>     6500     = ebeam1  ! beam 1 energy in GeV</code>
> <br><code>     6500     = ebeam2  ! beam 2 energy in GeV</code>

### 2.2. Generate events with the process already set up

<code>cd pp_to_Higgs_HEFT_Model/bin</code>

<code>./generate_events</code>

This program asks 2 questions:

> <code>Enter 2 for multi-core, 1 for parallel, 0 for serial run</code>
> <br><code>0</code>
> <br><code>Enter run name</code>
> <br><code>ggToHiggs_mH_125_13TeV_madgraph452_events80k</code>

Generated events are stored in file <code>MG_ME_V4.5.2/pp_to_Higgs_HEFT_Model/Events/ggToHiggs_mH_125_13TeV_madgraph452_unweighted_events.lhe.gz</code>

Unzip this LHE file with generated <b>unweighted</b> events, it will be used in next steps:

<code>cd MG_ME_V4.5.2/pp_to_Higgs_HEFT_Model/Events</code>

<code>unzip ggToHiggs_mH_125_13TeV_madgraph452_unweighted_events.lhe.gz</code>

Repeat generation for other masses of Higgs. Suggested run names:

<code>ggToHiggs_mH_090_13TeV_madgraph452_events80k</code>
<br><code>ggToHiggs_mH_100_13TeV_madgraph452_events80k</code>
<br><code>ggToHiggs_mH_110_13TeV_madgraph452_events80k</code>
<br><code>ggToHiggs_mH_125_13TeV_madgraph452_events80k</code>
<br><code>ggToHiggs_mH_150_13TeV_madgraph452_events80k</code>

## 3. Create custom Dark SUSY model

In our example Higgs decays into two neutralinos <code>n2</code> that decay into dark neutralino <code>n1</code> (LSP) and dark photon <code>zd</code>. Dark photon decays into two muons.

### 3.1. Create template for the model

Copy folder <code>MG_ME_V4.5.2/Models/usrmod</code> with custom user model to new folder:

<code>cp -r Models/usrmod Models/usrmod_DarkSusy_mH_125</code>

### 3.2. Define model's particles

Edit <code>Models/usrmod_DarkSusy_mH_125/particles.dat</code>:

> <code> #MODEL EXTENSION</code>
> <br><code> n1      n1        F        S      MN1   WN1     S    n1   3000001</code>
> <br><code> n2      n2        F        S      MN2   WN2     S    n2   3000002</code>
> <br><code> zd      zd        V        W      MZD   WZD     S    zd   3000022</code>
> <br><code> mu1-    mu1+      F        S      MMU1  WMU1    S    mu1  3000013</code>
> <br><code> # END</code>

NOTE: Muon with new code <code>3000013</code> to make it massive

### 3.3. Define model's interactions

Edit <code>Models/usrmod_DarkSusy_mH_125/interaction.dat</code>.

Add new vertexes:

> <code> #   USRVertex</code>
> <br><code> n2   n2   h    GHN22   QED</code>
> <br><code> n2   n1   zd   GZDN12  QED</code>
> <br><code> mu1- mu1- zd   GZDL    QED</code>

Remove SM Higgs vertexes to exclude Higgs decays to SM particles:

> <code> # FFS (Yukawa)</code>
> <br><code> #ta- ta- h GHTAU QED</code>
> <br><code> #b   b   h GHBOT QED</code>
> <br><code> #t   t   h GHTOP QED</code>

> <code> #   VVS</code>
> <br><code> #w- w+ h  GWWH  QED</code>
> <br><code> #z  z  h  GZZH  QED</code>

### 3.4. Convert model

Run the shell script <code>./ConversionScript.pl</code>

### 3.5. Redefine model's couplings

Edit file <code>Models/usrmod_DarkSusy_mH_125/couplings.f</code>.

Change couplings from default <code>1</code> to some small number <code>0.001</code> (narrow width approximation).

> <code>c************************************</code>
> <br><code>c UserMode couplings</code>
> <br><code>c************************************</code>
> <br><code>      GHN22(1)=dcmplx(1d-3,Zero)</code>
> <br><code>      GHN22(2)=dcmplx(1d-3,Zero)</code>
> <br><code>      GZDN12(1)=dcmplx(1d-3,Zero)</code>
> <br><code>      GZDN12(2)=dcmplx(1d-3,Zero)</code>
> <br><code>      GZDL(1)=dcmplx(1d-3,Zero)</code>
> <br><code>      GZDL(2)=dcmplx(1d-3,Zero)</code>

### 3.6. Re-define particles' masses and decay widths

Edit file <code>Models/usrmod_DarkSusy_mH_125/param_card.dat</code>

1. Adjust mass of Higgs to 125 GeV, mass of n2 to 10 GeV, mass of n1 to 1 GeV, mass of zd to 400 MeV, mass of mu1 to 105 MeV
2. Set widths of stable particles n1 and mu1 set to 0
3. Set Higgs width to 1 and remove branchings to SM particles

> <code>        25     <b>1.25000000E+02</b>   # H        mass</code>
> <br><code>   3000001     <b>1.00000000e+00</b>   # MN1</code>
> <br><code>   3000002     <b>1.00000000e+01</b>   # MN2</code>
> <br><code>   3000022     <b>4.00000000e-01</b>   # MZD</code>
> <br><code>   3000013     <b>1.05000000e-01</b>   # MMU1</code>
> <br><code>#            PDG       Width</code>
> <br><code>DECAY   3000001     <b>0.00000000e+00</b>   # WN1</code>
> <br><code>DECAY   3000002     <b>1.00000000e+00</b>   # WN2</code>
> <br><code>DECAY   3000022     <b>1.00000000e+00</b>   # WZD</code>
> <br><code>DECAY   3000013     <b>0.00000000e+00</b>   # WMU1</code>
> <br><code>DECAY         6     1.51013490E+00   # top width</code>
> <br><code>DECAY        23     2.44639985E+00   # Z   width</code>
> <br><code>DECAY        24     2.03535570E+00   # W   width</code>
> <br><code>DECAY        25     <b>1.00000000e+00</b>   # H   width</code>

### 3.7. Compile model's couplings and run

<code>make couplings</code>

<code>./couplings</code>

## 4. Define decay table using BRIDGE

### 4.1. Go to the BRIDGE folder:

<code>cd MG_ME_V4.5.2/BRIDGE</code>

### 4.2. Run BRIDGE

<code>./runBRI.exe</code>

The program asks a few following questions:

> <code> Would you like to run from a MadGraph Model directory? (Y/N): Y</code>
> <br><code> What is the name of the model directory(assuming that it is a subdirectory of Models/): usrmod_DarkSusy_mH_125</code>
> <br><code> Do you wish to generate decay tables for all particles listed above or a subset?(type 1 for all, 2 for subset): 2</code>
> <br><code> Please enter particles you wish to create decay tables for, you must explicitly enter antiparticles if you want BRI to generate their decay tables, otherwise use antigrids.pl: (type 'done' when finished):</code>
> <br><code> h</code>
> <br><code> n2</code>
> <br><code> zd</code>
> <br><code> done</code>
> <br><code> Please enter a random number seed or write 'time' to use the time: 1234</code>
> <br><code> The default number of Vegas calls is 50000. Would you like to change this? (Y/N) n</code>
> <br><code> The default max. number of Vegas iterations is 5. Would you like to change this? (Y/N) n</code>
> <br><code> Would you like to calculate three-body widths even for particles with open 2-body channels? (Y/N) n</code>
> <br><code> Do you wish to replace the values of the param_card.dat widths, with the values stored in slha.out?(Y/N) y</code>
> <br><code> Do you wish to keep a copy of the old param_card.dat?(Y/N) y</code>

NOTE: the file <code>param_card.dat</code> was updated with new decay widths:

> <br><code> DECAY        25   4.77997464e-06   # h decays</code>
> <br><code> #          BR         NDA      ID1       ID2</code>
> <br><code>      1.00000000e+00    2     3000002   3000002   # BR(h -> n2 n2 )</code>
> <br><code> #</code>
> <br><code> DECAY   3000002   1.20714630e-04   # n2 decays</code>
> <br><code> #          BR         NDA      ID1       ID2</code>
> <br><code>      1.00000000e+00    2     3000001   3000022   # BR(n2 -> n1 zd )</code>
> <br><code> #</code>
> <br><code> DECAY   3000022   1.02272608e-08   # zd decays</code>
> <br><code> #          BR         NDA      ID1       ID2</code>
> <br><code>      1.00000000e+00    2     3000013  -3000013   # BR(zd -> mu1- mu1+ )</code>

        DECAY        25   4.77997464e-06   # h decays
        #          BR         NDA      ID1       ID2
             1.00000000e+00    2     3000002   3000002   # BR(h -> n2 n2 )
        #
        DECAY   3000002   1.20714630e-04   # n2 decays
        #          BR         NDA      ID1       ID2
             1.00000000e+00    2     3000001   3000022   # BR(n2 -> n1 zd )
        #
        DECAY   3000022   1.02272608e-08   # zd decays
        #          BR         NDA      ID1       ID2
              1.00000000e+00    2     3000013  -3000013   # BR(zd -> mu1- mu1+ )

## 5. Decay events generated in step 2 within this custom model

### 5.1. Run BRIDGE

<code>./runDGE.exe</code>

The program asks a few following questions:

<code>Would you like to run from a MadGraph Model directory? (Y/N) Y</code>

<code>What is the name of the model directory(assuming that it is a subdirectory of Models/):</code>
<br><code>usrmod_DarkSusy_mH_125</code>

<code>What is the name of the input event file(include path if directory is different from where DGE is running)?</code>
<br><code>[FUL PATH]/MG_ME_V4.5.2/pp_to_Higgs_HEFT_Model/Events/ggToHiggs_mH_125_13TeV_madgraph452_events80k_unweighted_events.lhe</code>

<code>What is the name of the output event file(include path if directory is different from where DGE is running)?</code>
<br><code>ggToHiggsTo2n1To2nD2aD_mH_125_13TeV_madgraph452_bridge224_events80k.lhe</code>

<code>Please enter a random number seed or write 'time' to use the time</code>
<br><code>12345</code>

<code>Choose a mode:</code>
<br><code>1. Decay a particular particle.</code>
<br><code>2. Decay down to a set of final-state particles.</code>
<br><code>3. Decay using a specified set of decay modes.</code>
<br><code>Which mode? 2</code>

<code>Choose an input method:</code>
<br><code>1. Read a file listing final-state particles.</code>
<br><code>2. Enter the list of final-state particles manually.</code>
<br><code>Which mode? 2</code>

NOTE: In this test example we want to decay particles to mu+mu- final states according to branching ratios.

<code>
Enter a final-state particle name, or "END" to finish: mu1+
</code>

<code>
Enter a final-state particle name, or "END" to finish: mu1-
</code>

<code>
Enter a final-state particle name, or "END" to finish: END
</code>

<code>
Would you like to save the list of final-state particles? (Y/N) Y
</code>

<code>
What file name do you want to save to? ggToHiggsTo2n1To2nD2aD_mH_125_ListFinalStateParticles.txt
</code>

### 5.2. Finally, we need to change our custom massive muon "mu1" to regular "mu".

Just search for codes <code>3000013</code> and <code>-3000013</code> in event file <code>test_out.lhe</code> and replace them with codes <code>13</code> and <code>-13</code>.
