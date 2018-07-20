# Set working directory
setwd("/home/rstudio/work/data/data/")

# patch and reproduce 1st result
#system("patch -p0 < ./merge.patch", intern = TRUE)
source("../scripts/new_total_PAH_and_Alkanes_GoA_Hydrocarbons_Clean.R")

# patch and reproduce 2nd result
#system("patch -p0 < ./genResults.patch", intern = TRUE)
source("../scripts/new_HcdbSites.R")

