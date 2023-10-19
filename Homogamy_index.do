
/* This file constructs the data for Figure 5 "Tests for Constant Type-Complementarity Across Regions" */ 


/* *** Part 1: Data Preparations *** */	

	use $outdata/completesample_regs.dta, replace;
	
	gen p_edu = .;
	replace p_edu = 1 if p_hiq3cat<=3;
	replace p_edu = 2 if p_hiq3cat==3;
	la def p_edu 1 "GCSE or Below" 2 "A-Level or Above";
	la val p_edu edu;
	drop if single1==0 & p_bornuk==.;
	drop if single1 == 1 & age<28;
				
	count
	sum sex 
	tab married
	
	/* Generate type dummies */
	tab eth, gen(ethdum)
	tab type, gen(typedum)
	tab edu, gen(edudum)
	
	/* Generate an ordering that matches existing figures */
	tab govtof
	gen gr = .
		replace gr = 1 if govtof==7		/* London */
		replace gr = 2 if govtof==5		/* WM */
		replace gr = 3 if govtof==4		/* EM */
		replace gr = 4 if govtof==3		/* Y */
		replace gr = 5 if govtof==2		/* NW */
		replace gr = 6 if govtof==8		/* SE */
		replace gr = 7 if govtof==6		/* Eastern */
		replace gr = 8 if govtof==1		/* NE */
		replace gr = 9 if govtof==9		/* SW */
		replace gr = 10 if govtof==11	/* Sc */
		replace gr = 11 if govtof==10	/* Wales */
	
	/* Extend partner ethnic type to include 0 for single */
		gen p_ethdum0 = married==0
		gen p_ethdum1 = p_eth==1
		gen p_ethdum2 = p_eth==2
		gen p_ethdum3 = p_eth==3 

	/* Extend partner edu type to include 0 for singles */
		gen p_edudum0 = married==0
		gen p_edudum1 = p_edu==1
		gen p_edudum2 = p_edu==2
				
	/* Extend partner (full) type to include 0 for single */
		gen p_typedum0 = married==0
		gen p_typedum1 = p_type==1					/* White low qual */
		gen p_typedum2 = p_type==2					/* Black low qual */
		gen p_typedum3 = p_type==3					/* Asian low qual */
		gen p_typedum4 = p_type==4					/* White hi qual */
		gen p_typedum5 = p_type==5					/* Black hi qual */
		gen p_typedum6 = p_type==6					/* Asian hi qual */
		
	/* Save tmp at this stage */
		save dattmp.dta, replace	
		
		
	/* Generate type distribution by region and gender */
	
		/* Ethnicity only */		
		su gr
		local G = r(max)				/* Nr of groups (=11) */
		
		matrix matethpr = J(`G',7,.)	/* 1 = govtof, 2-4 male props, 5-7 fem props */
		forvalues g=1/`G' {
		
			matrix matethpr[`g',1] = `g'
		
			/* loop over ethnicities */
			forvalues i = 1/3 {

				/* Males */
				local cc = 1+`i'		/* Col counter 2-4 */			
				sum ethdum`i' if sex==1&gr==`g'
				matrix matethpr[`g',`cc'] = r(mean)
				
				/* Females */
				local cc = 4+`i'		/* Col counter 5-7 */	
				sum ethdum`i' if sex==2&gr==`g'
				matrix matethpr[`g',`cc'] = r(mean)
				}
			}	
	
			
	
		mat colnames matethpr = gr matethpr1_m matethpr2_m matethpr3_m matethpr1_f matethpr2_f matethpr3_f					
		drop _all
		svmat matethpr, names(col)	
		sort gr
		save ethpr.dta, replace	
	
		
/* *** Part 2: Define Routine that Computes the Core Sorting Statistic *** */
		
	/* Define programme with six arguments */	
	cap prog drop myratio
	program myratio, rclass
          version 16
          summarize `1' if `5'==1		/* Pr own type spouse, first type */
          local 1m = r(mean)
          summarize `2' if `5'==1		/* Pr opposite type spouse, first type */
          local 2m = r(mean)
          summarize `3' if `6'==1		/* Pr own type spouse, second type */
          local 3m = r(mean)
          summarize `4' if `6'==1		/* Pr opposite type spouse, second type */
          local 4m = r(mean)
          /* set to zero if any empirical proportion is zero */
          if `1m'==0|`2m'==0|`3m'==0|`4m'==0 {
          	local rat = 0
          	}
          if `1m'~=0&`2m'~=0&`3m'~=0&`4m'~=0 {
			* local rat = (`1m'/`2m')*(`3m'/`4m')
			* local rat = (`4m'/`3m')*(`2m'/`1m')
			local rat = log(`1m') + log(`3m') - log(`2m') - log(`4m')
			}
          return scalar ratio = `rat'
 	end

 	
/* *** Part 3: Application - Ethnicity only *** */
 
	/* Compute the sorting measure by type profile, gender, and region */
	
		use dattmp.dta, clear	
	 			
	 	/* Loop over ethnicity pairs (w,b), (w,a), (b,a) */
	 	su gr
	 	local G = r(max)				/* Nr of groups */
	 	local N = 3						/* Nr of types */

	 	/* Set up matrix: nr of pairs, N!/(2!*(N-2)!) */
		local Np = 3					/* N!/(2!*(N-2)!) with N=6 ->15; N=3 -> 3 */		
		local Nr = `Np'*`G'				/* Np rows for each group, so Np x G rows in total */
		matrix mateth1 = J(`Nr',5,.)	/* Males: 1st type, 2nd type, group, est, se */
		matrix mateth2 = J(`Nr',5,.)	/* Females: 1st type, 2nd type, group, est, se */
		
	 	/* Loop over gender: 1=male, 2=female */
		forvalues s = 1/2 {
		 	local kk = 1					
		 	local N0 = `N'-1
		 	/* Loop over first type i = 1,...,N-1 */
		 	forvalues i = 1/`N0' {
			 	local ii = `i'+1
		 		/* Loop over second type j = i+1,...,N */		 	
		 		forvalues j = `ii'/`N' {
		 			/* Loop over groups */
		 			forvalues g = 1/`G' {
				 		preserve
				 		keep if gr==`g'&sex==`s'
				 		bootstrap r(ratio), reps(100) seed(456): myratio p_ethdum`i' p_ethdum`j' p_ethdum`j' p_ethdum`i' ethdum`i'  ethdum`j'
				 			matrix mateth`s'[`kk',1] = `i'
				 			matrix mateth`s'[`kk',2] = `j'
				 			matrix mateth`s'[`kk',3] = `g'
				 			matrix mateth`s'[`kk',4] = e(b)
				 			matrix mateth`s'[`kk',5] = e(se)
				 		restore
				 		local kk = `kk'+1
				 		}
				 	}
				}
			}		
			
	drop _all
		mat dir
		mat list mateth1
		mat list mateth2	

		
	forvalues i = 1/2 {
		svmat mateth`i'
			rename mateth`i'1 type1
			rename mateth`i'2 type2 
			rename mateth`i'3 group
			rename mateth`i'4 stat
			rename mateth`i'5 se
		
		/* Save for graphing in matlab */
		cd "TextFiles"
			outfile using "mateth`i'.txt", nolabel replace comma
		cd ..
		drop _all
	}
	
	cap erase ethpr.dta	
	
	
/* *** Part 4: Application - Qual only *** */
	
	/* Quals only */
		use dattmp.dta, clear	
	 	
	 	/* Loop over edu-pairs: (L,H) [nb loop here is superfluous as only one pair,
	 		 but just recycles the code to avoid mistakes] */
	 	su gr
	 	local G = r(max)
	 	local N = 2

	 	/* Set up matrix: nr of pairs, N!/(2!*(N-2)!) */
		local Np = 1					/* N!/(2!*(N-2)!) with N=6 ->15; N=3 -> 3 */		
		local Nr = `Np'*`G'				/* Np rows for each group */
		matrix matedu1 = J(`Nr',5,.)	/* 1st type, 2nd type, group, est, se */
		matrix matedu2= J(`Nr',5,.)		/* 1st type, 2nd type, group, est, se */
		
	 	/* Loop over gender: 1=male, 2=female */
		forvalues s = 1/2 {
		 	local kk = 1					
		 	local N0 = `N'-1
		 	/* Loop over first type i = 1,...,N-1 */
		 	forvalues i = 1/`N0' {
			 	local ii = `i'+1
		 		/* Loop over second type j = i+1,...,N */		 	
		 		forvalues j = `ii'/`N' {
		 			/* Loop over groups */
		 			forvalues g = 1/`G' {
				 		preserve
				 		keep if gr==`g'&sex==`s'
				 		bootstrap r(ratio), reps(100) seed(456): myratio p_edudum`i' p_edudum`j' p_edudum`j' p_edudum`i' edudum`i' edudum`j'
				 			matrix matedu`s'[`kk',1] = `i'
				 			matrix matedu`s'[`kk',2] = `j'
				 			matrix matedu`s'[`kk',3] = `g'
				 			matrix matedu`s'[`kk',4] = e(b)
				 			matrix matedu`s'[`kk',5] = e(se)
				 		restore
				 		local kk = `kk'+1
				 		}
				 	}
				 }
			}		
			
	drop _all
		mat dir
		mat list matedu1
		mat list matedu2	

	forvalues i = 1/2 {
		svmat matedu`i'
			rename matedu`i'1 type1
			rename matedu`i'2 type2 
			rename matedu`i'3 group
			rename matedu`i'4 stat
			rename matedu`i'5 se
			
		cd "TextFiles"
			outfile using "matedu`i'.txt", nolabel replace comma	
		cd ..
		
		drop _all
	} 	
 	 
	
	cap erase dattmp.dta
