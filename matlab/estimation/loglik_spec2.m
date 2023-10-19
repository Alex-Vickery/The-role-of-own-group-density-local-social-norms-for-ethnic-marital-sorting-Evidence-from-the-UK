function [LLik,Lm,Lf] = loglik_spec2(fxdpar,dat,Z0)
		
% Reshape vector into matrix  
	Z = reshape(Z0(1:fxdpar.N^2),[fxdpar.N,fxdpar.N]);
    z_om = zeros(fxdpar.N,1);
    z_om = Z0(fxdpar.N^2+1:fxdpar.N^2+fxdpar.N);
    z_of = zeros(fxdpar.N,1);
    z_of = Z0(fxdpar.N^2+fxdpar.N+1:fxdpar.N^2+fxdpar.N*2);
    FE = zeros(fxdpar.k,1);					
    FE(2:fxdpar.k) = Z0(fxdpar.N^2+fxdpar.N*2+1:fxdpar.N^2+fxdpar.N*2+fxdpar.k-1);
    PE = zeros(4,1);
   
 % Solve equilibrium as non-linear equation system in singles rates given parameters and population structure
 % preallocate 
    s_m = zeros(fxdpar.N,1,fxdpar.k);
    s_f = zeros(fxdpar.N,1,fxdpar.k);
    Mm = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    Mf = zeros(fxdpar.N,fxdpar.N,fxdpar.k);
    o_m = zeros(fxdpar.N,1,fxdpar.k);
    o_f = zeros(fxdpar.N,1,fxdpar.k);
    Lm = zeros(1,1,fxdpar.k);
    Lf = zeros(1,1,fxdpar.k);
    
    for r = 1:fxdpar.k
    
	    h_m = dat.h_m(:,:,r);
		h_f = dat.h_f(:,:,r);
    
		s = 0.40*ones(2*fxdpar.N,1);	% Initiate never-married rates
		lns = log(s);					% Use log transformation to avoid problems with non-negatives
		itr = 1;						% Iteration counter
		d = 99;							% Initiate distance (for convergence)
		maxit = 1000;					% Set limit on nr iterations
	
		while d>0.00000001,
		
			s = exp(lns);		% Back to level
			s_m(:,:,r) = s(1:fxdpar.N);					% Split into males...
			s_f(:,:,r) = s(fxdpar.N+1:2*fxdpar.N);		% ... and females
            
			Mm(:,:,r) = (s_m(:,:,r).^((1-PE(3))./(2-PE(1)-PE(2)))).*(s_f(:,:,r)'.^((1-PE(4))./(2-PE(1)-PE(2)))).*((h_f'./h_m).^((1-PE(2))./(2-PE(1)-PE(2)))).*exp((Z+FE(r))./(2-PE(1)-PE(2)));
			Mf(:,:,r) = (s_m(:,:,r).^((1-PE(3))./(2-PE(1)-PE(2)))).*(s_f(:,:,r)'.^((1-PE(4))./(2-PE(1)-PE(2)))).*((h_m./h_f').^((1-PE(1))./(2-PE(1)-PE(2)))).*exp((Z+FE(r))./(2-PE(1)-PE(2)));
			
            o_m(:,:,r) = (exp(z_om).^(1/(1-PE(1)))).*(s_m(:,:,r).^((1-PE(3))/(1-PE(1))));
            o_f(:,:,r) = (exp(z_of).^(1/(1-PE(2)))).*(s_f(:,:,r).^((1-PE(4))/(1-PE(2))));
           
			Fm = s_m(:,:,r) + o_m(:,:,r) + (sum(Mm(:,:,r)'))' - 1;
			Ff = s_f(:,:,r) + o_f(:,:,r) + (sum(Mf(:,:,r)))' - 1;
			
			Fv = [Fm; Ff];
	
			d = max(abs(Fv));
					
			lns = lns - Fv./5;
			
			itr = itr + 1;
		
			if itr>maxit,
				disp('Not converging');
				break;
			end;
			
		end; 	
    end
    clear r;
    
	% Add up log likelihood over male and female types (negative sign as we will use minimizer)
    for r = 1:fxdpar.k
		Lm(r) = -sum(sum([dat.M_pre(:,:,r),dat.s_m(:,:,r),dat.o_m(:,:,r)].*log([Mm(:,:,r), s_m(:,:,r), o_m(:,:,r)]).*repmat(dat.cnt_m(:,:,r),1,fxdpar.N+2)));
		Lf(r) = -sum(sum([dat.F_pre(:,:,r);dat.s_f(:,:,r)';dat.o_f(:,:,r)'].*log([Mf(:,:,r); s_f(:,:,r)'; o_f(:,:,r)']).*repmat(dat.cnt_f(:,:,r)',fxdpar.N+2,1)));	
    end	
    
    % Sum over groups (initiate as zero then add men and women in each groups
    LLik = zeros(1,1);
    for r = 1:fxdpar.k
        LLik = LLik + Lm(r) + Lf(r);
    end
    
    % save
    
    pred2 = struct;
    
    pred2.Mm = Mm;
    pred2.Mf = Mf;
    pred2.s_m = s_m;
    pred2.s_f = s_f;
    pred2.o_m = o_m;
    pred2.o_f = o_f;
    pred2.Lm = Lm;
    pred2.LF = Lf;
    pred2.LLik = LLik;
    
    save('lik_spec2','pred2');