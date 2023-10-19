clearvars; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION C: TABLES AND FIGURES 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% MARITAL STATUS AND PARTNER CHOICE - FIGURES 2 & 3 -> choices.m

% load in the data
load('data.mat')

% partner choices - women
a = repmat(pagetranspose(dat.cnt_f),6,1).*dat.M_pre;
b = zeros(6,6);
for r = 1:fxdpar.k
   b = b + a(:,:,r);
end
c = sum(b);
d = (b./repmat(c,6,1))*100;
clear a b c d; 

% the above can be repeated for men by changing dat.cnt_f to dat.cnt_m
% and dat.M_pre to dat.F_pre (and removing the transpose of the counts)

% marstat  - women
a = repmat(pagetranspose(dat.cnt_f),6,1).*pred3.Mf; 
b = dat.cnt_f.*pred3.s_f;
c = dat.cnt_f.*pred3.o_f;

d = zeros(6,6);
e = zeros(6,1);
f = zeros(6,1);
for r = 1:fxdpar.k
    d = d + a(:,:,r);
    e = e + b(:,:,r);
    f = f + c(:,:,r);
end
g = sum(d);
e = e';
f = f';

f = [(e./(e+f+g))*100;(g./(e+f+g))*100;(f./(e+f+g))*100];

% these values can then be exported in order to create figures 2 & 3
% 





