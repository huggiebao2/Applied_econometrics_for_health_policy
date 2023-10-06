cd "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata"
use car, clear

*Perfect collinearity
reg price trunk, robust
gen trunk2=trunk+3
gen trunk3=3*trunk
gen trunk4= 1-trunk

*what happens if we regress price on trunk, trunk2, trunk3, trunk4?
reg price trunk
reg price trunk2
reg price trunk3
*di 72.24942*3
reg price trunk4 
reg price trunk trunk4 

*now let's make trunk 5 highly collinear with trunk
gen trunk5=3*trunk +mpg
corr trunk trunk5
reg price trunk
reg price trunk5
predict r5, res
reg price trunk trunk5
predict r_both, res
       *Regressing price on trunk5 was insignificant, but now it is significant, why?
	    *Let's generate the variance for each.
		gen r5_2=r5^2
		gen r_both2=r_both^2
		sum r5_2 r_both2		
	   *It is clear r5^2 is much larger!
 

*Assumption 4 (Zero conditional mean)
reg price trunk
predict resid, res
reg trunk res
    /*it is like OLS will make the estimate biased in a way 
	in order to force there is no relationshop between trunk and residual. */

reg price trunk mpg
predict resid1, res
reg mpg resid1
reg trunk resid1

*Heteroskedasticity
twoway (scatter resid trunk), ytitle(resid) xtitle(trunk)
 

/*Load Data7*/
cd "C:\Users\Christy\Desktop\Course September 2021\Econometrics\OLS"
use SMOKE, clear

/*
Y : number of cigarettes smoked per day (cigs)
X: log of annual income (lincome), 
log of per-pack price (lcigpric), 
years of school (educ), 
age measured in years (age), 
square of age, 
a binary indicator of whether the person residing in 
   a state with restaurant smoking restrictions (restaurn)
*/
sum
histogram cigs, bin(20) normal
/*Cigs=0 for a lot of observations, using OLS is not ideal because it can result
 in negative predicted value, but we can still learn about the determinants*/

/*OLS*/
reg cigs lincome lcigpric educ age agesq restaurn
rvpplot lincome, yline(0)
*The rvpplot command plots a residual versus predictor

/*WLS*/
/*install wls0 program*/
*use findit wls0
wls0 cigs lincome lcigpric educ age agesq restaurn, wvar(lincome) type(abse) graph
/* The WLS type, abse, uses the absolute value of the residuals */
*wvar(lincome) means we suspect the residual to vary with income. You can add other variables

wls0 cigs lincome lcigpric educ age agesq restaurn, wvar(lincome age) type(e2) graph
/* Residual squared*/

wls0 cigs lincome lcigpric educ age agesq restaurn, wvar(lincome) type(loge2) graph
/*adjustment proportional to the log of squared residuals, wrong heteroskedasticity functional form, less efficient*/

/*Heteroskedasticity-robust SE option*/
reg cigs lincome lcigpric educ age agesq restaurn, robust
wls0 cigs lincome lcigpric educ age agesq restaurn, wvar(lincome) type(abse) robust  graph

*the robust option means that STATA will "scale up" the stnadard error using a satndard formular
*always use the "robust" option

/*Time series & serial correlation*/
use "PRMINWGE.dta", clear

/*
Y : Log of employment rate in PR (lprepop)
X: log of US GNP (lusgnp); 
	log of Puerto Rico GNP (plrgnp);
	importance of minimal wage relative	to average wages (mincov)
*mincov= (avg. min. wage)/(avg. overall wage)*(% workers covered by in. wage law) 
*/

/*Static OLS*/
sum
reg lprepop lusgnp lmincov /*GNP not statistically significant*/
reg lprepop lusgnp lmincov t  /*Adding trend veriable t to "detrend"*/
twoway (scatter lprepop t)
twoway (scatter lusgnp  t) /*GNP show obvious trends*/

/*Testing for serial correlation- D/W test and Durbin Alternative Test */
tsset year
reg lprepop lusgnp lmincov lprgnp t
estat dwatson
*38 is the sample size, 5 is the number of parameters
*Google a DW table. No p-values reported by STATA, unfortunately
*DW shows the critical value bound is 1.019-1.584
*With the DW-statistic 1.013709, we reject the null of no serial correlation

estat bgodfrey
*we reject the null of no serial correlation



/*Serial correlation-robust SE; Newey-West SE*/
newey lprepop lusgnp lmincov lprgnp t, lag(3) /*lag(#) sets maximum lag order of autocorrelation*/
*estat dwatson and estat bgodfrey do not work after newey

clear




