# Gaussian Mixture Models (GMM) & the EM algorithm
GMM is a probabilistic model for representing normally distributed subpopulations within an overall population, since subpopulation assignment is not known, this constitutes a form of unsupervised learning. *"Estimating the parameters of the individual normal distribution components is a canonical problem in modeling data with GMMs."*

<center>Gaussian Mixture Models</center>

![alt text](https://miro.medium.com/max/1400/1*I0WTzTOyyDVwfPyMSZPzWQ.gif)

## GMM Application Area
- Feature extraction from speech data
- Object tracking of multiple objects

Models are are typically learned by using maximum likelihood estimation techniques, which seek to maximize the probability, or likelihood, of the observed data given the model parameters.

## Problem
Finding the maximum likelihood solution for mixture models by differentiating the log likelihood and solving for 0 is usually analytically impossible.

## Solution
Expectation-Maximization (__EM__) is a numerical technique for maximum likelihood estimation, and is usually used when closed form expressions for updating the model parameters can be calculated.

# EM Algorithm
![alt text](https://sandipanweb.files.wordpress.com/2017/03/gmmem3d2.gif?w=676)

*Consists of two steps:*
 * __Step-1 Expectation__
  - The missing data are estimated given the observed data & current estimate of the model parameters
  - Estimate of the missing data from the E-step are used in lieu of the actual missing data
 * __Step-2 Maximization__
  - Likelihood function is maximized under the assumption that the missing data are known
__Note:__
  - Convergence is assured since the algorithm is guaranted to increase the likelihood at each iteration


*References:*
- Ramesh Sridharan, Gaussian mixture models and the EM algorithm, [link](https://people.csail.mit.edu/rameshvs).
- John McGonagle,et al., Gaussian Mixture Model [link](https://brilliant.org/wiki/gaussian-mixture-model/).
- Matt Bonakdarpour, Introduction to EM: Gaussian Mixture Models [link](https://stephens999.github.io/fiveMinuteStats/intro_to_em.html#mle_of_gaussian_mixture_model)
