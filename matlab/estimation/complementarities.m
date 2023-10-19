% load in the data 
clearvars;
cd '/Users/Alex/Documents/replicationfiles/estimation'
load('data.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES - C.1 - COMPLEMENTARITIES -> TABLE 3
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

% the code can be repeated for other specs by loading in e.g. Spec1.mat
% instead 
load('Spec3.mat');

% reshape the standard errors into a matrix 
Spec3.SE_Z_est = reshape(Spec3res.SE_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);

% SE's are rows 1:36 of the vector put into a 6x6
% Get covariance terms from the hessian
covs = sqrt(inv(Spec3res.H));

% preallocate the ethnicity complementarity matrix (including SEs)
ethc = zeros(8,3);

% wbll
comp = Spec3.Z_est(1,1) + Spec3.Z_est(3,3) - (Spec3.Z_est(1,3) + Spec3.Z_est(3,1));
se = Spec3.SE_Z_est(1,1) + real(Spec3.SE_Z_est(3,3)) + 2*real(covs(1,15)) + Spec3.SE_Z_est(1,3) + Spec3.SE_Z_est(3,1) - 2*real(covs(1,13)) - 2*real(covs(1,3)) - 2*real(covs(13,15)) - 2*real(covs(3,15)) + 2*real(covs(3,13));
ethc(1,1) = comp;
ethc(2,1) = se;
clear comp se;

% wall
comp = Spec3.Z_est(1,1) + Spec3.Z_est(5,5) - (Spec3.Z_est(1,5) + Spec3.Z_est(5,1));
% covs +(1,1 5,5) - (1,1 1,5) - (1,1 5,1) - (5,5 1,5) - (5,5 5,1) + (1,5 5,1)
se = Spec3.SE_Z_est(1,1) + real(Spec3.SE_Z_est(5,5)) + Spec3.SE_Z_est(1,5) + Spec3.SE_Z_est(5,1) + 2*real(covs(1,29)) - 2*real(covs(1,25)) - 2*real(covs(1,5)) - 2*real(covs(29,25)) - 2*real(covs(29,5)) + 2*real(covs(25,5));
ethc(1,2) = comp;
ethc(2,2) = se;
clear comp se;

% ball
comp = Spec3.Z_est(3,3) + Spec3.Z_est(5,5) - (Spec3.Z_est(3,5) + Spec3.Z_est(5,3));
% covs +(3,3 5,5) - (3,3 3,5) - (3,3 5,3) - (5,5 3,5) - (5,5 5,3) + (3,5 5,3)
se = Spec3.SE_Z_est(3,3) + real(Spec3.SE_Z_est(5,5)) + Spec3.SE_Z_est(3,5) + Spec3.SE_Z_est(5,3) + 2*real(covs(15,29)) - 2*real(covs(15,27)) - 2*real(covs(15,17)) - 2*real(covs(29,27)) - 2*real(covs(29,17)) + 2*real(covs(27,17));
ethc(1,3) = comp;
ethc(2,3) = se;
clear comp se;

% wbhl
rowa = 2;
cola = 2; 
rowd = 3;
cold = 3;
rowb = 2;
colb = 3;
rowc = 3;
colc = 2; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
% covs +(2,2 3,3) - (2,2 2,3) - (2,2 3,2) - (3,3 2,3) - (3,3 3,2) + (2,3 3,2)
se = Spec3.SE_Z_est(rowa,cola) + real(Spec3.SE_Z_est(rowd,cold)) + Spec3.SE_Z_est(rowb,colb) + Spec3.SE_Z_est(rowc,colc) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(3,1) = comp;
ethc(4,1) = se;
clear comp se;

% wahl
rowa = 2;
cola = 2; 
rowd = 5;
cold = 5;
rowb = 2;
colb = 5;
rowc = 5;
colc = 2; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = Spec3.SE_Z_est(rowa,cola) + real(Spec3.SE_Z_est(rowd,cold)) + Spec3.SE_Z_est(rowb,colb) + Spec3.SE_Z_est(rowc,colc) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(3,2) = comp;
ethc(4,2) = se;
clear comp se;

% bahl
rowa = 4;
cola = 4; 
rowd = 5;
cold = 5;
rowb = 4;
colb = 5;
rowc = 5;
colc = 4; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(3,3) = comp;
ethc(4,3) = se;
clear comp se;

% wblh
rowa = 1;
cola = 1; 
rowd = 4;
cold = 4;
rowb = 1;
colb = 4;
rowc = 4;
colc = 1; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(5,1) = comp;
ethc(6,1) = se;
clear comp se;

% walh
rowa = 1;
cola = 1; 
rowd = 6;
cold = 6;
rowb = 1;
colb = 6;
rowc = 6;
colc = 1; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(5,2) = comp;
ethc(6,2) = se;
clear comp se;

% balh
rowa = 3;
cola = 3; 
rowd = 6;
cold = 6;
rowb = 3;
colb = 6;
rowc = 6;
colc = 3; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(5,3) = comp;
ethc(6,3) = se;
clear comp se;

% wbhh
rowa = 2;
cola = 2; 
rowd = 4;
cold = 4;
rowb = 2;
colb = 4;
rowc = 4;
colc = 2; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(7,1) = comp;
ethc(8,1) = se;
clear comp se;

% wahh
rowa = 2;
cola = 2; 
rowd = 6;
cold = 6;
rowb = 2;
colb = 6;
rowc = 6;
colc = 2; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(7,2) = comp;
ethc(8,2) = se;
clear comp se;

% bahh
rowa = 4;
cola = 4; 
rowd = 6;
cold = 6;
rowb = 4;
colb = 6;
rowc = 6;
colc = 4; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
ethc(7,3) = comp;
ethc(8,3) = se;
clear comp se;

% preallocate the qualification complementarity matrix (including SEs)
qualc = zeros(6,3);
% qww
rowa = 1;
cola = 1; 
rowd = 2;
cold = 2;
rowb = 1;
colb = 2;
rowc = 2;
colc = 1; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
qualc(1,1) = comp;
qualc(2,1) = se;
clear comp se;

% qwb
rowa = 1;
cola = 3; 
rowd = 2;
cold = 4;
rowb = 1;
colb = 4;
rowc = 2;
colc = 3; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
qualc(1,2) = comp;
qualc(2,2) = se;
clear comp se;

% qwa
rowa = 1;
cola = 5; 
rowd = 2;
cold = 6;
rowb = 1;
colb = 6;
rowc = 2;
colc = 5; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
qualc(1,3) = comp;
qualc(2,3) = se;
clear comp se;

% qbw
rowa = 3;
cola = 1; 
rowd = 4;
cold = 2;
rowb = 3;
colb = 2;
rowc = 4;
colc = 1; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
qualc(3,1) = comp;
qualc(4,1) = se;
clear comp se;

% qbb
rowa = 3;
cola = 3; 
rowd = 4;
cold = 4;
rowb = 3;
colb = 4;
rowc = 4;
colc = 3; 
comp = Spec3.Z_est(rowa,cola) + Spec3.Z_est(rowd,cold) - (Spec3.Z_est(rowb,colb) + Spec3.Z_est(rowc,colc));
se = real(Spec3.SE_Z_est(rowa,cola)) + real(Spec3.SE_Z_est(rowd,cold)) + real(Spec3.SE_Z_est(rowb,colb)) + real(Spec3.SE_Z_est(rowc,colc)) + 2*real(covs(((cola-1)*6)+rowa,((cold-1)*6)+rowd)) - 2*real(covs(((cola-1)*6)+rowa,((colb-1)*6)+rowb)) - 2*real(covs(((cola-1)*6)+rowa,((colc-1)*6)+rowc)) - 2*real(covs(((cold-1)*6)+rowd,((colb-1)*6)+rowb)) - 2*real(covs(((cold-1)*6)+rowd,((colc-1)*6)+rowc)) + 2*real(covs(((colb-1)*6)+rowb,((colc-1)*6)+rowc));
qualc(3,2) = comp;
qualc(4,2) = se;
clear comp se;
