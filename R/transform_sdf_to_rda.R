##################
# Reads SDF filename from STDIN 
# transform to RDA format, save this to output folder as in environment variable 
# DATADIR
##################
options(error=traceback)

library("ChemmineR")
library("futile.logger")

init_environment<-function(logfile) {
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

assert <- function (expr, error, quitOnError) {
  if (!expr) {
     flog.error("Reason: %s", sprintf("%s ", paste(error, collapse=", ")))
     stop(error, call. = TRUE)
     if (quitOnError) quit(save='n')
  } 
}

create_if_absent<-function(basedir, dirname) {
   assert(expr=!is.null(basedir), error=c("Base Dir is missing"), quitOnError=TRUE)
   assert(expr=!is.null(dirname), error=c("Dirname is missing"), quitOnError=TRUE)
   newfile<-paste(basedir, dirname, sep="/")
   if (!file.exists(newfile)){
       flog.info("%s not found. Creating %s", newfile, newfile)
       ret = dir.create(newfile, showWarnings=TRUE)
       assert(expr=ret, error=c("Cannot create dir: ", newfile), quitOnError=TRUE)
       flog.info("Create: %s Status: %s", newfile, ret)
   }
   else {
       flog.info("%s already exists", newfile)
   }
}

get_image_filename<-function(file) {
   if(!is.null(file)) {
      file2<-basename(file)
      folder<-Sys.getenv("DATADIR")
      paste(folder,file2,sep="/")
   }
}

sdf_2_rda <- function(file, debug) {
   flog.info("Reading sdf set") 
   sdfset<-read.SDFset(file)
   flog.info("Save as apset set") 
   apset<-sdf2ap(sdfset)
   outputDir<-get_image_filename(file=file)
   flog.info("Save as compressed rda image to %s ", outputDir)
   image_file<-get_image_filename(file=gsub(".sdf", "_Image.rda", file))
   tryCatch({
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
