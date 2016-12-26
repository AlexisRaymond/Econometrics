******************************
***    Alexis Raymond      ***
*** Take Home Assignment 5 ***
***     Econometrics       ***
***  Professor Vicentini   ***
***    November 2, 2016    ***
******************************
clear

cd "/Users/alexisraymond/Documents/ECON/Econometrics/Take-home assignment 5"
log using TH5_Log_File.log, replace
import excel "/Users/alexisraymond/Documents/ECON/Econometrics/Take-home assignment 5/cps_2008.xlsx", sheet("Data") firstrow

label var wage "earnings per hour ($)"
label var educ "years of education" 
label var age "years"
label var exper "years of work experience"
label var female "=1 if female"
label var black "=1 if black"
label var white "=1 if white"
label var married "=1 if married"
label var union "=1 if union member"
label var northeast "=1 if northeast region of U.S."
label var midwest "=1 if midwest region of U.S."
label var south "=1 if south region of U.S."
label var west "=1 if west region of U.S."
label var fulltime "=1 if full time worker (as opposed to part-time worker)"
label var metro "=1 if lives in metropolitan area"

save TakeHome5.dta, replace
set more off
eststo clear
*Summary Statistics
sum *, detail
ssc install estout, replace


estpost tabstat *, stats(mean sd sk kurt min p5 p25 p50 p75 p95 max) ///
                      column(statistics)
esttab using TakeHome5_CPSData.rtf, ///
        cells("mean(fmt(2)) sd skewness kurtosis min p5 p25 p50 p75 p95 max") ///
        replace ///
        plain ///
        label ///
        varwidth(30) ///
        nomtitles ///
        nonumbers ///
        title("Table 1. Summary statistics: CPS 2008") ///
        addnote("Note: 4,733 Observations" ///
                "Source: Dr. Kang Sun Lee, Louisiana Department of Health and Human Services")  
				
*Correlation Table
eststo clear

corr wage educ age exper female black white married union northeast midwest south west fulltime metro

quietly:  estpost corr wage educ age exper female black white married union northeast midwest south west fulltime metro, matrix listwise
esttab using TH5_CorrelationTable.rtf, ///
       replace ///
       plain ///
       nonumbers ///
       unstack ///
       not ///
       compress ///
       title("Table 2. Correlation Table of CPS data in 2008") ///
     
*Histogram for wage
histogram wage, ///
		bin(10) xtitle(Wage (earnings per hour ($))) ///
		title(Histogram of Wage in 2008 using CPS data)		
graph export Histogram-of-Wage.pdf, replace		

*Histogram for educ
histogram educ, ///
		bin(10) xtitle(educ (years of education )) ///
		title(Histogram of Years of Education in 2008 using CPS data)		
graph export Histogram-of-Educ.pdf, replace	

*Regression of wage on educ
gen ln_wage = ln(wage)
gen ln_educ = ln(educ)

reg wage educ, r	
graph twoway (lfit wage educ) (scatter wage educ), ///
      title("Scatter plot:  Wage vs. Years of Education") ///
      ytitle("Wage (earnings per hour ($))", size(medsmall))
graph export Scatter_wage_educ_with_OLS_line.pdf, replace		

*Multiple scatter plots
graph matrix wage educ ln_educ ln_wage, half
graph export TH5_Scatter_multiple.pdf, replace 

*Side-by-side Regression table
gen female_educ = female * educ

eststo clear
	eststo: quietly regress ln_wage ln_educ, r
	eststo: quietly regress ln_wage educ, r
	eststo: quietly regress ln_wage educ exper, r
	eststo: quietly regress ln_wage educ exper female, r
	eststo: quietly regress ln_wage educ exper female female_educ,r
	esttab  using TH5_SidebySideTable.rtf, ///
          r2 ar2 se scalar(F rmse) ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          replace ///
          label ///
          depvars ///
          varwidth(30) ///
          title("Table 3. Side by Side regression using CPS 2008 data") ///
          nonotes ///
          addnote("Note 1:  Robust standard errors are displayed in parenthesis." ///
                  "Significance levels:  * p<0.10; ** p<0.05; *** p<0.01")
				  
*F-test
regress ln_wage educ exper female female_educ, robust
test (female = 0)

*Incorporating dummies
regress ln_wage educ exper female female_educ northeast midwest south west, robust
*Linear regression                               Number of obs     =      4,733
*                                                F(7, 4725)        =     318.20
*                                                Prob > F          =     0.0000
*                                                R-squared         =     0.3213
*                                                Root MSE          =     .45325
*
*------------------------------------------------------------------------------
*            |               Robust
*     ln_wage |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
*-------------+----------------------------------------------------------------
*        educ |   .1041582   .0038048    27.38   0.000      .096699    .1116173
*       exper |   .0120771    .000597    20.23   0.000     .0109066    .0132476
*      female |  -.5591927   .0796371    -7.02   0.000    -.7153186   -.4030668
* female_educ |   .0232517   .0059566     3.90   0.000     .0115741    .0349293
*   northeast |          0  (omitted)
*     midwest |  -.0503708   .0194223    -2.59   0.010    -.0884475   -.0122941
*       south |  -.1016694   .0181967    -5.59   0.000    -.1373434   -.0659955
*        west |  -.0524149   .0203546    -2.58   0.010    -.0923194   -.0125105
*       _cons |   .7269702   .0548663    13.25   0.000     .6194067    .8345337
*------------------------------------------------------------------------------



*F-test
test (northeast= 0) (midwest=0) (south=0) (west=0)

	
save TakeHome5.dta, replace	
log close 
