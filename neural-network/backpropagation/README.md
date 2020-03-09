
# Forward Propagation
 1. Always moves one direction; it never goes backwards
 2. Passing data across the network forward (__Input Layer -> Output Layer__)
 3. Apply *activation function* to the weighted sum of previous __layer Output__ 
 5. Repeat steps 2,3 until reaching the *Output Layer*
 4. Compute *loss function* (__Output - Observed__)

### Forward Propagation Processing Data
![gif](https://miro.medium.com/max/1200/1*kmDpcV6lVVMjuREj-ovC_g.gif)


# Back Propagation
Moving backwards through the network, updating weights from right to left, in order to move the values from the output nodes in the direction they should be going, in order to help lower the loss

 0. Feedforward data
 1. Process for propagating the output error backwards to the input layer
 2. Moving data across the network backward (__Output Layer -> Input Layer__)
 3. Update the gradiants of previous layers using the previous __layer Output__
    - Compute the *loss function* derivative with respect to *Weights* & *Biases*

*(__Gradiant Descent__ computation is necessary in order to update the __Weights__ -> Back propagation)*

### Back Propagation Updating Weights
![gif](https://hsto.org/files/627/6e1/d36/6276e1d365ba4f8497cd41fb110d7619.gif)


__Notes:__
 - ___Weights___ should be updated so as to minimize the *loss function* in an effective way
 - Resulting ___Weights__ updates will be the average for each individual input



