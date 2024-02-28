# Boyd Kane MSc Oral

Speaking notes

# Pre-oral prep

- MS teams set up?
- external examiner can hear & see the screen and can speak?

Notes from chatting with Trienko:

- _do_ show the introduction video
- Add YouTube link to all the things, thesis included
- explain all graphs and images, you can't just include something because it's
  pretty
- Define explicit, implicit, fidelity
- Say that _Ergo_ comes from _ergonomic_ or _therefore_.
- Add explicit headings to the slides
- One of the contributions is the dataset which is the biggest and the open
  description of the model

# Overview

## A video demonstration

- Play the video
- TODO: Make the video more stand-alone
  - describe what each of the frames does
  - explain the slow-down

# Introduction

## Research questions

### Evaluate hardware performance

- Ergo is made with off-the-shelf components
- Unclear whether they are suitable for high-frequency data capture
- Unclear whether they are accurate enough to distinguish different gestures

### Compare algorithm performance

- Five classification algorithms are compared
  - These will be introduced shortly
- Each algorithm has numerous parameters that control their behaviour
  - Different values for these hyperparameters are also tested

### Extract gestures from background noise

- Ergo makes continuous predictions about what gesture is currently being
  performed
- There are 50 different gesture classes that Ergo can classify, as well as 1
  class that represents the "background noise" that occurs in between gestures
- Since a gesture takes a fraction of a second to perform, the majority of
  predictions will be that "there's no gesture here"
- The ability of the algorithms to distinguish gestures from background noise
  will be evaluated

### Assess impact of background noise on performance

- The presence of non-gesture observations will likely impact the performance
  of any algorithm
- To evaluate this performance impact, all algorithms will be tested on the
  full dataset (with gesture and non-gesture observations) as well as a partial
  dataset with all the non-gesture observations removed.
  - If the performance on the full dataset is much better than on the partial
    dataset, then we can conclude that the non-gesture observations have a
    large impact on the performance of the algorithm

### Assess classification speed

- Given that the purpose of Ergo is as a full keyboard replacement, the
  classification speed of all algorithms is also important
- Any viable algorithm should be able to make a classification faster than the
  hardware can measure a new observation in order for the algorithm to be
  viable for real-time use.

# Background

## Models and Algorithms

Show one picture for each model, and give one short explainer for each model,
giving seminal reference.

Give a slide describing $F_1$ score, macro average, weighted confusion
matrices, why I chose to column norm, and how this relates to precision (and
not recall)

### FFNNs

- Neural Networks classify input data by taking in multiple inputs passing
  those inputs through layers of nodes.
  - Each node collects several inputs, performs some simple arithmetic, and
    passes the result to the next sequence of nodes.
- Neural networks can learn the training data by iteratively updating the
  parameters used in the nodes as they perform the simple arithmetic.

### SVMs

- Support Vector Machines classify input data by finding a boundary (solid
  line) that maximally separates the two classes of data (hollow and filled
  circles).
- This can be expanded to multi-class classification by training multiple SVMs,
  each of which learns to separate one class from all other classes.

### HMMs

- Hidden Markov Models learn to model data from a specific class or
  distribution.
- They do not explicitly perform classification, but we can use them for
  classification by training one HMM per class and seeing which HMM best fits
  some unknown observation.
- HMMs contain some hidden state which updates each time step according to some
  learnt distribution.
- Each state has some probability of emitting an observed value.
- As the HMM changes its state, it emits values based on the state that it is
  in. In this way it naturally mimics a time series dataset.
- We train one HMM for each class in the dataset. To classify an unseen
  observation, we poll every HMM and choose the class corresponding to the HMM
  with the greatest log-likelihood that the given observation came from that
  HMM.

### CuSUM

- Cumulative Sum (or CuSUM) is traditionally used for online outlier detection.
- It works by keeping track of a sum of all previously seen values.
  - When a new value arrives, it is subtracted from some threshold value. If
    the result is positive, it is added to the cumulative sum.
  - The cumulative sum is monitored, and if it exceeds a maximum allowed
    value then an alarm is raised and the sequence is said to be out of
    distribution.
- It can be used to identify when a gesture starts for a single sensor, and by
  combining multiple CuSUM algorithms a classifier that detects which gesture
  is being performed can be constructed.

## Evaluation Metrics

### Confusion Matrices

- When evaluating a multi-class classifier, there are many ways for it to make
  a mistake. A confusion matrix is a useful summary of how a classifier
  performed on different classes.
- Each row represents the true class of an observation, and each column
  represents the class of an observation as predicted by the classifier in
  question.
- The value (and colour) of each cell indicates how frequently the classifier
  predicted an observation belonged to one class when the observation actually
  belonged to some other class.
  - Here we can see that this example classifier correctly predicted that the
    two observations belonging to class 0 did indeed belong to class 0,
    indicated by the two in the top-left corner.
  - By the column of 1s, we can see that the classifier really likes class 2,
    and is over-eager in predicting that every observation belongs to class
    two.
- The Ergo dataset has classes with different numbers of observations.
  - This tends to make confusion matrices difficult to interpret.
- All confusion matrices in this thesis are column-normalised, so that the
  values in each column sum to one. The cell in column 2 and row 1 can then be
  interpreted as the proportion of observations predicted as belonging to class
  2 that actually belong to class 1.
- Similarly, the cells along the diagonal of the normalised matrix is the
  proportion of correctly classified observation.

### Precision, Recall

- Precision looks at all the predictions for a certain class, and tells you
  what proportion were classified correctly

- Recall looks at all the observations belonging to a certain class, and tells
  you what proportion were classified correctly

- Rows are the recall, columns are the precision

### $F_1$-score

- A way of describing both precision and recall
- One metric to evaluate a multi-class classifier
- A model has to good at both precision and recall to have a high $F_1$-score

# Literature Review

Always go back to the research questions. The lit review should justify why you
made the choices you did.

Explain the swarm plot and how to read it

Don't skimp on the literature review. The lit review explains why you did what
you did (wrt tech, hardware, etc). Explain this explicitly, "I used HMMs
because they're popular"

- Gesture classification has also been done with WiFi and with Vision, we won't
  be talking about that here.

## Seminal work

- Seminal review paper by Sturman and Zeltzer in 1994 following Sturman's 1992
  dissertation.
  - They focussed on the available hardware systems at the time.
- Another survey was done by LaViola in 1999 who focussed more on the models
  and techniques for glove and vision-based classification

## Tech used

## Number of classes

## Model(s) used

## Gesture fidelity

## Explicit or implicit segmentation

# Methodology

## Circuit diagram

10x accelerometers -> multiplexer (&why) -> Nano -> computer
TODO: explain why the multiplexer

## Gestures to Keystrokes

- 50 gestures required for full keyboard input
  - numerals, punctuation, letters, white space, control characters)
- Use ten fingers and five orientations

## Gesture indices

- Each gesture is given an index, between 0 and 49 (inclusive)
- Gestures are labelled semantically, so that the tens digit corresponds to the
  orientation of the hands and the units digit corresponds to the finger being
  flexed.
- For example: gesture 6 is the spacebar, and is right hand index finger at
  0deg rotation. gesture 34 is left hand thumb at 135deg orientation and would
  type a `t`.

## Class 50 - Background Noise

- Explain what class 50 is
- Explain that it's important and will come up later
- Explain that most time steps are labelled as gesture 50, the minority are
  split between the other 50 classes.

## Data Windowing

TODO

Emphasis that we want 50 gestures for full keyboard input (numerals,
punctuation, letters, white space, control characters). We have 10 fingers, so
lets do the Cartesian product with 5 orientations.

Spend lots of time describing how the gestures work, that you came up with them
yourself, and that they are designed to be easy for the lay-person to learn.
Clearly explain how the mapping is similar to the qwerty keyboard

Elaborate on how the classifier makes 40 predictions per second, and that the
gesture label is positioned at the start of the gesture. Add a nice graphic for
this (maybe 4.1 paired with gesture labels?). Explain that all other gestures are labelled as gesture 50. Emphasis that
this will be important later on as the models will struggle with gesture 50.

Add in Figure 4.2 that explains how the full dataset gets windowed. do this
before explaining how each model is trained.

Just say that hyperparameter optimisation was done via random search, don't go into the
details.

## Hyperparameter optimisation

Done via random search

## HFFNN

also need to describe these

# Results

Maybe add a quick refresher about what a good confusion matrix looks like

## CuSUM

## HMMs

## SVMs

## FFNNs

## HFFNNs

For each of the models:

- CuSUM: incl figure 5.1, show that it works for 5 classes but not the others
  (explain the confusion matrix again). Explain why CuSUM fails
- Other models?...

Need to show some plot that shows the models work in real time. Include
stripplot for validation inference time and a line at 0.025s, showing that most
models succeed in this metric.

Skip over the test set, just say the F1 score and that it shows nothing new

Go to the real-world dataset and explain how it works in practice. Explain that
it's good, and that there's a post-processing step that ensures that if a
letter is predicted sequentially, only the first prediction is made.

# Conclusion

Answer the research questions one by one, with reference to the parts of the
talk that answered them

One of the contributions of this work is the largest labelled
accelerometer-based dataset publicly available. Hopefully will lead to more
developments and better insight
