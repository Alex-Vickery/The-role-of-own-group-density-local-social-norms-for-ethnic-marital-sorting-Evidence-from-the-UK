   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION B: ESTIMATION OF SPEC1, NO RE, NO PE
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        clearvars;
        load('data.mat');
        
		% Unrestricted CHOO SIOW estimates by direct backing out, not
		% neccesary but we use as starting valuess for sigma terms
        
        for r = 1:fxdpar.k
		Z(:,:,r) = 2*log(dat.M_pre(:,:,r).*(1./(sqrt(dat.s_m(:,1,r).*dat.s_f(:,1,r)'))).*sqrt(dat.h_m(:,1,r)./dat.h_f(:,1,r)'));
        end
        clear r;
        
        % Now we move towards estimation
        Z0 = zeros(fxdpar.N,fxdpar.N);
		for r = 1:fxdpar.k
			Z0 = Z0 +  Z(:,:,r);
        end
        clear r;
        
		Z0 = Z0./fxdpar.k;
		Z0 = reshape(Z0,fxdpar.N^2,1) + zeros(fxdpar.N^2,1); % marriage surplus parameters 
        Z0 = [Z0; zeros(fxdpar.N*2,1)]; % extra parameters for marrying outside UK partner 
        
    % optimisation options         
	options = optimset('Display','iter','TolFun',1e-16,'TolX',1e-16,'MaxIter',50000,'MaxFunEvals',35000);
    
	% Checking that it computes at start values
    disp('check that function computes at starting values')
    loglik_spec1(fxdpar,dat,Z0)
   
    % Go for it!
    disp('estimate spec1')
	[Z_ML,LL,exitflag,output,grad,H] = fminunc(@(Z) loglik_spec1(fxdpar,dat,Z),Z0,options);
    
    % structure for results
    
    Spec1 = struct;
    Spec1.Z_ML = Z_ML;
    Spec1.LL = LL;
    Spec1.H = H;
    
    % Parameter estimates
	Spec1.Z_est = reshape(Z_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);
    Spec1.Z_out = reshape(Z_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N*2),fxdpar.N*2,1);
    
    % Standard Errors
    Spec1.SE_ML = sqrt(diag(inv(H)));
    Spec1.SE_Z_est = reshape(Spec1.SE_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);
    Spec1.SE_Z_out = reshape(Spec1.SE_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N*2),fxdpar.N*2,1);
    
    % wald test on std errors 
    WZest = Spec1.Z_est.^2./Spec1.SE_Z_est.^2;  
    WZout = (Spec1.Z_out./Spec1.SE_Z_out).^2;
    
      
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    
% save all
    clear filename Z_ML LL H Z Z0 options output grad exitflag;
    filename = 'spec1.mat' ;
    
    save(filename,'Spec1','pred1')
    
    % end of file
    disp('End of file spec1.m')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
  




