<!--
TODO: add tSNE to appendix

TODO remove figures that haven't been referenced.

FIXME: the calculation of the F_1 score contours is wrong for some reason.
I think it has to do with the weighting of each class. It's only really visible
near precision ~= 0 or recall ~= 0. Maybe this would be fixed if we used micro
avg instead of macro avg? Regardless, the macro avg f1-score _cannot_ be
calculated from the macro avg precision and macro avg recall.

```py
sns.scatterplot(
    data=df.assign(**{
        'calc_f1-score': lambda ddf: 2 * (ddf['val.macro avg.precision'] * ddf['val.macro avg.precision']) / (ddf['val.macro avg.recall'] + ddf['val.macro avg.recall'])
    }),
    x='val.macro avg.f1-score',
    y='calc_f1-score',
    hue='preprocessing.num_gesture_classes',
    size=.5,
    alpha=0.5,
    edgecolor=None,
)
```
-->

This chapter will discuss the results obtained from the experiments described
in the Methodology chapter. The dataset will be described and some preliminary
analysis done in Section \ref{dataset-description}. Section
\ref{comparison-of-hypothetical-models} will compare some hypothetical models
and explore their performance characteristics, so as to better understand
common failure cases for the dataset at hand. Section \ref{model-justification}
will justify the choice of models which were evaluated in this thesis. The
performance of each model is described in subsections \ref{in-depth-ffnn},
\ref{in-depth-hmm}, \ref{in-depth-cusum}, \ref{in-depth-hffnn}, and
\ref{in-depth-svm}.

Section \ref{best-model} looks at all trained models on the full dataset and
evaluates their performance. As _Ergo_ requires real-time inference, Section
\ref{time-comparison} compares the inference and training times of each model.
Section \ref{ratio-comparison} assesses the training and validation performance
of each model as an indicator of the model's susceptibility to overfitting on
the training data, which, in turn, could lead to subpar performance on unseen
observations. Section \ref{real-world-data} evaluates each model on a
real-world dataset of English-language typing data. Finally, Section
\ref{test-set-eval} evaluates the best performing model on the unseen test set.

# Dataset Description

The core goal of _Ergo_ is to convert hand motion to keyboard input. To this
end, there are 10 acceleration sensors mounted on the user's fingertips. Each
of these sensors measure linear acceleration in three axes at a rate of 40
times per second. This leads to a 30 dimensional time-series dataset, with one
timestep representing 0.025 seconds. Table \ref{tab:05_gesture0016} shows the
user's hands as a single gesture is being performed.

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|}
        \hline
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_0}
            \caption{Resting position with hands at $45^\circ$}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_1}
            \caption{The finger starts flexing}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_2}
            \caption{The finger is fully flexed}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_3}
            \caption{The finger starts returning to resting position}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_4}
            \caption{The gesture ends in the resting position}
        \end{subfigure} \\
        \hline
    \end{tabular}
    \caption{Video frames showing gesture number 16 being performed, in which
    both hands are oriented at $45^\circ$ and the right hand's index finger
    flexes.}
    \label{tab:05_gesture0016}
\end{table}
<!-- prettier-ignore-end -->

_Ergo_ can recognise 50 gesture classes and one non-gesture class. The
non-gesture class is used to represent the empty durations in-between gestures
during which the user's hands may be still, the transitioning period which
occurs after one gesture ends and another begins. The 50 gesture classes are
numbered from 0 to 49, and the software powering _Ergo_ takes care of
converting a predicted gesture class into a keystroke via a user-configurable
gesture-to-keystroke mapping. The non-gesture class is numbered as gesture 50.

The motion for each gesture is defined as the Cartesian product of a finger
motion and a hand orientation. There are 10 finger motions, one for each finger
flexing towards the palm of the user's hand. There are five orientations, which
define the angle both hands make with the horizon: $0^\circ, 45^\circ,
90^\circ, 135^\circ, 180^\circ$. The way in which these 10 fingers and 5
gestures combine to make 50 gestures is described in Table
\ref{tab:05_gestures}.

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   &  0 &  1 &  2 &  3 &  4 &  5 &  6 &  7 &  8 &  9 \\
        \hline
        $45^\circ$  & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 \\
        \hline
        $90^\circ$  & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 \\
        \hline
        $135^\circ$ & 30 & 31 & 32 & 33 & 34 & 35 & 36 & 37 & 38 & 39 \\
        \hline
        $180^\circ$ & 40 & 41 & 42 & 43 & 44 & 45 & 46 & 47 & 48 & 49 \\
        \hline
    \end{tabular}
    \caption{The cells of this table contain the different indices of the
    gestures which \emph{Ergo} can recognise. The index of each gesture is
    semantic: the units digit refers to the finger being flexed and the tens
    digit refers to the orientation of the hands. Each column of the table
    contains gestures where the finger being flexed is the same, and each row
    of the table contains gesture indices where the orientation of the gesture
    is the same.}
    \label{tab:05_gestures}
\end{table}
<!-- prettier-ignore-end -->

As previously mentioned, these 50 gestures are mapped to keystrokes via a
gesture-to-keystroke mapping. The default mapping is shown in Table
\ref{tab:05_keystrokes}, which has the same layout as Table
\ref{tab:05_keystrokes} to allow for easy comparison. The similarity in the
layout of the gestures to the English QWERTY keyboard allows for a new user to
easily learn which gestures map to which keystrokes. A hand orientation of
$90^\circ$ corresponds to the "home row" of a QWERTY keyboard.

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
    \label{tab:05_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

As the user performs gestures with _Ergo_, the sensor data is recorded and
stored to disk. A snapshot of these recordings is visible in Figure
\ref{fig:05_sensors_over_time_3230_30} which shows $\frac{3}{4}$ of a second during
which gesture 8 (right ring finger flexion with the hands at $0^\circ$,
\texttt{\`}) was made. During this period, the orientation of the hands
remained relatively stable as can be seen by how the majority of the sensors
recorded relatively stable values.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_sensors_over_time_3230_30}
    \caption{A snapshot of the sensor values as gesture 8 was being performed.
    The line plot and heatmap show the same data. The lines on the line plot
    are coloured based on the axis of the sensor: X-axis in red, Y-axis in
    green, Z-axis in blue. The line plot clearly shows an increase in the X, Y,
    and Z acceleration measured by one sensor. The heatmap makes it clear
    exactly which sensors experienced increased acceleration.}
    \label{fig:05_sensors_over_time_3230_30}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_sensors_over_time_3230_3200} shows a greater period of time,
80 seconds, during which multiple gestures were made and the orientation of the
hands changed multiple times. This can be seen by the long-term changes in
the majority of the sensor values.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_sensors_over_time_3230_3200}
    \caption{This plot shows the sensor values over a longer period of time,
    similar to Figure \ref{fig:05_sensors_over_time_3230_30}. Note that there
    are very brief spikes of acceleration interspersed with long periods of
    relatively stationary measurements. Also note that the orientation of the
    hands can be seen clearly in the heatmap, where the values of all sensors
    change at approximately the same time.}
    \label{fig:05_sensors_over_time_3230_3200}
\end{figure}
<!-- prettier-ignore-end -->

_Ergo_ can be defined as a 51-class classification problem with a highly
imbalanced class distribution (see Figure \ref{fig:05_class_imbalance}). During
training, the number of gestures performed per second is never greater than 2.
Given a data capture frequency of 40 times per second, this means that there
are at least 19 non-gesture labels for every gesture label, and that gesture
label is one of 50 possible gesture labels. This leads to a class balance of
about 97.6% of the data belonging to the non-gesture class, with the remaining
2.4% of the data divided approximately evenly between the 50 gesture classes.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_class_imbalance}
    \caption{Bar plots showing class imbalance. Class 50 occupies about 97\% of
    the data}
    \label{fig:05_class_imbalance}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_example_g0011_plot} shows all observations for gesture 11
plotted over each other, with one plot per sensor. The left ring finger is
clearly showing significant accelerations, but many other fingers are also
measuring accelerations. Note how the right hand is largely static, except the
orientation of the hand is varied.

<!-- TODO: Make this plot have properly sized plot titles -->
<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_example_g0011_plot}
    \caption{All observations for gesture 11, laid on top of one another with
    one plot per sensor.}
    \label{fig:05_example_g0011_plot}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_pca_plot} shows two PCA plots of the training data. The left
plot does not include the non-gesture class, while the bottom plot does. There
is reasonable separation between the gestures (as can be seen from the diagonal
streaks of colour). However, the bottom plot shows that the non-gesture class
has significant overlap with every other gesture, making it likely that a model
will easily distinguish the different gestures but struggle to distinguish the
gesture classes from the non-gesture class.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_pca_plot}
    \caption{Plot of the Principal Components of the training data. Left: All
    gesture observations, with the orientation of the gesture mapped to the
    colour and the finger used for the gesture mapped to the marker. L5 and R5
    are the left and right little fingers, L1 and R1 are the left and right
    thumbs. Right: The same observations, but with class 50 plotted in black.
    Note how the gesture classes are easily separated, but the non-gesture
    class is not easily separated from the gesture classes.}
    \label{fig:05_pca_plot}
\end{figure}
<!-- prettier-ignore-end -->

<!-- TODO It is more standard to use t-sne here.-->

# Comparison of hypothetical models

In this section, several hypothetical models are defined and their performance
examined. These hypothetical models have been chosen so as to provide some
intuition about common pitfalls encountered by real models.

Figure \ref{fig:05_pr_conf_mat_random_preds} shows the precision-recall graph
and confusion matrix of a classifier that predicts every observation according
to a uniform random distribution.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_pr_conf_mat_random_preds}
    \caption{Precision-recall graph and confusion matrix of a classifier that
    predicts completely randomly.}
    \label{fig:05_pr_conf_mat_random_preds}
\end{figure}
<!-- prettier-ignore-end -->

The precision-recall graph shows thirty repetitions, however the points are too
tightly clustered to be easily distinguished. The confusion matrix shows the
mean confusion matrix from the same thirty repetitions. This completely-random
classifier achieves a mean $F_1$-score of 0.00166. The confusion matrix also
makes it clear that the majority of observations belong to class 50, the
non-gesture class.

The highly imbalanced nature of the dataset permits a naïve classifier to
achieve 97.6% accuracy by always predicting the non-gesture class. Figure
\ref{fig:05_pr_conf_mat_only_50} shows the confusion matrix and
precision-recall graph of such a classifier, which has an $F_1$-score of
0.00164.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_pr_conf_mat_only_50}
    \caption{Precision-recall graph and confusion matrix of a classifier that
    only predicts the non-gesture class, class 50.}
    \label{fig:05_pr_conf_mat_only_50}
\end{figure}
<!-- prettier-ignore-end -->

Each gesture is a combination of a finger being moved and a rotation of the
user's hands. Certain models are better able to learn the finger/orientation of
certain gestures. The next hypothetical models are each perfect in one aspect
but uniformly random in all other aspects.

Figure \ref{fig:05_pr_conf_mat_wrong_orientation} shows the precision-recall
plot and confusion matrix for 30 classifiers that correctly predict the finger
and which hand is being used, but incorrectly predicts the orientation of the
hand. The non-gesture class is always predicted perfectly. Note the
characteristic diagonals, representing how any given gesture might be predicted
by these classifiers as one of five gestures, corresponding to the five
orientations. The mean $F_1$-score for these classifiers is 0.212.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_pr_conf_mat_wrong_orientation}
    \caption{Precision-recall graph and confusion matrix of a classifier that
    is perfect at predicting the finger being used, but always errs when
    predicting the orientation of the hand.}
    \label{fig:05_pr_conf_mat_wrong_orientation}
\end{figure}
<!-- prettier-ignore-end -->

Also instructive is the precision-recall plot and confusion matrix for 30
classifiers that correctly predict the orientation and the hand of a gesture,
but incorrectly predict the finger of a gesture. This plot has distinctive $5
\times 5$ squares along the primary diagonal, indicating how any given gesture
is only ever incorrectly predicted as one of four other gestures (the four
other fingers on that hand). The mean $F_1$-score for these classifiers is
0.214.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_pr_conf_mat_wrong_finger_correct_hand}
    \caption{Precision-recall graph and confusion matrix of a classifier that
    correctly predicts the orientation and hand being used for a gesture, but
    incorrectly predicts the finger being used.}
    \label{fig:05_pr_conf_mat_wrong_finger_correct_hand}
\end{figure}
<!-- prettier-ignore-end -->

# Evaluated Classification Algorithms \label{model-justification}

Several different classification algorithms were evaluated. The chosen
classification algorithms were selected if they are often used in the general
literature on high dimensionality, multi-class, classification data.
Additionally, we took into account their prevalence in gesture classification
studies to facilitate meaningful comparisons between our research and prior
work in the field.

Feed-forward Neural Networks (FFNNs) scale well as the number of classes
increases (see Figure \ref{fig:05_inf_time_vs_num_classes}). To scale a FFNN to
classify a greater number of classes, one needs to (at least) increase the
number of output neurons and retrain the entire network. This is favourable
when compared to an algorithms that requires one classifier to be trained per
class, in which case both the inference time and the training time increases
approximately linearly with the number of classes. While one-vs-rest
classification is suitable for few classes, it quickly becomes unwieldy as the
number of classes increases.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_inf_time_vs_num_classes}
    \caption{Inference times for each observation increases as the number of
    classes increase for HMMs and CuSUM, but that is not the case for SVMs and
    FFNNs. HFFNNs are not shown as they are not trained on fewer than 51
    classes.}
    \label{fig:05_inf_time_vs_num_classes}
\end{figure}
<!-- prettier-ignore-end -->

Hidden Markov Models (HMMs) have frequently been used in the literature for
gesture detection and classification. Multi-class classification with HMMs
require a one-vs-rest approach. This causes training and inference times to
scale approximately linearly with the number of classes. HMMs explicitly model
the progression of time via state transitions, and have shown promise in
previous works. Their implementation will allow for a better comparison between
the current and prior work.

Cumulative Sum (CuSUM) is a simple statistical technique that will provide a
lower bound on the speed with which predictions can be made. While it is
unlikely to outperform other, more sophisticated models, it will be useful as a
baseline against which the inference speed of other models can be compared.

Some works in the literature do not attempt the detection of gestures in
observations, and instead only attempt the classification of a gesture
conditional on the event that there is a gesture present in the observation.
That is to say, that every observation is assumed to contain one of a set of
gestures. This does not reflect real-world usage, in which the vast majority of
the observations do _not_ contain any gesture.

One technique in the literature which has shown promise in dealing with both
detection and classification is that of a hierarchical setup in which there are
two models trained. The first model (the detector) is a binary classifier
simply trained to detect if there is any gesture present in an observation. The
second model (the classifier) is trained on only the observations containing a
gesture, and is trained to classify which gesture is present.

To make a prediction with a hierarchical model, the detector is first queried
with an observation. If the detector indicates that there is no gesture
present, then the no-gesture class is returned as the model's prediction. If
the detector indicates that there is a gesture present, then the observation is
forwarded to the classifier. The classifier then predicts which gesture is
present and this predicted class is returned as the model's prediction.

A Hierarchical Feed Forward Neural Network (HFFNN) architecture is tested,
following the above procedure. Two neural networks are trained: one to detect
if a gesture is present and another to classify which gesture is present (given
that there is indeed a gesture present).

Support Vector Machines (SVMs) have been used in the literature for glove-based
gesture classification and so are evaluated here. SVMs do not natively support
multi-class classification, but multiple SVMs can be combined to perform
one-vs-rest classification. Due to the large number of observations and the
poor scaling characteristics of SVMs as the number of observations increases,
only a linear kernel is considered.

# Discussion of each model

This section will explore each of the models in depth, but will not make
comparisons between different model types. Characteristics specific to each
model type are discussed, relating to $F_1$-score, precision, recall, inference
times, and training times. Where appropriate, confusion matrices of different
models are visualised to aid with the analysis of these models. For inter-model
comparisons, please see sections \ref{best-model} and \ref{time-comparison}.

FFNNs are be discussed in section \ref{in-depth-ffnn}, HMMs in section
\ref{in-depth-hmm}, CuSUMs in section \ref{in-depth-cusum}, HFFNNs in section
\ref{in-depth-hffnn}, and SVMs in section \ref{in-depth-svm}.

## Cumulative Sum \label{in-depth-cusum}

Figure \ref{fig:05_mean_conf_mat_cusum} shows the confusion matrices for CuSUM
models trained on 5, 50, and 51 classes. The values in the confusion matrices
are the weighted mean of all CuSUM models, based on the $F_1$-score of each
CuSUM model.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_mean_conf_mat_cusum}
    \caption{The weighted confusion matrices of three CuSUM classifiers, trained
    on 5, 50, and 51 classes. The confusion matrices are weighted by the
    $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the CuSUM, with each colour representing
    the CuSUM trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_cusum}
\end{figure}
<!-- prettier-ignore-end -->

It can be seen that the 5-class CuSUM models performed well: The weighted
confusion matrix has large values along the principle diagonal. The median
$F_1$-score was 0.813, with a maximum of 0.989. A slight bias can be seen in
the weighted confusion matrix, where gesture 1 (left hand ring finger) is
sometimes predicted as gestures 0 (left hand little finger) and 2 (left hand
middle finger). These mispredictions can be explained by the natural movement
of the human hand: it is difficult to move one's ring finger in isolation. When
performing gesture 1, the user's little finger and middle finger move by some
amount, in addition to the expected movement of the user's ring finger. CuSUM
is not able to learn that this additional movement is expected, and only knows
that acceleration of the user's ring finger should result in a gesture 1, 11,
21, 31, or 41 prediction.

The 50- and 51-class CuSUM models both display a "chequerboard" pattern. This
pattern also originates from the formulation of the CuSUM model. Each of the
blocks on this chequerboard are $5 \times 5$, similar to what was shown in the
hypothetical model in Figure
\ref{fig:05_pr_conf_mat_wrong_finger_correct_hand}. This patten occurs when two
model biases occur simultaneously: The model must often confound gestures using
fingers on the same hand (this causes blocks along the principle diagonal), and
the model must often confound the orientation of the gesture (this causes
whatever pattern was along the principle diagonal to be repeated orthogonally).

These two biases cause the chequerboard pattern seen in the 50- and 51-class
CuSUM models. Note that the values inside each block are not uniform: there is
a slight bias to the diagonals within each block, indicating that the CuSUM
models do have _some_ ability to distinguish different fingers on the same
hand, although this ability is not strong.

### 5-class CuSUM Hyperparameter Analysis

Figure \ref{fig:05_hpar_analysis_cusum_classes5} shows the performance of all
5-class CuSUM models over varying values for its single hyperparameter, the
threshold value.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_hpar_analysis_cusum_classes5}
    \caption{Left: precision-recall plot for all 5-class CuSUM models, with the
    value of the threshold hyperparameter indicated by the colour of the point. Right: a direct
    plot of the model's $F_1$-score against the threshold parameter.}
    \label{fig:05_hpar_analysis_cusum_classes5}
\end{figure}
<!-- prettier-ignore-end -->

One can see that that increasing the value of the threshold hyperparameter
improves the performance of the model, although there are diminishing returns
with an inflexion point around a threshold value of 40. With the maximum
threshold value tested, the maximum $F_1$-score achieved is 0.989, with a
median of 0.937.

### 50-class CuSUM Hyperparameter Analysis

Figure \ref{fig:05_hpar_analysis_cusum_classes50} shows the performance of all
50-class CuSUM models over varying values for its single hyperparameter, the
threshold value.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_hpar_analysis_cusum_classes50}
    \caption{Left: precision-recall plot for all 5-class CuSUM models, with the
    value of the threshold hyperparameter indicated by the colour of the point.
    Right: a direct plot of the model's $F_1$-score against the threshold
    parameter.}
    \label{fig:05_hpar_analysis_cusum_classes50}
\end{figure}
<!-- prettier-ignore-end -->

The relationship between precision, recall, and the CuSUM threshold value is
not as clear for the 50-class CuSUM models as it was for the 5-class CuSUM
models. The 50-class CuSUM models have a precision of $\mu=0.222, \sigma=0.043$
and a recall of $\mu=0.252, \sigma=0.025$. The CuSUM models are clearly unable
to distinguish this many classes from each other.

### 51-class CuSUM Hyperparameter Analysis

While the 51-class CuSUM models are no better at learning the data than the
50-class CuSUM models, it is instructive to examine _how_ these models fail as
the only difference between the 50- and 51-class datasets is introduction of a
class imbalance via a majority class. Figure
\ref{fig:05_hpar_analysis_cusum_classes51} shows the performance of all
51-class CuSUM models over varying values for its single hyperparameter, the
threshold value.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_hpar_analysis_cusum_classes51}
    \caption{Left: precision-recall plot for all 5-class CuSUM models, with the
    value of the threshold hyperparameter indicated by the colour of the point.
    Right: a direct plot of the model's $F_1$-score against the threshold
    parameter.}
    \label{fig:05_hpar_analysis_cusum_classes51}
\end{figure}
<!-- prettier-ignore-end -->

Examining the precision ($\mu=0.030, \sigma=0.004$) and recall ($\mu=0.254,
\sigma=0.027$) of the 51-class CuSUM models and comparing them to the precision
($\mu=0.222, \sigma=0.043$) and recall ($\mu=0.252, \sigma=0.025$) of the
50-class CuSUM models, we can see that while the precision of the 51-class
CuSUM models is an order of magnitude less than that of the 50-class CuSUM
models ($\mu=0.030$ vs $\mu=0.222$), the recall of the 50- and 51-class CuSUM
models is similar ($\mu=0.254$ vs $\mu=0.252$).

As the only difference between the 50- and 51-class CuSUM models is the
addition of the non-gesture majority class (class 50), we can infer that this
additional class reduces the precision of CuSUM but not the recall.

The cause of this is clear when looking at the confusion matrices for the 50-
and 51-class CuSUM models (Figure \ref{fig:05_mean_conf_mat_cusum}). There is a
row at the bottom of the 51-class confusion matrix indicating that CuSUM often
predicts class 50 as belonging to one of the other classes. If gesture 50 is
predicted as belonging to class $c_i$, then that is a False Positive prediction
for class $c_i$. The definition for precision contains the number of False
Positives in the denominator:

$$
    \text{Precision}_i = \frac{\text{TP}_i}{\text{TP}_i + \text{FP}_i}.
$$

Increasing the number of False Positives will decrease the precision of a
model, all else being equal. As there are many instances where class 50 is
being predicted as belonging to class for the 51-class CuSUM models, this
increases the False Positive rate and correspondingly decreases the precision
of the model, while leaving the recall approximately the same.

## Hidden Markov Models \label{in-depth-hmm}

Figure \ref{fig:05_mean_conf_mat_hmm} shows the confusion matrices for HMMs
trained on 5, 50, and 51 classes.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_mean_conf_mat_hmm}
    \caption{The weighted confusion matrices of three HMM classifiers, trained
    on 5, 50, and 51 classes. The confusion matrices are weighted by the
    $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the HMMs, with each colour representing
    the HMMs trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_hmm}
\end{figure}
<!-- prettier-ignore-end -->

The 5-class HMMs are mostly strong classifiers, with a median validation
$F_1$-score of $0.694$ and a maximum of 1. It is clear from the 5-class
confusion matrix that gesture 4 was predicted correctly much more frequently
than the other gesture classes. Gesture 4 flexes the left hand's thumb (as does
every gesture which ends in the digit 4). This can be attributed to the sensors
on the thumbs being oriented differently to the sensors on the other fingers
(since the sensor is designed to lie flat on the user's fingernail). This has
the effect of changing which one of the three axes is dominated by gravity,
leading to gestures which are easier to distinguish.

The 5-class confusion matrix also makes apparent that adjacent gestures (for
example, gestures 0 and 1, or 1 and 2) are slightly more likely to be
confounded by the 5-class HMM. This can be seen in how the cells directly
adjacent to the principle diagonal contain larger values than the cells further
from the principle diagonal. This can be attributed to how the movement of ones
fingers is not completely independent, and moving one finger is likely to
subtly move the fingers adjacent to it. This effect is less apparent between
gestures 3 and 4 as the movement of the thumb is largely independent from the
movement of other fingers.

The 50-class HMMs generally show good performance, with a median $F_1$-score of
$0.699$ and a maximum of $0.968$. A chequerboard pattern (similar to that seen
on the 50-class CuSUM models) can be seen, although it is not very pronounced.
Diagonals adjacent to the principle diagonal can also be seen, indicating that
the 50-class HMMs occasionally mistake the orientation of the gesture. One can
also see that gestures involving the thumb (gestures 4, 5, 14, 15, 24, 25, 34,
35, 44, 45) are more accurately classified than other gestures. This is the
natural extension of what was seen in the 5-class HMMs where the orientation of
the thumb allowed the HMMs to be more certain of its predictions of the thumb.

The 51-class HMMs shows poor performance, with a median $F_1$-score of $0.034$
and a maximum of $0.047$. This is caused by the inability of the 51-class HMMs
to correctly classify class 50. The vast majority of observations belonging to
class 50 are incorrectly classified as belonging to one of the other gesture
classes. This causes the 51-class HMMs have a greatly reduced precision. This
behaviour is similar to the 51-class CuSUM models.

### 5-class HMM Hyperparameter Analysis

As HMMs only have one hyperparameter (the covariance type), Figure
\ref{fig:05_in_depth_hmm_5_p_vs_r_covar_type} shows the precision-recall plot
for all 5-class HMMs as well as the $F_1$-score of each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_hmm_5_p_vs_r_covar_type}
    \caption{Left: Precision-recall plot for all HMMs trained on 5 classes, with
    the models' $F_1$-scores as contours in grey. Right: Plot of the model's
    $F_1$-score for each covariance matrix type. Note that the scales of the
    axes have been adjusted to better show the distribution of the data.}
    \label{fig:05_in_depth_hmm_5_p_vs_r_covar_type}
\end{figure}
<!-- prettier-ignore-end -->

The tied covariance matrix HMMs performed the best, with a median
$F_1$-score of $0.967$ and a maximum of $1$. The full covariance matrix HMMs
had a very large range $[0.227, 0.968]$ when compared to the tied $[0.827,
1]$, spherical $[0.475, 0.895]$, and diagonal $[0.199, 0.817]$ covariance
matrix HMMs. This is likely due to the full covariance matrix HMMs having the
least constraints on the covariance matrix of the emission probability
distributions, therefore having the greatest number of values which can
influence the performance of the HMM.

The full covariance matrix HMMs have the next best performance after the tied
covariance matrix HMMs, however the variance of the full covariance matrix HMMs
is so large as to make them unreliable. The spherical and then the diagonal
covariance matrix HMMs have the next best median $F_1$-score, with $0.724$ and
$0.599$ respectively.

The spherical covariance matrix HMMs performed better than the diagonal
covariance matrix HMMs. The need for more parameters in expressing the diagonal
covariance matrix ($\bm{\lambda} \mathbb{I}$, where $\bm{\lambda}$ is a vector
of parameters and $\mathbb{I}$ is the identity matrix) compared to the
spherical covariance matrix ($\lambda \mathbb{I}$, where $\lambda$ is a scalar
parameter) can lead to diagonal covariance matrix HMMs requiring additional
training iterations on the same data.

The tied covariance matrix HMMs likely perform so well because each state of
the HMM (and therefore the distribution of each Gaussian emission) comes from
the same distribution: the space of acceleration values which can be reached by
the _Ergo_ hardware. This means that fitting a single covariance matrix which
is shared by all states is an efficient means of describing the overall
distribution of the data. Each timestep is sampled from approximately the same
distribution, and so is well represented by one covariance matrix.

Figure \ref{fig:05_in_depth_hmm_inf_trn_time_classes5} depicts the time taken
per observation for both fitting the HMM and making a prediction with that HMM.
The spherical and diagonal covariance types take an order of magnitude less
time to perform inference on a give observation compared to the tied and full
covariance types. The spherical and diagonal covariance types also take
approximately an order of magnitude less time to be trained on the dataset when
compared to the tied and full covariance types. This is due to the increased
number of parameters in the tied and full covariance types.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_in_depth_hmm_inf_trn_time_classes5}
    \caption{Duration in seconds per observation required to fit and to train
    the different covariance types for 5-class HMMs.}
    \label{fig:05_in_depth_hmm_inf_trn_time_classes5}
\end{figure}
<!-- prettier-ignore-end -->

<!-- TODO: This theory about the full HMMs having the largest variance because
it's got the most unconstrained dimensions is true, but doesn't hold up.

Looking at the covariance type, the number of free dimensions, and the
variance:

Full: 22 x 30 x 30 = 19 800     std = 0.210
Tied:      30 x 30 =    900     std = 0.033
Sphe: 22           =     22     std = 0.091
Diag: 22 x 30      =    660     std = 0.116

So The number of free dimensions implies that the Tied HMMs would have the
second largest variance, but actually it has the lowest variance.
-->

<!-- TODO probably also want to analyse the per-covariance type confusion
matrices and precision-recall-f1 heatmaps
-->

### 50-class HMM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_hmm_50_p_vs_r_covar_type} shows the
precision-recall plot for all 50-class HMMs, as well as the $F_1$-score
of each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_hmm_50_p_vs_r_covar_type}
    \caption{Left: Precision-recall plot for all HMMs trained on 50 classes, with
    the models' $F_1$-scores as contours in grey. Right: Plot of the model's
    $F_1$-score for each covariance matrix type. Note that the scales of the
    axes have been adjusted to better show the distribution of the data.}
    \label{fig:05_in_depth_hmm_50_p_vs_r_covar_type}
\end{figure}
<!-- prettier-ignore-end -->

The tied covariance matrix HMMs perform well with 50 classes, with a median
$F_1$-score of 0.952 and a maximum of 0.968. This lends credence to the
hypothesis that the tied covariance matrix HMMs perform well because each state
emits a value from a distribution with the same covariance matrix, allowing for
a sufficient number of parameters to describe that distribution, but not too
many that they cannot be trained within the computational bounds of the
training procedure.

The other covariance types perform poorly, and once again the full covariance
matrix HMMs have a very large variance. Like with the 5-class HMMs, the
spherical covariance matrix HMMs performed better than the diagonal covariance
matrix HMMs. The performance of each covariance matrix type is relatively
similar when comparing the 5- and 50-class HMMs. In this context, the tied HMMs
are the top performers, followed by the full HMMs, and then the spherical HMMs,
with diagonal HMMs having the least favourable performance. The full HMMs have
a very high variance.

Figure \ref{fig:05_in_depth_hmm_inf_trn_time_classes50} depicts the time taken
per observation for both fitting the HMM and making a prediction with that HMM.
Similar to the 5-class HMMs, the spherical and diagonal covariance types are
faster than the tied and full covariance types, both when training and when
performing inference. By comparing Figure
\ref{fig:05_in_depth_hmm_inf_trn_time_classes50} and Figure
\ref{fig:05_in_depth_hmm_inf_trn_time_classes5}, one can see that the inference
times take longer for the 50-class HMMs than for the 5-class HMMs. This is to
be expected, given the one-vs-rest multi-class classification strategy that
needs to be employed for the HMMs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_in_depth_hmm_inf_trn_time_classes50}
    \caption{Duration in seconds per observation required to fit and to train
    the different covariance types for 50-class HMMs.}
    \label{fig:05_in_depth_hmm_inf_trn_time_classes50}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_in_depth_hmm_conf_mats_cov_type_classes50} shows the
weighted confusion matrices for each of the four covariance types: spherical,
diagonal, tied, and full. <!-- TODO flesh this out -->

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_conf_mats_cov_type_classes50}
    \caption{todo}
    \label{fig:05_in_depth_hmm_conf_mats_cov_type_classes50}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_in_depth_hmm_prf1_plots_conv_type_classes50} shows the
per-class precision, recall, and $F_1$-score for each of the four covariance
types: spherical, diagonal, tied, and full. <!-- TODO flesh this out -->

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_prf1_plots_conv_type_classes50}
    \caption{todo}
    \label{fig:05_in_depth_hmm_prf1_plots_conv_type_classes50}
\end{figure}
<!-- prettier-ignore-end -->

### 51-class HMM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_hmm_51_p_vs_r_covar_type} shows the precision and
recall of all HMM models trained on all 51 classes, as well as the $F_1$-score
of each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_hmm_51_p_vs_r_covar_type}
    \caption{Left: Precision-recall plot for all HMMs trained on 51 classes, with
    the models' $F_1$-scores as contours in grey. Right: Plot of the model's
    $F_1$-score for each covariance matrix type. Note that the scales of the
    axes have been adjusted to better show the distribution of the data.}
    \label{fig:05_in_depth_hmm_51_p_vs_r_covar_type}
\end{figure}
<!-- prettier-ignore-end -->

The 51-class HMMs were unable to learn the dataset due to the addition of the
majority class, class 50. This addition drastically reduced the precision of
all HMMs, regardless of covariance type. This is similar to what was seen in
the CuSUM models, where hyperparameter combinations performing adequately with
50 classes perform poorly with the addition of the majority class.

The performance of each covariance matrix type has changed when compared to the
5- and 50-class HMMs. The full HMMs have a lower mean than all other covariance
classes. This results in the tied covariance matrix HMMs still being the top
performers for 51-classes, followed by the spherical, diagonal, and then the
full HMMs.

This drop in relative performance experienced by the full HMMs with respect to
the other covariance matrix types can be explained by increased number of
observations. It is likely that the full HMMs (which have the largest number of
parameters) were simply unable to converge on good parameter values within the
number of iterations. The other covariance matrix types do not have as many
parameters and so are able to converge on a good enough solution within the
computation limit.

While there is a positive correlation between the recall and precision for all
the 51-class HMMs, note that the range of precision values covered is very
small and each covariance matrix type achieves approximately the same
precision.

Figure \ref{fig:05_in_depth_hmm_inf_trn_time_classes51} depicts the time taken
per observation for both fitting the HMM and making a prediction with that HMM.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_in_depth_hmm_inf_trn_time_classes51}
    \caption{Duration in seconds per observation required to fit and to train
    the different covariance types.}
    \label{fig:05_in_depth_hmm_inf_trn_time_classes51}
\end{figure}
<!-- prettier-ignore-end -->

As with the 5- and 50-class HMMs, the spherical and diagonal covariance types
are approximately an order of magnitude faster than the tied and full
covariance types, in terms of both the inference time and the training time.

## Support Vector Machines \label{in-depth-svm}

Figure \ref{fig:05_mean_conf_mat_svm} shows the confusion matrices for SVM
models trained on 5, 50, and 51 classes. The values in the confusion matrices
are the weighted mean of all SVM, based on the $F_1$-score of each
SVM.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_mean_conf_mat_svm}
    \caption{The weighted confusion matrices of three SVM classifiers,
    trained on 5, 50, and 51 classes. The confusion matrices are weighted by
    the $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the CuSUM, with each colour
    representing the CuSUM trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_svm}
\end{figure}
<!-- prettier-ignore-end -->

The 5- and 50-class SVMs performed well, with the vast majority of predictions
being accurate. On the 5-class confusion matrix, one can see that class 3 (the
ring finger) gets more consistently confused with other classes; this can
likely be attributed to how it is difficult to move one's ring finger
independently of the other fingers.

The 50- and 51-class SVMs both made mispredictions where the orientation of a
gesture was incorrect, as can be seen by the diagonal lines of cells above and
below the main diagonal.

The 51-class SVMs also performed well, however many mispredictions were made
between class 50 and the gesture classes.

### 5-class SVM Hyperparameter Analysis

The 5-class SVM had no problem whatsoever in classifying the different classes:
the lowest $F_1$-score was 0.909, the median was 1, and the maximum was 1.
There are a few outliers, but the vast majority of 5-class SVMs were easily
able to separate the classes. The weighted confusion matrices can be seen in
Figure \ref{fig:05_in_depth_svm_conf_mats_unbalanced_classes5}. The
precision-recall plot can be seen in the appendix (Figure
\ref{fig:appendix_in_depth_svm_classes5}) as it does not convey much useful
information due to the good performance of the SVMs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced_classes5}
    \caption{Weighted confusion matrices of the balanced and unbalanced 5-class
    SVMs.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced_classes5}
\end{figure}
<!-- prettier-ignore-end -->

### 50-class SVM Hyperparameter Analysis

Similarly to the 5-class SVMs, the 50-class SVMs performed very well with a
minimum $F_1$-score of 0.955, a median of 0.974, and a maximum of 0.989.

The precision-recall plot can be seen in the appendix (Figure
\ref{fig:appendix_in_depth_svm_classes50}) as it does not convey much useful
information due to the good performance of the SVMs. The regularisation
coefficient C has minimal impact on the $F_1$-score and whether or not the
influence of each class was balanced has little impact on the $F_1$-score.

The weighted confusion matrices for the 50-class SVMs can be seen in Figure
\ref{fig:05_in_depth_svm_conf_mats_unbalanced_classes50}. Both the balanced and
unbalanced SVMs have a slight bias towards mispredicting the orientation of a
gestures (as can be seen by the diagonals adjacent to the principle diagonal)
but otherwise show very good performance.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced_classes50}
    \caption{Weighted confusion matrices of the balanced and unbalanced 50-class
    SVMs.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced_classes50}
\end{figure}
<!-- prettier-ignore-end -->

### 51-class SVM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_svm_classes51} shows how the regularisation
parameter C and whether or not the observations were weighted by their classes
frequency impacts the precision, recall, and $F_1$-score of the 51-class SVMs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_svm_classes51}
    \caption{Left: precision and recall of all 51-class SVMs, with the
    regularisation parameter C and class weighting mapped to the colour and
    marker type respectively. Right: The regularisation parameter C plotted
    against the $F_1$-score of each SVM, with the class weight indicated by the
    marker shape.}
    \label{fig:05_in_depth_svm_classes51}
\end{figure}
<!-- prettier-ignore-end -->

There are two clear clusters caused by the class weight hyperparameter. This
hyperparameter determines whether or not each observation is weighted based on
the frequency of its class. Both unbalanced and balanced class weights lead to
approximately the same $F_1$-score, but dramatically different precision and
recall values. Balanced class weights (where the minority classes have greater
weighting than the majority class) have higher recall but lower precision than
unbalanced class weights (where all observations are equally weighted).

The regularisation parameter C has only a small effect on the $F_1$-score, with
values below $10^{-4}$ consistently resulting in a decreased $F_1$-score. This
effect is independent of class weighting.

To investigate these clusters relating to the class weight hyperparameter,
Figure \ref{fig:05_in_depth_svm_conf_mats_unbalanced_classes51} shows the mean
confusion matrix for both balanced and unbalanced SVMs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced_classes51}
    \caption{Confusion matrices for SVMs with unbalanced (left) and balanced
    (right) class weights.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced_classes51}
\end{figure}
<!-- prettier-ignore-end -->

One can see that both the balanced and unbalanced SVMs do fairly well by the
strong diagonal through the plots. However, note that the balanced class weight
SVMs generally predict many non-50 classes as belonging to class 50 (as can be
seen by the column on the far right of the plot). This type of
misclassification leads to low precision, as the model is over-predicting for
all of the gesture classes.

In a complementary manner, the SVMs with unbalanced class weights frequently
mispredict observations belonging to class 50 as belonging to one of the other
gesture classes (as can be seen by the strong row at the bottom of the plot).
This type of misclassification leads to low recall, as the model is frequently
failing to correctly predict correctly for class 50.

Figure \ref{fig:05_in_depth_svm_prf1_plots_unbalanced} shows the per-class
precision, recall, and $F_1$-score for balanced and unbalanced class weight
SVMs. It is clear that the balanced SVMs have higher recall and that unbalanced
SVMs have higher precision.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_prf1_plots_unbalanced}
    \caption{Per-class precision, recall, and $F_1$-score for balanced and
    unbalanced class weight SVMs.}
    \label{fig:05_in_depth_svm_prf1_plots_unbalanced}
\end{figure}
<!-- prettier-ignore-end -->

Note that the balanced and unbalanced SVMs are approximately complementary in
their mistakes: the balanced SVMs predict too many observations as belonging to
class 50, and the unbalanced SVMs predict too _few_ observations as belonging
to class 50.

Figure \ref{fig:05_svm_hpars_vs_fit_time} depicts the training and the
inference time for 51-class SVMs against the hyperparameters C and the class
weight.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_svm_hpars_vs_fit_time}
    \caption{Left: Fit times against regularisation parameter C for all SVMs
    trained on 51 classes. Right: Inference time against regularisation
    parameter C. Whether or not the observation weights were adjusted is
    indicated by the marker type.}
    \label{fig:05_svm_hpars_vs_fit_time}
\end{figure}
<!-- prettier-ignore-end -->

As the regularisation parameter C increases, the amount of time required to fit
the SVM increases to a plateau and then remains constant. The rate of increase
and the fit time at the plateau are both higher for balanced SVMs than for
unbalanced SVMs. This follows from the extra computation required to calculate
and apply a weight to every observation.

There is no relationship between the inference time and the class weight nor
the inference time and the regularisation coefficient C. This is to be
expected, as neither hyperparameter is used to perform inference.

## Feed-forward Neural Networks \label{in-depth-ffnn}

Due to the large number of hyperparameters for FFNNs, plots which show no
relationship between hyperparameters and evaluation metrics will be excluded
from this chapter. Unabridged figures with all hyperparameters have been placed
in the Appendix and will be mentioned should the interested reader wish to view
them, although they will not be necessary for the discussion.

Figure \ref{fig:05_mean_conf_mat_ffnn} shows the mean confidence matrices for
all FFNNs trained on 5, 50, and 51 classes, weighted by that model's
$F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_mean_conf_mat_ffnn}
    \caption{The weighted confusion matrices of three FFNN classifiers, trained
    on 5, 50, and 51 classes. The confusion matrices are weighted by the
    $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the FFNNs, with each colour
    representing the FFNNs trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_ffnn}
\end{figure}
<!-- prettier-ignore-end -->

The weighted confusion matrix for FFNNs trained to classify only 5 classes
shows very good performance with little bias in its mispredictions.

The weighted confusion matrix for 50 classes also shows very good performance,
however there is a bias in its mispredictions as shown by the two diagonals
adjacent to the principle diagonal. These two diagonals are offset from the
principle diagonal by exactly 10 classes, indicating they are gestures where
the models mispredicted the orientation of the gesture but correctly predicted
the finger of the gesture. For example, predicting a gesture made with the
right hand's index finger at $0^\circ$ (gesture index 6) when the actual
gesture was made with the right hand's index finger at $45^\circ$ (gesture
index 16).

The confusion matrix for the FFNNs trained on 51 classes shows a strong
principle diagonal. It also shows mispredictions where class 50 was classified
as one of the other classes $0, 1, \ldots, 49$ as represented by the row at the
bottom of the confusion matrix. There are also a number of mispredictions where
one of the classes $0, 1, \ldots, 49$ were classified as class 50, represented
by the column at the right of the confusion matrix. There are relatively few
mispredictions where one gesture class was mispredict as another gesture class.

The precision-recall plot for these FFNNs shows that all FFNNs have a large
variance in their performance with standard deviations of the $F_1$-score of
0.395, 0.411, and 0.306 for the 5-, 50-, and 51-class models respectively. The
maximum performance of the models was 1, 0.997, and 0.772 for the 5-, 50-, and
51-class models respectively.

### 5-class FFNN Hyperparameter Analysis

For 5-class FFNN, the following hyperparameters showed no significant
relationship with the model's $F_1$-score: dropout rate, L2 coefficient, batch
size, number of layers, and the number of nodes in any layer. Interested
readers are referred to Figure \ref{fig:appendix_ffnn_hpar_analyis_classes5}
for unabridged plot of these hyperparameters.

Figure \ref{fig:05_hpar_analysis_ffnn_classes5_lr} shows the learning rate of the
5-class FFNNs against the model's validation loss and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes5_lr}
    \caption{The learning rate of the 5-class FFNNs against their $F_1$-score
    (left) and validation loss (right).}
    \label{fig:05_hpar_analysis_ffnn_classes5_lr}
\end{figure}
<!-- prettier-ignore-end -->

It is clear that a learning rate outside of the range $[10^{-4}, 10^{-1.5}]$ is
either too large or too small for the FFNN to learn the data at all, as models
with learning rates outside of this range resulted in very high validation loss
and very low $F_1$-scores. The validation-loss vs learning rate plot makes it
clear that while being outside of the range $[10^{-4}, 10^{-1.5}]$ makes
learning the dataset extremely unlikely, being within the aforementioned range
does not guarantee that the model will learn. The range $[10^{-4}, 10^{-1.5}]$
is necessary but not sufficient for a 5-class FFNN to perform well on the
validation dataset.

### 50-class FFNN Hyperparameter Analysis

For 50-class FFNN, the following hyperparameters showed no significant
relationship with the model's $F_1$-score: dropout rate, L2 coefficient, batch
size, and the number of nodes per layer. Interested readers are referred to
Figure \ref{fig:appendix_ffnn_hpar_analyis_classes50} for unabridged plot of
these hyperparameters.

Figure \ref{fig:05_hpar_analysis_ffnn_classes50_lr} shows the learning rate of the
50-class FFNNs against the model's validation loss and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_lr}
    \caption{The learning rate of the 50-class FFNNs against their $F_1$-score
    (left) and validation loss (right).}
    \label{fig:05_hpar_analysis_ffnn_classes50_lr}
\end{figure}
<!-- prettier-ignore-end -->

As with the 5-class FFNNs, there is a clear range of learning rates
$[10^{-3.5}, 10^{-1.5}]$ with improved $F_1$-scores and validation losses. This
range is approximately the same for the 50-class FFNNs as it was for the
5-class FFNNs, indicating that it is dependant on the dataset as opposed to the
model architecture. Once again, it's important to note that models with
learning rates outside of this range were unlikely to fit the data, but even
models within this range didn't have a guarantee of fitting the data
successfully. Having a learning rate within the range of $[10^{-3.5},
10^{-1.5}]$ is necessary but not by itself sufficient for achieving good
performance in a 50-class model.

In addition to the learning rate, the number of layers in the 50-class network
has an impact on the performance of the respective FFNN. Figure
\ref{fig:05_hpar_analysis_ffnn_classes50_nlayers} shows the number of layers in
the 50-class FFNNs against the model's validation loss and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_nlayers}
    \caption{The number of layers in the 50-class FFNNs against their
    $F_1$-score (left) and validation loss (right).}
    \label{fig:05_hpar_analysis_ffnn_classes50_nlayers}
\end{figure}
<!-- prettier-ignore-end -->

Models with one, two, or three layers were all able to learn the data and
achieve a high $F_1$-score, however this was more frequent with models with one
or two layers. Models with three layers were also unable to achieve a
validation loss as low as some of the models with one or two layers. This is
likely due to the increased complexity of the additional layer.

### 51-class FFNN Hyperparameter Analysis

<!---                       precision-recall density per nlayers           --->

Figure \ref{fig:05_51ffnn,x=p,y=r,c=nlayers,histplot} shows three
precision-recall plots, one for each of the 1-, 2-, and 3-layer FFNNs, where
the colour of each cell represents the number of FFNNs with that combination of
precision and recall.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=p,y=r,c=nlayers,histplot}}
    \caption{Caption here}
    \label{fig:05_51ffnn,x=p,y=r,c=nlayers,histplot}
\end{figure}
<!-- prettier-ignore-end -->

The 1-layer FFNNs have the greatest number of high-performing FFNNs, followed
by the 2- and then the 3-layer FFNNs. The vast majority of 3-layer FFNNs did
not manage to fit to the data, achieving nearly zero precision and recall.

<!---                       Number of layers                           --->

Figure \ref{fig:05_51ffnn,x=p,y=r,h=nlayers} shows the precision-recall plot
for all 51-class FFNNs, coloured based on the number of layers of each FFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_51ffnn,x=p,y=r,h=nlayers}
    \caption{Precision recall plot for all 51-class FFNNs, with the colour of
    the markers based on the number of layers in that FFNN.}
    \label{fig:05_51ffnn,x=p,y=r,h=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

There are many 1- and 2-layer FFNNs which achieve (or nearly achieve) the
maximum $F_1$-score. As the best $F_1$-score (0.772) is not significantly
better than the second-best $F_1$-score (0.767), it is unlikely that further
exploration of the hyperparameter space would result in significantly better
performance. If the best $F_1$-score were significantly better than the
second-best $F_1$-score, then it might be possible to explore the
hyperparameter space around the best $F_1$-score to find a slightly better
combination of hyperparameters. However, this is not the case, and the
proximity of the best and runner up $F_1$-scores indicates that the search
space around the best found $F_1$-score has been well-searched.

There is a cluster of high-performing FFNNs around a recall of 0.8 and a
precision of 0.6. It might be assumed that this cluster is a result of one
hyperparameter being in the correct range of values, however this is not the
case.

Figure \ref{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70} shows a set of
plots, with one plot for each hyperparameter for 51-class FFNNs.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_51ffnn,c=hpar,x=hpar,y=recall>70}
    \caption{Set of violin/strip plots with hyperparameter value on the x,
    recall>0.7 on the y. It shows that there is no hyperparameter range which
    causes good performance, only those which are necessary but not
    sufficient.}
    \label{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70}
\end{figure}
<!-- prettier-ignore-end -->

The colour of each point informs whether it's recall is greater than 0.7. If
there were a hyperparameter which could result in a FFNN with a recall greater
than 0.7, then one would expect the plot for that hyperparameter to contain a
range where the vast majority of FFNNs have a recall greater than 0.7 and very
few FFNNs with a recall less than 0.7. However this is not the case. There do
appear to be a few hyperparameters which are necessary for a FFNN to achieve a
recall greater than 0.7 (learning rate, number of nodes in the first layer, the
number of layers). However there are no hyperparameters which are _sufficient_
for a FFNN to achieve a recall greater than 0.7.

<!---                       LR vs npl1                           --->

Figure \ref{fig:05_51ffnn_x=lr,y=npl1,h=f1} shows the learning rate of all
51-class FFNNs against the number of nodes in layer 1, with the colour of each
point indicating the validation $F_1$-score of that FFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_51ffnn_x=lr,y=npl1,h=f1}
    \caption{The learning rate against the number of nodes in the first layer
    of all 51-class FFNNs. Note that a small amount of random noise has been
    applied to the hyperparameters (but not the $F_1$-score). As each set of
    hyperparameters was trained five times, this prevents five points (which
    have identical hyperparameters) being plotted directly on top of one
    another.}
    \label{fig:05_51ffnn_x=lr,y=npl1,h=f1}
\end{figure}
<!-- prettier-ignore-end -->

One can see a "V" shape of high-$F_1$-scoring FFNNs. This indicates that FFNNs
with a smaller number of nodes in their first layer require the learning rate
to be in a more precise range of values when compared to FFNNs with a larger
number of nodes in the first layer.

It can also be seen that FFNNs with more nodes in their first layer were more
likely to have a higher recall than FFNNs with fewer nodes, so long as the
learning rate was in the required range. FFNNs with a recall greater than 0.74
generally had more than 31 ($10^{1.5}$) nodes in their first layer and had a
learning rate in the range $[10^{-4}, 10^{-3}]$.

<!---                    precision-recall hue=nlayers                      --->

Figure \ref{fig:05_51ffnn,x=p,y=r,h=nlayers} showed that the cluster of
performant FFNNs with a recall greater than 0.7 contains FFNNs with 1-, 2-, and
3-layers. To analyse this cluster of performant FFNNs, Figure
\ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} plots the precision and recall for
1-, 2-, and 3-layer FFNNs, with the colour of the point indicating the learning
rate.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_51ffnn,x=p,y=r,h=lr,c=nlayers}
    \caption{todo}
    \label{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

For FFNNs with the same number of layers, the precision-recall plots generally
form tight clusters of similarly performant FFNNs.

The 1-layer FFNNs generally required a learning rate in the range $[10^{-2.5},
10^{-4.5}]$ in order to achieve a high $F_1$-score, although a learning rate
in this range did not guarantee a high $F_1$-score.

Looking at the 2-layer FFNNs with a recall greater than 0.7, there are two
clusters in the precision-recall plot. The one cluster has a learning rate in
the narrow range of $[10^{-4.75}, 10^{-3.75}]$, and the other cluster has a
learning rate either significantly greater (around $10^{-5}$) or significantly
lower (around $10^{-2.75}$) than the first. The learning rate of the 2-layer
FFNNs has a large impact on the $F_1$-score of the 2-layer FFNNs, and a
learning rate outside of the range $[10^{-4.75}, 10^{-3.75}]$ is likely to
result in poor performance.

The 3-layer FFNNs have a similar range of values for the learning rate which
result in good performance: $[10^{-4}, 10^{-3}]$. There is no bimodality as was
seen in the 2-layer FFNNs. The 3-layer FFNNs achieve a higher recall (0.933)
than the 1-layer (0.865) and the 2-layer (0.921) FFNNs, although their
$F_1$-score is worse (0.742 for the 3-layer FFNNs, compared against 0.772 for
the 1-layer FFNNs and 0.739 for the 2-layer FFNNs). It should be noted that as
the number of layers increased, the median $F_1$-score decreased substantially
(0.593 for 1-layer, 0.197 for 2-layer, and 0.019 for 3-layer FFNNs) due to an
increasing number of FFNNs which were failing to learn as the number of layers
increased.

It is possible that the ranges of hyperparameters for which 2- and 3-layer
FFNNs can successfully learn the data is outside of the ranges selected for
experimentation. If the optimal hyperparameter values are close enough to the
existing bounds for the hyperparameter ranges, then one would expect to see
optimal performance when the hyperparameters are on this bound. However, this
is not the case, <!-- TODO: Figures to back this point up --> and it is
therefore likely that the FFNNs with 2 and 3 layers are less efficient at using
the fixed computational budget to learn the dataset.

<!---       learning rate vs f1-score and number of nodes in last layer               --->

Figure \ref{fig:05_51ffnn,x=lr,y=npl-1,h=f1,c=nlayers} shows the learning rate
and the number of nodes in the last layer of the 1-, 2-, and 3-layer FFNNs,
with the point's colour indicating the $F_1$-score of the FFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=lr,y=npl-1,h=f1,c=nlayers}
    \caption{todo}
    \label{fig:05_51ffnn,x=lr,y=npl-1,h=f1,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

From this figure the impact of the learning rate and the number of nodes in the
last layer is clear. If the learning rate is in the correct range, then
increasing the number of nodes in the last layer of the FFNN very frequently
resulted in an improvement in the $F_1$-score. Indeed, there are very few
instances where the best performing model for a given learning rate is not also
the model with the greatest number of nodes in its last layer.

<!---                       Nodes per layer 1/2/3 vs F_1                      --->

Figure \ref{fig:05_51ffnn,x=npl1,y=npl2,h=f1,c=nlayers} shows the number of
nodes in each layer against the $F_1$-score of the 51-class FFNNs with 1, 2,
and 3 layers.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_51ffnn,x=npl1,y=npl2,h=f1,c=nlayers}
    \caption{caption todo}
    \label{fig:05_51ffnn,x=npl1,y=npl2,h=f1,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

For the 1-layer FFNNs, one can see that increasing the number of nodes in the
singular layer generally improves performance, although the number of nodes in
the singular layer is not the sole cause of good performance.

This trend is largely continued with the 2-layer FFNNs. One can see that the
majority of performant FFNNs had many nodes in both layer one and in layer two.
There are several instances of FFNNs with many nodes in layer 1 but few in
layer 2, or many nodes in layer 2 but few nodes in layer 1; these FFNNs mostly
did not perform well.

It is likely that this trend of more nodes resulting in better performance
would not continue without bound. The range for the number of nodes in layers
one and two were likely too stringent, and a higher bound should have been
imposed, allowing for FFNNs with more nodes in their first and second layers.

The 3-layer FFNNs are trickier to analyse due to the number of layers. Overall,
there are fewer performant FFNNs with three layers than there were with one or
two layers. Looking at the plot of the number of nodes in layer 1 against the
number of nodes in layer 2, there is a negatively-sloped region from the top
left to the bottom right of the plot which contains a disproportionate number
of the high-$F_1$-score FFNNs. This indicates that 3-layer FFNNs with too many
or too few nodes in _either_ their first or second layer do not perform well.
An increase in the number of nodes in the first layer will reduce the
performance of a 3-layer model if there is not a commensurate decrease in the
number of nodes in the second layer. There is a similar pattern in the plot
describing the number of nodes in the second and third layer for 3-layer FFNNs,
where the number of nodes in layer three can only be high if the nodes in layer
2 is low, and vice versa.

This would imply that the performant 3-layer FFNNs trace a line through the
3-dimensional hyperparameter space that has the number of nodes per layer as
it's dimensions. This line would go from the point of many nodes in layers 1
and 3 with few nodes in layer 2 to the point of few nodes in layers 1 and 3
with many nodes in layer 2.

This hypothesis is backed up by the 3 dimensional plot in Figure
\ref{fig:05_51ffnn,x=npl1,y=npl2,z=npl3,h=f1} which shows all the 3-layer
FFNNs.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_51ffnn,x=npl1,y=npl2,z=npl3,h=f1}
    \caption{All 51-class 3-layer FFNNs with the number of nodes in each layer
    assigned to the x, y, and z axis. The colour of each point represent the
    $F_1$-score of that FFNN.}
    \label{fig:05_51ffnn,x=npl1,y=npl2,z=npl3,h=f1}
\end{figure}
<!-- prettier-ignore-end -->

The plot has been oriented so that the line of performant FFNNs is
orthogonal to the camera viewport. One can see that the performant FFNNs are
clustered in the centre of the 3D plot, with the low-$F_1$-score FFNNs
surrounding them.

This narrow line of performant 3-layer FFNNs is in contrast to what was seen
with the 1- and 2-layer FFNNs where so long as the number of nodes was above
some threshold, the performance would be good. This reinforces the hypothesis
that the upper bound chosen for the number of nodes in each layer was too low,
and that increasing this bound would have seen the performance possibly
increase before reducing as the number of nodes became too great.

<!---                       Regularisation                      --->

Figure \ref{fig:05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers} shows the dropout rate
against the $F_1$-score for the 1-, 2-, and 3-layer FFNNs, with the colour of
each point indicating the L2 coefficient.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers}}
    \caption{Caption here}
    \label{fig:05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

The dropout rate has little to no effect on the 1-layer FFNNs, while the 2- and
3-layer FFNNs generally benefit from a low dropout rate. For the 2- and 3-layer
FFNNs, a low dropout rate was not the sole factor which resulted in a high
$F_1$-score, however having a high dropout rate rarely resulted in high
$F_1$-scores. The L2 coefficient had little impact on the $F_1$-scores of any
of the FFNNs, with no range of L2 coefficient showing superior performance.

Figure \ref{fig:05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers} shows the
dropout rate against the number of nodes in the last layer for the 1-, 2-, and
3-layer FFNNs, with the colour of each point indicating the $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers}}
    \caption{Caption here}
    \label{fig:05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

Since increasing the dropout rate has the effect of suppressing the output of a
random subset of nodes in each layer, one might expect that FFNNs with a high
dropout rate would require a large number of nodes in order to achieve good
performance. This can be seen to some extent in the plot for 1-layer FFNNs, in
which FFNNs with a low dropout rate only achieve a high $F_1$-score if they
also have a low number of nodes in their singular layer. There are no 1-layer
FFNNs which simultaneously have a high dropout rate, few nodes in their
singular layer, and a high $F_1$-score. One can see that an increase in the
dropout rate usually requires an increase in the number of nodes in the
singular layer for the FFNN to maintain a high $F_1$-score.

The 2- and 3-layer FFNNs both show behaviour whereby a FFNN performs well if it
has a low dropout rate and a high number of nodes in its final layer. This
behaviour is less distinct for the 3-layer FFNNs, which is to be expected as
the extra layer introduces more complexity into its performance characteristics.

## Hierarchical Feed Forward Neural Networks \label{in-depth-hffnn}

<!-- TODO do a proper hpar analysis here -->

As with the FFNNs, the HFFNNs have many hyperparameters. Plots which show no
relationship between hyperparameters and evaluation metrics will be excluded
from this chapter. Unabridged figures with all hyperparameters have been placed
in the Appendix and will be mentioned should the interested reader wish to view
them, although they will not be necessary for the discussion.

Figure \ref{fig:05_mean_conf_mat_hffnn} shows the confusion matrices for HFFNN
models trained on 51 classes. HFFNNs were not trained on 5 or 50 classes, as
that is equivalent to training a FFNN on 5 or 50 classes. The values in the
confusion matrices are the weighted mean of all HFFNN, based on the $F_1$-score
of each HFFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_mean_conf_mat_hffnn}
    \caption{The weighted confusion matrices of three HFFNN classifiers,
    trained on 5, 50, and 51 classes. The confusion matrices are weighted by
    the $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the CuSUM, with each colour
    representing the CuSUM trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_hffnn}
\end{figure}
<!-- prettier-ignore-end -->

HFFNNs perform well, however there are faint offset diagonals showing a
tendency to mispredict the orientation of a gesture. There are also a large
number of misclassifications where class 50 was predicted as one of the other
gesture classes. This type of misclassification lowers the precision of the
models, as can be seen on the precision-recall plot in Figure
\ref{fig:05_mean_conf_mat_hffnn}.

The HFFNN is made up of two FFNNs. The first FFNN, which is a binary classifier
that detects if a gesture is present in an observation, is called the majority
classifier as it detects the majority class, class 50. The other classifier is
called the minority classifier, as it distinguishes between the remaining
minority classes.

### 51-class HFFNN Hyperparameter Analysis

<!--- TODO
Currently the "perfect" decision rules first achieve perfect recall and then
try achieve perfect precision.

- Try make a perfect set of decision rules which first achieve perfect
  precision and then achieve perfect recall.

Also look at a decision rule that first splits by number of layers and then
splits by other values.
-->

<!-- TODO: Distribution of the hyperparameters [plots thereof] -->

# Which model performs the best with 51 classes? \label{best-model}

The performance of each of the five classification algorithms can be seen in
Figure \ref{fig:05_precision_recall_51_classes} (for those models trained on
all 51 classes).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_precision_recall_51_classes}
    \caption{ Left: precision and recall for all model types trained on the
    full 51 classes, with the contours depicting the $F_1$-scores for those
    models. Right: The $F_1$-scores for the same models, shown side-by-side for
    easier comparison. }
    \label{fig:05_precision_recall_51_classes}
\end{figure}
<!-- prettier-ignore-end -->

From these plots we can see that SVMs, FFNNs, and HFFNNs perform competitively.
HMMs achieve high recall but struggle with precision, and CuSUM similarly
achieves much higher recall than precision.

The two neural network based models (FFNN and HFFNN) perform similarly as is to
be expected from their similar architecture, however the two-model HFFNN
largely performed worse than the single model FFNN. This is likely due to the
HFFNN having a larger number of hyperparameters to tune, resulting in a model
which is more prone to overfitting. These neural network-based models exhibit a
notably larger and denser hyperparameter space in comparison to the relatively
constrained hyperparameter space explored for SVMs, HMMs, or CuSUM,
contributing to the observed variance in their performance

The CuSUM models show predictably poor performance, as the model largely serves
as a speed comparison.

The HMMs show four clusters, all with very poor precision but varying recall,
corresponding to the four covariance types.

High recall on the _Ergo_ dataset means that many of the minority class
observations get correctly predicted. High precision on the _Ergo_ dataset
means that many very few of the majority class observations get predicted as
belonging to one of the minority classes.

Therefore, high recall implies good performance when identifying minority
classes, and high precision implies good performance when identifying the
majority class. Low performance implies that there are instances of the
majority class which are incorrectly classified as belonging to a minority
class. This would happen if a model "extended" its predictions such that
timesteps $t, t+1, t+2$ are all predicted as belonging to the same minority
class even though only timestep $t$ actually belonged to that minority class.
This asymmetry between minority/majority classes and precision/recall is a
consequence of the uniform class weighting used for calculating $F_1$, recall,
and precision.

<!--
> This would happen if a model "extended" its predictions such that
> timesteps $t, t+1, t+2$ are all predicted as belonging to the same minority
> class even though only timestep $t$ actually belonged to that minority class.

TODO: This needs to be highlighted with an experiment or with results....
-->

Each set of hyperparameters for each model type was trained and evaluated on
five different subsets of the data, resulting in five different validation sets
and five different training sets for each hyperparameter combination. The
individual performances of all training runs are shown as points in Figure
\ref{fig:05_hpar_comparison_per_model_type}. The black horizontal bars indicate
the mean of each set of hyperparameters. Note that, for model types with
discrete hyperparameters, some sets of hyperparameters were evaluated more than
five times.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_comparison_per_model_type}
    \caption{$F_1$-score for each model type on each set of hyperparameters
    that were tested. The hyperparameter index is a unique number assigned to
    each set of hyperparameter-model type combinations. The black horizontal
    bar indicates the mean $F_1$-score for one set of hyperparameters, and the
    hyperparameters are ordered by the lower bound of the 90\% confidence
    interval.}
    \label{fig:05_hpar_comparison_per_model_type}
\end{figure}
<!-- prettier-ignore-end -->

To rank the distributions of $F_1$-scores for each set of hyperparameters, the
90% confidence interval for each set is calculated. The hyperparameter sets are
then ordered by the lower bound of this confidence interval. This ensures
that hyperparameter combinations with high variance in their performance are
penalised, as the lower bound of the 90% confidence interval will be smaller
for a high-variance model than for a low-variance model. Low-variance models
are desirable as their performance is less dependant on the data it is
evaluated on, which improves the chance that it will perform well on unseen
testing data.

One can clearly see from Figure \ref{fig:05_hpar_comparison_per_model_type}
that the FFNNs, the HFFNNs, and the SVMs all perform well. Figure
\ref{fig:05_best_hpar_comparison} shows the best performing 41 hyperparameters.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_best_hpar_comparison}
    \caption{Performance of hyperparameter combinations for the best performing
    41 hyperparameters. The black horizontal markers indicate the mean
    performance, and each dot indicates the performance on run.}
    \label{fig:05_best_hpar_comparison}
\end{figure}
<!-- prettier-ignore-end -->

It can be seen that the FFNNs are very prevalent amongst the best-performing
models. There are a few HFFNNs achieving good performance, and all SVMs
achieved approximately the same level of performance. The SVMs generally
performed worse than the neural network based models.

Given that the best 17 performing models are all FFNNs, it can be concluded
that well-tuned FFNNs perform the best on this dataset. It should be noted that
SVMs perform relatively well on the dataset, regardless of the hyperparameters
used. This is in start contrast to neural network based methods which
outperform SVMs, but only after extensive hyperparameter tuning has been
performed.

The best performing hyperparameter combinations for each model type can be seen
in tables
\ref{tab:05_best_ffnn_hpars} (FFNN),
\ref{tab:05_best_majority_hffnn_hpars} (Majority classifier of the HFFNN),
\ref{tab:05_best_minority_hffnn_hpars} (Minority classifier of the HFFNN),
\ref{tab:05_best_svm_hpars} (SVM),
\ref{tab:05_best_hmm_hpars} (HMM), and
\ref{tab:05_best_cusum_hpars} (CuSUM).

\input{src/tables/05_best_ffnn_hpars.tex}

\input{src/tables/05_best_majority_hffnn_hpars.tex}

\input{src/tables/05_best_minority_hffnn_hpars.tex}

\input{src/tables/05_best_svm_hpars.generated.tex}

\input{src/tables/05_best_hmm_hpars.generated.tex}

\input{src/tables/05_best_cusum_hpars.generated.tex}

# Comparison of the inference and training times for each model \label{time-comparison}

Raw performance is not the only metric of interest, as _Ergo_ requires
real-time prediction at a rate of 40 predictions per second. The inference and
training times for each model were recorded on the training and validation
dataset. This allows values to be calculated for the amount of time each model
takes to perform inference and to train, on both the training dataset and the
validation dataset.

There were significant technical problems with the Hidden Markov Models due to
the volume of observations being trained on. This necessitated that the HMMs be
trained on only 1000 randomly selected observations of the non-gesture class
(all other classes were trained on the full number of observations in the
training dataset). Even with this, the training times are significantly longer
than any other model. Figure \ref{fig:05_inf_trn_times_per_obs} shows the
training times and inference times per observation for each model on the
training and validation dataset.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_inf_trn_times_per_obs}
    \caption{Inference and fitting times for the validation and training
    datasets. Due to the range of the data, all axes are $\log_{10}$}
    \label{fig:05_inf_trn_times_per_obs}
\end{figure}
<!-- prettier-ignore-end -->

First the times taken to perform inference on the training and validation
dataset will be discussed. Afterwards, the relationship between the time taken
to train a model and the time it takes that model to perform inference will be
discussed. Finally, the relationship between training time and validation $F_1$
score will be discussed.

For real-time prediction, the model must be able to make at least 40
predictions per second, or one prediction every 0.025 seconds.

One can see from Figure \ref{fig:05_inf_trn_times_per_obs} that the Hidden
Markov Models take significantly longer to perform inference than the other
models, with some HMMs taking 0.08 seconds per observation. There are other
HMMs which take approximately 0.01 seconds per observation, however this is
still orders of magnitude slower than all Neural Networks and all Support
Vector Machines. CuSUM also takes a relatively long time to perform inference,
around 0.0015 seconds per observation. While this is not large in absolute
terms, it is much larger than the inference times for the neural network based
models and the SVMs.

The models chosen all perform approximately the same amount of computation
regardless of whether an observation has been seen before by the model, and
this is reflected in the strong correlation between inference times on the
training and validation datasets .

From the right plot in Figure \ref{fig:05_inf_trn_times_per_obs}, one can see
that the HMMs take orders of magnitude longer to fit to the data than other
model types. Some HMMs take around 0.04 seconds per observation to train, and
other HMMs take around 0.01 seconds per observation. This is in start contrast
to the FFNNs, HFFNNs, and SVMs which take an order of magnitude less time to
train, around 0.0025 seconds per observation

As already mentioned, HMMs are orders of magnitude slower than the FFNNs and
the SVMs but as Figure \ref{fig:05_inference_time_per_obs_vs_f1} makes this
very apparent.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_inference_time_per_obs_vs_f1}
    \caption{Inference time per observation for each model plotted against each
    models' $F_1$-score.}
    \label{fig:05_inference_time_per_obs_vs_f1}
\end{figure}
<!-- prettier-ignore-end -->

CuSUM also has slow inference times. This is likely due to the implementation
being written in the Python programming language. While the SVM, FFNN, and
HFFNN implementations each provide a Python interface, the majority of the
computational workload is executed in the C programming language.

For the SVMs, the FFNNs, and the HFFNNs, there is no significant correlation
between training times and $F_1$-score. This is to be expected, given the
learning mechanisms behind each model.

Regardless of the relative speed of each model, the absolute speed of every
SVM, FFNN, and HFFNN is more than sufficient for real-time prediction with
_Ergo_. The absolute speed of CuSUM is likely sufficient for _Ergo_, however
imposing additional workload on the relevant machine or running the software on less
performant hardware might cause problems. The HMMs are not fast enough for
real-time predictions, however a compromise might be made by only attempting
inference on every other timestep, thereby reducing the performance required at
the cost of a less responsive system.

# Comparison of the validation to training ratios for each model \label{ratio-comparison}

Figure \ref{fig:05_f1_vs_f1_ratio} shows the validation and training $F_1$
scores for every model trained all 51 classes. The ratio of a model's training
$F_1$-score to its validation $F_1$-score can be used as a heuristic for how much a model
is overfitting to the training data, as a model that performs very well on the
training dataset but very poorly on the validation dataset is likely to have
overfit on the data, and therefore is unlikely to perform well on unseen data.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_f1_vs_f1_ratio}
    \caption{$F_1$ ratio (training $F_1$ over validation $F_1$) for each model,
    coloured by the model type. Plots a and c show the full range of their
    data, while plots b and d show the same data but magnified on a subset of
    the data.}
    \label{fig:05_f1_vs_f1_ratio}
\end{figure}
<!-- prettier-ignore-end -->

<!--
TODO: High training f1 : low validation f1 does not imply overfitting.

Only if the validation loss starts to increase can we say that a model has
started to overfit

What the f1-ratio does indicate is that a change in the distribution (ie
validation set -> testing set) will likely cause a change in performance.
-->

The plots in the first column of Figure \ref{fig:05_f1_vs_f1_ratio} (plots a
and c) show the full range of the data, while the plots in the second column of
Figure \ref{fig:05_f1_vs_f1_ratio} (plots b and d) show a subset of the data
where the validation $F_1$-score is greater than 0.5.

One can see from plot a that the HMMs have a much higher training $F_1$-score
than their validation $F_1$; this is due to the training dataset for HMMs not
containing every observation of the non-gesture class, leading to inflated
training metrics. The validation set _does_ include every observation of the
non-gesture class, and so the validation $F_1$-score is an accurate depiction
of the model's performance.

At a high level, models which performed poorly ($F_1 < 0.5$) on the training
dataset also performed poorly on the validation dataset, as can be seen with the
$F_1$-ratio being near 1 for the majority of models with an $F_1$-score of less than
0.5 (plots a and c). Note that CuSUM performed very poorly with a median
validation $F_1$-score of 0.0307 and is obscured on the plots by other models.

Plots b and d highlights the region where $F_1 > 0.5$, showing several clusters
for SVM models and regions occupied by the two neural network based models:
FFNN and HFFNN. One can see that the training $F_1$-score is almost always higher
than the validation $F_1$, as would be expected from models with a capacity to
overfit to data that has been seen before.

The higher the $F_1$ ratio, the more probable it is that the model has overfit
to the training data (as it was unable to generalise its performance to the
validation data). In plots b and d, it can be seen that the SVMs tend to have a
higher $F_1$ ratio. However, plot b shows that (within certain clusters of
models) the training $F_1$-score of SVMs is largely uncorrelated with the
validation $F_1$-score.

A possible explanation is that the SVMs are easily finding local maxima of
performance on the training dataset. However, these local maxima do not
properly convert to good performance on the validation dataset.

<!-- TODO: ## Residual analysis of the best performing models -->

# English-language test data \label{real-world-data}

To evaluate the model on English-language typing data, the sensor measurements
were stored as the phrase "The quick brown fox jumped over the lazy dog" was
gestured. This stored phrase can then be fed to any model and that model's
predictions can be analysed. The predictions from the best-performing model are
shown in Figure \ref{fig:05_tqbfjotld}.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_tqbfjotld.png}
    \caption{Time series plot of the phrase "the quick brown fox jumped over
    the lazy dog" is typed.}
    \label{fig:05_tqbfjotld}
\end{figure}
<!-- prettier-ignore-end -->

<!-- TODO ## Evaluation of autocorrect -->
<!-- TODO ## Evaluation of end-to-end process -->

<!--
TODO: Clarify test set vs English dataset
-->

# Evaluation of Models on the test set \label{test-set-eval}

Figure \ref{fig:05_tst_set_conf_mat} shows confusion matrix and the per-class
$F_1$-score, precision, and recall for the best performing hyperparameters
(hyperparameter index 44).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_tst_set_conf_mat}
    \caption{Confusion matrix and per-class $F_1$-score, precision, and recall
    for the best-performing model on the unseen test data.}
    \label{fig:05_tst_set_conf_mat}
\end{figure}
<!-- prettier-ignore-end -->

The model performs well on the test set, with the majority of mispredictions
being between the non-gesture class and the gesture classes. The heatmap at the
bottom of Figure \ref{fig:05_tst_set_conf_mat} shows the per-class recall,
precision, and $F_1$-scores. Gesture classes 0, 19, and 45 performed worse than
the other gesture classes, although the cause is not readily apparent. Figure
\ref{fig:05_p_r_best_model} shows the precision and recall as a scatter plot
for each gesture.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_p_r_best_model}
    \caption{Precision and recall for all 51 classes, as classified on the test
    set by the most performant model.}
    \label{fig:05_p_r_best_model}
\end{figure}
<!-- prettier-ignore-end -->

It is clear that there is no systematic bias in the model against any gestures
and that the gestures for which the model performs poorly is due to the data,
not some bias inherent in the model.
