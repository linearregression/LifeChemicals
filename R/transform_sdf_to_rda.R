##################
# Reads SDF filename from STDIN 
# transform to RDA format, save this to output folder as in environment variable 
# DATADIR
##################
rm(list=ls()) #Dump all preexiting objects

options(error=traceback, showWarnCalls=TRUE, showErrorCalls=TRUE)
if (!exists('RUNNER_BASE')) RUNNER_BASE='/opt/andrew/LifeChemicals'
source(sprintf("%s/R/util.R", RUNNER_BASE))

library("ChemmineR")
library("futile.logger")

lastprocessed.log<-"lastprocessed.log"

init_environment<-function(logfile="sdf2rda") {
   flog.logger("ROOT", DEBUG, appender=appender.file(paste(RUNNER_BASE, "/log/", logfile, ".log", sep="")))
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
     flog.info("Reading sdf set: %s", file) 
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

remove_processed_sdf<-function(sdffile, shouldRemove) {
   print(c("Is ok to removing sdf file ", sdffile, "?",shouldRemove))
   if(shouldRemove) {
     assert(expr=!is.null(sdffile), error=c("Filename is missing"), quitOnError=FALSE)
     flog.info("Finished processing. Removing sdf %s", sdffile)
     file.remove(sdffile)
     flog.info("Removed sdf %s", sdffile)
     cat(paste(basename(sdffile)),file=lastprocessed.log)
   } else {
     flog.info("Not finish processing %s", sdffile)
   }
}

check_last_process<-function(currentFile=NULL) { 
  if(!is.null(currentFile)) {     
     line<-readChar(lastprocessed.log, file.info(lastprocessed.log)$size)
     lastfile.processed<-gsub("[\r\n]", "", line)
     if(!is.null(lastfile.processed)) {
        previous.file<-basename(lastfile.processed)
        current.file<-basename(currentFile)
        flog.info("Lastfile processed %s current file: %s", previous.file, current.file)
        print(c("Lastfile processed: ", previous.file, "current file: ",current.file))
        return((previous.file==current.file))
     } 
  } 
  flog.warn("Missing source file to process")
  print("Missing source file to process")
  FALSE
}

main<-function() {
  args<-commandArgs(trailingOnly=TRUE)
  print(c("Start processing sdf file: ", args))
  if(!file.exists(lastprocessed.log)) {
     cat("",file=lastprocessed.log) #seed the lastprocessed.log
  }
  assert(expr=(nchar(args) >0 ), error=c("No input file provided"), quitOnError=TRUE)
  init_environment(logfile=basename(args))
  flog.info("Going to process file %s", args)
  isfileprocessed <- check_last_process(args)
  if(!isfileprocessed) { #no need to start from scratch each time
    print(c("This is a new sdf file: ", args))
    sdf_2_rda(file=args, debug=FALSE)
    print(c("Done processing sdf file: ", args))
  } else {
    print(c("File already processed: ", args))
 }
}

main()
