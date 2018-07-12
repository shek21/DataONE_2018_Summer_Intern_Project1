# Set working directory
setwd("../new/")

# Create metadata in eml
source("../createEml.R")


# create a package
library(dataone)
library(datapack)

dp <- new("DataPackage")


# Add members
metadataObj <- new("DataObject", format="eml://ecoinformatics.org/eml-2.1.1", filename="../../../meta.xml")
dp <- addMember(dp, metadataObj)

# Collect lists of files except metadata file
flists <- grep(list.files("."), pattern="\\.xml$", inv=T, value=T)
flists <- grep(flists, pattern="\\.zip$", inv=T, value=T)

# Filter out directory names
flists <- setdiff(flists, list.dirs(recursive = FALSE, full.names = FALSE))

for(o in flists) { 
  obj <- new("DataObject", filename=paste("./",o,sep=""))
  dp <- addMember(dp, obj, metadataObj)
}

print(dp)


# add otherEntity
#devtools::install_github("nceas/arcticdatautils")
library(arcticdatautils)

pids <- NULL
for(i in 1:length(flists)) {
  pid <- selectMember(dp, name="sysmeta@fileName", value=flists[i])
  pids <- c(pids, pid)
  flists[i] <- paste("./", flists[i], sep="")
}
entity_df <- data.frame(type="otherEntity", path=flists, pid=pids, format_id=guess_format_id(flists), stringsAsFactors=FALSE)
eml <- eml_add_entities(eml, entity_df)
write_eml(eml, "../../../meta.xml")
eml_validate("../../../meta.xml")
print(eml)


# replace metadata file in the package
dp <- replaceMember(dp, metadataObj, replacement="../../../meta.xml", formatId="eml://ecoinformatics.org/eml-2.1.1")
print(dp)


# Initialize recordr
#devtools::install_github("nceas/recordr")
library(recordr)
rc <- new("Recordr")

# Capture provenance
progFiles <- list.files(".", pattern="\\.R$")
for(i in progFiles) {
  record(rc, paste("./",i,sep=""), tag=i)
}

# Add provenance into the package
for(i in 1:length(progFiles)) {
  # capture file names and access types
  vr <- viewRuns(rc, seq=i)
  vrdf <- setNames(data.frame(basename(vr$files$filePath), vr$files$access), c("names","access"))
  vrUsed <- setNames(subset(vrdf, vrdf$access == "read"), c("names","acess"))
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

print(dp)


# Publish package to DataONE Test node
#d1c <- D1Client("STAGING", "urn:node:mnTestARCTIC")
#pkgId <- uploadDataPackage(d1c, dp, public=TRUE, quiet=FALSE)
