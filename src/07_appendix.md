\chapter{Additional Analysis}

# 50-class CuSUM Hyperparameter Analysis \label{sec:appendix_50_cusum_hpar}

<!--
TODO:

> Since these models are not performing well move all of this to an appendix. You
> can just say the hyperparameter analysis of the remaining cusm models are doen
> in the appendix. Your thesis is getting too long. We need to carefully consider
> what we keep and what we move to an appendix. Only keep the main conclusions
> about the failing models here.
>
> PS you have to explain the reaons for failure better. Is there a way you could
> have designed the HMM and CUSUM models better so they did not fail. The exact
> reason for failure is only bruched over. This shoul be made explicit and how
> this could be improved upon.
-->

Figure \ref{fig:05_hpar_analysis_cusum_classes50} shows the performance of all
50-class CuSUM models over varying values for the threshold hyperparameter.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_cusum_classes50}
    \caption[CuSUM 50-class precision-recall plot]{Left: precision-recall plot
    for all 50-class CuSUM models, with the value of the threshold
    hyperparameter indicated by the colour of the point. Right: a direct plot
    of the model's $F_1$-score against the threshold parameter.}
    \label{fig:05_hpar_analysis_cusum_classes50}
\end{figure}
<!-- prettier-ignore-end -->

The relationship between precision, recall, and the CuSUM threshold value is
not as clear for the 50-class CuSUM models as it was for the 5-class CuSUM
models. The 50-class CuSUM models have a precision of $\mu=0.222, \sigma=0.043$
and a recall of $\mu=0.252, \sigma=0.025$. The CuSUM models are clearly unable
to distinguish this many classes from each other. As seen in the confusion
matrices in Figure \ref{fig:05_mean_conf_mat_cusum}, this is due to frequent
mispredictions where the correct hand is predicted, but the incorrect
orientation or finger is predicted.

# 51-class CuSUM Hyperparameter Analysis \label{sec:appendix_51_cusum_hpar}

While the 51-class CuSUM models are no better at learning the data than the
50-class CuSUM models, it is instructive to examine _how_ these models fail.
The only difference between the 50- and 51-class datasets is addition of a
class imbalance via a majority class: class 50. Figure
\ref{fig:05_hpar_analysis_cusum_classes51} shows the performance of all
51-class CuSUM models over varying values for its single hyperparameter, the
threshold value.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_hpar_analysis_cusum_classes51}
    \caption[CuSUM 51-class precision-recall plot]{Left: precision-recall plot
    for all 51-class CuSUM models, with the value of the threshold
    hyperparameter indicated by the colour of the point. Right: a direct plot
    of the model's $F_1$-score against the threshold parameter.}
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

The cause of this reduction is clear when looking at the confusion matrices for
the 50- and 51-class CuSUM models (Figure \ref{fig:05_mean_conf_mat_cusum}).
There is a row at the bottom of the 51-class confusion matrix, indicating that
the 51-class CuSUM model often predicts class 50 as belonging to one of the
other classes. If gesture 50 is predicted as belonging to some class $c_i$, then
that is a False Positive prediction for class $c_i$. The definition for
precision contains the number of False Positives in the denominator:

$$
    \text{Precision}_i = \frac{\text{TP}_i}{\text{TP}_i + \text{FP}_i}.
$$

Therefore, increasing the number of False Positives will decrease the precision
of a model (all else being equal). As there are many instances where class 50
is being predicted as belonging to class for the 51-class CuSUM models, this
increases the False Positive rate and correspondingly decreases the precision
of the model, while leaving the recall approximately the same. This explains
the drastic reduction in precision when comparing the 50-class CuSUM models to
the 51-class CuSUM models.

# 5-class HMM Hyperparameter Analysis \label{sec:appendix_5_hmm_hpar}

<!--

TODO:

Before you implement this change just check the length of the thesis. You
should aim to get it below 150 pages for the main text. This excludes table of
contents appendix and the like.... It is very well written and there is no need
to change things if it will fit.....


I would move 5 and 51 to an appendix. Only briefly referring to them in the
main text highlightinh how they are different. The main text is getting a bit
too long we need to find a way of distilling out the important results and
putting the rest in an appendix. Everything you have done is important but the
results need to be more succinct......


-->

As HMMs only have one hyperparameter (the covariance type), Figure
\ref{fig:05_in_depth_hmm_5_p_vs_r_covar_type} shows the precision-recall plot
for all 5-class HMMs as well as the $F_1$-score of each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_5_p_vs_r_covar_type}
    \caption[HMM 5-class precision-recall plot]{Left: Precision-recall plot for all HMMs trained on 5 classes.
    Right: Plot of the model's $F_1$-score for each covariance matrix type.
    Note that the scales of the axes have been adjusted to better show the
    distribution of the data.}
    \label{fig:05_in_depth_hmm_5_p_vs_r_covar_type}
\end{figure}
<!-- prettier-ignore-end -->

The tied covariance matrix HMMs performed the best, with a median
$F_1$-score of $0.967$ and a maximum of $1$. The full covariance matrix HMMs
had a very large range $[0.227, 0.968]$ when compared to the tied $[0.827,
1]$, spherical $[0.475, 0.895]$, and diagonal $[0.199, 0.817]$ covariance
matrix HMMs. This is likely due to the full covariance matrix HMMs having the
fewest constraints on the covariance matrix of the emission probability
distributions, therefore having the greatest number of parameters which can
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

The tied covariance matrix HMMs likely perform so well because each timestep in
the dataset is sampled from approximately the same distribution (the
distribution of acceleration values which can be reached by the _Ergo_
hardware), and so is well represented by one covariance matrix. Fitting a
single covariance matrix which is shared by all states is an efficient means of
describing the overall distribution of the data.

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
    \caption[HMM 5-class seconds per observation: training and inference
    times]{Duration in seconds per observation required to fit and to train
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

# 51-class HMM Hyperparameter Analysis \label{sec:appendix_51_hmm_hpar}

Figure \ref{fig:05_in_depth_hmm_51_p_vs_r_covar_type} shows the precision and
recall of all HMM models trained on all 51 classes, as well as the $F_1$-score
of each covariance type.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_in_depth_hmm_51_p_vs_r_covar_type}
    \caption[HMM 51-class precision-recall plot]{Left: Precision-recall plot for all HMMs trained on 51 classes.
    Right: Plot of the model's $F_1$-score for each covariance matrix type.
    Note that the scales of the axes have been adjusted to better show the
    distribution of the data.}
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
the other covariance matrix types can be explained by the increased number of
observations. It is likely that the full HMMs (which have the largest number of
parameters) were simply unable to converge on good parameter values within the
number of iterations. The other covariance matrix types do not have as many
parameters and so are able to converge on a good enough solution within the
computation limit.

<!--
The reason for the failure is unclear, please be more specific. Did it work
well for some hmms only in precision I assume?

The discussion of the reason for failure has to be more explicit... Why do the
models fail not just that one can see they struggel to detect orientation or
fingers.... the reason they failed is important....
-->

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
    \caption[HMM 51-class seconds per observation: training and inference
    times]{Duration in seconds per observation required to fit and to train the
    different covariance types.}
    \label{fig:05_in_depth_hmm_inf_trn_time_classes51}
\end{figure}
<!-- prettier-ignore-end -->

As with the 5- and 50-class HMMs, the spherical and diagonal covariance types
are approximately an order of magnitude faster than the tied and full
covariance types, in terms of both the inference time and the training time.

<!---                       Regularisation                      --->

# Performance vs dropout rate and L2 coefficient \label{sec:appendix_51_ffnn_regularisation}

Figure \ref{fig:05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers} shows the dropout rate
against the $F_1$-score for the 1-, 2-, and 3-layer FFNNs, with the colour of
each point indicating the L2 coefficient.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers}}
    \caption[FFNN 51-class dropout rate vs $F_1$ and L2]{The dropout rate of each of the 51-class FFNNs against the
    $F_1$-score and with the L2 coefficient indicated by the colour of each
    point and the shared colour bar on the right. One plot each is assigned to
    the 1-, 2-, and 3-layer FFNNs. A small amount of random noise is applied to
    each point such that they do not overlap.}
    \label{fig:05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

The dropout rate has little to no effect on the 1-layer FFNNs, while the 2- and
3-layer FFNNs generally benefit from a low dropout rate. For the 2- and 3-layer
FFNNs, a low dropout rate was not the sole factor which resulted in a high
$F_1$-score, however having a high dropout rate rarely resulted in high
$F_1$-scores. The L2 coefficient had little impact on the $F_1$-scores of any
of the FFNNs, with no range of L2 coefficient showing superior performance.
Because dropout has the effect of setting a subset of nodes' output to zero,
it is not surprising that dropout worked best for models with more layers.

Figure \ref{fig:05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers} shows the
dropout rate against the number of nodes in the last layer for the 1-, 2-, and
3-layer FFNNs, with the colour of each point indicating the $F_1$-score.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers}}
    \caption[FFNN 51-class dropout rate vs $F_1$ and number of nodes per
    layer]{The dropout rate of each of the 51-class FFNNs against the number of
    nodes in the last layer of the FFNN, with the $F_1$-score indicated by the
    colour of each point and the shared colour bar on the right. One plot each
    is assigned to the 1-, 2-, and 3-layer FFNNs. A small amount of random
    noise is applied to each point such that they do not overlap.}
    \label{fig:05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers}
\end{figure}
<!-- prettier-ignore-end -->

Since increasing the dropout rate has the effect of suppressing the output of a
random subset of nodes in each layer, one might expect that FFNNs with a high
dropout rate would require a large number of nodes in order to achieve good
performance. This can be seen to some extent in the plot for 1-layer FFNNs, in
which only the FFNNs with a low dropout rate and a low number of nodes in their
singular layer have a high $F_1$-score. There are no 1-layer FFNNs which
simultaneously have a high dropout rate, few nodes in their singular layer, and
a high $F_1$-score. One can see that an increase in the dropout rate usually
requires an increase in the number of nodes in the singular layer for the FFNN
to maintain a high $F_1$-score.

The 2- and 3-layer FFNNs both show behaviour whereby a FFNN performs well if it
has a low dropout rate and a high number of nodes in its final layer. This
behaviour is less distinct for the 3-layer FFNNs, which is to be expected as
the extra layer introduces more complexity into its performance characteristics.

# Analysis of best model predicting "lazy"

Figure \ref{fig:05_pred_plot_7400_to_8500_lazy} shows the prediction
probabilities and sensor values for the word "lazy ". There are several points
to note here.

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_pred_plot_7400_to_8500_lazy}}
    \caption[Best model predictions and probabilities for "lazy"]{Time series plot of the sensor values and model predictions while
    gesturing the word "lazy ". Spaces are shown with quotes. Top: each
    box shows the predicted keystroke and it's probability. Boxes are green if
    the probability is above 50\% and the prediction is correct and it is at
    the correct timestamp. Predictions which are either of too low probability,
    at the incorrect time, or plainly wrong have a red box. Bottom: Each box
    shows the ground truth keystroke and the class number in brackets.}
    \label{fig:05_pred_plot_7400_to_8500_lazy}
\end{figure}
<!-- prettier-ignore-end -->

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

<!--

===============================================================================
===============================Additional Figures==============================
===============================================================================

-->

\chapter{Additional Figures}

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_svm_classes5}
    \caption[svm 5-class precision and recall]{Left: precision and recall of all 5-class SVMs, with the
    regularization parameter C and class weighting mapped to the colour and
    marker type respectively. Right: The regularization parameter C plotted
    against the $F_1$-score of each SVM, with the class weight indicated by the
    marker shape.}
    \label{fig:appendix_in_depth_svm_classes5}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[height=5cm]{src/imgs/graphs/05_in_depth_svm_classes50}
    \caption[SVM 50-class precision and recall]{Left: precision and recall of all 50-class SVMs, with the
    regularization parameter C and class weighting mapped to the colour and
    marker type respectively. Right: The regularization parameter C plotted
    against the $F_1$-score of each SVM, with the class weight indicated by the
    marker shape.}
    \label{fig:appendix_in_depth_svm_classes50}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_analysis_ffnn_classes5_yval_macro_avg_f1_score_hueNone}
    \caption[FFNN 5-class $F_1$ vs all hyperparameters]{The $F_1$-score for all 5-class FFNNs plotted against the various
    hyperparameters.}
    \label{fig:appendix_ffnn_hpar_analyis_classes5}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_yval_macro_avg_f1_score_hueNone}
    \caption[FFNN 50-class $F_1$ vs all hyperparameters]{The $F_1$-score for all 50-class FFNNs plotted against the various
    hyperparameters.}
    \label{fig:appendix_ffnn_hpar_analyis_classes50}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_analysis_ffnn_classes51_yval_macro_avg_f1_score_hueNone}
    \caption[FFNN 51-class $F_1$ vs all hyperparameters]{The $F_1$-score for all 51-class FFNNs plotted against the various
    hyperparameters.}
    \label{fig:appendix_ffnn_hpar_analyis_classes51}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_pairplot}}
    \caption[FFNN 51-class all hyperparameter pairplot]{Pairplot of all hyperparameters for 51-class FFNNs.}
    \label{fig:appendix_hpar_analysis_ffnn_pairplot}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_pred_plot_0000_to_9420_full_text}}
    \caption[Best model full phrase predictions and probabilities]{Predictions
    and raw sensor values for the full phrase "the quick brown fox jumped over
    the lazy dog".}
    \label{fig:appendix_pred_plot_0000_to_9420_full_text}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_all_f1_scores}}
    \caption[All models and $F_1$-scores]{All models and their $F_1$-scores. Each point
    is a model, and points sharing the same x-value had identical sets of
    hyperparameters. The black horizontal bars show the mean $F_1$-score of
    each set of models with identical hyperparameters. Sets of hyperparameters
    are ordered based on the lower bound of the 90\% confidence interval for
    the $F_1$-score.}
    \label{fig:05_all_f1_scores}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.2\textwidth]{src/imgs/ergo_schematic}}
    \caption[Circuit Schematic]{Circuit schematic for the left and right hand
    of Ergo.}
    \label{fig:appendix_circuit_diagram}
\end{figure}
<!-- prettier-ignore-end -->

<!--

===============================================================================
===============================Additional Tables===============================
===============================================================================

-->

\chapter{Additional Tables}

\input{src/tables/05_best_ffnn_hpars.tex}

\input{src/tables/05_best_majority_hffnn_hpars.tex}

\input{src/tables/05_best_minority_hffnn_hpars.tex}

\input{src/tables/05_best_svm_hpars.tex}

\input{src/tables/05_best_hmm_hpars.tex}

\input{src/tables/05_best_cusum_hpars.tex}
