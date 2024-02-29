\epigraph{
    The best way to predict the future is to invent it.
}{\textit{Alan Key}}

This chapter provides an overview of what was found and some final remarks on
the thesis. Section \ref{sec:06-thesis-summary} provides a summary of what was
discussed in each chapter of the thesis. Section
\ref{sec:06-assessment-of-the-research-questions} restates the research
question and assesses the evidence found, such that the questions can be
answered. Section \ref{sec:06-general-remarks-and-recommendations} provides
high-level remarks about what was encountered during the thesis and any
findings which did not fit into the research questions, as well as practical
recommendations for researchers exploring this area. Section
\ref{sec:06-future-work} offers ideas for potentially fruitful avenues of
further study.

# Thesis Summary \label{sec:06-thesis-summary}

Chapter \ref{chap:introduction} introduced the thesis and stated the research
questions to be answered. A brief description of the field of gesture
recognition was given, and some commonly-faced problems were outlined.

Chapter \ref{chap:background} provided the theoretical background for the
classification algorithms used in this thesis. Neural Networks were
discussed in Section \ref{sec:02-artificial-neural-networks}, providing a short
history of their development, a description of the mathematical process of
training and inference, as well as a description of commonly used modifications
to plain neural networks that generally improve performance. Hidden Markov
Models were discussed in Section \ref{sec:02-hidden-markov-models}, discussing
the mathematics required for the forward and backward procedures as well as the
Viterbi algorithm. Support Vector Machines were discussed in Section
\ref{sec:02-support-vector-machines} and the relevant mathematics for finding
the optimal splitting hyperplane was discussed. Cumulative Sum were discussed
in Section \ref{sec:02-cumulative-sum} with reference to the original work by
\cite{pageCONTINUOUSINSPECTIONSCHEMES1954}.

Chapter \ref{chap:literature-review} reviewed the gesture recognition
literature since the first work by
\cite{experimentaltelevisioncenterComputerImageCorporation1969} and provided a
thorough analysis of the different hardware technologies and algorithms used
over the decades through various attempts at automatically recognising human
hand gestures. The different applications of gesture recognition were also
covered.

Chapter \ref{chap:methodology} provided the details required to reproduce the
experiments conducted with the aim of answering the research questions. These
details covered implementation of the different classification algorithms
discussed in Chapter \ref{chap:background} as well as the construction of the
sensor suite and data collection.

Chapter \ref{chap:results} analysed the results of the experiments and
discussed the findings. Each model type and dataset was compared and the
influence of individual hyperparameters on the performance of each model was
discussed.

# Assessment of the Research Questions \label{sec:06-assessment-of-the-research-questions}

This section will briefly restate and then review the research questions stated
in Section \ref{sec:01-research-questions}, discussing the degree to which they
have been answered by the results.

## Hardware construction and data capture

\begin{framed}
    The viability of off-the-shelf hardware components for high-frequency data
    capture is assessed. A custom sensor suite is designed and built to capture
    the movement of a user's fingertips with enough fidelity that many
    different gestures can be distinguished.
\end{framed}

Section \ref{sec:04-construction-of-ergo} described the construction of
\emph{Ergo} along with the components used during construction and the
capabilities of those components. All these components are commercially
available from online hobby electronics websites\footnote{Some hobby
electronics stores based in South Africa are
\href{https://www.diyelectronics.co.za/store/}{DIY Electronics},
\href{https://www.netram.co.za/}{Netram}, and
\href{https://www.communica.co.za/}{Communica}.}. These components were
sufficient for high-frequency data capture, providing a new set of 30 sensor
measurements every 0.025 seconds. This rate was obtained without requiring
significant optimisation of the circuitry or the software controlling the
circuitry. The commercially available components were easily able to provide
measurements at the required rate. In addition, the acceleration sensors were
sensitive enough to easily distinguish gestures made by the user, as well as
pick up small rotations of the user's hand or small movements of any fingertip.
The commercially available components were easily able to provide measurements
at the required fidelity to distinguish many different gestures.

## Performance of different classification algorithms

\begin{framed}
    Five classification algorithms are assessed on the same dataset, each over
    a wide variety of hyperparameter combinations. The performance of each
    algorithm and of the different hyperparameter combinations is compared.
\end{framed}

The five different classification algorithms (Hidden Markov Models, Cumulative
Sum, Feed-forward Neural Networks, Hierarchical Feed-forward Neural Networks,
and Support Vector Machines) were evaluated in Section
\ref{sec:05-discussion-of-each-model}.

Cumulative Sum (CuSUM, evaluated in Section \ref{sec:05-in-depth-cusum})
succeed at classifying the 5-class dataset but failed to learn the 50 and 51
class datasets due to the inability of the CuSUM model to predict the
orientation of the gesture.

Hidden Markov Models (HMMs, evaluated in Section \ref{sec:05-in-depth-hmm})
succeeded at classifying the datasets with 5 and 50 gesture classes, but failed
on the 51-class dataset. This was due largely to the computational requirements
of HMM parameter estimation increasing with the number of observations, and
there being over 100 000 observations of the non-gesture class.

Support Vector Machines (SVMs, evaluated in Section \ref{sec:05-in-depth-svm})
succeeded at classifying the 5- and 50-class datasets, and achieved good
performance on the 51-class dataset. They were shown to have good performance
on a wide variety of hyperparameter values. Even the worst-performing SVMs
managed to somewhat learn the dataset. This indicates that they would be a good
choice if extensive hyperparameter tuning is not a viable option, as any
reasonable choice of hyperparameters work fairly well.

Feed-forward Neural Networks (FFNNs, evaluated in Section
\ref{sec:05-in-depth-ffnn}) succeeded at classifying the 5-, 50-, and 51-class
datasets. Their performance on all datasets had a high variance and was highly
dependant on the hyperparameter combination being used. The learning rate,
number of layers, and number of nodes in their first layer had the greatest
effect on their performance, with other hyperparameters having little to no
effect. FFNNs had the best performance overall, although extensive
hyperparameter tuning was required to find a combination of hyperparameter
which was able to achieve the best performance, and many hyperparameter
combinations resulted in the FFNNs simply failing to learn at all.

Hierarchical Feed-forward Neural Networks (HFFNNs, described in evaluated in
Section \ref{sec:04-model-specifics-hffnn}) were evaluated on the dataset
containing the background non-gesture class, the 51-class dataset. On the
51-class dataset, they performed slightly worse than the FFNNs. With more than
double the hyperparameters, having a separate model to predict the presence or
absence of a gesture did not benefit the performance of a FFNN-based
classifier.

## Detecting gestures from background noise

\begin{framed}
    An assessment is made of the capability of any one algorithm to perform
    implicit segmentation.
\end{framed}

This research question can be answered by comparing how well the 51-class FFNNs
and the 51-class HFFNNs classify the different classes, since the former has
one model to classify them all, and the latter had one model to detect the
presence or absence of the non-gesture class, and another to classify which
gesture was present given that a gesture was indeed present. The best FFNNs
performed better than the best HFFNNs, achieving a higher validation unweighted
average $F_1$-score. Additionally, the FFNNs required less time to make a
prediction than the HFFNNs. Since the FFNNs performed better than the HFFNNs,
it can be concluded that a hierarchical set-up with two neural networks is not
required, and that one neural network can perform implicit segmentation.

## Performance impact of background sensor noise

\begin{framed}
    The requirement for an algorithm to perform implicit segmentation is likely
    to have a detrimental effect on that algorithm's performance. This impact
    is examined and discussed.
\end{framed}

This research question can be answered by comparing the performance all models
on the 50-class dataset against the 51-class dataset, as the only difference
between the two is the addition of a background non-gesture class in the
latter. All models which were able to learn the 50-class dataset were able to
achieve near-perfect performance after hyperparameter tuning. However, on the
51-class dataset those same models had substantially reduced performance
regardless of hyperparameter tuning. While some models still managed to achieve
relatively good performance, no model achieved the same performance on the
50-class dataset as was achieved on the 51-class dataset. It can then be
concluded that the addition of "background noise", introduced by the
non-gesture class, substantially increases the difficulty of the classification
problem.

## Classification speed

\begin{framed}
    As \emph{Ergo} is to be a real-time keyboard replacement, the speed with
    which different classification algorithms can make accurate class
    predictions is recorded and evaluated.
\end{framed}

As _Ergo_ records data at a rate of 40Hz, the time to make a single
classification on the 51-class dataset cannot exceed 0.025 seconds if real-time
predictions are required. Only the HMMs failed in this matter, with all other
models making classifications in orders of magnitude less time than the
required 0.025 seconds. Of the HMMs, the covariance type hyperparameter had a
large impact on the amount of time required to perform a classification, with
the spherical and diagonal covariance types requiring around 0.005 seconds but
the tied and full covariance types requiring around 0.075 seconds. It can be
concluded that the SVMs, FFNNs, HFFNNs, CuSUM are viable for real-time
predictions.

# General Remarks and Recommendations \label{sec:06-general-remarks-and-recommendations}

Gesture recognition has a long history but generally has seen little commercial
adoption, despite many attempts by researchers to make the technology viable.
Vision-based systems (discussed in Section
\ref{sec:03-vision-and-wifi-based-gesture-recognition}) have shown lots of
recent advances, primarily due to the use of Convolutional Neural Networks and
the ease with which common video datasets of humans performing gestures can be
shared between researchers. WiFi-based systems (also discussed in Section
\ref{sec:03-vision-and-wifi-based-gesture-recognition}) are relatively new, but
show promise if the privacy problems can be resolved. Based on the number of
contemporary literature surveys which claim to review gesture recognition and
yet fail to mention WiFi-based gesture
recognition \citep{chenSurveyHandGesture2013,
raysarkarHandGestureRecognition2013, anwarHandGestureRecognition2019,
chenSurveyHandPose2020}, one might conclude that many researchers are simply
unfamiliar with the technology and thus have not considered it as an avenue for
further study.

Glove-based systems (discussed in Section
\ref{glove-based-gesture-recognition}) show the most promise for an ideal user
experience, as the researcher does not have to worry about the environmental
conditions or the potential occlusion of the user's hands, both of which are
common problems with vision-based systems. A wireless glove-based system would
additionally not require a user be tethered to their computer, resulting in
significantly increased freedom of movement of the user.

Research into glove-based systems is significantly hampered by the fact that
every researcher has to create their own sensor suite, due to the lack of
affordable and effective sensor gloves. It is likely that the lack of
affordable and effective commercially available sensor gloves is due in no
small part to the lack of effective software to interpret the data coming from
them. This reciprocal dependency will only be solved if a company with
sufficient resources decides to create both a high quality sensor suite to
capture data _and_ a high quality software suite to interpret that data. This
is what happened with the Microsoft Kinect, and it resulted in an explosion of
vision-based gesture recognition research \citep{
chenSurveyHandGesture2013,
jiehuangSignLanguageRecognition2015,
ghotkarDynamicHandGesture2016,
zhaoMultifeatureGestureRecognition2016,
caiRGBDDatasetsUsing2017}.

The fidelity of different gestures defined in the gesture recognition
literature vary significantly, as does the difficulty in classifying those
gestures. A whole hand waving motion requires very few sensors to register, but
is cumbersome for the user to perform repeatedly. These low-fidelity gestures
might be applicable for general interactions such as music playback or volume
controls, but they are wholly unsuitable for high-frequency interactions such
as typing at a keyboard. _Ergo_ represents a high-fidelity solution which is
expressly designed for and capable of high-frequency interactions such as the
emulation of keyboard input. Much previous work has focussed on low-fidelity
<!-- TODO: add reference to Literature review here --> gesture recognition
where the time taken to perform each gesture makes those gestures unsuitable
for everyday computer
interaction \citep{schlomerGestureRecognitionWii2008,
bevilacquaContinuousRealtimeGesture2010, netoHighLevelProgramming2010,
aklAccelerometerbasedGestureRecognition2010,
aklNovelAccelerometerBasedGesture2011, patilHandwritingRecognitionFree2016,
riveraRecognitionHumanHand2017}.

Much of the literature focusses on the traditional machine learning task of
classifying each class, but there is an additional class which often is
excluded: the background non-gesture class. The addition of this class to the
classification task has been shown in this thesis to significantly increase the
difficulty of the problem. Additionally, classifiers which perform well when
only classifying the gesture classes are not guaranteed to perform well when
also required to detect those gesture classes against the non-gesture class.
Classifiers trained on datasets without any background non-gesture class cannot
be used in the real world because they lack the ability to detect when no
gesture is being performed. Datasets without a background class are toy
datasets, and performance on them is not representative of real-world
performance.

Despite the practical and technical hurdles, this thesis has shown that
real-time gesture recognition is a viable option for keyboard emulation. A
machine learning model has been trained on a sufficiently large vocabulary of
gesture classes to enable one gesture for every key on a standard English
QWERTY keyboard. These gesture classes can be distinguished from the regular
non-gesture movement of the hand reliably enough that keystrokes are not sent
when the user does not intend them to be sent.

# Future Work \label{sec:06-future-work}

There are several avenues of further research which are promising. Several
emerging technologies have not yet (in the author's opinion) been fully
explored with regards to their potential for gesture recognition. The privacy
and security concerns of WiFi-based systems (see Section
\ref{sec:03-vision-and-wifi-based-gesture-recognition} and
\citealt{maWiFiSensingChannel2020}) are significant, but if resolved the
technology has many promising applications related to gesture detection. This
is particularly interesting when one considers that the user in a WiFi-enabled
gesture recognition environment need not interact with any device explicitly.
It could appear to "just work". However, the privacy implications of this are
very concerning \citep{aliKeystrokeRecognitionUsing2015,
aliRecognizingKeystrokesUsing2017, liWhenCSIMeets2016} and also require more
thought about how to provide a good experience to the user while indicating to
the user that their movements are being watched and recorded. Very few people
are aware of the capabilities of WiFi-based gesture detection, making this
avenue rife for attack from a malicious agent.

Surface Electromyography (EMG, discussed in Section
\ref{sec:03-technologies-used}) is also very promising (see
\citealt{moinWearableBiosensingSystem2020}), as it requires only the user's
forearm to be measured, but could provide information about the user's whole
hand movement by measuring muscle activity. Keeping one's hands clear and
unobstructed is often desirable for intricate movements and is often more
comfortable, making this technology worth pursuing. Current research requires
dense arrays of custom designed electrodes to be attached to the user's
forearm. This technology has promise, but requires a lot more work to be simple
to use. The NinaPro database \citep{atzoriNinaproDatabaseResource2015} is a
useful resource for EMG controlled robotic hand prosthetics.

Future development on the \emph{Ergo} sensor suite would focus on portability:
The current system is tethered to the user's computer but it is technically
feasible for the suite to be completely wireless and battery powered. This
would enable \emph{Ergo} to provide an interface identical to that of a
Bluetooth keyboard. Turning \emph{Ergo} on would cause it to broadcast its
availability as a Bluetooth keyboard to surrounding Bluetooth-enabled devices,
and on connection the user would be able to interact with those devices using
\emph{Ergo} exactly as though it were a keyboard. All machine learning
inference would be required to run on the microcontroller (as there would no
longer be an external computer to perform the inference), however the speed
with which the FFNN makes predictions makes it possible that an optimised
neural network would be able to run on-device.
