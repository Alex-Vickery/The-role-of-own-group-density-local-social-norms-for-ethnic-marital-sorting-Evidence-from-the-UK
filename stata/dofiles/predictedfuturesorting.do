	# delimit ;
	clear; 
	clear matrix;
	set mem 500m;
	set more 1;
	version 11.0;
	
	capture log close;


/* Alex's Path and Log (on Macbook) */

	global mainpath "pathname";		/* Main path */
	global outdata "pathname";		/* Where to save final data */
	global matlab	"pathname";		/* matlab path */
	
	/* load in the original sample */
	use $outdata/completesample_regs.dta, clear;
	
	/* generate partner education identifier */
	gen p_edu = .;
	replace p_edu = 1 if p_hiq3cat<=3;
	replace p_edu = 2 if p_hiq3cat==3;
	la def p_edu 1 "GCSE or Below" 2 "A-Level or Above";
	la val p_edu edu;
	/* marital status identifier */
	drop if single1==0 & p_bornuk==.;
	drop if single1 == 1 & age<28;
	
	/* male dummy */
	gen male = 0;
	replace male = 1 if sex == 1;
	gen highed = 0;
	replace highed = 1 if edu == 2;  
	
	bysort accoh govtof sex eth: egen palvlplus = mean(highed);
	tab govtof, gen(reg_dum);
	
	/* regression to predict future education attainment */
	reg palvlplus accoh reg_dum* male ethdum2 ethdum3;
	
	/* loop over regions  */
	forvalues r = 1/11{;
		scalar future_edu_wm`r' = 100*_b[accoh] + _b[reg_dum`r'] + _b[male] + _b[_cons]; 
		scalar future_edu_wf`r' = 100*_b[accoh] + _b[reg_dum`r'] + _b[_cons];
		scalar future_edu_bm`r' = 100*_b[accoh] + _b[reg_dum`r'] + _b[male] + _b[ethdum2] + _b[_cons];
		scalar future_edu_bf`r' = 100*_b[accoh] + _b[reg_dum`r'] + _b[ethdum2] + _b[_cons];
		scalar future_edu_am`r' = 100*_b[accoh] + _b[reg_dum`r'] + _b[male] + _b[ethdum3] + _b[_cons];
		scalar future_edu_af`r' = 100*_b[accoh] + _b[reg_dum`r'] + _b[ethdum3] + _b[_cons];
		
		cap matrix drop edu`r';
		matrix edu`r' = J(2,6,.);
		
		matrix edu`r'[1,1] = 1-future_edu_wm`r';
		matrix edu`r'[1,2] = future_edu_wm`r';
	
		matrix edu`r'[1,3] = 1-future_edu_bm`r';
		matrix edu`r'[1,4] = future_edu_bm`r';
	
		matrix edu`r'[1,5] = 1-future_edu_am`r';
		matrix edu`r'[1,6] = future_edu_am`r';
	
		matrix edu`r'[2,1] = 1-future_edu_wf`r';
		matrix edu`r'[2,2] = future_edu_wf`r';
	
		matrix edu`r'[2,3] = 1-future_edu_bf`r';
		matrix edu`r'[2,4] = future_edu_bf`r';
	
		matrix edu`r'[2,5] = 1-future_edu_af`r';
		matrix edu`r'[2,6] = future_edu_af`r';
	
	};
		
		/* correct for the forecast error - can't be below 0 or bigger than 1 */
		matrix edu7[1,5] = 0.01;
		matrix edu7[1,6] = 0.99;
		matrix edu7[2,5] = 0.005;
		matrix edu7[2,6] = 0.995;
	
	clear;
	use $tempdata/lfsind.dta, clear;
	
	keep if bornuk==1;
	keep if accoh>=90 & accoh<=106;
	
	/* keep white, black, asian - drop missing */
	drop if ethnic4 == 4 | ethnic4 ==.;
	
	
	/* fix regions */
	drop if (region == 17)|(region==.);
	replace region = 1 if region == 2;
	recode region (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (15=14) (16=15) ;
	la def region 1 "Rest of North" 2 "South Yorkshire" 3 "West Yorkshire" 4 "Rest of Yorkshire" 5 "East Midlands" 6 "East Anglia" 7 "London" 8 "Rest of South East" 9 "South West" 10 "West Midlands" 11 "Greater Manchester" 12 "Merseyside" 13 "Rest of North West" 14 "Wales" 15 "Scotland", replace;
	la val region region;
	
	replace govtof = 2 if govtof == 3;
	recode govtof (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) ;
	la def govtof 1 "North East" 2 "North West" 3 "Yorkshire and Humberside" 4 "East Midlands" 5 "West Midlands" 6 "Eastern" 7 "London" 8 "South East" 9 "South West" 10 "Wales" 11 "Scotland", replace;
	la val govtof govtof;
	drop if govtof==.;
	
	save $matlab/counterfactual_sample.dta, replace;
	
	/* loop over regions */
	forvalues r = 1/11{;
	
	count if sex==1 & govtof==`r';
	scalar males`r'r = r(N);
	
	count if sex==2 & govtof==`r';
	scalar females`r'r = r(N);
	
	/* qual distribution */
	cap matrix drop Qual_pre`r'r;
	matrix Qual_pre`r'r = J(2,6,.);
	forvalues t = 1/3 {; /* loop over eth categories */
	forvalues s = 1/2 {; /* loop over genders */
	forvalues e = 1/2 {;
	
	count if sex==`s' & ethnic4==`t' & govtof==`r';
	scalar t`t's`s'qual`r'r = r(N);
	
	if `s' == 1 {;
		scalar t`t's`s'qualp`r'r = t`t's`s'qual`r'r/males`r'r;
	};
	if `s' == 2 {;
		scalar t`t's`s'qualp`r'r = t`t's`s'qual`r'r/females`r'r;
	};
	
	if `t'==1 {;
		matrix Qual_pre`r'r[`s',`t'*`e'] = t`t's`s'qualp`r'r;
	};
	if `t'==2 {;
		matrix Qual_pre`r'r[`s',`t'+`e'] = t`t's`s'qualp`r'r;
	};
	if `t'==3 {;
		matrix Qual_pre`r'r[`s',`t'+`e'+1] = t`t's`s'qualp`r'r;
	};
	
	};
	};
	};
	};
	
	
	forvalues r = 1/11 {;
	forvalues i = 1/2 {;
	forvalues j = 1/6 {;
		
		matrix Qual_pre`r'r[`i',`j'] = Qual_pre`r'r[`i',`j']*edu`r'[`i',`j'];
		
	};
	};
	};
	
	
	forvalues r = 1/11 {;
	
	svmat Qual_pre`r'r;
	outfile Qual_pre`r'r* using "$matlab/Qual_prereg`r'.txt" if _n<=2, replace;
	
	};
	
	scalar drop _all;
	
	/**************************************************************************/

	/* population counts */
	
	/* loop over regions */
	forvalues r = 1/11{;
	
	/* population counts */
	cap matrix drop cnt_pre`r'r;
	matrix cnt_pre`r'r = J(2,6,.);
	forvalues t = 1/3 {; /* loop over eth categories */
	forvalues s = 1/2 {; /* loop over genders */
	forvalues e = 1/2 {; 
	
	count if sex==`s' & ethnic4==`t' & govtof==`r';
	scalar t`t'cnt`s't`r'r = r(N);
	
	if `t'==1 {;
		matrix cnt_pre`r'r[`s',`t'*`e'] = t`t'cnt`s't`r'r;
	};
	if `t'==2 {;
		matrix cnt_pre`r'r[`s',`t'+`e'] = t`t'cnt`s't`r'r;
	};
	if `t'==3 {;
		matrix cnt_pre`r'r[`s',`t'+`e'+1] = t`t'cnt`s't`r'r;
	};
	
	};
	};
	};
	};
	
	forvalues r = 1/11 {;
	forvalues i = 1/2 {;
	forvalues j = 1/6 {;
		
		matrix cnt_pre`r'r[`i',`j'] = cnt_pre`r'r[`i',`j']*edu`r'[`i',`j'];
		
	};
	};
	};
	
	forvalues r = 1/11 {;
	
	svmat cnt_pre`r'r;
	outfile cnt_pre`r'r* using "$matlab/cnt_prereg`r'.txt" if _n<=2, replace;
		};
	
/*************************************************************************/
/*************************************************************************/
/*************************************************************************/
	
	
