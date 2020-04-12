

# Pearson-type goodness-of-fit test with bootstrap maximum likelihood estimation

# What is a Goodness to fit test?
The goodness of fit test is used to test if sample data fits a distribution from a certain population
(i.e. a population with a normal distribution or one with a Weibull distribution).In other words,
it tells you if your sample data represents the data you would expect to find in the actual population.

Two potential disadvantages of chi square are:

   1. The chi square test can only be used for data put into classes (bins). If you have non-binned data you’ll need to make a frequency table or histogram before performing the test.
   2. Another disadvantage of the chi-square test is that it requires a sufficient sample size in order for the chi-square approximation to be valid.

The null hypothesis for the chi-square goodness of fit test is that the data comes from a specified distribution.
The alternate hypothesis is that the data does not come from a specified distribution.

# What is model misspecification?
   1. Model Misspecification is where the model you made with regression analysis is in error. In other words, it doesn’t account for everything it should.
   2. Models that are misspecified can have biased coefficients and error terms, and tend to have biased parameter estimations.


# Pearson Chi-Squared test with bootsrap

The variable of interest *Y* is a vector of __N observations__, *X* is a covariate matrix with dimension (N,p) where p equals to covariate size. This paper assumes Y's density is derived from an exponential family in the form of,
    ![equation](https://latex.codecogs.com/gif.latex?f%28Y+%7C+X%29+%3D+%5Bexp%28%5Cfrac%7B%5Ctheta%5ET+Y+-+b%28%5Ctheta%29%7D%7Ba%28%5Cphi%29%7D%2Bc%28Y%2C%5Cphi%29%29%5D_%7BN%5Ctimes1%7D)

In order to test whether exponential family model fits the data adequately, new algorithm has been introduced to illustrate the bootstrap *Chi-Square* test under GLM models.

### Proposed Algorithm
1. Taking a random *sample* with replacement from the observed data *(Y, X)*
2. Fitting *Original Regression* model to the *bootstrap sample*
3. Collecting *MLE* of coefficients obtained in step 2
4. Partitioning the range \[0,1] into *K* intervals 0 < s_0 < s_1 <...< s_k, p_k = s_k-s_{k-1}
5. Computing *Pearson-type bins count* using MLE from step 2 and original obseved data *(Y,X)*
6. Computing cumulative distribution of the exponential density evaluated using the bootstrapped *MLE* and original data *X*
*(In this paper, the author has precisely defined the cumulative distribution for each regression case Linear, logistic and Poisson regression.)*
7. Computing Bootstrap *Chi-Squared* Statistics

# Usage
### 1. Linear Regression

```
# Import Pearson Boostrap For Linear Regression Class
from pearsonbootLinear import PearsonBootLin

# Create Instance
bootlogObj =PearsonBootLin(k=5)

# Compute m_k matrix and coefficiant values at each iteration for bootstraped sample: ")
_, m_k_beta_star = bootlogObj.mkBootLinear(iter_num = 3,X=covariates, y=y_linear)

# Compute Pearson Chi-Squared test with bootsrap for linear regression
qboot_lin_value = bootlogObj.bootLinearStatistics(iter_num = 3,X=covariates, y=y_linear)
```

### 2. Logistic Regression

```
# Import Pearson Boostrap For Logistic Regression Class
from pearsonbootLogistic import PearsonBootLogstc

# Create Instance 
bootlogObj =PearsonBootLogstc(k=5)

# Compute m_k matrix and coefficiant values at each iteration for bootstraped sample
_, m_k_beta_star = bootlogObj.mkBootLogistic(iter_num = 3,X=covariates, y=y_logistic)

# Pearson Chi-Squared test with bootsrap for logistic regression
qboot_log_value = bootlogObj.bootLogisticStatistics(iter_num = 3,X=covariates, y=y_logistic)
```

### 3. Poisson Regression

```
from pearsonbootPoisson import PearsonBootPoisson

# Create Instance
bootlogObj =PearsonBootPoisson(k=5)

# Compute m_k matrix and coefficiant values at each iteration for bootstraped sample
_, m_k_beta_star = bootlogObj.mkBootPoisson(iter_num = 3,X=covariates, y=y_count)

# Pearson Chi-Squared test with bootsrap for Poisson regression
qboot_log_value = bootlogObj.bootPoissonStatistics(iter_num = 3,X=covariates, y=y_count)

```



*Conclusion:*
   - *Bootstrap Chi-Squared Statistics* converge to a *Chi-Squared* distribution with *K-1* dof under the null hypothesis.
   - Data from a discret distribution -> cummulative function is the *step function*.
   - For Binary data The author defined uniform distribution between the two adjacent endpoints of the line segment. Check [Article](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3664432/).

# N.B: 
*Maximum likelihood estimators are:*
- for the regression coefficients, the usual OLS estimator;
- for the variance of the error terms, the unadjusted sample variance of the residuals.



*Reference:*
- Yin, Guosheng & Ma, Yanyuan. (2013). Pearson-type goodness-of-fit test with bootstrap maximum likelihood estimation. Electronic journal of statistics. 7. 412-427. 10.1214/13-EJS773. [Article](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3664432/) 



