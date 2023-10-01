# Results

Note: report the accuracy when excluding g255, as most of the literature does
this. Discuss the difficulties of segmentation and how most of the literature
does not attempt this.

See the **Word Error Rate** in Amma, Christoph, Marcus Georgi, and Tanja
Schultz. “Airwriting: A Wearable Handwriting Recognition System.” Personal and
Ubiquitous Computing 18, no. 1 (January 2014): 191–203.
https://doi.org/10.1007/s00779-013-0637-3.

From discussion with Trienko:

> Results chapter:

> Also, include some sort of scatter plot with ellipses overlaid on the different
> groupings on the scatter plot. So the x is the independent variable (ie
> regularization distance), the y is the dependant variable (ie the validation
> accuracy), each of the points is one measurement, each hue is one grouping
> (from identical hyperparameters) and each grouping is encircled by an ellipse
> with the mean, std dev, and correlation of that group's data
>
> High level overview
>
> - Dataset description
> - What do good/bad models look like wrt F1, confusion matrix, etc?
> - Motivation for each model
> - Research questions:
>   - Which model performs the best with 51 classes?
>   - Which model shows the best results after cross validation?
>   - Which model takes the longest to train
>   - Which model takes the longest to perform inference? (and is therefore most
>     suitable to live inference?)
>   - How does each model perform on real-world data?
>   - For each model (SVM, HMM, CuSUM, FFNN, HFFNN):
>     - For each model, what effect do the hyperparameters have on the
>       performance? (increasing/decreasing f1/precision/recall?)
>     - For each model, are there patterns in how the model performs? (Can we
>       compare the confusion matrices of the model with the "platonic ideals" of
>       various models?)
>
> Talking points for Trienko
>
> - [ ] Validation plots to show that the selected model is statistically likely to perform well
> - [ ] Hyperparameter comparison
> - [ ] Real-time evaluation
> - [ ] Real-world dataset evaluation
> - [ ] In depth discussion about the pros/cons of where each model gets confused
> - [ ] Motivation for evaluating the different model types
> - [ ] (where do the 50 or 5 gesture tests come into this?)
>
> NOTE: There needs to be a discussion of accuracy, precision, recall, $F_1$
> score somewhere, as well as macro/micro/weighted $F_1$ score.
>
> NOTE: Hyperparameter optimisation which selects models based on macro-F1 score
> needs to be mentioned
>
> NOTE: have an explanation that precision/validation/f1 is always on the
> validation set unless otherwise noted
>
> Note: Have a note that the confusion matrices are always normalised to have
> each row sum to one unless otherwise noted, and that cells without any
> predictions are left uncoloured (so that you can easily see
> close-to-zero-but-not-quite-zero cells).

## Dataset Description

- "Video" of some gestures being performed
- 30 dimensional dataset
- 10 sensors, each providing 3x linear acceleration from the fingertips
- 50 gesture classes
- 1 non-gesture class
- highly imbalanced dataset
- Example time series plots showing 2 seconds/20 seconds of data
- PCA plot of the data showing the individual gestures to be easily separated,
  but the non-gesture class being tricky to separate
  - Select an interesting subset of the PCA plot and just show those
    observations
- Very large dataset of observations

The core goal of _Ergo_ is to convert hand motion to keyboard input. To this
end, there are 10 acceleration sensors mounted on the user's fingertips which
each measure three axes of linear acceleration at a rate of 40 times per
second. This leads to a 30 dimensional dataset. A snapshot of this dataset is
visible in Figure \ref{fig:todo}.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{'video' of various gestures being performed}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

These data are recordings of 50 gesture classes and one non-gesture class. The
50 gesture classes are indexed 0 through 49, and each one represents a unique
combination of one of ten fingers together with one of five orientations for
the hand. The product of ten fingers with five orientations results in fifty
gesture classes. The non-gesture class represents all observations which do not
represent a gesture.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{Plot showing the 'anatomy' of a gesture: labels, g255, etctodo}
    \label{fig:todo}
\end{figure}

This setup results in a 51-class classification problem with a highly
imbalanced class distribution. During training, one gesture is made every half
second. Given a data capture frequency of 40 times per second, this means that
there is one gesture label for every 19 non-gesture labels. The class balance
is about 97.6% the non-gesture class and the remaining 2.4% divided evenly
between the 50 gesture classes.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{Bar plot showing class imbalance}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{Time series showing about 20 g255 for each non-g255}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{Time series line plots of the dataset over selected gestures over about 2 seconds (one plot per finger)}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{Time series heatmap of the dataset over selected gestures over about 20 seconds}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

To aid in the intuition gained from looking at the data the below figures show
all observations for gesture 0:

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/05_example_g000_plot}
\caption{All observations for gesture 0, laid on top of one another (one plot per finger)}
\label{fig:05_example_g000_plot}
\end{figure}

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_example_pca_plot}
    \caption{PCA plot of the data, excluding g255}
    \label{fig:05_example_pca_plot}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_example_pca_w_g255}
    \caption{PCA plot of the data, g255 vs rest}
    \label{fig:05_example_pca_w_g255}
\end{figure}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{PCA plot of the g255 observations, coloured by distance to real gesture}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

## Comparison of hypothetical models

In this section, hypothetical models will be defined and their performance
examined. These hypothetical models have been chosen by the author to provide
some intuition about common pitfalls encountered by the real models. Consider
this section to be less about the models, but rather about what is required (or
sometimes, what is _not_ required) for a model to present certain performance
characteristics such as high F1, high precision, or a near-perfect confusion
matrix.

Figure \ref{fig:05_pr_conf_mat_random_preds} shows the precision-recall graph
and confusion matrix of a classifier that predicts every observation according
to a uniform random distribution. The precision-recall graph shows thirty
repetitions, however the points are too tightly clustered to be easily
distinguished. The confusion matrix shows the mean confusion matrix from the
same thirty repetitions. This classifier achieves a mean $F_1$ score of
0.00166, which is a reasonable floor for the performance of any classifier. The
confusion matrix also makes it clear that the majority of observations belong
to class 50, the non-gesture class.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_random_preds}
    \caption{Precision-recall graph and confusion matrix of a classifier that predicts completely randomly.}
    \label{fig:05_pr_conf_mat_random_preds}
\end{figure}
<!-- prettier-ignore-end -->

The highly imbalanced nature of the dataset permits a naïve classifier to
achieve 97.6% accuracy by always predicting the non-gesture class. Figure
\ref{fig:05_pr_conf_mat_only_50} shows the confusion matrix and
precision-recall graph of such a classifier, which has an $F_1$ score of
0.00164.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_only_50}
    \caption{Precision-recall graph and confusion matrix of a classifier that only predicts the non-gesture class.}
    \label{fig:05_pr_conf_mat_only_50}
\end{figure}
<!-- prettier-ignore-end -->

Each gesture is a combination of a finger being moved and a rotation of the
user's hands. Certain models are better able to learn the finger/orientation of
certain gestures, and so the below plots focus on models which are perfect in
one respect but uniformly random in all other respects. In order to perform
this comparison, these hypothetical models have perfect information about the
ground truth.

The performance of a model with access to the ground truth is not reasonable as
a goal for other models to achieve. Nonetheless, these models will prove useful
when diagnosing what other more realistic models are getting wrong and what
they're getting right.

Below is the precision-recall plot and confusion matrix for 30 classifiers that
correctly predict the finger and which hand is being used, but incorrectly
predicts the orientation of the hand. The non-gesture class is always predicted
perfectly. Note the characteristic diagonals, representing how any given gesture
might be predicted by these classifiers as one of five gestures, corresponding
to the five orientations. The mean $F_1$ score for these classifiers is 0.212.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_wrong_orientation}
    \caption{Precision-recall graph and confusion matrix of a classifier that is perfect at predicting the finger being used, but always errs when predicting the orientation of the hand.}
    \label{fig:05_pr_conf_mat_wrong_orientation}
\end{figure}
<!-- prettier-ignore-end -->

Also instructive is the precision-recall plot and confusion matrix for 30
classifiers that correctly predict the orientation and hand being used in a
gesture, but incorrectly predicts the finger being used. This plot has
distinctive $5 \times 5$ squares along the primary diagonal, indicating how any
given gesture is only ever incorrectly predicted as one of four other
gestures. The mean $F_1$ score for these classifiers is 0.214.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_pr_conf_mat_wrong_finger_correct_hand}
    \caption{Precision-recall graph and confusion matrix of a classifier that correctly predicts the orientation and hand being used for a gesture, but incorrectly predicts the finger being used.}
    \label{fig:05_pr_conf_mat_wrong_finger_correct_hand}
\end{figure}
<!-- prettier-ignore-end -->

## Justification for why each of the model types are tested

Several different classification algorithms were evaluated. The chosen
classification algorithms were selected based on how well suited they are to a
high dimensional multi-class classification problem, as well as their
prevalence in the gesture classification literature (such that comparisons may
be made between prior work and the current work). Different techniques in the
literature were also consulted and applied where appropriate, with details
discussed below.

Feed-forward Neural Networks (FFNNs) scale well as the number of classes
increases [@TODO]. To scale a FFNN to classify a greater number of classes, one
(at least) needs to increase the number of output neurons and retrain the
entire network. This is favourable when compared to an algorithms that requires
one classifier to be trained per class, in which case both the inference time
and the training time increases approximately linearly with the number of
classes.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/todo}
    \caption{TODO: Graphic showing how NN inference and training time does not scale linearly with number of classes, but HMMs do}
    \label{fig:todo}
\end{figure}
<!-- prettier-ignore-end -->

Hidden Markov Models (HMMs) have frequently been used in the literature for
gesture detection and classification (see the Background Chapter @TODO) and
while training and inference times scale approximately linearly with the number
of classes, they do explicitly model time and have shown promise in previous
works [@TODO]. Their implementation will allow for a better comparison between
the current and prior work.

Cumulative Sum (CuSUM) is a simple statistical technique that will provide a
lower bound on the speed with which predictions can be made. While it is
unlikely to outperform other, more sophisticated models, it will be useful as a
baseline against which the inference speed of other models can be compared.

Some works in the literature do not attempt the detection of gestures in
observations, and instead only attempt the classification of a gesture given
that there is a gesture present in the observation. That is to say that they
assume every observation contains one of a set of gestures, even though
real-world use requires the handling of a non-gesture class such that the
"empty space" in between one gesture and the next does not get erroneously
classified as a gesture even though no gesture is being performed. One
technique in the literature which has shown promise in dealing with both
detection and classification is that of a hierarchical setup [@TODO] in which
there are two models trained. The first model (the detector) is a binary
classifier simply trained to detect if there is any gesture present in an
observation. The second model (the classifier) is trained on only the
observations containing a gesture, and is trained to classify which gesture is
present. To make a prediction with the hierarchical model, first the detector
is queried with an observation. If the detector indicates that there is no
gesture present, then that result is returned. If the detector indicates that
there is a gesture present, the observation is forwarded to the classifier
which predicts which gesture is present and this result is returned.

A Hierarchical Feed Forward Neural Network (HFFNN) architecture is also tested,
following the above procedure. Two neural networks are trained, one to detect
if a gesture is present and another to classify which gesture is present, given
that there is indeed a gesture present. Despite being composed of two
independent neural networks, the HFFNN is evaluated as one model.

Support Vector Machines (SVMs) have been used in the literature for glove-based
gesture classification [@TODO] and so are evaluated here. SVMs do not natively
support multi-class classification but multiple SVMs can be combined to perform
one-vs-rest classification. Due to the large number of observations and the
poor scaling characteristics of SVMs as the number of observations increases,
only a linear kernel is considered.

## Which model performs the best with 51 classes?

The performance of each of the five classification algorithms can be seen in
Figure \ref{fig:05_precision_recall_51_classes} (for those models trained on
all 51 classes).

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_precision_recall_51_classes}
    \caption{ Left: Precision and recall for all model types trained on the
    full 51 classes, with the contours depicting the $F_1$-scores for those
    models. Right: The $F_1$-scores for the same models, shown side-by-side for
    easier comparison. }
    \label{fig:05_precision_recall_51_classes}
\end{figure}
<!-- prettier-ignore-end -->

From these plots we can see that SVMs, FFNNs, and HFFNNs perform competitively.
HMMs achieve high recall but struggle with precision, and CuSUM similarly
achieves much higher recall than precision. Individual model types will be
discussed in more detail in the following sections: HMMs in section
\ref{in-depth-ffnn}, SVMs in \ref{in-depth-svm}, FFNNs in
\ref{in-depth-ffnn}, HFFNNs in \ref{in-depth-hffnn}, and CuSUM in
\ref{in-depth-cusum}\footnote{TODO reorder these}.

The SVMs show a bi-modality in the precision-recall plot, despite the resulting
$F_1$ score being similar. There are clusters around (0.45, 0.90), (0.525,
0.825) and (0.725, 0.575), each with a $F_1$ score between 0.55 and 0.65.

The two neural network based models (FFNN and HFFNN) perform similarly as is to
be expected from their similar architecture, however the two-model HFFNN
largely performed worse than the single model FFNN. This is likely due to the
HFFNN having a larger number of hyperparameters to tune, resulting in a model
which is more prone to overfitting. These neural-network-based models exhibit
very large variance in their performance, which may be attributable to the
large number of hyperparameters which were tuned in comparison to the number of
hyperparameters required for SVMs, HMMs, or CuSUM.

The CuSUM models show predictably poor performance, as the model largely serves
as a speed comparison.

The HMMs show three clusters, all with very poor precision but varying recall.
The clusters all have a precision of near zero, but have recall values of 0.25,
0.6, and 0.9.

Figure \ref{fig:05_precision_recall_stripplot} shows the precision and recall
for each model type (for all models trained on all 51 classes).

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_precision_recall_stripplot}
    \caption{Precision and recall for all model types trained on all 51
    classes, aligned for easier comparison.}
    \label{fig:05_precision_recall_stripplot}
\end{figure}
<!-- prettier-ignore-end -->

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

## Model hyperparameter comparison

As each model was trained five times, an approximate empirical distribution can
be obtained for each model type and each model and each hyperparameter
combination. These can then be ranked by the median $F_1$ score and compared.

TODO: tabular comparison of the top 10 models overall, and also a strip plot of
those models
TODO: tabular comparison of the top 10 models for each model type
TODO: comparison of the confusion matrices for the best models

> This looks at all iterations of one model+hyperparameter set and compares the
> median result.
>
> Don't just look at the best run, but take the median for each set of
> model+hyperparameters and see which one is the best.
>
> Maybe this is where the ellipse plots come in?

## Comparison of the inference and training times for each model

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
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inf_trn_times_per_obs}
    \caption{Inference and training times for the validation and training
    datasets. Due to the large range of the data, the plots in the first column
    show the unmagnified data (plots a and d) and the plots in the other two
    columns show increasing levels of magnification (plots b, c, e, and f).}
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

One can see from Figure \ref{fig:05_inf_trn_times_per_obs} plot a that the
Hidden Markov Models take significantly longer to perform inference than the
other models, with some HMMs taking 0.08 seconds per observation. There are
other HMMs which take approximately 0.01 seconds per observation, however this
is still orders of magnitude slower than all Neural Networks and all Support
Vector Machines (visible in plot c). CuSUM also takes a relatively long time to
perform inference, around 0.0015 seconds per observation. While this is not
large in absolute terms, it is much larger than the inference times for the
neural network based models and the SVMs.

The models chosen all perform approximately the same amount of computation
regardless of whether an observation has been seen before by the model, and
this is reflected in the strong correlation between inference times on the
training and validation datasets (plots a, b, and c).

Plots d, e, and f show the inference times on the training dataset against the
amount of time taken to train the model on that dataset. One can see that the
HMMs take orders of magnitude longer to train than other model types (plot d,
x-axis). Some HMMs take around 0.04 seconds per observation to train, and other
HMMs take around 0.01 seconds per observation. This is in start contrast to the
FFNNs, HFFNNs, and SVMs which take an order of magnitude less time to train,
around 0.0025 seconds per observation (plot f, x-axis)

As already mentioned, HMMs are orders of magnitude slower than the FFNNs and
the SVMs but as Figure \ref{fig:05_inference_time_per_obs_vs_f1} makes
apparent, there is no increase in $F_1$ score that could compensate for the
increase in inference times.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_inference_time_per_obs_vs_f1}
    \caption{Inference time per observation for each model plotted against each model's $F_1$-score. Left shows all inference times, Right shows only those inference times less than 0.0001 seconds.}
    \label{fig:05_inference_time_per_obs_vs_f1}
\end{figure}
<!-- prettier-ignore-end -->

CuSUM also has slow inference times. This is likely due to the implementation
being written in the Python programming language. While the SVM, FFNN, and
HFFNN implementations each provide a Python interface, the majority of the
computational workload is executed in the C programming language.

For the SVMs, the FFNNs, and the HFFNNs, there is no significant correlation
between training times and $F_1$ score. This is to be expected, given the
learning mechanisms behind each model.

Regardless of the relative speed of each model, the absolute speed of every
SVM, FFNN, and HFFNN is more than sufficient for real-time prediction with
_Ergo_. The absolute speed of CuSUM is likely sufficient for _Ergo_, however
imposing additional workload on the relevant machine or running the software on less
performant hardware might cause problems. The HMMs are not fast enough for
real-time predictions, however a compromise might be made by only attempting
inference on every other timestep, thereby reducing the performance required at
the cost of a less responsive system.

## Comparison of the validation to training ratios for each model

Figure \ref{fig:05_f1_vs_f1_ratio} shows the validation and training $F_1$
scores for every model trained all 51 classes. The ratio of a model's training
$F_1$ to its validation $F_1$ can be used as a heuristic for how much a model
is overfitting to the training data, as a model that performs very well on the
training dataset but very poorly on the validation dataset is likely to have
overfit on the data, and therefore is unlikely to perform well on unseen data.

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
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
where the validation $F_1$ score is greater than 0.5.

One can see from plot a that the HMMs have a much higher training $F_1$ than
their validation $F_1$; this is due to the training dataset for HMMs not
containing every observation of the non-gesture class, leading to inflated
training metrics. The validation set _does_ include every observation of the
non-gesture class, and so is an accurate depiction of the model's performance.
This is discussed more in section TODO (HMM discussion section).

At a high level, models which performed poorly ($F_1 < 0.5$) on the training
dataset performed similarly on the validation dataset, as can be seen with the
$F_1$ ratio being near 1 for the majority of models with an $F_1$ of less than
0.5 (plots a and c). Note that CuSUM performed very poorly with a median
validation $F_1$ of 0.0307 and is obscured on the plots by other models.

Plots b and d highlights the region where $F_1 > 0.5$, showing several clusters
for SVM models and regions occupied by the two neural network based models:
FFNN and HFFNN. The clusters for SVM are discussed more in section TODO. One
can see that the training $F_1$ is almost always higher than the validation
$F_1$, as would be expected from models with a capacity to overfit to data that
has been seen before.

The higher the $F_1$ ratio, the more probable it is that the model has overfit
to the training data (as it was unable to generalise its performance to the
validation data). In plots b and d, it can be seen that the SVMs tend to have a
higher $F_1$ ratio. However, plot b shows that (within certain clusters of
models) the training $F_1$ score of SVMs is largely uncorrelated with the
validation $F_1$ score.

A possible explanation is that the SVMs are easily finding local maxima of
performance on the training dataset. However, these local maxima do not
properly convert to good performance on the validation dataset.

Comparing the points representing the FFNNs and the HFFNNs in plots b and d,
one can see that the FFNNs with higher validation $F_1$ scores tend to have a
lower $F_1$ ratio, indicating that the FFNNs are less susceptible to
overfitting than the HFFNNs.

## How does each model perform on real-world data?

> Using actual "typing" data recorded which plays a known sequence of keys and
> has a comparison of where the model goes wrong.

## In-depth model comparisons

This section will explore each of the model types in depth, but will not make
comparisons between different model types. Characteristics specific to each
model type are discussed, relating to $F_1$ score, precision, recall, inference
times, and training times. Where appropriate, confusion matrices of different
models are also visualised to aid with the analysis of those models.

FFNNs will be discussed in section \ref{in-depth-ffnn}, HMMs in
\ref{in-depth-hmm}, CuSUMs in \ref{in-depth-cusum}, HFFNNs in
\ref{in-depth-hffnn}, and SVMs in \ref{in-depth-svm}.

- What effect do hyperparameters have on f1/precision/recall?
- Are there clusters of hyperparameters that perform similarly?
- Where does the model perform poorly? Can conclusions be drawn from this?
- Can the model's performance be compared to some of the idealised confusion
  matrices?
- Residual analysis on the final models to see why they go wrong where they go
  wrong, and what patterns can be discerned there from. Also, do these patterns
  indicate ways in which you could have improved the models?

### FFNN \label{in-depth-ffnn}

> The two neural network based models (FFNN and HFFNN) perform similarly
> as is to be expected from their similar architecture, however the two-model
> HFFNN largely performed worse than the single model FFNN\footnote{TODO: why is this
> the case?}. These models exhibit very large variance in their performance,
> which may be attributable to the large number of hyperparameters which were
> tuned. This is discussed more in section TODO.

### HMM \label{in-depth-hmm}

Also seem to be clustered in terms of 51-class precision/recall graphs

> HMMs seem to be clustered in terms of the inference/training times(?)

> Discuss why the HMMs couldn't be trained on every training observation but
> could be evaluated on every validation observation.

### CuSUM \label{in-depth-cusum}

### HFFNN \label{in-depth-hffnn}

> The two neural network based models (FFNN and HFFNN) perform similarly
> as is to be expected from their similar architecture, however the two-model
> HFFNN largely performed worse than the single model FFNN\footnote{TODO: why is this
> the case?}. These models exhibit very large variance in their performance,
> which may be attributable to the large number of hyperparameters which were
> tuned. This is discussed more in section TODO.

### SVM \label{in-depth-svm}

> SVMs seem to be clustered in terms of the inference/training times

> SVMs seem to be clustered in terms of training and validation $F_1$ scores

## Evaluation of autocorrect

## Evaluation of end-to-end process
