*=====================================================================================
//TITLE: SIERRA LEONE DO FILE
//AUTHOR: GEORGETOWN TEAM
//DATASETS USED: 
//DATE CREATED: OCTOBER 13, 2025
//DATE LAST UPDATED: OCTOBER 13, 2025
*=====================================================================================
clear
if "`c(username)'"=="danielanagar" {
    gl wb_data "/Users/danielanagar/Desktop/Capstone/WB_data"
	gl excel_2023 "$wb_data/ACTUAL TRANSFERS 2023.xls"
	gl excel_2024 "$wb_data/ACTUAL TRANSFERS 2024.xlsx"
}

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
 
**# 2024
//Tranches 1 and 2 combined into Tranche 3 in Excel
clear

import excel "$excel_2024", sheet("TRANCHE 3") cellrange(A2:R25) firstrow clear

generate year = 2024
replace COUNCIL = trim(COUNCIL)

foreach var of varlist * {
        local newname = "`var'"
		local newname = lower("`newname'")
		if "`newname'" != "`var'" rename `var' `newname' 
        }
		
rename secondaryhealth secondary_health
rename primaryhealth primary_health
rename primaryhealthcashtophufacil primary_health_cash_to_phu_facil
rename ruralwater rural_water
rename socialwelfare social_welfare
rename marineresources marine_resources
rename unconditionalblockgrant2024 unconditional_block_grant_2024
rename supporttoddcc support_to_dc
rename counciltotal council_total

drop if _n==23

