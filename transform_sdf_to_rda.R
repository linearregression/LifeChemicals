##################
# Reads SDF file from STDIN as stream then 
# transform to RDA format
##################

library("ChemmineR")
library("futile.logger")

sdf_2_rda<-function(file="stdin", debug=F)

init_environment<-function() {
   flog.logger("sdf2rda", DEBUG, appender=appender.file('sdf3rda.log'))
   flog.layout(layout.format("[~l] [~t] [~n.~f] ~m"))
   flog.appender(appender.console, "sdf2rda")
   (base.dir<-getwd())
   assert(expr=!missing(base.dir), error=c("Cannot get working directory"), quitOnError=TRUE)
   setwd(base.dir)
   flog.info("Current base dir: %s", base.dir)
   create_if_absent(basedir=base.dir, dirname="image")
   create_if_absent(basedir=base.dir, dirname="log")
   create_if_absent(basedir=base.dir, dirname="data/sdf")
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
       flog.info("Create: %s Status:%s", newfile, ret)
   }
   else {
       flog.info("%s already exists", newfile)
   }
}

get_image_filename<-function(folder="image",file=NULL) {
   if(!is.null(file)) {
      paste(getwd(),folder,file,sep="/")
   }
}

sdf_2_rda <- function(file="stdin", debug=FALSE) { 
   flog.appender(appender=appender.file('sdf3rda.log'), "sdf2rda") 
   flog.info("Reading sdf set") 
   sdfset<-read.SDFset(file)
   flog.info("Save as apset set") 
   apset<-sdf2ap(sdfset)
   flog.info("Save as rda image") 
   image_file<-get_image_filename(file=gsub(".sdf", "_Image.rda", file))
   save.image(file=image_file, compress="bzip2", safe=TRUE)
   flog.info("Saved %s_Image.rda. File Size", file, size)
}

upload_file<-function(files, debug=TRUE) {
   files<-list.files(pattern=".rda", recursive=T)
}

get_rda_files<-function() {
   list_files(cwd=".", extension="rda")
}

get_sdf_files<-function(){
   list_files(cwd=".", extension="sdf")
}

list_files<-function (cwd, extension) {
  ext<-sprintf("\\.%s$",extension)
  flog.info("Current directory: %s extension: %s", cwd, extension)
  fs<-list.files(path=cwd, recursive=TRUE, full.names=TRUE, pattern=ext)
}

cleanup<-function() {
  cwd<-getwd()
  rda.files<-list_files(cwd=cwd, extension="rda")
  sdf.files<-list_files(cwd=cwd, extension="sdf")
  rm(rda.files)
  rm(sdf.files)
}

main<-function() {
  init_environment()
  prep_data_files()
  sdf_2_rda()
  upload_file()
  print_result()
}
