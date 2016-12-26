***Take-Home Assignment 1***

clear
set more off 

*change directory*
cd "/Users/alexisraymond/Documents/ECON/Econometrics/Take-home assignment 1"

*create log file
log using Home_data_Stockton_LOG_FILE.log, replace

*import data*
import excel using "Home data - Stockton.xlsx", sheet("Data") firstrow
save Home_data_Stockton, replace
clear

use Home_data_Stockton, replace

*Label variables*
label var sprice "Selling price of home(USD)"
label var livarea "Living area (hundreds of sq. ft.)"
label var beds "Number of beds"
label var baths "Number of baths"
label var lgelot "=1 if lot size > 0.5 acres, 0 otherwise"
label var age "Age of home at time of sale (years)"
label var pool "=1 if home has pool, 0 otherwise"

sum, detail 


*Calculate a table of desciptive statistics*
ssc install estout, replace


estpost tabstat *, stats(mean sd sk kurt min p5 p25 p50 p75 p95 max) ///
                      column(statistics)
esttab using Table-Home_data_Stockton.csv, ///
        cells("mean(fmt(2)) sd skewness kurtosis min p5 p25 p50 p75 p95 max") ///
        replace ///
        plain ///
        label ///
        varwidth(30) ///
        nomtitles ///
        nonumbers ///
        title("Table 1. Summary statistics: Home data Stockton") ///
        addnote("Note: Data consists of 2,610 home sales in Stockton, CA from Oct. 1, 1996 to Nov. 30, 1998" ///
                "Source:  Dr. John Knight, Department of Finance, University of the Pacific")  

* Create a histogram of Selling Price *
hist sprice, ///
     start(0) width(50000) frequency addlabels mlabsize(half_tiny) ///
	 xlabel(0(50000)750000, angle(forty_five) format(%9.0gc)) ///
     xtick(0(50000)750000) ///
     xtitle("Selling Price of Home(USD)", size(medsmall)) ///
     ylabel(0(200)1200, angle(horizontal) format(%9.0gc)) ///
     title("Histogram of Selling Price of a Home in Stockton, CA") ///
     subtitle("(From Oct. 1, 1996- Nov. 30, 1998)", size(med)) ///
     note("Note:  Number of observations is 2,610.") ///
     caption("Source: Dr. John Knight, Department of Finance, University of the Pacific.", size(vsmall))

graph export Histogram-sprice.pdf, replace 


*Create a scatter plot of Selling Price and Living area*
scatter sprice livarea, ///
	msize(medsmall) xlabel(,grid angle(forty_five)) ///
	ylabel( , angle(forty_five)) ///
	title("Scatter Plot of Selling Price Vs. Living Area") ///
	note("Note: 2,610 observations. Data is from Stockton, CA from Oct. 1, 1996- Nov. 30, 1998") ///
    caption("Source: Dr. John Knight, Department of Finance, University of the Pacific.", size(vsmall))

graph export Scatter-sprice_livarea.pdf, replace
	 
log close
clear all

*For analysis of table and graphs see Word doc.*
