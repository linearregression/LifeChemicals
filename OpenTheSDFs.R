##################
library("ChemmineR")
##################
rm(list=ls())
##################
files<-list.files(pattern=".sdf", recursive=F)
##################


p<-1
#DoCheminformatics<-function(p){
##################
sdfset<-read.SDFset(files[p])
##################
#valid <- validSDF(sdfset)
#sdfset <- sdfset[valid]
apset<-sdf2ap(sdfset)
#sdfset<-sdfset[!sapply(as(apset,"list"),length)==1]
#smiset<-sdf2smiles(sdfset)
##################
#Get starting sdfset
#sdfset_start<-sdfset[which(sapply(as(apset, "list"), length)==1)]
#sdfset<-sdfset[-which(sapply(as(apset, "list"), length)==1)]
#apset<-apset[-which(sapply(as(apset, "list"), length)==1)]
##################
save.image(file=gsub(".sdf", "_Image.rda", files[p]), compress=T)
##################
#}
##################
#p<-1:length(files)
#p<-1 #for testing
##################
#lapply(p, DoCheminformatics)

#mclapply(p, DoCheminformatics, mc.cores=#ofcores) #install parallel in R for this feature

