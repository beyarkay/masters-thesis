# Results

<!--
TODO or open questions:

- Note: report the accuracy when excluding class 50, as most of the literature
  does this. Discuss the difficulties of segmentation and how most of the
  literature does not attempt this.

- NOTE: have an explanation that precision/validation/f1 is always on the
  validation set unless otherwise noted.
-->

This chapter will discuss the results obtained from the experiments described
the Methodology chapter. The dataset will be described and some preliminary
analysis done in in Section \ref{dataset-description}. Section
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
Section \ref{ratio-comparison} examines the training and validation performance
of each model as a heuristic for that model's probability to overfit on the
training data and therefore perform poorly on unseen observations. Section
\ref{real-world-data} evaluates each model on a real-world dataset of
English-language typing data. Finally, Section \ref{test-set-eval} evaluates
the most performant model on the unseen test set.

## (Some things I'll cover in the Methodology chapter)

Hi Professor, this section will be removed, but I found there were a few times
where I needed to mention something but that thing was better mentioned in the
methodology chapter rather than the results chapter. So this section just has
some things which I'll write up in the methodology chapter, but which I thought
would be confusing to not acknowledge at all:

1. How do HMMs/CuSUM/SVMs go from binary classifiers to multi-class classifiers
1. How is hyperparameter optimisation done?
1. How are the models evaluated based on recall/precision/f1-score?
1. What is macro/micro/weighted f1 score and why is macro f1-score used?
1. What does _Ergo_ look like? Where are the sensors places?
1. Discussion about why the HMMs couldn't be trained on every training
   observation but could be evaluated on every validation observation.
1. Each set of hyperparameters has 5 repetitions

## Dataset Description

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
during which the user's hands may be still, or may be moving from the end of
one gesture to the start of the next gesture. The 50 gesture classes are
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_sensors_over_time_3230_30}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_sensors_over_time_3230_3200}
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
about 97.6% the non-gesture class, with the remaining 2.4% divided
approximately evenly between the 50 gesture classes.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_class_imbalance}
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

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_example_g0011_plot}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pca_plot}
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

## Comparison of hypothetical models

In this section, several hypothetical models are be defined and their performance
examined. These hypothetical models have been chosen so as to provide
some intuition about common pitfalls encountered by real models.

Figure \ref{fig:05_pr_conf_mat_random_preds} shows the precision-recall graph
and confusion matrix of a classifier that predicts every observation according
to a uniform random distribution.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_random_preds}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_only_50}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_wrong_orientation}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_wrong_finger_correct_hand}
    \caption{Precision-recall graph and confusion matrix of a classifier that
    correctly predicts the orientation and hand being used for a gesture, but
    incorrectly predicts the finger being used.}
    \label{fig:05_pr_conf_mat_wrong_finger_correct_hand}
\end{figure}
<!-- prettier-ignore-end -->

## Evaluated Classification Algorithms \label{model-justification}

Several different classification algorithms were evaluated. The chosen
classification algorithms were selected based on how well suited they are to a
high dimensional multi-class classification problem, as well as their
prevalence in the gesture classification literature (such that comparisons may
be made between prior work and the current work).

Feed-forward Neural Networks (FFNNs) scale well as the number of classes
increases (see Figure \ref{fig:05_inf_time_vs_num_classes}). To scale a FFNN to
classify a greater number of classes, one needs to (at least) increase the
number of output neurons and retrain the entire network. This is favourable
when compared to an algorithms that requires one classifier to be trained per
class, in which case both the inference time and the training time increases
approximately linearly with the number of classes. While one-vs-rest
classification is suitable for few classes, it quickly becomes unwieldy for as
the number of classes increases.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inf_time_vs_num_classes}
    \caption{Inference times for each observation increases as the number of
    classes increase for HMMs and CuSUM, but that is not the case for SVMs and
    FFNNs. HFFNNs are not shown as they are not trained on fewer than 51
    classes.}
    \label{fig:05_inf_time_vs_num_classes}
\end{figure}
<!-- prettier-ignore-end -->

Hidden Markov Models (HMMs) have frequently been used in the literature for
gesture detection and classification. While training and inference times
scale approximately linearly with the number of classes, they do explicitly
model time and have shown promise in previous works. Their implementation will
allow for a better comparison between the current and prior work.

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

## Discussion of each model

This section will explore each of the models in depth, but will not make
comparisons between different model types. Characteristics specific to each
model type are discussed, relating to $F_1$-score, precision, recall, inference
times, and training times. Where appropriate, confusion matrices of different
models are visualised to aid with the analysis of these models. For inter-model
comparisons, please see sections \ref{best-model} and \ref{time-comparison}.

FFNNs are be discussed in section \ref{in-depth-ffnn}, HMMs in section
\ref{in-depth-hmm}, CuSUMs in section \ref{in-depth-cusum}, HFFNNs in section
\ref{in-depth-hffnn}, and SVMs in section \ref{in-depth-svm}.

### Feed-forward Neural Networks \label{in-depth-ffnn}

Figure \ref{fig:05_in_depth_ffnn_p_vs_r} depicts the precision and recall of
all FFNN models trained on 51 classes. A clear cluster is visible in in the
recall of these FFNN models, centred around a recall of about 0.8.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_in_depth_ffnn_p_vs_r}
    \caption{Precision-recall plot for all FFNNs trained on 51 classes, with
    the models' $F_1$-scores as contours in grey.}
    \label{fig:05_in_depth_ffnn_p_vs_r}
\end{figure}
<!-- prettier-ignore-end -->

To investigate this cluster, Figure \ref{fig:05_in_depth_ffnn_hpars_vs_recall}
shows the recall of all models trained on the full dataset of 51 classes
against the hyperparameters for the FFNNs: the dropout rate, the L2
coefficient, the batch size, the learning rate, the number of layers, and the
nodes in each layer. Several FFNNs had a validation loss much larger than the
training loss. These models have been omitted from the analysis. Figure
\ref{fig:05_in_depth_ffnn_hpars_vs_recall} shows that a learning rate between
$10^{-4.5}$ and $10^{-3}$ often leads to a higher recall.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_ffnn_hpars_vs_recall.pdf}
    \caption{Hyperparameters for FFNNs trained on 51 classes, compared against
    their recall. Note that some hyperparameters were sampled from a
    $\log_{10}$ distribution and are therefore plotted over that same
    distribution.}
    \label{fig:05_in_depth_ffnn_hpars_vs_recall}
\end{figure}
<!-- prettier-ignore-end -->

Figure\ref{fig:05_mean_conf_mat_ffnn} shows the mean confidence matrices for
all FFNNs trained on 5, 50, and 51 classes, weighted by that model's $F_1$
score and normalized across the entire matrix so the maximum value is 1.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_ffnn}
    \caption{The weighted confusion matrices of FFNNs, weighted by the model's
    $F_1$-score and normalized to make the maximum value in the confusion
    matrix be 1. Note that the bottom right cell of the 51-class confusion
    matrix has to be set to zero, as class 50 has such a significant majority
    so as to make the confusion matrix uninformative.}
    \label{fig:05_mean_conf_mat_ffnn}
\end{figure}
<!-- prettier-ignore-end -->

Looking at the mean confidence matrix for 5 and 50 gesture classes, one can see
that FFNNs do not struggle when distinguishing the different gesture classes.
When there are 50 gesture classes, FFNNs will occasionally incorrectly predict
the orientation of a gesture (as can be seen by the weak off-centre diagonals
in the confusion matrix for 50 gesture classes). Beyond that, mispredictions
are evenly distributed.

The rightmost plot of Figure \ref{fig:05_mean_conf_mat_ffnn} shows the weighted
mean of all confusion matrices for FFNNs trained on 51 classes. This includes
the non-gesture class, class 50.

There are three types of mistakes made by these FFNNs: predicting that an
observation of a gesture class belongs to class 50 (as seen by the strong
column on the far right of the plot). The second mistake is predicting that an
observation which does not contain a gesture actually contains a gesture (as
seen by the strong row at the bottom of the plot). The final mistake is
predicting one gesture as being another gesture (as seen by the various other
cells in the plot).

It is clear from these plots that while distinguishing the different gestures
is an achievable task, distinguishing gestures from non-gestures is much
trickier. The FFNNs show a small bias in how they mispredict the orientation of
a gesture.

### Hidden Markov Models \label{in-depth-hmm}

Figure \ref{fig:05_in_depth_hmm_p_vs_r_covar_type} shows the precision and
recall of all HMM models trained on all 51 classes.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_in_depth_hmm_p_vs_r_covar_type.pdf}
    \caption{Precision-recall plot for all HMMs trained on 51 classes, with
    the models' $F_1$-scores as contours in grey. Note that the scales of the
    axes have been adjusted to better show the distribution of the data.}
    \label{fig:05_in_depth_hmm_p_vs_r_covar_type}
\end{figure}
<!-- prettier-ignore-end -->

Since the HMMs only have one hyperparameter (the type of covariance matrix to
use for each state\footnote{
Hi Professor, I'm planning on explaining the hyperparameters of all models
in the Methodology chapter, so what I mean by "covariance matrix type" will
be known to the reader at this point.
}). Each covariance type is strongly clustered together, with
tied covariance matrices having the best recall and precision.

While there is a positive correlation between the recall and precision for the
HMMs, note that the range of precision values covered is very small and each
HMM achieves approximately the same precision.

Figure \ref{fig:05_in_depth_hmm_inf_trn_time} depicts the time taken per
observation for inference and training, for all HMMs trained on the full 51
class dataset.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_inf_trn_time}
    \caption{Seconds per observation for training and inference for HMMs
    trained on the full 51 classes. Plots a and c show the full dataset, while
    plots b and d are magnified so that the Spherical and Diagonal covariance
    types can be better inspected.}
    \label{fig:05_in_depth_hmm_inf_trn_time}
\end{figure}
<!-- prettier-ignore-end -->

It is clear that the covariance type has a strong impact on both the training
times and the inference times of the HMMs, with the full and tied covariance
types being nearly ten times slower both when training and predicting. This
means that the tied covariance type (which achieved the best performance) is
both one of the longest to train and the slowest to perform inference.

Figure \ref{fig:05_in_depth_hmm_conf_mats_cov_type} plots four confusion
matrices, one for each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_conf_mats_cov_type}
    \caption{Mean covariance matrices of all HMMs trained on 51 classes, split
    by the four covariance types: spherical, diagonal, full, and tied.}
    \label{fig:05_in_depth_hmm_conf_mats_cov_type}
\end{figure}
<!-- prettier-ignore-end -->

From the confusion matrices alone, it might look like the full HMM outperformed
all others as it has a very strong diagonal and very few off-diagonal
mispredictions when compared to the other covariance types. However, Figure
\ref{fig:05_in_depth_hmm_p_vs_r_covar_type} has already shown that the full
HMMs perform the worst in terms of both precision and recall. To investigate
this, Figure \ref{fig:05_in_depth_hmm_prf1_plots_conv_type} shows the per-class
precision, recall, and $F_1$-scores for the four covariance types.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_prf1_plots_conv_type}
    \caption{Per-class precision, recall, and $F_1$-score for each of the HMM
    covariance types.}
    \label{fig:05_in_depth_hmm_prf1_plots_conv_type}
\end{figure}
<!-- prettier-ignore-end -->

From Figure \ref{fig:05_in_depth_hmm_prf1_plots_conv_type} we can see that the
per-class recall of the Full HMMs is substantially lower than all other
covariance types. This fact is not apparent on the confusion matrices because
the majority class 50 makes the colour scale difficult to interpret. Figure
\ref{fig:05_in_depth_hmm_prf1_plots_conv_type} also clearly shows the superior
recall of the tied HMMs.

The superior recall of the tied covariance type is also apparent from the
strong diagonal in the tied confusion matrix in Figure
\ref{fig:05_in_depth_hmm_conf_mats_cov_type}. However, the tied HMMs had a
greater tendency than the full HMMs to mispredict the orientation of the
gesture (shown by the two diagonals adjacent to the major diagonal in the tied
HMMs' confusion matrix).

The spherical and diagonal HMMs have many mispredictions. The very low
precision of all HMMs is also apparent, and can be seen by the row of incorrect
predictions at the bottom of each confusion matrix where the HMM incorrectly
predicted class 50 as one of the other classes.

Figure \ref{fig:05_mean_conf_mat_hmm} shows the confusion matrices for HMMs
trained on 5, 50, and 51 classes.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_hmm}
    \caption{The weighted confusion matrices of HMMs, weighted by the models'
    $F_1$-score and normalized to make the maximum value in the confusion
    matrix be 1.}
    \label{fig:05_mean_conf_mat_hmm}
\end{figure}
<!-- prettier-ignore-end -->

The values in the confusion matrices are the weighted mean of all HMMs, based
on the $F_1$-score of each HMM. One can see that for 5 and 50 classes, the HMMs
make incorrect predictions but are largely able to predict the correct class.
There are no patterns in the errors for 5 classes but there are occasional
patterns with 50 classes: the HMMs are slightly more likely to incorrectly
infer the orientation of a gesture (as seen by the diagonal lines of cells).

With 51 classes, the HMMs struggle to correctly predict class 50, frequently
predicting that it belongs to some other class as can be seen by the row at the
bottom of the rightmost confusion matrix.

### Cumulative Sum \label{in-depth-cusum}

Figure \ref{fig:05_in_depth_cusum_p_vs_r_thresh} shows the precision and recall
for all CuSUM models trained on 51 classes, as well as the relationship between
CuSUM's threshold parameter and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_cusum_p_vs_r_thresh}
    \caption{Left: precision-recall plot for all CuSUM models trained on 51 classes, with
    the models' $F_1$-scores as contours in grey. Note that the scales of the axes have
    been adjusted to better show this models' data. Right: the CuSUM threshold
    value plotted against the $F_1$-score, showing the diminishing returns
    gained by increasing the CuSUM threshold.}
    \label{fig:05_in_depth_cusum_p_vs_r_thresh}
\end{figure}
<!-- prettier-ignore-end -->

There is a clear positive trend between precision, recall, and the CuSUM
threshold used, although there are diminishing returns on increasing the CuSUM
threshold beyond 80.

Figure \ref{fig:05_mean_conf_mat_cusum} shows the confusion matrices for CuSUM
models trained on 5, 50, and 51 classes. The values in the confusion matrices
are the weighted mean of all CuSUM models, based on the $F_1$-score of each
CuSUM model.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_cusum}
    \caption{The weighted confusion matrices of CuSUM models, weighted by the
    models' $F_1$-score and normalized to make the maximum value in the
    confusion matrix be 1.}
    \label{fig:05_mean_conf_mat_cusum}
\end{figure}
<!-- prettier-ignore-end -->

The "chequerboard" pattern visible in the 50- and 51-class confusion matrices
originates from the formulation of the CuSUM model: it has little knowledge of
the orientation of the gestures, and largely distinguishes observations based
on the finger that is moving.

### Hierarchical Feed Forward Neural Networks \label{in-depth-hffnn}

Figure \ref{fig:05_in_depth_hffnn_p_vs_r} shows the precision and recall for
all HFFNN models trained on the full 51 class dataset. Both precision and
recall have a large variance, which is likely due to the volume of the
hyperparameter search space.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_in_depth_hffnn_p_vs_r}
    \caption{Precision-recall plot for all HFFNN models trained on 51
    classes, with the models' $F_1$-scores as contours in grey. Note that the
    scales of the axes have been adjusted to better show the data.}
    \label{fig:05_in_depth_hffnn_p_vs_r}
\end{figure}
<!-- prettier-ignore-end -->

As an HFFNN is made of two classifiers, the hyperparameters for the majority
classifier (which detects if there is a gesture in the observation) and the
minority classifier (which classifies gestures, given that there is a gesture
in the observation) will be discussed sequentially. Figure
\ref{fig:05_in_depth_hffnn_majority_hpars} shows the hyperparameters for the
majority classifier. There are no clear patterns between the hyperparameters of
the majority classifier and the HFFNN's $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hffnn_majority_hpars}
    \caption{$F_1$-score against all hyperparameters for the majority
    classifier in every HFFNN.}
    \label{fig:05_in_depth_hffnn_majority_hpars}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_in_depth_hffnn_minority_hpars} shows the hyperparameters for
the minority classifier against the $F_1$-score for each HFFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hffnn_minority_hpars}
    \caption{$F_1$-score against all hyperparameters for the minority
    classifier in every HFFNN.}
    \label{fig:05_in_depth_hffnn_minority_hpars}
\end{figure}
<!-- prettier-ignore-end -->

The learning rate of the minority classifier reveals that the $F_1$-score is
higher in the range between $10^{-4}$ and $10^{-3}$ compared to the surrounding
regions.

Figure \ref{fig:05_mean_conf_mat_hffnn} shows the confusion matrices for HFFNN
models trained on 51 classes. HFFNNs were not trained on 5 or 50 classes, as
that is equivalent to training a FFNN on 5 or 50 classes. The values in the
confusion matrices are the weighted mean of all HFFNN, based on the $F_1$-score
of each HFFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_mean_conf_mat_hffnn}
    \caption{The weighted confusion matrices of HFFNN models, weighted by the
    models' $F_1$-score and normalized to make the maximum value in the
    confusion matrix be 1.}
    \label{fig:05_mean_conf_mat_hffnn}
\end{figure}
<!-- prettier-ignore-end -->

HFFNNs perform well, however there are feint offset diagonals showing a
tendency to mispredict the orientation of a gesture.

### Support Vector Machines \label{in-depth-svm}

Figure \ref{fig:05_in_depth_svm_p_vs_r_class_weight_C} shows how the
hyperparameters of the SVMs affect their precision, recall, and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_p_vs_r_class_weight_C}
    \caption{Left: precision and recall of all SVMs, with the regularization
    parameter C and class weighting mapped to the colour and marker type
    respectively. Right: The regularization parameter C plotted against the
    $F_1$-score of each SVM, with the class weight indicated by the marker
    shape.}
    \label{fig:05_in_depth_svm_p_vs_r_class_weight_C}
\end{figure}
<!-- prettier-ignore-end -->

There are two clear clusters formed by the class weighting hyperparameter. This
hyperparameter determines whether or not each observation is weighted by how
frequent its class is. Both unbalanced and balanced class weights lead to
approximately the same $F_1$-score, but dramatically different precision and
recall values. Balanced class weights (where the minority classes have greater
weighting than the majority class) have higher recall but lower precision than
unbalanced class weights (where all observations are equally weighted).

The regularization parameter C has only a small effect on the $F_1$-score, with
values below $10^{-4}$ consistently resulting in a decreased $F_1$-score. This
effect is independent of class weighting.

To investigate these clusters relating to the class weight hyperparameter,
Figure \ref{fig:05_in_depth_svm_conf_mats_unbalanced} shows the mean confusion
matrix for both balanced and unbalanced SVMs.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced}
    \caption{Confusion matrices for SVMs with unbalanced (left) and balanced
    (right) class weights. Note that the confusion matrices are \emph{not}
    normalised, which means that the cell in the bottom right corner
    (corresponding to the ground-truth and predicted class being class 50) is
    left blank. The value in this cell is so much larger than any other cell
    that it renders the plot uninformative.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced}
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
\begin{figure}[!h]
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

Figure \ref{fig:05_svm_hpars_vs_fit_time} depicts the time it takes to fit an
SVM against the hyperparameters Class Weight and C for all SVMs trained on the
full 51 classes.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_svm_hpars_vs_fit_time}
    \caption{Fit times against regularization parameter C for all SVMs trained
    on 51 classes. Whether or not the observation weights were adjusted is
    indicated by the marker type.}
    \label{fig:05_svm_hpars_vs_fit_time}
\end{figure}
<!-- prettier-ignore-end -->

As the regularization parameter C increases, the amount of time required to fit
the SVM increases to a plateau and then remains constant. The rate of increase
and the fit time at the plateau are both higher for balanced SVMs than for
unbalanced SVMs. This follows from the extra computation required to calculate
and apply a weight to every observation.

Figure \ref{fig:05_mean_conf_mat_svm} shows the confusion matrices for SVM
models trained on 5, 50, and 51 classes. The values in the confusion matrices
are the weighted mean of all SVM, based on the $F_1$-score of each
SVM.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_svm}
    \caption{The weighted confusion matrices of SVM models, weighted by the models'
    $F_1$-score and normalized to make the maximum value in the confusion
    matrix be 1. Note that the bottom right cell of the 51-class confusion
    matrix has to be set to zero, as class 50 has such a significant majority
    so as to make the confusion matrix uninformative.}
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

## Which model performs the best with 51 classes? \label{best-model}

The performance of each of the five classification algorithms can be seen in
Figure \ref{fig:05_precision_recall_51_classes} (for those models trained on
all 51 classes).

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_precision_recall_51_classes}
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
consequence of the macro weighting used for calculating $F_1$, recall, and
precision.

Each set of hyperparameters for each model type was trained and evaluated on
five different subsets of the data, resulting in five different validation sets
and five different training sets for each hyperparameter combination. The
individual performances of all training runs are shown as points in Figure
\ref{fig:05_hpar_comparison_per_model_type}. The black horizontal bars indicate
the mean of each set of hyperparameters. Note that, for model types with
discrete hyperparameters, some sets of hyperparameters were evaluated more than
five times.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_comparison_per_model_type}
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
\ref{fig:05_best_hpar_comparison} shows only those models where the lower bound
of the 90% confidence interval for the $F_1$-score is above 0.6, making it
clear which hyperparameter combinations performed the best.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_best_hpar_comparison}
    \caption{Performance of hyperparameter combinations where the lower bound
    of the 90\% confidence interval of the $F_1$-score is above 0.6. The black
    horizontal markers indicate the mean performance, and each dot indicates
    the performance on run.}
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

## Comparison of the inference and training times for each model \label{time-comparison}

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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inf_trn_times_per_obs}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inference_time_per_obs_vs_f1}
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

## Comparison of the validation to training ratios for each model \label{ratio-comparison}

Figure \ref{fig:05_f1_vs_f1_ratio} shows the validation and training $F_1$
scores for every model trained all 51 classes. The ratio of a model's training
$F_1$-score to its validation $F_1$-score can be used as a heuristic for how much a model
is overfitting to the training data, as a model that performs very well on the
training dataset but very poorly on the validation dataset is likely to have
overfit on the data, and therefore is unlikely to perform well on unseen data.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_f1_vs_f1_ratio}
    \caption{$F_1$ ratio (training $F_1$ over validation $F_1$) for each model,
    coloured by the model type. Plots a and c show the full range of their
    data, while plots b and d show the same data but magnified on a subset of
    the data.}
    \label{fig:05_f1_vs_f1_ratio}
\end{figure}
<!-- prettier-ignore-end -->

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

## English-language test data \label{real-world-data}

To evaluate the model on English-language typing data, the sensor measurements
were stored as the phrase "The quick brown fox jumped over the lazy dog" was
gestured. This stored phrase can then be fed to any model and that model's
predictions can be analysed. The predictions from the best-performing model are
shown in Figure \ref{fig:05_tqbfjotld}.

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_tqbfjotld.png}
    \caption{Time series plot of the phrase "the quick brown fox jumped over
    the lazy dog" is typed.}
    \label{fig:05_tqbfjotld}
\end{figure}
<!-- prettier-ignore-end -->

<!-- TODO ## Evaluation of autocorrect -->
<!-- TODO ## Evaluation of end-to-end process -->

## Evaluation of Models on the test set \label{test-set-eval}

Figure \ref{fig:05_tst_set_conf_mat} shows confusion matrix and the per-class
$F_1$-score, precision, and recall for the best performing hyperparameters
(hyperparameter index 44).

<!-- prettier-ignore-start -->
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_tst_set_conf_mat}
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
\begin{figure}[!h]
    \centering
    \includegraphics[width=0.75\textwidth]{src/imgs/graphs/05_p_r_best_model}
    \caption{Precision and recall for all 51 classes, as classified on the test
    set by the most performant model.}
    \label{fig:05_p_r_best_model}
\end{figure}
<!-- prettier-ignore-end -->

It is clear that there is no systematic bias in the model against any gestures
and that the gestures for which the model performs poorly is due to the data,
not some bias inherent in the model.
