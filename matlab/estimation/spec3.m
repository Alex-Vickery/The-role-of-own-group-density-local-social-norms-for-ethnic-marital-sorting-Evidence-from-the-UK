    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        % SECTION B: ESTIMATION OF SPEC3, YES RE, YES PE
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        clearvars;
        load('data.mat');
        
		% Unrestricted CHOO SIOW estimates by direct backing out, not
		% neccesary but we use as starting valuess for sigma terms 
        for r = 1:fxdpar.k
                Z(:,:,r) = 2*log(dat.M_pre(:,:,r).*(1./(sqrt(dat.s_m(:,1,r).*dat.s_f(:,1,r)'))).*sqrt(dat.h_m(:,1,r)./dat.h_f(:,1,r)'));
        end
        clear r;
     
        % Now we move towards estimation by creating the parameter vector
        Z0 = zeros(fxdpar.N,fxdpar.N);
		for r = 1:fxdpar.k
			Z0 = Z0 +  Z(:,:,r);
        end
        
		Z0 = Z0./fxdpar.k;
		Z0 = reshape(Z0,fxdpar.N^2,1) + zeros(fxdpar.N^2,1); % surplus terms 
        Z0 = [Z0; zeros(fxdpar.N*2,1)]; % outside marriage terms 
        Z0 = [Z0;zeros(fxdpar.k-1,1)]; % Region effects
        Z0 = [Z0;zeros(3,1)]; %Peer effects
    
    % optimisation options
	options = optimset('Display','iter','TolFun',1e-8,'TolX',1e-16,'MaxIter',50000,'MaxFunEvals',80000);
        
	% Checking that it computes at start values
    disp('check that function computes at starting values')
    loglik_spec3(fxdpar,dat,Z0)
   
    % Go for it!
    disp('estimate spec3')
	[Z_ML,LL,exitflag,output,grad,H] = fminunc(@(Z) loglik_spec3(fxdpar,dat,Z),Z0,options);
    
    % structure for results
    clear Spec3 pred3;
    Spec3 = struct;
    Spec3.Z_ML = Z_ML;
    Spec3.LL = LL;
    Spec3.H = H;
    Spec3.grad = grad; 
    
    % Parameters
	Spec3.Z_est = reshape(Z_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);
    Spec3.Z_out = reshape(Z_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N*2),fxdpar.N*2,1);
    Spec3.FE_est = reshape(Z_ML(fxdpar.N^2+fxdpar.N*2+1:fxdpar.N^2+fxdpar.N*2+fxdpar.k-1),fxdpar.k-1,1);
    Spec3.PE_est = reshape(Z_ML(fxdpar.N^2+fxdpar.N*2+fxdpar.k:fxdpar.N^2+fxdpar.N*2+fxdpar.k+2),3,1);
    
    % Standard Errors 
    Spec3.SE_ML = diag(sqrt(inv(Spec3.H)));
    Spec3.SE_Z_est = reshape(Spec3.SE_ML(1:fxdpar.N^2),fxdpar.N,fxdpar.N);
    Spec3.SE_Z_out = reshape(Spec3.SE_ML(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N*2),fxdpar.N*2,1);
    Spec3.SE_FE = reshape(Spec3.SE_ML(fxdpar.N^2+fxdpar.N*2+1:fxdpar.N^2+fxdpar.N*2+fxdpar.k-1),fxdpar.k-1,1);
    Spec3.SE_PE = reshape(Spec3.SE_ML(fxdpar.N^2+fxdpar.N*2+fxdpar.k:fxdpar.N^2+fxdpar.N*2+fxdpar.k+2),3,1);
    
    % wald test on std errors 
    WZest = Spec3.Z_est.^2./Spec3.SE_Z_est.^2;  
    WPEest = (Spec3.PE_est./Spec3.SE_PE).^2; 
    WFEesst = (Spec3.FE_est./Spec3.SE_FE).^2;     
    WZout = (Spec3.Z_out./Spec3.SE_Z_out).^2;
    
    
%prepare for Likelihood ratio test
load('lik_spec2.mat')
   
pred3.LLik = -pred3.LLik;
pred2.LLik = -pred2.LLik;
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
 % likelihood ratio test 
   
    clear h pValue stat cValue;
   
    % perform test
    disp('Likelihood Ratio Test')
    
    dof = 3;
    
    [h,pValue,stat,cValue] = lratiotest(Spec3.LL,pred2.LLik,dof)
    [h,pValue,stat,cValue] = lratiotest(pred3.LLik,pred2.LLik,dof)
    
    if cValue>stat,
        disp('reject null')
    end;
    
    clear dof;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    
 % save all
    clear filename Z_ML LL H Z Z0 options output grad exitflag;
    filename = 'spec3.mat' ;
    
    save(filename,'Spec3','pred3')
    
 % end of file
    disp('End of file spec3.m')
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     


  
    