********************************************************************************
* APPEND ALL TRANSFER YEARS
********************************************************************************

**# Run 00.set.globals.do
clear

capture do "00.set.globals.do"

cd $dofiles

do "01.01.cleaning.2019.do"



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
