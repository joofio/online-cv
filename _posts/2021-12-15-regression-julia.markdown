---
layout: post
title:  "Regression Tutorial with Julia lang"
date:   2021-12-15 12:00:00 +0000
categories: machine-learning julia regression
classes: wide

---


Hi, in my last [post](/posts/2020-10-15-Classification-julia.html), I showed how Julia can be used to perform a classification task. In that case, we classified patients into two categories, so it was a classification, which is a method for predicting a, you guessed it, categorical outcome. But now, we are going to do a regression, where the outcome variable is continuous.

That said, let’s try to create a model that can predict a time to event. Even though this could be handled differently, for this purpose, we are going to treat this outcome prediction as a simple continuous variable.

The dataset is available [here](https://archive.ics.uci.edu/ml/machine-learning-databases/00519/heart_failure_clinical_records_dataset.csv). For this tutorial, we are going to need a few packages. For using them, check the code below.

{% gist 5c14478f6e513a4333e608e89eace8f1 %}


If you do not have the packages installed, run

```julia
using Pkg; Pkd.add(“<PackageName>")

```

## Data Load and Checking
For loading the dataset into your environment we can do it through the link.
Then we should inspect the dataset in order to check if everything went as expected. Then we can analyse some descriptive statistics of the dataset, like central statistics and dispersion. We can sum all of this into:

{% gist 7a308fca326bbeded0cd322d0932c3c4 %}

For today, we are going to try to predict the variable **time**. This variable is the time to the event, which can be death or not. So time is the amount of time needed until that event, whether death or follow-up period.
So we need to evaluate more in detail the target variable with some visualizations.

![glimpse of the dataset](/assets/img/julia-2/julia-2-0.png)

Time to event has a median of +- 110 and interquartile of 125. Now for a frequency plot.

![glimpse of the dataset](/assets/img/julia-2/julia-2-1.png)

We have at least two peaks of time frequency around 90 and 210.

![glimpse of the dataset](/assets/img/julia-2/julia-2-2.png)


For a further inspection, we ploted age vs time. There is a negative correlation between them (even if low), as would be expected. Now for event vs time.

![glimpse of the dataset](/assets/img/julia-2/julia-2-3.png)

As expected, Event is a major differentiator for the value of time. So it will be natural that the variable event has a lot of impact into our model. Now to prepare the data for applying the models, we will coerce into specific scitypes for better handling by the models. More information on scitypes [here](https://docs.juliahub.com/MLJScientificTypes/XeLZr/0.2.9/).

```julia
coerce!(dataset, Count=>MLJ.Continuous);
```

## Creating Models
Preparing data is important for starting the model creation, so we will divide data in target (y) and remaining features (X).

{% gist 0f5688a0d23eec602e47408daf32b486 %}

For this, we are going to evaluate the models in the training dataset with repeated cross-validation in order to get a pretty good idea of the model performance on the test set. For all models we are going to:
1. Load model.
2. Create the machine (which is a similar action to class instantiation)
3. Training with 3x 10-fold cross-validation and return the evaluation metric.
4. Store the metrics into a dictionary for further usage.
So, we are going to use a linear model, decision tree, k-nearest neighbours, random forest and gradientboost (this could be done with a loop but oh well 😃). The seed is used to make the code reproducible (since RNG is used for cross-validation).

{% gist eaa74e85b6361d0f03a28b6664bfc2b3 %}

## Assessing results
For the results, we need to collect all the [Root Mean Squared Error](https://en.wikipedia.org/wiki/Root-mean-square_deviation) returned by the cross-validations and evaluate the Confidence Interval (95%).

{% gist ffe75f8b150f49d92cbcc8488124dc49 %}

![glimpse of the dataset](/assets/img/julia-2/julia-2-4.png)

The Linear regression, Random Forest and GradientBoost seems to perform a little better than the other 2. However, since linear regression has a better explainability, we are going with it as the final model.

{% gist 40d16fe0c54c4a742f62696abf256022 %}

>MAE: 51.26912864372159   
RMSE: 59.80738088464344   
RMSP: 2.398347880392765   
MAPE: 0.9529914417765525  

>(coefs = [:age => -0.5600676786856139, :anaemia => -17.379451678818782, :creatinine_phosphokinase => -0.0024220637584861492, :diabetes => 5.5623104572596525, :ejection_fraction => -0.4719281676537811, :high_blood_pressure => -23.336061031579977, :platelets => -2.9328265873457684e-5, :serum_creatinine => 1.80232687559864, :serum_sodium => 0.06127126459720784, :sex => -3.8716177684193114, :smoking => -6.7752701233783705, :DEATH_EVENT => -86.69157019555797],  intercept = 226.6056333198319,)

As we understood earlier, the **DEATH_EVENT** variable has a major impact in the model, with a **-86** coefficient.

## Evaluating Final Model
The model was fitted to the data and evaluated on the test set, we know how good it performed but we can investigate this more deeply. It should assess the errors for each row in the test set, in order to inspect them more thoroughly.

![glimpse of the dataset](/assets/img/julia-2/julia-2-5.png)


The errors seem random and do not follow any type of pattern, which is good.

![glimpse of the dataset](/assets/img/julia-2/julia-2-6.png)

Test error seems to follow a normal distribution, which is desirable.

## Conclusion
With these evaluations, we have a little more confidence to say that our model grasped a glimpse of the reality of the data in order to predict the time variable. Further work could be employed in tuning the parameters or creating variables to improve our models.

I hope that this was helpful to let you take on a regression task with Julia Lang!