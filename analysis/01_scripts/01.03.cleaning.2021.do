****************************************************
* CLEAN TRANSFERS DATASET (2021)
* Author: Martin Hernan Barros
* Purpose: Import Excel; destring all except council;
*          standardize variable names with underscores;
*          drop hospital rows; add year column (2021).
****************************************************


****************************************************
** Define folder paths
****************************************************
capture do "00.set.globals.do"
cd $proj
global RAWXLSX "$raw_data/ACTUAL TRANSFERS 2021.xlsx"

****************************************************
** Step 2: Import Excel file
** - Imports the Excel dataset
** - Uses first row as variable names
** - Converts variable names to lowercase
** - Clears old data before loading new one
****************************************************
import excel using "$RAWXLSX", cellrange(A2:Q31) firstrow case(lower) clear

****************************************************
** Step 3: Destring all variables except 'council'
** - Checks if 'council' exists
** - Creates a list of all other variables
** - Converts them to numeric, ignoring commas/symbols
****************************************************
capture confirm variable council
if _rc {
    di as error "Variable 'council' not found — check column name."
    exit 198
}

ds council, not
local vars_to_destring `r(varlist)'

destring `vars_to_destring', replace ignore(",% ") force

**checks that the variable council exists, then converts every other variable
** in the dataset from text to numeric while leaving council as a string.

****************************************************
** Step 4: Standardize variable names
** - Renames columns to snake_case
****************************************************
capture rename primaryhealth                   primary_health
capture rename secondaryhealth                 secondary_health
capture rename basiceducation                  basic_education
capture rename ruralwaterservices              rural_water_services
capture rename genderchildrensaffairs          gender_childrens_affairs
capture rename marineservices                  marine_services
capture rename youthaffairs                    youth_affairs
capture rename sportservices                   sports_services
capture rename fireservices                    fire_services
capture rename unconditionalblockgrantadmin    unconditional_block_grant_admin
capture rename grandtotal                      grand_total
capture rename f                               library
capture rename d secondary_health

****************************************************
** Step 5: Drop hospital related observations
****************************************************
replace council = strtrim(council)
drop if lower(council) == "sec. hospitals"
drop if strpos(lower(council), "hospital")
drop if council == "NATIONAL TOTAL"
drop if administration == .
**cleans up extra spaces in the council names,  drops the row labeled 
**"Sec. Hospitals" and any other row where the council name contains the word "hospital."

****************************************************
** Step 6: Add year variable (2021)
** - Creates a constant 'year' column with value 2021
** - Moves it to the end of the dataset
****************************************************
gen year = 2021
order year, last


save "$dta/2021_Transfers.dta", replace


