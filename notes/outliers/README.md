# Outliers

Outliers needs close inspection else it can result in wildly wrong estimations.
Outlier is an observation that appears far away and diveges from an overall pattern in a sample.
Values that are very different in magnitude from the others in the feature or target space are called outliers.
Noise and Outliers can lead to inconsistencies (i.e similar or identical features vectors with much different target values)

## A. Outliers types

    - __Univariate:__
        -Can be found when we look at distribution of a single variable

    - __Multivariate:__
        -Can be found when we look at distributions in multi-dimensions


## B. Outliers causes

    - __Non natural causes:__
        - Human errors, errors caused during data collection, recording or entry can cause outliers in data
        - Measurment error, when the measurement instrument used turns out to be faulty
        - Intentional error, when human under report an action (i.e alcohol consumption...)
        - Data pocessing error, when we extract data from multiple sources some manipulation or extraction may lead to outliers in the dataset
        - Sampling error, when we mix two separate population

    - __Natural causes:__
        - When outlier is not artificial

## C. Outliers impact

    - Can drastically change the results of the data analysis and statistical modeling
    - Increases variance error and reduces the power of statistical tests
    - Non-randomly distributed outliers can decrease normality
    - Bias or influence estimated with substantive interest
    - Impact basic assumption in regression models

## D. Outliers Detection

    - Box-plot, Histogram, scatter plot
    - Cook Distance (is used only for MLR)
    - Replace Outliers with missing values and try to predict it

## F. Rule of thumb

    - Lower & Upper 1.5*IQR whisker
    - Use capping methods, value out of range of 5th and 95t percentile can be considered outlier
    - Data points, three or more standard deviation away from mean are considered outlier
    - Taking the log of a predictor or target variable is useful when there are outliers that can't be filtered out because they are important to the model


## G. Box-Plot

    - Simple graphical distribution of a probability distribution (maps a feature value to the probability occurence)
    - Box-plot are constructed using interquartile


## H. Interquartile Range

    - Often used to find outliers in data
    - Difference between Q3 and Q1
    - Q3 and Q1 repsents medians

    - Q1 is median of n smallest values
    - Q3 is median of n largest values
    - Q2 is ordinary median

    - Observation with lower 1.5xIQR whisker, are identified as outliers.\\
        - All values less then Q1-1.5 x IQR are outliers.

    - Observation with upper 1.5xIQR whisker, are identified as outliers.\\
        - All values more then Q3 + 1.5 x IQR are outliers.


## I. Cook Distance

    - Only used in MLR
    - Computes the effect of deleting a given observation
    - Represents the sum of all the changes in the regression model when observation "i" is removed from it.
    - Cut-off values to use for spotting highly influential points.


Cut-off values
\end{frame}



## What to do with outliers?

    - Leave dataset noisy
    - Delete outliers
    - "Fix" the records


## What strategy to choose depends on

    - Knowledge about this domain
    - Goals of the model
    - How numerous the anomalies are
    - What we see in individual record with anomalous values


