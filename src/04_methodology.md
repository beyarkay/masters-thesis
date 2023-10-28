This chapter will describe the construction of the hardware that powers _Ergo_,
how the training data was collected and processed, what experiments were
conducted, and how different model architectures were applied to the task of
predicting gestures given an observation. Hyperparameters of those models (and
their optimisation) is also discussed. The evaluation metrics used to rank the
models is discussed, and the method for turning gesture predictions into
keystrokes is described

<!--

Explain that "class" shall refer to any class 0..=50, gesture class to any
class 0..=49, and non-gesture class to class 50

TODO: Ensure this is fully integrated

TODO explain how the 51-class HMMs ran into computation limits

TODO: Explain how dropout works:
- it reduces the training loss
- it is only applied during training
- during validation, the output is normalised so the output of each layer is
  the same
- dropout is applied to the output of each layer

TODO: have an explanation that precision/validation/f1 is always on the
validation set unless otherwise noted.

 ## (Some things I'll cover in the Methodology chapter)

Hi Professor, this section will be removed, but I found there were a few times
where I needed to mention something but that thing was better mentioned in the
methodology chapter rather than the results chapter. So this section just has
some things which I'll write up in the methodology chapter, but which I thought
would be confusing to not acknowledge at all:

1. How do HMMs/CuSUM/SVMs go from binary classifiers to multi-class classifiers

TODO:
One thing an examiner will look at is if your methodology is correct. Did you
split training/test and validation. Was there leakage. How big is each set...
How did you do hyperparameter tuning. None of this is clear.... Please make
sure it is. Remember an examiner is looking for different things than what you
are interested in. You want to show how each mode is doing on 51 classes. The
examiner is checking;

-->

# Construction of Ergo

_Ergo_ is, at its core, a set of acceleration sensors mounted onto the user's
fingertips (see Figure \ref{fig:04_accelerometers}).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.33\textwidth]{src/imgs/accelerometers.jpg}
    \caption{\emph{Ergo} consists of ten ADXL335 tri-axis linear
    accelerometers, each one of which is mounted to the back of the user's
    fingertips (highlighted in red)}
    \label{fig:accelerometers}
\end{figure}
<!-- prettier-ignore-end -->

These sensors measure acceleration in three orthogonal axes. Acceleration due
to gravity is included in these measurements. The measured values are collected
together using two microcontrollers (one on each hand) and then sent to the
user's computer via a serial wire. Each sensor has three signal lines for
output (describing the acceleration measured by the X, Y, and Z axes, see
Figure \ref{fig:04_adxl335_xyz}).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.33\textwidth]{src/imgs/accel_xyz.jpg}
    \caption{The user's left hand while wearing \emph{Ergo} with the
    accelerometer directions indicated. The X direction is in red, the Y
    direction is in green, and the Z direction is in blue. Note that the sensor
    on the thumb is rotated relative to the sensors on the fingers.}
    \label{fig:04_adxl335_xyz}
\end{figure}
<!-- prettier-ignore-end -->

This results in 15 signals per hand, which is too many for one microcontroller
to accept as input. To solve this problem, a 16-to-1 multiplexer is introduced
such that the microcontroller (using four selection control wires) can choose
which of the 15 inputs it would like to read data from. The microcontroller
repeatedly polls each of the inputs until it has one set of data readings, and
then this packet of data is sent via the serial port to the user's computer.

On the user's computer, it is associated with a time stamp. What happens next
is dependant on whether the software is configured to capture the data or to
feed the data to a classification model in real time.

# Data collection and Cleaning

To collect training data, the author wore the device and performed the gestures
for a sufficient amount of time to get enough data. As the gestures were being
performed, the data were stored to disc along with a timestamp of when the
measurements were received.

In order to facilitate the labelling of this data, a marker was placed in the
stored data approximately every half second, and a gesture was performed every
half second such that the marker and the gesture were approximately aligned.

Accurate real-time data labelling is not possible due to the authors hands
being occupied in performing the data as well as due to the speed at which each
gesture is performed.

Preliminary model training showed that these markers are not well-aligned
enough with the actual gestures for accurate predictions to be made. One marker
might be aligned with the start of a gesture, and the other with the end of the
gesture. This hampered performance in the preliminary models.

To remedy this, all markers are manually aligned such that they all coincide
with the same portion of each gesture. This ensures that the observations
labelled as one gesture all represent the same portion of that gesture.

To enable the collection and labelling of a large dataset, gestures were
performed in batches of 5 unique classes at a time. The data from each batch
was saved in a separate file. The reduction in the number of gestures which
could be present in a file allowed the sensor data immediately before and after
a marker to be manually analysed and compared against the known five gesture
classes which are present in that file. The marker can then be replaced with a
label for that gesture class, and the position in time of that label can be
adjusted such that the new observation and all previous observations are
aligned as close as possible to one another.

This process is repeated for all observations of all gesture classes. 5767
gestures were performed, resulting in a dataset of 241762 observations of 30
different sensor readings. On average 115 observations were recorded per
gesture class.

# Splitting the data into train, test, validation \label{sec:trn_tst_val}

The measurements recorded from _Ergo_ are stored on disk as several files
listing the time stamp, the 30 sensor values, and the associated gesture with
that particular time stamp. There are 37MB and 241 762 lines of data.
Preliminary testing showed that models trained on just a single instant of time
did not perform as well as models provided with a historical window of data.
For this reason, the entire dataset is combined together and then windowed to a
size of 20 timesteps, so as to produce a dataset of shape $(\text{number of
observations}, 20, 30)$.

25% of this dataset is split off and saved as the testing dataset. It is saved
as a single binary file, completely separate from the training and validation
data. The test-set-splitting procedure is designed to ensure that the frequency of the
different classes is maintained, but otherwise chooses a random subset of the
full dataset.

The remaining 75% of the dataset is saved to disc as a single binary file. The
training-validation dataset is only split into separate training and validation
datasets at training time, just before each model is fit to the training
subset. This split is random, but the pseudo-random number generator (PRNG) is
initialised with a seed based on the model type, hyperparameter set, and
repetition number, such that each training-validation split is different but
reproducible. Splitting the dataset into training and validation datasets based
on a PRNG also allows for an arbitrary number of repetitions to be made for
cross validation.

The exact procedure is given in Algorithm \ref{alg:04_hyperparam_search}.

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption{Hyperparameter Search and Model Evaluation}
    \label{alg:04_hyperparam_search}
    \begin{algorithmic}
    \Procedure{HyperparameterSearch}{}
        \State Load the training+validation dataset from disc
        \State $dataset \gets$ \Call{LoadData}{}
        \While{Not all hyperparameters are exhausted or computational budget not reached}
            \State Select a model type
            \State $hyperparameters \gets$ new set of hyperparameters
            \For{$repetition$ in 1 to 5}
                \State $seed \gets$ \Call{GetSeed}{$hyperparameters$, $repetition$}
                \State Split the training+validation dataset based on $seed$
                \State Train the model on the training dataset
                \State Evaluate the model on the validation dataset
                \State Store the results to disc
            \EndFor
        \EndWhile
    \EndProcedure
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

As each set of hyperparameters is trained and evaluated multiple times on a
random subset of the training+validation dataset, an approximate confidence
interval can be obtained for the performance of each model. This allows
statistical bounds to be placed on the performance of each model on the test
set and other unseen data which might have a different underlying distribution
to the training+validation dataset.

It should be noted that every model was provided with the same format for the
observation data: a 600 dimension vector that originated from a $20 \times 30$
matrix that had been flattened. The 20 comes from 20 timesteps of history, and
the 30 from the 30 sensors.

# Explicit vs implicit segmentation

In the _Ergo_ dataset, gestures are not explicitly segmented from the
surrounding background noise. That is, there are no markers which inform any
machine learning algorithm when a gesture begins and when it ends. Much prior
work provides impressive results

Data segmentation is "implicit": There's no nice labels marking the start
and end of each gesture, the model has to learn 1. how to extract
gestures from background and 2. how to differentiate between the
different gestures.

# Experimental Procedure

Experiments will be conducted so as to answer the research questions posed in
the Introduction. The following experiments will be performed

- Evaluate multiple {hmm|cusum|hffnn|ffnn|svm} models on the
  training-validation set
- Then what?

<!--- TODO
(These should tie into the "research questions" asked in the introduction, so
probably need to come up with those first)
-->

# Design and Implementation of the Different Models

## Hidden Markov Models

For Hidden Markov Models (HMMs), the data was interpreted such that there is a
start state, an end state, and one additional state for each time step. Each
state emits a 30-dimensional Gaussian distribution. There is one HMM for each
class, including the non-gesture class. Each Gaussian distribution has a mean
vector and a covariance matrix as parameters which are learned during the
Baum-Welch expectation maximisation algorithm. To potentially reduce the number
of parameters which need to be learned, the covariance matrices for each HMM
can be one of four different types, each of which constrains the covariance
matrix in some way such that the full matrix need not be learned. In order from
least constrained to most constrained:

All HMMs had their parameters estimated over 20 iterations of the
Expectation-Maximisation algorithm.

- Full covariance matrix: each state uses its own full, unrestricted,
  covariance matrix.
- Tied covariance matrix: each state use the same shared, full covariance
  matrix.
- Diagonal covariance matrix: each state uses a diagonal covariance matrix.
  $\bm{\lambda} I$
- Spherical covariance matrix: each state uses a single variance value that
  applies to all features $\lambda I$

Calculating the number of parameters in each of the covariance types provides a
crude estimate for the complexity, and can be seen in Table
\ref{tab:04_covariance_comparison}.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{Comparison of Covariance Types in a Gaussian Mixture Model}
    \label{tab:04_covariance_comparison}
    % \begin{adjustbox}{width=1\textwidth}
    \begin{tabular}{|c|c|c|c|c|}
        \hline
        Covariance Type & \#Gaussians   & Params/Gaussian & Total Parameters \\
        \hline
        Full            & 22            & $30 \times 30$  & 19800            \\
        Tied            & 1             & $30 \times 30$  & 900              \\
        Diagonal        & 22            & 30              & 660              \\
        Spherical       & 22            & 1               & 22               \\
        \hline
    \end{tabular}
    % \end{adjustbox}
\end{table}
<!-- prettier-ignore-end -->

The Forward Algorithm for HMMs allows the log-likelihood of a particular
observation originating from hue same distribution as that which the HMM was
trained on can. To make a prediction for a certain observation, the forward
algorithm is run for each of the 50 HMMs and the log-likelihood that the given
observation originated from the distribution modelled by that HMM is obtained.
These 50 log-likelihoods are compared and the HMM providing the maximum
log-likelihood is selected the prediction for that observation.

It must be noted that training the Hidden Markov Models resulted in significant
problems due to the size of the dataset. Training one HMM on each of the
gesture classes encountered no difficulties, however training a HMM to the
distribution of class 50 on every observation of class 50 proved impossible.
Training times for the class 50 HMM either exceeded 6 hours (at which point
they were stopped) or were killed by the operating system due to excessive
memory usage. For this reason, all HMMs were only trained on a subset of 1000
observations of class 50. During calculation of the validation performance, all
HMMs were evaluated on all validation observations.

While some prior research has used 5000 HMMs for a 5000-class classification
task, that required several complicated wrappers and that was not done for this
project.

## Cumulative Sum

Cumulative Sum (CuSUM) is designed for real-time univariate time series out of
distribution detection. It requires adjustments before it can be used
for 30-dimensional time series multi-class classification. For the CuSUM
classifier, 30 CuSUM algorithms will be running on the 30-dimensional dataset
so as to detect if any of the 30 sensor measurements become out of bounds.
These out-of-distribution indicators will then be converted into gesture
classifications based on which of the sensor measurements were
out-of-distribution.

The original CuSUM algorithm is only able to detect when the time series
exceeds a threshold, and is not suitable to two-sided detection where a time
series could dip below some threshold. That is, it is not able to signal when a
time series leaves a band of allowed values, and can only signal when a time
series exceeds some threshold value. The original algorithm can be modified
however, such that there is one procedure that alerts on values which exceed
some upper bound and another similar procedure that alerts on values which fall
below some lower bound.

CuSUM only has one parameter, the threshold value.

To "fit" a CuSUM classifier to the data for a multi-class classification task, one
CuSUM model is trained for each gesture.

For each observation of a given gesture the same procedure, the reference value
is set to the first 5 values of the observation. CuSUM is run on that
observation, and if it is either too high or too low, that sensor is marked for
that gesture.

Once this has been repeated for all observations of a gesture, an average is
taken to see, on average, which sensors are alerted for which gestures.

Then to classify an observation, we run CuSUM on the given observation and
compare the sensors which did alert with the reference values. We take the
difference between them, and figure out which one is closest to the recorded
ood values for each sensor.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{CuSUM Classifier Fitting with Sensor Averages}
\label{alg:cusum-clf}
\begin{algorithmic}
\Require Threshold: $threshold$
\Require Dataset: $dataset$ of shape $(\text{num\_observations}, \text{num\_timesteps}, \text{num\_sensors})$
\Require Labels: $labels$ of shape $(\text{num\_observations},)$ in the range $0$ to $50$
\Require Sensor Averages: $sensor\_averages$ of shape $(\text{num\_sensors},)$
\For{$gesture = 0$ to $50$}
    \For{$sensor = 1$ to $\text{num\_sensors}$}
        \State Initialize $sensor\_count$ as an array of zeros with length $\text{num\_sensors}$
    \EndFor
    \For{$obs = 1$ to $\text{num\_observations}$}
        \If{$\text{label of observation} = \text{gesture}$}
            \For{$sensor = 1$ to $\text{num\_sensors}$}
                \State Perform CuSUM on sensor's time series for the observation
                \If{lowest Cumulative Sum is below $threshold$ or highest Cumulative Sum is above $threshold$}
                    \State Increment $sensor\_count[sensor]$ by $1$
                \EndIf
            \EndFor
        \EndIf
    \EndFor
    \For{$sensor = 1$ to $\text{num\_sensors}$}
        \State Calculate the average as $sensor\_averages[sensor] = \frac{sensor\_count[sensor]}{\text{num\_observations}}$
    \EndFor
\EndFor
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

- Describe in obscene detail the exact architecture of the CuSUM and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- How does CuSUM perform one-vs-rest classification, how does "passing a
  threshold" get transformed into a gesture detection?

The CuSUM algorithm is given in Algorithm \ref{alg:cusum}.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{CuSUM Algorithm}
\label{alg:cusum}
\begin{algorithmic}
\Require Data stream: $x_1, x_2, \ldots, x_n$
\Require Thresholds: $h$ (positive) and $k$ (negative)
\Require Reference value: $r$
\Require Initial values: $S_0 = 0$, $D_0 = 0$
\For{$i = 1$ to $n$}
    \State Calculate the incremental change: $d_i = x_i - r$
    \State Update the cumulative sums:
    \If{$d_i > 0$}
        \State $S_i = S_{i-1} + d_i$
        \State $D_i = D_{i-1}$
    \Else
        \State $S_i = S_{i-1}$
        \State $D_i = D_{i-1} - d_i$
    \EndIf
    \If{$S_i > h$ \textbf{or} $D_i > k$}
        \State \textbf{Alarm condition met.}
        \Comment{Anomaly detected.}
        \State \textbf{Take action as needed.}
    \Else
        \State \textbf{No alarm condition met.}
    \EndIf
\EndFor
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

## Feed-forward Neural Networks

The Feed-forward Neural Networks had several hyperparameters, but there were
some constants:

- All observations are normalised on the training set to have zero mean and
  unit variance
- All layers use the ReLU activation function
- All layers have dropout after the dense layer (TODO: convert this away from
  tensorflow speak)
- All layers have L2 regularisation
- The input of 20 x 30 is flattened before being passed through the network (no
  convolution layers)
- The last layer has 51, 50, or 5 output neurons
- The optimiser is Adam
- SparseCategoricalCrossentropy is used as the loss function
- Class weights are used such that the weight of a class is proportional to $\log_10(1/count)$
- Predictions are done by looking at the largest value of the output neurons
- Prediction probabilities are calculated using softmax
- There are always 40 epochs completed

The ReLU activation function is used for all FFNNs:

<!-- prettier-ignore-start -->
\begin{align*}
    \text{ReLU}(x) = \begin{cases}
        x, & \text{if } x > 0 \\
        0, & \text{if } x \leq 0
    \end{cases}
\end{align*}
<!-- prettier-ignore-end -->

Categorical Cross Entropy Loss is used as the loss function for all FFNNs:

$$
    L(\bm{y}, \hat{\bm{y}}) = -\sum_{i=1}^n y_i \cdot \log(\hat{y}_i) \cdot \text{weight}_i
$$

Where:

- $y_i \in \{0, 1\}$ is the ground truth prediction for class $i$.
- $\hat{y}_i \in [0, 1]$ is the predicted probability for class $i$.
- The summation is performed over all $n$ classes.
- $\text{weight}_i$ is the weight of class $i$.

The weight of each class is determined by the formula below, where
$\text{count}_i$ is the count of samples in the class.

$$
    \text{weight}_i = -\log_{10}\left( {\text{count}_i} \right)
$$

L2 normalisation is applied

The L2 regularization penalty is computed as: $loss = l2 * reduce_sum(square(x))$

Cost added is proportional to the square of the value of the weights
coefficients

L2 regularisation is only applied to the weights of the FFNN, and not the
biases

Dropout is applied after each layer of neurons, such that a random number of
the output of the neurons is set to zero. The neurons which were not set to
zero have their output scaled up by $(1 - \text{dropout rate})^{-1}$. This
ensures the sum of the output of all neurons remains the same regardless of
exactly how many neurons were dropped out.

As it is a regularisation technique to decrease overfitting, dropout is only
applied during training; no neurons have their output dropped during inference.

## Hierarchical Feed-forward Neural Networks

Hierarchical Feed-forward Neural Networks are an extended version of the FFNN
and operate in nearly the same manner.

One FFNN is the majority, and it is a binary classifier in charge of detecting
whether or not a gesture exists in the observation.

The other FFNN is the minority FFNN, and it is only invoked if there is a
gesture present as detected by the majority FFNN.

The only additional hyperparameter is that the majority and minority FFNN can
be trained for a variable number of epochs each, in the range from 5 to 40.

Algorithm \ref{alg:hffnn_prediction} shows the procedure for making a
prediction using the majority and minority classifiers.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{Prediction Algorithm}
\label{alg:hffnn_prediction}
\begin{algorithmic}
\Procedure{predict}{$X$}
    \State Initialize an empty array $y\_pred$ of the same length as $X$
    \For{$i = 1$ to length($X$)}
        \If{$\Call{predict\_with\_majority}{$X[i]$} = 0$}
            \State $y\_pred[i] \gets$ \Call{predict\_with\_minority}{$X[i]$}
        \Else
            \State $y\_pred[i] \gets 50$
        \EndIf
    \EndFor
    \State \textbf{return} $y\_pred$
\EndProcedure
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

## Support Vector Machines \label{models-specifics-svm}

Support Vector Machines (SVMs) do not support multi-class classification
natively, and so for an $n$-class classification problem, $n$ different SVMs
have to be fit to the data, where the $i$-th SVM is trained to predict whether
an observation belongs to class $i$ or not. Each of these SVMs can then be
polled in order to decide whether a given observation belongs to each class.

All SVMs were trained for 200 iterations with a linear kernel. One
hyperparameter, the class weight was iterated to weight the influence of each
class based on it's prevalence in the training dataset. The regularisation
hyperparameter $C$ is used as by @bishopPatternRecognitionMachine2007.

# Procedure for Hyperparameter Optimisation

Hyperparameter optimisation is the procedure of searching over a (usually
large) space of hyperparameters, with the goal of finding a set of
hyperparameters which optimise some objective function. As _Ergo_ has five
different model types with five different hyperparameter spaces, hyperparameter
optimisation is done separately but identically for each model type.

Methods for computationally efficient hyperparameter optimisation is a field of
active research, however broadly there are three kinds of hyperparameter
optimisation: grid search, random search, and intelligent search.

Grid search is the simplest to implement, and requires that all hyperparameters
are sets with finitely many elements. Grid search will then iterate over every
combination of the hyperparameters, calculating the objective value in each
case. If there are $N$ hyperparameters $h_1, h_2, \ldots, h_N$, and
each hyperparameter $h_i$ has $n_i$ possible values, then the total number of
hyperparameter combinations to search is

$$
    \prod_{i=1}^N n_i.
$$

Once every combination has been evaluated, the combination which resulted in
the optimal objective value is selected.

This approach is often requires a very large computational budget due to the
number of hyperparameter combinations which must be evaluated. The researcher
must also discretise continuous hyperparameters by choosing certain values from
the range of the continuous hyperparameter, and only these chosen values will
be tested. If the optimal hyperparameter combination is in between the values
chosen by the researcher, a sub-optimal result will be returned. Grid search is
valued in circumstances where direct interpretation of influence of
hyperparameters is valued over the optimisation of the objective function.
Because every single combination of hyperparameters is tested, it is trivial to
observe the marginal effect one hyperparameter has on the objective function
without concern of the effect the other hyperparameters might have.

Random search trades some amount of the interpretability of the influence of
each hyperparameter in return for less bias in terms of the search space
covered as well as an improved ability to find better hyperparameters faster.
As explored by @bergstraRandomSearchHyperParameter2012a, random search can
trivially handle continuous hyperparameters and as the randomly selected value
for some continuous hyperparameter $h_i$ is almost surely different from any
previous choice for the same hyperparameter, the _marginal_ search of that
hyperparameter is improved.

Random search has the attractive quality that, in contrast to grid search, the
computational budget independent of the number of hyperparameters one wishes to
explore. As a trade off, the ability to directly infer the influence any
hyperparameter has on the objective value is hampered, as one no longer has
examples where the hyperparameter of interest is modified while all other
hyperparameters remain constant.

By way of comparing grid search and random search over a search space of five
continuous hyperparameters, 1000 evaluations of the objective function is
enough to either search $\approx 4$ values of each of the five hyperparameters
(for grid search), or 1000 values of all five hyperparameters (for random
search), with the caveat that the influence of each hyperparameter can not be
compared as easily.

The final method for hyperparameter search is more of a collection of
intelligent methods which all attempt to explore the hyperparameter space and
then automatically exploit regions of search space which look promising. These
methods often have a hyperparameter themselves, which adjusts how much the
algorithm will explore the search space or exploit known regions of good
performance. These methods all sacrifice human interpretability as regions
which are suspected of poor performance are quickly omitted from the search
space. For this reason, they were not explored as options for hyperparameter
optimisation.

# Hyperparameter Search Space

Hyperparameter optimisation was performed separately for each model type via
random search over each model type's hyperparameter space. A value for each
hyperparameter was randomly selected (hyperparameters, ranges, and
distributions are specified in Table \ref{tab:04_hpar_dists}) and then five
models were trained with those hyperparameters.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{Hyperparameters and the associated range and distributions for
    each model type.}
    \label{tab:04_hpar_dists}
    \begin{tabular}{|c|c|c|c|}
        \hline
        Model Type  & Hyperparameter & Range & Distribution \\
        \hline
        CuSUM            & Threshold            & $\{5, 10, 20, 40, 60, 80, 100\}$            & Categorical \\
        \hline
        HMM              & Number of Iterations & 20                                          & Fixed \\
                         & Covariance Type      & $\{ \text{Spherical}, \text{Diagonal}, \text{Full}, \text{Tied} \}$ & Categorical \\
        \hline
        SVM              & $C$                  & $[10^{-6}, 1]$                              & Logarithmic \\
                         & Class Weights        & $\{ \text{Balanced}, \text{Unbalanced} \}$  & Categorical \\
                         & Maximum Iterations   & 200                                         & Fixed \\
        \hline
        FFNN             & Epochs               & 40                                          & Fixed \\
                         & Batch Size           & $[2^6, 2^8]$                                & Logarithmic \\
                         & Learning Rate        & $[10^{-6}, 10^{-1}]$                        & Logarithmic \\
                         & Optimizer            & Adam                                        & Fixed \\
                         & Number of Layers     & \{1, 2, 3\}                                 & Categorical \\
                         & Nodes per Layer      & $[2^2, 2^9]$                                & Logarithmic \\
                         & L2 Coefficient       & $[10^{-7}, 10^{-4}]$                        & Logarithmic \\
                         & Dropout Rate         & $[0.0, 0.5]$                                & Linear \\
        \hline
        HFFNN (Majority) & Epochs               & $[5, 40]$                                   & Linear \\
                         & Batch Size           & $[2^6, 2^8]$                                & Logarithmic \\
                         & Learning Rate        & $[10^{-6}, 10^{-1}]$                        & Logarithmic \\
                         & Optimizer            & Adam                                        & Fixed \\
                         & Number of Layers     & \{1, 2, 3\}                                 & Categorical \\
                         & Nodes per Layer      & $[2^2, 2^9]$                                & Logarithmic \\
                         & L2 Coefficient       & $[10^{-7}, 10^{-4}]$                        & Logarithmic \\
                         & Dropout Rate         & $[0.0, 0.5]$                                & Linear \\
        \hline
        HFFNN (Minority) & Epochs               & $[5, 40]$                                   & Linear \\
                         & Batch Size           & $[2^6, 2^8]$                                & Logarithmic \\
                         & Learning Rate        & $[10^{-6}, 10^{-1}]$                        & Logarithmic \\
                         & Optimizer            & Adam                                        & Fixed \\
                         & Number of Layers     & \{1, 2, 3\}                                 & Categorical \\
                         & Nodes per Layer      & $[2^2, 2^9]$                                & Logarithmic \\
                         & L2 Coefficient       & $[10^{-7}, 10^{-4}]$                        & Logarithmic \\
                         & Dropout Rate         & $[0.0, 0.5]$                                & Linear \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

Each model was trained on a different subset of the training data, using the
cross-validation procedure described in Section \ref{sec:trn_tst_val}. Summary
statistics of each model's performance on the training and the validation sets
are saved to disc.

If a model requires the use of a pseudo-random number generator (PRNG) then
that PRNG is initialised with a seed that is unique to that particular model,
hyperparameter combination, and repetition number. This ensures that models can
be reproduced, should the need arise.

The ground truth labels for each model's validation set are saved to disc, as
well as the predictions the model made for the observations in that validation
set. This allows for arbitrary performance metrics to be calculated after
training, as the ground truth and predicted labels are available for
comparison.

Different model types had differing numbers of evaluated hyperparameters
across. This stemmed from discrepancies in the quantity of hyperparameters and
distinct training and evaluation durations for each model.

The number of unique hyperparameter evaluations for each model are available in
Table \ref{tab:04_uniq_hpar_evals}.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \begin{tabular}{|c|p{0.23\textwidth}|p{0.19\textwidth}|p{0.19\textwidth}|p{0.19\textwidth}|}
    \hline
        Model Type & Hyperparameter Combinations & Models evaluated & Mean Fit Time & Mean Inference Time \\
    \hline
    CuSUM 	& 7 	& 398 	&  2m 23s    &  0m 47.343s \\
    FFNN 	& 79 	& 486 	&  5m 30s    &  0m  0.373s \\
    HFFNN 	& 88 	& 440 	&  6m 39s    &  0m  0.734s \\
    HMM 	& 4 	& 104 	&  1m 19s    & 29m 35.772s \\
    SVM 	& 57 	& 285 	& 12m  3s  	 &  0m  0.122s \\
    \hline
    \end{tabular}
    \caption{Hyperparameter Combinations for different model types. Note that
    HMM and CuSUM have only discrete hyperparameters, so there is a maximum
    number of hyperparameter combinations that can be tested.}
    \label{tab:04_uniq_hpar_evals}
\end{table}
<!-- prettier-ignore-end -->

The mean inference time for the HMMs is much larger because of the in

<!-- TODO: explain why the HMM  mean inference time is such an outlier -->

# Evaluation metrics

Given a set of classes $C = {c_1, c_2, \ldots, c_{|C|}}$ and a number of
observations $n$, multi-class classifiers can be evaluated against one another
when comparing the ground truth labels $\bm{t}: t_i \in C \forall i \in {1,
\ldots, n}$ against the labels predicted by that classifier $\bm{p}: p_i \in C
\forall i \in {1, \ldots, n}$.

## Confusion Matrices

Confusion matrices provide the most complete picture of a model's performance.
For a $|C|$-class classification problem, a confusion matrix is a $|C| \times
|C|$ square matrix of values, where the element in the $i$-th row and the
$j$-th column of the confusion matrix is the number of times a classifier
predicted an observation that belongs to class $i$ as belonging to class $j$.
That is, that the ground truth label is $i$ and the predicted label is $j$. The
element-wise definition of a confusion matrix is

$$
    \text{Confusion Matrix}_{ij} = \sum_{k=1}^{n} [t_k = j \land p_k = i].
$$

An example confusion matrix is given in the top-left plot of Figure
\ref{fig:04_example_conf_mat}. Note that elements in the confusion matrix which
are zero are left uncoloured and are not annotated with a 0. This is done for
consistency with the $51 \times 51$ confusion matrices used to compare models
trained on the \emph{Ergo} dataset, in which the difference between one
misprediction and zero mispredictions is often important so visualise.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_example_conf_mat}
    \caption{An example confusion matrix, visualised under four different
    normalisation schemes.}
    \label{fig:04_example_conf_mat}
\end{figure}
<!-- prettier-ignore-end -->

In practice, confusion matrices are often normalised before visualisation as
this aids in the interpretation of the model's performance. The unnormalised
confusion matrix (as has been defined above) is shown in the top-left plot of
Figure \ref{fig:04_example_conf_mat}. Confusion matrices can also be column- or
row-normalised (shown in the top-right and bottom-left plots respectively).
Column normalisation divides each element by the sum of its column, such that
each column sums to one. Row normalisation is similar, and ensures each row
sums to one.

In a confusion matrix, each row corresponds to a specific ground truth label,
while each column corresponds to a predicted label. Row-normalization and
column-normalization are processes that ensure each element in the matrix
represents the proportion of ground truth or predicted labels concerning the
total number of ground truth or predicted labels for the associated class,
respectively.

Confusion matrices can also be sum-normalised (as seen in the bottom-right
plot) in which case every element is divided by the sum over the entire
confusion matrix. This allows the elements to be interpreted as a fraction of
the total number of observations.

## Precision, Recall, and $F_1$-score

Confusion matrices aid in the interpretation of large numbers of predictions,
but do not have a total ordering. To this end, we will define first the
per-class precision, recall, and $F_1$-score. These per-class metrics depend on
four summary statistics:

- $\text{TP}_i$ (The number of True Positives for class $c_i$): This is the
  number of labels for which both the ground truth and the predicted class are
  $c_i$:

  $$
       \text{TP}_i = \sum_{j=1}^n [t_j = p_j = c_i]
  $$

- $\text{TN}_i$ (The number of True Negatives for class $c_i$): This is the
  number of labels for which both the ground truth and the predicted class are
  _not_ $c_i$:

  $$
       \text{TN}_i = \sum_{j=1}^n [t_j \neq c_i \land p_j \neq c_i]
  $$

- $\text{FP}_i$ (The number of False Positives for class $c_i$): This is the
  number of labels for which the predicted class is $c_i$ but the true label
  is _not_ $c_i$:

  $$
       \text{FP}_i = \sum_{j=1}^n [p_j = c_i \land t_j \neq c_i]
  $$

- $\text{FN}_i$ (The number of False Negatives for class $c_i$): This is the
  number of labels for which the predicted label is not $c_i$ but the true
  label is $c_i$:

  $$
       \text{FN}_i = \sum_{j=1}^n [p_j \neq c_i \land t_j = c_i]
  $$

The precision for some class $c_i$ can be intuitively understood as a metric that
penalises classifiers which too frequently predict class $c_i$. It is defined as

$$
    \text{Precision}_i = \frac{\text{TP}_i}{\text{TP}_i + \text{FP}_i}.
$$

Likewise, the recall for some class $c_i$ can be understood as a metric that
penalises classifiers which too infrequently predict class $c_i$. It is defined
as

$$
    \text{Recall}_i = \frac{\text{TP}_i}{\text{TP}_i + \text{FN}_i}.
$$

The $F_1$-score for some class $c_i$ ($F_{1,i}$) is defined as the harmonic
mean of the precision and recall of that class:

$$
    F_{1,i} = 2 \cdot \frac{
            \text{Precision}_i \cdot \text{Recall}_i
        }{
            \text{Precision}_i + \text{Recall}_I
        }
$$

The fact that the harmonic mean is used to calculate the $F_1$-score ensures
that _both_ a high precision and high recall are required to obtain a high
$F_1$-score. This is visible when plotting the $F_1$-scores for various
precision and recall values, as in Figure \ref{fig:04_precision_recall_f1}.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_precision_recall_f1}
    \caption{Precision and recall with the calculated $F_1$-score plotted as
    contours. Both a high recall and a high precision are required for a high
    $F_1$-score.}
    \label{fig:04_precision_recall_f1}
\end{figure}
<!-- prettier-ignore-end -->

Given the definitions for per-class precision, recall, and $F_1$-score, we can
calculate and plot those metrics for the same data as is displayed in the
confusion matrices in Figure \ref{fig:04_example_conf_mat}, but as a heatmap
with one row for each of precision, recall, and $F_1$-score, and one column for
each class. This plot is shown in Figure \ref{fig:04_prec_rec_f1_example}.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_prec_rec_f1_example}
    \caption{Precision, recall, and $F_1$ score for the confusion matrix in
    Figure \ref{fig:04_example_conf_mat}.}
    \label{fig:04_prec_rec_f1_example}
\end{figure}
<!-- prettier-ignore-end -->

It is apparent that the classes with perfect precision (classes 0, 1, and 3)
have columns in the confusion matrix which are zero except for the element on
the principle diagonal. Likewise, classes with perfect recall (class 2) have
rows in the confusion matrix which are zero except for the element on the
principle diagonal. Precision can therefore be gleaned from a confusion matrix
by observing the columns of the appropriate confusion matrix, and
\textbf{r}ecall by observing the \textbf{r}ows.

## Weighted and unweighted averages

While precision, recall, and $F_1$-score provide a much more concise
representation of a classifier's performance than a confusion matrix, they
still do not provide a single number through which all classifiers might be
given a total ordering. To this end, we will calculate the unweighted
arithmetic mean of the per-class precision, recall, and $F_1$-scores.

The unweighted mean is desirable for the task at hand as the _Ergo_ dataset is
highly imbalanced, with one class being assigned to 97% of the observations. If
the weighted mean was used instead, then a classifier would be able to achieve
very high performance by ignoring the minority classes and only focusing on
predicting the majority class correctly. For these reasons, the unqualified
terms "precision", "recall", and "$F_1$-score" will be taken to mean the
unweighted mean over the per-class precisions, recalls, and $F_1$-scores.

It is important to note that one cannot calculate the unweighted $F_1$-score
using the unweighted precision and recall due to the non-linear relationship
between the $F_1$-score and precision and recall. This has the unfortunate
implication that a plot showing the unweighted precision and unweighted recall
of a model does _not_ allow the viewer to infer its unweighted $F_1$-score. The
$F_1$-score must be shown in another plot of mentioned explicitly.

# An ordering over multi-class classifiers

In order that the best model can be chosen, an ordering must be defined. This
ordering should work given solely the list of predictions and the list of
ground truth values.

A single metric will be calculated using the unweighted average $F_1$-score
over all classes.

Each set of hyperparameters will be evaluated five times, each time calculating
the unweighted average $F_1$-score on the validation dataset. From these five
$F_1$-scores, a 90% confidence interval will be calculated. The lower bound of
this confidence interval shall be used to rank the models.

Using the lower bound of the confidence ensures that the best-ranked model did
not just have a single outlier performance which achieved a high $F_1$-score,
but rather consistently achieved a high $F_1$-score across all validation sets
and all random initialisations. This means that the resulting model is more
likely to generalise to unseen data.

TODO: Probably need something here describing student's t-Distribution and how
confidence intervals are calculated.

# The conversion of class predictions into keystrokes

Given a time-series of predictions, it still takes some work to convert those
predictions into keystrokes. There are a few ambiguities to clear up in order
to make this process clear.

Only the neural-network based models natively support probabilities. Therefore
predictions shall be assumed to be binary such that only one class is predicted
at each timestep. This ensures maximum applicability.

Each time step, a class prediction will be made. The boundary cases are easy to
handle: if the prediction is 100% class 50 (the non-gesture class) then don't
emit any keystroke. If the prediction is 100% a class other than class 50, then
look up the corresponding keystroke and emit that.

But this runs into problems when prediction probabilities are not 100% or the
same gesture class is predicted multiple times in quick succession.

To solve the first case, the program will only emit a keystroke if it is not
class 50 and it has a majority over 50%. This percentage can be customizable

If sequential predictions are made of the same class, then a keystroke will
only be emitted the first time that class is predicted. This will improve the
perceived performance of the model, so that one gesture does not result in
multiple keystrokes if the model predicts that gesture in multiple sequential
time steps.

The predicted classes are converted to keystrokes using the
gesture-to-keystroke mapping. This mapping is configurable by the user, but by
default it is set up to mirror the QWERTY keyboard as closely as possible. The
mapping is visible in Table \ref{tab:04_keystrokes}

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   & \texttt{control} &  \texttt{=} &  \texttt{'} &  \texttt{-} &  \texttt{[} &  \texttt{]} &  \texttt{space} &  \texttt{\textbackslash} &  \texttt{\`} &  \texttt{shift} \\
        \hline
        $45^\circ$  & \texttt{z} & \texttt{x} & \texttt{c} & \texttt{v} & \texttt{b} & \texttt{n} & \texttt{m} & \texttt{,} & \texttt{.} & \texttt{/} \\
        \hline
        $90^\circ$  & \texttt{a} & \texttt{s} & \texttt{d} & \texttt{f} & \texttt{g} & \texttt{h} & \texttt{j} & \texttt{k} & \texttt{l} & \texttt{;} \\
        \hline
        $135^\circ$ & \texttt{q} & \texttt{w} & \texttt{e} & \texttt{r} & \texttt{t} & \texttt{y} & \texttt{u} & \texttt{i} & \texttt{o} & \texttt{p} \\
        \hline
        $180^\circ$ & \texttt{1} & \texttt{2} & \texttt{3} & \texttt{4} & \texttt{5} & \texttt{6} & \texttt{7} & \texttt{8} & \texttt{9} & \texttt{0} \\
        \hline
    \end{tabular}
    \caption{The default keystroke mappings for \emph{Ergo}. Note that the
    layout is similar to the QWERTY. \emph{Ergo} recognises control keys like
    \texttt{control} and \texttt{shift}, so the user can combine gestures to
    get new keystrokes.}
    \label{tab:04_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

The mapping allows certain gestures to emit the "control" and the "shift"
non-printing characters. These characters, in addition to the other printing
characters, greatly extends the number of input a user can give. As is natural
for regular keyboard input, performing the gesture for "shift" and then the
gesture for the letter "a" would result in the keystroke "A" being sent. This
applies for all alphabetical characters a--z, as well as the numerals 0--9 and
various punctuation characters. The effect of pressing "shift" before each
character is visible in Table \ref{tab:04_shift_keystrokes}. Empty cells
indicate that shift has no effect.

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   &   &  \texttt{+} &  \texttt{"} &  \texttt{\_} &  \texttt{\{} &  \texttt{\}} &    &  | &  \texttt{\~} &   \\
        \hline
        $45^\circ$  & \texttt{Z} & \texttt{X} & \texttt{C} & \texttt{V} & \texttt{B} & \texttt{N} & \texttt{M} & \texttt{<} & \texttt{>} & \texttt{?} \\
        \hline
        $90^\circ$  & \texttt{A} & \texttt{S} & \texttt{D} & \texttt{F} & \texttt{G} & \texttt{H} & \texttt{J} & \texttt{K} & \texttt{L} & \texttt{:} \\
        \hline
        $135^\circ$ & \texttt{Q} & \texttt{W} & \texttt{E} & \texttt{R} & \texttt{T} & \texttt{Y} & \texttt{U} & \texttt{I} & \texttt{O} & \texttt{P} \\
        \hline
        $180^\circ$ & \texttt{!} & \texttt{@} & \texttt{\#} & \texttt{\$} & \texttt{\%} & \texttt{\^} & \texttt{\&} & \texttt{$\ast$} & \texttt{(} & \texttt{)} \\
        \hline
    \end{tabular}
    \caption{todo}
    \label{tab:04_shift_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

The "control" character also allows for some other keystrokes to be made, such
as carriage return (\texttt{ctrl+j} or \texttt{ctrl+m}), backspace
(\texttt{ctrl+h}), or escape (\texttt{ctrl+[}). These key combinations are the
same as in Vim's insert mode (see \texttt{:h ins-special-keys} in vim's
built-in help menu).

---

# (old) Hardware Description

These accelerometers can measure linear acceleration in three
orthogonal directions, but cannot measure rotational acceleration. Due to how
the accelerometers are built, the measurements they provide _do_ include
gravity. For example, an accelerometer at rest will register a large
acceleration towards the centre of the earth. This makes distinguishing
acceleration due to finger movement and acceleration due to gravity impossible
based off of the linear acceleration alone. Appendix
\ref{the-adxl335-accelerometers} contains more information about the
accelerometers.

\end{figure}

The fifteen measurements provided by the five accelerometers on the left hand
are collected by an Arduino Nano 3.3v BLE microcontroller which is mounted to
the back of the user's left hand. Similarly, the fifteen measurements provided
by the accelerometers on the right hand are collected by another Arduino Nano
3.3v BLE microcontroller, this one mounted on the back of the user's right
hand. Appendix \ref{the-arduino-nano-33-ble} describes these microcontrollers
in greater detail.

The 15 sensor readings from the microcontroller on the left hand are
transmitted to the microcontroller on the right hand by a wired serial
connection. These thirty measurements are then sent by a wired serial
connection to the host computer.

A full description of the hardware used is
given in Appendix \ref{app:hardware} and a circuit diagram in Appendix
\ref{app:circuit-diagram}.
