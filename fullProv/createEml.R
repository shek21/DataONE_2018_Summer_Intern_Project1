library(EML)

# create metadata information
coverage <- set_coverage(beginDate="2018-07-09", endDate="2018-07-13", 
                         geographicDescription="Chicago", 
                         west=-87.623177, east=-87.623177, 
                         north=41.881832, south=41.881832)
person <- as.person("Seokki Lee <slee195@hawk.iit.edu> [cre]")
slee <- as(person, "creator")
contact <- new("contact", 
               individualName = slee@individualName, 
               electronicMail = slee@electronicMailAddress, 
               organizationName = "IIT", phone="000-000-0000")
pubDate <- "2018-07-10"
title <- "test storing provenance into resmap"
abstract <- "test abs"

dataset <- new("dataset", 
               title=title, 
               creator=slee, 
               pubDate=pubDate, 
               abstract=abstract, 
               coverage=coverage, 
               contact=contact)
eml <- new("eml", system="uuid", dataset=dataset)

# write it into a file
write_eml(eml, "./meta.xml")

# check the written metadata file is valid
eml_validate("./meta.xml")

#print(eml)
