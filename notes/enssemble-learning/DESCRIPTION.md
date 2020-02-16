
#Random Thought
This file contain a simple introduction and notes for different enssemble learning. Explaining different methods, when, how and where to apply it.

    -Combining diverse set of learners (individual models)
    -Use these combination to improve model robustness and predictive accuracy

What causes error in the model?
    -Bias error: 
        -Quantify how much on an average are the predicted values different from the actual values
        -High values indicates under-performing model (i.e keeps on missing important trends)
    
    -Variance error:
        -Qauntifies the variance of predictions made on different set of observation
        -High variance indicates over-fitting

Enssemble learning techniques:
    -Bagging:
        -Implement similar learners on small population sample and output the mean of all the predictions
        -Help to reduce the variance error
    
    -Boosting:
        -Iterative technique that adjust weight of an observation based on the last classification
        -Inaccurate classification leads to weight increasing of this observations and vice versa
        -Help to decrease bias error and builds string predictive models
        -It may over-fit on the training data



#Data Mining with Decision Trees
    -Combiner usage is the relation between the enssemble generator and the combiner.

#Combination methods
    -There is two main method for combining classifiers:
        -__ Weighting __, individual classifiers perform the same task, comparable success.
        -__ meta-learning __, 
    


#How to classify unlabeled instance?

## Weighting Methods
    -According to the class that obtains the highest number of votes (PV or BEM)
    
    -Performance weighting, set weight of each classifier proportionally to its accuracy performance on a validaion set


    -Distribution Summation, sum up the conditional probability vector obtained from each classifier, selected class is chosen according to the highest value in the total vector

    -Dempster-Shafer
    
    -Vogging (Variance Optimized Bagging), optimize a linear combination of base classifier to reduce variance while attemptine to preserve a prescribed accuracy
    -Naive Bayes
    -Entropy Weighting, give each classifier a weight that is inversely proportional to the entropy of its classification vector
    -Density-based Weighting,
    -DEA Weighting Method, figure out the set of efficient classifier
    -Logarithmic Opinion Pool
    -Gating Network,
        * Each classifier in base model (i.e Expert), outputs the conditional probability given the input instance
        * Gating Network, combine various experts by assigning a weight to each network
        * These weights are function of input instance 
        * Gating Network, select one or a few experts which appear to have the most class distribution for the example
        *Check variation of this methods; Meta-p_i, nonlinear gated experts for time-series, revised modular network for predicting in survival analysis 


##Meta-combination Methods
    -Stacking:
        -Achieving highest generalization accuracy
        -Induce which classifiers are reliable and which not
        -Usually employed to combine models built by different inducers
        -Use learner to combine output from different learners
        -Can lead to decrease in bias or variance error


#Questions:
    - How to remove undesirable classifiers from enssemble learning?
    - How to specify the Combiner usage?