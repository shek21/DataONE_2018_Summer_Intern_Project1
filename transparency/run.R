library(recordr)
rc <- new("Recordr")
savedDir <- getwd()
setwd("/Users/eunjungpark/Documents/dataone/DataONE_2018_SummerIntern_Project1/transparency")
source("setup.R")
runNumber = 1
tagStr <- sprintf("aoos run %s", runNumber)
record(rc, "./scripts/aoos.R", tag=tagStr)
setwd(savedDir)