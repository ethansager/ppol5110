*Preparation on 2020 Transfers for merging
*Programmer: Uendjii

cd "C:\Users\eman7\Dropbox\ppol5110"

clear
import excel "raw_data/ACTUAL TRANSFERS 2020.xlsx", sheet("Actual Transfers By SECTORS") cellrange(A2:L34) firstrow clear


rename D SecondaryHealth
rename F Library
drop if _n == 1
rename ADMINISTRATION Administration
destring Administration, replace
destring Health, replace
destring SecondaryHealth, replace
destring BasicEducation, replace
destring Library, replace
gen Year =2020

rename *, lower

* Drop the variable labels 
foreach var of varlist _all {
    label var `var' ""
}

* cleaning 
drop grandtotal
drop if council == "Note 1: Unconditional Block Grant included the following in 2018-2020; Local council Administration, Solid waste Management, Youths, Sports & Fire Services"
drop if council == "NATIONAL TOTAL"
drop if administration == 0 

save "analysis/00_dta/2020 Transfers.dta", replace


