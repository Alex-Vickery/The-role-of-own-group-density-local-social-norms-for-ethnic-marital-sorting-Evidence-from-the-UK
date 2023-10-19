# The-role-of-own-group-density-local-social-norms-for-ethnic-marital-sorting-Evidence-from-the-UK

This repository contains the code and data accompanying the paper "The role of own-group density &amp; local social norms for ethnic marital sorting: Evidence from the UK", written by [Dan Anderberg](https://www.dananderberg.com/) &amp; Alexander Vickery, published in the [European Economic Review](https://doi.org/10.1016/j.euroecorev.2021.103774) in September 2021.

## Links to the Paper
The paper and supplementary material are available at [https://doi.org/10.1016/j.euroecorev.2021.103774](https://doi.org/10.1016/j.euroecorev.2021.103774).

## Software
The results were obtained on a Mac running OS X with Stata 14 and Matlab R2019b.

## List of Included files 
Stata `.do` files
1. `masterfile.do`
2. `reduced_forms.do`
3. `predictedfuturesorting.do`
4. `Homogamy_index.do`
5. `Spec_tests.do`

Stata `.dta` files 
1. `eth01q1.dta`
2. `qual15key.dta`
3. `qualkey04.dta`
4. `qualkey05plus.dta`
5. `qualkey08plus.dta`
6. `qualkey11plus.dta`
7. `qualkey15plus.dta`
8. `qualkey93_96.dta`
9. `qualkey96plus.dta`

Matlab `.m` files
1. `choices.m`
2. `complementarities.m`
3. `FIG4.m`
4. `FIG6.m`
5. `FIG7.m`
6. `FIG8.m`
7. `internalpredict.m`
8. `loglik_spec1.m`
9. `loglik_spec2.m`
10. `loglik_spec3.m`
11. `setup.m`
12. `spec1.m`
13. `spec2.m`
14. `spec3.m`
15. `TAB4.m`

## Section 1 - Data Cleaning (stata)
All LFS data used in this project is freely available from the UK data service repository at the following link: [link](https://beta.ukdataservice.ac.uk/datacatalogue/series/series?id=2000026#!/access-data)

### Storing the data 
We use data for survey years 1996-2015. All survey waves need to be downloaded and saved in the users `indata` directory, this directory is where the raw data files will be stored. 
Within the `indata` directory we recommend creating additional sub-directories for each survey wave according to the following syntax: `yrzQj` 

where `z` corresponds to the survey year i.e. survey year 1999 &rarr; `z = 99`. 

where `j` corresponds to the survey quarter i.e. quarter 1 &rarr; `j = 1`. 

Within each sub-directory we recommend saving the corresponding survey wave according to the following syntax: `qlfsjmz.dta`, `qlfsajz.dta`, `qlfsjsz.dta`, &amp; `qlfsodz.dta`. 

Here `jm` corresponds to January-March i.e. Q1. etc …

In the end the structure of the `indata` directory shoud look like the following 

```
users_path\indata
├── yr96Q1
│ └── qlfsjm96.dta
├── yr96Q2
│ └── qlfsaj96.dta
├── yr96Q3
│ └── qlfsjs96.dta
```


## License 
The content of this repository are licensed under the terms of the MIT License.
