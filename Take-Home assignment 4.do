****************************
** Take-Home Assignment 3 **
**     Alexis Raymond     **
**      Econometrics      **
**   Professor Vicentini  **
**     October 10, 2016    **
****************************
clear

cd "/Users/alexisraymond/Documents/ECON/Econometrics/Take-home assignment 4"

log using Assignment4-LogFile.log, replace

*Import data set*
import excel "/Users/alexisraymond/Documents/ECON/Econometrics/Take-home assignment 4/crime - 1987.xlsx", sheet("Sheet1") firstrow
set more off

*save as Stata dataset*
save "/Users/alexisraymond/Documents/ECON/Econometrics/THAssignment4.dta", replace
clear

use THAssignment4.dta, replace

*Relabel 25 variables*
label var county "County Name (North Carolina)"
label var year "1987"
label var crmrte "Crimes Committed per person"
label var prbarr "Probability of Arrest"
label var prbconv "Probability of Conviction"
label var prbpris "Probability of Prison Sentence"
label var avgsen "Average Sentence (days)"
label var polpc "Police Per Capita"
label var density "Thousands of People per Square Mile" 
label var taxpc "Tax Revenue Per Capita"
label var west "Dummy for West"
label var central "Dummy for Central"
label var east "Dummy for East"
label var urban "Dummy for Urban (SMSA)"
label var pctmin80 "Percent Minority, 1980"
label var pctymle "Pecent Young Male"
label var wcon "Weekly Wage- Construction Industry"
label var wtuc "Weekly Wage- Transportation, Utility and Communications Industry"
label var wtrd "Weekly Wage- Wholesale, Retail Trade Industries"
label var wfir "Weekly Wage- Finance, Insurance, Real Estate Industry"
label var wser "Weekly Wage- Service Industry"
label var wmfg "Weekly Wage- Manufacturing Industry"
label var wfed "Weekly Wage- Federal Employees"
label var wsta "Weekly Wage- State Employees"
label var wloc "Weekly Wage- Local Government Employees" 

sum *, detail

* Create and export table of summary statistics*
   ssc install estout, replace

   estpost tabstat *, stats(mean sd sk kurt min p5 p25 p50 p75 p95 max) ///
                      column(statistics)
   esttab using Assignment4SummaryTable.rtf, ///
          cells("mean(fmt(2)) sd skewness kurtosis min p5 p25 p50 p75 p95 max") ///
          replace ///
          label ///
          varwidth(30) ///
          nomtitles ///
          nonumbers ///
          title("Table 1. Summary Statistics: Crime 1987") ///
          addnote("Note: 90 Observations. Each observation is regarding a county in North Carolina in 1987")  

*Histograms 		  
histogram crmrte, ///
		bin(10) xtitle(Crime Rate- Crimes Committed Per Person) ///
		title(Histogram of Crime Rate in North Carolina in 1987)		
graph export Histogram-of-Crime-Rate.pdf, replace		
		
histogram prbarr, ///
		bin(10) xtitle(Probability of Arrest) ///
		title(Histogram of Probability of Arrest in North Carolina in 1987)	
graph export Histogram-of-Prob-Of-Arrest.pdf, replace		


*Correlation Table
eststo clear

corr crmrte prbarr prbconv prbpris avgsen polpc
corr

quietly:  estpost corr crmrte prbarr prbconv prbpris avgsen polpc, matrix listwise
esttab using table_correlation_Crime.rtf, ///
       replace ///
       plain ///
       nonumbers ///
       unstack ///
       not ///
       compress ///
       title("Table 2. Correlation Table of Crime in North Carolina in 1987") ///
     


reg crmrte prbarr, robust
predict pcrmrte
summarize pcrmrte

gen OLS_Residuals = pcrmrte- crmrte
scatter OLS_Residuals prbarr, ///
        title("Probability of Arrest vs. OLS Residuals of Crime Rate")

graph export Scatter_prbarr_OLSResiduals.pdf, replace


*Regressions 
reg crmrte prbarr, r
reg crmrte prbarr density, r
reg crmrte prbarr density urban, r
reg crmrte prbarr urban, r

eststo clear  
  eststo:  quietly  regress crmrte prbarr, robust
  eststo:  quietly  regress crmrte prbarr density, robust
  eststo:  quietly  regress crmrte prbarr density urban, robust
  eststo:  quietly  regress crmrte prbarr urban, robust 
  esttab  using table3_sidebyside_regressions.rtf, ///
          r2 ar2 se scalar(F rmse) ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          replace ///
          label ///
          depvars ///
          varwidth(30) ///
          title("Table 3. Regression Results for 1987 North Carolina Crime Data") ///
          nonotes ///
          addnote("Note 1:  Robust standard errors are displayed in parenthesis." ///
                  "Significance levels:  * p<0.10; ** p<0.05; *** p<0.01")

vif

reg crmrte prbarr density west central east
reg crmrte prbarr density west central
reg crmrte prbarr density east west

eststo clear
 eststo:  quietly reg crmrte prbarr density west central east
 eststo:  quietly reg crmrte prbarr density west central
 eststo:  quietly reg crmrte prbarr density east west 
 esttab using table4_Sidebyside_regressions.rtf, ///
		r2 ar2 se scalar(F rmse) ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          replace ///
          label ///
          depvars ///
          varwidth(30) ///
          title("Table 4. Interpretation of Dummy Variables." ///
				"Regression Results for 1987 North Carolina Crime Data") ///
          nonotes ///
          addnote("Note 1:  Robust standard errors are displayed in parenthesis." ///
                  "Significance levels:  * p<0.10; ** p<0.05; *** p<0.01")

gen density_1000 = (density/ 1000)
reg crmrte prbarr density_1000 				  

 
log close		
