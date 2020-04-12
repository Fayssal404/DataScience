


#----------------------------n=10------------
#réplication bootstrap  
B <- 7000
n10<-10 

sigma <-1.4
X_1 <- runif(n10,5,10)
X_2 <- runif(n10,20,30)
X_3 <- rnorm(n10,4,1)
resid<-rnorm(n10,0,sigma)


#-------------------------Modèle simulé------------
Y10<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté
regression10 <-lm(Y10~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat10 <-regression10$coefficients
#L'écart type
st_dev_fit10 <-summary(regression10)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=10)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild10 <-matrix(nrow=length(beta_hat10),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild10 <-matrix(nrow=n10,ncol=B)
#Standard error for every coefficients
std_beta_normal_star10 <-matrix(nrow = length(beta_hat10),ncol = B)


for (i in 1:B) {
  #variable aléatoire poids
  W <-rnorm(n10)
  #Bootstrap des residus
  epsilon_star <- W*sample(regression10$residuals,n10,replace=TRUE)
  Y_star <-beta_hat10[1]+X_1*beta_hat10[2]+X_2*beta_hat10[3]+X_3*beta_hat10[4]+epsilon_star
  #le nouveau modéle ajusté
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild10[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild10[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star10[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}








#---------------------Wild Bootstrap (Radem weight, n=10)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild10 <-matrix(nrow=length(beta_hat10),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild10 <-matrix(nrow=n10,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star10 <-matrix(nrow = length(beta_hat10),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n10,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression10$residuals,n10,replace=TRUE)
  Y_star <-beta_hat10[1]+X_1*beta_hat10[2]+X_2*beta_hat10[3]+X_3*beta_hat10[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild10[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild10[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star10[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}





#---------------------Score Bootstrap (Normal weight, n=10)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score10<- matrix(nrow=length(beta_hat10),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)


#Calculer la Hessian du modèle
hessian10 <-(t(predictor) %*% predictor)/n10

#Matrix to keep track of perturbed residualds
pertur_Normal_res10 <-matrix(nrow=n10,ncol=B)
for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n10)
  #Calculer le score contributions perturber		
  perturbed_score10 <-(t(predictor) %*% (regression10$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score10[,m]<-solve(hessian10) %*% perturbed_score10/sqrt(n10)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res10[,m] <-regression10$residuals*z
}







#---------------------Score Bootstrap (Radem weight, n=10)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score10 <- matrix(nrow=length(beta_hat10),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res10 <-matrix(nrow=n10,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n10,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score10 <-(t(predictor) %*% (regression10$residuals*rad))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score10[,m]<-solve(hessian10) %*% perturbed_score10/sqrt(n10)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res10[,m] <-regression10$residuals*rad
}







#---------------------Statistique de test de,variance n=10--------------------------

T_Normal_wild10 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild10[j,] <- (beta_normal_wild10[j,]-beta_hat10[j])/std_beta_normal_star10[j,]
}

T_Radem_wild10 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild10[j,] <-(beta_Radem_wild10[j,]-beta_hat10[j])/std_beta_Radem_star10[j,]
}



Var_Normal_score10 <-matrix(nrow=length(beta_hat10),ncol=B)
for (i in 1:B){
  Var_Normal_score10[1,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[1,1]/n10
  Var_Normal_score10[2,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[2,2]/n10
  Var_Normal_score10[3,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[3,3]/n10
  Var_Normal_score10[4,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[4,4]/n10
  
}



Var_Radem_score10 <-matrix(nrow=length(beta_hat10),ncol=B)
for (i in 1:B){
  Var_Radem_score10[1,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[1,1]/n10
  Var_Radem_score10[2,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[2,2]/n10
  Var_Radem_score10[3,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[3,3]/n10
  Var_Radem_score10[4,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[4,4]/n10
  
}





#----------------------------n=50---------------------------------
n50<-50 

sigma <-1.4
X_1 <- runif(n50,5,10)
X_2 <- runif(n50,20,30)
X_3 <- rnorm(n50,4,1)
resid<-rnorm(n50,0,sigma)


#-------------------------Modèle simulé--------------------
Y50<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté
regression50 <-lm(Y50~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat50 <-regression50$coefficients
#L'écart type
st_dev_fit50 <-summary(regression50)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=50)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild50 <-matrix(nrow=length(beta_hat50),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild50 <-matrix(nrow=n50,ncol=B)
#Standard error for every coefficients
std_beta_normal_star50 <-matrix(nrow = length(beta_hat50),ncol = B)


for (i in 1:B) {
  W <-rnorm(n50)
  #Bootstrap des residus du modèle de regression
  epsilon_star <- W*sample(regression50$residuals,n50,replace=TRUE)
  Y_star <-beta_hat50[1]+X_1*beta_hat50[2]+X_2*beta_hat50[3]+X_3*beta_hat50[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild50[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild50[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star50[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}


#---------------------Wild Bootstrap (Radem weight, n=50)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild50 <-matrix(nrow=length(beta_hat50),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild50 <-matrix(nrow=n50,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star50 <-matrix(nrow = length(beta_hat50),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n50,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression50$residuals,n50,replace=TRUE)
  Y_star <-beta_hat50[1]+X_1*beta_hat50[2]+X_2*beta_hat50[3]+X_3*beta_hat50[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild50[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild50[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star50[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}





#---------------------Score Bootstrap (Normal weight, n=50)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score50<- matrix(nrow=length(beta_hat50),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)



#Calculer la Hessian du modèle
hessian50 <-(t(predictor) %*% predictor)/n50

#Matrix to keep track of perturbed residualds
pertur_Normal_res50 <-matrix(nrow=n50,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n50)
  #Calculer le score contributions perturber		
  perturbed_score50 <-(t(predictor) %*% (regression50$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score50[,m]<-solve(hessian50) %*% perturbed_score50/sqrt(n50)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res50[,m] <-regression50$residuals*z
}







#---------------------Score Bootstrap (Radem weight, n=50)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score50 <- matrix(nrow=length(beta_hat50),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res50 <-matrix(nrow=n50,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n50,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score50 <-(t(predictor) %*% (regression50$residuals*rad))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score50[,m]<-solve(hessian50) %*% perturbed_score50/sqrt(n50)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res50[,m] <-regression50$residuals*rad
}







#---------------------Statistique de test de,variance n=50--------------------------

T_Normal_wild50 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild50[j,] <- (beta_normal_wild50[j,]-beta_hat50[j])/std_beta_normal_star50[j,]
}

T_Radem_wild50 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild50[j,] <-(beta_Radem_wild50[j,]-beta_hat50[j])/std_beta_Radem_star50[j,]
}



Var_Normal_score50 <-matrix(nrow=length(beta_hat50),ncol=B)
for (i in 1:B){
  Var_Normal_score50[1,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[1,1]/n50
  Var_Normal_score50[2,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[2,2]/n50
  Var_Normal_score50[3,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[3,3]/n50
  Var_Normal_score50[4,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[4,4]/n50
  
}



Var_Radem_score50 <-matrix(nrow=length(beta_hat50),ncol=B)
for (i in 1:B){
  Var_Radem_score50[1,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[1,1]/n50
  Var_Radem_score50[2,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[2,2]/n50
  Var_Radem_score50[3,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[3,3]/n50
  Var_Radem_score50[4,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[4,4]/n50
  
}







#-----------------------------n=100--------------------
n100<-100 

sigma <-1.4
X_1 <- runif(n100,5,10)
X_2 <- runif(n100,20,30)
X_3 <- rnorm(n100,4,1)
resid<-rnorm(n100,0,sigma)


#-------------------------Modèle simulé, n=100
Y100<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté, n=100
regression100 <-lm(Y100~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat100 <-regression100$coefficients
#L'écart type
st_dev_fit100 <-summary(regression100)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=100)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild100 <-matrix(nrow=length(beta_hat100),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild100 <-matrix(nrow=n100,ncol=B)
#Standard error for every coefficients
std_beta_normal_star100 <-matrix(nrow = length(beta_hat100),ncol = B)


for (i in 1:B) {
  W <-rnorm(n100)
  #Bootstrap des residus du modèle de regression
  epsilon_star <- W*sample(regression100$residuals,n100,replace=TRUE)
  Y_star <-beta_hat100[1]+X_1*beta_hat100[2]+X_2*beta_hat100[3]+X_3*beta_hat100[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild100[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild100[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star100[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}


#---------------------Wild Bootstrap (Radem weight, n=100)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild100 <-matrix(nrow=length(beta_hat100),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild100 <-matrix(nrow=n100,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star100 <-matrix(nrow = length(beta_hat100),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n100,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression100$residuals,n100,replace=TRUE)
  Y_star <-beta_hat100[1]+X_1*beta_hat100[2]+X_2*beta_hat100[3]+X_3*beta_hat100[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild100[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild100[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star100[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}




























































#---------------------Score Bootstrap (Normal weight, n=100)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score100<- matrix(nrow=length(beta_hat100),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)

#Calculer la Hessian du modèle
hessian100 <-(t(predictor) %*% predictor)/n100

#Matrix to keep track of perturbed residualds
pertur_Normal_res100 <-matrix(nrow=n100,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n100)
  #Calculer le score contributions perturber		
  perturbed_score100 <-(t(predictor) %*% (regression100$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score100[,m]<-solve(hessian100) %*% perturbed_score100/sqrt(n100)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res100[,m] <-regression100$residuals*z
}





#---------------------Score Bootstrap (Radem weight, n=100)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score100 <- matrix(nrow=length(beta_hat100),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res100 <-matrix(nrow=n100,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n100,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score100 <-(t(predictor) %*% (regression100$residuals*rad))
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score100[,m]<-solve(hessian100) %*% perturbed_score100/sqrt(n100)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res100[,m] <-regression100$residuals*rad
}







#---------------------Statistique de test de,variance n=100--------------------------

T_Normal_wild100 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild100[j,] <- (beta_normal_wild100[j,]-beta_hat100[j])/std_beta_normal_star100[j,]
}

T_Radem_wild100 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild100[j,] <-(beta_Radem_wild100[j,]-beta_hat100[j])/std_beta_Radem_star100[j,]
}


#Score :$T^{\star s}_n=(H^{-1}_n\Sigm^{\star}_n(\hat\beta) H^{-1}_n)\frac{1}{\sqrt{n}} \sum_{i=1}^{n}X_i\epsilon^{\sta}_i$.

#Ces deux statistiques sont studentariser, On remarque que pour calculer $T^{\star$T^{\star s}_n$ on utilise l'estimateur des moindres carrés $\hat\beta$ dont le bootstrap $\hat\beta^{\star}$ et les résidus vont pas nous servire. Dans la version studentariser les deux statistiques ne sont pas numériquement équivalente. Mais la différence entre wild et score bootstrap sont assymptotiquement négligeable.

Var_Normal_score100 <-matrix(nrow=length(beta_hat100),ncol=B)
for (i in 1:B){
  Var_Normal_score100[1,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[1,1]/n100
  Var_Normal_score100[2,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[2,2]/n100
  Var_Normal_score100[3,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[3,3]/n100
  Var_Normal_score100[4,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[4,4]/n100
  
}



Var_Radem_score100 <-matrix(nrow=length(beta_hat100),ncol=B)
for (i in 1:B){
  Var_Radem_score100[1,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[1,1]/n100
  Var_Radem_score100[2,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[2,2]/n100
  Var_Radem_score100[3,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[3,3]/n100
  Var_Radem_score100[4,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[4,4]/n100
  
}


#-------------------------------------n=200--------------
n200<-200 

sigma <-1.4
X_1 <- runif(n200,5,10)
X_2 <- runif(n200,20,30)
X_3 <- rnorm(n200,4,1)
resid<-rnorm(n200,0,sigma)


#-------------------------Modèle simulé, n=200-----------------
Y200<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté, n=200
regression200 <-lm(Y200~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat200 <-regression200$coefficients
#L'écart type
st_dev_fit200 <-summary(regression200)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=200)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild200 <-matrix(nrow=length(beta_hat200),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild200 <-matrix(nrow=n200,ncol=B)
#Standard error for every coefficients
std_beta_normal_star200 <-matrix(nrow = length(beta_hat200),ncol = B)


for (i in 1:B) {
  W <-rnorm(n200)
  #Bootstrap des residus du modèle de regression
  epsilon_star <- W*sample(regression100$residuals,n200,replace=TRUE)
  Y_star <-beta_hat200[1]+X_1*beta_hat200[2]+X_2*beta_hat200[3]+X_3*beta_hat200[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild200[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild200[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star200[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}


#---------------------Wild Bootstrap (Radem weight, n=200)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild200 <-matrix(nrow=length(beta_hat200),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild200 <-matrix(nrow=n200,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star200 <-matrix(nrow = length(beta_hat200),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n200,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression200$residuals,n200,replace=TRUE)
  Y_star <-beta_hat200[1]+X_1*beta_hat200[2]+X_2*beta_hat200[3]+X_3*beta_hat200[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild200[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild200[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star200[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}




























































#---------------------Score Bootstrap (Normal weight, n=200)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score200<- matrix(nrow=length(beta_hat200),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)

#Calculer la Hessian du modèle
hessian200 <-(t(predictor) %*% predictor)/n200

#Matrix to keep track of perturbed residualds
pertur_Normal_res200 <-matrix(nrow=n200,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n200)
  #Calculer le score contributions perturber		
  perturbed_score200 <-(t(predictor) %*% (regression200$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score200[,m]<-solve(hessian200) %*% perturbed_score200/sqrt(n200)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res200[,m] <-regression200$residuals*z
}






#---------------------Score Bootstrap (Radem weight, n=200)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score200 <- matrix(nrow=length(beta_hat200),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res200 <-matrix(nrow=n200,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n200,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score200 <-(t(predictor) %*% (regression200$residuals*rad))
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score200[,m]<-solve(hessian200) %*% perturbed_score200/sqrt(n200)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res200[,m] <-regression200$residuals*rad
}







#---------------------Statistique de test de,variance n=200--------------------------

T_Normal_wild200 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild200[j,] <- (beta_normal_wild200[j,]-beta_hat200[j])/std_beta_normal_star200[j,]
}

T_Radem_wild200 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild200[j,] <-(beta_Radem_wild200[j,]-beta_hat200[j])/std_beta_Radem_star200[j,]
}



Var_Normal_score200 <-matrix(nrow=length(beta_hat200),ncol=B)
for (i in 1:B){
  Var_Normal_score200[1,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[1,1]/n200
  Var_Normal_score200[2,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[2,2]/n200
  Var_Normal_score200[3,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[3,3]/n200
  Var_Normal_score200[4,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[4,4]/n200
  
}



Var_Radem_score200 <-matrix(nrow=length(beta_hat200),ncol=B)
for (i in 1:B){
  Var_Radem_score200[1,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[1,1]/n200
  Var_Radem_score200[2,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[2,2]/n200
  Var_Radem_score200[3,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[3,3]/n200
  Var_Radem_score200[4,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[4,4]/n200
  
}




c200<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild200[4,i]**2>qchisq(1-0.05,1)) (c200[1] <-c200[1]+1/B)
  if (T_Radem_wild200[4,i]**2>qchisq(1-0.05,1)) (c200[2] <-c200[2]+1/B)
  if ((beta_Normal_score200[4,i]/sqrt(mean(Var_Normal_score200[4,])))**2>qchisq(1-0.05,1)) (c200[3] <-c200[3]+1/B)
  if ((beta_Radem_score200[4,i]/sqrt(mean(Var_Radem_score200[4,])))**2>qchisq(1-0.05,1)) (c200[4] <-c200[4]+1/B)
  
  
}




c100<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild100[4,i]**2>qchisq(1-0.05,1)) (c100[1] <-c100[1]+1/B)
  if (T_Radem_wild100[4,i]**2>qchisq(1-0.05,1)) (c100[2] <-c100[2]+1/B)
  if ((beta_Normal_score100[4,i]/sqrt(mean(Var_Normal_score100[4,])))**2>qchisq(1-0.05,1)) (c100[3] <-c100[3]+1/B)
  if ((beta_Radem_score100[4,i]/sqrt(mean(Var_Radem_score100[4,])))**2>qchisq(1-0.05,1)) (c100[4] <-c100[4]+1/B)
  
  
}



c50<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild50[4,i]**2>qchisq(1-0.05,1)) (c50[1] <-c50[1]+1/B)
  if (T_Radem_wild50[4,i]**2>qchisq(1-0.05,1)) (c50[2] <-c50[2]+1/B)
  if ((beta_Normal_score50[4,i]/sqrt(mean(Var_Normal_score50[4,])))**2>qchisq(1-0.05,1)) (c50[3] <-c50[3]+1/B)
  if ((beta_Radem_score50[4,i]/sqrt(mean(Var_Radem_score50[4,])))**2>qchisq(1-0.05,1)) (c50[4] <-c50[4]+1/B)
  
  
}



c10<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild10[4,i]**2>qchisq(1-0.05,1)) (c10[1] <-c10[1]+1/B)
  if (T_Radem_wild10[4,i]**2>qchisq(1-0.05,1)) (c10[2] <-c10[2]+1/B)
  if ((beta_Normal_score10[4,i]/sqrt(mean(Var_Normal_score10[4,])))**2>qchisq(1-0.05,1)) (c10[3] <-c10[3]+1/B)
  if ((beta_Radem_score10[4,i]/sqrt(mean(Var_Radem_score10[4,])))**2>qchisq(1-0.05,1)) (c10[4] <-c10[4]+1/B)
  
}

DT2 <- data.frame(c("Normal.wild","Radem.wild","Normal.score","Radem.score"),c10,c50,c100,c200)
colnames(DT2) <-c("Loi de W","n=10","n=50","n=100","n=200")






























#------------------------modèle Hétéroscédastique-----------

#----------------------------n=10------------
n10<-10 

X_1 <- runif(n10,5,10)
X_2 <- runif(n10,20,30)
X_3 <- rnorm(n10,4,1)
resid<-rnorm(n10,0,rexp(n10,0.5))


#-------------------------Modèle simulé------------
Y10<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté
regression10 <-lm(Y10~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat10 <-regression10$coefficients
#L'écart type
st_dev_fit10 <-summary(regression10)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=10)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild10 <-matrix(nrow=length(beta_hat10),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild10 <-matrix(nrow=n10,ncol=B)
#Standard error for every coefficients
std_beta_normal_star10 <-matrix(nrow = length(beta_hat10),ncol = B)


for (i in 1:B) {
  #variable aléatoire poids
  W <-rnorm(n10)
  #Bootstrap des residus
  epsilon_star <- W*sample(regression10$residuals,n10,replace=TRUE)
  Y_star <-beta_hat10[1]+X_1*beta_hat10[2]+X_2*beta_hat10[3]+X_3*beta_hat10[4]+epsilon_star
  #le nouveau modéle ajusté
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild10[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild10[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star10[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}








#---------------------Wild Bootstrap (Radem weight, n=10)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild10 <-matrix(nrow=length(beta_hat10),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild10 <-matrix(nrow=n10,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star10 <-matrix(nrow = length(beta_hat10),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n10,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression10$residuals,n10,replace=TRUE)
  Y_star <-beta_hat10[1]+X_1*beta_hat10[2]+X_2*beta_hat10[3]+X_3*beta_hat10[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild10[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild10[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star10[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}





#---------------------Score Bootstrap (Normal weight, n=10)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score10<- matrix(nrow=length(beta_hat10),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)


#Calculer la Hessian du modèle
hessian10 <-(t(predictor) %*% predictor)/n10

#Matrix to keep track of perturbed residualds
pertur_Normal_res10 <-matrix(nrow=n10,ncol=B)
for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n10)
  #Calculer le score contributions perturber		
  perturbed_score10 <-(t(predictor) %*% (regression10$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score10[,m]<-solve(hessian10) %*% perturbed_score10/sqrt(n10)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res10[,m] <-regression10$residuals*z
}







#---------------------Score Bootstrap (Radem weight, n=10)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score10 <- matrix(nrow=length(beta_hat10),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res10 <-matrix(nrow=n10,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n10,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score10 <-(t(predictor) %*% (regression10$residuals*rad))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score10[,m]<-solve(hessian10) %*% perturbed_score10/sqrt(n10)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res10[,m] <-regression10$residuals*rad
}







#---------------------Statistique de test de, variance n=10--------------------------

T_Normal_wild10 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild10[j,] <- (beta_normal_wild10[j,]-beta_hat10[j])/std_beta_normal_star10[j,]
}

T_Radem_wild10 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild10[j,] <-(beta_Radem_wild10[j,]-beta_hat10[j])/std_beta_Radem_star10[j,]
}



Var_Normal_score10 <-matrix(nrow=length(beta_hat10),ncol=B)
for (i in 1:B){
  Var_Normal_score10[1,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[1,1]/n10
  Var_Normal_score10[2,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[2,2]/n10
  Var_Normal_score10[3,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[3,3]/n10
  Var_Normal_score10[4,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Normal_res10[,i] %*% t(pertur_Normal_res10[,i]))%*% predictor %*% solve(hessian10))[4,4]/n10
  
}



Var_Radem_score10 <-matrix(nrow=length(beta_hat10),ncol=B)
for (i in 1:B){
  Var_Radem_score10[1,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[1,1]/n10
  Var_Radem_score10[2,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[2,2]/n10
  Var_Radem_score10[3,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[3,3]/n10
  Var_Radem_score10[4,i]<-(solve(hessian10)  %*% t(predictor)%*%(pertur_Radem_res10[,i] %*% t(pertur_Radem_res10[,i]))%*% predictor %*% solve(hessian10))[4,4]/n10
  
}





#----------------------------n=50---------------------------------
n50<-50 

X_1 <- runif(n50,5,10)
X_2 <- runif(n50,20,30)
X_3 <- rnorm(n50,4,1)
resid<-rnorm(n50,0,rexp(n50,0.5))


#-------------------------Modèle simulé--------------------
Y50<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté
regression50 <-lm(Y50~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat50 <-regression50$coefficients
#L'écart type
st_dev_fit50 <-summary(regression50)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=50)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild50 <-matrix(nrow=length(beta_hat50),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild50 <-matrix(nrow=n50,ncol=B)
#Standard error for every coefficients
std_beta_normal_star50 <-matrix(nrow = length(beta_hat50),ncol = B)


for (i in 1:B) {
  W <-rnorm(n50)
  #Bootstrap des residus du modèle de regression
  epsilon_star <- W*sample(regression50$residuals,n50,replace=TRUE)
  Y_star <-beta_hat50[1]+X_1*beta_hat50[2]+X_2*beta_hat50[3]+X_3*beta_hat50[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild50[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild50[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star50[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}


#---------------------Wild Bootstrap (Radem weight, n=50)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild50 <-matrix(nrow=length(beta_hat50),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild50 <-matrix(nrow=n50,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star50 <-matrix(nrow = length(beta_hat50),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n50,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression50$residuals,n50,replace=TRUE)
  Y_star <-beta_hat50[1]+X_1*beta_hat50[2]+X_2*beta_hat50[3]+X_3*beta_hat50[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild50[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild50[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star50[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}





#---------------------Score Bootstrap (Normal weight, n=50)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score50<- matrix(nrow=length(beta_hat50),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)



#Calculer la Hessian du modèle
hessian50 <-(t(predictor) %*% predictor)/n50

#Matrix to keep track of perturbed residualds
pertur_Normal_res50 <-matrix(nrow=n50,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n50)
  #Calculer le score contributions perturber		
  perturbed_score50 <-(t(predictor) %*% (regression50$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score50[,m]<-solve(hessian50) %*% perturbed_score50/sqrt(n50)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res50[,m] <-regression50$residuals*z
}







#---------------------Score Bootstrap (Radem weight, n=50)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score50 <- matrix(nrow=length(beta_hat50),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res50 <-matrix(nrow=n50,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n50,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score50 <-(t(predictor) %*% (regression50$residuals*rad))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score50[,m]<-solve(hessian50) %*% perturbed_score50/sqrt(n50)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res50[,m] <-regression50$residuals*rad
}







#---------------------Statistique de test de, variance n=50--------------------------

T_Normal_wild50 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild50[j,] <- (beta_normal_wild50[j,]-beta_hat50[j])/std_beta_normal_star50[j,]
}

T_Radem_wild50 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild50[j,] <-(beta_Radem_wild50[j,]-beta_hat50[j])/std_beta_Radem_star50[j,]
}



Var_Normal_score50 <-matrix(nrow=length(beta_hat50),ncol=B)
for (i in 1:B){
  Var_Normal_score50[1,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[1,1]/n50
  Var_Normal_score50[2,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[2,2]/n50
  Var_Normal_score50[3,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[3,3]/n50
  Var_Normal_score50[4,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Normal_res50[,i] %*% t(pertur_Normal_res50[,i]))%*% predictor %*% solve(hessian50))[4,4]/n50
  
}



Var_Radem_score50 <-matrix(nrow=length(beta_hat50),ncol=B)
for (i in 1:B){
  Var_Radem_score50[1,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[1,1]/n50
  Var_Radem_score50[2,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[2,2]/n50
  Var_Radem_score50[3,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[3,3]/n50
  Var_Radem_score50[4,i]<-(solve(hessian50)  %*% t(predictor)%*%(pertur_Radem_res50[,i] %*% t(pertur_Radem_res50[,i]))%*% predictor %*% solve(hessian50))[4,4]/n50
  
}







#------------------------------------n=100-------------
n100<-100 

X_1 <- runif(n100,5,10)
X_2 <- runif(n100,20,30)
X_3 <- rnorm(n100,4,1)
resid<-rnorm(n100,0,rexp(n100,0.5))


#-------------------------Modèle simulé, n=100
Y100<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté, n=100
regression100 <-lm(Y100~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat100 <-regression100$coefficients
#L'écart type
st_dev_fit100 <-summary(regression100)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=100)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild100 <-matrix(nrow=length(beta_hat100),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild100 <-matrix(nrow=n100,ncol=B)
#Standard error for every coefficients
std_beta_normal_star100 <-matrix(nrow = length(beta_hat100),ncol = B)


for (i in 1:B) {
  W <-rnorm(n100)
  #Bootstrap des residus du modèle de regression
  epsilon_star <- W*sample(regression100$residuals,n100,replace=TRUE)
  Y_star <-beta_hat100[1]+X_1*beta_hat100[2]+X_2*beta_hat100[3]+X_3*beta_hat100[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild100[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild100[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star100[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}


#---------------------Wild Bootstrap (Radem weight, n=100)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild100 <-matrix(nrow=length(beta_hat100),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild100 <-matrix(nrow=n100,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star100 <-matrix(nrow = length(beta_hat100),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n100,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression100$residuals,n100,replace=TRUE)
  Y_star <-beta_hat100[1]+X_1*beta_hat100[2]+X_2*beta_hat100[3]+X_3*beta_hat100[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild100[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild100[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star100[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}




























































#---------------------Score Bootstrap (Normal weight, n=100)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score100<- matrix(nrow=length(beta_hat100),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)

#Calculer la Hessian du modèle
hessian100 <-(t(predictor) %*% predictor)/n100

#Matrix to keep track of perturbed residualds
pertur_Normal_res100 <-matrix(nrow=n100,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n100)
  #Calculer le score contributions perturber		
  perturbed_score100 <-(t(predictor) %*% (regression100$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score100[,m]<-solve(hessian100) %*% perturbed_score100/sqrt(n100)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res100[,m] <-regression100$residuals*z
}


#L'avantage de score bootstrap c'est qu'il est aussi généraliser pour les modèle généraliser, il est plus simple à implementer;





#---------------------Score Bootstrap (Radem weight, n=100)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score100 <- matrix(nrow=length(beta_hat100),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res100 <-matrix(nrow=n100,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n100,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score100 <-(t(predictor) %*% (regression100$residuals*rad))
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score100[,m]<-solve(hessian100) %*% perturbed_score100/sqrt(n100)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res100[,m] <-regression100$residuals*rad
}







#---------------------Statistique de test de, variance n=100--------------------------

T_Normal_wild100 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild100[j,] <- (beta_normal_wild100[j,]-beta_hat100[j])/std_beta_normal_star100[j,]
}

T_Radem_wild100 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild100[j,] <-(beta_Radem_wild100[j,]-beta_hat100[j])/std_beta_Radem_star100[j,]
}


Var_Normal_score100 <-matrix(nrow=length(beta_hat100),ncol=B)
for (i in 1:B){
  Var_Normal_score100[1,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[1,1]/n100
  Var_Normal_score100[2,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[2,2]/n100
  Var_Normal_score100[3,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[3,3]/n100
  Var_Normal_score100[4,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Normal_res100[,i] %*% t(pertur_Normal_res100[,i]))%*% predictor %*% solve(hessian100))[4,4]/n100
  
}



Var_Radem_score100 <-matrix(nrow=length(beta_hat100),ncol=B)
for (i in 1:B){
  Var_Radem_score100[1,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[1,1]/n100
  Var_Radem_score100[2,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[2,2]/n100
  Var_Radem_score100[3,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[3,3]/n100
  Var_Radem_score100[4,i]<-(solve(hessian100)  %*% t(predictor)%*%(pertur_Radem_res100[,i] %*% t(pertur_Radem_res100[,i]))%*% predictor %*% solve(hessian100))[4,4]/n100
  
}


#-------------------------------------n=200--------------
n200<-200 

X_1 <- runif(n200,5,10)
X_2 <- runif(n200,20,30)
X_3 <- rnorm(n200,4,1)
resid<-rnorm(n200,0,rexp(n200,0.5))


#-------------------------Modèle simulé, n=200-----------------
Y200<-1+X_1+X_2+0*X_3+resid

#Le modèle de regression linéaire ajusté, n=200
regression200 <-lm(Y200~X_1+X_2+X_3)
#Les coefficients estimés
beta_hat200 <-regression200$coefficients
#L'écart type
st_dev_fit200 <-summary(regression200)$coefficients[,"Std. Error"]

#---------------------Wild Bootstrap (Normal weight, n=200)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_normal_wild200 <-matrix(nrow=length(beta_hat200),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_normal_wild200 <-matrix(nrow=n200,ncol=B)
#Standard error for every coefficients
std_beta_normal_star200 <-matrix(nrow = length(beta_hat200),ncol = B)


for (i in 1:B) {
  W <-rnorm(n200)
  #Bootstrap des residus du modèle de regression
  epsilon_star <- W*sample(regression100$residuals,n200,replace=TRUE)
  Y_star <-beta_hat200[1]+X_1*beta_hat200[2]+X_2*beta_hat200[3]+X_3*beta_hat200[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_normal_wild200[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_normal_wild200[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_normal_star200[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}


#---------------------Wild Bootstrap (Radem weight, n=200)--------------------------

#Matrice pour stocker les bootstraps des coefficients pour le nouveau modèle de régression de la variable Y_star
beta_Radem_wild200 <-matrix(nrow=length(beta_hat200),ncol=B)
#Matrice pour stocker les residus pour le nouveau modèle de regression de Y_star
residu_Radem_wild200 <-matrix(nrow=n200,ncol=B)
#Standard error for every coefficients
std_beta_Radem_star200 <-matrix(nrow = length(beta_hat200),ncol = B)


for (i in 1:B) {
  #Generer un vecteur aléatoire 1,-1 avec une proba =1/2
  Ra <-2*rbinom(n200,1,prob=0.5)-1
  #Bootstrap des residus du modèle de regression
  epsilon_star <- Ra*sample(regression200$residuals,n200,replace=TRUE)
  Y_star <-beta_hat200[1]+X_1*beta_hat200[2]+X_2*beta_hat200[3]+X_3*beta_hat200[4]+epsilon_star
  #On calcule le nouveau modéle de regression
  regression_new <- lm(Y_star~X_1+X_2+X_3)
  #Chaque colonne de cette matrice représente les coefficients de nouveau modèle
  beta_Radem_wild200[,i]<-regression_new$coefficients
  #Chaque colonne de cette matrice représente les nouvelles valeures des résidus
  residu_Radem_wild200[,i]<-regression_new$residuals
  #les valeurs de l'écart-type estimé de beta chapeau star
  std_beta_Radem_star200[,i]<-summary(regression_new)$coefficients[,"Std. Error"]
}




























































#---------------------Score Bootstrap (Normal weight, n=200)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Normal_score200<- matrix(nrow=length(beta_hat200),ncol=B)

#Matrice des prédicteurs linéaire
predictor <- cbind(1,X_1,X_2,X_3)

#Calculer la Hessian du modèle
hessian200 <-(t(predictor) %*% predictor)/n200

#Matrix to keep track of perturbed residualds
pertur_Normal_res200 <-matrix(nrow=n200,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  #Chaque colonne réprésente un nouveau vecteur generer
  z <-rnorm(n200)
  #Calculer le score contributions perturber		
  perturbed_score200 <-(t(predictor) %*% (regression200$residuals*z))	
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Normal_score200[,m]<-solve(hessian200) %*% perturbed_score200/sqrt(n200)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Normal_res200[,m] <-regression200$residuals*z
}


#L'avantage de score bootstrap c'est qu'il est aussi généraliser pour les modèle généraliser, il est plus simple à implementer;





#---------------------Score Bootstrap (Radem weight, n=200)--------------------------
#Matrice pour stocker les valeurs de l'étape 4
beta_Radem_score200 <- matrix(nrow=length(beta_hat200),ncol=B)

#Matrix to keep track of perturbed residualds
pertur_Radem_res200 <-matrix(nrow=n200,ncol=B)

for (m in 1:B) {
  #Générer une variable aléatoire Z qui représente les poids de perturbations.
  rad <-2*rbinom(n200,1,prob=0.5)
  #Calculer le score contributions perturber		
  perturbed_score200 <-(t(predictor) %*% (regression200$residuals*rad))
  #On multiplie par l'inverse de la matrice Hessienne
  beta_Radem_score200[,m]<-solve(hessian200) %*% perturbed_score200/sqrt(n200)
  #Stocker les valeurs des residus multiplier par une variable aléatoire z qui suit une loi normal
  pertur_Radem_res200[,m] <-regression200$residuals*rad
}







#---------------------Statistique de test de, variance n=200--------------------------

T_Normal_wild200 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Normal_wild200[j,] <- (beta_normal_wild200[j,]-beta_hat200[j])/std_beta_normal_star200[j,]
}

T_Radem_wild200 <- matrix(nrow=4, ncol=B)
for (j in 1:4){
  T_Radem_wild200[j,] <-(beta_Radem_wild200[j,]-beta_hat200[j])/std_beta_Radem_star200[j,]
}


Var_Normal_score200 <-matrix(nrow=length(beta_hat200),ncol=B)
for (i in 1:B){
  Var_Normal_score200[1,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[1,1]/n200
  Var_Normal_score200[2,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[2,2]/n200
  Var_Normal_score200[3,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[3,3]/n200
  Var_Normal_score200[4,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Normal_res200[,i] %*% t(pertur_Normal_res200[,i]))%*% predictor %*% solve(hessian100))[4,4]/n200
  
}



Var_Radem_score200 <-matrix(nrow=length(beta_hat200),ncol=B)
for (i in 1:B){
  Var_Radem_score200[1,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[1,1]/n200
  Var_Radem_score200[2,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[2,2]/n200
  Var_Radem_score200[3,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[3,3]/n200
  Var_Radem_score200[4,i]<-(solve(hessian200)  %*% t(predictor)%*%(pertur_Radem_res200[,i] %*% t(pertur_Radem_res200[,i]))%*% predictor %*% solve(hessian200))[4,4]/n200
  
}




c200<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild200[4,i]**2>qchisq(1-0.05,1)) (c200[1] <-c200[1]+1/B)
  if (T_Radem_wild200[4,i]**2>qchisq(1-0.05,1)) (c200[2] <-c200[2]+1/B)
  if ((beta_Normal_score200[4,i]/sqrt(mean(Var_Normal_score200[4,])))**2>qchisq(1-0.05,1)) (c200[3] <-c200[3]+1/B)
  if ((beta_Radem_score200[4,i]/sqrt(mean(Var_Radem_score200[4,])))**2>qchisq(1-0.05,1)) (c200[4] <-c200[4]+1/B)
  
  
}




c100<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild100[4,i]**2>qchisq(1-0.05,1)) (c100[1] <-c100[1]+1/B)
  if (T_Radem_wild100[4,i]**2>qchisq(1-0.05,1)) (c100[2] <-c100[2]+1/B)
  if ((beta_Normal_score100[4,i]/sqrt(mean(Var_Normal_score100[4,])))**2>qchisq(1-0.05,1)) (c100[3] <-c100[3]+1/B)
  if ((beta_Radem_score100[4,i]/sqrt(mean(Var_Radem_score100[4,])))**2>qchisq(1-0.05,1)) (c100[4] <-c100[4]+1/B)
  
  
}



c50<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild50[4,i]**2>qchisq(1-0.05,1)) (c50[1] <-c50[1]+1/B)
  if (T_Radem_wild50[4,i]**2>qchisq(1-0.05,1)) (c50[2] <-c50[2]+1/B)
  if ((beta_Normal_score50[4,i]/sqrt(mean(Var_Normal_score50[4,])))**2>qchisq(1-0.05,1)) (c50[3] <-c50[3]+1/B)
  if ((beta_Radem_score50[4,i]/sqrt(mean(Var_Radem_score50[4,])))**2>qchisq(1-0.05,1)) (c50[4] <-c50[4]+1/B)
  
  
}



c10<-vector(mode="numeric",length=4)

for (i in 1:B){
  if (T_Normal_wild10[4,i]**2>qchisq(1-0.05,1)) (c10[1] <-c10[1]+1/B)
  if (T_Radem_wild10[4,i]**2>qchisq(1-0.05,1)) (c10[2] <-c10[2]+1/B)
  if ((beta_Normal_score10[4,i]/sqrt(mean(Var_Normal_score10[4,])))**2>qchisq(1-0.05,1)) (c10[3] <-c10[3]+1/B)
  if ((beta_Radem_score10[4,i]/sqrt(mean(Var_Radem_score10[4,])))**2>qchisq(1-0.05,1)) (c10[4] <-c10[4]+1/B)
  
}

DT3 <- data.frame(c("Normal.wild","Radem.wild","Normal.score","Radem.score"),c10,c50,c100,c200)
colnames(DT3) <-c("Loi de W","n=10","n=50","n=100","n=200")





























