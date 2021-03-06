#! /bin/bash

# This script do a parallel unzip of sdf.zip files located in DATADIR to OUTDIR
# You need to ave parallel installed
# Only tested unde Ubuntu

echo on
set -e
export DATADIR="/home/developer/Dropbox/DataLifeChemicals"
export OUTDIR="/opt/andrew/LifeChemicals/data"

command -v parallel >/dev/null 2>&1 || { echo "Require parallel but not installed.  Aborting." >&2; exit 1; }

if [[ -z "$DATADIR" ]]; then
	echo "Make sure you set \$DATADIR before running this script"
	echo "e.g. export DATADIR=\"/path/to/yourLifeChemicalsdfzip\""
	exit 1
fi

if [[ -z "$OUTDIR" ]]; then
	echo "Make sure you set \$OUTDIR before running this script"
	echo "e.g. export DATADIR=\"/path/to/yourLifeChemicalsdfzip\""
	exit 1
fi


#sort file size in increasing order, so smaller files are processed first
ls -rS $OUTDIR/*.sdf | parallel Rscript --vanilla --slave ./R/transform_sdf_to_rda.R {}
-
