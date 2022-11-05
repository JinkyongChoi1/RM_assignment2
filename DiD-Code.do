* Load the data: 
cd "/Users/jc5901/Documents/GitHub/RM_assignment2"
insheet using vaping-ban-panel.csv, clear

* label variables 
label variable vapingban "Vaping Ban"
label variable lunghospitalizations "Lung Hospitalizations"

* regression to evaluate the "parallel trends" requirement of a difference-in-difference ("DnD") estimate. 
drop if (year > 2021)
reg lunghospitalizations i.year##i.vapingban i.stateid 
eststo regression_parallel
* Output your results into a publication-quality table. 
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_parallel using Reg-Table-parallel.rtf, replace 

* Run a regression to estimate the treatment effect of the laws. 
insheet using vaping-ban-panel.csv, clear 

* first method 
didregress (lunghospitalizations) (vapingban), group(stateid) time(year)

* Create the canonical DnD line graph. 
estat trendplot
graph export mygraph.pdf, replace 

* Output your from regressions #1 and #4 into a publication-quality table. 

* Store regression
eststo regression_fe 
* Output your results into a publication-quality table. 
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_fe using Reg-Table-DnD.rtf, replace 

* second method 
reg lunghospitalizations i.year##vapingban i.stateid  
* Store regression
eststo regression_two
* Output your results into a publication-quality table. 
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_two using Reg-Table-DnD2.rtf, replace 

testparm i.stateid
