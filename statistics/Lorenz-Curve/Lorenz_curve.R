gini<-function(x){
  if (!is.numeric(x[[1]]) || !is.numeric(x[[2]]) ){warning("elle n'est pas un data frame")
    return(NA)}
  x<-data.frame(x)
  vec1<-c(0,cumsum(x[[1]])) #pop_cumule
  vec2<-c(0,cumsum(x[[2]])) #ressource_cumule
  n<-length(vec1)
  gini<- (vec1[n]^2-sum((vec1[2:n]-vec1[1:(n-1)])*(vec2[2:n]+vec2[1:(n-1)])))
  return(gini/10000)
}

class(inegdata)
class(inegdata$D1)
# inegdata<-read.csv('/home/fayssal/R/R_project_M1_S2/donne2.csv',header=T)
# var<-data.frame(rep(10,10),inegdata[5,11:20])

gini(data.frame(rep(10,10),t(inegdata[5,11:20])))
class(x[1]) 
ind_G<-gini(data.frame(rep(10,10),t(inegdata[1,11:20])))
for (i in 2:nrow(inegdata)){
  ind_G<- c(ind_G,gini(data.frame(rep(10,10),t(inegdata[i,11:20]))))
}
ind_G

inegdata<-read.csv('/home/fayssal/R/R_project_M1_S2/donne2.csv',header=T)
# #nouvelle variable contenant les indice de gini contenant les pays,annees,Ind_G
# inegdata$Year
coun.year.g<-data.frame(inegdata$Country,inegdata$Year,ind_G)

# #creer une variable qui prend coun.year.g avec anne =2015
boub<-coun.year.g[coun.year.g[[2]]==2015,]
dim(boub[c(1,3)])
#indice de gini des pays europeen
europe_Gini<-read.csv('/home/fayssal/R/R_project_M1_S2/Eurostat_Table.csv',header = T)
help("read.csv")
#nouvelle variable sans les extra pays
var1<-europe_Gini[!europe_Gini$geo.time %in% c("Albania","Former Yugoslav Republic of Macedonia, the","Switzerland","Turkey","Montenegro","Ireland"),]
var1
fay2<-var1[c(1,11)]
fay2

help(in)
length(boub$ind_G)
dim(fay2)
fay2

#plot coefficient question 6 et question 4:
#n'oublie pas de multiplie l'axe d'abscice par 10^-2
plot(fay2$X2015,boub$ind_G*)

#fonction de Lorenz:
lorenz <- function(g.dat){   
  
  if(class(g.dat)=="data.frame") { g.dat <- t(g.dat) }  #verifi si g.dat est un data frame ,transpose devient une matrice...
  
  # Plot Lorenz curves
  # y = cumulative percent abundance
  # x = cumulative percent individuals
  
  plot(0,0,ylim=c(0,100),xlim=c(0,100),type="n",xlab="population cumulée en %",ylab="Ressources cumulée en %")     # trace un repere orthonome,type "n" c'est pour ne pas l'affiche
  abline(1,1)		#trace la premier bisectrice y=x

  for (i in 1:length(g.dat[,1])) {    #nombre des classe
    x <- as.numeric(g.dat[i,])
    x <- x[x>0]                      	# 	enleve les valeurs manquantes
    ox <- x[order(x)]	#	ordonne x par ordre decroissant
    ab <- c(0,cumsum(ox/sum(ox)*100))	#	contient la frequence cummule de x
    sp <- numeric(length=length(ox))	#	
    for (j in 1: length(ox)) {
      sp[j] <- (j/length(ox))*100
    }
    sp <- c(0,sp)
    lines(ab~sp,type="b")
  }
}

z1<-data.frame(rep(10,10),t(inegdata[5,11:20]))
z2<-data.frame(rep(10,10),t(inegdata[6,11:20]))
data.frame(rep(10,10),t(inegdata[5:8,11:20]))
apply(data.frame(rep(10,10),t(inegdata[5:8,11:20])),2,lorenz)


#question9:
similarite<-function(z1,z3){
integrate(z1*z2,lower= 0,upper= 1)/sqrt((integrate(z1*z1,lower= 0,upper= 1))*(integrate(z2*z2,lower= 0,upper= 1)))
return(similarite)
}

fa<-function(x){x^2}
fa2<-function(x){x/2}

similarite(fa(),fa2())
lorenz(data.frame(c(50,50),c(40,60)))