* Process TRANSFERS Excel files and clean 2022 data

clear all

* Change to project directory (adjust path as needed)
capture do "00.set.globals.do"
cd $proj

* Import Excel file, skipping first row
import excel "$raw_data/ACTUAL TRANSFERS 2022.xlsx", cellrange(A2:R27) firstrow clear

* Set everything to numeric 
rename *, lower
replace council = itrim(council)

capture confirm variable council
if _rc {
    di as error "Variable 'council' not found — check column name."
    exit 198
}

ds council, not
local vars_to_destring `r(varlist)'

destring `vars_to_destring', replace ignore(",% ") force

* rename that variables 
capture rename health                   	   primary_health
capture rename basiceducation                  basic_education
capture rename e                  			   phc_cash_to_facils
capture rename ruralwater                      rural_water_services
capture rename genderchildrensaffairs          gender_childrens_affairs
capture rename socialwelfare          		   social_welfare
capture rename marineservices                  marine_services
capture rename youthaffairs                    youth_affairs
capture rename sportservices                   sports_services
capture rename fireservices                    fire_services
capture rename unconditionalblockgrant         unconditional_block_grant_admin
capture rename grandtotal                      grand_total
capture rename g                               library
capture rename d 							   secondary_health

* Drop NATIONAL TOTAL rows
drop if council == "national total"
drop if council == ""
drop if administration == .

* Create row total (assuming specific column range)
* Note: Adjust variable names based on your actual column names
egen row_total = rowtotal(administration-unconditional_block_grant_admin), missing
replace row_total = round(row_total, 0.001)

* Check if row totals match grand total
gen total_check = (abs(row_total - round(grand_total, 0.001)) < 0.001)
tab total_check

* Drop unnecessary variables
drop total_check row_total

* Add year variable
gen year = 2022

* Display summary
describe
summarize

* Save processed data
save "$dta/transfers_2022_processed.dta", replace
