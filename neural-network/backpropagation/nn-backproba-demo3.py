import numpy as np

class NeuralNetwork:
    
    def __init__(self, nn_depth, input_size, output_size):
        """ Collecting neural network structure details."""
        self.input_size =  input_size ## Input size
        self.output_size = output_size # Output size
        self.neurones_per_lay = nn_depth # Hidden Layer size
        
        # Additional info
        self.nn_shape = [self.input_size] + self.neurones_per_lay +  [self.output_size] 
        self.depth = len(self.nn_shape)
        
        
        self.WEIGHTS = self.generate_weights()
        # Compute contribution recursively 
        self.contrib = lambda X, idx: nn.sigmoid(np.dot(X, nn.WEIGHTS[f'w{idx}']))
        #contrib(contrib(contrib(contrib(contrib(x,0),1),2),3),4)

        
    def generate_weights(self):
        """ Return dictionary of weights corresponding to each layer.""" 
        return {f'w{idx-1}': np.random.randn(*(self.nn_shape[idx-1], self.nn_shape[idx])) for idx in range(1, self.depth)}
    

    def forward(self, X, l_idx):
        """ Return conribution values (recursively) to the output at a layer index.
        Keyword arguments:
            X -- numpy.array
        """
        return self.contrib(self.forward(X,l_idx-1),l_idx) if l_idx else self.contrib(X,0)

    def forward_out_contrib(self, X):
        """ Return contributions of each layer output.
        Keyword arguments:
            X -- numpy.array
        """ 
        return [X] + [self.forward(X,i) for i in range(self.depth-1)]

    
    def sigmoid(self, s, deriv=False):
        """ Return values sigmoid transformation applied to s.
        Keyword arguments:
            s -- numpy.array
            deriv -- boolean (default False reciprocal if True)
        """ 
        return s*(1-s) if deriv == True else 1/(1+np.exp(-s))

    def backpropagate(self, X, y):
        """ Backrpopagation update Weights (minimize the loss function) in each layer.
        Keyword arguments:
            X -- numpy.array, inputs values
            y -- numpy.array, observed output value
        TODO:
            - Backpropagate error recursively
            - Update Weights recursively
            - Eliminate for loops
            - Use generators
        """ 
        *z_i, output = self.forward_out_contrib(X)
        print(z_i, output)
        deltas = []

        # First Iteration
        output_error = y - output
        deltas.append(output_error * nn.sigmoid(output, True))

        # Backward Iteration
        lay_depth = len(self.nn_shape)
        lay_idx_reversed = [ lay_depth-i -1 for i in range(1, lay_depth)]

        # Run Recursevly in inverse from output layer into input layer
        for lay_idx in lay_idx_reversed[:-1]:
            print(f"Layer {lay_idx} ")
            z_error = deltas[-1].dot(self.WEIGHTS[f'w{lay_idx}'].T)        

            deltas.append(z_error * self.sigmoid(z_i[lay_idx], True))

        # Output_delta, z_{l-1}, ... , z_1
        #print("Before Updating Weights: " , self.WEIGHTS)

        for idx_rev, idx_frw in zip(lay_idx_reversed, range(lay_depth)):
            print(f"Layer Index {idx_rev} Output -> Input direction")
            print(f"Layer Index {idx_frw} Input -> Output direction")

            # Update Weights
            self.WEIGHTS[f'w{idx_frw}'] += z_i[idx_frw].T.dot(deltas[idx_rev])

        for idx in range(len(deltas)):
            #print(idx)
            self.WEIGHTS[f"w{idx}"] += z_i[idx].T.dot(deltas[len(deltas)-1-idx])

        #print("After Updating Weights: " , self.WEIGHTS)

    def train(self, X,y, n_iter=100):
        i=0
        while i<=n_iter:
            self.backpropagate(X, y)
            i+=1
        return self.WEIGHTS
