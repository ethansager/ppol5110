********************************************************************************
* SET FILE PATHS
********************************************************************************

* Local path definitions - Create globals for the root folder and all project folders
if c(username) == "danielanagar" {
	global root "/Users/danielanagar/Desktop/Capstone/ppol5110"
} 
else if c(username) == "martinhernanbarros" {
    global root "/Users/martinhernanbarros/Desktop/Capstone/ppol5110"
}
else if c(username) == "uendjiundjablack" {
    global root "/Users/uendjiundjablack/Desktop/Capstone/ppol5110"
} 
else if c(username) == "eman7" {
    global root "C:\Users\eman7\Dropbox\ppol5110"
}
else if c(username) == "eman" {
    global root "/mnt/c/Users/eman7/Dropbox/ppol5110/analysis"
}
else {
    display as error "ERROR: User not recognized. Please set the root path manually."
}

* Establish paths for inputs and outputs
global raw_data "$root/raw_data"
global dta "$root/analysis/00_dta"
global output "$root/analysis/02_output"
global docs "$root/analysis/02_docs"
global dofiles "$root/analysis/01_scripts"