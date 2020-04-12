from pearsonboot import BootMaximumLikely
from sklearn.linear_model import LinearRegression
import numpy as np


class PearsonBootLin(BootMaximumLikely):

    def __init__(self, k):
        self.bootObj = BootMaximumLikely.__init__(self, k=k)

        # Association between Y and Z as Linear Regression
        self.model = LinearRegression(fit_intercept=True)

    def mkBootLinear(self, iter_num, X, y):
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

        iter_ = 0

        # (B x (len(X) + 1))
        beta_star_matrix = []

        # (B x K)
        m_k_beta_star = []
        nrows, _ = X.shape

        while iter_ < iter_num:

            # Get Bootstraped Sample
            y_star, x_star = self.bootstraped_sample(org_matrix=covariates)

            coeff_star = self.model_estimate_coeff(self.model, x_star, y_star)
#            print("Coeff_Star: ", coeff_star)

            beta_star_matrix.append(coeff_star)  # (1x (len(X)+1))

            # Add Intercept Column
            matrix_plus_one = np.column_stack(
                (np.ones(nrows), covariates[:, 1:]))

            # Cumulative Distribution Function f(y_i | Z_i)
            y_hat_star = np.matmul(matrix_plus_one, coeff_star)  # (1 x n)
#            print("Y_hat_star: ", y_hat_star)

            cdf_cumsum = y_hat_star.cumsum()  # (1 x n)
#            print("Cumulative: ", cdf_cumsum)

            p_k = self.getBins()  # (1 x k)
#            print("Bins : ", p_k)

            # Number of Subject Satisfiying F(y_i | Z_i) is s_k-s_{k-1}
            m_k_beta_star.append(self.pearson_type_bin(
                self.partitions, cdf_cumsum))

#            print("M_k_Star: ", m_k_beta_star)
            iter_ += 1

        return beta_star_matrix, m_k_beta_star

    def bootLinearStatistics(self, iter_num, X, y):
        """ Pearson Chi-Squared test with bootsrap for linear regression
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

        _, m_k_beta_star = self.mkBootLinear(iter_num, X, y)
        return np.diag(np.square(np.divide(m_k_beta_star - proba, np.sqrt(proba))))
