#!/usr/bin/env bash

# setup (install necessary packages)
Rscript /home/rstudio/work/data/setup.R

# transparency
Rscript /home/rstudio/work/data/retrieveProv.R

# reproducibility
Rscript /home/rstudio/work/data/reproduce.R

# bundling and publishing
Rscript /home/rstudio/work/data/bundling.R

