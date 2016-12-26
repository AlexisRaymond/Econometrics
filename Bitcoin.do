**Bitcoin Data
cd "/Users/alexisraymond/Documents/ECON/Econometrics/My Semester Research Paper"
log using Bitcoin_Log_File.log, replace

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/coindesk-bpi-USD-close_data-2013-12-31_2016-11-09.csv", encoding(ISO-8859-1)
*(2 vars, 1047 obs) *Dec. 31, 2013- Nov. 09, 2016
save Bitcoin, replace

gen Date = substr(date,1,10)
drop date
*destring the sent date 
generate date = date(Date, "YMD")
format date %td
drop Date
order date, first

save Bitcoin, replace

clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/WGC-GOLD_DAILY_USD (1).csv", encoding(ISO-8859-1)
*(2 vars, 747 obs) *Dec. 31, 2013 - Nov. 09, 2016 (No data for weekends)
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
save GoldPrices, replace

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                           300
*        from master                         0  (_merge==1)
*        from using                        300  (_merge==2)
*
*    matched                               747  (_merge==3)
*    -----------------------------------------
drop _merge 
save Bitcoin, replace
clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/YAHOO-INDEX_DJI.csv", encoding(ISO-8859-1)
*(7 vars, 721 obs)
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
drop open high low close volume
save DowJones, replace

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                           326
*        from master                         0  (_merge==1)
*        from using                        326  (_merge==2)
*
*    matched                               721  (_merge==3)
*    -----------------------------------------
save Bitcoin, replace

*Clean up data. Relabel
label var adjustedclose "Adjusted Closing Price of Dow Jones"
rename value PriceofGold
label var PriceofGold "Price of Gold in USD"
rename closeprice BitcoinPrice
label var BitcoinPrice "Closing Price of Bitcoin"
drop _merge
save Bitcoin, replace

clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/CBOE-VIX.csv", encoding(ISO-8859-1)
*(5 vars, 722 obs)
drop vixopen vixhigh vixlow
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
save VIX, replace

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                           323
*        from master                         0  (_merge==1)
*        from using                        323  (_merge==2)
*
*    matched                               722  (_merge==3)
*    -----------------------------------------
drop _merge
save Bitcoin, replace

clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/BCHAIN-TOTBC.csv", encoding(ISO-8859-1)clear
*(2 vars, 1044 obs)
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
rename value BitcoinTotalMined
label var BitcoinTotalMined "Total Number of Bitcoins Mined"
save TotalBitcoin

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                             3
*        from master                         0  (_merge==1)
*        from using                          3  (_merge==2)
*
*    matched                             1,044  (_merge==3)
*    -----------------------------------------
drop _merge
save Bitcoin, replace

clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/BCHAIN-TOTBC (1).csv", encoding(ISO-8859-1)
*(2 vars, 1043 obs)
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
rename value BitcoinMined_Change
label var BitcoinMined_Change "Change in Number of Bitcoins Mined"
save BitcoinChange

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                             2
*        from master                         0  (_merge==1)
*        from using                          2  (_merge==2)
*
*    matched                             1,043  (_merge==3)
*    -----------------------------------------
drop _merge
save Bitcoin, replace

clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/FRED-USEPUINDXD.csv", encoding(ISO-8859-1)
*(2 vars, 1045 obs)
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
rename value EconUncertaintyIndex
label var EconUncertaintyIndex "Economic Policy Uncertainty Index for United States"
save EconUncertaintyIndex

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                             0
*    matched                             1,045  (_merge==3)
*    -----------------------------------------
drop _merge
save Bitcoin, replace

clear

import delimited "/Users/alexisraymond/Documents/ECON/Econometrics/USTREASURY-REALYIELD.csv", encoding(ISO-8859-1)
*(6 vars, 716 obs)
generate Date = date(date, "YMD")
format Date %td
drop date
rename Date date
drop v3 v5 v6
rename yr five_year
label var five_year "5 Year Treasury Rate"
rename v4 ten_year
label var ten_year "10 Year Treasury Rate"
save TreasuryRate, replace

merge 1:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                           331
*        from master                         0  (_merge==1)
*        from using                        331  (_merge==2)
*
*    matched                               716  (_merge==3)
*    -----------------------------------------
drop _merge
save Bitcoin, replace
order date, first
label var date "Date"
order date BitcoinPrice
save Bitcoin, replace
	   
twoway (bar BitcoinPrice date), ///
       title(Bitcoin Closing Price (Dec. 31, 2013- Nov. 09, 2016))
graph export BitcoinPrice.pdf	

import delimited "/Users/alexisraymond/Downloads/coindesk-bpi-USD-close_data-2010-07-17_2016-11-14.csv", encoding(ISO-8859-1)
gen Date = substr(date,1,10)
drop date
generate date = date(Date, "YMD")
format date %td
drop Date
order date, first
save FullBitcoin
merge m:m date using Bitcoin
*    Result                           # of obs.
*    -----------------------------------------
*    not matched                         1,267
*        from master                     1,267  (_merge==1)
*        from using                          0  (_merge==2)
*
*    matched                             1,047  (_merge==3)
*    -----------------------------------------
save Bitcoin, replace

twoway (bar closeprice date), ///
		title( Bitcoin Closing Price (July 18, 2010- November 14, 2016))
graph export FullBitcoinPrice.pdf		

drop in 1/1262
drop in 1046/ 1052 
drop _merge
drop closeprice

save Bitcoin, replace		
log close
clear all
end do

