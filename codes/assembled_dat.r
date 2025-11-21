library(tidyverse)
library(oce)

## needs tree_soil.csv, ward.D2_ball_basal_1_20.csv, full_dat.csv, census_elevation

# Data frame with only necessary columns
fdat<-read_csv("../data/tree_soil.csv", show_col_types=FALSE)
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

cl_dat<-read_csv("../data/census_clust_out/ward.D2_ball_basal_1_20.csv", show_col_types=FALSE)
cdat<-add_column(cdat,as_tibble_col(cl_dat$Clusters_complete_silhouette,column_name="Clusters_id"))

cdat<-add_column(cdat,as_tibble_col(fdat$Land_use,column_name="Land_use"))
cdat<-add_column(cdat,as_tibble_col(fdat$MUSYM,column_name="Soil_type"))

fdat<-read_csv("../data/full_dat.csv", show_col_types=FALSE)
fdat$Species[is.na(fdat$Species)]<-"UNKNOWN"
fdat<-fdat[-which(fdat$Species=="Corner"),]
fdat<-fdat[-which(fdat$Species=="PAGGRA"),]
fdat<-fdat[-which(fdat$Species=="Ulmus sp."),]
fdat<-fdat[-which(fdat$Species=="PRUSP"),]
fdat<-fdat[-which(fdat$Species=="Carya sp."),]
fdat<-fdat[-which(fdat$Species=="ABCDE"),]
fdat<-fdat[-which(fdat$Species=="UNKNOWN"),]

cdat<-add_column(cdat,as_tibble_col(fdat$N18UTMFrom0313E,column_name="UTM18N_Easting"))
cdat<-add_column(cdat,as_tibble_col(fdat$N18UTMFrom0313N,column_name="UTM18N_Northing"))

lldat<-utm2lonlat(fdat$N18UTMFrom0313E,fdat$N18UTMFrom0313N,zone=18,hemisphere="N")

cdat<-add_column(cdat,as_tibble_col(lldat$longitude,column_name="Longitude"))
cdat<-add_column(cdat,as_tibble_col(lldat$latitude,column_name="Latitude"))

edat<-read_csv("../data/census_elevation.csv", show_col_types=FALSE)
edat<-edat[-which(edat$Species_code=="ABCDE"),]
edat<-edat[-which(edat$Species_code=="UNKNOWN"),]

cdat<-add_column(cdat,as_tibble_col(edat$Elevation,column_name="Elevation(m)"))
cdat<-add_column(cdat,as_tibble_col(fdat$DBH,column_name="DBH"))

write_csv(cdat,"../data/census_w_cluster.csv")
