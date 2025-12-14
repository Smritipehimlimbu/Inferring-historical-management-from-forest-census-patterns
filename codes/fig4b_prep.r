library(tictoc)

load("../data/basal_1_20_neighbours.RData")

tic()
dm<-dist(samples)

rm(samples)

pcoa_res<-cmdscale(dm,k=2,eig=TRUE)
toc()

save(pcoa_res,file="../data/pcoa_basal.RData")
