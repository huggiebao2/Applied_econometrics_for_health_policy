
*in class exercise
cd "C:\Users\"
use cd_2005, clear
 gen count1=1
gen dm=regexs(0) if (regexm(acode_icd9_1, "^[2][5][0]"))
replace dm=regexs(0) if (regexm(acode_icd9_2, "^[2][5][0]"))
replace dm=regexs(0) if (regexm(acode_icd9_3, "^[2][5][0]"))
gen DMcount=1 if dm~=""

*/
collapse (sum) count1 DMcount (mean) t_amt drug_amt, by(id id_birthday)
sort id id_birthday
save temp.dta, replace

use id_2005.dta , clear
sort id id_birthday
merge id id_birthday using temp.dta 
tab _merge
*should only have 1 and 3*
drop _merge
replace count1=0 if count1==.
replace DMcount=0 if DMcount==.
replace t_amt=0 if t_amt==.
replace drug_amt=0 if drug_amt==.  
tab DMcount
tab count1
sum count1 t_amt drug_amt if count1~=0
count if DMcount~=0
