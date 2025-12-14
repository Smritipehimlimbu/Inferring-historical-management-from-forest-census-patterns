library(ggplot2)

graphics.off()

load("../data/pcoa_basal.RData")
dat<-read.csv("../data/census_w_cluster.csv")

pcoa_xy<-as.data.frame(pcoa_res$points)
colnames(pcoa_xy)<-c("PCoA1","PCoA2")
pcoa_xy$group<-as.character(dat$Clusters_id)
l<-pcoa_res$eig
v1<-100*l[1]/sum(l)
v2<-100*l[2]/sum(l)

cPal <- c("#1F77B4","#FF7F0F","#2CA02C","#d62728","#9467bd","#8c564b","#e377c2","#7f7f7f","#bcbd22","#16bece","#000000")

#dev.new()
fig1<-ggplot(pcoa_xy, aes(x=PCoA1, y=PCoA2)) +
	geom_point(aes(color = group),alpha=1.0) +
	scale_color_manual(values=cPal,name="Cluster #")+
	theme(legend.text=element_text(size=20),
				legend.title=element_text(size=20),
				axis.title=element_text(size=20))+
	labs(x=sprintf("PCoA1 (~%.2f%%)",v1), y=sprintf("PCoA2 (~%.2f%%)",v2))+
	coord_fixed(ratio=1)
ggsave(filename = file.path("./output/fig4b.png"), plot = fig1, width = 10, height = 8, units = "in")
#print(fig1)
