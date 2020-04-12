
gini.coef.biased <- numeric(length = length(g.dat[,1])) # empty vector to put the coefficient in
#gini.coef.unbiased <- gini.coef.biased                  # second empty vector for unbiased version
for (i in 1:length(g.dat[,1])) {                        # open loop to go through each OTU (species)
  x <- as.numeric(g.dat[i,])                            # put species data in a vector, x
  x <- x[x>0]                                           # remove all absent species
  ox <- x[order(x)]                                     # sort species by abundance value
  a <- numeric(length = length(ox))                     # a = total number of species
  for (j in 1:length(ox)) {                           # within each sample loop through each abundance value
    a[j] <- (2*j-length(ox)-1)*ox[j]                  # inside brackets of eqn 3 in Damgaard and Weiner 2000
  }
  gini.coef.biased[i] <- sum(a)/((length(ox)^2)*mean(ox))                   # biased
  # gini.coef.unbiased[i] <- gini.coef.biased[i]*(length(ox)/(length(ox)-1))  # unbiased
}







#Sans avoir modifié davantage le fichier, l'imp orter dans R dans un objet nommé inegData
help(read.csv)
inegdata<-read.csv('/home/fayssal/R/R_project_M1_S2/donne2.csv',header=T)
head(inegdata)
