#! /bin/bash
echo on
set -e
export DATADIR="/home/developer/Dropbox/DataLifeChemicals"
export OUTDIR="/opt/andrew/data"

if [[ -z "$DATADIR" ]]; then
	echo "Make sure you set \$DATADIR before running this script"
	echo "e.g. export DATADIR=\"/path/to/yourLifeChemicalsdfzip\""
	exit 1
fi

ls $DATADIR/*.zip | parallel unzip -u -d $OUTDIR
