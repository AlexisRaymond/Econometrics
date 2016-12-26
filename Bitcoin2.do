***Using merged and cleaned Bitcoin Data***

clear all
cd "/Users/alexisraymond/Documents/ECON/Econometrics/My Semester Research Paper"
log using Bitcoin_Regress.log, replace
use "/Users/alexisraymond/Documents/ECON/Econometrics/My Semester Research Paper/Bitcoin.dta"


histogram three_month, ///
		bin(10) xtitle("Three Month Tresury Bond Yields") ///
		title("Histogram of 3 Month Treasury Bond Yields") /// 
		subtitle("From Dec. 31, 2013- November 09, 2016")
graph export Histogram-Three_month.pdf, replace	

histogram five_year, ///
		bin(10) xtitle("5 Year Treasury Bond Yield") ///
		title("Histogram of 5 Year Treasury Bond Yields") ///
		subtitle ("From Dec 31, 2013- November 9, 2016")
graph export Histogram-Fiveyear.pdf, replace

summarize BitcoinPrice three_month five_year EconUncertaintyIndex BitcoinMined_Change vixclose adjustedclose PriceofGold

ssc install estout, replace
eststo clear
* use "tabstat" to calculate descriptive stats, then export to a Word file
estpost tabstat BitcoinPrice three_month five_year EconUncertaintyIndex BitcoinMined_Change vixclose adjustedclose PriceofGold, stats(mean sd sk kurt min p5 p25 p50 p75 p95 max) ///
                   column(statistics)
esttab using Bitcoin_tabstat.rtf, ///
        cells("mean(fmt(2)) sd skewness kurtosis min p5 p25 p50 p75 p95 max") ///
        replace ///
        plain ///
        label ///
        varwidth(30) ///
        nomtitles ///
        nonumbers ///
        title("Table 1.  Summary statistics:  Bitcoin Data") ///
        addnote("Note: All data is taken from Dec. 31, 2013- Nov. 09, 2016")

eststo clear

corr BitcoinPrice three_month five_year EconUncertaintyIndex BitcoinMined_Change vixclose adjustedclose PriceofGold

quietly:  estpost corr BitcoinPrice three_month five_year EconUncertaintyIndex BitcoinMined_Change vixclose adjustedclose PriceofGold, matrix listwise
esttab using Bitcoin_CorrelationTable.rtf, ///
       replace ///
       plain ///
       nonumbers ///
       unstack ///
       not ///
       compress ///
       title("Table 2. Correlation Table of Bitcoin data") 



   **Bitcoin Time series models and Regressions


***Format Calender to allow for gaps***
bcal create Bitcoin, replace from(date) purpose(Bitcoin and Financial Data) generate(Date)

order Date, first
tsset Date

tsreport *
*Gap summary report
*--------------------------------------------------------
*             |                             --Number of--
*Variable     |      Start         End      Obs.     Gaps
*-------------+------------------------------------------
*        Date |  31dec2013   09nov2016       718        0
*BitcoinPrice |  31dec2013   09nov2016       718        0
* three_month |  31dec2013   09nov2016       718        0
*   five_year |  31dec2013   09nov2016       716        2
*    ten_year |  31dec2013   09nov2016       716        2
* PriceofGold |  31dec2013   09nov2016       718        0
*EconUncert~x |  31dec2013   09nov2016       718        0
*    vixclose |  31dec2013   09nov2016       717        1
*adjustedcl~e |  31dec2013   08nov2016       716        1
*BitcoinMin~e |  31dec2013   09nov2016       717        1
*--------------------------------------------------------

tsreport
*Time variable:    Date
*---------------------------
*Starting period = 31dec2013
*Ending period   = 09nov2016
*Observations    =       718
*Number of gaps  =         0


label var Date "Business Calendar Formated Date(no gaps)"


twoway (tsline BitcoinPrice, lcolor(pink) connect(direct)), ///
		ytitle("Yield") ttitle(Time) tlabel(#18, labels labsize(small) angle(forty_five) grid)

twoway (tsline BitcoinMined_Change, lcolor(pink) connect(direct)), ///
		ytitle("Amount Mined") ttitle(Time) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
		title(Bitcoin Mined Daily, size(medium)) ///
		note("Source: blockchain.info/charts")
graph export DailyMined.pdf, replace		
	
twoway (tsline three_month, lcolor(purple) connect(direct)), ///
		ytitle("Yield") ttitle(Time) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
		title(Three Month Treasury Bond Yield, size(medium)) ///
		note("Source: US Treasury Database")
graph export Three_Month.pdf, replace	

twoway (tsline BitcoinPrice, lcolor(blue) c(1) yaxis(1)) ///
	   (tsline three_month, lcolor(purple) c(1) yaxis(2)), ///
	   ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
	   title(Price of Bitcoin and Three Month Treasury Bond Yield, size(medium))
graph export Bitcoinand3month.pdf, replace	 

twoway (tsline EconUncertaintyIndex, lcolor(maroon) lwidth(medthick) lpattern(solid) connect(direct)), ///
		ytitle(Level of Uncertainty) ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) ///
		grid) title(Economic Policy Uncertainty Index, ///
		size(medium)) note("Source: Baker, Scott, Nicholas Bloom and Steven Davis www.policyuncertainty.com")
graph export EconUnIndex.pdf, replace
	
twoway (tsline PriceofGold, lcolor(gold) connect(direct)), ///
		ytitle("Price in $USD") ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
		title(Price of Gold, size(medium)) ///
		note("Source: World Gold Council")
graph export PriceofGold.pdf, replace

twoway (tsline BitcoinPrice, lcolor(blue) c(1) yaxis(1)) ///
	   (tsline PriceofGold, lcolor(gold) c(1) yaxis(2)), ///
	   ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
	   title(Price of Bitcoin and Price of Gold, size(medium))
graph export BitcoinandGold.pdf, replace	   

twoway (tsline adjustedclose, lcolor(green) connect(direct)), ///
		ytitle("DJI") ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
		title(Dow Jones Industrial Average, size(medium)) ///
		note("Source: Chicago Board Options Exchange Database")
graph export DowJones.pdf, replace

twoway (tsline BitcoinPrice, lcolor(blue) c(1) yaxis(1)) ///
	   (tsline adjustedclose, lcolor(green) c(1) yaxis(2)), ///
	   ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
	   title(Price of Bitcoin and Dow Jones Index, size(medium))
graph export BitcoinandDowJones.pdf, replace	

twoway (tsline vixclose, lcolor(lime) connect(direct)), ///
		ytitle("VIX") ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
		title(Volatility Index , size(medium)) ///
		note("Source: Yahoo Finanace")
graph export VIX.pdf, replace

twoway (tsline five_year, lcolor(black) connect(direct)), ///
		ytitle("Yield") ttitle(TIme) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
		title(Five Year Treasury Bond Yield, size(medium)) ///
		note("Source: US Treasury Database")
graph export Five_Year.pdf, replace	

twoway (tsline five_year, c(1) yaxis(1)) ///
	   (tsline three_month, c(1) yaxis(2)), ///
	   ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
	   title(Price of Bitcoin and Price of Gold, size(medium))
graph export fiveyearand3month.pdf, replace	

twoway (tsline BitcoinPrice, lcolor(blue) c(1) yaxis(1)) ///
	   (tsline five_year, lcolor(black) c(1) yaxis(2)), ///
	   ttitle(Time) tlabel(#20, labels labsize(small) angle(forty_five) grid) ///
	   title(Price of Bitcoin and Five Year Treasury Bond Yield, size(medium))
graph export Bitcoinand5year.pdf, replace	

sum BitcoinPrice
********************************************************************************
tsset Date
********************************************************************************				  
**************Lag Selection Using Bayesian information criterion****************
eststo clear

eststo: quietly regress BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/1).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/2).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/3).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/4).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/5).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/1).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/2).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/3).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/5).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

  esttab using BICSelectioin.rtf, replace r2 ar2 se scalar(BIC_lag F rmse) star(* 0.10 ** 0.05 *** 0.01)

dfuller BitcoinPrice, regress

********************************************************************************
*******************Dickey-Fuller Tests for Unit Root****************************

*Unit Root*
gen ln_BitcoinPrice = ln(BitcoinPrice)
gen d1_BitcoinPrice = D1.BitcoinPrice
gen d1_ln_BitcoinPrice = D1.ln_BitcoinPrice

dfuller BitcoinPrice, regress lag(5)
dfuller ln_BitcoinPrice
dfuller d1_BitcoinPrice
dfuller d1_ln_BitcoinPrice, regress lag(2)

******* Reject the null hypothesis that the first difference of the      *******
******* variable is unit root. Therefore, stationary                     *******
ac BitcoinPrice
graph export ac1.pdf

ac ln_BitcoinPrice
graph export ac2.pdf

ac d1_ln_BitcoinPrice
graph export ac3.pdf

sum d1_BitcoinPrice
*    Variable |        Obs        Mean    Std. Dev.       Min        Max
*-------------+---------------------------------------------------------
*d1_Bitcoin~e |        717   -.0506416    19.51102    -140.81     126.49

sum d1_ln_BitcoinPrice
*    Variable |        Obs        Mean    Std. Dev.       Min        Max
*-------------+---------------------------------------------------------
*d1_ln_Bitc~e |        717   -.0000685    .0412396  -.2471313   .1975498


dfuller three_month, regress lags(0)
*Non-stationary

dfuller five_year, regress lags(0)
*Non-stationary 

dfuller EconUncertaintyIndex, regress lags(0)
*Stationary

dfuller PriceofGold, regress lags(0)		
*Non-Stationary
		
dfuller vixclose, regress lags(0)
*Stationary

dfuller adjustedclose, regress lags(0)
*Non-Stationary

dfuller BitcoinMined_Change, regress	
*Stationary	

gen d1_three_month = D1.three_month

gen d1_five_year = D1.five_year

gen ln_EconUncertaintyIndex = ln(EconUncertaintyIndex)

gen d1_PriceofGold = D1.PriceofGold
gen ln_PriceofGold = ln(PriceofGold)
gen d1_ln_PriceofGold =D1.ln_PriceofGold

gen ln_vixclose = ln(vixclose)

gen d1_adjustedclose = D1.adjustedclose
gen ln_adjustedclose = ln(adjustedclose)
gen d1_ln_adjustedclose = D1.ln_adjustedclose

gen ln_BitcoinMined_Change = ln(BitcoinMined_Change)


twoway (tsline d1_three_month), ///
ytitle("Yield Change") ttitle(Time) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
title("First Difference of Three Month Treasury Yields")
graph export three_monthDifference.pdf, replace

twoway (tsline d1_PriceofGold), ///
ytitle("Price Change") ttitle(Time) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
title("First-Difference of Price of Gold")
graph export PriceofGoldDifference.pdf, replace


twoway (tsline d1_five_year), ///
ytitle("Yield Change") ttitle(Time) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
title("First Difference of Five Year Treasury Yields")
graph export five_yearDifference.pdf, replace

twoway (tsline d1_adjustedclose), ///
ytitle("Index Change") ttitle(Time) tlabel(#20, labels labsize(Small) angle(forty_five) grid) ///
title("First Difference of Dow Jones")
graph export DowJonesDifference.pdf, replace


order Date date BitcoinPrice d1_BitcoinPrice ln_BitcoinPrice d1_ln_BitcoinPrice three_month d1_three_month ///
   five_year d1_five_year PriceofGold d1_PriceofGold ln_PriceofGold d1_ln_PriceofGold EconUncertaintyIndex ///
   ln_EconUncertaintyIndex BitcoinMined_Change ln_BitcoinMined_Change vixclose ///
   ln_vixclose adjustedclose d1_adjustedclose ln_adjustedclose d1_ln_adjustedclose ten_year

label var date "Date- Daily"
label var BitcoinPrice "Price of Bitcoin (USD)" 
label var d1_BitcoinPrice "First Difference of Bitcoin Price"
label var ln_BitcoinPrice "Log of Bitcoin (USD)"
label var d1_ln_BitcoinPrice "First Difference of Log of Bitcoin (USD)"
label var three_month "Three Month Treasury Yield"
label var d1_three_month "First Difference of Three Month Treasury Yield"
label var five_year "Five Year Treasury Yield"
label var d1_five_year "First Difference of Five Year Treasury Yield"
label var PriceofGold "Price of Gold (USD)"
label var d1_PriceofGold "First Difference of Price of Gold"
label var ln_PriceofGold "Log of Price of Gold (USD)"
label var d1_ln_PriceofGold "First Difference of Log of Price of Gold (USD)"
label var EconUncertaintyIndex "Economic Uncertainty Index"
label var ln_EconUncertaintyIndex "Log of Economic Uncertainty Index"
label var BitcoinMined_Change "Daily Bitcoin Mined"
label var ln_BitcoinMined_Change "Log of Daily Bitcoin Mined"
label var vixclose "Volatility Index Close"
label var ln_vixclose "Log of Volatility Index Close"
label var adjustedclose "Dow Jones Index Close"
label var d1_adjustedclose "First Difference of Dow Jones Index Close"
label var ln_adjustedclose "Log of Dow Jones Index Close"
label var d1_ln_adjustedclose "First Difference of Log of Dow Jones Index Close"

********************************************************************************				  
**************Lag Selection Using Bayesian information criterion****************
eststo clear

eststo: quietly regress BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/1).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/2).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/3).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/4).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress BitcoinPrice L(1/5).BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/1).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/2).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/3).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_BitcoinPrice L(1/5).d1_ln_BitcoinPrice, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

  esttab using BICSelectioin.rtf, replace r2 ar2 se scalar(BIC_lag F rmse) star(* 0.10 ** 0.05 *** 0.01)



eststo clear

eststo: quietly regress d1_ln_PriceofGold, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_PriceofGold L(1/1).d1_ln_PriceofGold, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_PriceofGold L(1/2).d1_ln_PriceofGold, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_PriceofGold L(1/3).d1_ln_PriceofGold, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_PriceofGold L(1/4).d1_ln_PriceofGold, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_ln_PriceofGold L(1/5).d1_ln_PriceofGold, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_five_year, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_five_year L(1/1).d1_five_year, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_five_year L(1/2).d1_five_year, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_five_year L(1/3).d1_five_year, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_five_year L(1/4).d1_five_year, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_five_year L(1/5).d1_five_year, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_three_month, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_three_month L(1/1).d1_three_month, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_three_month L(1/2).d1_three_month, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_three_month L(1/3).d1_three_month, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_three_month L(1/4).d1_three_month, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )

eststo: quietly regress d1_three_month L(1/5).d1_three_month, robust
  estadd scalar BIC_lag = ( ln(e(rss)/e(N)) ) + (e(df_m) + 1) * ( ln(e(N))/e(N) )
  
  esttab using BICSelectioin2.rtf, replace r2 ar2 se scalar(BIC_lag F rmse) star(* 0.10 ** 0.05 *** 0.01)


*OLS regressions
eststo clear
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year d1_three_month, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year d1_three_month L(1/5).d1_ln_PriceofGold
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose ln_BitcoinMined_Change, r
	eststo: quietly regress d1_BitcoinPrice L(1/4).d1_five_year d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose ln_BitcoinMined_Change, r
	esttab  using BitcoinRegress.rtf, ///
          r2 ar2 se scalar(F rmse) ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          replace ///
          label ///
          depvars ///
          varwidth(30) ///
          title("Table 5. Side by Side table of regression results") ///
          nonotes ///
          addnote("Note 1:  Robust standard errors are displayed in parenthesis." ///
                  "Significance levels:  * p<0.10; ** p<0.05; *** p<0.01")
				  
eststo clear
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose, r
	eststo: quietly regress d1_ln_BitcoinPrice L(1/4).d1_five_year L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose ln_BitcoinMined_Change, r
	eststo: quietly regress d1_BitcoinPrice L(1/4).d1_five_year L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose ln_BitcoinMined_Change, r
	esttab  using BitcoinRegress2.rtf, ///
          r2 ar2 se scalar(F rmse) ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          replace ///
          label ///
          depvars ///
          varwidth(30) ///
          title("Table 6. Side by Side table of regression results without Three-Month") ///
          nonotes ///
          addnote("Note 1:  Robust standard errors are displayed in parenthesis." ///
                  "Significance levels:  * p<0.10; ** p<0.05; *** p<0.01")
				  
eststo clear
	eststo: quietly regress d1_ln_BitcoinPrice d1_three_month, r
	eststo: quietly regress d1_ln_BitcoinPrice d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex, r
	eststo: quietly regress d1_ln_BitcoinPrice d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose, r
	eststo: quietly regress d1_ln_BitcoinPrice d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose, r
	eststo: quietly regress d1_ln_BitcoinPrice d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose ln_BitcoinMined_Change, r
	eststo: quietly regress d1_BitcoinPrice d1_three_month L(1/5).d1_ln_PriceofGold ln_EconUncertaintyIndex d1_ln_adjustedclose ln_vixclose ln_BitcoinMined_Change, r
	esttab  using BitcoinRegress3.rtf, ///
          r2 ar2 se scalar(F rmse) ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          replace ///
          label ///
          depvars ///
          varwidth(30) ///
          title("Table 7. Side by Side table of regression results without Five-Year") ///
          nonotes ///
          addnote("Note 1:  Robust standard errors are displayed in parenthesis." ///
                  "Significance levels:  * p<0.10; ** p<0.05; *** p<0.01")
				  				  
****************************************FIN*************************************				  
