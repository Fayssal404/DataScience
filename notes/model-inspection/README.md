
# Model Inspection

## A. Classification Models
   - ___TruePositive:___ number of the true positive samples
   - ___Positive:___ number of positive samples
   - ___TrueNegative:___ number of the true negative samples
   - ___Negative:___ number of samples that is negative
   
### 1. Confusion Matrix
| Confusion Matrix | Predicted Negative | Predicted Positive  |
| ------------- |:-------------:| -----:|
| Real Negative | TN | FP |
| Real Positive | FN      |   TP |


### 2. Precision
The fraction of correct predictions for a certain class. Measures how many examples classified as "Positive" class are indeed "Positive".

![equation](http://www.sciweavers.org/tex2img.php?eq=%24%24%5Cfrac%7BTruePositive%7D%7BTruePositive%20%2B%20FalsePositive%7D%24%24%0A&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=)

Confusion matrix second column.

### 3. Recall (or Sensivity)
The fraction of instances of a class that were correctly predicted, if a model predict a certain class most of the time, this class will have a high recall values. This is why other classes will be less likely to be predicted, this will lead to low precision for this class. Assesses how well the classifier can a positive samples. 

![equation](http://www.sciweavers.org/tex2img.php?eq=%24%24%5Cfrac%7BTruePositive%7D%7BPositive%7D%20%3D%20%5Cfrac%7BTruePositive%7D%7BTruePositive%20%2B%20FalseNegative%7D%24%24%0A&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=)

Confusion matrix second row.

*(When Precision increases, recall should decrease)*

### 4. Specifity
Measures how well the classifier can recognize negative samples.

![equation](http://www.sciweavers.org/tex2img.php?eq=%24%24%5Cfrac%7BtrueNegative%7D%7BNegative%7D%20%3D%20%5Cfrac%7BtrueNegative%7D%7BtrueNegative%20%2B%20falsePositive%7D%24%24%0A&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=)

Second row of the confusion matrix.

### 5. f1 score
Considers both precision and recall, F1 Score is best if there is some sort of balance between ___Precision___ & ___Recall___ in the system. Which is not the case here.

![equation](http://www.sciweavers.org/tex2img.php?eq=%24%24%5Cfrac%7B2%2A%20Recall%20%2A%20Precision%20%7D%7B%20Recall%20%2B%20Precision%7D%24%24%0A&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=)

### 6. ROC

Shows tradeoff between __TRUE POSITIVE RATE__ (___Sensivity___) and __TRUE NEGATIVE RATE__ (___Specifity___).
    
   * The curves of different models can be compared directly in general or for different thresholds
   * The area under the curve (AUC) can be used as a summary of the model skill
   
![fig](http://ncss.wpengine.netdna-cdn.com/wp-content/uploads/2013/01/ROC-Curve-21.png)

*Interpretation:*

The ideal point on the ROC curve is (0, 1), which means all Positive classes are predicted correctly. Statistically significant models are represented by curves that bow up to the top left of the plot.

   * Smaller values on the x-axis of the plot indicate lower false positives and higher true negatives.
   * Larger values on the y-axis of the plot indicate higher true positives and lower false negatives.
   * The ROC curve for the final model help us to choose a threshold that gives a desirable balance between the false positives and false negatives.
