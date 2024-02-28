# Boyd Kane MSc Oral

Speaking notes

# Pre-oral prep

- MS teams set up?
- external examiner can hear & see the screen and can speak?
- Don't forget a laser pointer!

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
- Describe the dataset of the literature, it being public, and how many papers
  were surveyed

## Seminal work

- Seminal review paper by Sturman and Zeltzer in 1994 following Sturman's 1992
  dissertation.
  - They focussed on the available hardware systems at the time.
- Another survey was done by LaViola in 1999 who focussed more on the models
  and techniques for glove and vision-based classification

## Tech used

- This is a swarmplot
  - Each point represents one research paper
  - The y-axis shows the technology used in that research paper
  - The x-axis shows the publication year of that paper
  - The colour of each point shows the number of citations
  - If there are multiple papers published in the same year that use the same
    technology, they are clustered (or "swarmed") together along the same
    horizontal line.
- This plot shows the hardware used for various glove-based systems over time.
- Flex sensors used to be popular, but accelerometers are now so cheap and
  accurate that they are a very popular choice.
  - This is why I used accelerometers for Ergo

## Number of classes

- This plot shows the number of gesture classes recognised by various research
  papers. Note that a log-scale is used due to the large range of classes.
- The three papers with around 5000 classes is Wang Chunli, Gao Wen, Ma Jiyong
  (Chinese Sign Language) but it was not in real time and presented a very
  complicated composite model architecture
- The majority of experiments are able to classify fewer than 30 gestures, not
  allowing for full human-language communication.
- Ergo can recognise 50 different gestures, allowing for full English keyboard
  input including letters, numerals, punctuation, and control characters

## Algorithms used

- NN and FFNN based approaches are common
- HMM based approaches are also common
- Support Vector Machines are different from the neural-network based
  approaches but still commonly used.
- With HMMs, SVMs, and NNs a wide variety of different modelling algorithms are
  used.
- CuSUM is used as a baseline algorithm so that the performance of any other
  algorithm can be reasonably be compared
- The outliers are XXX

## Gesture fidelity

- Not all gestures are created equal. It is much easier to recognise a
  "gesture" that just requires the user to wave their arms than to recognise a
  subtle finger movement.
  - This will be referred to as the gesture's _fidelity_.
  - Gestures requiring arm-level fidelity could be performed with a full-hand
    plaster cast (such as waving or drawing letters in the air).
  - Gestures requiring hand-level fidelity could be performed with a heavy
    woollen mitten (such as making a fist or swiping back and forth).
  - Gestures requiring hand-level fidelity require full finger motion, such
    as most sign language signs
- Most research papers do not explicitly acknowledge the fidelity of their
  gestures, so comparisons are difficult to make.
- While finger-level fidelity poses more technical challenges, it also permits
  a greater number of unique gestures to be performed.
- The gestures that Ergo can recognise are finger-level, such that more
  gestures can be recognised.

## Explicit or implicit segmentation

- Another unspoken differentiator is gesture segmentation, or the end-point
  problem
- For a user-friendly product, a user should be able to perform gestures
  without having to manually indicate the start or end of the gesture.
- That is, the algorithm should implicitly segment the continuous stream of
  data into gesture and non-gesture portions.
- However, performing implicit segmentation often increases the difficulty of
  the problem,
  - by adding an additional class to be recognised and
  - by often introducing a large imbalance in the class proportions
- Explicit segmentation requires the user to mark the start and end of each
  gesture.
  - Often this is not explicitly stated in the paper, and the researcher simply
    records a continuous stream of data that later gets manually segmented
    before training a classification algorithm
- To improve the user experience, Ergo will not require the user to manually
  mark the start and end of each gesture.

# Methodology

## Circuit diagram

- Ergo consists of two nearly identical modules, one for each hand
- Each hand has 5x accelerometers mounted on the user's fingertips
- The measurements from these accelerometers are passed to an Arduino Nano
  Microcontroller.
  - But the Arduino Nano does not have enough analogue input ports to read
    all fifteen signal lines, so the measurements from the accelerometers
    need to be passed through a multiplexer
- The measurements from the left hand's Arduino is sent to the right hand
- The data from both hands is combined in the right hand's Arduino, and this
  data is then sent to the computer where it is read and stored to disc or used
  in live gesture processing.

## Gestures to Keystrokes

- For now we will assume the classification algorithm is a black box that can
  do its job perfectly.
- Once we know what gesture was performed, our job is not done, we still need
  to convert gestures into keystrokes
- 50 gestures required for full keyboard input
- Use ten fingers and five orientations
- 0deg through 180deg, and ten fingers
- Exactly which gesture is matched with which keystroke is designed such that
  a QWERTY keyboard user can easily pick up.
- The columns of the top table shows the finger used in the gesture
- The rows show the orientation of the hands
- The cells show what keystroke is emitted
- Note how it is nearly identical to the QWERTY keyboard
- This allows a new user to use their knowledge of the QWERTY keyboard when
  learning how to use Ergo

## Gesture indices

- To decouple the gestures from the keystrokes, each gesture is given an index,
  between 0 and 49 (inclusive)
- Gestures are labelled semantically, so that the tens digit corresponds to the
  orientation of the hands and the units digit corresponds to the finger being
  flexed.
- For example: gesture 6 is the spacebar, and is right hand index finger at
  0deg rotation. gesture 34 is left hand thumb at 135deg orientation and would
  type a `t`.

## Class 50 - Background Noise

- As mentioned in the literature review, Ergo does not require the user to
  explicitly indicate when a gesture starts and ends, it is figured out
  automatically.
- This means that we actually need one extra class, class 50, to represent the
  background noise present between gestures.
- Here's an example slice of some data from Ergo
- The top plot shows one line per sensor, with time on the x axis and the
  raw sensor readings on the y axis
- The bottom plot is a heat map, with the colour of each cell showing the
  sensor reading and the y-axis indicating the sensor
- Both plots show the same data
- The plots show the data as two gestures were being performed (indicated by
  the black lines), gestures 4 and then 0.
- Even though a gesture takes a period of time to perform, only the start of
  a gesture is labelled. All other time steps are labelled as gesture 50, here
  indicated by a period `.`
- 97% of the dataset is labelled as belonging to gesture 50

## Data Windowing

- The continuous stream of data is partitioned into windows.
- Each window is 20 consecutive time steps in length
- Note that each $t$ in this diagram represents a vector of 30 measurements

## HFFNN

- One additional model architecture is introduced
- A Hierarchical model, where
  - one neural net is used to detect whether or not a gesture is present,
  - and then another neural net is used to detect which gesture is present,
    given that the first NN things a gesture is indeed present

# Results

## CuSUM

- All models were tested over multiple hyperparameter combinations.
- Models were tested on 3 different datasets:
  - 5-classes: to test that the model is working
  - 50-classes: excludes the background class, equivalent to explicit
    segmentation, easier task
  - 51-classes: Includes all classes, even the background class 50. The
    "real" dataset, indicative of real-world performance.
- In order to visualise the performance of multiple models, the confusion
  matrices for all models were calculated, weighted by the $F_1$-score of that
  model, and then summed together.

  - The resulting confusion matrices can be seen as a weighted average of all
    confusion matrices.

- From the top left confusion matrix you can see that the CuSUM model somewhat
  accurately classifies the 5-class dataset, however it fails to accurately
  classify the 50 and 51-class datasets.
- With 50 classes, it confuses the orientation of the two hands together,
  leading to the chequerboard pattern.
- with 51 classes, it also confuses the orientations of the hands, but also
  frequently classifies a background observation as a non-background
  observation.

## HMMs

- HMMs also perform somewhat accurately with five classes and with 50 classes,
  but performed very poorly with 51-classes
- This was largely a computational problem.
  - The 51-class dataset is approximately 40 times larger than the 50-class
    dataset due to the addition of class 50.
  - The model training procedure for HMMs does not scale well as the number
    of observations increases, and the computational limits of the training
    hardware were reached before the 51 HMMs could be trained on the full
    dataset.

## SVMs

- SVMs performed very well on the 5, 50, and 51-class datasets
- The red diagonal lines are the SVM getting the finger correct but incorrectly
  predicting the orientation of the gesture
- The SVMs also often predict that a class-50 observation belongs to a gesture
  class.

## FFNNs

- The NNs perform well on all datasets
- Their performance was the most varied, there were many hyperparameters which
  could affect the performance of the NNs
- Many FFNNs performed poorly, but some performed very well.

## HFFNNs

- The HFFNNs were not evaluated on the 5- and 50- class datasets as they
  require a background class, which is only present in the 51-class dataset.
- The HFFNNs performed well

## Comparison between the models

- Each dot shows a single model.
- The left plot shows the $F_1$ score of all models
- The right plot shows the precision and recall of all models
- Naturally, the colours are consistent, so the blue dots represent the FFNN on
  both plots.
- The best FFNNs outperformed all other models.
- The best HFFNNs outperformed all models except the FFNNs
  - The addition of another NN to aid in background detection did not help
- The SVMs performed well, with low variance.
- The HMMs and CuSUM models failed to learn the data, as previously mentioned.
- The best performing model (a FFNN) has an $F_1$-score of 0.75.

## Real-world typing (1)

- To make this more intuitive, here's an example of what typing with the best
  model looks like
- This data shows the phrase "the quick brown dog jumped over the lazy dog"
  being typed using Ergo.
- But we'll focus in on a small snippet, the word "quick "

## Real-world typing (2)

- The bottom line plot shows the raw sensor readings over time
- The top plot shows the keystroke probabilities as predicted by the best
  performing model over time
- Each of the vertical lines is actually a single instant where the model
  predicted an actual gesture as being typed.
- The green boxes indicate a correct prediction for a certain keystroke, along
  with the model's predicted probability of that keystroke.
- The red boxes indicate incorrect or low-confidence predictions.
  - We can see that the model gets every keystroke correct, but occasionally
    gets the exact timing of the keystroke incorrect, leading to
    low-probability

## Inference Speed

For real-time predictions, each observation must be predicted in less than
1/40th of a second (the amount of time the hardware requires to take a
measurement.

Only some of the HMMs fail this metric, all other classifiers easily pass. The
failed HMMs had different hyperparameters to those which passed.

# Conclusion

One of the contributions of this work is the largest labelled
accelerometer-based dataset publicly available. Hopefully will lead to more
developments and better insight

- Evaluate hardware performance
  - The hardware is able to take measurements at 40 times per second, more
    than fast enough for human gesture measurement.
- Compare algorithm performance
  - The FFNNs performed the best overall
  - HFFNNs performed well, but required significantly more resources to train
  - CuSUM was unable to learn the data
  - HMMs were too computationally expensive and had to be dismissed
  - SVMs performed well, but not the best
- Extract gestures from background noise
  - By comparing the HFFNNs (which had a dedicated model for extracting
    gestures) and the FFNNs (which had to learn to extract gestures) we can
    see that using a separate NN model to extract gestures does not improve
    performance
- Assess impact of noise on performance
  - All models showed a substantial decrease in performance when the
    background noise (gesture 50) was added.
  - This indicates that requiring a model to implicitly recognise gestures
    from background noise is a difficult task
- Assess classification speed
  - Only some of the HMM models were too slow to meet the real-time benchmark.
    The fastest models were the FFNNs.
