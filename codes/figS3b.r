source("pattern_model_lib.R")

graphics.off()

# Parameters (defaults)
cs<-0.001	# Conditioning strength
cap<-"p" #"n"-negative feedback, "p"-positive feedback
cnd<-"l" #"l"-linear, "nl"-nonlinear
T<-5000	# Total time
	
sp_l<-c("A","B")	#Species list

set.seed(1)

# Initialization
xm<-50
ym<-20
N<- xm*ym	#Total stems - constant

sp0 <-sample(sp_l,size=N,replace=TRUE)		#Check if we can evenly divide
xy0<-cbind(rep(1:xm,each=ym),rep(1:ym,xm))

# Linear Environment
e0<-matrix(seq(from=0,to=1,length.out=xm),nrow=ym,ncol=xm,byrow=TRUE)

# Simulations
tic()
dat01<-pattern_model_2d(0.001,"n","l",sp0,e0,T)
dat02<-pattern_model_2d(0.001,"n","nl",sp0,e0,T)
toc()

# Patchy Environment
e1<-cbind(matrix(seq(from=0,to=0.3,length.out=xm/2),nrow=ym,ncol=xm/2,byrow=TRUE),matrix(seq(from=0.7,to=1,length.out=xm/2),nrow=ym,ncol=xm/2,byrow=TRUE))

# Simulations

tic()
dat11<-pattern_model_2d(0.001,"n","l",sp0,e1,T)
dat12<-pattern_model_2d(0.001,"n","nl",sp0,e1,T)
toc()

#Plots
fig01<-ggplot(dat01, aes(x = x, y = y)) + 
	geom_raster(aes(fill=env))+
	scale_fill_gradientn(colours=c("white","grey30"))+
	#scale_fill_gradientn(colours=c("#2A649C","#FFFFFF","#DDC046"))+
	geom_point(aes(shape=species))+
#	coord_fixed(ratio=3)+
	scale_shape_manual(values=c(1,16))+
	#scale_color_manual(values=c("white","black"))+
	ggtitle("Linear conditioning")+
	theme(legend.position="none")

fig02<-ggplot(dat02, aes(x = x, y = y)) + 
	geom_raster(aes(fill=env))+
	scale_fill_gradientn(colours=c("white","grey30"))+
	#scale_fill_gradientn(colours=c("#2A649C","#FFFFFF","#DDC046"))+
	geom_point(aes(shape=species))+
#	coord_fixed(ratio=3)+
	scale_shape_manual(values=c(1,16))+
	#scale_color_manual(values=c("white","black"))+
	ggtitle("Nonlinear conditioning")+
	theme(legend.position="none")

fig11<-ggplot(dat11, aes(x = x, y = y)) + 
	geom_raster(aes(fill=env))+
	scale_fill_gradientn(colours=c("white","grey30"))+
	#scale_fill_gradientn(colours=c("#2A649C","#FFFFFF","#DDC046"))+
	geom_point(aes(shape=species))+
#	coord_fixed(ratio=3)+
	scale_shape_manual(values=c(1,16))+
	#scale_color_manual(values=c("white","black"))+
	ggtitle("Linear conditioning")+
	theme(legend.position="none")

fig12<-ggplot(dat12, aes(x = x, y = y)) + 
	geom_raster(aes(fill=env))+
	scale_fill_gradientn(colours=c("white","grey30"))+
	#scale_fill_gradientn(colours=c("#2A649C","#FFFFFF","#DDC046"))+
	geom_point(aes(shape=species))+
#	coord_fixed(ratio=3)+
	scale_shape_manual(values=c(1,16))+
	#scale_color_manual(values=c("white","black"))+
	ggtitle("Nonlinear conditioning")+
	theme(legend.position="none")

fig<-grid.arrange(fig01,fig11,fig02,fig12,nrow=2)

ggsave(filename = file.path("./output","figS3b.png"), plot = fig, width = 18, height = 6, units = "in")
