********************************************************************************
* APPEND ALL TRANSFER YEARS
********************************************************************************

**# Run 00.set.globals.do
clear

capture do "00.set.globals.do"


**# Check that all scripts are ran for updates
local start_year = 2019

* The below loop checks that each cleaning script is ran 
* and works before merging
forvalues i = 1/6 {
    local yr  = `start_year' + `i' - 1
    local idx : display %02.0f `i'  

    di as txt "------------------------------------------------------------"
    di as txt "Running $dofiles/01.`idx'.cleaning.`yr'.do ..."
    capture noisily run "$dofiles/01.`idx'.cleaning.`yr'.do"

    if (_rc) {
        di as error "ERROR: 01.`idx'.cleaning.`yr'.do failed (return code `_rc')."
        di as error "Stopping execution of master do-file."
        exit _rc
    }
    else {
        di as result "Completed: 01.`idx'.cleaning.`yr'.do"
    }
}


********************************************************************************
* APPEND FIRST 2019 WITH 2020 (2019 IS THE BASE YEAR)
********************************************************************************

use "$dta/2019_Transfers.dta", clear
tempfile table19_20
save `table19_20', replace emptyok
append using "$dta/2020 Transfers.dta"
replace swgca = gender_childrens_affairs if year == 2019
replace gender_childrens_affairs = . if year == 2019
replace primary_health = health if year == 2020
drop health
replace unconditionalblockgrantgena = unconditional_grant if year == 2020
drop unconditional_grant
drop gender_childrens_affairs
save `table19_20', replace

********************************************************************************
* APPEND BASE WITH 2021
********************************************************************************

tempfile table19_21
save `table19_21', replace emptyok
append using "$dta/2021_Transfers.dta"
replace swgca = gender_childrens_affairs + socialwelfare if year == 2021
replace gender_childrens_affairs = . if year == 2021
replace socialwelfare = . if year == 2021
replace primary_health = health if year == 2021
drop health
replace unconditionalblockgrantgena = unconditional_block_grant_admin if year == 2021
drop unconditional_block_grant_admin 
drop gender_childrens_affairs
drop socialwelfare
save `table19_21', replace

********************************************************************************
* APPEND BASE WITH 2022
********************************************************************************
tempfile table19_22
save `table19_22', replace emptyok
append using "$dta/transfers_2022_processed.dta"
replace swgca = social_welfare if year == 2022
replace social_welfare = . if year == 2022
replace sportsservices = sports_services if year == 2022
drop sports_services
rename sportsservices sports_services
replace unconditionalblockgrantgena = unconditional_block_grant_admin if year == 2022
drop unconditional_block_grant_admin
rename unconditionalblockgrantgena unconditional_block_grant_admin
drop genderandchildrensaffairs
drop social_welfare
save `table19_22', replace

********************************************************************************
* APPEND ALL TRANSFER YEARS
********************************************************************************
tempfile table19_23
save `table19_23', replace emptyok
append using "$dta/transfer_2023_processed.dta"
replace swgca = soc_welfare + gender if year == 2023
replace gender = . if year == 2023
drop gender
replace sports_services = sports if year == 2023
drop sports
rename sports_services sports
replace basic_education = education if year == 2023
drop education
replace rural_water_services = rural_water if year == 2023
drop rural_water
rename rural_water_services rural_water
drop soc_welfare
replace youth_affairs = youths
drop youths
rename youth_affairs youths
replace fire_services = fire if year == 2023
drop fire
rename fire_services fire
replace marine_services = marine_resources if year == 2023
drop marine_resources
rename marine_services marine_resources
replace unconditional_block_grant_admin = unconditional_block_grant if year == 2023
drop unconditional_block_grant
rename unconditional_block_grant_admin unconditional_block_grant
replace phc_cash_to_facils = primary_health_cash_to_phu_facil if year == 2023
drop primary_health_cash_to_phu_facil
rename phc_cash_to_facils primary_health_cash_to_phu_facil
replace grand_total = council_total if year == 2023
drop council_total
save `table19_23', replace
********************************************************************************
* APPEND ALL TRANSFER YEARS
********************************************************************************

tempfile table19_24
save `table19_24', replace emptyok
append using "$dta/transfer_2024_processed.dta"
replace grand_total = council_total if year == 2024
drop council_total
replace youths = youth if year == 2024
replace swgca = gender + social_welfare if year == 2024
drop gender
drop social_welfare
replace unconditional_block_grant = unconditional_block_grant_2024 if year == 2024
drop unconditional_block_grant_2024
replace support_toward_committees = support_to_dc if year == 2024
drop support_to_dc
rename support_toward_committees support_to_dc
drop youth
order year, a(education) 
save `table19_24', replace

********************************************************************************
* MERGE 2018 ELECTION DATA
********************************************************************************
use "$dta/transfers_merged1924.dta", clear
capture drop _merge
save "$dta/transfers_merged1924.dta", replace

use "$dta/2018_Elections.dta", clear
capture drop _merge
save "$dta/2018_Elections.dta", replace

merge 1:m council using "$dta/transfers_merged1924.dta"
sort year council

********************************************************************************
* MERGE 2018 ELECTION DATA
********************************************************************************
/*use "$dta/transfers_merged1924.dta", clear
capture drop _merge
save "$dta/transfers_merged1924.dta", replace

use "$dta/2018_Elections.dta", clear
capture drop _merge
save "$dta/2018_Elections.dta", replace

merge 1:m council using "$dta/transfers_merged1924.dta"
sort year council*/

********************************************************************************
* CLEAN THE NAMING CONVENTIONS OF LC'S
********************************************************************************
replace council = strtrim(council)
replace council = "Falaba District" if council == "Falaba District Council"
replace council = "Karene District" if council == "Karene District Council"
replace council = "Koidu New Sembehun" if council == "Koidu/New Sembehun City"
replace council = "Port Loko City" if council == "Port Loko City Council"

********************************************************************************
* CLEAN COLLASPING OF CATEGORIES FOR GRANTS
********************************************************************************
* This should fix the missing cases for 2024 
replace basic_education = education if basic_education == . 
drop education 
* This should fix 2023 and 2024 missing cases 
replace administration = support_to_dc if administration == . 
drop support_to_dc
* Collaspe the primary health cash into primary health 
replace primary_health = primary_health + primary_health_cash_to_phu_facil ///
	if primary_health_cash_to_phu_facil != . 
drop primary_health_cash_to_phu_facil
* save temp file before pulling in currency 
tempfile clean_raw_currency
save `clean_raw_currency', replace emptyok

********************************************************************************
* ADJUST VALUES TO 2015 INTERNATIONAL DOLLARS
********************************************************************************

* Pull WDI series for Sierra Leone (ISO3 = SLE)
* Indicators:
*   NY.GDP.DEFL.ZS = GDP deflator (2018=100)
*   PA.NUS.PPP     = PPP conversion factor (LCU per Intl $)
*   PA.NUS.FCRF    = Official exch. rate (LCU per USD)

* Install if not yet installed
ssc install wbopendata, replace

* Pull relevant indicators for Sierra Leone (SL)
wbopendata, country(SLE) ///
	indicator(ny.gdp.defl.zs; pa.nus.ppp; pa.nus.fcrf) long clear


local base_year = 2018
summ ny_gdp_defl_zs if year==`base_year', meanonly
assert r(N)==1
scalar base_defl = r(mean)

keep if year > 2018 

rename countrycode iso3
rename countryname country
rename ny_gdp_defl_zs deflator
rename pa_nus_ppp ppp
keep year country deflator ppp 
gen double deflator_index = deflator / base_defl
label var deflator_index "GDP deflator index (base=2018)"

save "$dta/wb_sierra_leone.dta", replace

merge 1:m year using `clean_raw_currency'

* Now take adjustment factors 
ds year, not
local vars `r(varlist)'

foreach v of local vars {
    * Skip string variables just in case
    capture confirm numeric variable `v'
    if !_rc {
        gen double `v'_real = `v' / deflator_index
        label var `v'_real "`: var label `v'' (constant `base_year' SLL)"

        gen double `v'_intl = `v'_real / ppp
        label var `v'_intl "`: var label `v'' (constant `base_year', PPP Intl $)"
    }
}

* This is going to be helpful for reg etc. 
encode council, gen(council_id)

* Clean up the junk we don't need 
keep council council_id year *_real *_intl
drop deflator* ppp* _merge*

* Sort for eye test 
sort council year 

* Set order in columns for ease of use 
order council council_id year grand_total_real grand_total_intl
********************************************************************************
* EYE TEST THE TRANSFER CHANGES 
********************************************************************************
line grand_total_intl year, ///
    by(council, title(" Grand Total (2018 PPP INT$) by Council") ///
        note("Values in constant 2018 PPP INT$") ///
        graphregion(color(white)) ///
        yrescale xrescale) ///
    ytitle("") xtitle("Year") ///
    lwidth(medthick)


********************************************************************************
* APPEND ALL TRANSFER YEARS
********************************************************************************
save "$dta/transfers_merged1924", replace 


