##################
# Reads SDF filename from STDIN 
# transform to RDA format, save this to output folder as in environment variable 
# DATADIR
##################
rm(list=ls()) #Dump all preexiting objects

options(error=traceback, showWarnCalls=TRUE, showErrorCalls=TRUE)
if (!exists('RUNNER_BASE')) RUNNER_BASE='/opt/andrew/LifeChemicals/R'
source(sprintf("%s/util.R", RUNNER_BASE))

library("ChemmineR")
library("futile.logger")

init_environment<-function(logfile="sdf2rda") {
   flog.logger("ROOT", DEBUG, appender=appender.file(paste(logfile, ".log", sep="")))
   #flog.layout(layout.format("[~l] [~t] [~n.~f] ~m"))
   #flog.appender(appender.console, "sdf2rda")
   flog.info("Initializing environment")
   folder<-Sys.getenv("DATADIR")
   flog.info("Output image folder is %s", folder)
   assert(expr=(nchar(folder) > 0), error=c("Env variable DATADIR not set: "), quitOnError=TRUE)
   (base.dir<-getwd())
   assert(expr=!missing(base.dir), error=c("Cannot get working directory"), quitOnError=TRUE)
   setwd(base.dir)
   flog.info("Current base dir: %s", base.dir)
   create_if_absent(basedir=base.dir, dirname="image")
   create_if_absent(basedir=base.dir, dirname="log")
}


get_image_filename<-function(file) {
   if(!is.null(file)) {
      file2<-basename(file)
      folder<-Sys.getenv("DATADIR")
      paste(folder,file2,sep="/")
   }
}

sdf_2_rda <- function(file, debug) {
   tryCatch({
     flog.info("Reading sdf set") 
     sdfset<-read.SDFset(file)
     flog.info("Save as apset set") 
     apset<-sdf2ap(sdfset)
     outputDir<-get_image_filename(file=file)
     image_file<-get_image_filename(file=gsub(".sdf", "_Image.rda", file))
     flog.info("Save as compressed rda image to %s ", outputDir)
     save.image(file=image_file, compress="bzip2", safe=TRUE)
     flog.info("Saved %s_Image.rda.", file)
     remove_processed_sdf(sdffile=file, shouldRemove=TRUE)
      
     }, warning = function(warn) {
        flog.warn("Unexpected warning: %s", warn)
     }, error = function(err) {
        flog.error("Unexpected error: %s", err)
     }, finally = {
	flog.info("Done execution")
     }
   ) 
}

remove_processed_sdf<-function(sdffile, shouldRemove=FALSE) {
   if(shouldRemove) {
     assert(expr=!is.null(sdffile), error=c("Filename is missing"), quitOnError=FALSE)
     flog.info("Finished processing. Removing sdf %s", sdffile)
     file.remove(sdffile)
     flog.info("Removed sdf %s", sdffile)
   } else {
     flog.info("Not finish processing %s", sdffile)
   }
}

#list_files<-function (cwd, extension) {
#  ext<-sprintf("\\.%s$",extension)
#  flog.info("Current directory: %s extension: %s", cwd, extension)
#  fs<-list.files(path=cwd, recursive=TRUE, full.names=TRUE, pattern=ext)
#}

#cleanup<-function() {
#  cwd<-getwd()
#  rda.files<-list_files(cwd=cwd, extension="rda")
#  sdf.files<-list_files(cwd=cwd, extension="sdf")
#  rm(rda.files)
#  rm(sdf.files)
#}

main<-function() {
  args<-commandArgs(trailingOnly=TRUE)
  assert(expr=(nchar(args) >0 ), error=c("No input file provided"), quitOnError=TRUE)
  init_environment(logfile=basename(args))
  flog.info("Going to process file %s", args)
  sdf_2_rda(file=args, debug=FALSE)
}

main()
