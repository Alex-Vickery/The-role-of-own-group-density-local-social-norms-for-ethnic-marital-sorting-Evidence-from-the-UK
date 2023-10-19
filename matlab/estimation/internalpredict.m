clearvars; 
% The idea is to use the model estimated w/o Eastern region to try and
% predict the patterns for the Eastern region 

load('data.mat')
load('Spec3wowestmidlands.mat')

% Load in parameters 
Z = reshape(Spec3.Z_ML(1:fxdpar.N^2),[fxdpar.N,fxdpar.N]);
z_om = Spec3.Z_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N);
z_of = Spec3.Z_ML(fxdpar.N^2+fxdpar.N+1:fxdpar.N^2+fxdpar.N*2);
PE = [Spec3.PE_est;0];
FE = 0.0707345538799069; % this is the RE for WM in the full model 
    
% Solve equilibrium as non-linear equation system in singles rates given parameters and population structure
% preallocate 

% WM is region 7 in data 
h_m = dat.h_m(:,:,7);
h_f = dat.h_f(:,:,7);
    
s = 0.40*ones(2*fxdpar.N,1);	% Initiate never-married rates
lns = log(s);					% Use log transformation to avoid problems with non-negatives
itr = 1;						% Iteration counter
d = 99;							% Initiate distance (for convergence)
maxit = 1000;					% Set limit on nr iterations
	
while d>0.00000001,
		
			s = exp(lns);		% Back to level
			s_m = s(1:fxdpar.N);					% Split into males...
			s_f = s(fxdpar.N+1:2*fxdpar.N);		% ... and females
            
			Mm = (s_m.^((1-PE(3))./(2-PE(1)-PE(2)))).*(s_f'.^((1-PE(4))./(2-PE(1)-PE(2)))).*((h_f'./h_m).^((1-PE(2))./(2-PE(1)-PE(2)))).*(exp(Z+FE).^(1/(2-PE(1)-PE(2))));
			Mf = (s_m.^((1-PE(3))./(2-PE(1)-PE(2)))).*(s_f'.^((1-PE(4))./(2-PE(1)-PE(2)))).*((h_m./h_f').^((1-PE(1))./(2-PE(1)-PE(2)))).*(exp(Z+FE).^(1/(2-PE(1)-PE(2))));
			
            o_m = (exp(z_om).^(1/(1-PE(1)))).*(s_m.^((1-PE(3))/(1-PE(1))));
            o_f = (exp(z_of).^(1/(1-PE(2)))).*(s_f.^((1-PE(4))/(1-PE(2))));
            
			Fm = s_m + o_m + (sum(Mm'))' - 1;
			Ff = s_f + o_f + (sum(Mf))' - 1;
			
			Fv = [Fm; Ff];
	
			d = max(abs(Fv));
					
			lns = lns - Fv./5;
			
			itr = itr + 1;
		
			if itr>maxit,
				disp('Not converging');
				break;
			end;
end; 	
  
% now compare predicted with data 
% need - intra ethnic marriages across regions, by gender 
% WM is region 7 in matlab, and region 5 in stata 
b = repmat(dat.cnt_m(:,:,7),1,6).*Mm;
a = repmat(pagetranspose(dat.cnt_f(:,:,7)),6,1).*Mf;
exclm = zeros(3,1);
exclf = zeros(3,1);
for x = 1:3
exclf(x) = (a(2*x-1,2*x-1)+a(2*x-1,2*x)+a(2*x,2*x-1)+a(2*x,2*x))/(sum(a(:,2*x-1)) + sum(a(:,2*x))); 
exclm(x) = (b(2*x-1,2*x-1)+b(2*x-1,2*x)+b(2*x,2*x-1)+b(2*x,2*x))/(sum(b(2*x-1,:)) + sum(b(2*x,:))); 
end
excl = [exclm,exclf];

% now load in the preffered model and repeat 

load('Spec3phif0.mat')

b = repmat(dat.cnt_m(:,:,7),1,6).*pred3.Mm(:,:,7);
a = repmat(pagetranspose(dat.cnt_f(:,:,7)),6,1).*pred3.Mf(:,:,7);
inclm = zeros(3,1);
inclf = zeros(3,1);
for x = 1:3
inclf(x) = (a(2*x-1,2*x-1)+a(2*x-1,2*x)+a(2*x,2*x-1)+a(2*x,2*x))/(sum(a(:,2*x-1)) + sum(a(:,2*x))); 
inclm(x) = (b(2*x-1,2*x-1)+b(2*x-1,2*x)+b(2*x,2*x-1)+b(2*x,2*x))/(sum(b(2*x-1,:)) + sum(b(2*x,:))); 
end
incl = [inclm,inclf];

% now do for the data 
b = repmat(dat.cnt_m(:,:,7),1,6).*dat.M_pre(:,:,7);
a = repmat(pagetranspose(dat.cnt_f(:,:,7)),6,1).*dat.F_pre(:,:,7);
datm = zeros(3,1);
datf = zeros(3,1);
for x = 1:3
datf(x) = (a(2*x-1,2*x-1)+a(2*x-1,2*x)+a(2*x,2*x-1)+a(2*x,2*x))/(sum(a(:,2*x-1)) + sum(a(:,2*x))); 
datm(x) = (b(2*x-1,2*x-1)+b(2*x-1,2*x)+b(2*x,2*x-1)+b(2*x,2*x))/(sum(b(2*x-1,:)) + sum(b(2*x,:))); 
end
datres = [datm,datf];


res = [datres,incl,excl];  



