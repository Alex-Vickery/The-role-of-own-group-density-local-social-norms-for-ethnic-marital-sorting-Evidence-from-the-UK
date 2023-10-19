%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Section D - PREDICTED FUTURE ETHNIC HOMOGAMY 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% D.1 - counterfactuals.m

clearvars;
% Part 0: Setup Data Structure 
        dat = struct;
        fxdpar = struct;
        fxdpar.k = 11;				% Nr regions
        fxdpar.N = 6;				% Nr types
        fxdpar.gr = 1.0462451;		% gender ratio (imported from stata)
        load('spec3.mat');
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% Part 1a: Create the data

        cd '/Users/Alex/Documents/replicationfiles/matlab/predfuturesorting'
        
        % load in the txt files on the 1990s cohorts
		files = dir('Qual_prereg*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end       
        
        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;	
        
        % Save all the txt files into one matrix
        save -ascii Qual_prereg.dat Qual_prereg*;
        clear Qual_prereg*;
        load Qual_prereg.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
		% Qualifications distributions by gender and type [INITIATE ONCE]
		dat.h_m = zeros(fxdpar.N,1,fxdpar.k); 	% h_m is the distribution for males, rows are types, single col, sheets are regions.
        dat.h_f = zeros(fxdpar.N,1,fxdpar.k); 	% h_f is the distribution for females, rows are types, single col, sheets are regions.
		        
        for r = 1:fxdpar.k
            dat.h_m(:,1,r) = Qual_prereg((2*r)-1,:)';
            dat.h_f(:,1,r) = Qual_prereg(2*r,:)';
        end
        
        dat.h_m(dat.h_m==0) = [0.0000001]; % replace 0 cells with very small values
        dat.h_m = dat.h_m./1.000001; % make sure rows/columns still sum to 1
        
        dat.h_f(dat.h_f==0) = [0.0000001]; % replace 0 cells with very small values
        dat.h_f = dat.h_f./1.000001; % make sure rows/columns still sum to 1

        clear Qual_prereg files k r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      

% Scale by a fixed gender ratio

        for r = 1:fxdpar.k 
            dat.h_m(:,:,r) = dat.h_m(:,:,r).*fxdpar.gr;
        end
		clear r;
        
% combine into single distribution matrix
        dat.H = zeros(fxdpar.N,2,fxdpar.k);
        
        for r = 1:fxdpar.k
            dat.H(:,1,r) = dat.h_m(:,:,r);
            dat.H(:,2,r) = dat.h_f(:,:,r);
        end
        clear r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        
files = dir('cnt_prereg*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 

        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;        
                
         % Save all the txt files into one matrix
        save -ascii cnt_prereg.dat cnt_prereg*;
        clear cnt_prereg*;
        load cnt_prereg.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
% LFS observation counts by gender and type (will be used at end of loglik)
        
		dat.cnt_m = zeros(fxdpar.N,1,fxdpar.k); % cnt_m is the population count for males, rows are types, sheets are regions.
		dat.cnt_f = zeros(fxdpar.N,1,fxdpar.k); % cnt_f is the population count for females, rows are types, sheets are regions.

		for r = 1:fxdpar.k 	% Loop over regions
			dat.cnt_m(:,1,r) = cnt_prereg((2*r)-1,:)';
			dat.cnt_f(:,1,r) = cnt_prereg(2*r,:)';
        end
        
        
		clear cnt_prereg files k r;
		       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        
%% Prediction when social norms are fully endogenous

% Parameter vector - obtained from our model spec 3 

	% Define Zeta (fundamental prefs) and redefine in exponential form, male types on rows and female types in cols
	clear Z;
    % full spec
     % Group effects
	RE = [0;Spec3.FE_est];
    % Define social interactions preferences, phi_m_1, phi_f_1, phi_m_0, phi_f_0
	PE = [Spec3.PE_est;0];  
    % Surplus
    Z = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    for g = 1:fxdpar.k
        Z(:,:,g) = Spec3.Z_est(:,:);
        Z(:,:,g) = Z(:,:,g) + RE(g,1);
    end 
    clear g;
    
    z_out = Spec3.Z_out;
    z_om = z_out(1:6,1);
    z_of = z_out(7:12,1); 
	s_m = zeros(fxdpar.N,1,fxdpar.k);
    s_f = zeros(fxdpar.N,1,fxdpar.k);
    Mm = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    Mf = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    o_m = zeros(fxdpar.N,1,fxdpar.k);
    o_f = zeros(fxdpar.N,1,fxdpar.k);
      
% Guess singles rates (as N x 2 x G array, males in 1st col; females in second col; groups on sheets)
	s = 0.06*ones(fxdpar.N,2,fxdpar.k);
    o = zeros(fxdpar.N,2,fxdpar.k);
			
	% Loop over groups, solving the equilibrium in each group
	for g = 1:fxdpar.k,
	
		% Use the starting values for the singles-rates for group g (N x 2 matrix; males in 1st col; females on second)
		sg = s(:,:,g);
        og = o(:,:,g);
		
		% Use the population distribution for group g (N x 2 matrix; males in 1st col; females on second)		
		H = dat.H(:,:,g);
					
			% Solving the adding up equations by iterative process
			iter = 1;
			while iter<500,
			
				% Male marriage frequencies (male type on rows, female types on cols)
				Mmg = ((exp(Z(:,:,g))).*((repmat(sg(:,1).^(1-PE(3)),1,fxdpar.N))).*((repmat((sg(:,2))'.^(1-PE(4)),fxdpar.N,1))).*(repmat((H(:,2))',fxdpar.N,1)./repmat(H(:,1),1,fxdpar.N)).^(1-PE(2))).^(1/(2-PE(1)-PE(2)));
				Mmg = real(Mmg);
				% Female marriage frequencies  (male type on rows, female types on cols)
				Mfg = ((exp(Z(:,:,g))).*((repmat(sg(:,1).^(1-PE(3)),1,fxdpar.N))).*((repmat((sg(:,2))'.^(1-PE(4)),fxdpar.N,1))).*(repmat(H(:,1),1,fxdpar.N)./repmat((H(:,2))',fxdpar.N,1)).^(1-PE(1))).^(1/(2-PE(1)-PE(2)));
                Mfg = real(Mfg);
                
                og(:,1) = (exp(z_om).*sg(:,1).^(1-PE(3))).^(1/(1-PE(1)));
                %og = real(og);
                og(:,2) = (exp(z_of).*sg(:,2).^(1-PE(4))).^(1/(1-PE(2)));
                %og = real(og);
                
				% Adding up equations	
				d = [sum(Mmg')' + sg(:,1) + og(:,1) - 1; sum(Mfg)' + sg(:,2) + og(:,2) - 1];
		
				% A simple Newton-ish updating that ignores the finer details of the derivatives... but works!
				sg = sg - [d(1:fxdpar.N) d(fxdpar.N+1:2*fxdpar.N)]/100;
		
				iter = iter + 1;
				
			end;
			
		% Put the equilibrium single-rates into s in sheet g
		s(:,:,g) = sg;
        s_m(:,1,g) = s(:,1,g);
        s_f(:,1,g) = s(:,2,g);
        
        o(:,:,g) = og;
        o_m(:,1,g) = o(:,1,g);
        o_f(:,1,g) = o(:,2,g);
	
		% Store also the equilibrium marriages rates (male type on rows, female types on cols, groups on sheets)
		Mm(:,:,g) = Mmg;
		Mf(:,:,g) = Mfg;	
		
	end;

predcount1 = struct;
    
    predcount1.Mm = Mm;
    predcount1.Mf = Mf;
    predcount1.s_m = s_m;
    predcount1.s_f = s_f;
    predcount1.o_m = o_m;
    predcount1.o_f = o_f;
    

%% Prediction when PE are active and norms based on previous mar rates 

	% Parameter vector - obtained from our model spec 3 

	% Define Zeta (fundamental prefs) and redefine in exponential form, male types on rows and female types in cols
	clear Z;
    % full spec
    
     % Group effects
	RE = [0;Spec3.FE_est];
    % Define social interactions preferences, phi_m_1, phi_f_1, phi_m_0, phi_f_0
	PE = [Spec3.PE_est;0];
    
    % Surplus
    Z = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    for g = 1:fxdpar.k
        Z(:,:,g) = Spec3.Z_est(:,:);
        Z(:,:,g) = Z(:,:,g) + RE(g,1);
        Z(:,:,g) = Z(:,:,g) + PE(1)*log(pred3.Mm(:,:,g)) + PE(2)*log(pred3.Mf(:,:,g));
    end 
    clear g;
    
    z_out = Spec3.Z_out;
    z_om = z_out(1:6,1) + PE(1)*log(pred3.o_m) - PE(3)*log(pred3.s_m);
    z_of = z_out(7:12,1)+ PE(2)*log(pred3.o_f) - PE(4)*log(pred3.s_f);
   
	s_m = zeros(fxdpar.N,1,fxdpar.k);
    s_f = zeros(fxdpar.N,1,fxdpar.k);
    Mm = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    Mf = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    o_m = zeros(fxdpar.N,1,fxdpar.k);
    o_f = zeros(fxdpar.N,1,fxdpar.k);
    
    % Guess singles rates (as N x 2 x G array, males in 1st col; females in second col; groups on sheets)
	s = 0.06*ones(fxdpar.N,2,fxdpar.k);
    o = zeros(fxdpar.N,2,fxdpar.k);
			
	% Loop over groups, solving the equilibrium in each group
	for g = 1:fxdpar.k,
	
		% Use the starting values for the singles-rates for group g (N x 2 matrix; males in 1st col; females on second)
		sg = s(:,:,g);
        og = o(:,:,g);
		
		% Use the population distribution for group g (N x 2 matrix; males in 1st col; females on second)		
		H = dat.H(:,:,g);
					
			% Solving the adding up equations by iterative process
			iter = 1;
			while iter<500,
			
				% Male marriage frequencies (male type on rows, female types on cols)
				Mmg = ((exp(Z(:,:,g))).*((repmat(sg(:,1),1,fxdpar.N))).*((repmat((sg(:,2))',fxdpar.N,1))).*(repmat((H(:,2))',fxdpar.N,1)./repmat(H(:,1),1,fxdpar.N))).^(1/(2));
				%Mmg = real(Mmg);
				% Female marriage frequencies  (male type on rows, female types on cols)
				Mfg = ((exp(Z(:,:,g))).*((repmat(sg(:,1),1,fxdpar.N))).*((repmat((sg(:,2))',fxdpar.N,1))).*(repmat(H(:,1),1,fxdpar.N)./repmat((H(:,2))',fxdpar.N,1))).^(1/(2));
                %Mfg = real(Mfg);
                
                og(:,1) = (exp(z_om(:,:,g)).*sg(:,1).^(1-PE(3))).^(1/(1-PE(1)));
                %og = real(og);
                og(:,2) = (exp(z_of(:,:,g)).*sg(:,2).^(1-PE(4))).^(1/(1-PE(2)));
                %og = real(og);
                
				% Adding up equations	
				d = [sum(Mmg')' + sg(:,1) + og(:,1) - 1; sum(Mfg)' + sg(:,2) + og(:,2) - 1];
		
				% A simple Newton-ish updating that ignores the finer details of the derivatives... but works!
				sg = sg - [d(1:fxdpar.N) d(fxdpar.N+1:2*fxdpar.N)]/100;
		
				iter = iter + 1;
				
			end;
			
		% Put the equilibrium single-rates into s in sheet g
		s(:,:,g) = sg;
        s_m(:,1,g) = s(:,1,g);
        s_f(:,1,g) = s(:,2,g);
        
        o(:,:,g) = og;
        o_m(:,1,g) = o(:,1,g);
        o_f(:,1,g) = o(:,2,g);
	
		% Store also the equilibrium marriages rates (male type on rows, female types on cols, groups on sheets)
		Mm(:,:,g) = Mmg;
		Mf(:,:,g) = Mfg;	
		
	end;

    predcount2 = struct;
    predcount2.Mm = Mm;
    predcount2.Mf = Mf;
    predcount2.s_m = s_m;
    predcount2.s_f = s_f;
    predcount2.o_m = o_m;
    predcount2.o_f = o_f;
   

%% need to work out predicted values - prop of intra ethnic marriages

% wm
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
wmcount1 = zeros(fxdpar.k,1);
wmcount2 = zeros(fxdpar.k,1);
propw = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*predcount1.Mm(:,:,r);
    numijm2(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*predcount2.Mm(:,:,r);
    wmcount1(r,1) = (numijm1(1,1,r) + numijm1(1,2,r)+ numijm1(2,1,r) + numijm1(2,2,r))./(sum(numijm1(:,1,r)) + sum(numijm1(:,2,r)));
    wmcount2(r,1) = (numijm2(1,1,r) + numijm2(1,2,r)+ numijm2(2,1,r) + numijm2(2,2,r))./(sum(numijm2(:,1,r)) + sum(numijm2(:,2,r)));
    propw(r,1) = (dat.cnt_m(1,1,r) + dat.cnt_m(2,1,r) + dat.cnt_f(1,1,r) + dat.cnt_f(2,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
save ('wmcount.mat','wmcount1','wmcount2','propw');
clear numijm1 numijm2 propw; 

% wf
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
wfcount1 = zeros(fxdpar.k,1);
wfcount2 = zeros(fxdpar.k,1);
propw = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*predcount1.Mf(:,:,r);
    numijm2(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*predcount2.Mf(:,:,r);
    wfcount1(r,1) = (numijm1(1,1,r) + numijm1(1,2,r)+ numijm1(2,1,r) + numijm1(2,2,r))./(sum(numijm1(1,:,r)) + sum(numijm1(2,:,r)));
    wfcount2(r,1) = (numijm2(1,1,r) + numijm2(1,2,r)+ numijm2(2,1,r) + numijm2(2,2,r))./(sum(numijm2(1,:,r)) + sum(numijm2(2,:,r)));
    propw(r,1) = (dat.cnt_m(1,1,r) + dat.cnt_m(2,1,r) + dat.cnt_f(1,1,r) + dat.cnt_f(2,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
save ('wfcount.mat','wfcount1','wfcount2','propw');
clear numijm1 numijm2 propw; 

% bm
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
bmcount1 = zeros(fxdpar.k,1);
bmcount2 = zeros(fxdpar.k,1);
propb = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*predcount1.Mm(:,:,r);
    numijm2(:,:,r) = repmat(dat.cnt_m(:,:,r),1,6).*predcount2.Mm(:,:,r);
    bmcount1(r,1) = (numijm1(3,3,r) + numijm1(3,4,r)+ numijm1(4,3,r) + numijm1(4,4,r))./(sum(numijm1(:,3,r)) + sum(numijm1(:,4,r)));
    bmcount2(r,1) = (numijm2(3,3,r) + numijm2(3,4,r)+ numijm2(4,3,r) + numijm2(4,4,r))./(sum(numijm2(:,3,r)) + sum(numijm2(:,4,r)));
    propb(r,1) = (dat.cnt_m(3,1,r) + dat.cnt_m(4,1,r) + dat.cnt_f(3,1,r) + dat.cnt_f(4,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
save ('bmcount.mat','bmcount1','bmcount2','propb');
clear numijm1 numijm2 propb; 

% bf
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
bfcount2 = zeros(fxdpar.k,1);
propb = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*predcount1.Mf(:,:,r);
    numijm2(:,:,r) = repmat(pagetranspose(dat.cnt_f(:,:,r)),6,1).*predcount2.Mf(:,:,r);
    bfcount1(r,1) = (numijm1(3,3,r) + numijm1(3,4,r)+ numijm1(4,3,r) + numijm1(4,4,r))./(sum(numijm1(3,:,r)) + sum(numijm1(4,:,r)));
    bfcount2(r,1) = (numijm2(3,3,r) + numijm2(3,4,r)+ numijm2(4,3,r) + numijm2(4,4,r))./(sum(numijm2(3,:,r)) + sum(numijm2(4,:,r)));
    propb(r,1) = (dat.cnt_m(3,1,r) + dat.cnt_m(4,1,r) + dat.cnt_f(3,1,r) + dat.cnt_f(4,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
save ('bfcount.mat','bfcount1','bfcount2','propb');
clear numijm1 numijm2 propb; 

% am
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
amcount1 = zeros(fxdpar.k,1);
amcount2 = zeros(fxdpar.k,1);
propa = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = predcount1.Mm(:,:,r).*dat.cnt_m(:,1,r);
    numijm2(:,:,r) = predcount2.Mm(:,:,r).*dat.cnt_m(:,1,r);
    amcount1(r,1) = (numijm1(5,5,r) + numijm1(5,6,r)+ numijm1(6,5,r) + numijm1(6,6,r))./(sum(numijm1(:,5,r)) + sum(numijm1(:,6,r)));
    amcount2(r,1) = (numijm2(5,5,r) + numijm2(5,6,r)+ numijm2(6,5,r) + numijm2(6,6,r))./(sum(numijm2(:,5,r)) + sum(numijm2(:,6,r)));
    propa(r,1) = (dat.cnt_m(5,1,r) + dat.cnt_m(6,1,r) + dat.cnt_f(5,1,r) + dat.cnt_f(6,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
save ('amcount.mat','amcount1','amcount2','propa');
clear numijm1 numijm2 propa; 

% af
numijm1 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
numijm2 = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
afcount1 = zeros(fxdpar.k,1);
afcount2 = zeros(fxdpar.k,1);
propa = zeros(fxdpar.k,1); 
for r = 1:fxdpar.k
    numijm1(:,:,r) = predcount1.Mf(:,:,r).*dat.cnt_f(:,1,r)';
    numijm2(:,:,r) = predcount2.Mf(:,:,r).*dat.cnt_f(:,1,r)';
    afcount1(r,1) = (numijm1(5,5,r) + numijm1(5,6,r)+ numijm1(6,5,r) + numijm1(6,6,r))./(sum(numijm1(5,:,r)) + sum(numijm1(6,:,r)));
    afcount2(r,1) = (numijm2(5,5,r) + numijm2(5,6,r)+ numijm2(6,5,r) + numijm2(6,6,r))./(sum(numijm2(5,:,r)) + sum(numijm2(6,:,r)));
    propa(r,1) = (dat.cnt_m(5,1,r) + dat.cnt_m(6,1,r) + dat.cnt_f(5,1,r) + dat.cnt_f(6,1,r)) / (sum(dat.cnt_m(:,1,r)) + sum(dat.cnt_f(:,1,r)));
end
clear r;
save ('afcount.mat','afcount1','afcount2','propa');
clear numijm1 numijm2 propa; 

%% 

% The following code can be used to generate the values in table 4 for the
% predicting cohorts

countm = zeros(fxdpar.N,1);
countf = zeros(fxdpar.N,1);
for r = 1:fxdpar.k
    countm = countm + dat.cnt_m(:,1,r);
    countf = countf + dat.cnt_f(:,1,r);
end 
clear r;

countm = countm/sum(countm);
countf = countf/sum(countf);

% men 
numijm = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
nummar = zeros(6,6);
for r = 1:fxdpar.k
    numijm(:,:,r) = predcount1.Mm(:,:,r).*dat.cnt_m(:,1,r);
    nummar = nummar + numijm(:,:,r);
end 
clear r;

wlm = (nummar(1,1) + nummar(2,1))/sum(nummar(:,1));
whm = (nummar(2,2) + nummar(1,2))/sum(nummar(:,2));
blm = (nummar(3,3) + nummar(4,3))/sum(nummar(:,3));
bhm = (nummar(4,4) + nummar(3,4))/sum(nummar(:,4));
alm = (nummar(5,5) + nummar(6,5))/sum(nummar(:,5));
ahm = (nummar(6,6) + nummar(5,6))/sum(nummar(:,6));

% the below code is for women 
% numijm = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
% nummar = zeros(6,6);
% for r = 1:fxdpar.k
%     numijm(:,:,r) = predcount1.Mf(:,:,r)'.*dat.cnt_f(:,1,r);
%     nummar = nummar + numijm(:,:,r);
% end 
% clear r;
% 
% wlf = (nummar(1,1) + nummar(2,1))/sum(nummar(:,1));
% whf = (nummar(2,2) + nummar(1,2))/sum(nummar(:,2));
% blf = (nummar(3,3) + nummar(4,3))/sum(nummar(:,3));
% bhf = (nummar(4,4) + nummar(3,4))/sum(nummar(:,4));
% alf = (nummar(5,5) + nummar(6,5))/sum(nummar(:,5));
% ahf = (nummar(6,6) + nummar(5,6))/sum(nummar(:,6));








