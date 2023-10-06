* Setting the output folder;
LIBNAME OUTPUT "";

* Transforming DTA to SAS Dataset;
* Setting source data at FILE= ;
* Setting output file name at OUT=OUTPUT. ;
PROC IMPORT FILE=""
	OUT=OUTPUT.
	DBMS=STATA
	REPLACE;
RUN;
