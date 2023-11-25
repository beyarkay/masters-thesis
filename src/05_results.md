<!--

TODO: explain quickly why CuSUM isn't likely to be able to predict things
accurately due to how the sensor alert profiles work

TODO: lots of the models achieve near-zero but not actually zero $F_1$-score.
This is probably because they're just predicting everything is class 50

TODO Remove figures that haven't been referenced.

TODO: emphasise that "50-class classification" is a very different beast to
"51-class classification", and that the former shows performance comparable to
other methods in the literature, while the later represents state of the art,
in terms of gesture detection _and_ classification.

- TODO: Fit figures into margins
TODO(maybe): add back the English language dataset.


Feed-forward Neural Networks (FFNNs) scale well as the number of classes
increases (see Figure \ref{fig:05_inf_time_vs_num_classes}).

TODO: add footnote we discuss this figure in greater detail in section xxx. I do not
think this is the right place for this figure

TODO: one-vs-rest
> can scale quadratically depending on one-versus-one or one-versus-rest

TODO:
> Here SVMs seem to outperform neural nets. Remember a one-versus-rest SVM
> should outperform a neural network with the same number of features if the
> number of classes is small, as an SVM is a single layer neural network.
>
> From the plot it seems that SVM outperforms FFNN, which is not what you state
> later.

> Moreover how can SVM it become faster as #classes increase? You will
> effectively need 50 SVMs in background?

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

\epigraph{
    So the universe is not quite as you thought it was. You'd better rearrange
    your beliefs, then. Because you certainly can't rearrange the universe.
}{\textit{Isaac Asimov}}

This chapter will discuss the results obtained from the experiments described
in Chapter \ref{chap:methodology}. The performance of each model is
described in subsections
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
evaluates the best performing model on the unseen test set.

# Discussion of each model \label{sec:05-discussion-of-each-model}

This section will evaluate each model type (CuSUM, HMMs, SVMs, FFNNs, and
HFFNNs) in depth, but will not make comparisons between different model types.
Section \ref{sec:05-in-depth-cusum} discusses CuSUM, Section
\ref{sec:05-in-depth-hmm} discusses HMMs, Section \ref{sec:05-in-depth-svm}
discusses SVMs, Section \ref{sec:05-in-depth-ffnn} discusses FFNNs, and Section
\ref{sec:05-in-depth-hffnn} discusses HFFNNs,


## Cumulative Sum \label{sec:05-in-depth-cusum}

Figure \ref{fig:05_mean_conf_mat_cusum} shows the weighted confusion matrices for CuSUM
models trained on 5, 50, and 51 classes. The values in the weighted confusion matrices
are the weighted mean of all CuSUM models, with weights based on the
$F_1$-score of each CuSUM model. After the weighted sum, all columns were
independently normalised to sum to one.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_cusum}}
    \caption[CuSUM weighted confusion matrices]{The weighted confusion matrices
    of three CuSUM classifiers, trained on 5, 50, and 51 classes. The bottom
    right plot shows the precision-recall plot for the CuSUM, with each colour
    representing the CuSUM trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_cusum}
\end{figure}

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

The 50- and 51-class CuSUM models both perform poorly, displaying a
"chequerboard" pattern. This pattern also originates from the formulation of
the CuSUM model and happens when two model biases occur simultaneously: The
model must confuse gestures using fingers on the same hand (this causes
"blocks" of mispredictions along the principle diagonal), and the model must
confuse the orientation of the gesture (this causes the pattern along the
principle diagonal to be repeated orthogonally). Note that the density of
predictions inside each block are not uniform: there is a slight bias to the
diagonals within each block, indicating that the CuSUM models do have _some_
ability to distinguish different fingers on the same hand, although this
ability is not strong. Due to the poor performance of the 50- and 51-class
CuSUM models, only the hyperparameters of the 5-class CuSUM will be discussed.

### 5-class CuSUM Hyperparameter Analysis

Figure \ref{fig:05_hpar_analysis_cusum_classes5} shows the performance of all
5-class CuSUM models over varying values for its single hyperparameter, the
threshold value.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_cusum_classes5}
    \caption[5-class CuSUM precision-recall plots]{Left: precision-recall plot
    for all 5-class CuSUM models, with the value of the threshold
    hyperparameter indicated by the colour of the point. Right: a direct plot
    of the model's $F_1$-score against the threshold parameter.}
    \label{fig:05_hpar_analysis_cusum_classes5}
\end{figure}

One can see that increasing the value of the threshold hyperparameter improves
the performance of the model, although there are diminishing returns with an
inflexion point around a threshold value of 40. The maximum $F_1$-score of
0.989 is achieved with a threshold of 100, and the median $F_1$-score for CuSUM
models with a threshold of 100 is 0.937.

## Hidden Markov Models \label{sec:05-in-depth-hmm}

Figure \ref{fig:05_mean_conf_mat_hmm} shows the weighted confusion matrices for HMMs
trained on 5, 50, and 51 classes.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_hmm}}
    \caption[HMM weighted confusion matrices]{The weighted confusion matrices
    of three HMM classifiers, trained on 5, 50, and 51 classes. The bottom
    right plot shows the precision-recall plot for the HMMs, with each colour
    representing the HMMs trained on different numbers of classes.}
    \label{fig:05_mean_conf_mat_hmm}
\end{figure}

The 5-class HMMs are moderately strong classifiers, with a median $F_1$-score of
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

The 50-class HMMs are also moderately strong classifiers, with a median
$F_1$-score of $0.699$ and a maximum of $0.968$.

The 51-class HMMs shows poor performance, with a median $F_1$-score of $0.034$
and a maximum of $0.047$. This is because the majority of observations
belonging to class 50 are incorrectly classified as belonging to one of the
other gesture classes. This is indicated by the horizontal line at the bottom
of the 51-class confusion matrix in Figure \ref{fig:05_mean_conf_mat_hmm}, and
results in the 51-class HMMs having a greatly reduced precision.

Due to the poor performance of the 51-class HMMs, a detailed hyperparameter
analysis is not performed for them. Additionally, much of the insight that
could be gained from analysing the 5-class HMMs is also available when
analysing the 50-class HMMs, and so only a detailed analysis of the 50-class
HMMs is performed.

### 50-class HMM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_hmm_50_p_vs_r_covar_type} shows the
precision-recall plot for all 50-class HMMs, as well as the $F_1$-score
of each covariance type.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_50_p_vs_r_covar_type}
    \caption[50-class HMM precision recall plots]{Left: Precision-recall plot for all HMMs trained on 50 classes.
    Right: Plot of the model's $F_1$-score for each covariance matrix type.
    Note that the scales of the axes have been adjusted to better show the
    distribution of the data.}
    \label{fig:05_in_depth_hmm_50_p_vs_r_covar_type}
\end{figure}

The 50-class HMMs with tied covariance matrices performed well, with a median
$F_1$-score of 0.952 and a maximum of 0.968. The other covariance types
performed poorly, and the full covariance matrix HMMs have a very large
variance in their $F_1$-score. The spherical covariance matrix HMMs performed
better than the diagonal covariance matrix HMMs (this is also the case for the
5-class HMMs).

The good performance of the tied HMMs when compared to the other covariance
matrix type HMMs is likely because the ideal covariance matrix does not change
significantly from state to state, as the underlying distribution describing
the physically possible acceleration values does not change. Therefore, having
a single, full covariance matrix can efficiently describe the emissions for
each state without requiring the increased complexity required by having each
state represented by a different, full, covariance matrix.

Figure \ref{fig:05_in_depth_hmm_inf_trn_time_classes50} depicts the time taken
per observation for both fitting the HMM and making a prediction with that HMM.
The spherical and diagonal covariance types are faster than the tied and full
covariance types, both when training and when performing inference (a similar
effect was seen in the 5-class HMMs). This is to be expected, as the spherical
and diagonal covariance types have orders of magnitude fewer parameters than
the tied or full covariance types which impacts the time required for parameter
estimation as well as the time required to compute the maximum likelihood
emissions.

\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_in_depth_hmm_inf_trn_time_classes50}
    \caption[Fitting and training times for HMMs]{Duration in seconds per
    observation required to fit and to train the different covariance types for
    50-class HMMs.}
    \label{fig:05_in_depth_hmm_inf_trn_time_classes50}
\end{figure}

Figure \ref{fig:05_in_depth_hmm_conf_mats_cov_type_classes50} shows the
weighted confusion matrices for 50-class HMMs, with one plot for each of the
four covariance types.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_conf_mats_cov_type_classes50}
    \caption[50-class HMM weighted confusion matrices]{Weighted confusion
    matrices of all 50-class HMMs, with one confusion matrix per covariance
    type.}
    \label{fig:05_in_depth_hmm_conf_mats_cov_type_classes50}
\end{figure}

The spherical and diagonal covariance types show an interesting bias in their
predictions. The gestures made with the thumbs (4, 5, 14, 15, 24, 25, 34, 35,
44, 45) are better predicted than the gestures using other fingers. Gestures
using other fingers are more likely to be confused, and are generally confused
with gestures that use the correct orientation and the correct hand, but the
wrong finger. This can be explained by observing that the orientation of the
acceleration sensor on the thumbs is different to the orientation of the
acceleration sensor on the other fingers, and so is more distinct to the HMM
than the other gestures. This effect is also seen (although to a lesser degree)
in the confusion matrix of the full covariance type 50-class HMMs.

## Support Vector Machines \label{sec:05-in-depth-svm}

Figure \ref{fig:05_mean_conf_mat_svm} shows the weighted confusion matrices for
SVMs trained on 5, 50, and 51 classes.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_svm}}
    \caption[SVM weighted confusion matrices]{The weighted confusion matrices
    of three SVM classifiers, trained on 5, 50, and 51 classes. The bottom
    right plot shows the precision-recall plot for the SVMs, with each colour
    representing the SVM trained on different numbers of
    classes.}
    \label{fig:05_mean_conf_mat_svm}
\end{figure}

The 5-class SVM was easily able to classify the five different classes: the
median $F_1$-score was 1, as was the maximum, and the worst $F_1$-score was
0.909. Due to their near-perfect performance, no detailed analysis will be
performed on the 5-class SVMs; there is very little variance in the performance
of the 5-class SVMs which is explained by the hyperparameters.

The 50-class SVMs performed very well, with a minimum $F_1$-score of 0.955, a
median of 0.974, and a maximum of 0.989. The weighted confusion matrices for
the 50-class SVMs shows a slight bias towards mispredicting the orientation of
a gestures (as can be seen by the diagonals adjacent to the principle diagonal)
but otherwise show very good performance. The hyperparameters of the 50-class
SVMs will not be discussed further due to their performance being largely
independent of the hyperparameters.

The 50- and 51-class SVMs both made mispredictions where the orientation of a
gesture was incorrect, as can be seen by the diagonal lines of cells above and
below the main diagonal. The 51-class SVMs performed well, however many
mispredictions were made between class 50 and the gesture classes.

### 51-class SVM Hyperparameter Analysis

Figure \ref{fig:05_in_depth_svm_classes51} shows the precision, recall, and
$F_1$-score of the 51-class SVMs against the two hyperparameters of the SVMs:
the regularisation hyperparameter $C$ and whether or not the loss of
mispredicting an observation was weighted by the frequency of its class.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_classes51}
    \caption[51-class SVM precision and recall plots]{Left: precision and
    recall of all 51-class SVMs, with the regularisation parameter C and class
    weighting mapped to the colour and marker type respectively. Right: The
    regularisation parameter C plotted against the $F_1$-score of each SVM,
    with the class weight indicated by the marker shape. Note that the scale of
    the axes has been adjusted to better show the data.}
    \label{fig:05_in_depth_svm_classes51}
\end{figure}

The regularisation parameter C has only a small effect on the $F_1$-score, with
values below $10^{-4}$ consistently resulting in a decreased $F_1$-score. This
effect is independent of class weighting.

Looking at the precision-recall plot, there are two clear clusters caused by
the class weight hyperparameter. Balanced class weights have higher recall but
lower precision than unbalanced class weights. The $F_1$-score is unaffected by
whether or not the classes were balanced. Figure
\ref{fig:05_in_depth_svm_conf_mats_unbalanced_classes51} shows the weighted
confusion matrix for the balanced and unbalanced SVMs.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_svm_conf_mats_unbalanced_classes51}
    \caption[SVM weighted confusion matrices]{Weighted confusion matrices for
    SVMs with unbalanced (left) and balanced (right) class weights.}
    \label{fig:05_in_depth_svm_conf_mats_unbalanced_classes51}
\end{figure}

There is a strong primary diagonal of cells on both confusion matrices which
correlates to the relatively good performance of the SVMs. Looking at the
confusion matrix for the unbalanced SVMs, a strong row of cells at the bottom
of the matrix can be seen. This indicates that SVMs with unbalanced class
weights frequently mispredict observations which belong to class 50 as
belonging to one of the other gesture classes. This type of misclassification
increases the False Negative rate for class 50, which in turn lowers the
overall recall of the model due to the majority of the observations belonging
to class 50.

In a complementary manner, the column on the far right of confusion matrix of
the balanced SVMs indicates that many observations that are not in class 50 are
being predicted by the balanced SVMs as belonging in class 50. This type of
misclassification increases the False Positive rate for class 50, which in turn
lowers the overall precision of the model due to the majority of the
observations belonging to class 50.

Figure \ref{fig:05_svm_hpars_vs_fit_time} depicts the training and the
inference times for 51-class SVMs against the hyperparameter $C$ and the class
weight.

\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_svm_hpars_vs_fit_time}
    \caption[51-class SVM fitting times]{Left: Fit times against regularisation
    parameter C for all SVMs trained on 51 classes. Right: Inference time
    against regularisation parameter C.}
    \label{fig:05_svm_hpars_vs_fit_time}
\end{figure}

As the regularisation parameter C increases, the amount of time required to fit
the SVM increases to a plateau and then remains constant. The rate of increase
and the fit time at the plateau are both higher for balanced SVMs than for
unbalanced SVMs. This follows from the extra computation required to calculate
and apply a weight to every observation.

There is no relationship between the inference time and the class weight nor
the inference time and the regularisation coefficient C. This is to be
expected, as neither hyperparameter is used to perform inference.

## Feed-forward Neural Networks \label{sec:05-in-depth-ffnn}

Feed-forward Neural Networks (FFNNs) have nine hyperparameters (as described in
Table \ref{tab:04_hpar_dists_ffnn}), several of which were found to have no
influence on the performance of the FFNNs. These hyperparameters will not be
analysed. Figure \ref{fig:05_mean_conf_mat_ffnn} shows the mean confusion
matrices for all FFNNs trained on 5, 50, and 51 classes, weighted by that
model's $F_1$-score. The weighted confusion matrix for 5-class FFNNs shows good
performance, with little bias in its mispredictions, however the
precision-recall plot shows that the 5-class FFNNs had a large variance in
their performance, with a minimum $F_1$-score of 0.035, a median of 0.920, and
a maximum of 1.000.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_ffnn}}
    \caption[FFNN weighted confusion matrices]{The weighted confusion matrices
    of three FFNN classifiers, trained on 5, 50, and 51 classes. The bottom
    right plot shows the precision-recall plot for the FFNNs, with each colour
    representing the FFNNs trained on different numbers of
    classes.}
    \label{fig:05_mean_conf_mat_ffnn}
\end{figure}

The weighted confusion matrix for 50 classes also shows good performance, with
a minimum, median, and maximum $F_1$-score of 0.001, 0.440, and 0.997
respectively There is a bias in the mispredictions of the 50-class FFNN as
shown in its weighted confusion matrix by the two diagonals adjacent to the
principle diagonal. These two diagonals are offset from the principle diagonal
by exactly 10 classes, indicating they are gestures where the models
mispredicted the orientation of the gesture but correctly predicted the finger
of the gesture\footnote{
    For example, predicting a gesture made with the right hand's index finger
    at $0^\circ$ (gesture index 6) when the actual gesture was made with the
    right hand's index finger at $45^\circ$ (gesture index 16).
}.

The 51-class FFNNs achieved a minimum, median, and maximum $F_1$-score of
0.000221, 0.165, and 0.772 respectively. The confusion matrix for the 51-class
FFNNs shows many correct predictions (as indicated by the strong diagonal
sequence of cells). There are relatively few instances where a gesture class
was predicted as a different gesture class, but many instances where the
non-gesture class (class 50) was predicted as a gesture class. This is
indicated by the row at the bottom of the confusion matrix. There are also a
number of mispredictions where one of the classes $0, 1, \ldots, 49$ were
classified as class 50. This is indicated by the column at the right of the
confusion matrix. There are relatively few mispredictions where one gesture
class is mispredicted as belonging to another gesture class.

### 5-class FFNN Hyperparameter Analysis

For 5-class FFNN, the following hyperparameters showed no significant
relationship with the model's $F_1$-score: dropout rate, L2 coefficient, batch
size, number of layers, and the number of nodes in any layer. Interested
readers are referred to the Appendix (Figure
\ref{fig:appendix_ffnn_hpar_analyis_classes5}) for an unabridged plot of these
hyperparameters. Figure \ref{fig:05_hpar_analysis_ffnn_classes5_lr} shows the
learning rate of the 5-class FFNNs against the model's validation loss and
$F_1$-score.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes5_lr}
    \caption[FFNN 5-class learning rate vs validation loss]{Left: The learning
    rate of the 5-class FFNNs against their $F_1$-score. Right: The learning
    rate of the 5-class FFNNs against their validation loss.}
    \label{fig:05_hpar_analysis_ffnn_classes5_lr}
\end{figure}

It is clear that a learning rate outside of the range $[10^{-4}, 10^{-1.5}]$ is
either too large or too small for the 5-class FFNNs to learn the data at all.
Models with learning rates outside of this range resulted in very high
validation loss and very low $F_1$-scores. The validation-loss vs learning rate
plot makes it clear that a learning rate in the range of $[10^{-4}, 10^{-1.5}]$
is necessary but not sufficient for a 5-class FFNN to perform well on the
validation dataset.

### 50-class FFNN Hyperparameter Analysis

For the 50-class FFNNs, the following hyperparameters showed no significant
relationship with the model's $F_1$-score: dropout rate, L2 coefficient, batch
size. The number of nodes per layer had little impact on the ability of the
50-class FFNNs to fit to the data, provided that they had more than 10 nodes
per layer. Interested readers are referred to the Appendix (Figure
\ref{fig:appendix_ffnn_hpar_analyis_classes50}) for unabridged plot of these
hyperparameters. Figure \ref{fig:05_hpar_analysis_ffnn_classes50_lr} shows the
learning rate of the 50-class FFNNs against the model's validation loss and
$F_1$-score.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_lr}
    \caption[50-class FFNN learning rate vs $F_1$-score]{Left: The learning
    rate of the 50-class FFNNs against their $F_1$-score. Right: The learning
    rate of the 50-class FFNNs against their validation loss.}
    \label{fig:05_hpar_analysis_ffnn_classes50_lr}
\end{figure}

As with the 5-class FFNNs, there is a clear range of learning rates between
$10^{-3.5}$ and $10^{-1.5}$ with improved $F_1$-scores and validation losses.
This range is very similar to the learning rate range for the 5-class FFNNs,
indicating that the optimal learning rate range is dependant on the dataset and
not not very dependant on the model architecture. Once again, it's important to
note that models within this range are not guaranteed to fit the data
successfully. Having a learning rate between $10^{-3.5}$ and $10^{-1.5}$ is
necessary but not by itself sufficient for achieving good performance in a
50-class model.

In addition to the learning rate, the number of layers in the 50-class network
has an impact on the performance of the respective FFNN. Figure
\ref{fig:05_hpar_analysis_ffnn_classes50_nlayers} shows the number of layers in
the 50-class FFNNs against the model's validation loss and $F_1$-score.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_nlayers}
    \caption[50-class FFNN number of layers vs $F_1$-score]{Left: The number of
    layers in the 50-class FFNNs against their $F_1$-score. Right: The number
    of layers in the 50-class FFNNs against their  validation loss.}
    \label{fig:05_hpar_analysis_ffnn_classes50_nlayers}
\end{figure}

Models with one, two, or three layers were all able to learn the data and
achieve a high $F_1$-score, however this was more frequent with models with one
or two layers. Models with three layers were also unable to achieve a
validation loss as low as some of the models with one or two layers. This is
likely due to the increased probability of any one layer having far too few
nodes to effectively model the data, leading to a bottleneck and reduced
performance.

### 51-class FFNN Hyperparameter Analysis

Complex interactions were found between the various hyperparameters of the
51-class FFNNs and their $F_1$-scores, and will be discussed individually. The
Appendix contains a plot of all hyperparameters against the $F_1$-score (Figure
\ref{fig:appendix_ffnn_hpar_analyis_classes51}) as well as a plot of all
hyperparameters against one another (Figure
\ref{fig:appendix_hpar_analysis_ffnn_pairplot}) for the interested reader.

<!---                       precision-recall density per nlayers           --->

To investigate the distribution of precision and recall values for 51-class
FFNNs with 1, 2, and 3 layers, Figure
\ref{fig:05_51ffnn,x=p,y=r,c=nlayers,histplot} shows a precision-recall heatmap
for each of the 1-, 2-, and 3-layer FFNNs. The colour of each cell represents
the number of FFNNs with that combination of precision and recall, and empty
cells indicate no FFNNs had that combination of precision and recall

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=p,y=r,c=nlayers,histplot}}
    \caption[51-class FFNN per-class evaluation metrics]{Precision-recall
    heatmap for the 1-, 2-, and 3-layer 51-class FFNNs. The colour of each cell
    indicates the number of observations in that region, according to the
    shared colourbar on the right of the plot.}
    \label{fig:05_51ffnn,x=p,y=r,c=nlayers,histplot}
\end{figure}

The 1-layer FFNNs have the smallest proportion of poor-performing FFNNs (as
indicated by the low density of 1-layer FFNNs near the bottom left of the
plot), followed by the 2- and then the 3-layer FFNNs. The majority of 3-layer
FFNNs did not manage to fit to the data, achieving nearly zero precision and
recall. However, the best 3-layer 51-class FFNNs achieved nearly the same
performance as the best 2- and 1-layer 51-class FFNNs. Note that while the
recall of the 3-layer 51-class FFNNs is better than the recall of the 1-layer
FFNNs, the precision is significantly worse, resulting in the 3-layer FFNNs
having a worse $F_1$-score than the 1-layer FFNNs.

<!---                       Number of layers                           --->

Figure \ref{fig:05_51ffnn,x=p,y=r,h=nlayers} shows the $F_1$-score and
precision-recall plot for all 51-class FFNNs, coloured based on the number of
layers of each FFNN.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=p,y=r,h=nlayers}
    \caption[51-class FFNN precision and recall plot]{$F_1$ plot and
    precision-recall scatter plot for all 51-class FFNNs, with the colour of
    the markers based on the number of layers in that FFNN.}
    \label{fig:05_51ffnn,x=p,y=r,h=nlayers}
\end{figure}

The best $F_1$-score achieved by any 51-class FFNN is 0.772, the median is
0.165, and the minimum is 0.0002. There is a cluster of high-performing FFNNs
with a recall greater than 0.7. It might be assumed that this cluster is a
result of just one hyperparameter being in the correct range of values, however
this is not the case. To explore the relationship between the hyperparameters
and the $F_1$-score, it is informative to look at a plot of each
hyperparameter, with the FFNNs coloured based on whether they belong to this
cluster or not.

<!---- Split violin plots of recall > 0.7 --->

#### Hyperparameters causing the cluster around recall > 0.7

Figure \ref{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70} shows a set of scatter
plots, with one plot for each hyperparameter and with each point coloured based
on whether the corresponding FFNN belongs to the performant cluster or not.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,c=hpar,x=hpar,y=recall>70}}
    \caption[51-class FFNNs hyperparameter scatter plot]{Scatter plots of each
    of the hyperparameters for the 51-class FFNNs, where blue shows the points
    for FFNNs with a recall greater than 0.7, and orange shows the points for
    FFNNs with a recall less than 0.7. While one can see ranges of
    hyperparameter values which often result in a recall greater than 0.7,
    there are no hyperparameter ranges which entirely explain good
    performance.}
    \label{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70}
\end{figure}

Blue points  have a recall greater than 0.7 and therefore belong to the cluster
of performant 51-class FFNNs seen in Figure
\ref{fig:05_51ffnn,x=p,y=r,h=nlayers}. All other points are orange. If there
were one hyperparameter which caused a FFNN to achieve a recall greater than
0.7 (independent of the values of all other hyperparameters), then Figure
\ref{fig:05_51ffnn,c=hpar,x=hpar,y=recall>70} would show this as a cluster of
performant FFNNs surrounded by non-performant FFNNs. This is not the case, and
any range of any hyperparameter that exhibits good performance also exhibits
bad performance (such as a learning rate between $10^{-5}$ and $10^{-3}$). From
this we can conclude that there is no single hyperparameter which causes good
performance independent of the values of all other hyperparameters. To aid
further investigation, we will examine the 1-, 2-, and 3-layer FFNNs
separately.

<!---- Hyperparameter-f1 scatter plot for nlayers == 1 --->

#### Performance for 1-layer FFNNs

Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=1} shows the $F_1$-score
of each 1-layer FFNN against all hyperparameters, where each plot describes a
different hyperparameter.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=1}}
    \caption[51-class FFNN all hyperparameters (1 layer)]{$F_1$-score against
    all hyperparameters for all 51-class FFNNs with 1 layer. Each plot
    represents a different hyperparameter.}
    \label{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=1}
\end{figure}

The batch size, L2 coefficient, and dropout rate all had very little effect on
the performance of the FFNNs. The learning rate and the number of nodes in
layer 1 did have an effect on the $F_1$-score, where FFNNs with learning rates
between $10^{-4}$ and $10^{-2.5}$ or more than $10^{1.5}\approx 30$ nodes in
the first layer performing well. The maximum recall, precision, and $F_1$-score
achieved by the 1-layer FFNNs is 0.865, 0.736, and 0.772 respectively.

<!---- Hyperparameter-f1 scatter plot for nlayers == 2 --->

#### Performance of the 2-layer FFNNs

Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2} shows the
$F_1$-score of each 2-layer FFNN against all hyperparameters, where each plot
describes a different hyperparameter.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2}}
    \caption[51-class FFNNs all hyperparameters (2 layers)]{$F_1$-score against
    all hyperparameters for all 51-class FFNNs with 2 layers. Each plot
    represents a different hyperparameter.}
    \label{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2}
\end{figure}

The 2-layer FFNNs had a higher recall than the 1-layer FFNNs but otherwise
performed worse: the maximum recall, precision, and $F_1$-score achieved by the
2-layer FFNNs is 0.921, 0.678, and 0.745 respectively. The learning rate of the
2-layer FFNNs appears to have a wide range of values for which a good
$F_1$-score was achieved (between $10^{-5}$ and $10^{-2.5}$), and then a
smaller subset for which the best 2-layer FFNN $F_1$-score was achieved
(between $10^{-4.25}$ and $10^{-3}$). This effect will be better explored in
Figure \ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} by looking at the
precision-recall scatter plot for 1-, 2-, and 3-layer FFNNs. Having sufficient
nodes ($>10^{1.5} \approx 30$) in the first or second layer of the 2-layer FFNN
was also necessary for a good $F_1$-score. The batch size, L2 coefficient, and
dropout rate all had a negligible effect on the $F_1$-score.

<!---- Hyperparameter-f1 scatter plot for nlayers == 3 --->

#### Performance for 3-layer FFNNs

Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=3} shows the
$F_1$-score of each 3-layer FFNN against all hyperparameters, where each plot
describes a different hyperparameter.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=3}}
    \caption[51-class FFNNs all her parameters (3 layers)]{$F_1$-score against
    all hyperparameters for all 51-class FFNNs with 3 layers. Each plot
    represents a different hyperparameter.}
    \label{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=3}
\end{figure}

The 3-layer FFNNs had a higher recall than the 1- and 2-layer FFNNs but
otherwise performed worse: the maximum recall, precision, and $F_1$-score
achieved by the 3-layer FFNNs is 0.933, 0.685, and 0.742 respectively. The
learning rate of the 3-layer FFNNs has a very precise range of values for which
a good $F_1$-score was achieved (between $10^{-4}$ and $10^{-3}$). This effect
will be better explored in Figure \ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} by
looking at the precision-recall scatter plot for 1-, 2-, and 3-layer FFNNs. The
number of nodes in the third layer of the 3-layer FFNNs seems to have little
impact on their performance. The first and second layers only require than more
than $10$ nodes are present. Beyond this point, increasing the number of nodes
has little impact on the performance of the FFNN. The dropout rate has a large
impact on the $F_1$-score, and the majority of well-performing 3-layer FFNNs
had a dropout rate below 0.25. The batch size, and L2 coefficient had a
negligible effect on the $F_1$-score.

<!---                       LR vs npl1                           --->

#### Interactions between the Learning Rate and Nodes in Layer 1

Figure \ref{fig:05_51ffnn_x=lr,y=npl1,h=f1} shows the learning rate of all
51-class FFNNs against the number of nodes in layer 1, with the colour of each
point indicating the validation $F_1$-score of that FFNN.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51ffnn_x=lr,y=npl1,h=f1}}
    \caption[51-class FFNNs learning rate vs number of nodes]{The learning rate
    against the number of nodes in the first layer of all 51-class FFNNs, with
    the colour of each point indicating the $F_1$-score. Note that a small
    amount of random noise has been applied to the hyperparameters (but not the
    $F_1$-score) as this prevents points with identical hyperparameters from
    occluding one another. Points have identical hyperparameters due to 5-fold
    repetition during cross validation.}
    \label{fig:05_51ffnn_x=lr,y=npl1,h=f1}
\end{figure}

One can see a "U" shape of high-$F_1$-scoring FFNNs. This indicates that
the range of learning rates which result in good performance shrinks as the
number of nodes decreases.

<!---                    precision-recall hue=nlayers                      --->

#### Performance vs the Number of Layers and Learning Rate

Figure \ref{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers} plots the precision and
recall for 1-, 2-, and 3-layer FFNNs, with the colour of each point indicating
the learning rate.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_51ffnn,x=p,y=r,h=lr,c=nlayers}}
    \caption[51-class precision-recall scatter plots]{Precision-recall
    scatterplots with the colour indicating the learning rate according to the
    shared colour bar on the right. Each plot represents all 51-class FFNNs
    with 1-, 2-, or 3-layers. Note the cluster of high-precision and
    high-recall FFNNs that happens with the 1- and 2-layer FFNNs.}
    \label{fig:05_51ffnn,x=p,y=r,h=lr,c=nlayers}
\end{figure}

The 1- and 2-layer FFNNs both have dense clusters of high-precision,
high-recall FFNNs. The plot of the 1-layer FFNNs emphasises what has already
been discussed, that the 1-layer FFNNs generally require a learning rate
between $10^{-2.5}$ and $10^{-4.5}$ in order to achieve a high $F_1$-score.

The plot of the 2-layer FFNNs clearly shows two clusters of high-recall,
high-precision FFNNs. The better-performing of these two clusters has a
learning rate between $10^{-4.75}$ and $10^{-3.75}$. The worse-performing
cluster has a learning rate either significantly greater (around $10^{-5}$) or
significantly lower (around $10^{-2.75}$) than the first. This was also visible
in Figure \ref{fig:05_51ffnn,x=hpar,y=f1,c=hpar,nlayers=2}, although it is
clearer when the precision and recall are plotted individually.

There are not as many high-performing 3-layer FFNNs as there are 1- or 2-layer
FFNNs. This makes it difficult to distinguish any patterns seen amongst the
high-performing 3-layer FFNNs from the noise. While their recall is generally
better than that of the 1-layer FFNNs, their precision is significantly worse.
The reduced performance of the 3-layer FFNNs when compared to the 2- or 3-layer
FFNNs may also be attributed to the ranges of the hyperparameters simply not
including the optimal hyperparameter values for the 3-layer FFNNs.

## Hierarchical Feed Forward Neural Networks \label{sec:05-in-depth-hffnn}

The HFFNNs have over twice as many hyperparameters as the FFNNs. For this
reason, hyperparameters which show no relationship to any evaluation metric
will be excluded from the analysis.

Figure \ref{fig:05_mean_conf_mat_hffnn} shows the weighted confusion matrices for HFFNN
models trained on 51 classes. HFFNNs were not trained on 5 or 50 classes, as
that is equivalent to training a FFNN on 5 or 50 classes.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_mean_conf_mat_hffnn}}
    \caption[51-class FFNN weighted confusion matrix]{The weighted confusion
    matrices of 51-class HFFNN classifier.}
    \label{fig:05_mean_conf_mat_hffnn}
\end{figure}

HFFNNs perform well, however there are faint offset diagonals showing a
tendency to mispredict the orientation of a gesture. There are also a large
number of misclassifications where class 50 was predicted as one of the other
gesture classes.

### 51-class HFFNN Hyperparameter Analysis

<!--------------------------Maj nlayers vs Min nlayers----------------------------->

Figure \ref{fig:05_51hffnn,x=nlayers,y=f1,h=nlayers,c=majmin} shows the
precision, recall, and $F_1$-score of all HFFNNs, split by the number of layers
in their majority and minority classifiers.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51hffnn,x=nlayers,y=f1,h=nlayers,c=majmin}}
    \caption[51-class HFFNNs number of layers]{Top row: $F_1$-score of all HFFNNs,
    against the number of layers in their majority and minority classifiers.
    Bottom row: Precision-recall plots of all HFFNNs, against the number of layers
    in their majority and minority classifiers. Left column: The colour of each
    marker indicates the number of layers in the minority classifier. Right
    column: The colour of each marker indicates the number of layers in the
    majority classifier.}
    \label{fig:05_51hffnn,x=nlayers,y=f1,h=nlayers,c=majmin}
\end{figure}

Looking at the top-left plot, which splits the HFFNNs by the number of layers
in their majority classifier, we can see that HFFNNs with 3-layer majority
classifiers perform worse than HFFNNs with 1- or 2-layer majority classifiers.
The bottom-right plot supports this, showing that best precision and recall of
the HFFNNs with 3-layer majority classifiers (indicated in green) is less than
the best precision and recall of HFFNNs with 2- or 3-layer majority
classifiers.

Looking at the top-right plot, it is clear that there are many performant
HFFNNs with HFFNNs with 1-layer minority classifiers. While good performance is
achieved regardless of the number of layers in the minority classifier, good
performance is more common amongst HFFNNs with 1-layer minority classifiers. It
is likely that the minority classifier is more able to make use of additional
layers than the majority classifier because there are so many classes that need
to be distinguished by the minority classifier.

<!--------------------------Nodes in last layer----------------------------->

Figure \ref{fig:05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin} shows the number of
nodes in the last layer of the majority and minority classifiers for all
51-class HFFNNs.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin}}
    \caption[51-class HFFNN $F_1$-scores vs number of nodes]{The top row shows
    the $F_1$-scores on the y-axis plotted against the number of nodes in the
    last layer of the majority/minority classifier (x-axis), and with the
    colour of each point indicating the number of nodes in the last layer of
    the minority/majority classifier. The bottom plot shows the interactions
    between the number of nodes in the last layer of the majority (x-axis) and
    minority (y-axis) classifiers, with the $F_1$-score indicated by the colour
    of each point.}
    \label{fig:05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin}
\end{figure}

Overall there is very little connection between the number of nodes in the last
layer of either the majority or minority classifier and the performance of the
overall FFNN. Looking at the top-right plot, it is possible that there is a
positive relationship between the number of nodes in the last layer of the
minority classifier and the $F_1$-score, however this effect is slight. Looking
at the top-left plot, it can be seen that the $F_1$-score of an HFFNN is
usually reduced when there is a large number of nodes ($>10^2.5$) in the last
layer of the majority classifier.

The bottom-left plot of Figure
\ref{fig:05_51hffnn,x=npl-1,y=f1,h=majmin,c=majmin} shows the number of nodes
in the last layer of the majority and minority classifiers plotted against each
other, with the colour of each point indicating the $F_1$-score of the HFFNN.
There are no well-performing HFFNNs with fewer than 10 nodes in the last layer
of both the majority and minority classifiers (as seen by the lack of
high-performing HFFNNs in the bottom left of the plot). This is to be expected,
as some amount of capacity is required for the classifiers to be able to learn
the data. HFFNNs with very few ($<10$) nodes in the last layer of the majority
classifier are still able to perform well if the number of nodes in the last
layer of the minority classifier is sufficiently high ($>10^{1.5}$).

<!--------------------------Maj LR vs Min LR----------------------------->

Figure \ref{fig:05_51hffnn,x=lr,y=f1,h=lr,c=majmin} shows the 51-class HFFNNs
learning rates of the majority and minority classifiers against the
$F_1$-scores.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51hffnn,x=lr,y=f1,h=lr,c=majmin}}
    \caption[51-class HFFNNs learning rate against $F_1$-score]{The top row
    shows the $F_1$-scores on the y-axis plotted against
    the learning rate of the majority/minority classifier (x-axis), and with
    the colour of each point indicating the learning rate of the
    minority/majority classifier. The bottom plot shows the interactions
    between the learning rate of the majority (x-axis) and minority (y-axis)
    classifiers, with the $F_1$-score indicated by the colour of each point.}
    \label{fig:05_51hffnn,x=lr,y=f1,h=lr,c=majmin}
\end{figure}

For the majority classifier, there is a wide range of learning rates (between
$10^{-4.5}$ and $10^{-2.5}$) for which the HFFNN will learn the dataset. While
all high-performing HFFNNs did have a majority learning rate in this range,
this condition is not sufficient for a HFFNN to perform well.

HFFNNs with majority learning rates just beyond the aforementioned range do
still manage to learn the dataset, but do so at a performance level that
reduces as the majority learning rate gets further from that range.

For the minority classifier, the range of optimal learning rates is similar
(between $10^{-4}$ and $10^{-2}$) however learning rates outside of this
range generally fare very poorly and fail to learn the data. The performance
the minority classifier is a lot more sensitive to sub-optimal learning rates
than that of the majority classifier. As with the majority classifier, having a
minority learning rate in the optimal range did not guarantee good performance.

The bottom left plot shows that the best performing HFFNNs generally had both
the minority and majority learning rates in their respective optimal ranges,
and that having learning rates in this range is often enough to result in good
performance.

# Best performing 51-class classifier \label{sec:05-best-performing-51-class-classifier}

The performance of each of the five classification algorithms can be seen in
Figure \ref{fig:05_precision_recall_51_classes} (for those models trained on
all 51 classes).

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_precision_recall_51_classes}}
    \caption[51-class precision and recall for all models]{Left: The
    $F_1$-scores all model types trained on 51 classes. Right: The precision
    and recall for all model types trained on the 51 classes.}
    \label{fig:05_precision_recall_51_classes}
\end{figure}

From these plots we can see that FFNNs, SVMs, and HFFNNs perform competitively.
HMMs achieve high recall but struggle with precision, and CuSUM does poorly
although achieves much higher recall than precision.

The two neural network based models (FFNN and HFFNN) perform similarly, as is
to be expected from their similar architecture. However, the two-model HFFNN
performed worse than the single model FFNN. This is likely due to the HFFNN
having a larger number of hyperparameters to tune, making it difficult to find
a well-performing model. As was seen during the HFFNN hyperparameter analysis,
multiple hyperparameters need to be in the optimal range for good performance.
The HFFNN has more hyperparameters which can impact its performance, thereby
increasing the probability of any one hyperparameter being poorly chosen.

The neural network-based models have a far larger hyperparameter space when
compared to the hyperparameters for SVMs/HMMs/CuSUM. This largely explains the
large variance seen in the performance of the neural network-based models.

Each model, and each set of hyperparameters, was trained on and evaluated on
five different subsets of the training-validation dataset, resulting in five
different validation sets and five different training sets for each
hyperparameter combination. Each unique hyperparameter combination is assigned
a hyperparameter index to identify it. The best performing hyperparameter
combinations for each model type can be seen in tables
\ref{tab:appendix_best_ffnn_hpars} (FFNN),
\ref{tab:appendix_best_majority_hffnn_hpars} (Majority classifier of the HFFNN),
\ref{tab:appendix_best_minority_hffnn_hpars} (Minority classifier of the HFFNN),
\ref{tab:appendix_best_svm_hpars} (SVM),
\ref{tab:appendix_best_hmm_hpars} (HMM), and
\ref{tab:appendix_best_cusum_hpars} (CuSUM).

The individual performances of all training runs are shown as points in Figure
\ref{fig:05_hpar_comparison_per_model_type}. The black horizontal bars indicate
the mean of each set of hyperparameters. Model types with discrete
hyperparameters (such as the HMM and CuSUM) has some sets of hyperparameters
were evaluated more than five times due to the finite size of the
hyperparameter space.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_comparison_per_model_type}}
    \caption[$F_1$-scores for all hyperparameter sets]{$F_1$-score for each
    model type on each set of hyperparameters
    that were tested. The black horizontal
    bar indicates the mean $F_1$-score for one set of hyperparameters, and the
    hyperparameters are ordered by the lower bound of the 90\% confidence
    interval.}
    \label{fig:05_hpar_comparison_per_model_type}
\end{figure}

One can clearly see that the FFNNs, HFFNNs, and SVMs all perform well. Figure
\ref{fig:05_best_hpar_comparison} shows only the best performing 50
hyperparameters.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_best_hpar_comparison}}
    \caption[Best performing 50 hyperparameter combinations]{Performance of
    hyperparameter combinations for the best performing 50 hyperparameters.}
    \label{fig:05_best_hpar_comparison}
\end{figure}

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

# Comparison of the inference and training times for each model \label{time-comparison}

Raw performance is not the only metric of interest, as _Ergo_ requires
real-time prediction at a rate of 40 predictions per second so that it can keep
up with the incoming data. There were significant technical problems with the
Hidden Markov Models due to the volume of observations being trained on. This
necessitated that the HMMs be trained on only 1000 randomly selected
observations of the non-gesture class (all other classes were trained on the
full number of observations in the training dataset). Even with this, the
training times are significantly longer than any other model. Figure
\ref{fig:05_inf_trn_times_per_obs} shows the training times and inference times
per observation for each model on the training and validation dataset.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inf_trn_times_per_obs}
    \caption[Inference and training times for each model type]{Duration in
    seconds per observation for each model type to perform inference and to be
    fit to the training dataset.}
    \label{fig:05_inf_trn_times_per_obs}
\end{figure}

As was seen in Section \ref{50-class-hmm-hyperparameter-analysis}, the fitting
and inference times of HMMs is highly dependant on the covariance type
hyperparameter. This is again apparent in Figure
\ref{fig:05_inf_trn_times_per_obs}, as we can see two clusters of HMMs. One
cluster takes about 0.1 seconds to perform inference per observation, the other
cluster takes about 0.01 seconds. The faster HMMs would be fast enough for
real-time inference, however it has already been shown in Section
\ref{sec:05-in-depth-hmm} that the 51-class HMMs do not perform well enough to
be considered for prediction.

All other models easily perform inference fast enough to meet the 40
predictions per second threshold. It should be noted that the CuSUM models are
slower than the SVMs, the FFNNs, and the HFFNNs. This is due to the fact that
it is not one CuSUM algorithm, but multiple. As the original CuSUM algorithm is
a one-sided univariate out-of-distribution detection algorithm, 3 000 CuSUM
algorithms are executed for each prediction (30 dimensional time series
$\times$ two-sided detection $\times$ 50 classes).

From the plot on the right in Figure \ref{fig:05_inf_trn_times_per_obs}, it can
be seen that the slow HMMs take an order of magnitude more time to fit than the
other HMMs and the other models. All the other models take between 0.01 and
0.001 seconds per observation to fit to the data.

Regardless of the relative speed of each model, the absolute speed of every
SVM, FFNN, and HFFNN is more than sufficient for real-time prediction with
_Ergo_. The absolute speed of CuSUM is likely sufficient for _Ergo_, however
imposing additional workload on the relevant machine or running the software on
less performant hardware might cause problems. The HMMs are not fast enough for
real-time predictions, however a compromise might be made by only attempting
inference on every other timestep, thereby reducing the performance required at
the cost of a less responsive system.

# Comparison of the validation:training ratios for each model \label{ratio-comparison}

Figure \ref{fig:05_f1_vs_f1_ratio} shows the validation and training
$F_1$-scores for every model trained all 51 classes. The ratio of a model's
training $F_1$-score to its validation $F_1$-score can be used to indicate
whether a change in the distribution of the dataset (as seen when comparing the
training and validation dataset) is likely to cause a change in performance. A
model that performs very well on the training dataset but very poorly on the
validation dataset is unlikely to perform well on unseen data (such as the test
set).

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_f1_vs_f1_ratio}}
    \caption[$F_1$-ratio per model]{$F_1$ ratio (training $F_1$ over validation
    $F_1$) for each model, coloured by the model type. The plots in the
    leftmost column show the full range of their data, while the plots in the
    rightmost column show only a subset of the data. Note that because CuSUM
    performed so poorly, it is mostly obscured by the other models.}
    \label{fig:05_f1_vs_f1_ratio}
\end{figure}

The HMMs have a much higher training $F_1$-score than validation $F_1$-score;
this is due to the training dataset for HMMs not containing every observation
of the non-gesture class (as discussed in Section \ref{model-specifics-hmm}),
leading to inflated training metrics. The validation set _does_ include every
observation of the non-gesture class, and so the validation $F_1$-score is an
accurate depiction of the model's performance.

Models which performed poorly on the training dataset ($F_1 < 0.5$) also
performed poorly on the validation dataset, as can be seen with the $F_1$-ratio
being near 1 for the majority of those models with an $F_1$-score less than
0.5.

The plots in the rightmost column highlight the region where $F_1 > 0.5$,
showing two clusters for the SVM models, corresponding the class weight
hyperparameter and to a lesser extent, the value of the regularisation
hyperparameter $C$. The SVMs achieved very high training $F_1$-scores but
mediocre validation $F_1$-scores indicating that they overfit on the training
dataset (regardless of the amount of regularisation applied).

The FFNNs and the HFFNNs are approximately clustered together and achieve
similar training and validation $F_1$-scores, however the FFNNs perform
slightly better, and are the most robust against unseen data.

# Evaluation of models on the test set \label{test-set-eval}

Figure \ref{fig:05_tst_set_conf_mat} shows confusion matrix and the per-class
$F_1$-score, precision, and recall for the best performing model (a FFNN,
hyperparameter index 73). The model's $F_1$-score is 0.753, its precision is
0.715, and its recall is 0.812.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_tst_set_conf_mat}
    \caption[Test dataset confusion matrix for best performing model]{Confusion
    matrix and per-class $F_1$-score, precision, and recall for the
    best-performing model on the unseen test data.}
    \label{fig:05_tst_set_conf_mat}
\end{figure}

The model performs well on the test set, with the majority of mispredictions
being between the non-gesture class and the gesture classes. The heatmap at the
bottom of Figure \ref{fig:05_tst_set_conf_mat} shows the per-class recall,
precision, and $F_1$-scores. Gesture classes 0, 19, and 45 performed worse than
the other gesture classes, although the cause is not readily apparent. Figure
\ref{fig:05_p_r_best_model} shows the precision and recall as a scatter plot
for each gesture.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_p_r_best_model}
    \caption[Best model's precision and recall per class]{Precision and recall
    for all 51 classes, as classified on the test set by the most performant
    model.}
    \label{fig:05_p_r_best_model}
\end{figure}

It is clear that there is no systematic bias in the model against any gestures
and that the gestures for which the model performs poorly is due to the data,
not some bias inherent in the model.

To evaluate this model on an English-language dataset, the following phrase was
gestured as the model made predictions, all in real time:

> the quick brown fox jumped over the lazy dog

Figure \ref{fig:05_pred_plot_7400_to_8500_lazy} shows the prediction
probabilities and sensor values for the word "lazy ". There are several points
to note here.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_pred_plot_7400_to_8500_lazy}}
    \caption[Best model predictions and probabilities for "lazy"]{Time series
    plot of the sensor values and model predictions while gesturing the word
    "lazy ". Spaces are shown with quotes. Top: each box shows the predicted
    keystroke and it's probability. Boxes are green if the probability is above
    50\% and the prediction is correct and it is at the correct timestamp.
    Predictions which are either of too low probability, at the incorrect time,
    or plainly wrong have a red box. Bottom: Each box shows the ground truth
    keystroke and the class number in brackets.}
    \label{fig:05_pred_plot_7400_to_8500_lazy}
\end{figure}

The first prediction, that of the letter "l", predicted "l" with 76% and "o"
with 17%. When multiple prediction probabilities for a given time step are
greater than 10% (and are not class 50), they are all drawn within the same
box.

The classes for "l" and "o" are 28 and 38 respectively, meaning that the same
finger is used, and only the orientation of the hand differs between them. As
the two classes are similar to one another, it is not unexpected that the model
emits a low probability for "o" when "l" is gestured. It is also entirely
possible that the actual performed gesture was slightly more similar to the
gesture for "o" than usual.

The letter "a" is predicted with 61% probability at one time step and then is
predicted with 97% probability at another time step. The fact that there are
two boxes indicate that the predictions are done at different time steps. Only
the one prediction is marked as "correct", because that is the timestep which
aligned with the ground truth label. As _Ergo_ does not emit keystrokes for
repeated predictions, the end user would be completely unaware of this double
prediction. A similar situation happens for the keystroke "z", where there is a
high probability and low probability of the same keystroke in quick succession.
Predictions made with a probability of less than 50% are marked as incorrect.
