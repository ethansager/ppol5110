*=====================================================================================
//TITLE: SIERRA LEONE DO FILE 2024
//AUTHOR: GEORGETOWN TEAM
//DATASETS USED: 
//DATE CREATED: OCTOBER 13, 2025
//DATE LAST UPDATED: OCTOBER 13, 2025
*=====================================================================================

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
replace council = "Freetown City" if council == "Freetown"

drop if _n==23

save "$dta/transfer_2024_processed.dta", replace 
 