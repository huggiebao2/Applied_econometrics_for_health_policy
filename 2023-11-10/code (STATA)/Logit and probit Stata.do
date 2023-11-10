*Logit and probit
webuse lbw, clear
*"C:\Users\Christy\Desktop\D\Econometrics\Logit and Probit\lbw.dta"
describe
summarize

tab low
*about 31% of the babies have low birth weight

global x "lwt ht"
*lwt= mother's weight


*quantile plot
 quantile bwt
 
 tab low
   bysort low: sum bwt

*y=continuous
regress bwt $x

*y=binary
regress low $x

predict phat
predict resid, residual
generate resid2 = resid^2
scalar b0    = _b[_cons]
scalar b_lwt = _b[lwt]
scalar b_ht  = _b[ht]

twoway scatter low lwt, xlabel(80(20)260) ///
	|| rcap low phat lwt ///
	|| function y = b0 + b_lwt*x, range(80 250) ///
	|| function y = b0 + b_lwt*x + b_ht, range(80 250) ///
    yline(0 1) ///
    title("Linear Probability Model") ///
	ytitle("y/Fitted Values") xtitle("Mother's Weight (lbs.)") legend(off)
graph export LPM_bwt.eps, replace

*Heteroskedasticity
twoway scatter resid2 lwt, xlabel(80(20)260) ///
    yline(0) ///
    title("Heteroskedasticity in LPM") ///
	ytitle("Squared Residuals") xtitle("Mother's Weight (lbs.)") legend(off)
graph export LPM_hetero.eps, replace
  
logit low

gen pnc=(ftv>=1)
tab low pnc
logit low pnc


logit low i.smoke##i.ht
margins, dydx(smoke) at(ht=(0 1)) post
margins, coeflegend
test _b[1.smoke:2._at] = _b[1.smoke:1bn._at]

*to make a table of regressions quickly
quiet logit low age lwt
estimates store logit
quiet probit low age lwt
estimates store probit
estimates table logit probit, stats(N ll) b(%8.3f) se(%8.3f) p(%8.3f)

gen agesq=age*age
logit low c.age c.age#c.age lwt
estimates store a
logit low c.age c.agesq lwt
estimates store b
estimate table a b , stats(N ll) b(%8.3f) se(%8.3f) p(%8.3f)


* Use syntax for -margins-

*For continuous variables:
reg low c.lwt i.smoke i.ht c.age c.age#c.age
 margins, dydx(age)
 *Every unit increasein age is expected to decrease predcted probaility of Y by 0.4 percentage points

*For logistc regression
logit low c.lwt i.smoke i.ht, nolog vce(robust)

* Average of predicted probabilities
summarize low
predict pphat
summarize pphat
margins
margins , at((asobserved) _all)

* Base case predicted probabilities
display 1/(1 + exp(-_b[_cons]))
margins , at((zero) _continuous (base) _factor)
* margins , at((zero) lwt (base) smoke ht)

* Predicted values at specific values
margins , at((median) _continuous (base) _factor)
margins , at(lwt=130 smoke=0 ht=0)

* Predicted values at the mean
margins , atmeans           /* not recommended */
*margins , at((mean) _all)  /* not recommended */

* Predicted values for multiple values of variable
margins smoke
margins , at(smoke=(0 1))
* margins lwt  /* cannot do this for continuous variable */
margins , at(lwt=(100 130 160))
margins , at(lwt=(100(20)160) smoke=(0 1) ht=0)
margins smoke, at(lwt=(100(20)160) ht=0)
margins smoke ht

* Different ways of estimating effect of smoking
margins                
margins smoke
margins , over(smoke)
margins if smoke==0, at(smoke=(0 1))
margins if smoke==1, at(smoke=(0 1))

* Incremental effects
margins , dydx(smoke ht)

* Marginal effects
margins , dydx(lwt)

* Add lwt squared
logit low c.lwt c.lwt#c.lwt, nolog
margins , at(lwt=(100(20)160))
twoway function y = 1/(1 + exp(-(_b[_cons] + _b[c.lwt]*x + _b[c.lwt#c.lwt]*x^2))), ///
	range(100 200) yline(0) xlabel(100(20)200)

margins , dydx(lwt)
margins , dydx(lwt) at(lwt=(100(20)160))
marginsplot
twoway function y = (1/(1 + exp(-(_b[_cons] + _b[c.lwt]*x + _b[c.lwt#c.lwt]*x^2))))* ///
	(1 - (1/(1 + exp(-(_b[_cons] + _b[c.lwt]*x + _b[c.lwt#c.lwt]*x^2)))))* ///
	(_b[c.lwt] + 2*_b[c.lwt#c.lwt]*x), ///
    range(100 200) yline(0) xlabel(100(20)200)
	
	 
*Ordered logistic
webuse fullauto, clear
ologit rep77 foreign, nolog
margins, dydx(foreign)


*mlogit
mlogit rep78 price i.foreign
margins, dydx(*)
margins, dydx(price) at(price=(2800(2000)15000))
marginsplot

margins , at(price=(2800(2000)15000))
marginsplot