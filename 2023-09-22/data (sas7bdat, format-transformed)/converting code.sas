LIBNAME DATASET "D:\git\Applied_econometrics_for_health_policy\2023-09-22\output";

PROC IMPORT DATAFILE = "D:\git\Applied_econometrics_for_health_policy\2023-09-22\data\Car.dta"
			DBMS = STATA
			OUT = DATASET.Car
			REPLACE;
PROC IMPORT DATAFILE = "D:\git\Applied_econometrics_for_health_policy\2023-09-22\data\cd_2005.dta"
			DBMS = STATA
			OUT = DATASET.cd_2005
			REPLACE;
PROC IMPORT DATAFILE = "D:\git\Applied_econometrics_for_health_policy\2023-09-22\data\id_2005.dta"
			DBMS = STATA
			OUT = DATASET.id_2005
			REPLACE;
RUN;
