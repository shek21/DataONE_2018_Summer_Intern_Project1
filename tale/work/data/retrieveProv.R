# set working directory
setwd("./work/data/data/")

library(dataone)
library(datapack)

# Get package from production node of Gulf of Alaska Data Portal (GOA)
d1c <- D1Client("PROD", "urn:node:GOA")
pkg <- getDataPackage(d1c, identifier = "urn:uuid:1d23e155-3ef5-47c6-9612-027c80855e8d", lazyLoad=TRUE, limit="0MB", quiet=FALSE)
print(pkg)

# Retrieve relationships for the package
rels <- getRelationships(pkg, condense=T)
print(rels)

# Retrieve provenance only
prov <- subset(rels, predicate=="prov:used" | predicate =="prov:wasDerivedFrom" | predicate=="prov:wasGeneratedBy")
print(prov)

# Replace ids with names in the provenance
provPlan <- subset(rels,predicate == "prov:hadPlan")
provAsso <- subset(rels,predicate == "prov:qualifiedAssociation")
provAsso$object <- provPlan$object[match(provAsso$object, provPlan$subject)]
indx <- match(prov$subject, provAsso$subject, nomatch = 0)
prov$subject[indx != 0] <- provAsso$object[indx]
indx <- match(prov$object, provAsso$subject, nomatch = 0)
prov$object[indx != 0] <- provAsso$object[indx]

# Filter out unnecessary 
prov <- data.frame(lapply(prov, as.character), stringsAsFactors=FALSE)
provSimp <- subset(prov, predicate=="prov:used" | predicate=="prov:wasGeneratedBy")
provSimp <- data.frame(lapply(provSimp, as.character), stringsAsFactors=FALSE)
print(provSimp)

# Create RDF
install.packages("rdflib")
library(rdflib)
rdfSimp <- rdf()
for (i in 1:nrow(provSimp)) rdf_add(rdfSimp, provSimp$object[i], provSimp$predicate[i], provSimp$subject[i], subjectType="uri", objectType="uri")
options(rdf_print_format = "rdfxml")
rdf_serialize(rdfSimp, "../../../provSimp.rdfxml")
print(rdfSimp)

# Generate YesWorkflow
system("java -jar ../yw_jar/yesworkflow-0.2.1-SNAPSHOT-jar-with-dependencies.jar graph ../yw/aoos.R -c graph.view=combined -c graph.layout=tb > ../../../aoos.dot")
system("dot -Tpdf ../../../aoos.dot > ../../../aoos.pdf")
