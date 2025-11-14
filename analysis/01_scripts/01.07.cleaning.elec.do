********************************************************************************
* MERGE 2018 ELECTION DATA
********************************************************************************

**# Run 00.set.globals.do
clear

capture do "00.set.globals.do"
import delimited "$raw_data/district_votes_2012_2018.csv"

rename districtname district
keep if year == 2018

foreach var in npd i pdp adp c4c ngc nurp renip up{
	replace `var' = "." if `var' == "NA"
	destring `var', replace
}

save "$raw_data/district_votes_2012_2018.dta", replace 

