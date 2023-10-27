/***************************************
Use "PSMATCH.dta" to demonstrate command
****************************************/

/*******
Basic
********/
psmatch2 t x1 x2, out(y)
d
/******************
Check new variables
*******************/ 
   /*若未儲存，會被新指令覆蓋掉*/
tab t _treated
tab _weight if t==1
tab _weight if t==0 
/*find matched outcome by using search function for "_id" and _id of control unit stored in _n1*/
/*check _pdif*/

/**************************
Calculate treatment effect
***************************/
pscore t x1 x2, pscore(myps)
attnd y t, detail

psmatch2 t x1 x2, out(y) common ate
psmatch2 t x1 x2, out(y) n(5) logit
psmatch2 t x1 x2, out(y) radius caliper(0.01)
count if _weight!=. & t==1
count if _weight!=. & t==0
