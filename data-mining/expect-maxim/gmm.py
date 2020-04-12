import numpy as np
from scipy.stats import norm


class GMM:

    def __init__(self, k):
        self.k = k
        # self.mus = mus  # Mean Vector [SAMPLE_SIZE x 1]
        # self.sigmas = sigmas  # Variance Vector [SAMPLE_SIZE x 1]
        # Probability Vector that an observation is drawn from prob distro [SAMPLE_SIZE x 1]
        # self.probas = probas

    def density_value(self, x, means, sigmas):
        """ Gaussian density corresponding to a numeric vector """
        return np.array([self.gaussian_density_formula(x, means=mu, sigmas=sig) for mu, sig in zip(means, sigmas)])

    def gaussian_density_formula(self, x, means, sigmas):
        """ Gaussian density  """
        return norm.pdf(x, loc=means, scale=sigmas)

    def loglikelihood(self, x, probas, means, sigmas):
        """ Mixture Model loglikelihood """
        return np.sum(self.density_value(x, means=means, sigmas=sigmas).T * probas)

    def posteriori_latent(self, x, means, sigmas, probas):
        """ Posteriori distribiton with latent variables """

        # p_1 * N(x_i | mu_1, sigma_1) + p_2 * N(x_i | mu_2, sigma_2) +....
        # matrix (SAMPLE_SIZE x K)
        numerator = probas * self.density_value(x, means, sigmas).T

        #  gaus
        # (SAMPLE_SIZE x 1)
        denominator = np.sum(
            probas * self.density_value(x, means, sigmas).T, axis=1)

        return (numerator.T / denominator).T

    ############################ Parameters Estimation ###########################

    def mean_estimation(self, x, means, sigmas, probas):
        """ Mean Estimation """
        posteriori_latent_ = self.posteriori_latent(x, means, sigmas, probas)
        return np.sum((posteriori_latent_.T * x).T, 0) / np.sum(posteriori_latent_, 0)

    def sigma_estimation(self, x, means, sigmas, probas):
        """ Sigmas Estimation """
        posteriori_latent_ = self.posteriori_latent(x, means, sigmas, probas)

        # Because Sigma MLE depends on Means estimation
        means_estimate = self.mean_estimation(x, means, sigmas, probas)

        return np.sum(np.power(np.array([x - mu for mu in means_estimate]).T, 2) * posteriori_latent_, 0) / np.sum(posteriori_latent_, 0)

    def probas_estimation(self, x, means, sigmas, probas):
        """ Probability Estimation """
        posteriori_latent_ = self.posteriori_latent(x, means, sigmas, probas)

        return np.sum(posteriori_latent_, axis=0) / len(posteriori_latent_)

    ############################ Expected Value of the Complete log-likelihood ###########################

    def cloglikelihood_expectation(self, x, means, sigmas, probas):
        """ Expected Value of the Complete log-likelihood """
        posteriori_latent_ = self.posteriori_latent(x, means, sigmas, probas)

        return np.sum(np.sum(np.multiply(posteriori_latent_, np.log(self.density_value(x, means, sigmas)).T + np.log(probas)), 1))

    ############################ EM Estimation ###########################

    def gmm(self, x, threshold, mus_init, sigmas_init, probas):
        """ Gaussian Mixture Model """

        ll_init = self.loglikelihood(x, mus_init, sigmas_init, probas)

        #post_init = posteriori_latent(y_mix, mus_init, sigmas_init, probas)

        expect_init = self.cloglikelihood_expectation(
            x, mus_init, sigmas_init, probas)

        delta = 1
        log_liks = [ll_init]
        expect_ = [expect_init]
        means_estimates = [mus_init]
        sigma_estimates = [sigmas_init]
        proba_estimates = [probas]

        while (delta > threshold):

            # Current
            mean_curr, sig_curr, proba_curr = means_estimates[-1], sigma_estimates[-1], proba_estimates[-1]

            # Parameters Estimation At iteration (t+1)
            means_estimate = self.mean_estimation(
                x, mean_curr, sig_curr, proba_curr)
            sigma_estimate = self.sigma_estimation(
                x, mean_curr, sig_curr, proba_curr)
            proba_estimate = self.probas_estimation(
                x, mean_curr, sig_curr, proba_curr)

            means_estimates.append(np.array(means_estimate))
            sigma_estimates.append(np.array(sigma_estimate))
            proba_estimates.append(np.array(proba_estimate))

            # Expected Value of the Complete log-likelihood
            expec_prev = expect_[-1]
            expec_curr = self.cloglikelihood_expectation(
                x, means_estimate, sigma_estimate, proba_estimate)

            expect_.append(expec_curr)

            # loglikelihood
            loglike_prev = log_liks[-1]
            loglike_curr = self.loglikelihood(
                x, means_estimate, sigma_estimate, proba_estimate)

            delta = abs((loglike_curr - loglike_prev))

            log_liks.append(np.array(loglike_curr))

        return (log_liks, expect_),  (means_estimates, sigma_estimates, proba_estimates)


if __name__ == '__main__':

    from mixdatagenerator import MixtureDataGenerator

    SAMPLE_SIZE = 10000
    MU_1 = 0
    MU_2 = 3
    SIGMA_1 = 1
    SIGMA_2 = 2
    PROBA = 0.4

    # Generate Model
    mixtureObj = MixtureDataGenerator(sample_size=SAMPLE_SIZE)
    y_mix = mixtureObj.gaussMixture(MU_1, MU_2, SIGMA_1, SIGMA_2, PROBA)

    # Initialize Parameters
    mus_init = np.array([0.1, 0])
    sigmas_init = np.array([0.5, 1])
    probas = np.array([0.35, 0.65])
    threshold = 1e-6

    # Gmm

    gmmObj = GMM(k=3)

    _, param_estimates = gmmObj.gmm(x=y_mix, threshold=threshold, mus_init=mus_init,
                                    sigmas_init=sigmas_init, probas=probas)

    print("Means Estimates: \n", param_estimates[0])
    print("Sigmas Estimates: \n", param_estimates[1])
    print("Proba Estimates: \n", param_estimates[2])
