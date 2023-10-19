%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% C.7 - Predicted Shares of Intra-Ethnic Marriages - TABLE 4 -> TAB4.m
 
% load in the data 
clearvars;
load('spec3.mat');
load('data.mat');

% aggregate assortative matching  - men (change inputs for women)
numijm = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
nummar = zeros(6,6);
for r = 1:fxdpar.k
    %numijm(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,1,r)),6,1).*dat.F_pre(:,:,r);
    numijm(:,:,r) = repmat(dat.cnt_m(:,1,r),1,6).*pred3.Mm(:,:,r);
    nummar = nummar + numijm(:,:,r);
end 
clear r;

aswf = (nummar(1,1) + nummar(1,2) + nummar(2,1) + nummar(2,2)) / (sum(nummar(1,:)) + sum(nummar(2,:)));
%easwf = sqrt(aswf*(1-aswf)/(sum(nummar(:,1)) + sum(nummar(:,2))));

asbf = (nummar(3,3) + nummar(3,4) + nummar(4,3) + nummar(4,4)) / (sum(nummar(3,:)) + sum(nummar(4,:)));
%easbf = sqrt(asbf*(1-asbf)/(sum(nummar(:,3)) + sum(nummar(:,4))));

asaf = (nummar(5,5) + nummar(5,6) + nummar(6,5) + nummar(6,6)) / (sum(nummar(5,:)) + sum(nummar(6,:)));
%easaf = sqrt(asaf*(1-asaf)/(sum(nummar(:,5)) + sum(nummar(:,6))));

asql = (nummar(1,1) + nummar(1,3) + nummar(1,5) + nummar(3,1) + nummar(3,3) + nummar(3,5) + nummar(5,1) + nummar(5,3) + nummar(5,5)) / (sum(nummar(:,1)) + sum(nummar(:,3)) + sum(nummar(:,5))); 
asqh = (nummar(2,2) + nummar(2,4) + nummar(2,6) + nummar(4,2) + nummar(4,4) + nummar(4,6) + nummar(6,2) + nummar(6,4) + nummar(6,6)) / (sum(nummar(:,2)) + sum(nummar(:,4)) + sum(nummar(:,6)));

% group into a single matrix 
t = [t;aswf,asbf,asaf];








