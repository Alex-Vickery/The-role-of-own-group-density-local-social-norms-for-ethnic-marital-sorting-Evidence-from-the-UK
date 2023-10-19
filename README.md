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

where `z` corresponds to the survey year i.e. in survey year 1999 &rarr; `z = 99`. 

where `j` corresponds to the survey quarter i.e. in quarter 1 &rarr; `j = 1`. 

Within each sub-directory we recommend saving the corresponding survey wave according to the following syntax: `qlfsjmz.dta`, `qlfsajz.dta`, `qlfsjsz.dta`, &amp; `qlfsodz.dta`. 

Here `jm` corresponds to January-March, `aj` corresponds to April-June, etc ...

The structure of the `indata` directory shoud therefore look like the following 

```
users_path\indata
├── yr96Q1
│ └── qlfsjm96.dta
├── yr96Q2
│ └── qlfsaj96.dta
├── yr96Q3
│ └── qlfsjs96.dta
```
### IMPORTANT – `masterfile.do` must be executed before executing any other `.do` file

`Masterfile.do`

This `.do` file is the main script for cleaning the data and creating marriage matrices that will be exported to Matlab for the model estimation.

We recommend that the user creates additional directories that correspond to the Global variables defined in lines 30-37 of the `.do` file `Masterfile.do` before proceeding. 

Section 0 of the `.do` file is for programme definitions. 

These are programmes that will be subsequently executed on each survey wave in order to clean the data. 

Section 1 applies the pre-defined programmes to each survey wave, keeping only the relevant variables and then saves each cleaned wave as a temporary dataset. 

In order for this to execute it is required to have the qualification and ethnicity merge files stored in the correct directory. Specifically, all qualifications files (provided) need to be stored in a folder `qualpath` and the ethnicity merge file `eth01q1.dta` needs to be stored in the `tempdata` folder. The merge files are user created according to LFS mapping documents; we require the use of the merge `.dta` files in order to create a consistent definition of qualifications across all survey waves. 

Section 2 loops over survey waves creating a dataset of men that is subsequently merged with a created dataset of potential female partners. It also creates a dataset of women that is subsequently merged with a dataset of potential male partners. Section 2 concludes by appending the male and female datasets together into a single ‘matched’ dataset for each survey wave. 

Section 3 appends the matched datasets for each survey wave together into a single dataset.

Sections 4 and 5 inspect and clean the data respectively. 

Section 6 uses the cleaned data to create matrices, by region, that are exported as `.txt` files  to be used in matlab for the model estimation. Specifically, the `.do` file creates matrices for:
- Population distribution over ethnicity and education, by gender – `Qualpreregr.txt`
- Population counts by ethnicity, education, and gender – `cnt_preregr.txt`
- Male marriage rates by ethnicity and education – `M_prer.txt`
- Female marriage rates by ethnicity and education – `F_prer.txt`
- Male and female singles rates – `s_mr.txt`, `s_fr.txt`
- Male and female marriage rates to partners born outside of the UK – `o_mr.txt`, `o_fr.txt`

**Table 1:** The population counts shown in Table 1 are created in 1882-1910 of `Masterfile.do`.

**Figure 1:** The data used in Figure 1 is generated at this stage by summarising the ethnicity 
dummies by region. (eth and govtof respectively in the cleaned data).


## License 
The content of this repository are licensed under the terms of the MIT License.
