
import numpy as np


class MixtureDataGenerator:

    def __init__(self, sample_size):
        self.sample_size = sample_size

        # Probability Interval
        self.I = np.random.uniform(size=self.sample_size)

    def gaussDensity(self, mu, sigma):

        return np.random.normal(mu, sigma, size=self.sample_size)

    def gaussMixture(self, mu_1, mu_2, sigma_1, sigma_2, threshold):

        Y_one = self.gaussDensity(mu=mu_1, sigma=sigma_1)

        Y_two = self.gaussDensity(mu=mu_2, sigma=sigma_2)
        # Mixture Model
        proba = (self.I < threshold)

        return proba * Y_one + (1 - proba) * Y_two
