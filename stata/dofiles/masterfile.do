/* Masterfile */

/*******************************************************************************************************
********************************************************************************************************
	
	LFS Marital Matching With Peer Effects 

	
	Part 0: PROGRAMME DEFINITIONS
	Part 1: SELECTING YEARS, EXTRACT, CODE AND PREPARE TO COLLATE MASTER DATA
	Part 2: ADDING PARTNER INFORMATION TO THE DATASET
	Part 3: COLLATE MASTER DATA
	Part 4: DATA INSPECTION
	Part 5: SAMPLE SELECTION
	Part 6: MARRIAGE MATRICES

	
********************************************************************************************************/
********************************************************************************************************/

# delimit ;
clear all;
set mem 500m;
set more 1;
version 10.1;
capture log close;

/* Alex's Path and Log (on Macbook) */

	global mainpath "pathname/stata";			/* Main path */
	global indata "pathname/indata";			/* Where to find the data */
	global tempdata "pathname/tempdata";		/* Where to temporarily store data */
	global outdata "pathname/outdata";			/* Where to save final data */
	global qualpath "pathname/qualpath";		/* Path for qualifications analysis */
	global logpath	"/pathname/log";			/* Log path */
	global graphs	"pathname/graphs";			/* Log path */
	global matlab	"pathname/matlab";			/* matlab path */
	
/*******************************************************************************************************
********************************************************************************************************

	Part 0: PROGRAMME DEFINITIONS

********************************************************************************************************
********************************************************************************************************/
	
/*********************/
/**** Age Program ****/
/*******************************************************************************************************/
 
	cap prog drop ageprg;
	prog def ageprg;	
		/* Vars used: age/fage, lfsyear, refweekm/refwkm, doby, dobm
			Generates: Age in year, age in months. */
		
		cap rename fage age;
		cap rename refwkm refweekm;
		cap rename refwky refweeky;
		replace refweekm=4 if refweekm<0;			/* A few hundred missing; impute April */

		/* Age in years */
		replace age = . if age<0;
		
		/* fix doby variable */
		/*replace doby = doby + 1900 if doby<100;*/
		
		/* Age in months */
		gen agem = ((refweeky-1900)*12 + refweekm) - (12*(doby-1900) + dobm) + 12*100*((doby-1900)>lfsyear);
		
		/* Scan for mistakes */
		gen agediff = age - (agem/12);
		gen markage = (agediff <-1|agediff>1);
		replace agem = 12*age if markage==1&(doby-1900)<=lfsyear;		/* Over 100 yrs olds */
		replace markage = 0 if markage==1&(doby-1900)<=lfsyear; 		/* Corrected */
		count if markage==1;
		drop markage agediff;
		
		lab var agem "Age measured in months";
		
	end;
/*******************************************************************************************************/

/*********************************/	
/**** Interview Month Program ****/
/*******************************************************************************************************/

	cap prog drop intmonth;
	prog def intmonth;
		/* Vars used: lfsyear, refweekm/refwkm. Generates: Index for interview month, Jan 1950 = 1 */
		cap rename refwkm refweekm;
		cap rename refwky refweeky;
		gen intm = (refweeky-1950)*12 + refweekm;
		lab var intm "Interview month (Jan 1950 = 1)";
	end;	
/*******************************************************************************************************/	

/********************************/		
/**** Marital Status Program ****/
/*******************************************************************************************************/

	cap prog drop mrstat;
	prog def mrstat;
		/* Vars used: marstt/marsta  */	
				
		if (lfsyear<=105) {;
			gen single = marstt==1;
				lab var single "Marital status = single";
			gen married = marstt==2;
				lab var married "Marital status = married (living with)";
			gen marriedsep = marstt==3;
					lab var marriedsep "Marital status = married (seperated)";
			gen widowed = marstt==5;
				lab var widowed "Marital status = widowed";
			gen divorced = marstt==4;
				lab var divorced "Marital status = divorced";
			replace single = . if marstt<0;
			replace married = . if marstt<0;
			replace widowed = . if marstt<0;
			replace divorced = . if marstt<0;
			};
			
		else if (lfsyear>=106) {;
			gen single = marsta==1;
				lab var single "Marital status = single";
			gen married = marsta==2;
				lab var married "Marital status = married";
			gen marriedsep = marsta==3;
				lab var marriedsep "Marital status = married (seperated)";
			gen widowed = marsta==5;
				lab var widowed "Marital status = widowed";
			gen divorced = marsta==4;
				lab var divorced "Marital status = divorced";
			replace single = . if marsta<0;
			replace married = . if marsta<0;
			replace widowed = . if marsta<0;
			replace divorced = . if marsta<0;
			};
				
	end;
/*******************************************************************************************************/
	
/**********************************/
/**** Geography Coding Program ****/
/*******************************************************************************************************/ 

	/* Have region (gor), unitary authority (uala) and nuts codes (nuts2, nuts3) */
	
	cap prog drop regionprg;
	prog def regionprg;
		/* Vars used: urescom, nuts2, nuts3 (where available) */	

		/* Rename the original regions variables */
		cap ren urescomf urescom;
		cap ren urescomg urescom;
		cap ren urescomh urescom;
		cap ren urescomj urescom;
		cap ren uresmca urescom;
		cap ren uresmc urescom;
		
		cap drop region;
		gen region = .;
			replace region = 1 if urescom==1;		/* Tyne and Wear */
			replace region = 2 if urescom==2;		/* Rest of North Region */
			replace region = 3 if urescom==3;		/* South Yorkshire */
			replace region = 4 if urescom==4;		/* West Yorkshire */
			replace region = 5 if urescom==5;		/* Rest of Yorks&H'side */
			replace region = 6 if urescom==6;		/* East Midlands Region */
			replace region = 7 if urescom==7;		/* East Anglia Region */
			replace region = 8 if (urescom>=8 & urescom<=9 & lfsyear>=103); 		/* London */
			replace region = 9 if (urescom==10 & lfsyear>=103); 					/* Rest of SE England */
			replace region = 10 if (urescom==11 & lfsyear>=103); 					/* South West Region */
			replace region = 11 if (urescom>=12 & urescom<=13 & lfsyear>=103); 		/* West Midlands */		
			replace region = 12 if (urescom==14 & lfsyear>=103); 					/* Greater Manchester */
			replace region = 13 if (urescom==15 & lfsyear>=103); 					/* Merseyside */
			replace region = 14 if (urescom==16 & lfsyear>=103); 					/* Rest of NW Region */
			replace region = 15 if (urescom==17 & lfsyear>=103); 					/* Wales */
			replace region = 16 if (urescom>=18 & urescom<=19 & lfsyear>=103); 		/* Scotland */
			replace region = 17 if (urescom==20 & lfsyear>=103); 					/* NI */
		
		la def region 1 "Tyne and Wear" 2 "Rest of North" 3 "South Yorkshire" 4 "West Yorkshire" 5 "Rest of Yorkshire" 6 "East Midlands" 7 "East Anglia" 8 "London" 9 "Rest of South East" 10 "South West" 11 "West Midlands" 12 "Greater Manchester" 13 "Merseyside" 14 "Rest of North West" 15 "Wales" 16 "Scotland" 17 "Northern Ireland";
		la val region region;
		
		gen byte london = (urescom>=8 & urescom<=9 & lfsyear>=103);
		gen byte se = (urescom==10 & lfsyear>=103);
		la var london "London";
		la var se "Southeast region";

		gen byte nireland = (urescom==20 & lfsyear>=103);
		gen byte scotland = ((urescom==18 | urescom==19) & lfsyear>=103);
		gen byte wales = (urescom==17 & lfsyear>=103);

		gen ctryinuk = (wales==1) + (scotland==1)*2 + (nireland==1)*3;
		la var ctryinuk "Countries within the UK";
		la def ctryinuk 0 "England" 1 "Wales" 2 "Scotland" 3 "Northern Ireland";
		la val ctryinuk ctryinuk;
	
	end;
/*******************************************************************************************************/ 

/**********************************/	
/**** Country of Birth Program ****/
/*******************************************************************************************************/ 

	cap prog drop cntrybrth;
	prog def cntrybrth;
		/* Vars used: cry01/cry12 */	

		gen bornuk = .;		
						
		if (lfsyear>=102 & lfsyear<=106) {;
			replace bornuk = (cry01==1|cry01==2|cry01==3|cry01==4|cry01==5);		/* Including UK, Britain (Don't know country */
			replace bornuk = . if cry01<0;
			};
			
		else if (lfsyear>=107 & lfsyear<=111) {;
			replace bornuk = (cry01==921|cry01==924|cry01==923|cry01==922|cry01==926);		/* Including UK, Britain (Don.t know country) */
			replace bornuk = . if cry01<0;
			};
			
		else if (lfsyear>=112 & lfsyear<=116) {;
			replace bornuk = (cry12==921|cry12==924|cry12==923|cry12==922|cry12==926);		/* UK, Includes Britain Don.t know country) */
			replace bornuk = . if cry12<0;
			};
	end;
/*******************************************************************************************************/ 

/***************************************/	
/**** Qualifications Coding Program ****/
/*******************************************************************************************************/ 

	cap prog drop qualsprg;
	prog def qualsprg;
	
		/* Coding strategy: Aim to generate a consistent 15 category classification, arranged
			around the information that was available during the 1980s, and including 
			trade apprenticeships. See LSE documentation. */

		cap rename refwkm refweekm;	
		
		/* 2015 onwards */
		if lfsyear>=115 {;
			sort hiqual15;
			cap drop _merge;
			merge hiqual15 using "$qualpath/qualkey15plus", keep(hiq15cat);
			cap drop _merge;
			};
		
		
		/* 2011 - 2014 */
		else if lfsyear>=111 & lfsyear<=114 {;
			sort hiqual11;
			cap drop _merge;
			merge hiqual11 using "$qualpath/qualkey11plus", keep(hiq15cat);
			cap drop _merge;
			};
		
		
		/* 2008 - 2011 */
		else if lfsyear>=108 & lfsyear<=110 {;
			sort hiqual8;
			cap drop _merge;
			merge hiqual8 using "$qualpath/qualkey08plus", keep(hiq15cat);
			cap drop _merge;
			};
		

		/* 2005 Q2 -> 2007 */
		else if (lfsyear==105|lfsyear==106|lfsyear==107) {;
			sort hiqual5;
			cap drop _merge;
			merge hiqual5 using "$qualpath/qualkey05plus", keep(hiq15cat);
			cap drop _merge;
			};		
			
		/* 2004 Q2-Q4 */	
		else if lfsyear==104 & lfsqrtr>=2 {;
			sort hiqual4;
			cap drop _merge;
			merge hiqual4 using "$qualpath/qualkey04", keep(hiq15cat);
			cap drop _merge;
			};
			
		/* 2004 Q1 */	
		else if lfsyear==104 & lfsqrtr==1 {;
			sort hiqual4;														/* Available from March */
			cap drop _merge;
			merge hiqual4 using "$qualpath/qualkey04", keep(hiq15cat);			/* March-relevant info */
			cap drop _merge;
			* as hiq15cat~=.;														/* Verify that the 15-cat variable is currently not missing for anyone! (IMPORTANT) */
			replace hiq15cat = . if refweekm==12|refweekm==1|refweekm==2;		/* Set to missing for those where the earlier 31-cat classification applies */
			sort hiqual;														/* Sort the variable that applies for the earlier months */
			cap drop _merge;
			merge hiqual using "$qualpath/qualkey96plus", keep(hiq15cat) update;
			cap drop _merge;
			};						
		
		/* 96-Q2 onwards to 2003 */
		else if (lfsyear>=97&lfsyear<=103) {;
			sort hiqual;
			cap drop _merge;
			merge hiqual using "$qualpath/qualkey96plus", keep(hiq15cat) update;
			cap drop _merge;
		};
				
		/* We can now also put in the condensed 6 category classification */	
		sort hiq15cat;
			merge hiq15cat using "$qualpath/qual15key.dta", keep(hiq6cat nvqequiv);
		cap drop _merge;			
		
		/* Tidy up the 6 category educational attainment classification */
		/* Drop missing and unknown */
	
		recode hiq6cat 4 = 7;
		recode hiq6cat 5 = 8;
		recode hiq6cat 6 = 9;
		recode hiq6cat 1 = 6;
		recode hiq6cat 2 = 5;
		recode hiq6cat 3 = 4;
		recode hiq6cat 7 = 3;
		recode hiq6cat 8 = 2;
		recode hiq6cat 9 = 1;
	
		la def hiq6cat 6 "Degree or Higher" 5 "Higher Education" 4 "A Level Eq." 3 "GCSE Eq." 2 "Other Qua." 1 "No Qua.";
		la val hiq6cat hiq6cat;
		replace hiq6cat=. if hiq6cat==-8|hiq6cat==-9;
		
		/* Create a Smaller 3 category qualification classification */ 
		
		gen hiq3cat = . ;		
		replace hiq3cat = . if hiq15cat<0;
		replace hiq3cat = 1 if (hiq15cat>=13 & hiq15cat<=15);
		replace hiq3cat = 2 if (hiq15cat>=11 & hiq15cat<=12);
		replace hiq3cat = 3 if (hiq15cat<11 & hiq15cat>=1);
	
		la def hiq3cat 1 "No Qual/Other" 2 "GCSE or Equiv" 3 "A-Level or Higher";
		la val hiq3cat hiq3cat;
		
						
	end;
/*******************************************************************************************************/ 
	
/****************************************/	
/**** Another Age and Cohort Program ****/
/*******************************************************************************************************/ 

	cap prog drop cohortprg;
	prog def cohortprg;
		/* Vars used: doby dobm */
	
		/* Month Cohort */
		gen mcoh = ((doby-1900) - 50)*12 + dobm;
		la var mcoh "Month cohort (Jan 1950=1, Jan 1958=97)";
		
		/* When aged 18? */
		gen when18 = mcoh + 18*12;
		lab var when18 "Month when turning 18 (Jan 1950=1)";
		
		/* Academic Cohort */
		gen accoh = floor((mcoh - 105)/12) + 58;
		qui tab accoh, gen(accohdum);
		lab var accoh "Academic cohort (i.e. = 57 if born Sept 57 - Aug 58)";
	
		/* Month within academic year */
		gen minacc = (dobm - 8) + 12*(dobm<=8);
		lab var minacc "Month within academic cohort (i.e. Sept = 1)";
	
		/* "Autumn/Spring born" */
		gen autmborn = (dobm==9|dobm==10|dobm==11|dobm==12|dobm==1);
			lab var autmborn "Born Sept - Jan";
			label define autmborn 1 "autumn born" 0 "spring born";
		gen spriborn = -autmborn + 1;
			lab var spriborn "Born Feb - Aug";
			label define spriborn 1 "spring born" 0 "autm born";

		/* Renumbering the months in a convenient way */
		gen dobrfeb = dobm;
		recode dobrfeb 1 = 0 12=-1 11=-2 10=-3 9=-4;
		replace dobrfeb = dobm-1 if dobm>=2&dobm<=8;
		lab var dobrfeb "MoB relative to February (i.e. Feb = 1, Jan=0, Dec=-1 etc.)";
		
		/* Creating Academic Cohorts - (10 Year Bins) */ 
	
		gen accoh10 =. ;
	
		replace accoh10 = 50 if accoh >=50 & accoh<60;
		replace accoh10 = 60 if accoh >=60 & accoh<70;
		replace accoh10 = 70 if accoh >=70 & accoh<80;
		replace accoh10 = 80 if accoh >=80 & accoh<90;
		replace accoh10 = 90 if accoh >=90 & accoh<100; 
	
		la def accoh10 50 "1950-59 Birth Cohort" 60 "1960-69 Birth Cohort" 70 "1970-79 Birth Cohort" 80 "1980-89 Birth Cohort" 90 "1990-99 Birth Cohort";
		la val accoh10 accoh10;
	
		/* Creating Academic Cohorts - (5 Year Bins) */ 
		
		gen accoh5 =.;
	
		replace accoh5 = 1950 if accoh >=50 & accoh<55;
		replace accoh5 = 1955 if accoh >=55 & accoh<60;
		replace accoh5 = 1960 if accoh >=60 & accoh<65;
		replace accoh5 = 1965 if accoh >=65 & accoh<70;
		replace accoh5 = 1970 if accoh >=70 & accoh<75;
		replace accoh5 = 1975 if accoh >=75 & accoh<80;
		replace accoh5 = 1980 if accoh >=80 & accoh<85;
		replace accoh5 = 1985 if accoh >=85 & accoh<90;
		replace accoh5 = 1990 if accoh >=90 & accoh<95;
		replace accoh5 = 1995 if accoh >=95 & accoh<100; 
	
		la def accoh5 1950 "1950-54 Birth Cohort" 1955 "1955-59 Birth Cohort" 1960 "1960-64 Birth Cohort" 1965 "1965-69 Birth Cohort" 1970 "1970-74 Birth Cohort" 1975 "1975-79 Birth Cohort" 1980 "1980-84 Birth Cohort" 1985 "1985-89 Birth Cohort" 1990 "1990-94 Birth Cohort" 1995 "1995-99 Birth Cohort";
		la val accoh5 accoh5;
		
		
	end;
/*******************************************************************************************************/ 

/**************************************/
/**** Birth Cohort Cut Off Program ****/
/*******************************************************************************************************/ 

/* Creating (calendar year) birth cohort which centers on the Aug-Sept cutoff */
	cap prog drop btcohprg;
	prog def btcohprg;
		/* Vars used: doby dobm */
	
		/* (calendar year) Birth Cohort */
		gen btcoh = doby - 1900;
	
		/* "pre/post (entry-point) born" */
		gen pstborn = (dobm==9|dobm==10|dobm==11|dobm==12);
			lab var pstborn "Born post entry cutoff (Sept-Dec)";
			label define pstborn 1 "Sep-Dec born" 0 "Jan-Aug born";
		gen preborn = -pstborn + 1;
			lab var preborn "Born pre entry cutoff (Jan-Aug)";
			label define preborn 1 "Jan-Aug born" 0 "Sep-Dec born";

		/* Renumbering the months in a convenient way */
		gen dobrsep = dobm-8;
			lab var dobrsep "MoB relative to September (i.e. July, Aug=0, Sept=1 etc.)";
	end;
/*******************************************************************************************************/ 
	
/****************************************/	
/**** Partner Identification Program ****/
/*******************************************************************************************************/ 

	cap prog drop partid;
	prog def partid;
		/* Vars used: serial, sex, married (gen by mrstat), relhoh, relhfu */
		/* Vars gen: fnum, mnum, husbnum wifenum */
		
		if (lfsyear>=96 & lfsyear<=111) {; cap rename relh96 relhoh; };
		if (lfsyear>=112) {; cap rename relh06 relhoh; cap rename mardy6 mardy;};
		
		/* Generate Individual numbers for men and women */	
		gsort -sex serial;
		cap drop fnum;
		gen fnum = _n if sex==2;
		sort sex serial;
		cap drop mnum;
		gen mnum = _n if sex==1;	
		sort serial sex relhoh;
		lab var fnum "Female identifier within LFS year/wave";
		lab var mnum "Male identifier within LFS year/wave";
	
		/* The aim is to find, for each partnered women, the number of her partner */
		/* For married we will use husb and wife to identify them in the data*/
		cap drop mpartnum;
		gen mpartnum = .;
		cap drop fpartnum;
		gen fpartnum = .;
		lab var mpartnum "(Male) Number of partner";
		lab var fpartnum "(Female) Number of partner";
	
		/* Case 1.A: Married women, labelled as wife of hoh -> hoh is husband */
			sort serial relhoh;	/* Sorting as follows implies that the husband (the hoh) is on the line above her... */
			replace mpartnum = mnum[_n-1] if (sex==2&mardy==1&relhoh==1&relhoh[_n-1]==0&serial==serial[_n-1]);
		
		/* Case 1.B: cohabiting women, labelled as cohabitee of hoh -> hoh is cohabiting partner */
			sort serial relhoh;	/* Sorting as follows implies that the cohabiting partner is on the line above her... */
			replace mpartnum = mnum[_n-1] if (sex==2&mardy==1&relhoh==2&relhoh[_n-1]==0&serial==serial[_n-1]&mpartnum==.);
			
		/* Case 1.C: Married women, labelled as wife of head of family unit */
			sort serial famunit relhfu;
			replace mpartnum = mnum[_n-1] if (sex==2&mardy==1&relhfu==2&relhfu[_n-1]==1&serial==serial[_n-1]&mpartnum==.);
	
		/* Case 2.A: Married men, labelled as hoh -> wife of hoh is wife */
			sort serial relhoh;	/* Sorting as follows implies that the wife (wife of the hoh) is on the line below him... */
			replace fpartnum = fnum[_n+1] if (sex==1&mardy==1&relhoh==0&relhoh[_n+1]==1&serial==serial[_n+1]);
			
		/* Case 2.B: cohabiting men, labelled as hoh -> cohabitee of hoh is fem partner */
			sort serial relhoh;	/* Sorting as follows implies that the wife (wife of the hoh) is on the line below him... */
			replace fpartnum = fnum[_n+1] if (sex==1&relhoh==0&mardy==1&relhoh[_n+1]==2&serial==serial[_n+1]&fpartnum==.);
		
		/* Case 2.C: Married men, labelled as hofu  */
			sort serial famunit relhfu;
			replace fpartnum = fnum[_n+1] if (sex==1&mardy==1&relhfu==1&relhfu[_n+1]==2&serial==serial[_n+1]&fpartnum==.);
			
			gen matched=0;
			replace matched=1 if mpartnum~=.|fpartnum~=.;
			
			sort serial relhoh;
			gen cohab = 0;
			replace cohab=1 if sex==2&mardy==1&relhoh==2&relhoh[_n-1]==0&serial==serial[_n-1];
			replace cohab=1 if sex==1&relhoh==0&mardy==1&relhoh[_n+1]==2&serial==serial[_n+1];
			
			gen married1=0;
			replace married1=1 if matched==1&cohab==0;
			
			
	end;
/*******************************************************************************************************/ 

/**********************************/	
/**** Ethnicity Coding Program ****/ 
/*******************************************************************************************************/  
	
	cap prog drop ethnic;
	prog def ethnic;
	
		/* Ethnicity: Chinese grouped with Asian, new category of mixed (eth01=2) from 2001+   */
		if (lfsyear>=92 & lfsyear<=100) {;
			gen byte white = (ethnic==1);
			gen byte black = (ethnic>=2 & ethnic<=4);
			gen byte asian = (ethnic>=5 & ethnic<=8);
			gen byte otethnic = (ethnic<1 | ethnic>8);		
		};

		else if lfsyear==101 & lfsqrtr==1 & (refweekm<=2 | refweekm==12) {;
			gen byte white = (ethnic==1);
			gen byte black = (ethnic>=2 & ethnic<=4);
			gen byte asian = (ethnic>=5 & ethnic<=8);
			gen byte otethnic = (ethnic<1 | ethnic>8);		
		};

		else if (lfsyear==101 & lfsqrtr==1 & refweekm==3) {;
			gen byte white = (ethnic==1);
			gen byte black = (ethnic==4);
			gen byte asian = (ethnic==3 | ethnic==5);
			gen byte otethnic = (ethnic==2 | ethnic==6);		
		};
		

		else if (lfsyear==101 & lfsqrtr>=2) | (lfsyear>=102 & lfsyear<=110) {;
			gen byte white = (eth01==1);
			gen byte black = (eth01==4);
			gen byte asian = (eth01==3) | (eth01==5);
			gen byte otethnic = (eth01<1 | eth01==6);				
		};
		
		else if (lfsyear==111 & lfsqrtr==1) {;
			gen byte white = (ethuk14==1) ;
			gen byte black = (ethuk14>=11 & ethuk14<=13) ;
			gen byte asian = (ethuk14>=5 & ethuk14<=10);
			gen byte otethnic = (ethuk14<1) | (ethuk14==14) | (ethuk14>=2 & ethuk14<=4);	
		};
		
		else if (lfsyear==111 & lfsqrtr>=2) | (lfsyear>=112 & lfsyear<=116) {;
			gen byte white = (etheweul>=1 & etheweul<=3) ;
			gen byte black = (etheweul>=13 & etheweul<=15);
			gen byte asian = (etheweul>=8 & etheweul<=12);
			gen byte otethnic = (etheweul<1) | (etheweul==16) | (etheweul>=4 & etheweul<=7);
		
		};
		
		cap la var white "ethnic origin white";
		cap la var black "ethnic origin black";
		cap la var asian "ethnic origin asian";
		cap la var otethnic "Other ethnic origin";
		
		
		/* Condensing Ethnicity Classification */ 
		gen ethnic4=.;
		replace ethnic4 = 1 if white==1;
		replace ethnic4 = 2 if black==1;
		replace ethnic4 = 3 if asian==1;
		replace ethnic4 = 4 if otethnic==1;
		la def ethnic4 1 "White" 2 "Black" 3 "Asian" 4 "Other";
		la val ethnic4 ethnic4; 
						
	end;
/*******************************************************************************************************/ 
	
	
/*******************************************************************************************************
********************************************************************************************************

	Part 1: SELECTING YEARS, EXTRACT, CODE AND PREPARE TO COLLATE MASTER DATA

********************************************************************************************************
********************************************************************************************************/
	
	
	global useyrs "97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15";


	/* Loop over each year */
	foreach z in $useyrs{;
	
/*******************************
  1997 - 2015 Quarterly surveys 
********************************/
	
		if (`z'>=97 & `z'<=99) | (`z'==00) | (`z'==03) | (`z'>= 13 & `z'<= 15){;
		/* Loop over each survey quarter */
			forvalues j = 1(1)4 {;
				if `j' == 1 {;
					use "$indata/yr`z'Q`j'/qlfsjm`z'.dta", clear;
					};
				else if `j' == 2 {;
					use "$indata/yr`z'Q`j'/qlfsaj`z'.dta", clear;
					};
				else if `j' == 3 {;
					use "$indata/yr`z'Q`j'/qlfsjs`z'.dta", clear;
					};
				else if `j' == 4 {;
					use "$indata/yr`z'Q`j'/qlfsod`z'.dta", clear;
				};
		
			/* Gen LFS year indicator */
			local yrtmp = `z';
			if `z'==97 {; local yrtmp = 97; };
			else if `z'==98 {; local yrtmp = 98; };
			else if `z'==99 {; local yrtmp = 99; };
			else if `z'==00 {; local yrtmp = 100; };
			else if `z'==01 {; local yrtmp = 101; };
			else if `z'==02 {; local yrtmp = 102; };
			else if `z'==03 {; local yrtmp = 103; };
			else if `z'==13 {; local yrtmp = 113; };
			else if `z'==14 {; local yrtmp = 114; };
			else if `z'==15 {; local yrtmp = 115; };
			gen lfsyear = `yrtmp';
			gen lfsqrtr = `j';
		
			/* Fix up the ref year */
  			cap rename refwky refweeky;
  			replace refweeky = refweeky+1900 if refweeky<100;
		
 			/* Generate household serial number (see Household.pdf, Annex A) 
 				Note that due to the size of the numbers generated the variable have to 
 				be double-precision */
 				
 			keep if thiswv==1;
 			gen double serial = (quota*1000000000) + (week*10000000) + (w1yr*1000000) + (qrtr*100000) + (add*1000) + wavfnd*100 + hhld;

 			bysort refweeky serial persno: gen dupind = _N; 
 			/*tab lfsyear dupind;*/
 			bysort refweeky serial persno: keep if _n==1;  			
 						
 			/* Run programs */
		
			ageprg;
			intmonth;
			mrstat;
			regionprg;
			cntrybrth;
			qualsprg;
			cohortprg;
			btcohprg;
			partid;
			ethnic;
					
			keep lfsyear lfsqrtr refweek* doby dobm sex age agem intm marst* single married married1 marriedsep mardy cohab widowed divorced mnum fnum mpartnum fpartnum region ctryinuk bornuk mcoh accoh accoh5 accoh10 minacc autmborn spriborn dobrfeb persno relh* serial persno famunit thiswv hiqua* hiq*cat *num white black asian ethnic* otethnic btcoh pstborn preborn dobrsep govt* cameyr pw*;
			compress;
			save $tempdata/yr`z'Q`j'.dta, replace;
			
			};
		};
		
/********************************
	2004-2012: Yearly Surveys 
*********************************/
	
		else if (`z'>= 04 & `z'<= 09) | (`z'>=10 & `z'<=12) {;	
			
			/* Choose each year */
			use "$indata/yr`z'/qlfs`z'.dta", clear;
					
			/* Gen LFS year indicator */
			local yrtmp = `z';
				if `z'==04 {; local yrtmp = 104; };
				else if `z'==05 {; local yrtmp = 105; };
				else if `z'==06 {; local yrtmp = 106; };
				else if `z'==07 {; local yrtmp = 107; };
				else if `z'==08 {; local yrtmp = 108; };
				else if `z'==09 {; local yrtmp = 109; };
				else if `z'==10 {; local yrtmp = 110; };
				else if `z'==11 {; local yrtmp = 111; };
				else if `z'==12 {; local yrtmp = 112; };
			gen lfsyear = `yrtmp';
		
			/* Fix up the ref year */
  			cap rename refwky refweeky;
  			replace refweeky = refweeky+1900 if refweeky<100;
			gen lfsqrtr = qrtr;
		
 			/* Generate household serial number (see Household.pdf, Annex A) 
 				Note that due to the size of the numbers generated the variable have to 
 				be double-precision */
 				
 			keep if thiswv==1;
 			gen double serial = (quota*1000000000) + (week*10000000) + (w1yr*1000000) + (qrtr*100000) + (add*1000) + wavfnd*100 + hhld;

 			bysort refweeky serial persno: gen dupind = _N; 
 			/*tab lfsyear dupind;*/
 			bysort refweeky serial persno: keep if _n==1;
 							
 			/* Run programs */

			ageprg;
			intmonth;
			mrstat;
			regionprg;
			cntrybrth;
			qualsprg;
			cohortprg;
			btcohprg;
			partid;
			ethnic;
					
			/* Keep and save up */
			keep lfsyear lfsqrtr refweek* doby dobm sex age agem intm marst* single married married1 marriedsep mardy cohab widowed divorced mnum fnum mpartnum fpartnum region ctryinuk bornuk mcoh accoh accoh5 accoh10 minacc autmborn spriborn dobrfeb persno relh* serial persno famunit thiswv hiqua* hiq*cat *num white black asian ethnic* otethnic btcoh pstborn preborn dobrsep govt* cameyr pw*;
			compress;
			save $tempdata/yr`z'.dta, replace;
			
			};
			
/********************************
		Fix 2001 
*********************************/
			
	else if (`z' == 01) {;
			
		forvalues j = 1(1)2 {;
			if `j' == 1 {;
				use "$indata/yr`z'Q`j'/qlfsjm`z'.dta", clear;
				};
			else if `j' == 2 {;
					use "$indata/yr`z'Q`j'/qlfsaj`z'.dta", clear;
				};
				
				/* Gen LFS year indicator */
			local yrtmp = `z';
			if `z'==01 {; local yrtmp = 101; };
			gen lfsyear = `yrtmp';
			gen lfsqrtr = `j';
		
			/* Fix up the ref year */
  			cap rename refwky refweeky;
  			replace refweeky = refweeky+1900 if refweeky<100;
		
 			/* Generate household serial number (see Household.pdf, Annex A) 
 				Note that due to the size of the numbers generated the variable have to 
 				be double-precision */
 				
 			keep if thiswv==1;
 			gen double serial = (quota*1000000000) + (week*10000000) + (w1yr*1000000) + (qrtr*100000) + (add*1000) + wavfnd*100 + hhld;

 			bysort refweeky serial persno: gen dupind = _N; 
 			/*tab lfsyear dupind;*/
 			bysort refweeky serial persno: keep if _n==1;  			
 			
			if lfsqrtr == 1 {;
				sort refweeky serial persno;  
				/* add in ethnicity info for 2000 cohort */
				merge refweeky serial persno using $tempdata/eth01q1;
				tab _merge;
				keep if _merge==3;
				ren ethnic_or ethnic;	
				drop _merge;
 			};
			
 			/* Run programs */
		
			ageprg;
			intmonth;
			mrstat;
			regionprg;
			cntrybrth;
			qualsprg;
			cohortprg;
			btcohprg;
			partid;
			ethnic;
					
			keep lfsyear lfsqrtr refweek* doby dobm sex age agem intm marst* single married married1 marriedsep mardy cohab widowed divorced mnum fnum mpartnum fpartnum region ctryinuk bornuk mcoh accoh accoh5 accoh10 minacc autmborn spriborn dobrfeb persno relh* serial persno famunit thiswv hiqua* hiq*cat *num white black asian ethnic* otethnic btcoh pstborn preborn dobrsep govt* cameyr;
			compress;
			save $tempdata/yr`z'Q`j'.dta, replace;
			};
			};
			
/********************************
		Fix 2002 
*********************************/

	else if (`z' == 02) {;
			
			forvalues j = 2(1)4 {;
				if `j' == 2 {;
					use "$indata/yr`z'Q`j'/qlfsaj`z'.dta", clear;
					};
					else if `j' == 3 {;
					use "$indata/yr`z'Q`j'/qlfsjs`z'.dta", clear;
					};
					else if `j' == 4 {;
					use "$indata/yr`z'Q`j'/qlfsod`z'.dta", clear;
					};
				
			/* Gen LFS year indicator */
			local yrtmp = `z';
			if `z'==02 {; local yrtmp = 102; };
			gen lfsyear = `yrtmp';
			gen lfsqrtr = `j';
		
			/* Fix up the ref year */
  			cap rename refwky refweeky;
  			replace refweeky = refweeky+1900 if refweeky<100;
		
 			/* Generate household serial number (see Household.pdf, Annex A) 
 				Note that due to the size of the numbers generated the variable have to 
 				be double-precision */
 				
 			keep if thiswv==1;
 			gen double serial = (quota*1000000000) + (week*10000000) + (w1yr*1000000) + (qrtr*100000) + (add*1000) + wavfnd*100 + hhld;

 			bysort refweeky serial persno: gen dupind = _N; 
 			/*tab lfsyear dupind;*/
 			bysort refweeky serial persno: keep if _n==1;  			
 						
 			/* Run programs */
		
			ageprg;
			intmonth;
			mrstat;
			regionprg;
			cntrybrth;
			qualsprg;
			cohortprg;
			btcohprg;
			partid;
			ethnic;
					
			keep lfsyear lfsqrtr refweek* doby dobm sex age agem intm marst* single married married1 marriedsep mardy cohab widowed divorced mnum fnum mpartnum fpartnum region ctryinuk bornuk mcoh accoh accoh5 accoh10 minacc autmborn spriborn dobrfeb persno relh* serial persno famunit thiswv hiqua* hiq*cat *num white black asian ethnic* otethnic btcoh pstborn preborn dobrsep govt* cameyr;
			compress;
			save $tempdata/yr`z'Q`j'.dta, replace;
			
			};
			};
			};
	
	clear;
	
/*******************************************************************************************************
********************************************************************************************************

	Part 2: ADDING PARTNER INFORMATION TO THE DATASET

********************************************************************************************************
********************************************************************************************************/


	/* Aim is to merge partner information on to the dataset, so that for each person
	 that is married/cohabiting we should have also have their partner's info. What 
	 this means is that for every observation in the data, if that person is married
	 or cohabiting we will also have variables with the p_ prefix indicating the 
	 information of that person's partner. */
	
/*****************
	97-15 - Q's
******************/
	
	/***************************************************************************************	
	 First create a dataset consisting only of women (to later merge with husbands/partners)
	 **************************************************************************************/
	
	/* Loop over years */
	foreach z in $useyrs{;

		if (`z'>=97 & `z'<=99) | (`z'==00) | (`z'==03) | (`z'>=13 & `z'<=15) {;
		/* Loop over survey quarters */
			forvalues j = 1(1)4 {;
				if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
				};
			
			/* Keep only women */
			keep if sex==2;
			/* only keep the women who have the number of their husband */
			keep if mpartnum~=.;
			/* replace wifenum with fnum so that we can later merge with husbands */
			cap drop fpartnum;
			gen fpartnum = fnum;
			/* rename every variable with the p_ prefix so that once the females
			are merged with husbands the p_ variables will tell us the info about
			the wife */
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			/* create wifenum again allowing us to merge with the males */
			gen fpartnum = p_fnum;
				
			/* Keep and save up */ 
	
			sort fpartnum;
			compress;
			save $tempdata/yr`z'Q`j'fempart.dta, replace;
			
			clear;
			

	/**********************************************************************************	
	 Next create a dataset consisting only of men (to later merge with wives/partners)
	 **********************************************************************************/
			
			
			/* Now Men - Use the exact same method as used for women */
			/* Loop over survey quarters */
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
				};
			
			/* Keep only men */
			keep if sex==1;
			keep if fpartnum~=.;
			cap drop mpartnum;
			gen mpartnum = mnum;
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			gen mpartnum = p_mnum;
				
			/* Keep and save up */ 
	
			sort mpartnum;
			compress;
			save $tempdata/yr`z'Q`j'malepart.dta, replace;
			
			clear;
					
	/**********************************************************************************	
	 Next Create A Dataset Of Males And Merge Women Onto It - Both Married And Cohab
	 **********************************************************************************/
			
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
				};
		
			keep if sex==1;
			cap drop _merge; 
			sort fpartnum;
			merge fpartnum, using $tempdata/yr`z'Q`j'fempart.dta;
			drop if _merge==2;			
			cap drop _merge; 
			save $tempdata/yr`z'Q`j'matched_males.dta, replace;
			
			clear;

	
	/**********************************************************************************	
	 Next Create A Dataset Of Females And Merge Men Onto It - Both Married And Cohab
	 **********************************************************************************/	
			
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
				};
				
			keep if sex==2;
			sort mpartnum;
			merge mpartnum, using $tempdata/yr`z'Q`j'malepart.dta;
			drop if _merge==2;
			cap drop _merge; 
			save $tempdata/yr`z'Q`j'matched_females.dta, replace;
			
			clear;
			
	/*************************************************************************************	
	 Next Append the Matched Male Data with the Matched Female Data - Put It Back Together
	 *************************************************************************************/
			
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
				else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
				else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
				};
			
			append using $tempdata/yr`z'Q`j'matched_females.dta;
			save $tempdata/yr`z'Q`j'matched.dta, replace;
			
			};
		};
	 
/*******************************************************************************************************/
	 
/*****************
	2004 - 2012
******************/
	

			/* 2004-2012: Yearly surveys */
		else if (`z'>= 04 & `z'<= 09) | (`z'>=10 & `z'<=12) {;
		
	/***************************************************************************************	
	 First create a dataset consisting only of women (to later merge with husbands/partners)
	 **************************************************************************************/
			
			/* Choose each year */
			
			use "$tempdata/yr`z'.dta", clear;
			
			/* Keep only women */
			keep if sex==2;
			keep if mpartnum~=.;
			cap drop fpartnum;
			gen fpartnum = fnum;
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			gen fpartnum = p_fnum;
			
			compress;
			sort fpartnum;
			save $tempdata/yr`z'fempart.dta, replace;
			
			clear;
			
			
	/**********************************************************************************	
	 Next create a dataset consisting only of men (to later merge with wives/partners)
	 **********************************************************************************/

			/* now men */
			
			use "$tempdata/yr`z'.dta", clear;
			
			/* Keep only men */
			keep if sex==1;
			keep if fpartnum~=.;
			cap drop mpartnum;
			gen mpartnum = mnum;
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			gen mpartnum = p_mnum;
			
			compress;
			sort mpartnum;
			save $tempdata/yr`z'malepart.dta, replace;
			
			clear;
			
			
	/**********************************************************************************	
	 Next Create A Dataset Of Males And Merge Women Onto It - Both Married And Cohab
	 **********************************************************************************/
			
			use "$tempdata/yr`z'.dta", clear;
			
			keep if sex==1;
			cap drop _merge; 
			sort fpartnum;
			merge fpartnum, using $tempdata/yr`z'fempart.dta;
			drop if _merge==2;
			cap drop _merge; 
			save $tempdata/yr`z'matched_males.dta, replace;
			
			clear;
			
			
	/**********************************************************************************	
	 Next Create A Dataset Of Females And Merge Men Onto It - Both Married And Cohab
	 **********************************************************************************/	
			
			use "$tempdata/yr`z'.dta", clear;
			
			keep if sex==2;
			sort mpartnum;
			merge mpartnum, using $tempdata/yr`z'malepart.dta;
			drop if _merge==2;
			cap drop _merge; 
			save $tempdata/yr`z'matched_females.dta, replace;
			
			clear;
			
			
	/*************************************************************************************	
	 Next Append the Matched Male Data with the Matched Female Data - Put It Back Together
	 *************************************************************************************/	
			
			use "$tempdata/yr`z'matched_males.dta", clear;
			append using $tempdata/yr`z'matched_females.dta; 
			save $tempdata/yr`z'matched.dta, replace;
			
			};
			
/*******************************************************************************************************/
	
			
/*****************
      2001
******************/	
	
		else if (`z'==01) {;
			
			/* Loop over survey quarters */
			forvalues j = 1/2 {;
				if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
			/* Keep only women */
			keep if sex==2;
			/* only keep the women who have the number of their husband */
			keep if mpartnum~=.;
			/* replace wifenum with fnum so that we can later merge with husbands */
			cap drop fpartnum;
			gen fpartnum = fnum;
			/* rename every variable with the p_ prefix so that once the females
			are merged with husbands the p_ variables will tell us the info about
			the wife */
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			/* create wifenum again allowing us to merge with the males */
			gen fpartnum = p_fnum;
				
			/* Keep and save up */ 
	
			sort fpartnum;
			compress;
			save $tempdata/yr`z'Q`j'fempart.dta, replace;
			
			clear;
			

	/**********************************************************************************	
	 Next create a dataset consisting only of men (to later merge with wives/partners)
	 **********************************************************************************/
			
			
			/* Now Men - Use the exact same method as used for women */
			/* Loop over survey quarters */
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
			
			/* Keep only men */
			keep if sex==1;
			keep if fpartnum~=.;
			cap drop mpartnum;
			gen mpartnum = mnum;
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			gen mpartnum = p_mnum;
				
			/* Keep and save up */ 
	
			sort mpartnum;
			compress;
			save $tempdata/yr`z'Q`j'malepart.dta, replace;
			
			clear;
					
	/**********************************************************************************	
	 Next Create A Dataset Of Males And Merge Women Onto It - Both Married And Cohab
	 **********************************************************************************/
			
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};

			keep if sex==1;
			cap drop _merge; 
			sort fpartnum;
			merge fpartnum, using $tempdata/yr`z'Q`j'fempart.dta;
			drop if _merge==2;			
			cap drop _merge; 
			save $tempdata/yr`z'Q`j'matched_males.dta, replace;
			
			clear;

	
	/**********************************************************************************	
	 Next Create A Dataset Of Females And Merge Men Onto It - Both Married And Cohab
	 **********************************************************************************/	
			
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
			
			keep if sex==2;
			sort mpartnum;
			merge mpartnum, using $tempdata/yr`z'Q`j'malepart.dta;
			drop if _merge==2;
			cap drop _merge; 
			save $tempdata/yr`z'Q`j'matched_females.dta, replace;
			
			clear;
			
	/*************************************************************************************	
	 Next Append the Matched Male Data with the Matched Female Data - Put It Back Together
	 *************************************************************************************/
			
			if `j' == 1 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
				else if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
			
			append using $tempdata/yr`z'Q`j'matched_females.dta;
			save $tempdata/yr`z'Q`j'matched.dta, replace;
			
			};
		};
	 
/*******************************************************************************************************/
	 
/*****************
      2002
******************/			

	else if (`z'==02) {;
			
			/* Loop over survey quarters */
			forvalues j = 2/4 {;
				if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					
			/* Keep only women */
			keep if sex==2;
			/* only keep the women who have the number of their husband */
			keep if mpartnum~=.;
			/* replace wifenum with fnum so that we can later merge with husbands */
			cap drop fpartnum;
			gen fpartnum = fnum;
			/* rename every variable with the p_ prefix so that once the females
			are merged with husbands the p_ variables will tell us the info about
			the wife */
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			/* create wifenum again allowing us to merge with the males */
			gen fpartnum = p_fnum;
				
			/* Keep and save up */ 
	
			sort fpartnum;
			compress;
			save $tempdata/yr`z'Q`j'fempart.dta, replace;
			
			clear;
			

	/**********************************************************************************	
	 Next create a dataset consisting only of men (to later merge with wives/partners)
	 **********************************************************************************/
			
			
			/* Now Men - Use the exact same method as used for women */
			/* Loop over survey quarters */
			if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					
			/* Keep only men */
			keep if sex==1;
			keep if fpartnum~=.;
			cap drop mpartnum;
			gen mpartnum = mnum;
			foreach x of var * {; 
			ren `x' p_`x'; /* rename with a common prefix p_ for "partner info" */
			}; 
			gen mpartnum = p_mnum;
				
			/* Keep and save up */ 
	
			sort mpartnum;
			compress;
			save $tempdata/yr`z'Q`j'malepart.dta, replace;
			
			clear;
					
	/**********************************************************************************	
	 Next Create A Dataset Of Males And Merge Women Onto It - Both Married And Cohab
	 **********************************************************************************/
			
			if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};

			keep if sex==1;
			cap drop _merge; 
			sort fpartnum;
			merge fpartnum, using $tempdata/yr`z'Q`j'fempart.dta;
			drop if _merge==2;			
			cap drop _merge; 
			save $tempdata/yr`z'Q`j'matched_males.dta, replace;
			
			clear;

	
	/**********************************************************************************	
	 Next Create A Dataset Of Females And Merge Men Onto It - Both Married And Cohab
	 **********************************************************************************/	
			
			if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'.dta", clear;
					};
					
			keep if sex==2;
			sort mpartnum;
			merge mpartnum, using $tempdata/yr`z'Q`j'malepart.dta;
			drop if _merge==2;
			cap drop _merge; 
			save $tempdata/yr`z'Q`j'matched_females.dta, replace;
			
			clear;
			
	/*************************************************************************************	
	 Next Append the Matched Male Data with the Matched Female Data - Put It Back Together
	 *************************************************************************************/
			
			if `j' == 2 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
					else if `j' == 3 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
					else if `j' == 4 {;
					use "$tempdata/yr`z'Q`j'matched_males.dta", clear;
					};
			
			append using $tempdata/yr`z'Q`j'matched_females.dta;
			save $tempdata/yr`z'Q`j'matched.dta, replace;
			
			};
			};		
			};
			
/*******************************************************************************************************/
			
			clear;			
		
/*******************************************************************************************************
********************************************************************************************************

	Part 3: COLLATE MASTER DATA 
	
********************************************************************************************************	
********************************************************************************************************/	
			
		
	/** Collate dataset **/
	
	set obs 1;							/* Trick that allows to use append on all... */
	gen var1 = 10;						/* Create one obs with a bogus variable ... */
	foreach z in $useyrs{;
		if (`z'>=96 & `z'<=99) | (`z'==00) | (`z'==03) | (`z'>=13 & `z'<=15) {;
			forvalues j = 1(1)4 {;	
				append using $tempdata/yr`z'Q`j'matched.dta;
				};
				};
		else if (`z'>=04 & `z'<=09) | (`z'>=10 & `z'<=12)  {;	
				append using $tempdata/yr`z'matched.dta;
				};
		else if (`z'==01) {;
			forvalues j = 1/2 {;	
				append using $tempdata/yr`z'Q`j'matched.dta;
				};
				};
		else if (`z'==02) {;
			forvalues j = 2(1)4 {;	
				append using $tempdata/yr`z'Q`j'matched.dta;
				};
				};
		};
		
		drop if var1==10;			/* Drop the bogus obs and var */
		drop var1;
	
/*******************************************************************************************************/	
	
	/* Save up as a complete dataset - all waves appended together with complete partner info. */
	
	unab vlist : _all;
    sort `vlist';
    quietly by `vlist':  gen dup = cond(_N==1,0,_n);
	keep if dup==0;
	drop dup;
	
	/*********************************/
	save $tempdata/lfsind.dta, replace;
	/*********************************/
	
	
/*******************************************************************************************************	
********************************************************************************************************/
/*******************************************************************************************************
********************************************************************************************************

	Part 4: DATA INSPECTION
	
********************************************************************************************************	
********************************************************************************************************/	

	use $tempdata/lfsind.dta, clear; 
	
	/* We will focus on UK born individuals */
	tab bornuk;
	keep if bornuk==1;
	count;
			
	/* And of sufficiently advanced age */
	keep if age>=25;
	count;
	
	/* Not sure how those with missing ethnicity have been coded so will go a bit crude here... */
	tab ethnic4, gen(ethdum);
	count;
	drop if ethnic4==4|ethnic4==.;
	drop ethdum4;
	count;
	sum ethdum*;

	/* Are we then right in time? */
	/* Start in the mid 1960s */
	save $outdata/dattmp.dta, replace;
	collapse ethdum*, by(doby);
	
	use $outdata/dattmp.dta, clear;
	count;
	keep if doby>=1965;
	keep if doby<=1989;

	/* Now we have a slight age imbalance between ethnic groups due to
	the gradual increase in asians */
	bysort ethnic4: sum age;
	
	/* Gender ratio by ethnicity and DoBY */
	save $outdata/dattmp.dta, replace;
	replace sex = sex-1;
	collapse sex, by(doby ethnic4);
	reshape wide sex, i(doby) j(ethnic4);
	
	use $outdata/dattmp.dta, clear;
	/* Regions */
	tab region;
	
	/* Living with Partner */
	tab married1 cohab;
	gen partner = married1+cohab;			
	
	save $outdata/dattmp.dta, replace;
	collapse partner, by(age ethnic4);
	reshape wide partner, i(age) j(ethnic4);
	
	use $outdata/dattmp.dta, clear;
	
	/* Partners */
	count if partner==1;
	sum p_white p_black p_white;
	gen p_eth = p_white + 2*p_black + 3*p_asian;
	tab p_eth;
	drop if p_eth==0;
	count;
	
	/* Ethnic partner profile. Curious fact: looks like black males are more likely to have white partners than are black females  */
	bysort sex: tab ethnic4 p_eth, row;
	
	/* A further insight is that out of 190,000 observed partnerships, we observe 40 black-asian partnerships. */
	tab ethnic4 p_eth;
	gen lateborn = doby>=1973;
	
	/* Ethnic partner profile by early/late birth cohort: Very little evidence of change  */
	bysort lateborn: tab ethnic4 p_eth, row;
	
	tab p_eth, gen(p_ethdum);
	
	forvalues i = 1/3 {;
		forvalues j = 1/3 {;
			ci p_ethdum`j' if ethdum`i'==1&lateborn==0;
			ci p_ethdum`j' if ethdum`i'==1&lateborn==1;
			};
		};
		
	/* Construct simple ethnicity share measures */
	forvalues k = 1/3 {;	
		egen share`k' = mean(ethdum`k'), by(region);
		};
		
	/* And explore whether prevalance of minorities affect marriage partner: clearly supply matters, but also 
		some interesting gender differences */
	bysort sex: reg p_ethdum1 ethdum2 ethdum3 share2 share3;
	bysort sex: reg p_ethdum2 ethdum2 ethdum3 share2 share3;
	bysort sex: reg p_ethdum3 ethdum2 ethdum3 share2 share3;
	
	/* Quals: Go down to binary */
	tab hiq3cat;
	gen qual = .;
		replace qual = 0 if hiq3cat==1|hiq3cat==2;
		replace qual = 1 if hiq3cat==3;
		
	gen p_qual = .;
		replace p_qual = 0 if p_hiq3cat==1|p_hiq3cat==2;
		replace p_qual = 1 if p_hiq3cat==3;	

	sum qual p_qual;
	tab qual, gen(qdum);
	tab p_qual, gen(p_qdum);

	
	/* Generate qual-ethnic type */
	gen type=ethnic4 + 3*qual;
	gen p_type=p_ethnic4 + 3*p_qual;
	sum type p_type if partner==1;
	
	tab type, gen(typedum);
	tab p_type, gen(p_typedum);	
	
	/* Aggregate Singles Rates by Gender and Ethnicity */
	matrix mat_agg_M_s = J(6,1,.);
	matrix mat_agg_F_s = J(6,1,.);
				
	forvalues j = 1/6 {;
		sum partner if typedum`j'==1&sex==1;
		matrix mat_agg_M_s[`j',1] = r(mean);
		sum partner if typedum`j'==1&sex==2;	
		matrix mat_agg_F_s[`j',1] = r(mean);
		};	

	mat dir;
	mat list mat_agg_M_s;
	mat list mat_agg_F_s;	
	
	save $outdata/dattmp1singles.dta, replace;
	
	/* Keep partnered sample */
	count;
	keep if partner==1;
	count;
	
	matrix mat_agg_M = J(6,6,.);
	matrix mat_agg_F = J(6,6,.);
	
	forvalues j = 1/6 {;
		forvalues k = 1/6 {;
			sum p_typedum`k' if typedum`j'==1&sex==1;
			matrix mat_agg_M[`j',`k'] = r(mean);
			sum p_typedum`j' if typedum`k'==1&sex==2;
			matrix mat_agg_F[`j',`k'] = r(mean);
			};
		};

	save $outdata/dattmp1.dta, replace;
	
	mat dir;
	mat list mat_agg_M;
	mat list mat_agg_F;	
		
/*******************************************************************************************************
********************************************************************************************************

	Part 5: SAMPLE SELECTION
	
********************************************************************************************************	
********************************************************************************************************/	

/* This section is used to create a gender balance for both marriages and cohabitors
		in order to satisfy the equilibrium conditions. */
	
	use $outdata/dattmp1.dta, clear;
	
	/* Get rid of missing obs and partners born outside the uk */
	drop if p_eth==.|qual==.|p_qual==.;
	ren ethnic4 eth;
	/*drop if p_bornuk==0;*/
	replace qual = qual+1;
	replace p_qual=p_qual+1;
	
	save $outdata/dattmp2.dta, replace;
	
	/* Trying to get a gender balance */
	use $outdata/dattmp2.dta, clear;
	
	/* drop duplicates */
	unab vlist : _all;
    sort `vlist';
    quietly by `vlist':  gen dup = cond(_N==1,0,_n);
	keep if dup==0;
	drop dup;
	
	/* continue trying to get a gender balance */
	/* weird stuff in 2015 (duplicates with diff partners) */
	sort lfsyear serial sex;
	quietly by lfsyear serial sex :  gen dup = cond(_N==1,0,_n);
	drop if dup==2 & lfsyear==115;
	drop dup;
	
	/* delete single serial numbers (unmatched households) */
	sort lfsyear serial;
	quietly by lfsyear serial:  gen dup = cond(_N==1,0,_n);
	drop if dup==0 & p_bornuk==1;
	drop dup;

	save $outdata/sample_selection.dta, replace;

	/* now deal with singles */
	use $outdata/dattmp1singles.dta, clear;
	
	drop if partner==1; 
	ren ethnic4 eth;
	replace qual = qual+1;
	drop if hiq3cat==.;
	drop if qual==.;
	drop if eth==.;
	
	/* drop duplicates */
	unab vlist : _all;
    sort `vlist';
    quietly by `vlist':  gen dup = cond(_N==1,0,_n);
	keep if dup==0;
	drop dup;
	
	save $outdata/dattmp1singles1.dta, replace; 
	clear; 
	use $outdata/dattmp1singles1.dta, clear;
	
	/* append on the married individuals */
	append using $outdata/sample_selection.dta;
	
	/* check for duplicates */
	cap drop dup;
	unab vlist : _all;
    sort `vlist';
    quietly by `vlist':  gen dup = cond(_N==1,0,_n);
	keep if dup==0;
	drop dup;
	
	/* single identifier*/
	gen single1=0;
	replace single1=1 if married1==0&cohab==0;
	save $outdata/completesample.dta, replace;
	
	/* keep only 'married' and drop duplicates */
	keep if married1==1;
	sort lfsyear serial;
	quietly by lfsyear serial:  gen dup = cond(_N==1,0,_n);
	drop if dup==0 & p_bornuk==1;
	drop dup;
	save $tempdata/extra6.dta, replace;
	
	/* append back */
	use $outdata/completesample.dta, clear;
	drop if married1==1;
	append using $tempdata/extra6.dta;
	save $outdata/completesample.dta, replace;
	
	/* repeat for cohabitors*/
	keep if cohab==1;
	sort lfsyear serial;
	quietly by lfsyear serial:  gen dup = cond(_N==1,0,_n);
	drop if dup==0 & p_bornuk==1;
	drop dup;
	save $tempdata/extra7.dta, replace;
	
	/* append back*/
	use $outdata/completesample.dta, clear;
	drop if cohab==1;
	append using $tempdata/extra7.dta;
	
	save $outdata/completesample.dta, replace;

/*******************************************************************************************************
********************************************************************************************************

	Part 6: MARRIAGE MATRICES
	
********************************************************************************************************	
********************************************************************************************************/

	use $outdata/completesample.dta, clear;
	/* need to merge regions 1 and 2 together to be consistent with NUTS regions*/
	drop if (region == 17)|(region==.);
	replace region = 1 if region == 2;
	recode region (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (15=14) (16=15) ;
	la def region 1 "Rest of North" 2 "South Yorkshire" 3 "West Yorkshire" 4 "Rest of Yorkshire" 5 "East Midlands" 6 "East Anglia" 7 "London" 8 "Rest of South East" 9 "South West" 10 "West Midlands" 11 "Greater Manchester" 12 "Merseyside" 13 "Rest of North West" 14 "Wales" 15 "Scotland", replace;
	la val region region;
	
	replace govtof = 2 if govtof == 3;
	recode govtof (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) ;
	la def govtof 1 "North East" 2 "North West" 3 "Yorkshire and Humberside" 4 "East Midlands" 5 "West Midlands" 6 "Eastern" 7 "London" 8 "South East" 9 "South West" 10 "Wales" 11 "Scotland", replace;
	la val govtof govtof;
	
	/* create education identifier */
	gen edu = .;
	replace edu = 1 if hiq3cat<=3;
	replace edu = 2 if hiq3cat==3;
	la def edu 1 "GCSE or Below" 2 "A-Level or Above";
	la val edu edu;
	
	save $outdata/completesample_regs.dta, replace;

	/* load in the full marriage/single sample */
	use $outdata/completesample_regs.dta, replace;
		
	/* create partner education identifier */
	gen p_edu = .;
	replace p_edu = 1 if p_hiq3cat<=3;
	replace p_edu = 2 if p_hiq3cat==3;
	la def p_edu 1 "GCSE or Below" 2 "A-Level or Above";
	la val p_edu edu;
	/* drop those whom are married but do not have partner info */
	drop if single1==0 & p_bornuk==.;
	
	/* age threshold for singlehood - chosen to be less than 28 */
	drop if single1 == 1 & age<28;
	
	/*drop if single1 == 1 & age<20;*/ /* Robustness check */
	
	/* married to UK-born partner identifier  */
	gen marrieduk = 0;
	replace marrieduk = 1 if single1==0 & p_bornuk==1; 
	/* married to non-UK-born partner identifier */ 
	gen marriednon = 0;
	replace marriednon = 1 if single1==0 & p_bornuk==0;

/********************************************************************************************************/
	/* summary statistics  */
/********************************************************************************************************/
	/* single1 == 0 identifies married */
	
	/* first age and cohort by ethnicity, education, and gender */
	forvalues x = 1/3 {;
	forvalues y = 1/2 {;
	forvalues z = 1/2 {;
		su age accoh if eth == `x' & edu == `y' & sex == `z';
	};
	};
	};
	/* then marital status by ethnicity, education, and gender */
	forvalues x = 1/3 {;
	forvalues y = 1/2 {;
	forvalues z = 1/2 {;
		su marrieduk marriednon single1 if eth == `x' & edu == `y' & sex == `z';
	};
	};
	};
	/* then partner type by ethnicity, education, and gender */
	forvalues x = 1/3 {;
	forvalues y = 1/2 {;
	forvalues z = 1/2 {;
		tab p_type if eth == `x' & edu == `y' & sex == `z';
	};
	};
	};

/********************************************************************************************************/
	/* Marriage Matrices */
/********************************************************************************************************/
	
	/* loop over regions */
	forvalues r = 1/11{;
	count if sex==1 & govtof==`r';
	scalar males`r'r = r(N);
	count if sex==2 & govtof==`r';
	scalar females`r'r = r(N);
	
	/* type distribution */
	cap matrix drop Qual_pre`r'r;
	matrix Qual_pre`r'r = J(2,6,.);
	
	forvalues t = 1/3 {; /* loop over eth categories */
	forvalues s = 1/2 {; /* loop over genders */
	forvalues e = 1/2 {; /* lop over edu */
	
	count if sex==`s' & eth==`t' & edu == `e' & govtof==`r';
	scalar t`t'`e's`s'qual`r'r = r(N);
	
	if `s' == 1 {;
		scalar t`t'`e's`s'qualp`r'r = t`t'`e's`s'qual`r'r/males`r'r;
	};
	if `s' == 2 {;
		scalar t`t'`e's`s'qualp`r'r = t`t'`e's`s'qual`r'r/females`r'r;
	};
	
	if `t'==1 {;
		matrix Qual_pre`r'r[`s',`t'*`e'] = t`t'`e's`s'qualp`r'r;
	};
	if `t'==2 {;
		matrix Qual_pre`r'r[`s',`t'+`e'] = t`t'`e's`s'qualp`r'r;
	};
	if `t'==3 {;
		matrix Qual_pre`r'r[`s',`t'+`e'+1] = t`t'`e's`s'qualp`r'r;
	};
	
	};
	};
	};
	};
	
	/* Save type distributions by region  */
	forvalues r = 1/11 {;
	svmat Qual_pre`r'r;
	outfile Qual_pre`r'r* using "$matlab/Qual_prereg`r'.txt" if _n<=2, replace;
	};
	
	scalar drop _all;
	
	/**************************************************************************/

	/* population counts - used in likelihood estimation */
	/* loop over regions */
	forvalues r = 1/11{;
	cap matrix drop cnt_pre`r'r;
	matrix cnt_pre`r'r = J(2,6,.);
	forvalues t = 1/3 {; /* loop over eth categories */
	forvalues s = 1/2 {; /* loop over genders */
	forvalues e = 1/2 {; 
	
	count if sex==`s' & eth==`t' & edu == `e' & govtof==`r';
	scalar t`t'`e'cnt`s't`r'r = r(N);
	
	if `t'==1 {;
		matrix cnt_pre`r'r[`s',`t'*`e'] = t`t'`e'cnt`s't`r'r;
	};
	if `t'==2 {;
		matrix cnt_pre`r'r[`s',`t'+`e'] = t`t'`e'cnt`s't`r'r;
	};
	if `t'==3 {;
		matrix cnt_pre`r'r[`s',`t'+`e'+1] = t`t'`e'cnt`s't`r'r;
	};
	
	};
	};
	};
	};	
	/* save population counts */
	forvalues r = 1/11 {;
	svmat cnt_pre`r'r;
	outfile cnt_pre`r'r* using "$matlab/cnt_prereg`r'.txt" if _n<=2, replace;
	};
	
	scalar drop _all;
	
	/**************************************************************************/
	/**************************************************************************/
	/**************************************************************************/
	
	/* Partner type distributions - Males first  */
	
	/* loop over regions */
	forvalues r = 1/11{;
	
	/* Create a 3x3 Matrix (all elements missing) to later be filled
			with match probabilities. Rows represent male types and columns
			represent female types (where a type is defined as an edu level) */
			
		cap matrix drop MMales_pre`r'r;
		matrix MMales_pre`r'r = J(6,6,.);
		
		/* The following procedure is split into 4 parts - a part for 
			each ethnic group of females. The algorithm loops over males education 
			 and ethnic group. The first part fills in the first 3 columns, and so 
			 on for the subsequent parts. */
			
		forvalues p = 1/2 {;	/* loop over partner info */
		forvalues t = 1/3 {;  /* loop over eth categories*/
		forvalues e = 1/2 {; /* loop over edu levels */
			
			count if sex==1 & eth==`t' & edu == `e' & p_eth==1 & p_edu == `p' & govtof==`r' & single1==0 & p_bornuk==1;
			scalar t`t'`e'mt`p'f`r'r1 = r(N);
			
				if `t' == 1 {;
					matrix MMales_pre`r'r[`t'*`e',`p'] = t`t'`e'mt`p'f`r'r1;
				};
				if `t' == 2 {;
					matrix MMales_pre`r'r[`t'+`e',`p'] = t`t'`e'mt`p'f`r'r1;
				};
				if `t' == 3 {;
					matrix MMales_pre`r'r[`t'+`e'+1,`p'] = t`t'`e'mt`p'f`r'r1;
				};
			
			};
			};
			};
			
		forvalues p = 1/2 {;	/* loop over partner info */
		forvalues t = 1/3 {;  /* loop over eth categories*/
		forvalues e = 1/2 {; /* loop over edu levels */
			
			count if sex==1 & eth==`t' & edu == `e' & p_eth==2 & p_edu == `p' & govtof==`r' & single1==0 & p_bornuk==1;
			scalar t`t'`e'mt`p'f`r'r2 = r(N);
			
				if `t' == 1 {;
					matrix MMales_pre`r'r[`t'*`e',`p'+2] = t`t'`e'mt`p'f`r'r2;
				};
				if `t' == 2 {;
					matrix MMales_pre`r'r[`t'+`e',`p'+2] = t`t'`e'mt`p'f`r'r2;
				};
				if `t' == 3 {;
					matrix MMales_pre`r'r[`t'+`e'+1,`p'+2] = t`t'`e'mt`p'f`r'r2;
				};
			
			};
			};
			};
			
		forvalues p = 1/2 {;	/* loop over partner info */
		forvalues t = 1/3 {;  /* loop over eth categories*/
		forvalues e = 1/2 {; /* loop over edu levels */
			
			count if sex==1 & eth==`t' & edu == `e' & p_eth==3 & p_edu == `p' & govtof==`r' & single1==0 & p_bornuk==1;
			scalar t`t'`e'mt`p'f`r'r3 = r(N);
			
				if `t' == 1 {;
					matrix MMales_pre`r'r[`t'*`e',`p'+4] = t`t'`e'mt`p'f`r'r3;
				};
				if `t' == 2 {;
					matrix MMales_pre`r'r[`t'+`e',`p'+4] = t`t'`e'mt`p'f`r'r3;
				};
				if `t' == 3 {;
					matrix MMales_pre`r'r[`t'+`e'+1,`p'+4] = t`t'`e'mt`p'f`r'r3;
				};
			
			};
			};
			};
			
			svmat MMales_pre`r'r;
			scalar drop _all;
			
		/* Now create a matrix where each row is a male type, but each cell on a given row 
		contains the absolute number of males of that type. This will be useful later
		on as I can use it to divide by the MarriedMales matrix to obtain the marriage
		rates */
		
		cap matrix drop MMales`r'r;
		matrix MMales`r'r = J(6,6,.);
		
			forvalues t = 1/3 {; /* loop over education levels */
			forvalues e = 1/2 {; /* loop over edu */
			forvalues j = 1/6 {;
				count if sex==1 & eth==`t' & edu==`e' & govtof==`r' & single1==0 & p_bornuk==1;
				scalar t`t'`e'm`r'r = r(N);
				
				if `t' == 1 {;
					matrix MMales`r'r[`t'*`e',`j'] = t`t'`e'm`r'r;
				};
				if `t' == 2 {;
					matrix MMales`r'r[`t'+`e',`j'] = t`t'`e'm`r'r;
				};
				if `t' == 3 {;
					matrix MMales`r'r[`t'+`e'+1,`j'] = t`t'`e'm`r'r;
				};
				
			};
			};
			};
			
		/* Divide the MarriedMales Matrix by the Males matrix to obtain marriage rates */
		
		cap matrix drop M_pre`r'r;
		matrix M_pre`r'r = J(6,6,0);
		forvalues i = 1/6 {;
		forvalues j = 1/6 {;
				if MMales_pre`r'r[`i',`j']!= 0 {;
				matrix M_pre`r'r[`i',`j']= MMales_pre`r'r[`i',`j']/MMales`r'r[`i',`j'];
				};
			};
			};
		svmat M_pre`r'r;
		outfile M_pre`r'r* using "$matlab/M_pre`r'.txt" if _n<=6, replace;		
	};
	
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
		
	
	/* Partner type distributions - now Females  */
	/* loop over regions */
	forvalues r = 1/11{;
	
	/* Create a 3x3 Matrix (all elements missing) to later be filled
			with match probabilities. Rows represent male types and columns
			represent female types (where a type is defined as an edu level) */
			
		cap matrix drop MFemales_pre`r'r;
		matrix MFemales_pre`r'r = J(6,6,.);
		
		/* The following procedure is split into 4 parts - basically a part for 
			each ethnic group of males. The algorithm loops over females education 
			 and ethnic group. The first part fills in the first 3 columns, and so 
			 on for the subsequent parts. */
			
		forvalues p = 1/2 {;	/* loop over partner info */
		forvalues t = 1/3 {;  /* loop over eth categories*/
		forvalues e = 1/2 {; /* loop over edu levels */
			
			count if sex==2 & eth==`t' & edu == `e' & p_eth==1 & p_edu == `p' & govtof==`r' & single1==0 & p_bornuk==1;
			scalar t`t'`e'mt`p'f`r'r1 = r(N);
			
				if `t' == 1 {;
					matrix MFemales_pre`r'r[`p',`t'*`e'] = t`t'`e'mt`p'f`r'r1;
				};
				if `t' == 2 {;
					matrix MFemales_pre`r'r[`p',`t'+`e'] = t`t'`e'mt`p'f`r'r1;
				};
				if `t' == 3 {;
					matrix MFemales_pre`r'r[`p',`t'+`e'+1] = t`t'`e'mt`p'f`r'r1;
				};
			
			};
			};
			};
			
		forvalues p = 1/2 {;	/* loop over partner info */
		forvalues t = 1/3 {;  /* loop over eth categories*/
		forvalues e = 1/2 {; /* loop over edu levels */
			
			count if sex==2 & eth==`t' & edu == `e' & p_eth==2 & p_edu == `p' & govtof==`r' & single1==0 & p_bornuk==1;
			scalar t`t'`e'mt`p'f`r'r2 = r(N);
			
				if `t' == 1 {;
					matrix MFemales_pre`r'r[`p'+2,`t'*`e'] = t`t'`e'mt`p'f`r'r2;
				};
				if `t' == 2 {;
					matrix MFemales_pre`r'r[`p'+2,`t'+`e'] = t`t'`e'mt`p'f`r'r2;
				};
				if `t' == 3 {;
					matrix MFemales_pre`r'r[`p'+2,`t'+`e'+1] = t`t'`e'mt`p'f`r'r2;
				};
			
			};
			};
			};
			
		forvalues p = 1/2 {;	/* loop over partner info */
		forvalues t = 1/3 {;  /* loop over eth categories*/
		forvalues e = 1/2 {; /* loop over edu levels */
			
			count if sex==2 & eth==`t' & edu == `e' & p_eth==3 & p_edu == `p' & govtof==`r' & single1==0 & p_bornuk==1;
			scalar t`t'`e'mt`p'f`r'r3 = r(N);
			
				if `t' == 1 {;
					matrix MFemales_pre`r'r[`p'+4,`t'*`e'] = t`t'`e'mt`p'f`r'r3;
				};
				if `t' == 2 {;
					matrix MFemales_pre`r'r[`p'+4,`t'+`e'] = t`t'`e'mt`p'f`r'r3;
				};
				if `t' == 3 {;
					matrix MFemales_pre`r'r[`p'+4,`t'+`e'+1] = t`t'`e'mt`p'f`r'r3;
				};
			
			};
			};
			};
			
			svmat MFemales_pre`r'r;
			scalar drop _all;
	
		/* Now create a matrix where each row is a female type, but each cell on a given row 
		contains the absolute number of females of that type. This will be useful later
		on as I can use it to divide by the MarriedFemales matrix to obtain the marriage
		rates */
		
		cap matrix drop MFemales`r'r;
		matrix MFemales`r'r = J(6,6,.);
		
			forvalues t = 1/3 {; /* loop over education levels */
			forvalues e = 1/2 {; /* loop over edu */
			forvalues j = 1/6 {;
				count if sex==2 & eth==`t' & edu==`e' & govtof==`r' & single1==0 & p_bornuk==1;
				scalar t`t'`e'm`r'r = r(N);
				
				if `t' == 1 {;
					matrix MFemales`r'r[`j',`t'*`e'] = t`t'`e'm`r'r;
				};
				if `t' == 2 {;
					matrix MFemales`r'r[`j',`t'+`e'] = t`t'`e'm`r'r;
				};
				if `t' == 3 {;
					matrix MFemales`r'r[`j',`t'+`e'+1] = t`t'`e'm`r'r;
				};
				
			};
			};
			};
	
		/* Divide ther MarriedFemales Matrix by the Females matrix to obtain marriage rates */
		
		cap matrix drop F_pre`r'r;
		matrix F_pre`r'r = J(6,6,0);
		forvalues i = 1/6 {;
		forvalues j = 1/6 {;
				if MFemales_pre`r'r[`i',`j']!= 0 {;
				matrix F_pre`r'r[`i',`j']= MFemales_pre`r'r[`i',`j']/MFemales`r'r[`i',`j'];
				};
			};
			};
		svmat F_pre`r'r;
		outfile F_pre`r'r* using "$matlab/F_pre`r'.txt" if _n<=6, replace;		
	};
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
	

	/* Singles rates - Men */
	
	forvalues r = 1/11 {;
	cap matrix drop SMales_pre`r'r;
	matrix SMales_pre`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over eth levels */
			forvalues e = 1/2 {; /* loop over edu */
			
				count if sex==1 & eth==`t' & edu == `e' & govtof==`r' & single1==1;
				scalar t`t'`e'sm`r'r = r(N);
				
				if `t' == 1 {;
				matrix SMales_pre`r'r[`t'*`e',1] = t`t'`e'sm`r'r;	
				};
				if `t' == 2 {;
				matrix SMales_pre`r'r[`t'+`e',1] = t`t'`e'sm`r'r;	
				};
				if `t' == 3 {;
				matrix SMales_pre`r'r[`t'+`e'+1,1] = t`t'`e'sm`r'r;	
				};
			};
			};
			
			svmat SMales_pre`r'r;
			scalar drop _all;
	
		cap matrix drop SMales`r'r;
		matrix SMales`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over education levels */
			forvalues e = 1/2 {; /* loop over edu */
				count if sex==1 & eth==`t' & edu==`e' & govtof==`r';
				scalar t`t'`e'm`r'r = r(N);
				
				if `t' == 1 {;
				matrix SMales`r'r[`t'*`e',1] = t`t'`e'm`r'r;
				};
				if `t' == 2 {;
				matrix SMales`r'r[`t'+`e',1] = t`t'`e'm`r'r;
				};
				if `t' == 3 {;
				matrix SMales`r'r[`t'+`e'+1,1] = t`t'`e'm`r'r;
				};
			};
			};

		/* Divide ther SingleMales Matrix by the Males matrix to obtain singles rates */
		cap matrix drop s_m`r'r;
		matrix s_m`r'r = J(6,1,.);
		forvalues i = 1/6 {;
			matrix s_m`r'r[`i',1]= SMales_pre`r'r[`i',1]/SMales`r'r[`i',1];
			};
		svmat s_m`r'r;
		outfile s_m`r'r* using "$matlab/s_m`r'.txt" if _n<=6, replace;
		};

/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
	


	/* Singles rates - Women */
	
	forvalues r = 1/11 {;
	cap matrix drop SFemales_pre`r'r;
		matrix SFemales_pre`r'r = J(6,1,.);
	
			forvalues t = 1/3 {; /* loop over edu levels */
			forvalues e = 1/2 {; /* edu */
				count if sex==2 & eth==`t' & edu==`e' & govtof==`r' & single1==1;
				
				scalar t`t'`e'sf`r'r = r(N);
				if `t' == 1 {;
				matrix SFemales_pre`r'r[`t'*`e',1] = t`t'`e'sf`r'r;	
				};
				if `t' == 2 {;
				matrix SFemales_pre`r'r[`t'+`e',1] = t`t'`e'sf`r'r;	
				};
				if `t' == 3 {;
				matrix SFemales_pre`r'r[`t'+`e'+1,1] = t`t'`e'sf`r'r;	
				};
			};
			};
			svmat SFemales_pre`r'r;
			scalar drop _all;
	
		cap matrix drop SFemales`r'r;
		matrix SFemales`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over education levels */
			forvalues e = 1/2 {; /* edu */
				count if sex==2 & eth==`t' & edu==`e' & govtof==`r';
				scalar t`t'`e'f`r'r = r(N);
				
				if `t' == 1 {;
				matrix SFemales`r'r[`t'*`e',1] = t`t'`e'f`r'r;
				};
				if `t' == 2 {;
				matrix SFemales`r'r[`t'+`e',1] = t`t'`e'f`r'r;
				};
				if `t' == 3 {;
				matrix SFemales`r'r[`t'+`e'+1,1] = t`t'`e'f`r'r;
				};
			};
			};

		/* Divide ther SingleFemales Matrix by the Females matrix to obtain singles rates */
		
		cap matrix drop s_f`r'r;
		matrix s_f`r'r = J(6,1,.);
		forvalues i = 1/6 {;
			matrix s_f`r'r[`i',1]= SFemales_pre`r'r[`i',1]/SFemales`r'r[`i',1];
			};
		svmat s_f`r'r;
		outfile s_f`r'r* using "$matlab/s_f`r'.txt" if _n<=6, replace;
		};
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/

	/* Marry Partner From Outside UK - Men */
	scalar drop _all;
	
	forvalues r = 1/11 {;
	cap matrix drop OMales_pre`r'r;
		matrix OMales_pre`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over eth levels */
			forvalues e = 1/2 {; /* loop over edu */
			
				count if sex==1 & eth==`t' & edu == `e' & govtof==`r' & single1==0 & p_bornuk==0;
				scalar t`t'`e'sm`r'r = r(N);
				
				if `t' == 1 {;
				matrix OMales_pre`r'r[`t'*`e',1] = t`t'`e'sm`r'r;	
				};
				if `t' == 2 {;
				matrix OMales_pre`r'r[`t'+`e',1] = t`t'`e'sm`r'r;	
				};
				if `t' == 3 {;
				matrix OMales_pre`r'r[`t'+`e'+1,1] = t`t'`e'sm`r'r;	
				};
			};
			};		
			svmat OMales_pre`r'r;
			scalar drop _all;
	
		cap matrix drop OMales`r'r;
		matrix OMales`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over education levels */
			forvalues e = 1/2 {; /* loop over edu */
				count if sex==1 & eth==`t' & edu==`e' & govtof==`r' ;
				scalar t`t'`e'm`r'r = r(N);
				
				if `t' == 1 {;
				matrix OMales`r'r[`t'*`e',1] = t`t'`e'm`r'r;
				};
				if `t' == 2 {;
				matrix OMales`r'r[`t'+`e',1] = t`t'`e'm`r'r;
				};
				if `t' == 3 {;
				matrix OMales`r'r[`t'+`e'+1,1] = t`t'`e'm`r'r;
				};
			};
			};

		/* Divide the OMales Matrix by the Males matrix to obtain outside marriage rates */
		
		cap matrix drop o_m`r'r;
		matrix o_m`r'r = J(6,1,.);
		forvalues i = 1/6 {;
			matrix o_m`r'r[`i',1]= OMales_pre`r'r[`i',1]/OMales`r'r[`i',1];
			};
		svmat o_m`r'r;
		outfile o_m`r'r* using "$matlab/o_m`r'.txt" if _n<=6, replace;
	};

/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/
/*******************************************************************************************************/

	/* Partner From Outside UK - Women */
	scalar drop _all;
	
	forvalues r = 1/11 {;
	cap matrix drop OFemales_pre`r'r;
		matrix OFemales_pre`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over edu levels */
			forvalues e = 1/2 {; /* edu */
				count if sex==2 & eth==`t' & edu==`e' & govtof==`r' & single1==0 & p_bornuk==0;
				
				scalar t`t'`e'sf`r'r = r(N);
				if `t' == 1 {;
				matrix OFemales_pre`r'r[`t'*`e',1] = t`t'`e'sf`r'r;	
				};
				if `t' == 2 {;
				matrix OFemales_pre`r'r[`t'+`e',1] = t`t'`e'sf`r'r;	
				};
				if `t' == 3 {;
				matrix OFemales_pre`r'r[`t'+`e'+1,1] = t`t'`e'sf`r'r;	
				};
			};
			};
			svmat OFemales_pre`r'r;
			scalar drop _all;
		
		cap matrix drop OFemales`r'r;
		matrix OFemales`r'r = J(6,1,.);
		
			forvalues t = 1/3 {; /* loop over education levels */
			forvalues e = 1/2 {; /* edu */
				count if sex==2 & eth==`t' & edu==`e' & govtof==`r';
				scalar t`t'`e'f`r'r = r(N);
				
				if `t' == 1 {;
				matrix OFemales`r'r[`t'*`e',1] = t`t'`e'f`r'r;
				};
				if `t' == 2 {;
				matrix OFemales`r'r[`t'+`e',1] = t`t'`e'f`r'r;
				};
				if `t' == 3 {;
				matrix OFemales`r'r[`t'+`e'+1,1] = t`t'`e'f`r'r;
				};
			};
			};
	
		/* Divide ther OFemales Matrix by the Females matrix to obtain outside marriage rates */
		
		cap matrix drop o_f`r'r;
		matrix o_f`r'r = J(6,1,.);
		forvalues i = 1/6 {;
			matrix o_f`r'r[`i',1]= OFemales_pre`r'r[`i',1]/OFemales`r'r[`i',1];
			};
		svmat o_f`r'r;
		outfile o_f`r'r* using "$matlab/o_f`r'.txt" if _n<=6, replace;
		};
	
/*******************************************************************************************************/
/*******************************************************************************************************/
	/* THE END */
/*******************************************************************************************************/
/*******************************************************************************************************/




