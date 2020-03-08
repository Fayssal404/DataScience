class NeuralNetwork:
    
    def __init__(self):
        # ANN; Input layer (2x1) - L1 = (2x1) - L2 = (3x1) 
        self.input_size = 2
        self.output_size = 1
        self.hidden_size = 3
        
        # Weights
        self.W1 = np.random.randn(self.input_size, self.hidden_size)
        self.W2 = np.random.randn(self.hidden_size, self.output_size)        
    
    def feedforward(self, X):
        """ Rerwirte feedforward Tasks: 
            - Recursive style
            - Generator style
        """ 
        self.z = np.dot(X, self.W1)
        self.z2 = self.sigmoid(self.z)
        self.z3 = np.dot(self.z2, self.W2)
        return self.sigmoid(self.z3)
    
    
    def sigmoid(self, s, deriv=False):
        return s*(1-s) if deriv == True else 1/(1+np.exp(-s))
    
    def backpropagate(self, X, y, output):
        """ Backpropagation Algorithm """
        
        self.output_error = y -output
        self.output_delta = self.output_error * self.sigmoid(output, True)
        
        self.z2_error = self.output_delta.dot(self.W2.T)
        self.z2_delta = self.z2_error * self.sigmoid(self.z2_error, True)
        
        
        # Update Weights
        self.W1 += X.T.dot(self.z2_delta)
        self.W2 += self.z2.T.dot(self.output_delta)
    
    def train(self, X,y):
        output = self.feedforward(X)
        self.backpropagate(X, y, output)
        
        
        # Compute
