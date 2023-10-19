
/* This file generates Table 2: The effect of the Own Ethnicity Share on the Probability of Being Intra-Ethnically
Married */
	
	# delimit ;
	clear; 
	clear matrix;
	set mem 500m;
	set more 1;
	version 14.0;
	
	capture log close;

	
/* Regressions of intra-ethnic marriage frequency */

	use $outdata/completesample_regs.dta, replace;
	gen p_edu = .;
	replace p_edu = 1 if p_hiq3cat<=3;
	replace p_edu = 2 if p_hiq3cat==3;
	la def p_edu 1 "GCSE or Below" 2 "A-Level or Above";
	la val p_edu edu;
	drop if single1==0 & p_bornuk==.;
	drop if single1 == 1 & age<28;
		
	
	/* Confirming the cell counts in Table 1: Descriptive Statistics of the QLFS Sample */
	forvalues s = 1/2 { ;
		forvalues j = 1/2 {;
			forvalues k = 1/3 {;
				
				count if sex==`s'&edu==`j'&eth==`k';
				};
			};
		};
		
	count;
	
	
	/* Instruments */
		
	/* Cell Frequency 1940-60 - taken from the LFS data on those cohorts */
	gen z4060 = .;
		replace z4060 = .9881493 if eth == 1 & govtof == 1;
		replace z4060 = .9673615 if eth == 1 & govtof == 2; 
		replace z4060 = .9678486 if eth == 1 & govtof == 3;
		replace z4060 = .9514415 if eth == 1 & govtof == 4;
		replace z4060 = .9399757 if eth == 1 & govtof == 5;
		replace z4060 = .9670820 if eth == 1 & govtof == 6;
		replace z4060 = .7686310 if eth == 1 & govtof == 7;
		replace z4060 = .9674351 if eth == 1 & govtof == 8;
		replace z4060 = .9888695 if eth == 1 & govtof == 9;
		replace z4060 = .9915171 if eth == 1 & govtof == 10;
		replace z4060 = .9919726 if eth == 1 & govtof == 11;
		
		replace z4060 = .0015930 if eth == 2 & govtof == 1;
		replace z4060 = .0053412 if eth == 2 & govtof == 2; 
		replace z4060 = .0058791 if eth == 2 & govtof == 3;
		replace z4060 = .0078429 if eth == 2 & govtof == 4;
		replace z4060 = .0121822 if eth == 2 & govtof == 5; 
		replace z4060 = .0080738 if eth == 2 & govtof == 6;
		replace z4060 = .0873710 if eth == 2 & govtof == 7;
		replace z4060 = .0064448 if eth == 2 & govtof == 8;
		replace z4060 = .0035304 if eth == 2 & govtof == 9;
		replace z4060 = .0017638 if eth == 2 & govtof == 10;
		replace z4060 = .0005393 if eth == 2 & govtof == 11;
		
		replace z4060 = .0102576 if eth == 3 & govtof == 1;
		replace z4060 = .0272974 if eth == 3 & govtof == 2; 
		replace z4060 = .0262723 if eth == 3 & govtof == 3;
		replace z4060 = .0407157 if eth == 3 & govtof == 4;
		replace z4060 = .0478422 if eth == 3 & govtof == 5; 
		replace z4060 = .0248443 if eth == 3 & govtof == 6;
		replace z4060 = .1439980 if eth == 3 & govtof == 7;
		replace z4060 = .0261202 if eth == 3 & govtof == 8;
		replace z4060 = .0076001 if eth == 3 & govtof == 9;
		replace z4060 = .0067191 if eth == 3 & govtof == 10;
		replace z4060 = .0074881 if eth == 3 & govtof == 11;
	
		
	/* Create Proportion Own Ethnicity */
	
	bysort govtof: egen tot = count(eth);					/* total count of non-zeros */
	
	forvalues i = 1/3 {;
		bysort govtof: egen eth`i' = count(eth) if eth==`i';
		bysort govtof: gen prop`i' = (eth`i'/tot) if eth==`i';
		replace prop`i'=0 if prop`i'==.;
		};
		
	gen propown = prop1 + prop2 + prop3;
		
	order eth eth1 eth2 eth3 tot prop1 prop2 prop3 propown;	
	drop eth1 eth2 eth3 tot prop1 prop2 prop3;

	gen lnz = log(z4060);
		
	save ownpropdta.dta, replace;

	/* Loop over ethnicities and gender */
	forvalues z = 1/3 {;
		forvalues j = 1/2 {;
			
			use ownpropdta.dta, clear; 
			keep if sex==`j' & marrieduk==1 & eth==`z';
	
			gen intra = 0;
			replace intra = 1 if p_eth==`z' & p_eth!=.;
			
			gen highqual = 0;
			replace highqual = 1 if edu == 2;
		
			probit intra propown, vce(robust);
			margins, dydx(propown) predict(pr);
			
			ivprobit intra (propown=lnz), vce(robust) first;
			margins, dydx(propown) predict(pr);
			
			reg propown z4060;
			
			};
		};
