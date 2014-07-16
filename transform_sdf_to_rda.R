##################
# Reads SDF file from STDIN as stream then 
# transform to RDA format
##################

library("ChemmineR")
library("futile.logger")

sdf_2_rda<-function(file="stdin", debug=F)

init_environment<-function() {
   layout<-layout.format('[~l] [~t] [~n.~f] ~m')
   flog.logger(DEBUG, appender=appender.file('sdf3rda.log'))
   flog.layout(layout)
   flog.appender(appender.console)
   (base.dir<-getwd())
   if (!is.null(base.dir)) {
      setwd(base.dir)
      flog.info("Current base dir: ~s", base.dir)
      create_if_absent(base.dir,"image")
      create_if_absent(base.dir,"log")
      create_if_absent(base.dir,"data/sdf")
   }
}

create_if_absent<-function(basedir, dirname) {
   if (!is.null(basedir)) {
      newfile<-paste(basedir, dirname, sep="/")
      if (!file.exists(newfile)){
          flog.info("~s not found. Creating ~s", newfile)
          file.create(newfile, showWarnings=T)
          flog.info("~s Created", newfile)
      }
   }
}

get_image_filename<-function(folder="image",file=NULL) {
   ret<-NULL
   if(!is.null(file)) {
      ret<-paste(getwd(),folder,file,sep="/")
   }
   return ret
}

sdf_2_rda <- function(file="stdin", debug=FALSE) {  
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
   list_files(cwd=".", extension=".rda")
}

get_sdf_files<-function(){
   list_files(cwd=".", extension=".sdf")
}

list.files<-function (cwd, extension) {
  ext<-sprintf("\\.%s$",extension)
  flog.info("Current directory: %s extension: 5s", cwd, ext)
  fs<-list.files(path=cwd, recursive=TRUE, full.names=TRUE, pattern=ext)

}

cleanup<-function() {
  rda.files<-list.files(path=getwd(), recursive=T, full.names=T, pattern="\\.rda$")
  sdf.files<-list.files(path=getwd(), recursive=T, full.names=T, pattern="\\.sdf$")
  rm(rda.files)
  rm(sdf.files)
}

