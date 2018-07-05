#install.packages("rgeos")

library(sp)        # the classes and methods that make up spatial ops in R
library(maptools)  # tools for reading and manipulating spatial objects
library(rgeos)
library(rgdal)
library(raster)

### set wd to work in Github OHIBC location
dir_git  <- '/Users/eunjungpark/Documents/dataone/DataONE_2018_Summer_Intern_Project1/transparency/ohibc'         
source(file.path(dir_git, 'src/R/common.R'))  ### an OHIBC specific version of common.R

scenario <- 'vHS'

dir_spatial <- file.path(dir_git, 'prep/spatial') ### github: general buffer region shapefiles
dir_goal    <- file.path(dir_git, 'prep/lsp', scenario)
dir_rast    <- file.path(dir_goal, 'raster')            ### goal-specific raster files are small
source(file.path(dir_goal, 'lsp_fxns.R'))
source(file.path(dir_git, 'src/R/rast_tools.R'))

dir_anx <- file.path(dir_M, 'git-annex/bcprep')
dir_goal_anx <- file.path(dir_anx, 'lsp', 'v2016')
### git-annex: goal-specific large files; note in v2016 scenario instead of vHS

### provenance tracking
#library(provRmd); prov_setup()

### set up the default BC projection to be BC Albers
p4s_bcalb <- c('bcalb' = '+init=epsg:3005')
ext_howe <- extent(c(1140000, 1240000, 470000, 620000))
