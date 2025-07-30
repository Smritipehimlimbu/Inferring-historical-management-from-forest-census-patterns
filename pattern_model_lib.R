library(ggplot2)
library(gridExtra)
library(tictoc)

pattern_model_2d_0 = function(cs,cap,cnd,sp0,e0){

	# Parameters
	N<-length(sp0)
	m<- 0.1	# Mortality
	T<- 5000	#Total time steps

	if(cap=="n"){
		capt<-"A"
	}else{
		if(cap=="p"){
			capt<-"B"
		}else{
			stop("Invalid cap parameter")
		}
	}

	sp_l<-c("A","B")	#Species list

	sp<-sp0
	e<-e0

	for(i in 1:T){
		mt<-sample(1:N,size=m*N,replace=FALSE)
		for(j in mt){
	#		#print(c(i,j,sp[j],1-e[j],e[j]))
			sp[j]=sample(sp_l,size=1,prob=c(1-e[j],e[j]))
		}
		for(k in 1:N){
			if(cnd=="l"){
				e[k]=e[k]+cs*(as.numeric(sp[k]==capt)-e[k])
			}else{
				if(cnd=="nl"){
					if(sp[k]==capt){
						e[k]=e[k]+cs*e[k]*(1-e[k])
					}else{
						e[k]=e[k]-cs*e[k]*(1-e[k])
					}
				}else{
					stop("Invalid cnd parameter")
				}
			}
		}
	}

	dat<-data.frame(species=sp,x=xy0[,1],y=xy0[,2],env=c(e))

	return(dat)
}
