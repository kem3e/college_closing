

/****

Quick code for HE institution closures
Author: Katharine Meyer (katharine_meyer@brown.edu)

***/

*Set file path on your computer
global project "C:\Users\kmeyer6\Box Sync\Misc\IPEDS closing" 
global raw "${project}/IPEDS data" 
global clean "${project}/Stata data" 


*Download IPEDS directories from here: https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx?goToReportId=7


*Import & pare down to select vars; adjust as you need
	*Different years stored as different file names
	
	*Late 90s		
		import delimited "${raw}\ic98hdac_data_stata.csv", clear
			keep unitid instnm addr city stabbr zip fips sector hbcu closedat
			foreach var in unitid instnm addr city stabbr zip fips sector hbcu closedat {
				tostring `var', replace
			}
			rename closedat closedat`year'
		save "${clean}\small1998_directory.dta", replace	
	
		import delimited "${raw}\ic99_hd_data_stata.csv", clear
			keep unitid instnm addr city stabbr zip fips sector hbcu closedat
			foreach var in unitid instnm addr city stabbr zip fips sector hbcu closedat {
				tostring `var', replace
			}
			rename closedat closedat`year'
		save "${clean}\small1999_directory.dta", replace
		
	*Early 00s
	foreach year of numlist 2000/2001 {
		import delimited "${raw}\fa`year'hd_data_stata.csv", clear
			keep unitid instnm addr city stabbr zip fips sector hbcu closedat
			foreach var in unitid instnm addr city stabbr zip fips sector hbcu closedat {
				tostring `var', replace
			}
			rename closedat closedat`year'
		save "${clean}\small`year'_directory.dta", replace
	}

	*Mid-late 00s/10s
	foreach year of numlist 2002/2019 {
		import delimited "${raw}\hd`year'_data_stata.csv", clear
			keep unitid instnm addr city stabbr zip fips sector hbcu closedat
			foreach var in unitid instnm addr city stabbr zip fips sector hbcu closedat {
				tostring `var', replace
			}
			rename closedat closedat`year'
		save "${clean}\small`year'_directory.dta", replace
	}


*Is in following year? - Merge & find out
use "${clean}/small1998_directory.dta", clear
	foreach year of numlist 1999/2019 {
		merge 1:1 unitid using "${clean}/small`year'_directory.dta", gen(_m`year')
	}
save "${clean}/ipeds_college_entryexit_recent.dta", replace