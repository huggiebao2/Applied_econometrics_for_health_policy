*=====================================================*
*Week 9&10 Matching
*=====================================================*
* In this context, you have two rounds of data (before and after) on both enrolled and nonenrolled households. 
* Please compare health expenditures at follow-up between enrolled households and a set of matched nonenrolled households from both treament and comparison villages.

*============================*
*Select the relevant data
*============================*
use "../data (dta, gph)/HISP survey.dta", clear

*============================*
*Macros: make sure you run this piece of code before running the regressions
*============================*
*put together a standard list of explanatory variables to be used in regression analysis
global controls age_hh age_sp educ_hh educ_sp female_hh indigenous hhsize dirtfloor bathroom land hospital_distance

*============================*
*Class exercise: HISP Impact using propensity score matching method
*============================*
* reshape the database so that each household appears in only one row.
* The information on baseline and follow-up for each household appears in a single row.
* This is called a "wide" dataset.

reshape wide health_expenditures age_hh age_sp educ_hh educ_sp hospital, i(household_identifier) j(round)

*Baseline characteristics now appear twice. Keep only one.
drop age_hh1 age_sp1 educ_hh1 educ_sp1 hospital1
rename age_hh0 age_hh
rename age_sp0 age_sp
rename educ_hh0 educ_hh
rename educ_sp0 educ_sp
rename hospital0 hospital

*Estimate the propensity score.
probit enrolled $controls 
predict pscore, pr			/* pscore is a self-define variable name */
sum pscore

*Draw graph to show region of common support.
kdensity pscore if enrolled ==1, gen(take1 den1)
kdensity pscore if enrolled ==0, gen(take0 den0)
twoway (line den0 take0) (line den1 take1)

*Nearest neighbor matching requires the observations to be sorted in a random order. 
   *Here we generate a random number and sort observations according to that number.
    set seed 100 /*specifies the initial value of the random-number seed*/
    generate u=runiform()
    sort u

*Perform PSM (default: nearest neighbourhood matching) (default: probit)
ssc install psmatch2, replace /*install up-to-date psmatch2*/
psmatch2 enrolled $controls, out(health_expenditures1) common /*imposes a common support by dropping treatment observations whose pscore is higher than the maximum or less than the minimum pscore of the controls*/
   *Examine new variables created by Stata (for details see: help psmatch2)
sort _id
sum _pscore pscore
tab _treated
tab _treated enrolled
tab _support 
tab _weight if _treated==1, miss  /*For nearest neighbor matching, it holds the frequency with which the observation is used as a match with option ties and k-nearest neighbors matching it holds the normalized weight*/
tab _weight if _treated==0, miss

*use _n1 to check _pdif
list _id _treated _weight _pscore _n1 _pdif if _id==7369
list _id _treated _weight _pscore _n1 _pdif if _id==2904
display  .21885996- .21884225

*Check mean outcomes of the treated and untreated after matching
sum health_expenditures1 if enrolled==1 & _weight!=. & _support==1
sum health_expenditures1 if enrolled==0 & _weight!=. & _support==1 [fweight=_weight]

*Standard error on the impact estimate
   *There are different views on the way to estimate the standard error - here are two of them.
   *Estimating standard errors using bootstrapping.
    set seed 100
    bootstrap r(att) : psmatch2 enrolled $controls, out(health_expenditures1)
   *Estimating standard errors using linear regression.
    reg health_expenditures1 enrolled [fweight=_weight]

*Options for psmatch2
psmatch2 enrolled $controls, outcome (health_expenditures1) common logit 
psmatch2 enrolled $controls, outcome (health_expenditures1) common neighbor(3) 
psmatch2 enrolled $controls, outcome (health_expenditures1) common radius caliper(0.01) 

* Balance checking
psmatch2 enrolled $controls, out(health_expenditures1) common
pstest $controls, both 


*============================*
*Class exercise: HISP Impact using matched difference-in-differences
*============================*
* Manually compute the matched difference-in-differences.
sort _id
    *Create variable contains health expenditures of nearest neighbor match at baseline.
     gen health_exp_match0 = health_expenditures0[_n1] 
    *Create variable contains health expenditures of nearest neighbor match at follow-up 
	     /*This is equivelent to _health_expenditures1 created by Stata*/
	 gen health_exp_match1 = health_expenditures1[_n1] 
tabstat health_expenditures0 health_expenditures1 health_exp_match0 health_exp_match1 if enrolled==1, varwidth(20) columns(statistics)  s(n mean sd min max)
gen matchedDD=(health_expenditures1-health_expenditures0)-(health_exp_match1-health_exp_match0) if enrolled==1
sum matchedDD

* Use regression to compute matched difference-in-differences and standard error on DD
gen diff=health_expenditures1-health_expenditures0
tab _weight, missing
gen matched=_weight>=1 & _weight~=.& enrolled==0
lab var matched "1 if nonenrolled matched to enrolled"
reg diff enrolled [fweight=_weight] if !(matched==0 & enrolled==0)/*exclude nonenrolled which were not matched to enrolled*/
