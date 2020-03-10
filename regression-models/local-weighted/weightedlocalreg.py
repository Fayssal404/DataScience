import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


class WeightedLocalRegression:
    
    def __init__(self,size):
        self.gaussian_func = lambda diff,k: np.exp((diff@diff.T)/(-2*k**2))
        self.m, self.n = size
        
    def kernel(self, x_0, x, k):
        
        weight = np.mat(np.eye((self.m)))
        
        for row_idx in range(self.m):
            diff = x_0 - x[row_idx]
            weight[row_idx, row_idx] = self.gaussian_func(diff, k)
        
        return weight
    
    def local_weight(self, x_0, x, y, k):
        """Output regression parameters estimation,
        Keys parameters:
        x_0 -- 1D array, current selected data point
        x -- ND array, input matrix size (m x n)
        y -- 1D array, output variable
        k -- int float
        """
        wt = self.kernel(x_0, x,k)
        # \hat\beta = (X.W(x)X^T)^-1 . X.W^T Y^T
        return (x.T @ np.dot(wt,x)).I @ np.dot(x.T, np.dot(wt, y))
    
    def local_weight_regression(self, x, y,k):
        """ Output regressions of the x inputs.
        Keys parameters:
        x -- np.array, input matrix size (m x n)
        y -- 1D array, output variable
        k -- float int
        bias -- bool, (default True), add bias term
        """
        
        ypred = np.zeros(self.m)
    
        for row_idx in range(self.m):
            print(row_idx)
            ypred[row_idx] = x[row_idx] @ self.local_weight(x[row_idx], x, y, k)
        
        return ypred
