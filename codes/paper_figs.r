# Generates Fig. 2d, Fig. 4a

source("s_clust_lib.R")

tic()
#Fig. 2d
census_viz(10,"fig2d.png","summary_lu.png")

#Fig. 4a (saved in clust_plots/basal_1_20)
clust_nhood("basal",1,20)

dir.create("../data/census_clust_out")

clust_plot("ward.D2","ball","basal",1,20)
clust_plot("ward.D2","hartigan","basal",1,20)
toc()
