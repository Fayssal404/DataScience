
# Forward Propagation
 - Feeding the data forward through the network 
 - Repeatively calculating the weighted sum of the previous layers activation output with the corresponding weights
 - Passing the previous sum to the next layer activation function,
 - Repead step 2,3 until reaching output layer
 - Compute *loss* function on output

### Forward Propagation
![gif]()


# Back Propagation
 - Methode to propagate error at the output layer backward so that the gradiant so that the gradiants at the preceding layers can be computed easily using the chain rule of derivative 
 - The act of computing *Gradiant Descent* in order to update the *Weights* occures by the Backpropagation process 
 - Computing the *Gradiant Descent* function, is done by computing the derivative of the *Loss* with respects to the *Weights* & *Biases*
 - Move *backwards* through the network

## Intuition 
 1. *Gradiant Descent* start by looking at the activation output from output nodes
 2. Update the weights for the connections of the output layer
    - To achieve this you should
 3. Moving Backwards through the network, updating weights from right to left, in ordre to move the 
    values from the outut nodes in the direction they should be going, in order to help lower the loss

## Why Backpropagation?
 1. The output of each layer depends on the *Weights* & *Activation* of previous layer
 2. Modifying the *Weights* in previous layers those modifications will influence what happens in later layers
 3. Efficiently update the *Weights* so that the updates are being done in a manner that helps to reduce the loss function most efficiently
 4. The same process will occure for all the inputs for each batch provided to our network
 5. Resulting updates of the *Weights* in the network are going to be the average updates calculated for eachindividual inputs
 6. Average results of each *Weights* are corresponding gradiants for the *Loss* function with respect to each weights

![gif](https://thumbs.gfycat.com/FickleHorribleBlackfootedferret-small.gif, 3brown1blue)

### Back Propagation Weights Update
![gif](https://hsto.org/files/627/6e1/d36/6276e1d365ba4f8497cd41fb110d7619.gif)
