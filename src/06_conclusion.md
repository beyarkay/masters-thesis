<!--
Explain that modern gesture detection is done with computer vision methods
because they benefit from a large network effect: one researcher can easily
build off of another's research because the datasets are easily shared and teh
start-up cost is very low. Glove-based designs are trickier because they
require robotics knowledge to even get started with a dataset. Once the dataset
is created, it cannot easily be reused by another researcher unless they have
the exact same hardware.


Notes on writing a conclusion from TG:

3. Recommendations: Used to convince the reader that I know what's what. What
   are the take-home messages? What would I want to know if I were doing this
   again? How can I prove that I'm not a question-answering parrot and that I
   actually did gain something from this MSc
4. Future work. Because there's always more to do.

TODO: Get a friend to do the Afrikaans translations for you.
-->

<!-- prettier-ignore-start -->
\epigraph{
    The best way to predict the future is to invent it.
}{\textit{ Alan Key }}
<!-- prettier-ignore-end -->

This chapter provides some final remarks on the thesis and an overview of what
was found. Section \ref{sec:06-thesis-summary} provides a summary of what was
discussed in each chapter of the thesis. Section
\ref{sec:06-assessment-of-the-research-questions} restates the research
question and assesses the evidence found such that the questions can be
answered. Section \ref{sec:06-general-remarks-and-recommendations} provides
high-level remarks about what was encountered during the thesis and any
findings which did not fit into the research questions, as well as
recommendations for future researchers looking to explore this area. Section
\ref{sec:06-future-work} offers ideas for potentially fruitful avenues of
further study.

# Thesis Summary \label{sec:06-thesis-summary}

Chapter \ref{chap:introduction} introduced the thesis and the research
questions to be answered. A brief description of the field of gesture
recognition was given and some commonly-faced problems were outlined.

Chapter \ref{chap:background} provided the theoretical background about the
different classification algorithms used in the thesis. Neural Networks were
discussed in Section \ref{sec:02_ffnn}, providing a short history of their
development, a description of the mathematical process of training and
inference, as well as a description of commonly used modifications to plain
neural networks that generally improve performance. Hidden Markov Models were
discussed in Section \ref{sec:02_hmm}, discussing the mathematics required for
the forward and backward procedures as well as the Viterbi algorithm. Support
Vector Machines were discussed in Section \ref{sec:02_svm} and the relevant
mathematics for finding the optimal splitting hyperplane was discussed.
Cumulative Sum were discussed in Section \ref{sec:02_cusum} with reference to
the original work by \cite{pageCONTINUOUSINSPECTIONSCHEMES1954} who introduced
the algorithm as a means for detection of a change in the parameters of an
underlying distribution of sequential data.

Chapter \ref{chap:literature-review} reviewed the gesture recognition
literature since the first work by
\cite{experimentaltelevisioncenterComputerImageCorporation1969} and provided a
thorough analysis of the different hardware technologies and algorithms used
over the decades through various attempts at automatically recognising human
hand gestures. The different applications of gesture recognition was also
covered.

Chapter \ref{chap:methodology} provided the details required to reproduce the
experiments conducted in the aim of answering the research questions. These
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

<!-- prettier-ignore-start -->
\begin{framed}
    The viability of off-the-shelf hardware components for high-frequency data
    capture is assessed. A custom sensor suite is designed and built to capture
    the movement of a user's fingertips with enough fidelity that many
    different gestures can be distinguished.
\end{framed}
<!-- prettier-ignore-end -->

Section \ref{sec:04-construction-of-ergo} described the construction of
\emph{Ergo} along with the components used during construction and the
capabilities of those components. All these components are commercially
available from online hobby electronics websites\footnote{ Some hobby
electronics stores based in South Africa are
\href{https://www.diyelectronics.co.za/store/}{DIY Electronics},
\href{https://www.netram.co.za/}{Netram}, and
\href{https://www.communica.co.za/}{Communica}. }. These components were
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

<!-- prettier-ignore-start -->
\begin{framed}
    Five classification algorithms are assessed on the same dataset over a wide
    variety of hyperparameter combinations. The performance of each algorithm
    is compared, as well as the impact different hyperparameters have on each
    algorithm's performance.
\end{framed}
<!-- prettier-ignore-end -->

The five different classification algorithms (Hidden Markov Models, Cumulative
Sum, Feed-forward Neural Networks, Hierarchical Feed-forward Neural Networks,
and Support Vector Machines) were evaluated in Section
\ref{sec:05-discussion-of-each-model}.

Cumulative Sum (CuSUM, evaluated in Section \ref{sec:05-in-depth-cusum})
succeed at classifying the 5-class dataset but failed to learn the 50 and 51
class datasets due to the inability of the CuSUM model to predict the
orientation of the gesture.

The Hidden Markov Models (HMMs, evaluated in Section \ref{sec:05-in-depth-hmm})
succeeded at classifying the datasets with 5 and 50 gesture classes, but failed
on the 51-class dataset. This was due largely to the computational requirements
of HMM parameter estimation increasing with the number of observations, and
there being over 100 000 observations of the non-gesture class.

Support Vector Machines (SVMs, evaluated in Section \ref{sec:05-in-depth-svm})
succeeded at classifying the 5- and 50-class datasets, and achieved good
performance on the 51-class dataset. They were shown to have good performance
on a wide variety of hyperparameter values. Even the worst-performing SVMs
managed so somewhat learn the dataset. This indicates that they would be a good
choice if extensive hyperparameter tuning is not a viable option, as any
reasonable choice of hyperparameters work fairly well.

Feed-forward Neural Networks (FFNNs, evaluated in Section
\ref{sec:05-in-depth-ffnn}) succeeded at classifying the 5-, 50-, and 51-class
datasets. Their performance on all datasets had a high variance and was highly
dependant on the hyperparameter combination being used. The learning rate,
number of layers, and number of nodes in their first layer had the most effect
on their performance, with other hyperparameters having little to no effect.
FFNNs had the best performance overall, although extensive hyperparameter
tuning was required to find a combination of hyperparameter which was able to
achieve the best performance, and many hyperparameter combinations resulted in
the FFNNs simply failing to learn at all.

Hierarchical Feed-forward Neural Networks (HFFNNs, described in evaluated in
Section \ref{sec:04-model-specifics-hffnn}) have one internal model for
detecting a gesture against background noise and another for classifying which
gesture is present, given that the first model detected a gesture was present.
They were only evaluated on the dataset containing the background non-gesture
class, the 51-class dataset. On the 51-class dataset, they performed slightly
worse than the FFNNs. With more than double the hyperparameters and increased
training time due to two FFNNs being required for one HFFNN, it does not appear
that having a separate model to predict the presence or absence of a gesture
benefits the performance of a FFNN-based classifier.

## Detecting gestures from background noise

<!-- prettier-ignore-start -->
\begin{framed}
    The capability of any one algorithm to both detect a gesture from the
    background noise and classify that gesture into one of 50 gesture classes
    is assessed.
\end{framed}
<!-- prettier-ignore-end -->

This research question can be answered by comparing how well the 51-class FFNNs
and the 51-class HFFNNs classify the different classes, since the former has
one model to classify them all, and the latter had one model to detect the
presence or absence of the non-gesture class, and another to classify which
gesture was present given that a gesture was indeed present. The best FFNNs
performed better than the best HFFNNs, achieving a higher validation unweighted
average $F_1$-score, validation unweighted average precision, and validation
unweighted average recall. Additionally, the FFNNs required less time to make a
prediction than the HFFNNs. It can be concluded that having a separate model to
detect whether or not a gesture is present does not provide significant benefit
for FFNN-based classifiers.

## Performance impact of background noise

<!-- prettier-ignore-start -->
\begin{framed}
    The requirement for an algorithm to distinguish background noise is likely
    to have a detrimental effect on the model's performance on classifying the
    gestures. This impact is examined and discussed, with reference to research
    that does not attempt to recognise gestures from background noise.
\end{framed}
<!-- prettier-ignore-end -->

This research question can be answered by comparing the performance all models
on the 50-class dataset against the 51-class dataset, as the only difference
between the two is the addition of a background non-gesture class in the
latter. All models which were able to learn the 50-class dataset were able to
achieve near-perfect performance after hyperparameter tuning. However, on the
51-class dataset those same models had substantially decreased performance
regardless of hyperparameter tuning. While some models still managed to achieve
relatively good performance, no model achieved the same performance on the
50-class dataset as they did on the 51-class dataset. It can then be concluded
that the addition the "background noise" introduced by the non-gesture class
substantially increases the difficulty of the classification problem.

## Classification speed

<!-- prettier-ignore-start -->
\begin{framed}
    As \emph{Ergo} is to be a real-time keyboard replacement, the speed with which
    different models can make gesture predictions is recorded and evaluated.
\end{framed}
<!-- prettier-ignore-end -->

As _Ergo_ records data at a rate of 40Hz, the time to make a single
classification on the 51-class dataset cannot exceed 0.025 seconds if real-time
predictions are required. Only the HMMs failed in this matter, with all other
models making classifications in orders of magnitude less time than the
required 0.025 seconds. Of the HMMs, the covariance type hyperparameter had a
large impact on the amount of time required to perform a classification, with
the spherical and diagonal covariance types requiring around 0.005 seconds
but the tied and full covariance types requiring around 0.075 seconds. It can
be concluded that the SVMs, FFNNs, HFFNNs, and some of the HMMs are viable for
real-time predictions.

# General Remarks and Recommendations \label{sec:06-general-remarks-and-recommendations}

Gesture recognition has a long history, but generally has seen little
commercial adoption despite many attempts by researchers to make the technology
viable. Vision-based systems have shown lots of recent advances, primarily due
to the use of Convolutional Neural Networks and the ease with which common
video datasets of humans performing gestures can be shared between researchers.
WiFi-based systems are relatively new, but show promise if some details can be
worked out. Based on the number of contemporary literature surveys which claim
to review gesture recognition and yet fail too mention WiFi-based gesture
recognition\footnote{\cite{chenSurveyHandPose2020,
anwarHandGestureRecognition2019, chenSurveyHandGesture2013,
raysarkarHandGestureRecognition2013}}, one might conclude that many researchers
are simply unfamiliar with the technology and thus have not considered it as an
avenue for further study.

A glove-based approach shows the most promise for an ideal user
experience, as glove-based systems do not have to worry about the environmental
conditions or occlusion of the hands. A wireless glove-based system would
additionally not require a user be tethered to their computer, resulting in
increased freedom of movement of the user.

Research in this area is significantly hampered by the fact that every
researcher has to create their own sensor suite due to the lack of affordable
and effective commercially available sensor gloves. And it is likely that the
lack of affordable and effective commercially available sensor gloves is due in
no small part to the lack of effective software to interpret the data coming
from them. This reciprocal dependency will likely only be solved if a company
with sufficient resources decides to create both a high quality sensor suite to
capture data _and_ a high quality software suite to interpret that data.

The fidelity of different gestures defined in the gesture recognition
literature vary significantly, as does the difficulty in classifying those
gestures. A whole hand waving motion requires very few sensors to register, but
is cumbersome for the user to perform repeatedly. These low-fidelity gestures
might be applicable for general low-frequency interactions such as music or
volume controls, but they are wholly unsuitable for high-frequency interactions
such as typing at a keyboard. _Ergo_ represents a high-fidelity solution which
is expressly designed for and capable of high-frequency interactions such as
the emulation of keyboard input. Much previous work has focussed on
low-fidelity <!-- TODO: add reference to Literature review here --> gesture
recognition where the time taken to perform each gesture makes those gestures
unsuitable for everyday computer
interaction\footnote{\cite{bevilacquaContinuousRealtimeGesture2010,
netoHighLevelProgramming2010, patilHandwritingRecognitionFree2016,
schlomerGestureRecognitionWii2008, aklAccelerometerbasedGestureRecognition2010,
aklNovelAccelerometerBasedGesture2011, riveraRecognitionHumanHand2017}}.

Much of the literature focusses on the traditional machine learning task of
classifying each class, but the frequently unaddressed issue is that there is
an additional class which often is excluded<!-- TODO: add citations and
reference to literature review here -->: the background non-gesture class. The
addition of this class to the classification task has been shown in this thesis
to significantly increase the difficulty of the problem. Additionally,
classifiers which perform well when just classifying the gesture classes are
not guaranteed to perform well when also required to detect those gesture
classes against the non-gesture class. The implicit segmentation of gestures
has been shown to dramatically improve the performance of a given classifier,
however this improved performance is misleading. These classifiers trained on
implicitly segmented datasets cannot generalise to real-world use because
gestures are not segmented in the real world. Implicitly segmented datasets are
toy datasets, and performance on them is not representative of real-world
performance. While it is an interesting problem with notable applications,
attempting a gesture recognition problem that does not require the classifier
to distinguish the background noise from the gestures of interest is of little
practical value. It is not clear of what use a gesture recognition model would
be if it had the built-in assumption that every observation could be classified
as _some_ gesture, with no means of deciding that no gesture were present.

<!-- TODO: Merge the following paragraphs Recommendations -->

This thesis has shown that real-time gesture recognition is a viable option for
keyboard emulation. Enough gesture classes can be classified to assign a
different gesture to every key on a standard English QWERTY keyboard, and the
gesture classes can be distinguished from the regular non-gesture movement of
the hand reliably enough that keystrokes are not sent when the user does not
intend them to be sent.

SVMs show good performance with little hyperparameter tuning, however FFNNs
show the best performance after hyperparameter tuning.

The development of this dataset and hardware
platform would not be trivial however, as it would need to have enough fidelity
to cover a wide variety of use-cases, while still being affordable enough and
easy enough to produce or distribute that other researchers would consider it a
preferable option to building their own. With hindsight this gap is clear, but
it was not obvious to the author in the beginning and as such, \emph{Ergo} was
not built with mass production or ease of recreation in mind. An ideal platform
would be able to measure the movement of all ten fingers and would require
minimal electronics knowledge to assemble, while still being reasonably priced.

Even if this platform were developed, it is still possible that it becomes
obfuscated after several years as better hardware components get developed.
Indeed, this is largely what happened to the various CyberGloves and
PowerGloves that were available in the 1990s and 2000s. They were used by many
researchers, but eventually were discarded due to improvements in the capability
of hardware. With vision-based systems, common datasets only started to become
the standard of gesture recognition once video recording technology became
standardised and stopped making substantial progress year over year.

<!-- TODO: Merge this in with the above paragraphs
The development of a common glove-based sensor suite would likely result in
significant progress being made in the creation and analysis of glove-based
gesture recognition datasets. A well-designed sensor suite and gesture
detection dataset would enable talented machine-learning researchers to apply
their talent to gesture recognition, regardless of their electronics
background. The current state of the field requires a candidate researcher to
have experience in both electronics development and machine learning. This
decreases the candidate pool, resulting in less progress.
-->

# Future Work \label{sec:06-future-work}

There are several avenues which are promising. Several emerging technologies
have not yet (in the author's opinion) been fully explored with regards to
their potential for gesture recognition, and could possible prove fruitful.
WiFi-based systems (see Section
\ref{sec:03-vision-and-wifi-based-gesture-recognition} and
\cite{maWiFiSensingChannel2020}) have been explored with regards to security ,
but could result in very good results when applied to gesture detection. This
is particularly interesting when one considers that the user need not interact
with any device explicitly. It could appear to "just work". However, the
privacy implications of this are very concerning\footnote{
\cite{aliKeystrokeRecognitionUsing2015, aliRecognizingKeystrokesUsing2017,
liWhenCSIMeets2016}} and also require more thought about how to provide a good
experience to the user while still communicating to the user when their
movements are being watched and recorded. Closed-Circuit television (CCTV) is
commonly used to monitor behaviour in public and the public largely know this.
However, very few people are aware of the capabilities of WiFi-based gesture
detection, making this avenue rife for attack from a malicious agent.

Surface Electromyography (sEMG, discussed in Section
\ref{sec:03-technologies-used} ) is also very promising (see
\cite{moinWearableBiosensingSystem2020}), as it requires only the user's
forearm to be measured but could provide information about the user's whole
hand movement by measuring muscle activity. Keeping one's hands clear and
unobstructed is often desirable for intricate movements and is often more
comfortable, making this technology worth pursuing. Current research requires
dense arrays of custom designed electrodes to be attached to the user's
forearm. This technology has promise, but requires a lot more work to be simple
to use. The NinaPro database \citep{atzoriNinaproDatabaseResource2015} is a
useful resource for sEMG controlled robotic hand prosthetics.

Future development on the \emph{Ergo} sensor suite would focus on portability:
The current system is tethered to the user's computer but it is technically
feasible for the suite to be completely wireless and battery powered. This
would enable \emph{Ergo} to provide an interface identical to that of a
Bluetooth keyboard. Turning \emph{Ergo} on would cause it to broadcast it's
availability as a Bluetooth keyboard to surrounding Bluetooth-enabled devices,
and on connection the user would be able to interact with those devices using
\emph{Ergo} exactly as though it were a keyboard. All machine learning
inference would be required to run on the microcontroller, however the speed
with which the FFNN makes predictions makes it possible that an optimised
neural network would be able to run on-device.
