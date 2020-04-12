from pearsonboot import BootMaximumLikely
import statsmodels.formula.api as fm
import statsmodels.api as sm
from statsmodels.genmod.families import Poisson
import numpy as np

from utils import exponentiel


class PearsonBootPoisson(BootMaximumLikely):

    def __init__(self, k):
        self.bootObj = BootMaximumLikely.__init__(self, k=k)

    def model_estimate_coeff(self, X, y):
        """ Fit Poisson Regression Models & get Coefficiant & Intercept,

         Parametes:
        ---------

            model: ```sklearn.models```, Scikit-learn Regression Models

            x: ND Array, Inputs Variables,
            y: 1D Array, Output Variables Binary variable

        Output:
        -------
            Estimated Coefficient For Poisson Regression Model + Intercept
        """
        X = sm.add_constant(X)  # Add Constact To bootsraped X

        # Fit Poisson Model To bootsraped samples
        return fm.GLM(y, X, family=Poisson()).fit().params

    def hatoutput(self, X, coeffs):
        """ Estimated Output Variable,

         Parametes:
        ---------
            x: ND Array, Inputs Variables,
            coefffs: list,1D Array, regression model estimated coefficient

        Output:
        -------
            Estimated Output Variable,
            mu_star array
        """
        # Compute mu star Using Original Dataset and Beta Star
        mu_star = np.exp(np.matmul(X, coeffs))

        # Compute Y star
        c_ = np.exp(-mu_star)
        return [np.random.poisson(lam=mu_) for mu_ in mu_star], mu_star

    def mkBootPoisson(self, iter_num, X, y):
        """ Compute m_k matrix and coefficiant values at each iteration for bootstraped samples,

         Parametes:
        ---------

            iter_num: int, Number of iteration to run the algorithm

            x: ND Array, Inputs Variables,
            y: 1D Array, Output Variables Binary variable

        Output:
        -------
            beta_star_matrix: Array, shape=(iter_num, len(X)+1),
                            Logistic Regression Coefficients for boostraped samples at each iteration
            m_k_beta_star: Array, shape=(iter_num, K),
                           Number of subjects satisfiying cummulative function constraint
        """
        covariates = np.column_stack((y, X))  # Original Matrix

        #
        iter_ = 0
        beta_star_matrix = []
        # (B x K)
        m_k_beta_star = []

        nrows, _ = covariates.shape

        while iter_ < iter_num:

            # Get Boostrap Samples
            y_star, x_star = self.bootstraped_sample(covariates)

            coeff_star = self.model_estimate_coeff(X=x_star, y=y_star)

            # Store Beta Star Value
            beta_star_matrix.append(coeff_star)  # (1x (len(X)+1))

            # Compute Boostraped mu and y star

            # Add Constant Column to Original DataSet
            X = np.column_stack((np.ones(nrows), covariates[:, 1:]))

            # Compute Y star based on beta_star, and mu_star value
            y_count_star, mu_star = self.hatoutput(X, coeff_star)

            F_vector = [np.random.uniform(exponentiel(mu_star_, y_count_star_ - 1) * np.exp(-mu_star_),  exponentiel(
                mu_star_, y_count_star_) * np.exp(-mu_star_)) for mu_star_, y_count_star_ in zip(mu_star, y_count_star)]

            # Get Bins
            s_k = self.partitions
            # print('Get Bins',p_k)
            # Number of Subject Satisfiying F(y_i | Z_i) is s_k-s_{k-1}
            m_k_beta_star.append(self.pearson_type_bin(
                self.partitions, F_vector))

            #print("M_k_Star: ", m_k_beta_star)
            iter_ += 1

        return beta_star_matrix, m_k_beta_star

    def bootPoissonStatistics(self, iter_num, X, y):
        """ Pearson Chi-Squared test with bootsrap for Poisson regression
        Parametes:
        ---------

            iter_num: int, Number of iteration to run the algorithm

            x: ND Array, Inputs Variables,
            y: 1D Array, Output Variables Binary variable

        Output:
        -------
            Pearson Chi-Squared test Vector Computed for each bootstraped sample

        """
        bins = np.array(self.getBins())
        nrows, _ = X.shape
        proba = nrows * bins

        _, m_k_beta_star = self.mkBootPoisson(iter_num, X, y)
        return np.diag(np.square(np.divide(m_k_beta_star - proba, np.sqrt(proba))))
