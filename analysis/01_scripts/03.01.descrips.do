********************************************************************************
* APPEND ALL TRANSFER YEARS
********************************************************************************

**# Run 00.set.globals.do
clear

capture do "00.set.globals.do"

use "$dta/transfers_merged1924", replace 


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


