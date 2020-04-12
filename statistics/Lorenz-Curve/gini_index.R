gini <- function(x, unbiased = TRUE, na.rm = FALSE){
  if (!is.numeric(x)){
    warning("'x' is not numeric; returning NA")
    return(NA)
  }
  if (!na.rm && any(na.ind <- is.na(x))) #verifi si au moin une des valeur associe a x n'est pas manquante
    stop("'x' contain NAs")#arret le programe et envoie un message d'erreur   
  if (na.rm) 
    x1 <- x[!na.ind] #une nouvelle variable qui prend x ou il y en aucune valeur manquante
  n <- length(x1)   #taille du vecteur
  mu <- mean(x1)     #moyenne du vecteur x1
  N <- if (unbiased) n * (n - 1) else n * n
  ox <- x1[order(x1)]
  dsum <- drop(crossprod(2 * 1:n - n - 1,  ox))
  dsum / (mu * N)
}

inegdata<-read.csv('/home/fayssal/R/R_project_M1_S2/donne2.csv',header=T)
gini(inegdata,T,T)
inegdata
help("row.names.data.frame")

storage<-numeric(nrow(inegdata))
storage

gini(inegdata)

for (i in 1:nrow(inegdata)){
storage[i]<-gini(inegdata[i,11],F,na.rm=T)
}
storage
=gini(inegdata[])

apply(as.matrix(inegdata$P95),1,gini)
class(inegdata$P95)
names(inegdata)
inegdata[,24]
which(colnames(inegdata)=="D1")

class(inegdata$Year)
for (i in 1:nrow(inegdata)){
ind_G<-c(ind_G,gini(rep(10,10),data.frame(t(inegdata[i,11:20]))
}


