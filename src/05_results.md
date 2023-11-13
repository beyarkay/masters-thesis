<!--

TODO: lots of the models achieve near-zero but not actually zero $F_1$-score.
This is probably because they're just predicting everything is class 50

TODO: Residual analysis of the best performing models

TODO: Evaluation of autocorrect

TODO: Add tSNE to appendix

TODO Remove figures that haven't been referenced.

TODO: emphasise that "50-class classification" is a very different beast to
"51-class classification", and that the former shows performance comparable to
other methods in the literature, while the later represents state of the art,
in terms of gesture detection _and_ classification.



> Hi Boyd
>
> I know I had pushed you to do a thorough analysis of the hyperparameters, but
> now you need to summarize it a lot. A 70 page result chapter is too large.
> Please review my comments and try to reduce your results chapter to 35-40
> pages at most.
>
> Put sufficient hyperparameter ranges in tables. Focus on why these
> hyperparameters are important. Put one or two graphs to support those
> hyperparameters. For most classifiers keep to one model (the 5, 50 or 51) to
> discuss the hyperparameters preferably one that is working. Just say similar
> obs can be made for the other models. Only when you see stark difference hone
> in on that.  keep the conf matrices for all models as you have done.
>
> I know it can feel frustrating, but now that you have a very good
> understanding of the hyperparameters you need to present this in a very
> succinct way. Use as little text as possible to convey what you want to say.
> It is simply too long..... I said many times put in appendix, but really
> think if you should add it to an appendix or just drop it.... I do not think
> this will take you long to do though.... You are very close now...



- TODO: Long and short captions for figures and tables
- TODO: Fit figures into margins
-->

<!-- prettier-ignore-start -->
\epigraph{
    So the universe is not quite as you thought it was. You'd better rearrange
    your beliefs, then. Because you certainly can't rearrange the universe.
}{\textit{ Isaac Asimov }}
<!-- prettier-ignore-end -->

This chapter will discuss the results obtained from the experiments described
in the Methodology chapter. The dataset will be described and some preliminary
analysis done in Section \ref{sec:05-dataset-description}. Section
\ref{sec:05-comparison-of-hypothetical-models} will compare some hypothetical models
and explore their performance characteristics, so as to better understand
common failure cases for the dataset at hand. Section \ref{sec:05-evaluated-classification-algorithms}
will justify the choice of models which were evaluated in this thesis. The
performance of each model is described in subsections
\ref{sec:05-in-depth-cusum} (CuSUM),
\ref{sec:05-in-depth-hmm} (HMMs),
\ref{sec:05-in-depth-svm} (SVMs),
\ref{sec:05-in-depth-hffnn} (HFFNNs), and
\ref{sec:05-in-depth-ffnn} (FFNNs).

Section \ref{sec:05-best-performing-51-class-classifier} looks at all trained models on the 51-class training
dataset and evaluates their performance. As _Ergo_ requires real-time
inference, Section \ref{time-comparison} compares the inference and training
times of each model. Section \ref{ratio-comparison} assesses the training and
validation performance of each model as an indicator of the model's
susceptibility to overfitting on the training data, which, in turn, could lead
to subpar performance on unseen observations. Section \ref{test-set-eval}
evaluates the best performing model on the unseen test set. Finally, Section
\ref{real-world-data} evaluates each model on a real-world dataset of
English-language typing data.

# Dataset Description \label{sec:05-dataset-description}

<!-- TODO: Probably can remove this section or more it to methodology -->

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
            \caption[short caption todo]{Resting position with hands at $45^\circ$}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_1}
            \caption[short caption todo]{The finger starts flexing}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_2}
            \caption[short caption todo]{The finger is fully flexed}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_3}
            \caption[short caption todo]{The finger starts returning to resting position}
        \end{subfigure} &
        \begin{subfigure}[t]{0.19\linewidth}
            \includegraphics[width=\linewidth]{src/imgs/05_gesture0016_4}
            \caption[short caption todo]{The gesture ends in the resting position}
        \end{subfigure} \\
        \hline
    \end{tabular}
    \caption[short caption todo]{Video frames showing gesture 16 being performed, in which both
    hands are oriented at $45^\circ$ and the right hand's index finger flexes.}
    \label{tab:05_gesture0016}
\end{table}
<!-- prettier-ignore-end -->

As the user performs gestures with _Ergo_, the sensor data is recorded and
stored to disk. A snapshot of these recordings is visible in Figure
\ref{fig:05_sensors_over_time_3230_30}, which shows 0.75 seconds of sensor
data, during which gesture 8 was made. During this period, the orientation of
the hands remained relatively stable as can be seen by how the majority of the
sensors recorded relatively stable values.

<!-- TODO: re-create this graphic to be the correct size -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_sensors_over_time_3230_30}
    \caption[short caption todo]{A snapshot of the sensor values as gesture 8 was being performed.
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

<!-- TODO: re-create this graphic to be the correct size -->
<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_sensors_over_time_3230_3200}
    \caption[short caption todo]{This plot shows the sensor values over a longer period of time,
    similar to Figure \ref{fig:05_sensors_over_time_3230_30}. Note that there
    are very brief spikes of acceleration interspersed with long periods of
    relatively stationary measurements. Also note that the orientation of the
    hands can be seen clearly in the heatmap, where the values of all sensors
    change at approximately the same time.}
    \label{fig:05_sensors_over_time_3230_3200}
\end{figure}
<!-- prettier-ignore-end -->

The classification problem encountered by _Ergo_ can be described as a 51-class
classification problem with a highly imbalanced class distribution (see Figure
\ref{fig:05_class_imbalance}). There are never more than 2 gestures performed
per second. Given a data capture frequency of 40 times per second, this means
that there are at least 19 non-gesture labels for every gesture label, and that
gesture label is one of 50 possible gesture labels. This leads to a class
balance of about 97.6% of the data belonging to the non-gesture class, with the
remaining 2.4% of the data divided approximately evenly between the 50 gesture
classes.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_class_imbalance}
    \caption[short caption todo]{Bar plots showing class imbalance. Class 50 occupies about 97\% of
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
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_example_g0011_plot}}
    \caption[short caption todo]{All observations for gesture 11, laid on top of one another. Each
    plot represents the sensor values over time for one sensor.}
    \label{fig:05_example_g0011_plot}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_pca_plot} shows a Principal Component plot of the training
data. There is reasonable separation between the gestures (as can be seen from
the diagonal streaks of colour). However, gesture 50 (in black) is less
distinct, making it likely that a model will easily distinguish the different
gestures but struggle to distinguish the gesture classes from the non-gesture
class. While this two-dimensional analysis is not a very sophisticated
technique, it does show that separating the gesture classes from one another is
easier than separating the gesture classes from the non-gesture class is much
trickier.

<!--
TODO: wrt to the caption:
> I think this has to do with the user can keep their hands rested in different
> orientations....
-->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_pca_plot}}
    \caption[short caption todo]{Principal Components of the training data, with the orientation of
    the observation mapped to the colour and the finger used for the gesture
    mapped to the marker. Class 50 is plotted in black. Note how the gesture
    classes are easily separated, but class 50 is not easily separated from the
    gesture classes.}
    \label{fig:05_pca_plot}
\end{figure}
<!-- prettier-ignore-end -->

# Comparison of hypothetical models \label{sec:05-comparison-of-hypothetical-models}

In this section, several hypothetical models are defined and their performance
examined. These hypothetical models have been chosen so as to provide some
intuition about common pitfalls encountered by real models. All confusion
matrices (in all sections) are normalised such that their columns sum to one.

Figure \ref{fig:05_pr_conf_mat_random_preds} shows the precision-recall graph
and confusion matrix of a classifier that predicts every observation according
to a uniform random distribution.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_random_preds}
    \caption[short caption todo]{Precision-recall graph and confusion matrix of a classifier that
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
achieve 97.6% accuracy by always predicting the non-gesture class.

<!---
TODO: The mean per class accuracy will be much lower. It is important here to specify
micro versus macro F1 score and accuracy... The reader can get very confused.
Please be specific are you reporting macro or micor metrics to avoid confusion.
-->

Figure
\ref{fig:05_pr_conf_mat_only_50} shows the confusion matrix and
precision-recall graph of such a classifier, which has an $F_1$-score of
0.00164. Note the column on the far right of the confusion matrix, indicating
that every class was predicted as being class 50. It is a common mistake for
real models to predict that a gesture class belongs to class 50.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_only_50}
    \caption[short caption todo]{Precision-recall graph and confusion matrix of a classifier that
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
and hand being used, but incorrectly predicts the orientation of the hand. The
non-gesture class is always predicted perfectly. Note the characteristic
diagonals, representing how any given gesture might be predicted by these
classifiers as one of five gestures, corresponding to the five orientations.
The mean $F_1$-score for these classifiers is 0.212. It is common for real
models to mispredict the orientation of a gesture (resulting in similar
diagonal patterns) but correctly predict the finger being used.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_wrong_orientation}
    \caption[short caption todo]{Precision-recall graph and confusion matrix of a classifier that
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
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_wrong_finger_correct_hand}
    \caption[short caption todo]{Precision-recall graph and confusion matrix of a classifier that
    correctly predicts the orientation and hand being used for a gesture, but
    incorrectly predicts the finger being used.}
    \label{fig:05_pr_conf_mat_wrong_finger_correct_hand}
\end{figure}
<!-- prettier-ignore-end -->

# Evaluated Classification Algorithms \label{sec:05-evaluated-classification-algorithms}

Several different classification algorithms were evaluated. The chosen
classification algorithms were selected if they are often used in the general
literature on high dimensionality, multi-class, classification data.
Additionally, the prevalence of a classification algorithm in the gesture
classification literature was considered, so as to facilitate meaningful
comparisons between this and prior work.

Feed-forward Neural Networks (FFNNs) scale well as the number of classes
increases (see Figure \ref{fig:05_inf_time_vs_num_classes}).

<!--
TODO: add footnote we discuss this figure in greater detail in section xxx. I do not
think this is the right place for this figure
-->

To scale a FFNN to classify a greater number of classes, one needs to (at
least) increase the number of output neurons and retrain the entire network.
This is favourable when compared to an algorithm requiring one classifier to be
trained per class: in the best case both the inference time and the training
time increases approximately linearly with the number of classes. While
one-vs-rest classification is suitable for few classes, it quickly becomes
unwieldy as the number of classes increases.

<!--
TODO: one-vs-rest
> can scale quadratically depending on one-versus-one or one-versus-rest
-->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inf_time_vs_num_classes}
    \caption[short caption todo]{Inference times per observation plotted against the number of
    classes in the classification task, with one plot per model type. Note that
    the scale of the y-axis is not constant due to the large range of inference
    times. Inference times per observation increases as the number of classes
    increase for HMMs and CuSUM, but that is not the case for SVMs and FFNNs.
    HFFNNs are not shown as they are not trained on fewer than 51 classes.}
    \label{fig:05_inf_time_vs_num_classes}
\end{figure}
<!-- prettier-ignore-end -->

<!--
TODO:
> Here SVMs seem to outperform neural nets. Remember a one-versus-rest SVM
> should outperform a neural network with the same number of features if the
> number of classes is small, as an SVM is a single layer neural network.
>
> From the plot it seems that SVM outperforms FFNN, which is not what you state
> later.

> Moreover how can SVM it become faster as #classes increase? You will
> effectively need 50 SVMs in background?

-->

As noted in the literature review, Hidden Markov Models (HMMs) have frequently
been used for gesture detection and classification. Multi-class classification
with HMMs require a one-vs-rest approach. This causes training and inference
times to increase with the number of classes. HMMs explicitly model the
progression of time via state transitions, and have shown promise in previous
works. Their evaluation on the _Ergo_ dataset will allow for a better
comparison between the current and prior work.

Cumulative Sum (CuSUM) is a simple statistical technique that will provide a
lower bound on the speed with which predictions can be made. While it is
unlikely to outperform other models, it will be useful as a baseline against
which the inference speed of other models can be compared.

<!--
TODO:
> Note that CuSUM in theory requires the least number of samples to detect a
> change in distribution of iid samples. Here, however, the samples are not
> iid as the underlying distribution changes slowly as the finger flexes.
> Moreover, multiple CuSUM models are needed which increases the execution time
> of the model. Build this in even if only as a footnote. so the examiner
> does not raise the issue that cusum should be much faster.

Need to do some more concrete stuff about the speed of the different models:
they are not implemented on an equal basis. Some in python, some in C, some in
both, some by the author, some by veteran ML code writers, some making use of
the GPU cores some not.
-->

It should be noted that some works in the literature do not attempt the
detection of gestures in observations, and instead only attempt the
classification of a gesture conditional on the event that there is a gesture
present in the observation. That is to say, that every observation is assumed
to contain one of a set of gestures. This is a simplification of real-world
usage, in which the majority of the observations do _not_ contain any gesture.
This simplification greatly reduces the complexity of the task, as will be
shown through comparisons of classifiers trained to predict 50 classes (which
excludes the interstitial class 50) and classifiers trained to predict 51
classes (thereby including the interstitial class 50).

One technique in the literature which has shown promise in dealing with both
detection and classification is that of a hierarchy of classifiers. In this
setup, there are two models trained. The first model is a binary classifier
simply trained to detect if there is any gesture present in an observation. The
second model is trained on only the observations containing a gesture, and is
trained to classify which gesture is present.

The first classifier will be referred to as the majority classifier, as it
classifies the majority class. The second model will be referred to as the
minority classifier, as it distinguishes the minority classes.

To make a prediction with a hierarchical model, the majority classifier is
first queried with an observation. If the majority classifier indicates that
there is no gesture present, then the no-gesture class is returned as the
model's prediction. If the majority classifier indicates that there is a
gesture present, then the observation is forwarded to the minority classifier.
The minority classifier then predicts which gesture is present and this
predicted class is returned as the model's prediction.

A Hierarchical Feed Forward Neural Network (HFFNN) architecture is tested,
following the above procedure. Two neural networks are trained: one to detect
if a gesture is present (the majority classifier) and another to classify which
gesture is present (the minority classifier).

Support Vector Machines (SVMs) have been used in the literature for glove-based
gesture classification and so are evaluated here. SVMs do not natively support
multi-class classification, but multiple SVMs can be combined to perform
one-vs-rest classification. The training time of one-vs-rest classification
scales poorly as the number of classes increases, and so only a linear kernel
for the SVM is considered.

<!--
TODO: Figure \ref{fig:05_fit_time_vs_num_classes} shows the amount of time each
model takes to be fit to the data. Note how poorly SVMs scale as the number of
classes increase.
-->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_fit_time_vs_num_classes}}
    \caption[todo smol caption here]{Caption here}
    \label{fig:05_fit_time_vs_num_classes}
\end{figure}
<!-- prettier-ignore-end -->

<!--
TODO:
> Your inference plot seems to indicate it scales very good its inference time
> decreases, this does not make sense?
-->

# Discussion of each model \label{sec:05-discussion-of-each-model}

This section will evaluate each of the models in depth, but will not make
comparisons between different model types. Characteristics specific to each
model type are discussed, relating to $F_1$-score, precision, recall, inference
times, and training times. Where appropriate, confusion matrices of different
models are visualised to aid with the analysis of these models. For inter-model
comparisons, please see sections \ref{sec:05-best-performing-51-class-classifier} and \ref{time-comparison}.
All evaluation metrics ($F_1$-score, precision, recall, confusion matrices) are
and calculated using the validation set unless otherwise specified. When an
evaluation metric is given for an entire model, that metric is the unweighted
mean of the metric for each class. The models are evaluated on the unseen test
set in Section \ref{test-set-eval}.

FFNNs are be discussed in section \ref{sec:05-in-depth-ffnn}, HMMs in section
\ref{sec:05-in-depth-hmm}, CuSUMs in section \ref{sec:05-in-depth-cusum}, HFFNNs in section
\ref{sec:05-in-depth-hffnn}, and SVMs in section \ref{sec:05-in-depth-svm}.

## Cumulative Sum \label{sec:05-in-depth-cusum}

Figure \ref{fig:05_mean_conf_mat_cusum} shows the confusion matrices for CuSUM
models trained on 5, 50, and 51 classes. The values in the confusion matrices
are the weighted mean of all CuSUM models, with weights based on the
$F_1$-score of each CuSUM model. After the weighted sum, all columns were
independently normalised to sum to one.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_cusum}}
    \caption[short caption todo]{The weighted confusion matrices of three CuSUM classifiers, trained
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
sometimes predicted as gesture 0 (left hand little finger) or as gesture 2
(left hand middle finger). These mispredictions can be explained by the natural
movement of the human hand: it is difficult to move one's ring finger in
isolation. When performing gesture 1, the user's little finger and middle
finger move by some amount, in addition to the expected movement of the user's
ring finger. CuSUM is not able to learn that this additional movement is
expected, and only knows that acceleration of the user's ring finger should
result in a prediction of gesture 1. Therefore, movements
of the user's ring finger occasionally result in gesture 1 predictions

The 50- and 51-class CuSUM models both display a "chequerboard" pattern. This
pattern also originates from the formulation of the CuSUM model. Each of the
blocks on this chequerboard are $5 \times 5$, similar to what was shown in the
hypothetical model in Figure
\ref{fig:05_pr_conf_mat_wrong_finger_correct_hand}. This patten occurs when two
model biases occur simultaneously: The model must confuse gestures using
fingers on the same hand (this causes "blocks" of mispredictions along the
principle diagonal), and the model must confuse the orientation of the gesture
(this causes the pattern along the principle diagonal to be repeated
orthogonally).

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
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_cusum_classes5}
    \caption[short caption todo]{Left: precision-recall plot for all 5-class CuSUM models, with the
    value of the threshold hyperparameter indicated by the colour of the point. Right: a direct
    plot of the model's $F_1$-score against the threshold parameter.}
    \label{fig:05_hpar_analysis_cusum_classes5}
\end{figure}
<!-- prettier-ignore-end -->

One can see that increasing the value of the threshold hyperparameter improves
the performance of the model, although there are diminishing returns with an
inflexion point around a threshold value of 40. The maximum $F_1$-score of
0.989 is achieved with a threshold of 100, and the median $F_1$-score for CuSUM
models with a threshold of 100 is 0.937.

The hyperparameter analysis of the 50- and 51-class CuSUM models is done in the
appendix (Section \ref{sec:appendix_50_cusum_hpar} and \ref{sec:appendix_51_cusum_hpar} respectively)

## Hidden Markov Models \label{sec:05-in-depth-hmm}

Figure \ref{fig:05_mean_conf_mat_hmm} shows the confusion matrices for HMMs
trained on 5, 50, and 51 classes.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_hmm}}
    \caption[short caption todo]{The weighted confusion matrices of three HMM classifiers, trained
    on 5, 50, and 51 classes. The confusion matrices are weighted by the
    $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the HMMs, with each colour representing
    the HMMs trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_hmm}
\end{figure}
<!-- prettier-ignore-end -->

The 5-class HMMs are mostly strong classifiers, with a median $F_1$-score of
$0.694$ and a maximum of 1. It is clear from the 5-class confusion matrix that
gesture 4 was correctly predicted much more frequently than the other gesture
classes. Gesture 4 flexes the left hand's thumb (as does every gesture which
ends in the digit 4). This improvement in the predictions for gesture 4 can be
attributed to the acceleration sensors on the thumbs being oriented differently
to the sensors on the other fingers. This is because the sensor is designed to
lie flat on the user's fingernail. This change in orientation of the sensor the
effect of changing which one of the three axes is dominated by gravity, leading
to gestures which are easier to distinguish.

The 5-class confusion matrix also makes apparent that adjacent gestures (for
example, gestures 0 and 1, or 1 and 2) are slightly more likely to be
confounded by the 5-class HMM. This can be seen in how the cells directly
adjacent to the principle diagonal contain larger values than the cells further
from the principle diagonal. This can be attributed to how the movement of
one's fingers is not completely independent, and moving one finger is likely to
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
to correctly classify class 50. The majority of observations belonging to
class 50 are incorrectly classified as belonging to one of the other gesture
classes. This causes the 51-class HMMs have a greatly reduced precision. This
behaviour is similar to the 51-class CuSUM models.

A detailed analysis of the hyperparameters of the 5- and 51-class HMMs is
available in the appendix, sections \ref{sec:appendix_5_hmm_hpar} and \ref{sec:appendix_51_hmm_hpar} respectively.

### 50-class HMM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_hmm_50_p_vs_r_covar_type} shows the
precision-recall plot for all 50-class HMMs, as well as the $F_1$-score
of each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_50_p_vs_r_covar_type}
    \caption[short caption todo]{Left: Precision-recall plot for all HMMs trained on 50 classes.
    Right: Plot of the model's $F_1$-score for each covariance matrix type.
    Note that the scales of the axes have been adjusted to better show the
    distribution of the data.}
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
with diagonal HMMs having the least favourable performance.

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
    \caption[short caption todo]{Duration in seconds per observation required to fit and to train
    the different covariance types for 50-class HMMs.}
    \label{fig:05_in_depth_hmm_inf_trn_time_classes50}
\end{figure}
<!-- prettier-ignore-end -->

Figure \ref{fig:05_in_depth_hmm_conf_mats_cov_type_classes50} shows the
weighted confusion matrices for 50-class HMMs for each of the four covariance
types: spherical, diagonal, tied, and full.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_conf_mats_cov_type_classes50}
    \caption[short caption todo]{Weighted confusion matrices of all 50-class HMMs, with one
    confusion matrix per covariance type. The confusion matrices are normalised
    such that each column sums to one.}
    \label{fig:05_in_depth_hmm_conf_mats_cov_type_classes50}
\end{figure}
<!-- prettier-ignore-end -->

The spherical and diagonal covariance types show an interesting bias in their
predictions. The gestures made with the thumbs (4, 5, 14, 15, 2, 25, 34, 35,
44, 45) are largely better predicted than the gestures using other fingers.
Gestures using other fingers are more likely to be confused, and are generally
confused with gestures that use the correct orientation and the correct hand,
but the wrong finger. This can be explained by observing that the orientation
of the acceleration sensor on the thumbs is different to the orientation of the
acceleration sensor on the other fingers, and so is possibly more distinct than
the other gestures.

Figure \ref{fig:05_in_depth_hmm_prf1_plots_conv_type_classes50} shows the
per-class precision, recall, and $F_1$-score for each of the four covariance
types: spherical, diagonal, tied, and full.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_prf1_plots_conv_type_classes50}
    \caption[short caption todo]{The precision, recall, and $F_1$-scores of all 50-class HMMs, with
    one plot per covariance type. The colour scale is the same as used in
    Figure \ref{fig:05_in_depth_hmm_conf_mats_cov_type_classes50}. One can see
    that the spherical and diagonal covariance types are able to achieve a
    high precision on the gestures involving the thumbs: 4, 5, 14, 15, 24, 25,
    34, 35, 44, and 45.}
    \label{fig:05_in_depth_hmm_prf1_plots_conv_type_classes50}
\end{figure}
<!-- prettier-ignore-end -->

This makes the bias of the spherical and diagonal HMMs clear: the precision of
these HMMs is very obviously higher for gestures involving the thumbs. The tied
covariance HMM generally performed the best, making very few mispredictions.

## Support Vector Machines \label{sec:05-in-depth-svm}

Figure \ref{fig:05_mean_conf_mat_svm} shows the confusion matrices for SVM
models trained on 5, 50, and 51 classes. The values in the confusion matrices
are the weighted mean of all SVMs, with the weighting proportional to the
$F_1$-score of each SVM.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_svm}}
    \caption[short caption todo]{The weighted confusion matrices of three SVM classifiers,
    trained on 5, 50, and 51 classes. The confusion matrices are weighted by
    the $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the CuSUM, with each colour
    representing the CuSUM trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_svm}
\end{figure}
<!-- prettier-ignore-end -->

The 5- and 50-class SVMs performed well, with the majority of predictions
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
There are a few outliers, but the majority of 5-class SVMs were easily
able to separate the classes. The weighted confusion matrices can be seen in
Figure \ref{fig:05_in_depth_svm_conf_mats_unbalanced_classes5}. Both the
balanced and unbalanced SVMs performed well.

The precision-recall plot can be seen in the appendix (Figure
\ref{fig:appendix_in_depth_svm_classes5}) as it does not convey much useful
information due to the good performance of the SVMs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced_classes5}
    \caption[short caption todo]{Weighted confusion matrices of the balanced and unbalanced 5-class
    SVMs.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced_classes5}
\end{figure}
<!-- prettier-ignore-end -->

### 50-class SVM Hyperparameter Analysis

Similarly to the 5-class SVMs, the 50-class SVMs performed very well with a
minimum $F_1$-score of 0.955, a median of 0.974, and a maximum of 0.989.

The weighted confusion matrices for the 50-class SVMs shows a slight bias
towards mispredicting the orientation of a gestures (as can be seen by the
diagonals adjacent to the principle diagonal) but otherwise show very good
performance.

The precision-recall plot can be seen in the appendix (Figure
\ref{fig:appendix_in_depth_svm_classes50}) as it does not convey much useful
information due to the good performance of the SVMs. The regularisation
coefficient C has minimal impact on the $F_1$-score and whether or not the
influence of each class was balanced has little impact on the $F_1$-score.

<!--
TODO:
> Consider adopting a similar writing style for the other classifiers. We really
> need to only state the most important results everything else to appendix. But
> as I said look at the total length of your thesis if below 150 p it is all ok.
-->

### 51-class SVM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_svm_classes51} shows the regularisation parameter
C, as well as the balanced/unbalanced hyperparameter which dictates whether or
not the observations were weighted by their classes frequency.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_classes51}
    \caption[short caption todo]{Left: precision and recall of all 51-class SVMs, with the
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
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced_classes51}
    \caption[short caption todo]{Confusion matrices for SVMs with unbalanced (left) and balanced
    (right) class weights.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced_classes51}
\end{figure}
<!-- prettier-ignore-end -->

One can see that both the balanced and unbalanced SVMs do fairly well by the
strong diagonal through the plots. However, note that the SVMs with unbalanced
class weights frequently mispredict observations belonging to class 50 as
belonging to one of the other gesture classes (as can be seen by the strong row
at the bottom of the plot). This type of misclassification leads to low recall,
as the model is frequently failing to correctly predict correctly for class 50.

In a complementary manner, note that the balanced class weight SVMs generally
predict many non-50 classes as belonging to class 50 (as can be seen by the
column on the far right of the plot). This type of misclassification leads to
low precision, as the model is over-predicting for all of the gesture classes.

Figure \ref{fig:05_in_depth_svm_prf1_plots_unbalanced} shows the per-class
precision, recall, and $F_1$-score for balanced and unbalanced class weight
SVMs. It is clear that the balanced SVMs have higher recall and unbalanced
SVMs have higher precision.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_prf1_plots_unbalanced}
    \caption[short caption todo]{Per-class precision, recall, and $F_1$-score for balanced and
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
    \caption[short caption todo]{Left: Fit times against regularisation parameter C for all SVMs
    trained on 51 classes. Right: Inference time against regularisation
    parameter C. Whether or not the observation weights were adjusted is
    indicated by the marker type.}
    \label{fig:05_svm_hpars_vs_fit_time}
\end{figure}
<!-- prettier-ignore-end -->

<!--
TODO:
C should not affect inference time since a single svm is just a neural net
layer.... Same equation..... can you explain the outliers?
-->

As the regularisation parameter C increases, the amount of time required to fit
the SVM increases to a plateau and then remains constant. The rate of increase
and the fit time at the plateau are both higher for balanced SVMs than for
unbalanced SVMs. This follows from the extra computation required to calculate
and apply a weight to every observation.

<!--
TODO: why is the plateau for fit time at the same C value as the plateau for f1-score?
-->

There is no relationship between the inference time and the class weight nor
the inference time and the regularisation coefficient C. This is to be
expected, as neither hyperparameter is used to perform inference.

## Feed-forward Neural Networks \label{sec:05-in-depth-ffnn}

Due to the large number of hyperparameters for FFNNs, plots which show no
relationship between hyperparameters and evaluation metrics will be excluded
from this chapter. Unabridged figures with all hyperparameters have been placed
in the Appendix and will be mentioned at the appropriate point, should the
interested reader wish to view them. Note that they will not be necessary for
the discussion.

Figure \ref{fig:05_mean_conf_mat_ffnn} shows the mean confusion matrices for
all FFNNs trained on 5, 50, and 51 classes, weighted by that model's
$F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_ffnn}}
    \caption[short caption todo]{The weighted confusion matrices of three FFNN classifiers, trained
    on 5, 50, and 51 classes. The confusion matrices are weighted by the
    $F_1$-score of each model, such that better performing models have a
    greater impact on the weighted confusion matrix. The bottom right plot
    shows the precision-recall plot for the FFNNs, with each colour
    representing the FFNNs trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_ffnn}
\end{figure}
<!-- prettier-ignore-end -->

The weighted confusion matrix for 5-class FFNNs shows good performance,
with little bias in its mispredictions.

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
as one of the other classes $0, 1, \ldots, 49$. This is indicated by the row at
the bottom of the confusion matrix. There are also a number of mispredictions
where one of the classes $0, 1, \ldots, 49$ were classified as class 50. This
is indicated by the column at the right of the confusion matrix. There are
relatively few mispredictions where one gesture class is mispredicted as
belonging to another gesture class.

The precision-recall plot for these FFNNs shows that all FFNNs have a large
variance in their performance, with standard deviations of the $F_1$-score of
0.395, 0.411, and 0.306 for the 5-, 50-, and 51-class models respectively. The
maximum performance of the models was 1, 0.997, and 0.772 for the 5-, 50-, and
51-class models respectively.

### 5-class FFNN Hyperparameter Analysis

For 5-class FFNN, the following hyperparameters showed no significant
relationship with the model's $F_1$-score: dropout rate, L2 coefficient, batch
size, number of layers, and the number of nodes in any layer. Interested
readers are referred to Figure \ref{fig:appendix_ffnn_hpar_analyis_classes5}
for an unabridged plot of these hyperparameters.

<!--
TODO: double check Figure \ref{fig:appendix_ffnn_hpar_analyis_classes5}.

Also check if nodes per layer in layer 1 isn't related in some way

-->

Figure \ref{fig:05_hpar_analysis_ffnn_classes5_lr} shows the learning rate of the
5-class FFNNs against the model's validation loss and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes5_lr}
    \caption[short caption todo]{The learning rate of the 5-class FFNNs against their $F_1$-score
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

<!--
TODO:

> I think it is dangerous to state a model with too few nodes will not
> learn. Please think of rephrasing. Again it looks to me from A4 that if
> you have too few nodes it does not train if you have enough nodes it is more
> likely to train?

> At the very least you should comment on as to why it is less important in
> this and the 5 class case.
-->

Figure \ref{fig:05_hpar_analysis_ffnn_classes50_lr} shows the learning rate of the
50-class FFNNs against the model's validation loss and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_lr}
    \caption[short caption todo]{The learning rate of the 50-class FFNNs against their $F_1$-score
    (left) and validation loss (right).}
    \label{fig:05_hpar_analysis_ffnn_classes50_lr}
\end{figure}
<!-- prettier-ignore-end -->

As with the 5-class FFNNs, there is a clear range of learning rates between
$10^{-3.5}$ and $10^{-1.5}$ with improved $F_1$-scores and validation losses.
This range is approximately the same for the 50-class FFNNs as it was for the
5-class FFNNs, indicating that it is dependant on the dataset as opposed to the
model architecture. Once again, it's important to note that models with
learning rates outside of this range were unlikely to fit the data, but even
models within this range didn't have a guarantee of fitting the data
successfully. Having a learning rate between $10^{-3.5}$ and $10^{-1.5}$ is
necessary but not by itself sufficient for achieving good performance in a
50-class model.

In addition to the learning rate, the number of layers in the 50-class network
has an impact on the performance of the respective FFNN. Figure
\ref{fig:05_hpar_analysis_ffnn_classes50_nlayers} shows the number of layers in
the 50-class FFNNs against the model's validation loss and $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_nlayers}
    \caption[short caption todo]{The number of layers in the 50-class FFNNs against their
    $F_1$-score (left) and validation loss (right).}
    \label{fig:05_hpar_analysis_ffnn_classes50_nlayers}
\end{figure}
<!-- prettier-ignore-end -->

Models with one, two, or three layers were all able to learn the data and
achieve a high $F_1$-score, however this was more frequent with models with one
or two layers. Models with three layers were also unable to achieve a
validation loss as low as some of the models with one or two layers. This is
likely due to the increased complexity of the additional layer.

<!--

TODO: need to mention possible interactions between LR and number of layers

TODO:

> > This is likely due to the increased complexity of the additional layer.
> I would rephrase this. It is more likely that once there are three layers
> there is a higher probability of having very imbalanced layers, which can
> lead to bottlenecks and reduce perfromance....

-->

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
    \caption[short caption todo]{Precision-recall heatmap for the 1-, 2-, and 3-layer 51-class
    FFNNs. The colour of each cell indicates the number of observations in that
    region, according to the shared colourbar on the right of the plot.}
    \label{fig:05_51ffnn,x=p,y=r,c=nlayers,histplot}
\end{figure}
<!-- prettier-ignore-end -->

The 1-layer FFNNs have the greatest number of high-performing FFNNs, followed
by the 2- and then the 3-layer FFNNs. The majority of 3-layer FFNNs did
not manage to fit to the data, achieving nearly zero precision and recall.

<!---                       Number of layers                           --->

Figure \ref{fig:05_51ffnn,x=p,y=r,h=nlayers} shows the precision-recall plot
for all 51-class FFNNs, coloured based on the number of layers of each FFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=p,y=r,h=nlayers}
    \caption[short caption todo]{$F_1$ plot and precision-recall scatter plot for all 51-class
    FFNNs, with the colour of the markers based on the number of layers in that
    FFNN.}
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
space around the best found $F_1$-score has been well searched.

There is a cluster of high-performing FFNNs around a recall of 0.8 and a
precision of 0.6. It might be assumed that this cluster is a result of just one
hyperparameter being in the correct range of values, however this is not the
case. To explore the relationship between the hyperparameters and the
$F_1$-score, it is informative to look at the 1-, 2-, and 3-layer FFNNs
individually.

When looking at the best performing 1-, 2-, and 3-layer FFNNs, it appears that
increasing the number of layers has the effect of improving the recall but
reducing the precision. Overall, the precision decreases faster than the recall
improves, leading to a decrease in $F_1$-score as the number of layers is
increased.

<!---- Hyperparameter-f1 scatter plot for nlayers == 1 --->

#### Performance for 1-layer FFNNs

Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=1} shows the $F_1$-score
of each 1-layer FFNN against all hyperparameters, where each plot describes a
different hyperparameter.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=1}}
    \caption[short caption todo]{$F_1$-score against all hyperparameters for all 51-class FFNNs
    with 1 layer. Each plot represents a different hyperparameter.}
    \label{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=1}
\end{figure}
<!-- prettier-ignore-end -->

Generally the 1-layer FFNNs are able to achieve a high $F_1$-score with a wide
range of hyperparameter values, with notable exceptions being the learning rate
and the number of nodes in layer 1. This will be discussed in more detail in
the coming subsections. The batch size, L2 coefficient, and dropout rate all
had very little effect on the performance of the FFNNs. The maximum recall,
precision, and $F_1$-score achieved by the 1-layer FFNNs is 0.865, 0.736, and
0.772 respectively.

<!---- Hyperparameter-f1 scatter plot for nlayers == 2 --->

#### Performance for 2-layer FFNNs

Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2} shows the
$F_1$-score of each 2-layer FFNN against all hyperparameters, where each plot
describes a different hyperparameter.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2}}
    \caption[short caption todo]{$F_1$-score against all hyperparameters for all 51-class FFNNs
    with 2 layers. Each plot represents a different hyperparameter.}
    \label{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2}
\end{figure}
<!-- prettier-ignore-end -->

The 2-layer FFNNs performed slightly worse than the 1-layer FFNNs. The learning
rate of the 2-layer FFNNs appears to have a wide range of values for which a
good $F_1$-score was achieved, and then a smaller subset for which the best
2-layer FFNN $F_1$-score was achieved. This effect will be better explored in
Figure \ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} by looking at the
precision-recall scatter plot for 1-, 2-, and 3-layer FFNNs. Having sufficient
nodes in both layers of the 2-layer FFNN was also necessary for a good
$F_1$-score. The batch size, L2 coefficient, and dropout rate all had a
negligible effect on the $F_1$-score. The maximum recall, precision, and
$F_1$-score achieved by the 2-layer FFNNs is 0.921, 0.678, and 0.745
respectively.

<!---- Hyperparameter-f1 scatter plot for nlayers == 3 --->

#### Performance for 3-layer FFNNs

Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=3} shows the
$F_1$-score of each 3-layer FFNN against all hyperparameters, where each plot
describes a different hyperparameter.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=3}}
    \caption[short caption todo]{$F_1$-score against all hyperparameters for all 51-class FFNNs
    with 3 layers. Each plot represents a different hyperparameter.}
    \label{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=3}
\end{figure}
<!-- prettier-ignore-end -->

The 3-layer FFNNs generally performed worse than the 1- and 2-layer FFNNs. The
learning rate of the 3-layer FFNNs appears to have a very precise range of
values for which a good $F_1$-score was achieved. This effect will be better
explored in Figure \ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} by looking at the
precision-recall scatter plot for 1-, 2-, and 3-layer FFNNs.

The number of nodes in each of the layers had less of an impact in the 3-layer
FFNNs compared to the 1- and 2-layer FFNN, so long as there was a sufficient
number of nodes in the first layer.

The dropout rate has a large impact on the $F_1$-score, and the majority of
well-performing 3-layer FFNNs had a dropout rate below 0.2. This will be
discussed in more detail.

The batch size, and L2 coefficient had a negligible effect on the $F_1$-score.
The maximum recall, precision, and $F_1$-score achieved by the 3-layer FFNNs is
0.933, 0.685, 0.742 respectively.

<!---- Split violin plots of recall > 0.7--->

#### Hyperparameters causing the cluster around recall > 0.7

Figure \ref{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70} shows a set of scatter
plots, with one plot for each hyperparameter for 51-class FFNNs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,c=hpar,x=hpar,y=recall>70}}
    \caption[short caption todo]{Scatter plots of each of the hyperparameters for
    the 51-class FFNNs, where blue shows the points for FFNNs with a recall
    greater than 0.7, and orange shows the points for FFNNs with a recall
    less than 0.7. While one can see ranges of hyperparameter values which
    often result in a recall greater than 0.7, there are no hyperparameter
    ranges which entirely explain good performance.}
    \label{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70}
\end{figure}
<!-- prettier-ignore-end -->

The colour of each area informs whether it's recall is greater than 0.7. If
there were a hyperparameter which could result in a FFNN with a recall greater
than 0.7, then one would expect the plot for that hyperparameter to contain a
range where the majority of FFNNs have a recall greater than 0.7 and very
few FFNNs with a recall less than 0.7. However this is not the case. There do
appear to be a few hyperparameters which are necessary for a FFNN to achieve a
recall greater than 0.7 (learning rate, number of nodes in the first layer, the
number of layers). However there are no hyperparameters which are _sufficient_
for a FFNN to achieve a recall greater than 0.7.

<!---                       LR vs npl1                           --->

#### Performance vs Learning rate and Nodes in layer 1

Figure \ref{fig:05_51ffnn_x=lr,y=npl1,h=f1} shows the learning rate of all
51-class FFNNs against the number of nodes in layer 1, with the colour of each
point indicating the validation $F_1$-score of that FFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51ffnn_x=lr,y=npl1,h=f1}}
    \caption[short caption todo]{The learning rate against the number of nodes in the first layer
    of all 51-class FFNNs, with the colour of each point indicating the
    $F_1$-score. Note that a small amount of random noise has been applied to
    the hyperparameters (but not the $F_1$-score). As each set of
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
generally had more than 31 ($\approx 10^{1.5}$) nodes in their first layer and had a
learning rate in the range $[10^{-4}, 10^{-3}]$.

<!---                    precision-recall hue=nlayers                      --->

#### Performance vs Number of Layers

Figure \ref{fig:05_51ffnn,x=p,y=r,h=nlayers} showed that the cluster of
performant FFNNs with a recall greater than 0.7 contains FFNNs with 1-, 2-, and
3-layers. To analyse this cluster of performant FFNNs, Figure
\ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} plots the precision and recall for
1-, 2-, and 3-layer FFNNs, with the colour of the point indicating the learning
rate.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=p,y=r,h=lr,c=nlayers}}
    \caption[short caption todo]{Precision-recall scatterplots with the colour indicating the
    learning rate according to the shared colour bar on the right. Each plot
    represents all 51-class FFNNs with 1-, 2-, or 3-layers. Note the clustering
    that happens with the 1- and 2-layer FFNNs. Too few 3-layer FFNNs achieve
    good performance for clustering to be readily visible.}
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

<!--
TODO:

> I do not think it is fair to imply that three layer network will underperform
> in general. If the data is complex enough one ought to be able to get better
> performance from a three layer network. From what I saw in the histogram the
> good ranges of learning rate was not explored well enough. I would therefore
> not imply that three layers are a no go. Rather say for the hyperparameter
> ranges explored the three layer networks underperfomed. This either indicatess
> that they are of a too high capacity for htis data or that certain
> hyperparameter ranges need to be explored in more detail. This is left for
> future work.
-->

<!---       learning rate vs f1-score and number of nodes in last layer  --->

#### Performance vs learning rate and nodes in the last layer

<!--

TODO:

> Think a bit about what to report and what to throw away. In my mind the only
> thing to bring accross is. learning rate is important as are the number of
> nodes. Three layer models did not train welll probably as the hyperparameter
> ranges explored were too restrictive. That is about it.... There is tooo much
> here now....
-->

Figure \ref{fig:05_51ffnn,x=lr,y=npl-1,h=f1,c=nlayers} shows the learning rate
and the number of nodes in the last layer of the 1-, 2-, and 3-layer FFNNs,
with the point's colour indicating the $F_1$-score of the FFNN.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_51ffnn,x=lr,y=npl-1,h=f1,c=nlayers}}
    \caption[short caption todo]{The number of nodes in the last layer against the learning rate of
    all 51-class FFNNs, with one plot for each of the 1-, 2-, and 3-layer
    FFNNs. Colour of a point indicates the $F_1$-score of the FFNN, as
    indicated by the shared colour bar on the right. Note the relatively narrow
    band of learning rates which resulted in performant FFNNs. A small amount of
    random noise is applied to each point such that they do not overlap.}
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

#### Performance vs nodes in layers 1, 2, and 3

Figure \ref{fig:05_51ffnn,x=npl1,y=npl2,h=f1,c=nlayers} shows the number of
nodes in each layer against the $F_1$-score of the 51-class FFNNs with 1, 2,
and 3 layers.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51ffnn,x=npl1,y=npl2,h=f1,c=nlayers}}
    \caption[short caption todo]{The number of nodes in layer $i$ against the number of nodes in
    layer $j$, for $i, j \in [1,2,3]$ and where $i,j$ is not greater than the
    number of layers of the FFNN. The colour represents the $F_1$-score, as
    indicated by the shared colour bars on the right. Note that since 1-layer
    FFNNs only have 1 layer, there is no variable mapped to the y-axis.
    Instead, some noise is added in the vertical direction so that the points
    do not overlap. A small amount of random noise is applied to each point
    such that they do not overlap.}
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

<!--
TODO
> I think this is dangerous given that we saw the range of learning rate was not
> explored well enough for three layers. I would really think about this before
> writing this correlation is not the same as causality......
-->

This would imply that the performant 3-layer FFNNs trace a line through the
3-dimensional hyperparameter space that has the number of nodes per layer as
it's dimensions. This line would go from the point of many nodes in layers 1
and 3 with few nodes in layer 2 to the point of few nodes in layers 1 and 3
with many nodes in layer 2.

This hypothesis is backed up by the 3 dimensional plot in Figure
\ref{fig:05_51ffnn,x=npl1,y=npl2,z=npl3,h=f1} which shows all the 3-layer
FFNNs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51ffnn,x=npl1,y=npl2,z=npl3,h=f1}}
    \caption[short caption todo]{All 51-class 3-layer FFNNs with the number of nodes in each layer
    assigned to the x, y, and z axis. The colour of each point represent the
    $F_1$-score of that FFNN. A small amount of random noise is applied to each
    point such that they do not overlap.}
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

An analysis of the performance of the FFNNs against the regularisation
hyperparameters (dropout rate and L2 coefficient) is available in the appendix,
Section \ref{sec:appendix_51_ffnn_regularisation}.

## Hierarchical Feed Forward Neural Networks \label{sec:05-in-depth-hffnn}

As with the FFNNs, the HFFNNs have many hyperparameters. Plots which show no
relationship between hyperparameters and evaluation metrics will be excluded
from this section. Unabridged figures with all hyperparameters have been placed
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
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_hffnn}}
    \caption[short caption todo]{The weighted confusion matrices of 51-class HFFNN classifier. The
    confusion matrix is weighted by the $F_1$-score of each model, such that
    better performing models have a greater impact on the weighted confusion
    matrix.}
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

<!--------------------------Maj nlayers vs Min nlayers----------------------------->

Figure \ref{fig:05_51hffnn,x=nlayers,y=f1,h=nlayers,c=majmin} shows the
$F_1$-score of all 51-class HFFNNs, grouped by the number of layers of the
majority classifier and of the minority classifier, with the colour of each
point describing the number of layers in the minority classifier and
majority classifier respectively.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51hffnn,x=nlayers,y=f1,h=nlayers,c=majmin}}
    \caption[short caption todo]{The number of layer of the majority and minority classifiers for
    all 51-class HFFNNs against performance metrics. The top row shows the
    $F_1$-score organised based on the number of layers in the majority (left)
    and minority (right) classifiers. In these plots, the colour of each point
    represents the number of layers in the other classifier. The bottom plot
    shows the precision-recall scatterplot for all 51-class HFFNNs, with the
    colour of each point representing the number of layers in the majority
    classifier and the marker shape indicating the number of layers in the
    minority classifier.}
    \label{fig:05_51hffnn,x=nlayers,y=f1,h=nlayers,c=majmin}
\end{figure}
<!-- prettier-ignore-end -->

Looking at the left plot which splits the HFFNNs by the number of layers in the
majority classifier, we can see that the 1-layer classifiers are generally more
likely to have a higher $F_1$-score than the 2- and 3-layer classifiers. The
well-performing HFFNNs with 1-layer majority classifiers are also more likely
to have 1-layer minority classifiers. A similar observation can be made for the
well-performing HFFNNs with 2-layer majority classifiers: they too are more
likely to have 1-layer minority classifiers. There are very few high
$F_1$-score HFFNNs with a majority classifier with 3 layers. The performance of
the HFFNN generally decreased as the number of layers in the majority
classifier increased.

Looking at the plot on the right which splits the HFFNNs by the number of
layers in the minority classifier, we can see that while the 1-layer minority
classifiers more frequently achieve a better $F_1$-score than the 3-layer
minority classifiers; the performance of the HFFNN generally improved as the
number of layers in the minority classifier increased. This is the opposite of
the trend observed for the number of layers in the majority classifier. The
best HFFNN had a majority classifier with 1 layer and a minority classifier
with 3 layers.

This can be understood by observing that the majority classifier is a binary
classifier, and needs to only distinguish class 50 from all the gesture classes
$0 \ldots 49$. The minority classifier is a multi-class classifier and has to
distinguish between all 50 gesture classes $0 \ldots 49$. The minority
classifier is more able to make use of additional layers because of the number
of classes required to be classified, while the majority classifier is able to
accomplish the binary classification task with only one layer.

<!--------------------------Nodes in last layer----------------------------->

Figure \ref{fig:05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin} shows the number of
nodes in the last layer of the majority and minority classifiers for all
51-class HFFNNs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin}}
    \caption[short caption todo]{The top row shows the $F_1$-scores on the y-axis plotted against
    the number of nodes in the last layer of the majority/minority classifier
    (x-axis), and with the colour of each point indicating the number of nodes
    in the last layer of the minority/majority classifier. The bottom plot
    shows the interactions between the number of nodes in the last layer of the
    majority (x-axis) and minority (y-axis) classifiers, with the $F_1$-score
    indicated by the colour of each point.}
    \label{fig:05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin}
\end{figure}
<!-- prettier-ignore-end -->

Overall there is very little connection between the number of nodes in the last
layer of either the majority or minority classifier and the performance of the
overall FFNN. It is possible that there is a positive relationship between the
number of nodes in the last layer of the minority classifier and the
$F_1$-score, however this effect is slight. It also appears that the
$F_1$-score is reduced for HFFNNs with a large ($>10^2$) number of nodes in
the last layer of the majority classifier. It is possible that the increased
number of nodes but constant number of epochs assigned to training the
classifier meant that the majority classifier was less able to learn the
dataset within the computational budget. <!-- TODO: this is a poor
explanation-->

Of interest is how relatively well performing HFFNNs can have very few (less
than 10) nodes in the last layer of either the majority or minority classifier.
The rightmost plot of Figure
\ref{fig:05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin} shows the number of nodes
in the last layer of the majority and minority classifiers plotted against each
other, with the colour of each point indicating the $F_1$-score of the HFFNN.
There are no well-performing HFFNNs with few nodes in the last layer of both
the majority and minority classifiers (as seen in the bottom left of the plot).
This is to be expected, as some amount of capacity is required for the
classifiers to be able to learn the data. HFFNNs with very few ($<10$) nodes in
the last layer of the majority classifier are still able to perform well if the
number of nodes in the last layer of the minority classifier is sufficiently
high ($>10^{1.5}$).

<!--------------------------Maj LR vs Min LR----------------------------->

Figure \ref{fig:05_51hffnn,x=lr,y=f1,h=lr,c=majmin} shows the learning rates of
the majority and minority classifiers against the $F_1$-scores of the 51-class
HFFNNs.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51hffnn,x=lr,y=f1,h=lr,c=majmin}}
    \caption[short caption todo]{The top row shows the $F_1$-scores on the y-axis plotted against
    the learning rate of the majority/minority classifier (x-axis), and with
    the colour of each point indicating the learning rate of the
    minority/majority classifier. The bottom plot shows the interactions
    between the learning rate of the majority (x-axis) and minority (y-axis)
    classifiers, with the $F_1$-score indicated by the colour of each point.}
    \label{fig:05_51hffnn,x=lr,y=f1,h=lr,c=majmin}
\end{figure}
<!-- prettier-ignore-end -->

For the majority classifier, there is a wide range of learning rates
(in the range $[10^{-4.5}, 10^{-2.5}]$ for which the HFFNN will learn the
dataset. While all high-performing HFFNNs did have a majority learning rate in
this range, this condition is not sufficient for a HFFNN to perform well. There
are many HFFNNs with majority learning rates in this range which failed to
learn the dataset.

<!--
TODO:
> I think rather put a table only summarizing the ranges and conclusions for the
> hyperparameters of interest. You need to shorten the chapter.... Consider
> putting the hyperparameter graphs in an appendix and just putting the
> hyperparameter ranges in a table then you literally just say these are the
> hyperparameters found that had an impact and these did not and state why. So
> too few nodes to little capacity. To high or low learning rate divergence or it
> lears to slowly...... Then one or two supporting graphs in an appendix....
-->

HFFNNs with majority learning rates just beyond the range specified above
($[10^{-5}, 10^{-4.5}]$ or $[10^{-2.5}, 10^{-1.5}$) do still manage to learn
the dataset, but do so at a performance level that reduces as the majority
learning rate gets further from the optimal range of $[10^{-4.5}, 10^{-2.5}]$.

For the minority classifier, the range of optimal learning rates is similar
($[10^{-4}, 10^{-2}]$) however learning rates outside of this range generally
fare very poorly and fail to learn the data. The performance the minority
classifier is a lot more sensitive to sub-optimal learning rates than that of
the majority classifier. As with the majority classifier, having a minority
learning rate in the optimal range did not guarantee good performance, as it is
a necessary but not sufficient condition for a high $F_1$-score.

The best performing HFFNNs generally had both the minority and majority
learning rates in their respective optimal ranges.

<!--
TODO: there's not a whole lot of in-depth analysis going on here. Maybe you
need to add some plots just to show nothing's going on?
Make some plots of f1 vs hpar
-->

# Best performing 51-class classifier \label{sec:05-best-performing-51-class-classifier}

The performance of each of the five classification algorithms can be seen in
Figure \ref{fig:05_precision_recall_51_classes} (for those models trained on
all 51 classes).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_precision_recall_51_classes}}
    \caption[short caption todo]{Left: precision and recall for all model types trained on the full
    51 classes. Right: The $F_1$-scores for the same models, shown side-by-side
    for easier comparison.}
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
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_hpar_comparison_per_model_type}}
    \caption[short caption todo]{$F_1$-score for each model type on each set of hyperparameters
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
\ref{fig:05_best_hpar_comparison} shows the best performing 60 hyperparameters.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_best_hpar_comparison}}
    \caption[short caption todo]{Performance of hyperparameter combinations for the best performing
    60 hyperparameters. The black horizontal markers indicate the mean
    performance, and each dot indicates the performance on run.}
    \label{fig:05_best_hpar_comparison}
\end{figure}
<!-- prettier-ignore-end -->

It can be seen that the FFNNs are very prevalent amongst the best-performing
models. There are a few HFFNNs achieving good performance, and all SVMs
achieved approximately the same level of performance. The best SVMs generally
performed worse than the best neural network based models.

Given that the best 20 performing models are all FFNNs, it can be concluded
that well-tuned FFNNs perform the best on this dataset. It should be noted that
SVMs perform relatively well on the dataset, regardless of the hyperparameters
used. This is in stark contrast to neural network based methods which
outperform SVMs, but only after extensive hyperparameter tuning has been
performed.

The best performing hyperparameter combinations for each model type can be seen
in tables
\ref{tab:appendix_best_ffnn_hpars} (FFNN),
\ref{tab:appendix_best_majority_hffnn_hpars} (Majority classifier of the HFFNN),
\ref{tab:appendix_best_minority_hffnn_hpars} (Minority classifier of the HFFNN),
\ref{tab:appendix_best_svm_hpars} (SVM),
\ref{tab:appendix_best_hmm_hpars} (HMM), and
\ref{tab:appendix_best_cusum_hpars} (CuSUM).

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
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inf_trn_times_per_obs}
    \caption[short caption todo]{Duration in seconds per observation for each
    model type to perform inference and to be fit to the training dataset.}
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

<!--
TODO:
> why explain it is not a single cusum.....
-->

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
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_inference_time_per_obs_vs_f1}}
    \caption[short caption todo]{Inference time per observation for each model plotted against each
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
$F_1$-score to its validation $F_1$-score can be used to indicate whether a
change in the distribution of the dataset (as seen when comparing the training
and validation dataset) is likely to cause a change in performance. A model
that performs very well on the training dataset but very poorly on the
validation dataset is unlikely to perform well on unseen data.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_f1_vs_f1_ratio}}
    \caption[short caption todo]{$F_1$ ratio (training $F_1$ over validation $F_1$) for each model,
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

<!--
TODO:
> The neural networks are the most robust.... add somewhere
-->

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
than the validation $F_1$, indicating that these models are likely to perform
poorly on completely unseen datasets.

The higher the $F_1$ ratio, the more probable it is that the model would
perform well on completely unseen data. In plots b and d, it can be seen that
the SVMs tend to have a higher $F_1$ ratio. However, plot b shows that (within
certain clusters of models) the training $F_1$-score of SVMs is largely
uncorrelated with the validation $F_1$-score.

A possible explanation is that the SVMs are easily finding local maxima of
performance on the training dataset. However, these local maxima do not
properly convert to good performance on the validation dataset.

# Evaluation of models on the test set \label{test-set-eval}

Figure \ref{fig:05_tst_set_conf_mat} shows confusion matrix and the per-class
$F_1$-score, precision, and recall for the best performing hyperparameters
(hyperparameter index 73). The model's $F_1$-score is 0.753, its precision is
0.715, and its recall is 0.812.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_tst_set_conf_mat}
    \caption[short caption todo]{Confusion matrix and per-class $F_1$-score, precision, and recall
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
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_p_r_best_model}
    \caption[short caption todo]{Precision and recall for all 51 classes, as classified on the test
    set by the most performant model.}
    \label{fig:05_p_r_best_model}
\end{figure}
<!-- prettier-ignore-end -->

It is clear that there is no systematic bias in the model against any gestures
and that the gestures for which the model performs poorly is due to the data,
not some bias inherent in the model.

# English-language test data \label{real-world-data}

In addition to evaluating _Ergo_ on the unseen test data, the best found model
was run live as an example English-language sentence was gestured using the
device. Note that this is completely separate from the training, validation,
and testing datasets. This English-language example serves primarily as an
evaluation of the end-to-end process, and is therefore less thorough than the
datasets used for training, validation, and testing.

To accomplish this, _Ergo_ was worn by the user as they gestured the phrase
\texttt{"The quick brown fox jumped over the lazy dog"}. This phrase has no particular
meaning besides containing a wide variety of English letters. The raw sensor
data is streamed back to the user's computer where the The best found model is
run in real time and emitting gesture predictions based on the incoming sensor
values. These gesture predictions are converted to keystrokes using the gesture
to keystroke mapping and the resultant keystrokes emitted as though they were
regular keyboard input to the operating system.

For reproducibility, the raw sensor values are saved to disc. This allows
another (possibly different) model to later make predictions on the saved data
as though it were live data.

The full phrase is visible in the Appendix, (Figure
\ref{fig:appendix_pred_plot_0000_to_9420_full_text}) although due to the
duration of time covered and the speed with which any one gesture is made,
inspecting individual predictions is tricky. For this purpose, Figure
\ref{fig:05_pred_plot_0900_to_1800_quick} shows the prediction probabilities for
each of the 50 classes as well as the sensor values over the period when the
word \texttt{"quick "} (with a space at the end) was gestured. The prediction
probabilities look like vertical lines because due to the prediction frequency,
which results in 900 predictions over the course of the word \texttt{"quick "}. Each
gesture only lasts for one time step, so the predictions spike from 0% to 100%
for just that time step.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_pred_plot_0900_to_1800_quick}}
    \caption[short caption todo]{Time series plot of the sensor values and model predictions while
    gesturing the word \texttt{"quick "}. Spaces are shown with quotes. Top: each
    box shows the predicted keystroke and it's probability. Boxes are green if
    the probability is above 50\% and the prediction is correct and it is at
    the correct timestamp. Predictions which are either of too low probability,
    at the incorrect time, or plainly wrong have a red box. Bottom: Each box
    shows the ground truth keystroke and the class number in brackets.}
    \label{fig:05_pred_plot_0900_to_1800_quick}
\end{figure}
<!-- prettier-ignore-end -->

The FFNN correctly predicted the different keystrokes and did not often get
confused. Looking at the predictions for the letters "u" and "c", one can see
that immediately before or after a model predicts a class with high confidence,
it predicts that same class with low confidence. This is to be expected, as the
model input in sequential time steps is likely to be very similar.

Looking at the letters "q", "u", and "i", one can see that the baseline sensor
values do not change too much. This is because those three classes all have the
same orientation (they all start with the digit 3) and so the orientation of
the hands does not change from letter to letter. One can see the orientation of
the hands changing in between the letter "i" (class 37) and the letter "c"
(class 12), and then again from the letter "c" to the letter "k". The
orientation does change from the letter "k" to the space, but it quickly
changes back again.

Figure \ref{fig:05_eng_lang_phrase_conf_mat} shows the confusion matrix of the
English-language predictions.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_eng_lang_phrase_conf_mat}}
    \caption[short caption todo]{Confusion matrix of the best performing model predicting the
    gesture on the example English-language phrase \texttt{"the quick brown fox jumped
    over the lazy dog"}. Note that the confusion matrix does not have a value in
    every row as the chosen phrase does not contain every single gesture that
    can be performed.}
    \label{fig:05_eng_lang_phrase_conf_mat}
\end{figure}
<!-- prettier-ignore-end -->

While not every gesture was tested, the mistakes made on those gestures which
were tested are informative. For this particular dataset, mispredictions where
gesture 50 is predicted occurred for the classes 6 (a space) and 33 ("r" from
the word \texttt{"brown"}). All other classes had perfect recall. The bottommost row
represents time steps where the model predicted there was a gesture when there
was no gesture. This occurred for the classes 20 ("a" from \texttt{"lazy"}), 24 ("g"
from \texttt{"dog"}), 31 ("w" from \texttt{"brown"}), 32 ("e").

<!--
TODO:

> rather than a confusion matrix put a table with the phrase and then indicate
> if correct or misclassifier you can also indiocate characters created even if
> it was a non gesteure with a new column in table the way it is represented is
> hard to undersrtand and it takes up a lot of space.
-->
