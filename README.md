LifeChemicals
=============

Cheminformatics analysis of LifeChemicals

Dependencies
============
environment: Ubuntu 13+
tools: parallel (apt-get install parallel) for parallelizing batch script execution
R pacakges: 
* ChemmineR (chemical informatics R packages and tools)
* futile.logger (logger as in log4j styles)
DropBox client: for syncing result abck to dropbox

Description
=============
This repo contain multiple scripts. All scripts are under R folder.

transform_sdf_to_rda.R
-----------------------
info: transform the sdf file, the transform it into rda format.

Utility Scripts
---------------
prepdata.sh
info: Use parallel to unzip the data file fetched from DropBox 

transformsdf2rda.sh
info: Use parallel to pipe all the uncompressed sdf files to transform_sdf_to_rda.R for processing

To Use
========
There are 2 environment variables:
Open prepdata.sh to check, right now they are hardcoded for the moment.
```
export DATADIR="/home/developer/Dropbox/DataLifeChemicals"
export OUTDIR="/opt/andrew/LifeChemicals/data"
```
* DATADIR is where your dropbox downloaded compressed sdf files are.
* OUTDIR is where your uncompressed sdf file will be

Simply run transformsdf2rda.sh
* what you will see is that there are log files with the SAME name as the source sdf file
* all RDA images files are output under folder as in DATADIR (your dropbox folder). Your Dropbox client will auto sync to your dropbox account
* If rda images are successfully created and saved to DATADIR. That source sdf file is removed to conserve space. Also with the log files this allow you to resume where the error last stoppped you and continue process next on list.

If execution fails
