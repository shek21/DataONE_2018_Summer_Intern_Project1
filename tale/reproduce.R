# patch and reproduce 1st result
system("patch -p0 < ./merge.patch", intern = TRUE)
source("Total_PAH_and_Alkanes_GoA_Hydrocarbons_Clean.R")

# patch and reproduce 2nd result
system("patch -p0 < ./genResults.patch", intern = TRUE)
source("hcdbSites.R")

