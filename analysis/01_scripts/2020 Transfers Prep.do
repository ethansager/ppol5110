*Preparation on 2020 Transfers for merging
*Programmer: Uendjii
cd "/Users/danielanagar/Desktop/Capstone/ppol5110/"
*cd "C:\Users\eman7\Dropbox\ppol5110"

clear
import excel "raw_data/ACTUAL TRANSFERS 2020.xlsx", sheet("Actual Transfers By SECTORS") cellrange(A2:L34) firstrow clear


drop if _n == 1
rename ADMINISTRATION Administration
gen year =2020

rename D secondary_health
rename F library
rename Council council
rename Health health
rename BasicEducation basic_education
rename Agriculture agriculture
rename RuralWaterServices rural_water_services
*SWGCA acronym, leaving as is
rename MarineServices marine_services 
rename UnconditionalGrant unconditional_grant
rename GRANDTOTAL grand_total

destring Administration, replace
destring health, replace
destring secondary_health, replace
destring basic_education, replace
destring library, replace

rename *, lower

* Drop the variable labels 
foreach var of varlist _all {
    label var `var' ""
}

* cleaning 
drop grand_total
drop if council == "Note 1: Unconditional Block Grant included the following in 2018-2020; Local council Administration, Solid waste Management, Youths, Sports & Fire Services"
drop if council == " NATIONAL TOTAL"
drop if administration == 0 | administration == .

save "analysis/00_dta/2020 Transfers.dta", replace


