%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION A: DATA SETUP FILE
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     


% Setup file to load and shape the data
        disp('Setup file to load and shape the data')
        
% Part 0: Setup Structure 
        dat = struct;
        fxdpar = struct;
        fxdpar.k = 11;				% Nr regions
        fxdpar.N = 6;				% Nr types
        fxdpar.gr = 0.92525766;     % gender ratio - copied over from stata
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Part 1a: Load in the Data (all .txt files with the prefix Qual_prereg...)

		cd '/Users/Alex/Documents/replicationfiles/estimation' % Alex's Path on mac
       
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
        
        clear Qual_prereg files k r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      

% Part 1b: Load in the Data (all .txt files with the prefix cnt_prereg...)

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

% Part 1c: Load in the Data (all .txt files with the prefix M_pre...)

        files = dir('M_pre*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 
        
        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;        
        
        save -ascii M_pre.dat M_pre*; % Save all the txt files into one matrix
        clear M_pre*;
        load M_pre.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
% LFS partner type distribution - Males
		
		dat.M_pre = zeros(fxdpar.N,fxdpar.N,fxdpar.k); % M_pre is the partner type distribution for males, rows are males types, cols are female types, sheets are regions.
        
        for r = 1:fxdpar.k
			dat.M_pre(:,:,r) = M_pre((r-1)*fxdpar.N+1:r*fxdpar.N,1:fxdpar.N);
        end

        %%%%
        
        dat.M_pre(dat.M_pre==0) = [0.0000001]; % replace 0 cells with very small values
        dat.M_pre = dat.M_pre./1.0000001; % make sure rows/columns still sum to 1

        %%%%
        
        % Check that partner types sum to unity
        
        disp('Check that partner types sum to unity')
        for r = 1:fxdpar.k 
            sum(dat.M_pre(:,:,r)')' % Males 
        end
        
        clear M_pre files k r;
    
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      

% Part 1d: Load in the Data (all .txt files with the prefix F_pre...)

        files = dir('F_pre*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 
        
        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;                
        
        save -ascii F_pre.dat F_pre*; 	% Save all the txt files into one matrix
        clear F_pre*;
        load F_pre.dat -ascii; 			% Load the matrix back in as a single variable (for tidyness)
        
% LFS partner distribution - Females
        
		dat.F_pre = zeros(fxdpar.N,fxdpar.N,fxdpar.k); % F_pre is the partner type distribution for males, rows are males types, cols are female types, sheets are regions.
        
        for r = 1:fxdpar.k
			dat.F_pre(:,:,r) = F_pre((r-1)*fxdpar.N+1:r*fxdpar.N,1:fxdpar.N);                
        end
        
        %%%%
                                  
        dat.F_pre(dat.F_pre==0) = [0.0000001]; % replace 0 cells with very small values 
        dat.F_pre = dat.F_pre./1.0000001; % make sure rows/columns still sum to 1 
        
        %%%%
        
        % Check that partner types sum to unity
        
        disp('Check that partner types sum to unity')
    	for r = 1:fxdpar.k
             sum(dat.F_pre(:,:,r))' % Females
        end
                    
        clear F_pre files k r;
   
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
 
% Part 1e: Load in the Data (all .txt files with the prefix s_m...)

        files = dir('s_m*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 

        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;
                
        save -ascii s_m.dat s_m*; % Save all the txt files into one matrix
        clear s_m*;
        load s_m.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
% LFS Single rates by gender

        % Use the imported txt file to out values in s_m within the dat structure                         
        dat.s_m = zeros(fxdpar.N,1,fxdpar.k); % s_m is the singles rates for males, rows are male types, sheets are regions.
        
        for r = 1:fxdpar.k
			dat.s_m(:,1,r) = s_m((r-1)*fxdpar.N+1:r*fxdpar.N,1);
        end
        
        dat.s_m(dat.s_m==0) = [0.0000001]; % replace 0 cells with very small values
        dat.s_m(dat.s_m==1) = [0.9999999]; % replace 1 cells with very high values
        
        clear s_m files k r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        
% Part 1f: Load in the Data (all .txt files with the prefix s_f...)

        files = dir('s_f*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 
        
        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;        
        
        save -ascii s_f.dat s_f*; % Save all the txt files into one matrix
        clear s_f*;
        load s_f.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
        
% LFS Single rates by gender

        % Use the imported txt file to out values in s_d within the dat structure                 
        dat.s_f = zeros(fxdpar.N,1,fxdpar.k);

		for r = 1:fxdpar.k
			dat.s_f(:,1,r) = s_f((r-1)*fxdpar.N+1:r*fxdpar.N,1);
        end
        
        dat.s_f(dat.s_f==0) = [0.0000001]; % replace 0 cells with very small values
        dat.s_f(dat.s_f==1) = [0.9999999]; % replace 1 cells with very high values
        
        clear s_f files k r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
   
%Part 1g: Load in the Data (all .txt files with the prefix o_m...)

        files = dir('o_m*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 
        
        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;        
        
        save -ascii o_m.dat o_m*; % Save all the txt files into one matrix
        clear o_m*;
        load o_m.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
        
% LFS Single rates by gender

        % Use the imported txt file to out values in s_d within the dat structure                 
        dat.o_m = zeros(fxdpar.N,1,fxdpar.k);

		for r = 1:fxdpar.k
			dat.o_m(:,1,r) = o_m((r-1)*fxdpar.N+1:r*fxdpar.N,1);
        end
        
        dat.o_m(dat.o_m==0) = [0.0000001]; % replace 0 cells with very small values
        
        clear o_m files k r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
%Part 1h: Load in the Data (all .txt files with the prefix o_f...)

        files = dir('o_f*.txt');
        for k = 1:length(files)
        load(files(k).name, '-ascii')
        end 
        
        % Check that we loaded the right nr of regions
        if k~=fxdpar.k,
        	disp('Wrong nr regions loaded');
        	pause;
        end;        
        
        save -ascii o_f.dat o_f*; % Save all the txt files into one matrix
        clear o_f*;
        load o_f.dat -ascii; % Load the matrix back in as a single variable (for tidyness)
        
        
% LFS Single rates by gender

        % Use the imported txt file to out values in s_d within the dat structure                 
        dat.o_f = zeros(fxdpar.N,1,fxdpar.k);

		for r = 1:fxdpar.k
			dat.o_f(:,1,r) = o_f((r-1)*fxdpar.N+1:r*fxdpar.N,1);
        end
        
        dat.o_f(dat.o_f==0) = [0.0000001]; % replace 0 cells with very small values
        
        clear o_f files k r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

% Scale by fixed gender ratio

        for r = 1:fxdpar.k 
            dat.h_m(:,:,r) = dat.h_m(:,:,r).*fxdpar.gr;
        end
		clear r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        
% Part 1i:
		% The marriage frequencies outlined the partner type distribution; hence it was conditional
		% on marriage. Here we make it "unconditional" so that the sum of all available choices, 
		% including singlehood sums to unity (checked below)
        
        for r = 1:fxdpar.k
            dat.M_pre(:,:,r) = dat.M_pre(:,:,r).*(1-dat.s_m(:,1,r)-dat.o_m(:,1,r));
            dat.F_pre(:,:,r) = dat.F_pre(:,:,r).*(1-dat.s_f(:,1,r)'-dat.o_f(:,1,r)');
        end
        clear r;
        
        dat.M_pre(dat.M_pre<0) = [0.0000001]; % replace 0 cells with very small values
        dat.F_pre(dat.F_pre<0) = [0.0000001]; % replace 0 cells with very small values
        
        % Check that choices -- including singlehood -- sum to unity 
        
        disp('Check that choices -- including singlehood -- sum to unity')
        for r = 1:fxdpar.k
            sum([dat.M_pre(:,:,r), dat.s_m(:,1,r), dat.o_m(:,1,r)]')
            sum([dat.F_pre(:,:,r)', dat.s_f(:,1,r), dat.o_f(:,1,r)]')
        end
        clear r;
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

          % Check that the equilibrium condition is satisfied
    
        dat.robust = zeros(fxdpar.N,fxdpar.N,fxdpar.k);  
        
        for r = 1:fxdpar.k
           dat.robust(:,:,r) = (dat.h_m(:,1,r).*dat.M_pre(:,:,r)) - (dat.h_f(:,1,r).*dat.F_pre(:,:,r)); 
        end
        clear r;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
       
        filename = 'data.mat';
        save(filename)
        
        % end of file
        disp('Data setup complete')
        disp('End of file setup.m')
       
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      