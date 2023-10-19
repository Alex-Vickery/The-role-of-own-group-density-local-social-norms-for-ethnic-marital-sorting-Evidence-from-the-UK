        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION B: ESTIMATION OF SPEC2, YES RE, NO PE
   
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
        
		Z0 = Z0./fxdpar.k; 
		Z0 = reshape(Z0,fxdpar.N^2,1) + zeros(fxdpar.N^2,1); % surplus tterms 
        Z0 = [Z0; zeros(fxdpar.N*2,1)]; % marriage outside parameters 
        Z0 = [Z0;zeros(fxdpar.k-1,1)]; % Region effects 
       
	options = optimset('Display','iter','TolFun',1e-16,'TolX',1e-16,'MaxIter',50000,'MaxFunEvals',35000);
    
	% Checking that it computes at start values
    disp('check that function computes at starting values')
    loglik_spec2(fxdpar,dat,Z0)
   
    % Go for it!
    disp('estimate spec2')
	[Z_ML,LL,exitflag,output,grad,H] = fminunc(@(Z) loglik_spec2(fxdpar,dat,Z),Z0,options);
   
    % structure for results
    
    Spec2 = struct;
    Spec2.Z_ML = Z_ML;
    Spec2.LL = LL;
    Spec2.H = H;
    
    % Parameters
	Spec2.Z_est = reshape(Z_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);
    Spec2.Z_out = reshape(Z_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N*2),fxdpar.N*2,1);
    Spec2.FE_est = reshape(Z_ML(fxdpar.N^2+fxdpar.N*2+1:fxdpar.N^2+fxdpar.N*2+fxdpar.k-1),fxdpar.k-1,1);
   
    % Standard Errors
    Spec2.SE_ML = sqrt(diag(inv(H)));
    Spec2.SE_Z_est = reshape(Spec2.SE_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);
    Spec2.SE_Z_out = reshape(Spec2.SE_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N*2),fxdpar.N*2,1);
    Spec2.SE_FE = reshape(Spec2.SE_ML(fxdpar.N^2+fxdpar.N*2+1:fxdpar.N^2+fxdpar.N*2+fxdpar.k-1),fxdpar.k-1,1);
    
    % wald test on std errors 
    WZest = Spec2.Z_est.^2./Spec2.SE_Z_est.^2;  
    WFEesst = (Spec2.FE_est./Spec2.SE_FE).^2;     
    WZout = (Spec2.Z_out./Spec2.SE_Z_out).^2;
    
    % load in predicted values
    load('lik_spec2');
    
    % prepare for LR test
    load('lik_spec1.mat')
    
    pred2.LLik = -pred2.LLik;
    pred1.LLik = -pred1.LLik;
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
 % likelihood ratio test 
    LR = struct;
    
    % perform test
    disp('Likelihood Ratio Test')
    
    dof = 10;
     
    [h,pValue,stat,cValue] = lratiotest(pred2.LLik,pred1.LLik,dof)
    
    if cValue>stat,
        disp('reject null')
    end;
   
    clear dof;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    
% save all
    clear filename Z_ML LL H Z Z0 options output grad exitflag;
    filename = 'spec2.mat' ;
    
    save(filename,'Spec2','pred2')
    
 % end of file
    disp('End of file spec2.m')
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
  
    