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

init_environment <- function(){
   (base.dir <- getwd())
   if (!is.null(base.dir)) setwd(base.dir) 
}

sdf_2_rda<-function(file=, debug=T) {  
   flog.info("Reading sdf set") 
   sdfset<-read.SDFset(file)
   flog.info("Save as apset set") 
   apset<-sdf2ap(sdfset)
   flog.info("Save as rda image") 
   save.image(file=gsub(".sdf", "_Image.rda", file), compress="bzip2", safe=T)
   flog.info("Saved %s_Image.rda. File Size", file, size)
}

upload_file<-function(files, debug=TRUE) {

   files<-list.files(pattern=".sdf", recursive=F)
}

