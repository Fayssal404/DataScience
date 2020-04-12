  

#Esperance et variance jouent un role inverse (i.e ce que je gagne en moyenne je perd en moyenne)

#Exercice 3

#Estimateur de theta est le ratio de la moyenne empirique de X et Y



























boottheta=function(X,Y,B)
{
  theta_chap=mean(X)/mean(Y)
  Xboot=replicate(B,sample(X,length(X),replace = T))
  Yboot=replicate(B,sample(Y,length(Y),replace = T))
  #on divise les 2 vecteurs apres avoire appliquer la moyenne.
  theta_boot=apply(Xboot,2,mean)/apply(Yboot,2,mean)
  c(theta_chap,theta_chap-mean(theta_boot-theta_chap))
}


X=rnorm(10)
Y=rpois(15,50)
B=50
boottheta(X,Y,B=50)


res=replicate(1000,boottheta(rexp(20,1/80),rexp(20,1/70),B=50))




Nfumeur=c(84,73,73,83,80,67,91,76,90,70,70,81,78,68,64,82,91,72,84,66)
fumeur=c(94,65,71,83,47,55,96,57,57,64,77,97,51,50,48,41,71,59,86,71)
B=1000
boottheta(Nfumeur,fumeur,B)

#Comme le rapport de la moyenne de durre de vie de non-fumeur et fumeur est superieur a 1 donc la durrée de vie de n-fumeur est en moyen supérieur à celle de fumeur.


Ic_asymptotique<-function(X,Y,conf){
  n<-length(X)
  theta_chapeau<-mean(X)/mean(Y)
  var_Z<-var(X)/(mean(Y)^2)+(mean(X)^2*var(Y))/mean(Y)^4
  c(theta_chapeau+qnorm(1-conf/2)*sqrt(var_Z/n),theta_chapeau-qnorm(1-conf/2)*sqrt(var_Z/n))
  
}


x<-rnorm(100)
y<-rpois(100,1.2)
b<-0.05

#Dans le bootstrap on utilise les quantiles empirique. 


Ic_bootstrap<-function(vec1,vec2,conf,B){
  alpha<-1-conf
  n<-length(vec1)
  theta_chapeau<-mean(vec1)/mean(vec2)
  Xboot<-replicate(B,sample(vec1,n,replace=T))
  Yboot<-replicate(B,sample(vec2,n,replace=T))
  theta_boot<-apply(Xboot,2,mean)/apply(Yboot,2,mean)
  eta_chapeau<-quantile(theta_boot-theta_chapeau,c(alpha/2,1-alpha/2),names=F)
  c(theta_chapeau-eta_chapeau[2],theta_chapeau-eta_chapeau[1])  
}

