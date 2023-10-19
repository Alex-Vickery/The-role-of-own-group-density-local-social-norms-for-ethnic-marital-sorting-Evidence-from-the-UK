
/* This file create Table C.1: Specification Tests */

	
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

		use dattmp.dta, clear
		su gr
		local G = r(max)				/* Nr of groups (=11) */
		
		matrix mattyppr = J(`G',13,.)	/* 1 = govtof, 2-7 male props, 8-13 fem props */
		forvalues g=1/`G' {
		
			matrix mattyppr[`g',1] = `g'
		
			/* loop over types */
			forvalues i = 1/6 {

				/* Males */
				local cc = 1+`i'		/* Col counter 2-7 */			
				qui sum typedum`i' if sex==1&gr==`g'
				matrix mattyppr[`g',`cc'] = r(mean)
				
				/* Females */
				local cc = 7+`i'		/* Col counter 8-13 */	
				qui sum typedum`i' if sex==2&gr==`g'
				matrix mattyppr[`g',`cc'] = r(mean)
				}
			}	
		
		mat colnames mattyppr = gr mattyppr1_m mattyppr2_m mattyppr3_m mattyppr4_m mattyppr5_m mattyppr6_m mattyppr1_f mattyppr2_f mattyppr3_f mattyppr4_f mattyppr5_f mattyppr6_f					
		drop _all
		svmat mattyppr, names(col)	
		sort gr
		save typpr.dta, replace					
		

		
/* ************ Part 2: Specification Test Full Type ************* */

	use typpr.dta, clear
	mkmat *, mat(typmatpr)		
	matrix typmatst = J(11,1,.)
		
	/* Define programme that returns beta-coefficient */
	cap prog drop myratio
	program myratio, rclass

		preserve	
		
		forvalues g = 1/11 {
			qui summarize p_typedum`1' if typedum`1'==1&sex==`3'&gr==`g'		/* Pr own type spouse, first type */
			local 1m = r(mean)
			qui summarize p_typedum`2' if typedum`1'==1&sex==`3'&gr==`g'		/* Pr opposite type spouse, first type */
			local 2m = r(mean)
			qui summarize p_typedum`2' if typedum`2'==1&sex==`3'&gr==`g'		/* Pr own type spouse, second type */
			local 3m = r(mean)
			qui summarize p_typedum`1' if typedum`2'==1&sex==`3'&gr==`g'		/* Pr opposite type spouse, second type */
			local 4m = r(mean)
	 	
			if `1m'==0|`2m'==0|`3m'==0|`4m'==0 {
	          	local rat = 0
	          	}
	         if `1m'~=0&`2m'~=0&`3m'~=0&`4m'~=0 {
				local rat = log(`1m') + log(`3m') - log(`2m') - log(`4m')
				}
			matrix typmatst[`g',1] = `rat'
			}
			matrix colnames typmatst = stat
		
		mat typmat = typmatpr,typmatst
		drop _all	
		svmat typmat, names(col)

		* reg stat `4' if stat>0				/* With London 	  */
		reg stat `4' if stat>0&gr~=1		/* Without London */
		
		restore
		return scalar ratio = _b[`4']
	end
	
	
	/* Run for Whites Low Qual (type 1) */	
	use dattmp.dta, clear
	local r = 1
	matrix zval = J(120,7,.)
	/* Loop over types 2-6  */
	forvalues kk = 2/6 {
		/* Loop over gender (2) */
		forvalues s = 1/2 {
			/* Loop over pop supply dimension gender/type (12 in total) */
			local ki = 1
			foreach k in m f {
				forvalues i = 1/6 {

					matrix zval[`r',1] = 1			/* First type */
					matrix zval[`r',2] = `kk'		/* Second type */
					matrix zval[`r',3] = `s'		/* Gender for sorting measure */
					matrix zval[`r',4] = `i'		/* Type in population measure */
					matrix zval[`r',5] = `ki'		/* Gender in population measure */
				
					bootstrap r(ratio), reps(100) seed(456): myratio 1 `kk' `s' mattyppr`i'_`k' 
					matrix zval[`r',6] = e(b)
					matrix zval[`r',7] = e(se)
					local r = `r'+1
					}
				local ki = `ki'+1	
				}
			}
		}
				
	drop _all
	svmat zval
		rename zval1 typ1 
		rename zval2 typ2 
		rename zval3 gendersort
		rename zval4 typpopsup	 
		rename zval5 genpopsup	 
		rename zval6 betacoef
		rename zval7 secoef
	gen sqstdcoef = (1/2)*(betacoef/secoef)^2
	save zval1, replace
	
	
	/* Run for Whites High Qual (type 4) */	
	use dattmp.dta, clear
	local r = 1
	matrix zval = J(120,7,.)
	/* Given first type = 4, loop over types 1-3 and 5-6 */
	foreach kk of numlist 1/3 5/6 {
		/* Loop over gender (2) */
		forvalues s = 1/2 {
			/* Loop over pop supply dimension gender/type (12 in total) */
			local ki = 1
			foreach k in m f {
				forvalues i = 1/6 {

					matrix zval[`r',1] = 4			/* First type */
					matrix zval[`r',2] = `kk'		/* Second type */
					matrix zval[`r',3] = `s'		/* Gender for sorting measure */
					matrix zval[`r',4] = `i'		/* Type in population measure */
					matrix zval[`r',5] = `ki'		/* Gender in population measure */
				
					bootstrap r(ratio), reps(100) seed(456): myratio 4 `kk' `s' mattyppr`i'_`k' 
					matrix zval[`r',6] = e(b)
					matrix zval[`r',7] = e(se)
					local r = `r'+1
					}
				local ki = `ki'+1	
				}
			}
		}
				
	drop _all
	svmat zval
		rename zval1 typ1 
		rename zval2 typ2 
		rename zval3 gendersort
		rename zval4 typpopsup	 
		rename zval5 genpopsup	 
		rename zval6 betacoef
		rename zval7 secoef
	gen sqstdcoef = (1/2)*(betacoef/secoef)^2
	save zval2, replace	

	/* Run for Black/Asian Low v High Qual: types (2,5), (3,6) */	
	use dattmp.dta, clear
	local r = 1
	matrix zval = J(48,7,.)
	/* Given first type = 2, let other be 5; Given first type = 3, let other be 6 */
	forvalues kk = 2/3 {
		local kkk = `kk' + 3
		/* Loop over gender (2) */
		forvalues s = 1/2 {
			/* Loop over pop supply dimension gender/type (12 in total) */
			local ki = 1
			foreach k in m f {
				forvalues i = 1/6 {

					matrix zval[`r',1] = `kk'		/* First type */
					matrix zval[`r',2] = `kkk'		/* Second type */
					matrix zval[`r',3] = `s'		/* Gender for sorting measure */
					matrix zval[`r',4] = `i'		/* Type in population measure */
					matrix zval[`r',5] = `ki'		/* Gender in population measure */
				
					bootstrap r(ratio), reps(100) seed(456): myratio `kk' `kkk' `s' mattyppr`i'_`k' 
					matrix zval[`r',6] = e(b)
					matrix zval[`r',7] = e(se)
					local r = `r'+1
					}
				local ki = `ki'+1	
				}
			}
		}
				
	drop _all
	svmat zval
		rename zval1 typ1 
		rename zval2 typ2 
		rename zval3 gendersort
		rename zval4 typpopsup	 
		rename zval5 genpopsup	 
		rename zval6 betacoef
		rename zval7 secoef
	gen sqstdcoef = (betacoef/secoef)^2
	save zval3, replace		

	/* Append results together */
	clear
	use zval1
	append using zval2
	drop if typ1==4&typ2==1
	append using zval3
	cap drop if typ1==.
		
	/* Define left-out type */
	gen leftouttype = genpopsup==2&typpopsup==3
	
	/* All types */	
	sum sqstdcoef if leftouttype==0
	
	/* Current types */
	sum sqstdcoef if (typpopsup== typ1) | (typpopsup== typ2)
