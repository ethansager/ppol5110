*
cd "C:\Users\eman7\Dropbox\ppol5110"

clear
import excel "raw_data/ACTUAL TRANSFERS 2019.xlsx", sheet("Actual Transfers By SECTORS") cellrange(A2:L35) firstrow

rename D SecondaryHealth
rename F Library
drop if _n == 1
destring Administration, replace
destring Health, replace
destring SecondaryHealth, replace
destring BasicEducation, replace
destring Library, replace
gen Year =2019

rename *, lower

* Drop the variable labels 
foreach var of varlist _all {
    label var `var' ""
}

****************************************************
****************************************************
capture rename health                          primary_health
capture rename secondaryhealth                 secondary_health
capture rename basiceducation                  basic_education
capture rename ruralwaterservices              rural_water_services
capture rename swgca				           gender_childrens_affairs
capture rename marineservices                  marine_services
capture rename unconditionalblockgrantadmin    unconditional_block_grant_admin
capture rename grandtotal                      grand_total

drop if council == "Note 1: Unconditional Block Grant included the following in 2018-2020; Local council Administration, Solid waste Management, Youths, Sports & Fire Services"
drop if council == "NATIONAL TOTAL"
drop if administration == 0 


save "analysis/00_dta/2019_Transfers.dta", replace



