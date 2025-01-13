capture log close

log using log_2019_original_incarc_var.log, replace

clear all

use ../../data/cleaned/structural_racism_2019_original_incarceration_var.dta

browse state no_college_RR unemployment_RR median_income_ratio renters_RR incarceration_RR

// Create general structural equation model with 5 variables, SPECIFYING 2 LATENT CLASSES
gsem(no_college_RR unemployment_RR median_income_ratio renters_RR incarceration_RR <- _cons) ///
, lclass(C 2) startvalues(randomid, draws(5) seed(12345))

estat lcmean

estat lcprob

estat ic

predict classpost*, classposteriorpr

egen max = rowmax(classpost*)

generate two_class = 1 if classpost1==max 

replace two_class = 2 if classpost2==max 

tab two_class

browse state two_class

// Create general structural equation model with 5 variables, SPECIFYING 3 LATENT CLASSES
matrix b=e(b)

gsem(no_college_RR unemployment_RR median_income_ratio renters_RR incarceration_RR <- _cons) ///
 , lclass(C 3) from(b)
 
estat lcmean

estat lcprob

estat ic

predict cpost*, classposteriorpr

egen cmax = rowmax(cpost*)

generate three_class = 1 if cpost1==cmax 

replace three_class = 2 if cpost2==cmax 

replace three_class = 3 if cpost3==cmax

tab three_class

browse state three_class


// Create general structural equation model with 5 variables, SPECIFYING 4 LATENT CLASSES
matrix b=e(b)

gsem(no_college_RR unemployment_RR median_income_ratio renters_RR incarceration_RR <- _cons) ///
 , lclass(C 4)  from(b)
 
estat lcmean

estat lcprob

estat ic

predict fourclasspost*, classposteriorpr
egen classmax = rowmax(fourclasspost*)
generate four_class = 1 if fourclasspost1==classmax 
replace four_class = 2 if fourclasspost2==classmax 
replace four_class = 3 if fourclasspost3==classmax
replace four_class = 4 if fourclasspost4==classmax
tab four_class

browse state four_class

// Create general structural equation model with 5 variables, SPECIFYING 5 LATENT CLASSES
matrix b=e(b)

gsem(no_college_RR unemployment_RR median_income_ratio renters_RR incarceration_RR <- _cons) ///
 , lclass(C 5) from(b)
estat lcmean

estat lcprob

estat ic

predict fiveclasspost*, classposteriorpr
egen classesmax = rowmax(fiveclasspost*)
generate five_class = 1 if fiveclasspost1==classesmax 
replace five_class = 2 if fiveclasspost2==classesmax 
replace five_class = 3 if fiveclasspost3==classesmax
replace five_class = 4 if fiveclasspost4==classesmax
replace five_class = 5 if fiveclasspost5==classesmax
tab five_class

browse state five_class

browse state two_class three_class four_class five_class

save lpa_classes_original_incarceration_var.dta, replace

log close
