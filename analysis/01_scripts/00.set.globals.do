********************************************************************************
* SET FILE PATHS
********************************************************************************

* Local path definitions - Create globals for the root folder and all project folders
if c(username) == "danielanagar" {
	global proj "/Users/danielanagar/Desktop/Capstone/ppol5110"
} 
else if c(username) == "martinhernanbarros" {
    global proj "/Users/martinhernanbarros/Desktop/Capstone/ppol5110"
}
else if c(username) == "uendjiundjablack" {
    global proj "/Users/uendjiundjablack/Desktop/Capstone/ppol5110"
} 
else if c(username) == "eman7" {
    global proj "C:\Users\eman7\Dropbox\ppol5110"
}
else if c(username) == "eman" {
    global proj "/mnt/c/Users/eman7/Dropbox/ppol5110/analysis"
}
else {
    display as error "ERROR: User not recognized. Please set the root path manually."
}

* Establish paths for inputs and outputs
global raw_data "$proj/raw_data"
global dta "$proj/analysis/00_dta"
global output "$proj/analysis/02_output"
global docs "$proj/analysis/02_docs"
global dofiles "$proj/analysis/01_scripts"
