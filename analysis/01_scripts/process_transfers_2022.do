* Process TRANSFERS Excel files and clean 2022 data

clear all

set more off

* Change to project directory (adjust path as needed)
cd "/home/ethan/school/ppol5110"

* Import Excel file, skipping first row
import excel "raw_data/ACTUAL TRANSFERS 2022.xlsx", cellrange(A2:R27) firstrow clear

rename *, lower

* Drop NATIONAL TOTAL rows
drop if council == "national total"

* Create row total (assuming specific column range)
* Note: Adjust variable names based on your actual column names
egen row_total = rowtotal(support_to_ward_committees-unconditional_block_grant), missing
replace row_total = round(row_total, 0.001)

* Check if row totals match grand total
gen total_check = (abs(row_total - round(grand_total, 0.001)) < 0.001)
tab total_check

* Drop unnecessary variables
drop total_check grand_total row_total

* Add year variable
gen year = 2022

* Display summary
describe
summarize

* Save processed data
save "analysis/00_dta/transfers_2022_processed.dta", replace

* Display first few observations
list in 1/10