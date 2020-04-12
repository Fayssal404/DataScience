import numpy as np
import pandas as pd


class BootMaximumLikely:

    def __init__(self, k):

        self.K = k  # Number of Partitions

        self.partitions = np.linspace(0, 1, num=self.K)

    def model_estimate_coeff(self, model, X, y):
        """ Compute Regression Models Coefficiant and Intercept,

         Parametes:
        ---------

            model: ```sklearn.models```, Scikit-learn Regression Models

            x: ND Array, Inputs Variables,
            y: 1D Array, Output Variables Binary variable

        Output:
        -------
            Estimated Coefficient For Regression Model + Intercept
        """
        # Fit the model
        fitted_model = model.fit(X, y)
        # (1 x len(X) + 1)
        return np.append(np.array(fitted_model.intercept_), fitted_model.coef_)

    def getBins(self):
        """ Partition Bins,
        Output:
        -------
            Partition Bins
        """
        # Compute pk = s_{k}-s_{k-1}
        return [self.partitions[i] - self.partitions[i - 1] for i in range(1, self.K)]

    def bootstraped_sample(self, org_matrix):
        """ Get Bootstraped Samples,

         Parametes:
        ---------
            org_matrix: ND Array,  first column is the output variable, the rest is inputs variables

        Output:
        -------
            tuple: (Boostraped Output Sample, Boostraped Inputs Sample)
        """
        # Get Bootstraped Sample

        nrows, _ = org_matrix.shape

        bootstraped_sample = org_matrix[[
            np.random.randint(0, high=nrows) for i in range(nrows)]]
        #y_star, x_star
        return bootstraped_sample[:, 0], bootstraped_sample[:, 1:]

    def hatoutput(self, X, coeffs):
        """ Estimated Output Variable,

         Parametes:
        ---------
            x: ND Array, Inputs Variables,
            coefffs: list,1D Array, regression model estimated coefficient

        Output:
        -------
            Estimated Output Variable
        """
        y_hat_star = 0
        for coef, cov in zip(coeffs, X):
            y_hat_star += coef * cov
        return y_hat_star

    def __checkConstraint(self, born_inf, born_sup, distro_func):
        """ Compute Constraint For Each Value in distribution function,

         Parametes:
        ---------

            born_inf: int, float, partition born inf
            born_sup: int, float, partition born sup
            distro_func: 1D Array, list, distribution function or cummulative function Vector value
        Output:
        -------
            m_k value for corresponding partition and distroibution function
        """

        m_k_beta_s_value = 0
        for cum_sum in distro_func:
            if (cum_sum < born_sup and cum_sum > born_inf):
                m_k_beta_s_value += 1
        return m_k_beta_s_value  # ( 1 x 1 )

    def pearson_type_bin(self, partitions, distro_func):
        """ Compute Pearson-type bin counts,

         Parametes:
        ---------

            partitions:  Partition Bins
            distro_func: 1D Array, list, distribution function or cummulative function Vector value
        Output:
        -------
            m_k beta star matrix
        """

        # Number of Subject Satisfiying F(y_i | Z_i) is s_k-s_{k-1}
        m_k_beta_star = []
        for born_inf, born_sup in zip(partitions[:-1], partitions[1:]):
            m_k_beta_s_value = self.__checkConstraint(
                born_inf, born_sup, distro_func)
            m_k_beta_star.append(m_k_beta_s_value)

        return m_k_beta_star  # (1 x K)
