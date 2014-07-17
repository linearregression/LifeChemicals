NULL
options(error=traceback, showWarnCalls=TRUE, showErrorCalls=TRUE)
util<-new.env()

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
