*=====================================================================================
//TITLE: SIERRA LEONE DO FILE 2023
//AUTHOR: GEORGETOWN TEAM
//DATASETS USED: 
//DATE CREATED: OCTOBER 13, 2025
//DATE LAST UPDATED: OCTOBER 13, 2025
*=====================================================================================
clear

capture do "00.set.globals.do"
cd $proj

gl excel_2023 "$raw_data/ACTUAL TRANSFERS 2023.xls" 

**# 2023
clear
import excel "$excel_2023", sheet("Q1 2023") cellrange(A2:R31) firstrow clear

generate year = 2023

drop if _n>=8 & _n<=13 | _n==29
replace COUNCIL = trim(COUNCIL)

foreach var of varlist COUNCIL Education2023 Library2023 Agriculture2023 Environment2023 PrimaryHealth2023 SecondaryHealth2023 PrimaryHealthCashtoPHUFacil RuralWater2023 SocWelfare2023 Youths2023 Sports2023 Gender2023 Fire2023 MarineResources2023 UnconditionalBlockGrant2023 SupporttoWardCommitees2023 CouncilTotal year {
        local newname = "`var'"
		local newname = lower("`newname'")
		if "`newname'" != "`var'" rename `var' `newname' 
        }

 rename education2023 education
 rename library2023 library
 rename agriculture2023 agriculture
 rename environment2023 environment
 rename primaryhealth2023 primary_health
 rename secondaryhealth2023 secondary_health
 rename primaryhealthcashtophufacil primary_health_cash_to_phu_facil
 rename ruralwater2023 rural_water
 rename socwelfare2023 soc_welfare
 rename youths2023 youths
 rename sports2023 sports
 rename gender2023 gender
 rename fire2023 fire
 rename marineresources2023 marine_resources
 rename unconditionalblockgrant2023 unconditional_block_grant
 rename supporttowardcommitees2023 support_toward_committees
 rename counciltotal council_total
 replace council = "Freetown City" if council == "Freetown"
 
 save "$dta/transfer_2023_processed.dta", replace 

import excel "$excel_2023", sheet("Q2 20023") cellrange(A2:Q28) firstrow clear

tempfile q2 
drop if (_n>=8 & _n<=10) | (_n == 26)
gen year = 2029

foreach var of varlist COUNCIL Education2023 Library2023 Agriculture2023 Environment2023 PrimaryHealth2023 SecondaryHealth2023 PrimaryHealthCashtoPHUFacil RuralWater2023 SocWelfare2023 Youths2023 Sports2023 Gender2023 Fire2023 MarineResources2023 UnconditionalBlockGrant2023 CouncilTotal year {
        local newname = "`var'"
		local newname = lower("`newname'")
		if "`newname'" != "`var'" rename `var' `newname' 
        }
		
rename education2023 education
 rename library2023 library
 rename agriculture2023 agriculture
 rename environment2023 environment
 rename primaryhealth2023 primary_health
 rename secondaryhealth2023 secondary_health
 rename primaryhealthcashtophufacil primary_health_cash_to_phu_facil
 rename ruralwater2023 rural_water
 rename socwelfare2023 soc_welfare
 rename youths2023 youths
 rename sports2023 sports
 rename gender2023 gender
 rename fire2023 fire
 rename marineresources2023 marine_resources
 rename unconditionalblockgrant2023 unconditional_block_grant
 rename counciltotal council_total 
 replace council = "Freetown City" if council == "Freetown"

 save `q2', replace emptyok 
 
append using $dta/transfer_2023_processed.dta

collapse (sum) education primary_health library agriculture environment ///
         secondary_health primary_health_cash_to_phu_facil rural_water ///
         soc_welfare youths sports gender fire marine_resources ///
         unconditional_block_grant support_toward_committees council_total, ///
         by(council)

gen year = 2023
save $dta/transfer_2023_processed.dta, replace 

import excel "$excel_2023", sheet("Q3 2023") cellrange(A2:Q28) firstrow clear

tempfile q3
drop if (_n>=8 & _n<=10) | (_n == 26)
gen year = 2029

foreach var of varlist COUNCIL Education2023 Library2023 Agriculture2023 Environment2023 PrimaryHealth2023 SecondaryHealth2023 PrimaryHealthCashtoPHUFacil RuralWater2023 SocWelfare2023 Youths2023 Sports2023 Gender2023 Fire2023 MarineResources2023 UnconditionalBlockGrant2023 CouncilTotal year {
        local newname = "`var'"
		local newname = lower("`newname'")
		if "`newname'" != "`var'" rename `var' `newname' 
        }

rename education2023 education
 rename library2023 library
 rename agriculture2023 agriculture
 rename environment2023 environment
 rename primaryhealth2023 primary_health
 rename secondaryhealth2023 secondary_health
 rename primaryhealthcashtophufacil primary_health_cash_to_phu_facil
 rename ruralwater2023 rural_water
 rename socwelfare2023 soc_welfare
 rename youths2023 youths
 rename sports2023 sports
 rename gender2023 gender
 rename fire2023 fire
 rename marineresources2023 marine_resources
 rename unconditionalblockgrant2023 unconditional_block_grant
 rename counciltotal council_total 
 replace council = "Freetown City" if council == "Freetown"

  save `q3', replace emptyok
  
append using $dta/transfer_2023_processed.dta

collapse (sum) education primary_health library agriculture environment ///
         secondary_health primary_health_cash_to_phu_facil rural_water ///
         soc_welfare youths sports gender fire marine_resources ///
         unconditional_block_grant support_toward_committees council_total, ///
         by(council)

gen year = 2023
