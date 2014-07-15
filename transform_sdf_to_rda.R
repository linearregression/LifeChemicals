##################
# Reads SDF file from STDIN as stream then 
# transform to RDA format
##################

library("ChemmineR")

stream_input<-function(folder, debug=TRUE){
   

}

sdf_2_rda<-function(files, debug=TRUE) {

    sdfset<-read.SDFset()
    apset<-sdf2ap(sdfset)
    save.image(file=gsub(".sdf", "_Image.rda", files[p]), compress=T)
}

upload_file<-function(files, debug=TRUE) {

}

