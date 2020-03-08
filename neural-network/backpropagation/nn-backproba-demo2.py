
class NeuralNetwork:
    
    def __init__(self, nn_depth, input_size, output_size):
        # ANN; Input layer (2x1) - L1 = (2x1) - L2 = (3x1) 
        self.input_size =  input_size # Number of features
        self.output_size = output_size #1
        self.neurones_per_lay = nn_depth # Number Of Neurons per Layers
        
        self.nn_shape = [self.input_size] + self.neurones_per_lay +  [self.output_size] 
        self.WEIGHTS = self.generate_weights()
    
    def generate_weights(self):
        """ Generate Weights for dynamic Artificial neural network shape """
        
        return {'w'+str(idx): np.random.randn(*size) for idx, size in enumerate(zip(self.nn_shape[:-1],self.nn_shape[1:]))}        
    
    def feedforward(self, X):
        """ Rerwrite feedforward Tasks: 
            - Dynamic Artificial neural network shape
            - Recursive style
            - Generator style
        """ 
        z_i = [X,]
        for w_idx in range(len(self.nn_shape)-1):
            if w_idx ==0:
                
                #print(self.WEIGHTS['w'+str(w_idx)])
                z = self.sigmoid(np.dot(X, self.WEIGHTS[f'w{w_idx}']))
                print(z)
                z_i.append(z)
            else:
                z = self.sigmoid(np.dot(z, self.WEIGHTS[f'w{w_idx}']))
                z_i.append(z)
        return z, z_i # output Z_i, [sigma(X,w0), ... , sigma(z_{l-1}, w{l-1}), output]
    
    def sigmoid(self, s, deriv=False):
        return s*(1-s) if deriv == True else 1/(1+np.exp(-s))
    
    def backpropagate(self, X, y):
        """ Backpropagation Algorithm """
        
        output, z_i = self.feedforward(x)

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
