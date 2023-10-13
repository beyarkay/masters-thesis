This chapter will describe the construction of the hardware that powers _Ergo_,
how the training data was collected and processed, what experiments were
conducted, and how different model architectures were applied to the task of
predicting gestures given an observation. Hyperparameters of those models (and
their optimisation) is also discussed. The evaluation metrics used to rank the
models is discussed, and the method for turning gesture predictions into
keystrokes is described

<!--
TODO: Ensure this is fully integrated

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


1. Did you use a correct trianing methodology
1. Is the results showing working models for each model type. Check no
   programming bugs.
1. Under what circumstances do the models stop working
1. Does the candiadte understand why the model is perfroming badly in some
   cases
1. Are the results clear or presented in some onorthodox way can I make sense
   of the results as an examiner....

I think the chapter falls short on a number of these points and I think you
need to rework it quite a bit.
-->

# Construction of Ergo (?)

- What does _Ergo_ look like?
- Where are the sensors placed?

# How the data was collected

- Gravity is included
- 10 sensors, 3 axes per sensor
- 30 dimensional time series, recorded at ~40Hz, about 100 examples per
  class, 50 classes, 1 majority class (g255), around 230k observations.
- Data segmentation is "implicit": There's no nice labels marking the start
  and end of each gesture, the model has to learn 1. how to extract
  gestures from background and 2. how to differentiate between the
  different gestures.
- Data was collected over multiple sessions, performing the same ~5 gestures
  repeatedly and then manually labelling the data

# Splitting the data into train, test, validation \label{sec:trn_tst_val}

The measurements recorded from _Ergo_ are stored on disk as several files
listing the time stamp, the 30 sensor values, and the associated gesture with
that particular time stamp. There are 37MB and 241 762 lines of data.
Preliminary testing showed that models trained on just a single instant of time
did not perform as well as models provided with a historical window of data.
This allows the model to recognise the rate of change of acceleration, and not
only the raw acceleration.

The entire dataset is combined together and then windowed so as to produce a
dataset of shape $(\text{number of observations}, 20, 30)$. 25% of this dataset
is split off and saved as the testing dataset. It is saved as a single binary
file, separated from the training and validation data. The splitting procedure
ensures that the frequency of the different classes is approximately
maintained, but otherwise chooses a random subset of the full dataset.

The remaining 75% of the full dataset is saved to disc as a single binary file.
This training+validation dataset is only split into separate training and
validation datasets at training time, just before each model is fit to the
training subset. This allows the exact observations which are sorted into the
training and validation dataset to depend on the random seed assigned to each
hyperparameter combination, which in turn allows for arbitrary-repetition cross
validation.

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

# What experiments will be conducted?

- (These should tie into the "research questions" asked in the introduction)

# Model-specific stuff

## HMM

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- Discussion about why the HMMs couldn't be trained on every training
  observation but could be evaluated on every validation observation.
- Probably also need to acknowledge those mad lads with the 5000-class HMM
  classifier

## CuSUM

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- How does CuSUM perform one-vs-rest classification, how does "passing a
  threshold" get transformed into a gesture detection?

## FFNN

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- Dropout means that validation and training loss are not directly comparable
- Thoroughly explain the purpose of regularization wrt dropout, L2 norm, etc
- What optimizer is used?
- What loss function?
- activation function?
- How do the inputs get weighted?

## HFFNN

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.

## SVM

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.

# How is hyperparameter optimisation done?

Random search as recommended by James Bergstra and Yoshua Bengio, Random Search
for Hyper-Parameter Optimization

Hyperparameter optimisation was performed per model type via random search over
the model type's hyperparameter space. A value for each hyperparameter was
randomly selected (hyperparameters, ranges, and distributions are specified in
Table \ref{tab:04_hpar_dists}) and then five models were trained with those
hyperparameters.

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

Each model was trained on a different subset of the training
data, using the cross-validation procedure described in Section
\ref{sec:trn_tst_val}. Summary statistics of each model's performance on the
training and the validation sets are saved to disc.

If a model has random elements, the PRNG\footnote{elaborate} is seeded with a
seed unique to that model, to ensure reproducibility.

Each model has a different validation set, determined by that model's seed.

The ground truth labels for each model's validation set are saved to disc, as
well as the predictions the model made for the observations in that validation
set. This allows for arbitrary performance metrics to be calculated after
training, as the ground truth and predicted labels are available for
comparison.

Different model types had differing numbers of evaluated hyperparameters
across. This stemmed from discrepancies in the quantity of hyperparameters and
distinct training and evaluation durations for each model.

<!-- TODO: histogram of distances to evaluated hpars
To ensure each model got sufficient coverage over the hyperparameter space,
Figure \ref{fig:04_todo} shows the mean manhatten distance from 10 000 randomly
chosen points in each model's hyperparameter space to the nearest evaluated
hyperparameter.
-->

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

# How will the models be ranked?

- ranked based on the performance of the lower bound of the 90% percentile
  - Maybe we need to prove that 90% is reasonable, and the results don't
    really change if we pick 95% nor 99% nor 100%

# How are predictions turned into keystrokes?

---

# (old) Hardware Description

_Ergo_ consists of ten ADXL335 tri-axis linear accelerometers, each one of
which is mounted to the back of the user's fingertips (see Figure
\ref{fig:accelerometers}).

\begin{figure}[!htb]
\centering
\includegraphics[width=0.5\textwidth]{src/imgs/accelerometers.jpg}
\caption{The user's left hand while wearing \textit{Ergo}, with the
accelerometers highlighted in red.}
\label{fig:accelerometers}
\end{figure}

These accelerometers can measure linear acceleration in three
orthogonal directions, but cannot measure rotational acceleration. Due to how
the accelerometers are built, the measurements they provide _do_ include
gravity. For example, an accelerometer at rest will register a large
acceleration towards the centre of the earth. This makes distinguishing
acceleration due to finger movement and acceleration due to gravity impossible
based off of the linear acceleration alone. Appendix
\ref{the-adxl335-accelerometers} contains more information about the
accelerometers.

Each accelerometer measures linear acceleration in the orthogonal X, Y, and Z
directions (see Figure \ref{fig:adxl335-xyz}). This results in fifteen
measurements for each hand.

\begin{figure}[!htb]
\centering
\includegraphics[width=0.5\textwidth]{src/imgs/accel_xyz.jpg}
\caption{The user's left hand while wearing \textit{Ergo} with the
accelerometer directions indicated. The X direction is in red, the Y
direction is in green, and the Z direction is in blue.}
\label{fig:adxl335-xyz}
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
