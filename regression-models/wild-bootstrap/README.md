# A Score Based Approach to Wild Bootstrap Inference

This paper discusses two bootstrap methods: __Wild bootstrap__ and __Score bootstrap__,
in which __Score bootstrap__ is a variant of __Wild bootstrap__, having the advantage of minimizing the cost of estimateur ˆβ at each replication,
in particular in the case of complex non-linear models, since there is no need to re-compute an estimator of the model fitted at each iteration.

The __Least Squares__ approach for estimating coefficients in a __Gaussian__ linear model assume homoscedastic errors centred and independent,
under the previous assumptions, this is known to be best linear unbiased estimator. It means that among the unbiased estimators of type β=BY,

The __OLS__ estimator has minimal variation and in case of __Gaussian__ chance, the __OLS__ is the same as the one that maximizes the likelihood function.

If the hypothesis of __homoscedasticity__ is not fulfilled, estimators are biased.  This is where the __Wild bootstrap__ method comes into play,
it can be interpreted as the procedure of taking samples whose residues will be replaced in order to identify the heteroskedasticity of the residues.

__Wild bootstrap__ technique remains accurate regardless if there is evidence of heteroskedasticity.


Applications and extensions of __Wild bootstrap__ have been largely limited to the context of linear models where residuals can be computed easily.
An alternative approach to __Wild bootstrap__ consists in the creation a bootstrap sample from __Score contributions__.
__Wild bootstrap__ can be interpreted as a perturbation of the __Score contribution__.

Once both methods of bootstrapping were introduced and implemented, the critical value was estimated for different classes of quadratic tests (i.e. __Wald's test__, __Score test__, etc...).


## Statistical Model
The first statistical model is as follows,

![equation](https://latex.codecogs.com/gif.latex?%24%24Y_i%3D%5Cbeta_0&plus;%5Cbeta_1X%5E%7B%281%29%7D_i&plus;%5Cbeta_2X%5E%7B%282%29%7D_i&plus;%5Cbeta_3X%5E%7B%283%29%7D_i&plus;%20%5Cepsilon_i%24%24)

where,

* Y is a random variable to predict
* Xs are known variables
* \beta coefficients to estimate
* \epsilons are random variables that satisfy the following conditions;
    * ![equation](https://latex.codecogs.com/gif.latex?%24%24E%28%5Cepsilon_i%29%20%3D%200%20%5Ctextrm%7B%20for%20i%7D%20%5Cin%20%5B1%2C%5Cdots%2Cn%5D%24%24)
    * ![equation](https://latex.codecogs.com/gif.latex?%24%24Cov%28%5Cepsilon_i%2C%20%5Cepsilon_j%29%3D0%20%5Ctextrm%7B%20for%20i%2Cj%7D%20%5Cin%20%5B1%2Cn%5D%20%5Ctextrm%7B%20and%20%7D%20i%20%5Cneq%20j%24%24)
    * ![equation](https://latex.codecogs.com/gif.latex?%24%24Var%28%5Cepsilon_i%29%3D%5Csigma%5E2%20%5Ctextrm%7B%20for%20i%20%7D%20%5Cin%20%5B1%2Cn%5D%24%24)
* \epsilon is a __Gaussian Vector__


![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BFor%20the%20second%20statistical%20model%2C%20%7DVar%28%5Cepsilon_i%29%20%3D%20%5Csigma%5E2_i%20%5Ctextrm%7B%20for%20%7D%20i%20%5Cin%20%5B1%2Cn%5D%24%24)


## Wild Bootstrap Algorithm

1. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BOLS%20estimate%20of%20%7D%5Chat%5Cbeta%20%5Ctextrm%7B%20using%20the%20fitted%20model%20followed%20by%20the%20OLS%20vector%20%7D%20%5Chat%5Cepsilon%3D%20%28Y-X.%5Chat%5Cbeta%29%24%24)
2. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BDrawing%20of%20n%20elements%20noted%20%7D%5Chat%5Cepsilon%5E%7B%5Cstar%7D%3D%28%5Chat%5Cepsilon%5E%7B%5Cstar%7D_1%2C...%2C%5Chat%5Cepsilon%5E%7B%5Cstar%7D_n%29%5E%7B%27%7D%5Ctextrm%7B%2C%20called%20bootstrapped%20residues%20taken%20at%20random%20with%20replacement%20from%20%7D%20%5Chat%5Cepsilon%20%3D%28%5Chat%5Cepsilon%5E%7B%5Cstar%7D_1%2C...%2C%5Chat%5Cepsilon%5E%7B%5Cstar%7D_n%29%20%24%24)
3. Generate a centered and reduced random variable W
4. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BCompute%20%7DY%5E%7B%5Cstar%7D%20%3D%20X.%5Chat%5Cbeta%20&plus;%20%5Cepsilon%5E%7B%5Cstar%7D%5Ctextrm%7B%20using%20W%20and%20%7D%5Cepsilon%5E%7B%5Cstar%7D%24%24)
5.  ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BPerform%20regression%20with%20bootstraped%20dependent%20variables%20%7D%20Y%5E%7B%5Cstar%7D%20%5Ctextrm%7B%20and%20original%20regressors%2C%20this%20makes%20the%20estimation%20bootstrap%20%7D%20%5Chat%5Cbeta%5E%5Cstar%5E%7B%5C%7B1%5C%7D%7D%24%24)
6.  Repeat the process B times by returning to step 2


The ideal probability distribution for W is one that satisfies the following conditions,
![equation](https://latex.codecogs.com/gif.latex?%24%24E%28W%29%20%3D%200%2C%5Cquad%20E%28W%5E2%29%20%3D%201%2C%5Cquad%20E%28W%5E3%29%20%3D%201%2C%5Cquad%20E%28W%5E4%29%20%3D%201%24%24)

Since there is no known distribution that meets the above conditions, the three most common choices for the probability law of W are
 1. Centred normal, reduced
 2. Mammen two-point
 3. Rademacher


The two probability distributions __Rademacher__ and __Mammen__ two-point assure improvement compared to the normal approximation.

![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BSimulated%20three%20random%20variables%20%7D%20X_1%2CX_2%2CX_3%5Ctextrm%7B%20of%20size%20n%20each%20using%20a%20non-necessarily%20normal%20probability%20distribution%2C%20with%20one%20variable%20following%20a%20centred%20normal%20distribution%20with%20standard%20deviation%20%7D%20%5Csigma%20%3D%201.4.%5Ctextrm%7BThe%20Y%20variable%20is%20computed%20as%20%7D%20Y%3D%5Cbeta_0&plus;%5Cbeta_1X%5E%7B%281%29%7D%20&plus;%5Cbeta_2X%5E%7B%282%29%7D%20&plus;%5Cbeta_3X%5E%7B%283%29%7D%20%5Ctextrm%7B%20where%20%7D%20%5Cbeta_0%3D%5Cbeta_1%3D%5Cbeta_2%3D1%2C%20%5Cbeta_3%3D0.%24%24)

After fitting the model and extracting the MCO estimators and Residuals values}Then loop over B times,
where at each iteration a weight vector W is generated according to probability distributions mentioned above then draw a bootstraped sample from residuals of size n, and store the product in a variable
![equation](https://latex.codecogs.com/gif.latex?%24%24%5Chat%5Cepsilon%5E%7B%5Cstar%7D%20%5Ctextrm%7B%2C%20calculate%20the%20new%20dependent%20variable%7D%24%24)
![equation](https://latex.codecogs.com/gif.latex?%24%24%20Y%5E%7B%5Cstar%7D%20%5Ctextrm%7B%20by%20adding%20the%20variable%20epsilon%20staret%20each%20element%20de%20beta%20hat%20multiplied%20by%20an%20explanatory%20variable%2C%20then%20the%20fitted%20model%20of%20the%20new%20variable%20to%20be%20explained%20%7D%20Y%5E%7B%5Cstar%7D%20%5Ctextrm%7B%20and%20the%20explanatory%20variables%20%7D%24%24)
![equation](https://latex.codecogs.com/gif.latex?%24%24X_1%2CX_2%2CX_3%20%5Ctextrm%7B%20are%20stored%20in%20the%20variable%20regression%20new%20en%20usingm%28%29%2C%20each%20column%20of%20the%20matrixbeta%20normal%20wild%20of%20dimension%20%7D%204%5Ctimes%20B%20%5Ctextrm%7B%20corresponds%7D%24%24)
![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7B%20to%20the%20bootstrap%20estimator%2Cand%20each%20column%20of%20the%20matrixidu%20normalwild%20of%20dimension%20%7D%20n%20%5Ctimes%20B%20%5Ctextrm%7B%20corresponds%20to%20the%20fitted%20model%20residuals%20and%20the%20explanatory%20variables%20%7D%20X_1%2CX_2%2CX_3%20%5Ctextrm%7B%20at%20iteration%20i%2C%20and%20each%20column%20of%20the%20matrixd%20beta%20normal%20starde%20dimension%20%7D%204%5Ctimes%20B%20%5Ctextrm%7B%20represents%20the%20estimate%7D%20%5Csqrt%28%5Chat%20Var%28%5Chat%5Cbeta%5E%7B%5Cstar%7D%29%20%5Ctextrm%7Bat%20iteration%20i.%20This%20procedure%20was%20repeated%20for%20different%20sample%20sizes%20and%20probability%20distributions%20of%20%7D)
![equation](https://latex.codecogs.com/gif.latex?%24%24X_1%2CX_2%2CX_3%20%5Ctextrm%7B%20are%20stored%20in%20the%20variable%20regression%20new%20en%20usingm%28%29%2Ceach%20column%20of%20the%20%7D%20matri%5Ctimesbeta%20%5Ctextrm%7B%20normal%20wild%20of%20dimension%20%7D%204%5CtimesB%20%5Ctextrm%7B%20corresponds%20to%20the%20bootstrap%20estimator%20and%20each%20column%20of%20the%20matrixidu%20normalwild%20of%20dimension%20%7D%20n%5CtimesB%20%5Ctextrm%7B%20corresponds%20to%20the%20fitted%20model%20residuals%20and%20the%20explanatory%20variables%20%7D%20X_1%2CX_2%2CX_3%20%5Ctextrm%7B%20at%20iteration%20i%2C%20and%20each%20column%20of%20the%20matrixd%20beta%20normal%20starde%20dimension%20%7D%204%5Ctimes%20B%20%5Ctextrm%7B%20represents%20the%20estimate%20%7D%20%5Csqrt%28%5Chat%20Var%28%5Chat%5Cbeta%5E%7B%5Cstar%7D%29%20%5Ctextrm%7B%20at%20iteration%20i%20This%20procedure%20was%20repeated%20for%20different%20sample%20sizes%20and%20probability%20distributions%20of%20%7D%24%24)


## Score Bootstrap Algorithm

1. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BOLS%20estimator%20computation%20of%20%7D%5Cbeta%2C%20%5Chat%5Cbeta%20%5Ctextrm%7B%20from%20fitted%20model%2C%20then%20vector%20of%20residuals%7D%24%24)
2. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BCompute%20Score%20contributions%20given%20by%20%7D%20X%28Y-X.%5Chat%5Cbeta%29%24%24)
3. Generate a centered and reduced independent random variable W
4. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BCompute%20a%20new%20%22score%20contribution%20%22%20value%20perturb%2C%20%7DX%28Y-X.%5Chat%5Cbeta%29Z%24%24)
5. Multiply the perturbed "contribution score" by the inverse of the Hessian matrix and divide by square root n.
6. Repeat process B once, returning to step 3
7. ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BTo%20obtain%20the%20distribution%20law%20of%20%7D%20%5Csqrt%7Bn%7D%28%5Chat%5Cbeta-%5Cbeta%29%24%24)


![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BProbability%20distributions%20of%20W%20are%20the%20same%20as%20those%20presented%20in%20Wild%20bootstrap%20algorithm%2C%20and%20the%20same%20simulated%20regression%20model%20has%20been%20used%2C%20so%20the%20OLS%20estimator%20%7D%20%5Cbeta%24%24)
The probability distributions of W are the same as those presented in the Wild bootstrap algorithm, the same regression model has been used and therefore the OLS estimator is the same.

## Statistical Tests
![equation](https://latex.codecogs.com/gif.latex?%24%24H_0%3A%5Cbeta_3%3D%200%2C%5Cquad%20vs%5Cquad%20H_1%3A%5Cbeta_3%20%5Cneq%200%24%24)

Wald's test statistic require calculating,
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BBootstrap%20Studentized%20Score%20Test%20%7D%20T%5E%7B%5Cstar%20s%7D_n%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BBootstrap%20Studentized%20Wild%20Test%20%7D%20T%5E%7B%5Cstar%20w%7D_n%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Chat%5Cbeta%5E%7B%5Cstar%7D_j%5Ctextrm%7B%20the%20estimator%20computed%20for%20the%20jth%20sample%20bootstrap%7D%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Cbar%5Cbeta%5E%7B%5Cstar%7D_j%20%5Ctextrm%7B%20average%20of%20%7D%20%5Chat%5Cbeta%5E%7B%5Cstar%7D_j%5Ctextrm%7Bmatrix%20covariance%20is%20estimated%20by%7D%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Chat%20Var%28%5Chat%20%5Cbeta%29%5E%7B%5Cstar%7D%20%3D%20%5Cfrac%7B1%7D%7BB%7D%5Csum_%7Bj%3D1%7D%5E%7BB%7D%28%5Chat%5Cbeta%5E%7B%5Cstar%7D_j%20-%20%5Cbar%5Cbeta%5E%7B%5Cstar%7D_j%29%28%5Chat%5Cbeta%5E%7B%5Cstar%7D_j-%5Cbar%5Cbeta%5E%7B%5Cstar%7D%29%5E%7B%27%7D%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Chat%5Cbeta%5E%7B%5Cstar%7D_j%20-%20%5Cbar%5Cbeta%5E%7B%5Cstar%7D_j%20%3D%20%28X%5ETX%29%5E%7B-1%7DX%5E%7BT%7D%28X%5Chat%5Cbeta&plus;%5Chat%5Cepsilon%5E%7B%5Cstar%7D_j%29-%5Cbar%5Cbeta%5E%7B%5Cstar%7D%3D%20%28X%5ETX%29%5E%7B-1%7DX%5E%7BT%7D%5Cepsilon%5E%7B%5Cstar%7D_j&plus;%28%5Chat%5Cbeta-%5Cbar%5Cbeta%5E%7B%5Cstar%7D%29%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Ctextrm%7BIf%20B%20is%20big%20enough%20it%20is%20possible%20to%20ignore%7D%20%28%5Chat%5Cbeta-%5Cbar%5Cbeta%5E%7B%5Cstar%7D%29%20%5Ctextrm%7B%20.%20After%20multiplying%20it%20by%20its%20transpose%20to%20obtain%20the%20following%20result%2C%7D%24%24)
* ![equation](https://latex.codecogs.com/gif.latex?%24%24%5Chat%20Var%5E%7B%5Cstar%7D%28%5Chat%5Cbeta%29%20%3D%20%5Cfrac%7B1%7D%7BB%7D%5Csum_%7Bj%3D1%7D%5E%7BB%7D%28X%5ETX%29%5E%7B-1%7DX%5ET%5Chat%5Cepsilon%5E%7B%5Cstar%7D_j%5Chat%5Cepsilon%5E%7B%5Cstar%20T%7D_j%20X%28X%5ETX%29%5E%7B-1%7D%24%24)


## Estimate the critical value of Wald's test
The Wald test statistic under H0 is equivalent to the square versions of the two bootstrap statistics squared in a *chi-square* distribution with __one degree of freedom__.
In order to estimate the critical value, a threshold can be set and, by computing the number of values for the __Wald Statistic__ greater than the quantile of the *chi-square*
 distribution at __1-threshold__, one obtains an approximation of the *critical value*. This procedure has been repeated with different sample sizes and probability distributions of __W__.


## Simulation Results

### 1. Linear Gaussian homoscedastic Error Model

| Loi de W | n=10 | n=50 | n=100 | n=200 |
|----------|:----:|:----:|:-----:|:-----:|
|Normal.wild |   0.0952857 |  0.0571429 |  0.0507143 |  0.0525714 |
|Radem.wild  |  0.0977143  | 0.0548571 |  0.0517143 | 0.0498571 |
|Normal.score | 0.0488571 | 0.0482857|  0.0480000 | 0.0137143|
|Radem.score  | 0.0218571 | 0.0504286 | 0.0484286 | 0.048 |


### 2. Linear Gaussian Heteroskedastic Error Linear Model

| Loi de W | n=10 | n=50 | n=100 | n=200 |
|----------|:----:|:----:|:-----:|:-----:|
|Normal.wild |   0.1047143 |  0.0562857 | 0.0554286 |  0.0521429 |
|Radem.wild  | 0.0972857 |  0.0575714   | 0.0470000 |  0.0504286 |
| Normal.score  | 0.0508571 |  0.0524286 | 0.0495714 |  0.0384286 |
|Radem.score   |0.0000000  |0.0227143 | 0.0455714|  0.045|

Notice that with larger sample sizes the probability of rejecting H0 wrongly converges to the threshold,
and notice that the bootstrap score gives consistent results for small sample sizes and when W's law is Rademacher's law.



*Reference:*
- KLINE, Patrick et SANTOS, Andres. A score based approach to wild bootstrap inference. Journal of Econometric Methods, 2012, vol. 1, no 1, p. 23-41.[Article](https://www.nber.org/papers/w16127)
