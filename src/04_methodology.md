The construction of \emph{Ergo} is discussed in Section
\ref{construction-of-ergo}. The procedure for collecting, labelling, and
cleaning the dataset is discussed in Section
\ref{data-collection-and-cleaning}. The method for splitting the dataset into
training, validation, and testing datasets is discussed in Section
\ref{sec:trn_tst_val}. The procedure followed for conducting the experiments is
discussed in Section \ref{experimental-procedure}. The procedure for converting
binary classifiers into multi-class classifiers is discussed in Section
\ref{binary-and-multi-class-classifiers}. The implementation details for each
model type is discussed in Section \ref{model-design-and-implementation}, The
procure followed for optimising the hyperparameters of each model type is
discussed in Section \ref{procedure-for-hyperparameter-optimisation}. The exact
search space for each model is tabulated in Section
\ref{hyperparameter-search-space}. The evaluation metrics by which multi-class
classifiers can be compared is discussed in Section \ref{evaluation-metrics}. A
means of ordering those classifiers is discussed in Section
\ref{an-ordering-over-multi-class-classifiers}. Finally, the method by which
gestures are converted into keystrokes via class predictions is discussed in
Section \ref{the-conversion-of-class-predictions-into-keystrokes}.

# Construction of Ergo

_Ergo_, at its core, is a set of acceleration sensors mounted onto the user's
fingertips, paired with a software suite for reading that data (see Figure
\ref{fig:04_accelerometers}).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.33\textwidth]{src/imgs/accelerometers.jpg}
    \caption[Ergo with accelerometers highlighted]{\emph{Ergo} consists of ten ADXL335 tri-axis linear
    accelerometers, each one of which is mounted to the back of the user's
    fingertips (highlighted in red)}
    \label{fig:04_accelerometers}
\end{figure}
<!-- prettier-ignore-end -->

These sensors measure acceleration in three orthogonal axes. Acceleration due
to gravity is included in these measurements. The measured values are collected
together using two Arduino Nano microcontrollers (one on each hand) and then
sent to the user's computer via a serial wire. Each sensor has three signal
lines for output, describing the acceleration measured by the X, Y, and Z axes
(see Figure \ref{fig:04_adxl335_xyz}).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.33\textwidth]{src/imgs/accel_xyz.jpg}
    \caption[Ergo with accelerometer axes highlighted]{The user's left hand while wearing \emph{Ergo} with the
    accelerometer directions indicated. The X direction is in red, the Y
    direction is in green, and the Z direction is in blue. Note that the sensor
    on the thumb is rotated relative to the sensors on the fingers.}
    \label{fig:04_adxl335_xyz}
\end{figure}
<!-- prettier-ignore-end -->

These accelerometer provide in 15 signals per hand. Because each Arduino Nano
microcontroller only has 8 analogue signal inputs, a 16-to-1 multiplexer is
introduced such that the microcontroller (using four selection control wires)
can choose which of the 15 analogue signals it would like to read data from.
The microcontroller repeatedly polls each of the analogue signals until it has
read one measurement from each accelerometer sensor. This packet of data is
sent to the user's computer.

On the user's computer, the packet of accelerometer measurements is associated
with a time stamp. What happens next is dependant on whether the software is
configured to capture the data or to feed the data to a classification model in
real time. If configured to capture data, then all the accelerometer
measurements and time stamps will be stored to disc as one file, each newline
being one set of sensor readings. If configured to perform classification, then
the sensor readings will be streamed to a provided classifier and the
predictions will be surfaced to the user.

---

## Hardware Components Used

<!--- TODO -->

# Data Collection and Cleaning

To collect training data, the author wore _Ergo_ and performed each of the
pre-specified gestures sequentially, repeating each gesture until there was
approximately 100 observations of each gesture. The sensor measurements were
stored to disc as the gestures were being performed, along with a timestamp of
when the measurements were received from the hardware.

Real-time data labelling of the data with the gesture being performed is not
possible due to the author's hands being required to perform the data.

One gesture was performed approximately every half a second, with error due to
the human difficulty of timing a hand gesture within 0.025 seconds. In order to
facilitate the labelling of this data, annotations were made every half second,
and each gesture was performed such that they were aligned with the annotation.
These annotations serves no purpose other than to indicate that a gesture was
performed close to it.

After recording the data, labels are manually assigned to a single time step.
Each gesture gets a different label, and the labels for each gesture are
positioned such that they are all aligned to the same part of a gesture. For
example, each label might represent the peak of a gesture, in which case
_every_ label is positioned such that all observations of the same gesture are
maximally similar to one another.

The labelling process has to be done with care, as preliminary model training
showed that poorly aligned labels lead to very poor performance. If one label
is aligned with the start of a gesture and the other with the middle of the
gesture, all models struggle to generalise.

To enable the collection and labelling of a large dataset, gestures were
performed in batches of 5 unique classes at a time. For example, one data
recording session might record data for gestures 0, 1, 2, 3, 4. Then the next
session for gestures 5, 6, 7, 8, 9. And the next for gestures 10, 11, 12, 13, 14.
And so on, for all gestures from 0 through to 49. The data from each session
was saved in a separate file. Reducing the number of gestures present in a file
allowed for easier labelling. The sensor data immediately before and after an
annotation could be manually analysed and compared against the known five
gesture classes which are present in that file. The annotation can then be replaced
with a label for that gesture class, and the position in time of that label can
be adjusted such that the new observation and all previous observations are
aligned as close as possible to one another.

The measurements recorded from _Ergo_ are stored on disk as several files which
lists the time stamp, the 30 sensor values recorded at that time stamp, and the
gesture associated with that time stamp. There are 37MB and 241 762
observations, 235 995 of which belong to class 50 and the remaining 5 767 are
the gesture classes.

# Splitting the Data into Train, Test, Validation \label{sec:trn_tst_val}

Preliminary modelling showed that models trained on just a single instant of time
did not perform as well as models provided with a historical window of 20 time
steps of data.

For this reason, the dataset is windowed such that it contains a sequence of
observations, where each observation has 20 time steps of history and 30 sensor
values per time step. Each observation has an overlap of 19 time steps with the
observations immediately preceding and following it. Each observation only has
1 label which is the label for the most recent time step in its 20 time steps.
20 time steps is equivalent to half a second of sensor measurements. Every
model is presented with the same data format, although some models cannot
handle two-dimensional data and so the input is flattened to one dimension
before being used for inference.

25% of the dataset (60440 observations, 14 417 gesture class observations) is
split off and saved as the testing dataset. The testing dataset is saved as a
single binary file, completely separate from the training and validation data.
The test-set splitting procedure stratified by the class labels, ensuring
that the frequency of the different classes is maintained. Apart from this
constraint, the subset of data used for the testing set is random.

The remaining 75% of the dataset (181 321 total observations, 4 325 gesture
class observations) is saved to disc as a single binary file. This dataset will
be referred to as the training-validation dataset. The training-validation
dataset is only split into separate training and validation datasets at
training time, just before each model is fit to the training subset.

This split is random, but the pseudo-random number generator (PRNG) used to
make the split is initialised with a seed based on the model type,
hyperparameter set, and repetition number. This ensures that each
training-validation split is different but can be reproduced.

Splitting the dataset into training and validation datasets based on a PRNG
also allows for an arbitrary number of repetitions to be made for cross
validation. Of the 75% of the dataset set aside for training/validation, 75%
(135 990 observations, 3 243 gesture class observations) is used for training
leaving 25% (45 330 observations, 1 078 gesture class observations) for
validation.

A confidence interval can be obtained for the performance of each model, as
each set of hyperparameters is trained and evaluated multiple times on a random
subset of the training-validation dataset. This allows an empirical performance
distribution to be associated with each model. This distribution can be used to
compare models and evaluate which will most likely perform well on on the test
set and other unseen data which might have a different underlying distribution
to the training-validation dataset.

# Experimental Procedure

Experiments will be conducted so as to answer the research questions posed in
the Introduction. As each model type has a different hyperparameter space, the
experiments for each of the five model types will be performed separately.
Additionally, there will be experiments for 5-, 50-, and 51-class datasets.

The 5-class dataset is constructed by only including classes 0, 1, 2, 3, and 4
from the full training-validation dataset. These are the gestures performed by
the left hand oriented to be parallel to the ground. This excludes class 50
(the non-gesture class). The 50-class dataset is constructed by including only
gestures 0 through to 49 from the full training-validation dataset, also
excluding the non-gesture class. The 51-class dataset is equivalent to the full
training-validation dataset.

For each model and each of the 5-, 50-, and 51-class datasets, a number of
different hyperparameter combinations will be selected and tested. The number
of hyperparameter combinations depends on the model type, as the size of the
search space of each model is different. For example, the HMMs only have one
discrete hyperparameter which can take on one of four values, while the HFFNNs
have 18 continuous hyperparameters and so require a lot more exploration to
equivalently search the hyperparameter space.

For all models, each hyperparameter combination will be tested five times, each
time using different randomly selected partitions of the training-validation
dataset.

For each repetition, the predictions the model makes on both its training and
validation data is stored to disc, along with the ground truth labels for that
data. For ease of analysis, some summary metrics are calculated and recorded
such as training and validation $F_1$-score, recall, and precision. The time
taken to fit each model is stored, along with the time taken to perform
inference. The FFNNs also have their final training and validation loss stored
to disc. This procedure is described in Algorithm
\ref{alg:04_model_evaluation}.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{Hyperparameter Search and Model Evaluation}
\label{alg:04_model_evaluation}
\begin{algorithmic}
\State $\bm{C} \gets \{5, 50, 51\}$ \Comment{Number of classes}
\State $\bm{M} \gets \{$FFNN, HFFNN, CuSUM, HMM, SVM$\}$ \Comment{Model types}
\For{$C$ in $\bm{C}$} \Comment{Iterate over number of classes}
    \For{$M$ in $\bm{M}$} \Comment{Iterate over model types}
        \For{$n$ in $1..n_{\text{combinations}}$} \Comment{Number of combinations for the model type}
            \State Select a random hyperparameter combination
            \For{$R$ in $1..5$} \Comment{Five repetitions}
                \State Split the training-validation dataset
                \State Train model $M$ on the training dataset
                \State Evaluate model $M$ on the validation dataset
                \State Save model performance
            \EndFor
        \EndFor
    \EndFor
\EndFor
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

After experimentation, all the data required to evaluate which model performs
the best on the validation dataset has been collected. When a best-performing
model has been identified, the test dataset will be used to gauge how
well that model is able to generalise to unseen data.

In addition to evaluating the best-performing model on the unseen test dataset,
the model will be evaluated on an unseen English language dataset. This dataset
is small (9405 observations, 44 gestures), but contains sensor measurements
recorded while the user performed the gestures for an English sentence. This
dataset will provide an intuition for what the model's performance would feel
like for an end-user.

# Binary and Multi-class Classifiers

Some classification algorithms have support for multi-class classification
built-in to the classification procedure. Examples would be Feed Forward Neural
Networks or Decision trees. The training and classification procedure for these
algorithms does not depend on whether the task is binary or multi-class
classification.

Other classification algorithms only support binary classification and cannot
natively perform multi-class classification. Examples would be Hidden Markov
Models or Support Vector Machines. Binary classification algorithms can be
converted into $n$-class ($n>2$) classification algorithms by creating an
ensemble of $n$ binary classifiers. In this setup, the $i$-th binary classifier
would be trained to predict if a given observation belongs either to class $i$
or to some class other than class $i$.

To predict the class of an observation, each of these $n$ classifiers will make
a prediction for that same observation. A well trained ensemble will have only
one binary classifier predicting YES and all other classifiers predicting NO
for a given observation. This procedure for using an ensemble of binary
classifiers as a multi-class classifier is called one-vs-rest classification.

It is possible to construct an ensemble such that fewer than $n$ binary
classifiers are required. This is done in a means similar to binary search: the
first binary classifier is trained to differentiate the first $\frac{1}{2}$ of
the classes $[0, \lfloor\frac{n}{2}\rfloor]$ from the second $\frac{1}{2}$ of
the classes $[\lfloor\frac{n}{2}\rfloor+1, n]$.

The second classifier is then trained to recognise the first $\frac{1}{4}$ of
the classes $[0, \lfloor\frac{n}{4}\rfloor]$ from the second $\frac{1}{4}$ of
the classes $[\lfloor\frac{n}{4}\rfloor+1, \lfloor\frac{n}{2}\rfloor]$ and the
third classifier to recognise the third $\frac{1}{4}$ of the classes
$[\lfloor\frac{n}{2}\rfloor+1, \lfloor\frac{3 n}{4}\rfloor]$ from the final
$\frac{1}{4}$ of the classes $[\lfloor\frac{3 n}{4}\rfloor+1, n]$.

This procedure of iteratively halving the number of classes each binary classifier
predicts is recursively continued until each binary classifier is only
distinguishing between only two classes. This method requires only $log(n)$
binary classifiers compared to one-vs-rest's $n$ binary classifiers.

However, this procedure implicitly models the first half of the classes as
being distinct from the second half. There is no guarantee that this is true,
but nonetheless that is what the first classifier has to be trained to do.
Mispredictions are very problematic, as if the first classifier incorrectly
classifies an observation, then all subsequent classifiers will have to make
predictions on an observation that is completely out of the distribution they
were trained on. Without guarantees about the similarities between classes, a
binary-tree style ensemble of binary classifiers may have to trade off
classification performance for efficiency of computation. Because of these
problems, one-vs-rest classification will be used as the means by which all
binary classifiers are converted into multi-class classifiers in this thesis.

# Model Design and Implementation

This section discusses each model type and explains the implementation thereof.
Hidden Markov Models will be described in Section \ref{model-specifics-hmm},
Cumulative Sum in Section \ref{model-specifics-cusum},
Feed-Forward Neural Networks in Section \ref{model-specifics-ffnn},
Hierarchical Feed-forward Neural Networks in Section \ref{model-specifics-hffnn},
and Support Vector Machines in Section \ref{models-specifics-svm}.

## Hidden Markov Models \label{model-specifics-hmm}

Hidden Markov Models (HMMs) are able to model the progression of time via
sequential states and their transition probability matrices. For this reason,
each HMM classifier attempts to model an observation as a sequence of 22
states: a start state, one state for each of the 20 time steps, and an end
state. Each state emits a 30-dimensional Gaussian distribution (one dimension
for each of the 30 sensors). The mean vector $\bm{\mu}$ and the covariance
matrix $\bm{\Sigma}$ of the Gaussian are estimated using the Baum-Welch
expectation maximisation algorithm.

HMMs do not natively support multi-class classification, and as such
one-vs-rest classification is used. There is one HMM for each class, including
the non-gesture class. To reduce the number of parameters which need to be
learned, the covariance matrices for each HMM can be one of four different
types. These covariance types each constrain the covariance matrix such that
the full matrix need not be learned. In order from most constrained to least
constrained:

- Spherical covariance matrix: each state uses a single variance value that
  applies to all features: $\lambda I$ where $\lambda \in \Re$ and $I$ is the
  $30 \times 30$ identity matrix.
- Diagonal covariance matrix: each state uses a diagonal covariance matrix.
  $\bm{\lambda} I$ where $\bm{\lambda} \in \Re^{30}$
- Tied covariance matrix: each state use the same shared, full covariance
  matrix.
- Full covariance matrix: each state uses its own full, unrestricted,
  covariance matrix.

Calculating the number of parameters in each of the covariance types provides a
crude estimate for the complexity, and can be seen in Table
\ref{tab:04_covariance_comparison}.

<!-- prettier-ignore-start -->
\begin{table}[!ht]
    \centering
    \caption{Comparison of Covariance Types in a Gaussian Mixture Model}
    \label{tab:04_covariance_comparison}
    \begin{tabular}{|c|c|c|c|c|}
        \hline
        Covariance Type & \#Gaussians   & Parameters/Gaussian & Total Parameters \\
        \hline
        Full            & 22            & $30 \times 30$      & 19800            \\
        Tied            & 1             & $30 \times 30$      & 900              \\
        Diagonal        & 22            & 30                  & 660              \\
        Spherical       & 22            & 1                   & 22               \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

The forward algorithm allows log-likelihood that a certain observation
originated from the same distribution as that which a certain HMM to be
obtained.

To make a class prediction for a certain observation, the forward algorithm is
used to obtain the log-likelihood of that observation for each HMM. These 50
log-likelihoods are compared and the HMM providing the maximum log-likelihood
is selected as the prediction for that observation. If the HMM trained on class
5 provided the maximum log-likelihood for a given observation, then the
predicted class would be class 5.

Significant problems were encountered while training the HMMs due to the number
of observations of class 50. Training times for the class 50 HMM either
exceeded 6 hours (at which point they were stopped) or were killed by the
operating system due to excessive memory usage. For this reason, all HMMs were
only trained on a subset of 1000 randomly selected observations of class 50.
During calculation of the validation performance, all HMMs were evaluated on
all validation observations.

Table \ref{tab:04_hpar_dists_hmm} shows the hyperparameters for the HMMs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{HMM hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_hmm}
    \begin{tabular}{|c|c|c|c|}
        \hline
        Model Type  & Hyperparameter & Range & Distribution \\
        \hline
        HMM              & Number of Iterations & 20                                          & Fixed \\
                         & Covariance Type      & $\{ \text{Spherical}, \text{Diagonal}, \text{Full}, \text{Tied} \}$ & Categorical \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Cumulative Sum \label{model-specifics-cusum}

Cumulative Sum (CuSUM) is designed for real-time univariate time-series
out-of-distribution detection. It cannot natively support multivariate
multi-class classification, and so some adjustments are required.

The term _CuSUM algorithm_ will be used to refer to the univariate time series
out-of-distribution detection algorithm, and _CuSUM classifier_ to refer to the
ensemble of _CuSUM algorithms_ used to perform multivariate multi-class
classification.

Each CuSUM algorithm requires a reference value against which any deviations
will be compared. This reference value is set to be the first 10 values in the
given time series. The CuSUM algorithm will alert if the time series becomes
either too high or too low. Each CuSUM algorithm only has one parameter, the
threshold value, which defines how much deviation is permitted before an alert
is raised. The CuSUM algorithm is given in Algorithm \ref{alg:cusum}.

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption{CuSUM Algorithm}
    \label{alg:cusum}
    \begin{algorithmic}
        \Require Data stream: $x_1, x_2, \ldots, x_n$
        \Require Threshold: $t$
        \State $U_0 = 0$, $L_0 = 0$ \Comment{Upper and lower cumulative sums}
        \State $r = \frac{1}{10}\sum_{i=1}^{10} x_i$ \Comment{Reference value}
        \For{$i = 1$ to $n$}
            \State $d_i = x_i - r$ \Comment{Calculate the incremental change}
            \If{$d_i > 0$} \Comment{Update the cumulative sums:}
                \State $U_i = U_{i-1} + d_i$
                \State $L_i = L_{i-1}$
            \Else
                \State $U_i = U_{i-1}$
                \State $L_i = L_{i-1} - d_i$
            \EndIf

            \If{$U_i > t$ \textbf{or} $L_i > t$}
                \State \textbf{Alarm condition met}
            \EndIf
        \EndFor
        \State \textbf{Alarm condition not met}
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

To construct the CuSUM classifier, one CuSUM algorithm will be run for each
dimension of the 30-dimensional time series. Each algorithm will detect when a
certain time series exceeds a threshold value. Based on the training data, a
connection will be made between which algorithms exceed their threshold and
what the ground truth class is for the observation. Call this group of 30 CuSUM
algorithms combined with learnt parameters defining which algorithms alert for
a certain class a _cluster_ of CuSUM algorithms. Each cluster is capable of
multi-variate time-series binary classification.

To perform multi-class classification, one-vs-rest will be used to combine 50
clusters of CuSUM algorithms, where each cluster is trained on a different
class. A CuSUM classifier is therefore constructed of 50 clusters of 30 CuSUM
algorithms. Table \ref{tab:04_hpar_dists_cusum} shows the hyperparameter for
CuSUM.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{CuSUM hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_cusum}
    \begin{tabular}{|c|c|c|c|}
        \hline
        Model Type  & Hyperparameter & Range & Distribution \\
        \hline
        CuSUM            & Threshold            & $\{5, 10, 20, 40, 60, 80, 100\}$            & Categorical \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Feed-Forward Neural Networks \label{model-specifics-ffnn}

The Feed-Forward Neural Networks (FFNNs) were implemented using the TensorFlow
library for the Python3 programming language. Each FFNN is modelled as a
sequence layers, where each layer performs a transformation on its input and
provides output to the next layer. The input $20 \times 30$ matrix is flattened
into a 600 dimensional vector before being passed to the FFNN.

FFNNs are sensitive to the scale of the input data, and so the input data is
normalised to have approximately zero mean and approximately unit variance
before being passed to the FFNN. For each of the 600 dimensions, the mean
$\mu_i$ and standard deviation $\sigma_i$ ($i \in \{1, \ldots, 600\}$) of the
training data is calculated. These statistics are not calculated using the
validation data, as that would leak information about the validation data to
the model. These means and standard deviations are then stored.

To normalise an unseen observation $\bm{x}$, each element $x_i$ in $\bm{x}$ has
the $i$-th mean subtracted from it and is then divided by the $i$-th standard
deviation:

$$
    \frac{x_i - \mu_i}{\sigma_i}
$$

This ensures that the mean of each element in $\bm{x}$ is approximately zero
and the variance is approximately 1.

The loss function of every FFNN is categorical cross entropy loss, defined as:

$$
    L(\bm{y}, \hat{\bm{y}}) = -\sum_{i=1}^n y_i \cdot \log(\hat{y}_i) \cdot \text{weight}_i
$$

Where:

- $y_i \in \{0, 1\}$ is the ground truth prediction for class $i$.
- $\hat{y}_i \in [0, 1]$ is the predicted probability for class $i$.
- The summation is performed over all $n$ classes.
- $\text{weight}_i$ is the weight of class $i$.

The weight of each class is determined by the formula below, where
$\text{count}_i$ is the number of samples in the class.

$$
    \text{weight}_i = -\log_{10}\left( {\text{count}_i} \right)
$$

L2 normalisation is applied to the loss function such that the model is
penalised for weights which are too large. The strength of regularisation is
controlled by the L2 coefficient hyperparameter. A regularisation term is added
to the loss function:

$$
    \text{L2} \cdot \sum_w w^2
$$

Where L2 is the L2 coefficient hyperparameter and the sum iterates over every
weight in the network.

The activation function of each fully connected layer is the ReLU activation
function:

<!-- prettier-ignore-start -->
\begin{align*}
    \text{ReLU}(x) = \begin{cases}
        x, & \text{if } x > 0 \\
        0, & \text{if } x \leq 0
    \end{cases}
\end{align*}
<!-- prettier-ignore-end -->

The dropout rate hyperparameter controls the probability that the activation of
any neuron is set to zero during training. To compensate for the lower sum of
activations being passed to the next layer, the neurons which were not set to
zero have their output scaled up by $(1 - \text{dropout rate})^{-1}$. This
ensures the sum of the output of all neurons remains the same regardless of
exactly how many neurons were dropped out. Dropout is only applied during
training, as it is a regularisation technique to decrease overfitting; no
neurons have their output set to zero during inference.

The number of neurons in the last layer of the FFNN depends on the number of
classes being predicted, and is either 5, 50, or 51.

The optimiser used is the Adam optimiser <!--TODO:
[@kingmaAdamMethodStochastic2014]--> with a constant learning rate that is
determined by the learning rate hyperparameter. Constant values of
$\beta_1=0.9$, $\beta_2=0.999$, and $\hat{\epsilon}=10^{-07}$ are used for the Adam
hyperparameters mentioned by Kingma and Ba.

Every FFNN completes 40 epochs of trainined, after which it is evaluated on the
validation dataset. Summary statistics are stored to disc, as well as the full
vectors of ground truth labels and predicted labels for that particular
training-validation split. Table \ref{tab:04_hpar_dists_ffnn} shows the
hyperparameters for the FFNNs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{FFNN hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_ffnn}
    \begin{tabular}{|c|c|c|c|}
        \hline
        Model Type  & Hyperparameter & Range & Distribution \\
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
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Hierarchical Feed-forward Neural Networks \label{model-specifics-hffnn}

Hierarchical Feed-forward Neural Networks (HFFNNs) are an extended version of
the FFNN and operate by combining the output of two FFNNs, each of which is
trained on a different subset of the training data.

One FFNN (called the majority classifier) is binary classifier in charge of
detecting whether or not a gesture exists in the observation. The other FFNN
(called the minority classifier) is only invoked if there is a gesture present
in an observation, as detected by the majority FFNN.

Algorithm \ref{alg:hffnn_prediction} shows the procedure for making a
prediction using the majority and minority classifiers.

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption{Prediction Algorithm For HFFNNs}
    \label{alg:hffnn_prediction}
    \begin{algorithmic}
        \Require X \Comment{Array of observations}
        \State Initialize an empty array $\bm{y}$ of the same length as $X$
        \For{$i = 1$ to length($X$)}
            \If{\Call{PredictWithMajority}{$X_i$} = 0}
                \State $y_i \gets$ \Call{PredictWithMinority}{$X_i$}
            \Else
                \State $y_i \gets 50$
            \EndIf
        \EndFor
        \State \textbf{return} $\bm{y}$
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

The minority and majority classifiers each have the same hyperparameters as the
FFNNs, with the addition that the majority and minority FFNN can be trained for
a variable number of epochs each, in the range from 5 to 40. Table
\ref{tab:04_hpar_dists_hffnn} shows the hyperparameters for the HFFNNs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{HFFNN hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_hffnn}
    \begin{tabular}{|c|c|c|c|}
        \hline
        Model Type  & Hyperparameter & Range & Distribution \\
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

## Support Vector Machines \label{models-specifics-svm}

Support Vector Machines (SVMs) do not support multi-class classification
natively, and so a one-vs-rest technique is used to enable an ensemble of SVMs
to make multi-class classifications. The input $20 \times 30$ matrix is
flattened into a 600 dimensional vector before being passed to the SVMs.

All SVMs were trained for 200 iterations with a linear kernel. One
hyperparameter, the class weight, was iterated to weight the influence of each
class based on it's prevalence in the training dataset. The hyperparameter $C$
controls the regularisation and is used in the same way as described in the
Background chapter\footnote{NOTE: The background section on SVMs is being
completed}. Table \ref{tab:04_hpar_dists_svm} describes the hyperparameters for
the SVMs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{SVM hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_svm}
    \begin{tabular}{|c|c|c|c|}
        \hline
        Model Type  & Hyperparameter & Range & Distribution \\
        \hline
        SVM              & $C$                  & $[10^{-6}, 1]$                              & Logarithmic \\
                         & Class Weights        & $\{ \text{Balanced}, \text{Unbalanced} \}$  & Categorical \\
                         & Maximum Iterations   & 200                                         & Fixed \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

# Procedure for Hyperparameter Optimisation

Hyperparameter optimisation is the procedure of searching over a space of
hyperparameters, with the goal of finding a set of hyperparameters which
optimise some objective function. As _Ergo_ has five different model types with
five different hyperparameter spaces, hyperparameter optimisation is done
separately for each model type. Each procedure is identical, except for the
model type being evaluated.

Finding new methods for computationally efficient hyperparameter optimisation
is a field of active research. Broadly there are three kinds of
hyperparameter optimisation: grid search, random search, and various means of
more intelligent search.

Grid search is the simplest to implement, and requires that each hyperparameter
is a finite set. Grid search will then iterate over every
combination of the hyperparameters, calculating the objective value in each
case. If there are $N$ hyperparameters $h_1, h_2, \ldots, h_N$, and
each hyperparameter $h_i$ has $n_i$ possible values, then the total number of
hyperparameter combinations to search is

$$
    \prod_{i=1}^N n_i.
$$

Once every hyperparameter combination has been evaluated, the hyperparameter
combination which resulted in the optimal objective value is selected as the
best.

This approach often requires a very large computational budget due to the
number of hyperparameter combinations which must be evaluated. The researcher
is also required to discretise continuous hyperparameters, and only these
chosen values will be tested. If the optimal hyperparameter combination is far
from the values chosen by the researcher, a sub-optimal result will be
returned.

Grid search is useful in circumstances where interpretability of the influence
of different hyperparameters is valued over the optimisation of the objective
function. Because every combination of hyperparameters is tested, it is trivial
to observe the marginal effect one hyperparameter has on the objective function
without concern of the effect the other hyperparameters might have on the
objective function.

Random search trades some amount of the interpretability return for an improved
ability to find better hyperparameters faster. Random search can trivially
handle continuous hyperparameters. As the randomly selected value for some
continuous hyperparameter $h_i$ is almost surely different from any previous
choice for the same hyperparameter, the marginal search of that
hyperparameter is improved.

Random search has the attractive quality that -- in contrast to grid search --
the computational budget is independent of the number of hyperparameters one
wishes to explore. As a trade off, the ability to directly infer the influence
any hyperparameter has on the objective value is hampered. This is because one
no longer has examples where the hyperparameter of interest is modified while
all other hyperparameters remain constant.

As a comparison between grid search and random search, consider a search space
of five continuous hyperparameters, with a computational budget of 1000
evaluations of the objective function.

This is enough to either search $\approx 4$ values of each of the five
hyperparameters (for grid search), or 1000 values of all five hyperparameters
(for random search), with the caveat that the influence of each hyperparameter
can not be compared as easily. As the number of hyperparameters increases, the
number of values per hyperparameter collapses exponentially.

The final method for hyperparameter search, intelligent search, is a collection
of intelligent methods which all attempt to explore the hyperparameter space
and then automatically exploit regions of search space which look promising.

These methods often have a hyperparameter themselves, which adjusts how much
the algorithm will explore the search space or exploit known regions of good
performance. These methods all sacrifice human interpretability, as regions
which are suspected of poor performance are quickly omitted from the search
space. For this reason, they were not explored as options for hyperparameter
optimisation.

# Hyperparameter Search Space

Hyperparameter optimisation was performed separately for each model type via
random search over each model type's hyperparameter space. A value for each
hyperparameter was randomly selected and then five models were trained with
those hyperparameters.

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

<!-- TODO: explain why the HMM  mean inference time is such an outlier

The number of unique hyperparameter evaluations for each model are available in
Table \ref{tab:04_uniq_hpar_evals}.

prettier-ignore-start
\begin{table}[!ht]
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
    \caption[Hyperparameter Combinations for different model types]{Hyperparameter Combinations for different model types. Note that
    HMM and CuSUM have only discrete hyperparameters, so there is a maximum
    number of hyperparameter combinations that can be tested.}
    \label{tab:04_uniq_hpar_evals}
\end{table}
prettier-ignore-end

The mean inference time for the HMMs is much larger because of the in

-->

# Evaluation Metrics

Given a set of classes $C = {c_1, c_2, \ldots, c_{|C|}}$ and a number of
observations $n$, multi-class classifiers can be evaluated against one another
when comparing the ground truth labels $\bm{t}: t_i \in C \,\forall\, i \in {1,
\ldots, n}$ against the labels predicted by that classifier $\bm{p}: p_i \in C
\,\forall\, i \in {1, \ldots, n}$. The following subsections will describe
different means of comparing multi-class classifiers.

## Confusion Matrices

Confusion matrices collate a models performance by grouping each combination of
predicted and ground truth label. For a $|C|$-class classification problem, a
confusion matrix is a $|C| \times |C|$ matrix of values, where the
element in the $i$-th row and the $j$-th column of the confusion matrix is the
number of times a classifier predicted an observation that belongs to class $i$
as belonging to class $j$. That is, that the ground truth label is $i$ and the
predicted label is $j$. The element-wise definition of a confusion matrix is

$$
    \text{Confusion Matrix}_{ij} = \sum_{k=1}^{n} [t_k = j \land p_k = i].
$$

An example confusion matrix is given in the top-left plot of Figure
\ref{fig:04_example_conf_mat}. Note that elements in the confusion matrix which
are zero are left uncoloured and are not annotated with a 0. For confusion
matrices with few classes and few observations this will not matter
significantly. However, for confusion matrices with many classes and many
observations it will prove informative to be able to distinguish one
misprediction from zero mispredictions.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_example_conf_mat}
    \caption[Example confusion matrices]{Four example confusion matrices, each showing the same data but
    visualised under four different normalisation schemes.}
    \label{fig:04_example_conf_mat}
\end{figure}
<!-- prettier-ignore-end -->

In practice, confusion matrices are often normalised before visualisation as
this aids in the interpretation of the model's performance. The unnormalised
confusion matrix is shown in the top-left plot of
Figure \ref{fig:04_example_conf_mat}. Confusion matrices can also be column- or
row-normalised (shown in the top-right and bottom-left plots respectively).
Column normalisation divides each element by the sum of its column, such that
each column sums to one. Row normalisation is similar, and ensures each row
sums to one.

Row-normalization and column-normalization ensure that each element in the
matrix represents the proportion of ground truth or predicted labels concerning
the total number of ground truth or predicted labels for the associated class,
respectively.

Confusion matrices can also be total-normalised (as seen in the bottom-right
plot) in which case every element is divided by the sum over the entire
confusion matrix. This allows the elements to be interpreted as a fraction of
the total number of observations.

Unless otherwise specified, all confusion matrices presented in this thesis are
column-normalised.

It is also useful to compare the confusion matrices for all instances of a
model across two or more values of a discrete hyperparameter. For example,
comparing the confusion matrices for FFNNs with one, two, and three layers. In
these cases, the weighted confusion matrix shall be shown. The weighted
confusion matrix of a subset of models is calculated by taking the unnormalised
confusion matrix for a model, multiplying each value in that confusion matrix
by the model's $F_1$-score, and then adding all confusion matrices together
element-wise. The resulting sum of weighted confusion matrices is then divided
by the sum of all $F_1$-scores and finally column-normalised. This procedure is
given in Algorithm \ref{alg:04_weighted_cm}.

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption[Weighted confusion matrices]{Comparison of Weighted Confusion Matrices}
    \label{alg:04_weighted_cm}
    \begin{algorithmic}[1]
        \Require A set of models
        \Require A method for computing the confusion matrix for a model
        \Require A method for computing the $F_1$-score for a model
        \State $\bm{C}_{weighted} \gets \mathbf{0}_{n\times n}$
        \State $\Sigma F_1 \gets 0$
        \For{$model$ in $models$}
            \State $\bm{C} \gets$ \Call{ComputeConfusionMatrix}{model}
            \State $F_1 \gets$ \Call{$\text{ComputeF}_1\text{Score}$}{model}
            \State $\bm{C}_{weighted} \gets \bm{C}_{weighted} + (F_1 \cdot \bm{C})$
            \State $\Sigma F_1 \gets \Sigma F_1 + F_1$
        \EndFor
        \State $C_{weighted} \gets \frac{\bm{C}_{weighted}}{\Sigma F_1}$
        \State $C_{weighted} \gets$ \Call{ColumnNormalize}{$C_{weighted}$}
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

## Accuracy

The accuracy of a classifier is defined as the number of correct predictions
over the total number of predictions. This metric does not take into account
the distribution of predictions and does not work well when there is a class
imbalance. If 99% of the data belongs to a class YES while 1% of the data
belongs to the class NO, then a naïve classifier can achieve 99% accuracy by
always predicting YES. As the _Ergo_ dataset has a large class imbalance,
accuracy will not be used as a metric for comparing models.

## Precision, Recall, and $F_1$-score

Confusion matrices aid in the interpretation of large numbers of predictions,
but do not have a total ordering. To this end, we will define first the
per-class precision, recall, and $F_1$-score. These metrics depend on
four summary statistics:

- $\text{TP}_i$, the number of true positives for class $c_i$: This is the
  number of labels for which both the ground truth and the predicted class are
  $c_i$:

  $$
       \text{TP}_i = \sum_{j=1}^n [t_j = p_j = c_i]
  $$

- $\text{TN}_i$, the number of true negatives for class $c_i$: This is the
  number of labels for which both the ground truth and the predicted class are
  _not_ $c_i$:

  $$
       \text{TN}_i = \sum_{j=1}^n [t_j \neq c_i \land p_j \neq c_i]
  $$

- $\text{FP}_i$, the number of False positives for class $c_i$: This is the
  number of labels for which the predicted class is $c_i$ but the true label
  is _not_ $c_i$:

  $$
       \text{FP}_i = \sum_{j=1}^n [p_j = c_i \land t_j \neq c_i]
  $$

- $\text{FN}_i$, the number of False negatives for class $c_i$: This is the
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
that both a high precision and high recall are required to obtain a high
$F_1$-score. This is made clear when plotting the $F_1$-scores for various
precision and recall values, as in Figure \ref{fig:04_precision_recall_f1}.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics{src/imgs/graphs/04_precision_recall_f1}
    \caption[Precision and recall with $F_1$ as contours]{Precision and recall with the calculated $F_1$-score plotted as
    contours. Both a high recall and a high precision are required for a high
    $F_1$-score.}
    \label{fig:04_precision_recall_f1}
\end{figure}
<!-- prettier-ignore-end -->

To aid comparison, the same data used to construct the confusion matrices in
Figure \ref{fig:04_example_conf_mat} will be used to plot the per-class
precision, recall, and $F_1$-score. They will be visualised as a heatmap with
one column per class and one row for each of precision, recall, and
$F_1$-score. This plot is shown in Figure \ref{fig:04_prec_rec_f1_example}.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_prec_rec_f1_example}
    \caption[Precision, recall, $F_1$ heatmap]{Precision, recall, and $F_1$ score for the confusion matrix in
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

## Weighted and Unweighted Averages

While precision, recall, and $F_1$-score provide a much more concise
representation of a classifier's performance than a confusion matrix, they
still do not provide a single number through which all classifiers might be
given a total ordering. To this end, we will calculate the unweighted
arithmetic mean of the per-class precision, recall, and
$F_1$-scores\footnote{
The unweighted average is sometimes referred to as the macro average, and
the weighted average as the micro average.
}.

The unweighted mean is desirable for the task at hand as the _Ergo_ dataset is
highly imbalanced, with one class being assigned to 97% of the observations. If
the weighted mean was used instead, then a classifier would be able to achieve
very high performance by ignoring the minority classes and only focusing on
predicting the majority class correctly.

For these reasons, the unqualified terms precision, recall, and
$F_1$-score will be taken to mean the unweighted mean over the per-class
precisions, recalls, and $F_1$-scores.

It is important to note that one cannot calculate the unweighted $F_1$-score
using the unweighted precision and recall due to the non-linear relationship
between the $F_1$-score and precision and recall. This has the unfortunate
implication that a plot showing the unweighted precision and unweighted recall
of a model does _not_ allow the viewer to infer its unweighted $F_1$-score. The
$F_1$-score must be shown in another plot of mentioned explicitly.

# An Ordering Over Multi-class Classifiers

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

<!-- TODO: Probably need something here describing student's t-Distribution and
how confidence intervals are calculated. -->

# The Conversion of Class Predictions into Keystrokes

Converting sensor measurements into classifications is not enough, as they
still need to be converted into keystrokes. There are a few ambiguities to
clear up in order to make this process clear.

As only the neural-network based models natively support probabilities,
predictions will be assumed to be just one class label, as opposed to a
one-hot-encoded vector or a matrix of class probabilities. It is trivial to
convert between these formats, so there is no loss of generality.

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
    \caption[The default keystroke mappings for \emph{Ergo}]{The default
    keystroke mappings for \emph{Ergo}. Note that the layout is similar to the
    QWERTY. \emph{Ergo} recognises control keys like \texttt{control} and
    \texttt{shift}, so the user can combine gestures to get new keystrokes.}
    \label{tab:04_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

The mapping allows certain gestures to emit the \texttt{control} and the
\texttt{shift} non-printing characters. These characters, in addition to the
other printing characters, greatly extends the number of input a user can give.
As is natural for regular keyboard input, performing the gesture for
\texttt{shift} and then the gesture for the letter \texttt{a} would result in
the keystroke \texttt{A} being sent. This applies for all alphabetical
characters a--z, as well as the numerals 0--9 and various punctuation
characters. The effect of pressing \texttt{shift} before each character is
visible in Table \ref{tab:04_shift_keystrokes}. Empty cells indicate that shift
has no effect.

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
    \caption[\emph{Ergo} keystrokes with \texttt{shift} pressed]{The keystrokes
    emitted by the \emph{Ergo} software when certain each gesture is made after
    the \texttt{shift} control-character has been given.}
    \label{tab:04_shift_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

The \texttt{control} character also allows for some other keystrokes to be made, such
as carriage return (\texttt{ctrl+j} or \texttt{ctrl+m}), backspace
(\texttt{ctrl+h}), or escape (\texttt{ctrl+[}). These key combinations are the
same as in the text editor Vim\footnote{https://vim.org}. See vim's built-in
help \texttt{:h ins-special-keys} for more details.
