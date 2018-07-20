# Set working directory
setwd("/home/rstudio/work/data/")

# create a package
library(dataone)
library(datapack)
library(EML)

devtools::install_github("nceas/arcticdatautils")
library(arcticdatautils)

dp <- new("DataPackage")

metadataObj <- new("DataObject", format="eml://ecoinformatics.org/eml-2.1.1", filename="./data/metadata.xml")
dp <- addMember(dp, metadataObj)
eml <- read_eml("./data/metadata.xml")

# Add datasets as members (do not include jar file which is too large)
dirs <- c(".","data","yw","scripts")

for(d in dirs) {
  # Collect lists of files
  flists <- grep(list.files(d), pattern="\\.xml$", inv=T, value=T)
  flists <- grep(flists, pattern="\\.zip$", inv=T, value=T)
  
  # Filter out directory names
  flists <- setdiff(flists, list.dirs(recursive = FALSE, full.names = FALSE))
  
  for(o in flists) { 
    obj <- new("DataObject", format=guess_format_id(o), filename=paste(d,"/",o,sep=""))
    dp <- addMember(dp, obj, metadataObj)
  }
  
  # add other entities except those already existing (e.g., files under ./data/)
  if(d != "data") {
    pids <- NULL
    for(i in 1:length(flists)) {
      pid <- selectMember(dp, name="sysmeta@fileName", value=flists[i])
      pids <- c(pids, pid)
      flists[i] <- paste(d,"/",flists[i], sep="")
    }
    
    entity_df <- data.frame(type="otherEntity", path=flists, pid=pids, format_id=guess_format_id(flists), stringsAsFactors=FALSE)
    eml <- eml_add_entities(eml, entity_df)
  }
}

print(eml)
write_eml(eml, "./data/metadata.xml")
eml_validate("./data/metadata.xml")

# replace metadata file in the package
dp <- replaceMember(dp, metadataObj, replacement="./data/metadata.xml", formatId="eml://ecoinformatics.org/eml-2.1.1")
print(dp)


# Initialize recordr
devtools::install_github("nceas/recordr")
library(recordr)

setwd("./data/")
rc <- new("Recordr")

# Capture provenance
progFiles <- list.files(".", pattern="\\.R$")
progFiles <- grep(progFiles, pattern="DataDownload.R", inv=T, value=T)

for(p in progFiles) {
  record(rc, paste("./",p,sep=""), tag=p)
}

# Add provenance into the package
if(length(progFiles) > 0) {
   for(i in 1:length(progFiles)) {
     # capture file names and access types
     vr <- viewRuns(rc, seq=i)
     vrdf <- setNames(data.frame(basename(vr$files$filePath), vr$files$access), c("names","access"))
     vrUsed <- setNames(subset(vrdf, vrdf$access == "read" & vrdf$names != "statep010.shp"), c("names","acess"))
     vrDerived <- setNames(subset(vrdf, vrdf$access == "write"), c("names","acess"))
     
     # capture ids for sources (those files used and read)
     sids <- NULL
     for(n in 1:length(vrUsed$names)) {
       sid <- selectMember(dp, name="sysmeta@fileName", value=as.character(vrUsed$names[n]))
       sids <- c(sids, sid)
     }
     
     # capture ids for outputs (those files derived)
     oids <- NULL
     for(o in 1:length(vrDerived$names)) {
       oid <- selectMember(dp, name="sysmeta@fileName", value=as.character(vrDerived$names[o]))
       oids <- c(oids, oid)
     }
     
     # capture id for program script
     pid <- selectMember(dp, name="sysmeta@fileName", value=progFiles[i])
     
     # create provenance relationships
     dp <- describeWorkflow(dp, sources=sids, program=pid, derivations=oids)
   }
}

print(dp)


# Publish package to DataONE Test node
#d1c <- D1Client("STAGING", "urn:node:mnTestARCTIC")
#pkgId <- uploadDataPackage(d1c, dp, public=TRUE, quiet=FALSE)
