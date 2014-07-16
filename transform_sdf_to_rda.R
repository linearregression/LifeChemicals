##################
# Reads SDF file from STDIN as stream then 
# transform to RDA format
##################

library("ChemmineR")
library("futile.logging")

layout <- layout.format('[~l] [~t] [~n.~f] ~m')
flog.logger(DEBUG, appender=appender.file('sdf3rda.log')))
flog.layout(layout)
flog.appender(appender.console)
sdf_2_rda<-function(file="stdin", debug=F)

init_environment<-function() {
   (base.dir<-getwd())
   if (!is.null(base.dir)) {
      setwd(base.dir)
      flog.info("Current base dir: ~s", base.dir)
      image.dir<-paste(base.dir,"image",sep="/")
      if (!file.exists(image.dir)){
          flog.info("ImageDir not found. Creating ~s", image.dir)
          file.create(image.dir, showWarnings=T)
          flog.info("ImageDir ~s Created", image.dir)
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

sdf_2_rda <- function(file="stdin", debug=F) {  
   flog.info("Reading sdf set") 
   sdfset<-read.SDFset(file)
   flog.info("Save as apset set") 
   apset<-sdf2ap(sdfset)
   flog.info("Save as rda image") 
   image_file<-get_image_filename(file=gsub(".sdf", "_Image.rda", file))
   save.image(file=image_file, compress="bzip2", safe=T)
   flog.info("Saved %s_Image.rda. File Size", file, size)
}

upload_file<-function(files, debug=TRUE) {
   files<-list.files(pattern=".rda", recursive=T)
}

cleanup<-function() {
  

}

