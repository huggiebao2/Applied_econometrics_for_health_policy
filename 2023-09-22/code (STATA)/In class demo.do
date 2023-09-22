 use "C:\Users\Car.dta", clear
 
 /*
 
 This do file explains some of the basics
 
 */
 
 *總共有幾筆資料?
 describe
 
 *平均價格是多少?
 sum price
 
 *變項改名
 rename make manufacturer
 
 *多少車是foreign made?
 tab foreign
 
 *多少車>$5000
 count if price >=5000
 
 label data "1978 Automobile Data, In-class exercise"
label var price "price of the car"
*to clear
label variable price "" 

*label categories
label define stock 0 no 1 yes 2 maybe
label list stock 
*to drop
label drop stock

*describe your variable
list price
list price if price>6000
*list only the 45~49 observations
list in 45/49  

*summarize (short for summarize, only for numeric values)
sum price
sum price, detail
sum price if length<200
sum price if weight>3000
sum price if weight>3000, detail

*table statistics
tabstat price weight mpg  
tabstat price weight mpg, by(foreign) stat(mean sd min max) long

*tab a variable
tab length
tab length if length<170
tab length if length<170, sum(weight)

/*
保持良好習慣: 跑迴歸前先sum或tab所有變項，並作完整描述性統計。
*/
 
 
 *save dataset
 save "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata\Car_2.dta", replace
 
 
*Generate a variable 
gen want=1 if price<=4500 & stock==1
gen eco = length + weight


*preserve must run with restore
preserve
*Keep variable(s)  
keep price weight length
*Keep christy*  (keep all variables beginning with christy)
*Drop variable(s) 
drop price weight
restore

*保持良好習慣: always drop those variables you mistakenly generated.

*文字變項
tab own
gen car_id=[own] + [id]
gen car_id2 = [own] + " loves STATA" if own=="Christy"
replace car_id2 =  [own] + " loves SAS" if own=="Hu"

 
*Replace  
replace stock=. if  price>7000
gen eco=.
replace eco= length/weight

 /*
 gen vs. egen
 
“gen” is to generate a variable.
“egen” generates a variable containing a function.
Functions in egen include: 
mean, sd, max, mean, median, mode, rank, iqr, kurt, skew, rowmean, rowmax…etc

For more functions: findit egen

For example, I want to generate a variable containing the mean of price:
*/

egen mean_price = mean(price)
count if price > mean_price
*  keep if price > mean_price


*For percentiles and quantiles:
 pctile p_price = price, nq(5)
  
xtile x_price = price, nq(5)


*Sort in ascending order 
sort 
sort id
sort id sex

*Sort in descending order:
gsort id -sex   
*(the minus sign means this variable is to be sorted in descending order)
*Sort must be performed before “by” 
sort own
by own: sum price
by own: logistic Y X1 X2 X3
bysort own: sum price

*Merge file

*Open using file, sort id
*Open master file, sort id
merge 1:1 id using "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata\Homework_stata format\Using file.dta"

*1  observation only appears in the Master data  
*2  observation only appears in the Using data  
*3  Observations in both Master and Using data  

*update
merge 1:1 id using "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata\Homework_stata format\Using file.dta", update
*STATA will use the Using values only when Master has missing values.

* replace, update
merge 1:1 id using "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata\Homework_stata format\Using file.dta", replace update
*STATA will use the value in Using to replace Master.

*保持良好習慣: merge前先預測應出現什麼數值，然後 tab _merge 檢察
/*
Q: 健保資料庫ID檔=master, 
     CD檔=using, 
      merge後應該會出現哪些 _merge值?
*/
*Always drop _merge before performing next merge.       
	  

*Append 
*See slides 
use "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata\Homework_stata format\Master file.dta", clear
append using "C:\Users\Christy\Desktop\Course September 2021\Econometrics\Stata\Homework_stata format\Append.dta"



*Others, see slides
