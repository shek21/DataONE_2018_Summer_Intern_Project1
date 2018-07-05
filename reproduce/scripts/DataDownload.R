# use 32-bit version of R
#install.packages("httr")
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("XML")
#install.packages("curl")
#install.packages("rvest")
#install.packages("tidyr")
#install.packages("stringr")
#install.packages("Hmisc")
#install.packages("RODBC")

#load packages (order matters)
library(httr)
library(plyr)
library(dplyr)
library(XML)
library(curl)
library(rvest)
library(tidyr)
library(stringr)
library(Hmisc)
library(RODBC)

  EVTHD_Packagezipd = tempfile()
  download.file("https://workspace.aoos.org/published/file/48a76993-a061-492d-b775-5a680c70a4ec/2016_EVTHD_Package.zip",EVTHD_Packagezipd, mode="wb")
  EVTHD_Packagezip_L = unzip(EVTHD_Packagezipd, list=TRUE)

  EVTHD_Packagezip_accdb <- EVTHD_Packagezip_L[grep(".accdb", EVTHD_Packagezip_L$Name),]$Name   # creates list of files I want
  UNz <- unzip(EVTHD_Packagezipd, EVTHD_Packagezip_accdb)
  
  pdf_table_list <- function(file_list){
    # for every pdf file in the list, do the following 
    conn <- odbcConnectAccess2007(path.expand(file_list)) # establish a connection
    table_list <- subset(sqlTables(conn), TABLE_TYPE=="TABLE") # lists tables in DB
    return(table_list)
    
  }
  
  lapply(UNz, pdf_table_list)  # running the function over the two .mdb files
  
  conn <- odbcConnectAccess2007(path.expand("./2015_EVTHD_Package/EVTHD Feb 2016.accdb")) # establish a connection
  Sample <- sqlFetch(conn,"Sample")  # read in a table. Need to change the names to download the csv files that we want. ex. sample 
  PAH <- sqlFetch(conn,"PAH") 
  CollectionMethods<-sqlFetch(conn, "Collection Methods")
  Alkane<-sqlFetch(conn,"Alkane")
  
  write.csv(Alkane, "Alkane.csv")
  write.csv(PAH, "PAH.csv")
  write.csv(CollectionMethods, "Collection Methods.csv")
  write.csv(Sample, "Sample.csv")
  
  close(conn) 
  unlink(EVTHD_Packagezipd)
