#!/usr/bin/env bash

# create output directories
# mkdir -p $RESULTS_DIR

SCRIT_DIR="./new"

# generate metadata
Rscript $SCRIPT_DIR/createEml.R

# bundling objects and provenance together into the package
Rscript $SCRIPT_DIR/bundle.R
