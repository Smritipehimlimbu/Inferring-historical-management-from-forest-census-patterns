# First modified on 5/13/24 by Athma

library(tidyverse)
library(ggplot2)
library(factoextra)
library(NbClust)
library(tictoc)

#
census_viz = function(num_species,pl_name_1,pl_name_2){
	graphics.off()
	
	if(num_species>10){
		num_species=10
	}

	#Load and prepare data
	fdat<-read_csv("../data/full_dat.csv",show_col_types = FALSE)
	fdat$Species[is.na(fdat$Species)]<-"UNKNOWN"
	fdat<-fdat[-which(fdat$Species=="Corner"),]
	fdat<-fdat[-which(fdat$Species=="PAGGRA"),]
	fdat<-fdat[-which(fdat$Species=="Ulmus sp."),]
	fdat<-fdat[-which(fdat$Species=="PRUSP"),]
	fdat<-fdat[-which(fdat$Species=="Carya sp."),]
	fdat<-fdat[-which(fdat$Species=="ABCDE"),]
	fdat<-fdat[-which(fdat$Species=="UNKNOWN"),]

	# Calculate species frequencies
	species_counts <- fdat %>%
  	count(Species) %>%
	  arrange(desc(n))

	# Determine the top n most abundant species
	top_species <- species_counts$Species[1:num_species]

	fdat$Species_color <- ifelse(fdat$Species %in% top_species, as.character(fdat$Species), "OTHER")
	fdat$Species_color <- factor(fdat$Species_color, levels = c(top_species,"OTHER"))
	fdat$Land_use <- ifelse(fdat$Land_use=="Managed/CutRegrowth","Managed Forest",fdat$Land_use)

	# Color pallete
	cPal <- c("#1F77B4","#FF7F0F","#2CA02C","#d62728","#9467bd","#8c564b","#e377c2","#7f7f7f","#bcbd22","#16bece","#000000")

theme()

	#dev.new()
	fig1 <- ggplot(fdat, aes(x = global_y, y = -global_x)) + 
		geom_point(aes(color = Species_color),alpha=1.0) +
		theme(legend.text = element_text(size=15, face = "italic"),
														legend.position = "right",
														legend.key.size = unit(0.05, 'cm'),
														legend.box = "vertical",
					legend.title=element_text(size=15),	
					axis.title.x=element_blank(),
	        axis.text.x=element_blank(),
  	      axis.ticks.x=element_blank(),
					axis.title.y=element_blank(),
					axis.text.y=element_blank(),
  	      axis.ticks.y=element_blank())+
		scale_x_continuous(breaks=seq(0,500,by=20),minor_breaks=c()) +
		scale_y_continuous(breaks=seq(-200,0,by=20),minor_breaks=c()) +
	#	scale_radius(range=c(0,max(fdat$DBH, na.rm=T))/25) + 
	# scale_color_manual(values=c(cPal[1:num_species],"#9e9e9e"), labels=c("Tsuga canadensis","Acer saccharum","Frangula alnus","Pinus strobus","Fraxinus americana","Acer rubrum","Carpinus caroliniana","Betula alleghaniensis","Fraxinus nigra","Fagus grandifolia","Others")) +
		scale_color_manual(values=c(cPal[1:num_species],"#9e9e9e"), labels=c("Eastern hemlock","Sugar maple","Alder buckthorn","White pine","White ash","Read maple","American hornbeam","Yellow birch","Black ash","American beech","Others")) +
		labs(color="Species")+
		coord_fixed(ratio=1)
		ggsave(filename = file.path("./output",pl_name_1), plot = fig1, width = 10, height = 8, units = "in")
	#print(fig1)
	#dev.off()

	fig2 <- ggplot(fdat, aes(x = global_y, y = -global_x)) + 
		geom_point(aes(color = Land_use),alpha=1.0) +
		theme(legend.text = element_text(size=15, face = "italic"),
														legend.position = "right",
														legend.key.size = unit(0.05, 'cm'),
														legend.box = "vertical",
					legend.title=element_text(size=15),	
					axis.title.x=element_blank(),
	        axis.text.x=element_blank(),
  	      axis.ticks.x=element_blank(),
					axis.title.y=element_blank(),
					axis.text.y=element_blank(),
  	      axis.ticks.y=element_blank())+
		scale_x_continuous(breaks=seq(0,500,by=20),minor_breaks=c()) +
		scale_y_continuous(breaks=seq(-200,0,by=20),minor_breaks=c()) +
	#	scale_radius(range=c(0,max(fdat$DBH, na.rm=T))/25) + 
		scale_color_manual(values=cPal,name="Land Use") +
		coord_fixed(ratio=1)
		ggsave(filename = file.path("./output",pl_name_2), plot = fig2, width = 10, height = 8, units = "in")
}

#
clust_nhood = function(ne_type,norm_i,barad){
	graphics.off()

	# Check argument 1; Argument 2 decides if the neighborhood metric is normalized
	if(ne_type != 'basal' && ne_type != 'stem'){
		stop("Bad argument");
	}

	#Load and prepare data
	fdat<-read_csv("../data/full_dat.csv")

	fdat$Species[is.na(fdat$Species)]<-"UNKNOWN"
	fdat<-fdat[-which(fdat$Species=="Corner"),]
	fdat<-fdat[-which(fdat$Species=="PAGGRA"),]
	fdat<-fdat[-which(fdat$Species=="Ulmus sp."),]
	fdat<-fdat[-which(fdat$Species=="PRUSP"),]
	fdat<-fdat[-which(fdat$Species=="Carya sp."),]
	fdat<-fdat[-which(fdat$Species=="ABCDE"),]
	fdat<-fdat[-which(fdat$Species=="UNKNOWN"),]

	# Compute matrix: each row is an individual tree, each column is the number of neigbors/basal area of one tree species within 20 m of that tree

#	barad <- 20

	samples <- data.frame(matrix(ncol = length(unique(fdat$Species)), nrow = nrow(fdat)))
	colnames(samples) <- unique(fdat$Species)

	if(ne_type=='stem'){
		for(i in 1:nrow(fdat)) {
			nx <- fdat$global_x[i]
			ny <- fdat$global_y[i]
			neighbors <- fdat[which(((nx-fdat$global_x)^2+(ny-fdat$global_y)^2)<barad^2),]
			for(j in unique(fdat$Species)) {
				singlesp <- neighbors[which(neighbors$Species == j),]
				samples[i,j] <- nrow(singlesp)
			}
			if(i %% 100 == 0) print(i)
		}
	}

	if(ne_type=='basal'){
		for(i in 1:nrow(fdat)) {
			nx <- fdat$global_x[i]
			ny <- fdat$global_y[i]
			neighbors <- fdat[which(((nx-fdat$global_x)^2+(ny-fdat$global_y)^2)<barad^2),]
			for(j in unique(fdat$Species)) {
				singlesp <- neighbors[which(neighbors$Species == j),]
				samples[i,j] <- sum(singlesp$DBH^2)
			}
			if(i %% 100 == 0) print(i)
		}
	}

	if(norm_i!=0){
		samples <- samples / rowSums(samples)	# normalized neighborhoods
	}
	save(samples,file=sprintf("../data/%s_%d_%d_neighbours.RData",ne_type,norm_i,barad))
}

#
clust_plot = function (nb_method,ind,ne_type,norm_i,barad){
	
	fdat<-read_csv("../data/full_dat.csv",show_col_types=FALSE)
	fdat$Species[is.na(fdat$Species)]<-"UNKNOWN"
	fdat<-fdat[-which(fdat$Species=="Corner"),]
	fdat<-fdat[-which(fdat$Species=="PAGGRA"),]
	fdat<-fdat[-which(fdat$Species=="Ulmus sp."),]
	fdat<-fdat[-which(fdat$Species=="PRUSP"),]
	fdat<-fdat[-which(fdat$Species=="Carya sp."),]
	fdat<-fdat[-which(fdat$Species=="ABCDE"),]
	fdat<-fdat[-which(fdat$Species=="UNKNOWN"),]

	cdat<-as_tibble_col(fdat$Species,column_name="Species_code")
	cdat<-add_column(cdat,as_tibble_col(fdat$global_x,column_name="X"))
	cdat<-add_column(cdat,as_tibble_col(fdat$global_y,column_name="Y"))

	load(sprintf("../data/%s_%d_%d_neighbours.RData",ne_type,norm_i,barad))

	clust_out <- NbClust(samples, max.nc=15, method = nb_method, index = ind)
	
	# Save cluster output
	cdat<-add_column(cdat,as_tibble_col(clust_out$Best.partition,column_name="Clusters_complete_silhouette"))

	write_csv(cdat,sprintf("../data/census_clust_out/%s_%s_%s_%d_%d.csv",nb_method,ind,ne_type,norm_i,barad))

	# Plot clusters
	if(clust_out$Best.nc[1]<12){
		cPal <- c("#1F77B4","#FF7F0F","#2CA02C","#d62728","#9467bd","#8c564b","#e377c2","#7f7f7f","#bcbd22","#16bece","#000000")
#	dev.new()
	fig1 <- ggplot(fdat, aes(x = global_y, y = -global_x)) + 
		geom_point(aes(color = as.character(clust_out$Best.partition)),alpha=1.0) +
		theme(legend.text = element_text(size=15, face = "italic"),
														legend.position = "right",
														legend.key.size = unit(0.05, 'cm'),
														legend.box = "vertical",
					legend.title=element_text(size=15),	
					axis.title.x=element_blank(),
	        axis.text.x=element_blank(),
  	      axis.ticks.x=element_blank(),
					axis.title.y=element_blank(),
					axis.text.y=element_blank(),
  	      axis.ticks.y=element_blank())+
		scale_x_continuous(breaks=seq(0,500,by=20),minor_breaks=c()) +
		scale_y_continuous(breaks=seq(-200,0,by=20),minor_breaks=c()) +
	#	scale_radius(range=c(0,max(fdat$DBH, na.rm=T))/25) + 
		scale_color_manual(values=cPal,name="Cluster #") +
		coord_fixed(ratio=1)
	} else{
	#	dev.new()
		fig1 <- ggplot(fdat, aes(x = global_y, y = -global_x)) + 
			geom_point(aes(color = as.character(clust_out$Best.partition)),alpha=1.0) +
			theme(legend.text = element_text(size=15, face = "italic"),
															legend.position = "right",
															legend.key.size = unit(0.05, 'cm'),
															legend.box = "vertical",
						legend.title=element_text(size=15),	
						axis.title.x=element_blank(),
						axis.text.x=element_blank(),
						axis.ticks.x=element_blank(),
						axis.title.y=element_blank(),
						axis.text.y=element_blank(),
						axis.ticks.y=element_blank())+
			scale_x_continuous(breaks=seq(0,500,by=20),minor_breaks=c()) +
			scale_y_continuous(breaks=seq(-200,0,by=20),minor_breaks=c()) +
			coord_fixed(ratio=1)
		}

		ggsave(filename = file.path(sprintf("./output/clust_plots/%s_%d_%d",ne_type,norm_i,barad),sprintf("%s_%s_plot.png",nb_method,ind)), plot = fig1, width = 10, height = 8, units = "in")
#	print(fig1)
}

#
clust_stats = function(nb_method,ne_type,norm_i){
	# Runs all best cluster indices for nb_method agglomeration method

	load(sprintf("../data/%s_%d_neighbours.RData",ne_type,norm_i))

	#Available options for nb_method <- c("ward.D","ward.D2","single", "complete", "average", "mcquitty", "median", "centroid")

	ind_l<-c("kl", "ch", "hartigan", "cindex", "db", "silhouette", "ratkowsky", "ball", "sdbw")

	#Available options for ind_l <- c("kl", "ch", "hartigan", "ccc", "scott", "marriot", "trcovw", "tracew", "friedman", "rubin", "cindex", "db", "silhouette", "duda", "pseudot2", "beale", "ratkowsky", "ball", "ptbiserial", "frey", "mcclain", "gamma", "gplus", "tau", "dunn", "hubert", "sdindex", "dindex", "sdbw")
	
	## Based primarily on ward.D2
	#warning indices: ccc, scott, marriot (fails for complete), trcovw, tracew,  rubin
	#crashing indices:  ptbiserial (also complete)
	#erreaneous indices: friedman, pseudot2, beale, duda, frey (complete) 
	#extremelt slow indices: gap, gamma, gplus, tau, 
	#graphical indices: hubert, dindex

	## Single crashes
	# mcclain (also complete), dunn, frey, sdindex

	stats_out<-data.frame(method='NaN',index='NaN',nc=0,value=0)

	tic("All")
	j<-1
	for(i in ind_l){
		tic(sprintf('%s',i))
		clust_out <- NbClust(samples, max.nc=15, method = nb_method, index = i)
		stats_out[j,]=c(nb_method,i,clust_out$Best.nc[1],clust_out$Best.nc[2])
		j=j+1
		toc()
	}
	toc()

	print(stats_out)
	write_csv(stats_out,sprintf('../data/clust_stats/%s_%s_%d.csv',nb_method,ne_type,norm_i))
}

