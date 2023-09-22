LIBNAME DATASET "D:\git\Applied_econometrics_for_health_policy\2023-09-22\output";

* import DTA data;
PROC IMPORT DATAFILE="D:\git\Applied_econometrics_for_health_policy\2023-09-22\data\Car.dta"
			DBMS=STATA
			OUT=DATASET.CAR REPLACE;
RUN;

* view top 5 observations;
PROC PRINT DATA=DATASET.CAR (OBS=5);
RUN;

* to see how many foreign car;
PROC FREQ DATA=DATASET.CAR;
	TABLE foreign;
RUN;
