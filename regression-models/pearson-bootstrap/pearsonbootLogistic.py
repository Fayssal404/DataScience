from pearsonboot import BootMaximumLikely
from sklearn.linear_model import LogisticRegression
import numpy as np


class PearsonBootLogstc(BootMaximumLikely):

    def __init__(self, k):
        self.bootObj = BootMaximumLikely.__init__(self, k=k)

        # Association between Y and Z as Linear Regression
        self.model = LogisticRegression(fit_intercept=True)

        # utils Function
        self.F_vector_transformer = lambda y, born: np.random.uniform(
            low=0, high=born) if y == 0 else np.random.uniform(low=born, high=1)
        self.binary_transformer = lambda x: 1 if x[0] < x[1] else 0
        self.probability = lambda x: 1 / (1 + np.exp(x))

    def mkBootLogistic(self, iter_num, X, y):
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
        beta_star_matrix = []
        # (B x K)
        m_k_beta_star = []

        nrows, _ = X.shape
        while iter_ < iter_num:
            y_star, x_star = self.bootstraped_sample(
                org_matrix=covariates)  # Get bootstrap Samples

            # Fit model To Boostraped Samples
            # Does Everytime the model initiate itself ??
            coeff_star = self.model_estimate_coeff(self.model, x_star, y_star)

            beta_star_matrix.append(coeff_star)  # (1x (len(X)+1))

            # Add Intercept Column
            matrix_plus_one = np.column_stack(
                (np.ones(nrows), covariates[:, 1:]))

            # Compute uniform distribution form
            pi_star = np.apply_along_axis(
                self.probability, axis=0, arr=np.matmul(matrix_plus_one, coeff_star))
            #print('Pi_Star: ', pi_star)

            # Compute logit p star for coressponding bootstrap sample
            # TODO: I am not sure if it is with original inputs or boostraped inputs??
            logit_p_star = self.hatoutput(x_star, coeff_star)  # (1 x n)

            probas = [proba for proba in map(self.probability, logit_p_star)]
            y_hat_beta_star = np.random.binomial(
                size=len(probas), n=1, p=probas)
            #print('Predicted Y Star:', y_hat_beta_star)

            # Compute Cummulative Distributon
            # Base on Logistic regression definition
            # Replace it by A generator
            F_vector = [self.F_vector_transformer(
                y=y, born=pi) for y, pi in zip(y_hat_beta_star, pi_star)]
            #print('F Beta Star: ', F_vector)

            # Get Bins
            s_k = self.partitions
            # print('Get Bins',p_k)
            # Number of Subject Satisfiying F(y_i | Z_i) is s_k-s_{k-1}
            m_k_beta_star.append(self.pearson_type_bin(
                self.partitions, F_vector))

            #print("M_k_Star: ", m_k_beta_star)
            iter_ += 1

        return beta_star_matrix, m_k_beta_star

    def bootLogisticStatistics(self, iter_num, X, y):
        """ Pearson Chi-Squared test with bootsrap for logistic regression
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

        _, m_k_beta_star = self.mkBootLogistic(iter_num, X, y)
        return np.diag(np.square(np.divide(m_k_beta_star - proba, np.sqrt(proba))))
