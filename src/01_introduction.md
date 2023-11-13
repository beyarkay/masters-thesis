<!---
Note: What you bring to the table is _fidelity_. There has been oodles of work
trying to classify big obvious gestures, but nothing that comes close to
replacing the keyboard. Nobody wants to wave their hands around just to type
the letter "a", but Ergo lets you do a simple motion and it's done.

Contributions:

- Gestures are far more subtle than found before
- Gestures can be completed far faster than before
- Application is explicitly for full computer interaction
- Many more gestures than before
- Glove is very unintrusive due to the fingernail design
- Segmentation is done automatically, which is often not considered
--->

<!-- prettier-ignore-start -->
\epigraph{
    In the beginning there was nothing, which exploded.
}{\textit{ Terry Pratchett }}
<!-- prettier-ignore-end -->

# Overview \label{sec:01-overview}

This thesis explores gesture recognition using an acceleration-based
fingertip-mounted sensor suite, with the goal of completely replicating the
functionality of a computer keyboard. Gesture recognition has a long history,
going back to the first attempts in 1969 by the
\citeauthor{experimentaltelevisioncenterComputerImageCorporation1969}. Initial
attempts used various kinds of sensors mounted on the user's hands to measure
movement. With the improvements in computer vision algorithms, many recent
attempts focus on improving performance on shared datasets containing labelled
videos of people performing different
gestures\footnote{\cite{alazraiDatasetWiFibasedHumantohuman2020,
atzoriNinaproDatabaseResource2015, guyonChaLearnGestureChallenge2012,
materzynskaJesterDatasetLargeScale2019, zhangEgoGestureNewDataset2018}}. Recent
changes in commercially available Wi-Fi routers
\citep{halperinToolReleaseGathering2011} have also enabled the detection of
hand gestures by analysing diagnostics data from these routers
\citep{puWholehomeGestureRecognition2013}.

Work done on gesture detection is notably divided based on whether the
application allows the user to make gestures at arbitrary points in time
(implicit segmentation), or whether the user is required to explicitly mark the
start and end of their gestures (explicit segmentation). Implicit segmentation
dramatically improves the experience for the user and may be considered a
requirement for a commercial product. Explicit segmentation significantly
reduces the complexity of classifying gestures. This thesis will present an
adequate solution to the former.

A bespoke sensor suite, named \emph{Ergo}, has been constructed and is used to
measure the acceleration of a user's fingertips in real time (see Figure
\ref{fig:01_glove}).

<!-- prettier-ignore-start -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.5\textwidth]{src/imgs/glove}
    \caption[Picture of \emph{Ergo}]{The sensor suite, \emph{Ergo} as viewed
    from the user's perspective. The accelerometers (the blue chips on the
    user's fingertips) are capable of recording tri-axis linear acceleration at
    40 Hz.}
    \label{fig:01_glove}
\end{figure}
<!-- prettier-ignore-end -->

This sensor suite was designed and constructed by the author for the purpose of
gesture recognition, and is capable of recording one 3-dimensional acceleration
vector for each of the user's ten fingertips every 0.025 seconds. This is
equivalent to 1200 measurements per second.

Using this data, several multi-class classification algorithms are trained 1)
to distinguish intentional gestures from regular hand movements, and if an
intentional gesture is detected, 2) to predict which one of the 50 learnt
gestures is being performed.

To evaluate the difficulty of implicit segmentation when compared to explicit
segmentation, all classification algorithms are evaluated on three different
datasets. The first is explicitly segmented and has only five classes. The
second is also explicitly segmented but includes 50 different gesture classes.
The third requires the classification algorithm to implicitly segment the
intentional gestures from the background hand movements and has 51 classes
(with the 51\textsuperscript{st} class representing all background hand
movements).

The rest of this chapter is as follows\footnote{This chapter has broken
references some sections that look like ?? because I've excluded the content of
all other chapters so that the PDF easier to manage. These references will be
fixed when the entire PDF is compiled as one document.}: Section
\ref{sec:01-problem-statement} will describe the problem to be solved. Section
\ref{sec:01-research-questions} will pose the research questions related to the
problem. Section \ref{sec:01-contributions} lists the software and the dataset
contributions of the thesis. Finally, Section \ref{sec:01-thesis-structure}
describes the structure of the thesis and the layout of the chapters.

# Problem Statement \label{sec:01-problem-statement}

<!-- prettier-ignore-start -->
\begin{framed}
    Ascertain the feasibility of a commercially viable gesture recognition
    device that is capable of implicit segmentation, and evaluate its ability
    to replace a full QWERTY keyboard as an input device.
\end{framed}
<!-- prettier-ignore-end -->

Existing glove-based gesture classification research either requires the start
and end of each gesture to be explicitly marked or is only able to recognise a
small number of gestures. Either of these constraints render the research
impractical for real-world usage as a keyboard replacement.

Recent developments in computational hardware and machine learning research
mean that using glove-based acceleration data to classify gestures is more
likely than ever to succeed. Such success would provide a product that could
replace regular computer keyboards with a more ergonomic\footnote{
\emph{ergonomic} is defined here to mean a device designed for efficiency
and comfort in the working environment.
} alternative.

A study of the above description is considered, evaluating multiple
classification algorithms on datasets with 5, 50, and 51 classes. The 5- and
50-class datasets include only intentional gestures, while the 51-class dataset
uses the 51\textsuperscript{st} class to represent the background movement
which is unrelated to any gestures being made by the user. An analysis of the
inference speed is performed, with a focus on how completely \emph{Ergo} could
replace a user's computer keyboard in day-to-day use.

# Research Questions\label{sec:01-research-questions}

Addressing the concerns mentioned earlier, a set of research questions is
presented. These inquiries will steer the execution of experiments and the
examination of the ensuing outcomes.

The study aims to address the following points:

1. **Hardware construction and data capture**: The viability of off-the-shelf
   hardware components for high-frequency data capture is assessed. A custom
   sensor suite is designed and built to capture the movement of a user's
   fingertips with enough fidelity that many different gestures can be
   distinguished.
1. **Performance of different classification algorithms**: Five classification
   algorithms are assessed on the same dataset over a wide variety of
   hyperparameter\footnote{\emph{Hyperparameter} is defined as a parameter of
   an algorithm that is chosen by the researcher, as opposed to being chosen by
   the algorithm itself.} combinations. The performance of each algorithm is
   compared, as well as the impact different hyperparameters have on each
   algorithm's performance.
1. **Detecting gestures from background noise**: The capability of any one
   algorithm to both detect a gesture from the background noise and classify
   that gesture into one of 50 gesture classes is assessed.
1. **Performance impact of background noise**: The requirement for an algorithm
   to distinguish background noise is likely to have a detrimental effect on
   the model's performance on classifying the gestures. This impact is examined
   and discussed.
1. **Classification speed**: As _Ergo_ is to be a real-time keyboard
   replacement, the speed with which different models can make gesture
   predictions is recorded and evaluated. This is done so as to determine
   whether or not \emph{Ergo} can be used in real time, as well to determine
   which classification algorithms are best suited to real-time prediction.

# Contributions \label{sec:01-contributions}

The dataset used in this thesis is freely available on
[Zenodo](https://zenodo.org/)\footnote{I am yet to upload the dataset, I want
to double check some details with you before I do so}. Both the raw sensor
readings are available, as well as the pre-windowed and processed data.

The code used to train the classification algorithms, control the hardware, and
to make predictions using the raw sensor data in real time is available on
[GitHub](https://github.com/beyarkay/masters-code/)\footnote{This repo is
private for now, is there any problem with me making it public now or should I
wait for the hand-in date?}.

# Thesis Structure \label{sec:01-thesis-structure}

The structure of the thesis is as follows:

- Chapter \ref{chap:introduction} has introduced the goals of the thesis and
  what will be explored in the coming chapters.
- Chapter \ref{chap:background} provides background information relating to the
  concepts discussed in this thesis in-depth discussion of the various models
  used throughout.
- Chapter \ref{chap:literature-review} reviews the gesture-detection literature
  over the past 50 years and compares the different subfields as split by the
  data collection methodology, the classification algorithm used, the number of
  gesture classes which could be recognised, and the intended application of
  the research.
- Chapter \ref{chap:methodology} describes how data was collected, how
  classifiers were trained on the collected data, and how the performance of
  the trained classifiers was evaluated.
- Chapter \ref{chap:results} presents the results found after training the
  various classifiers, and evaluates the relative performance of those
  classifiers.
- Chapter \ref{chap:conclusion} concludes the thesis, summarising the results
  and providing recommendations for future work.
- The Appendix has several sections, none of which are required for the thesis
  but which are presented for the interested reader: Appendix
  \ref{app:additional-analysis} contains some additional analysis, Appendix
  \ref{app:additional-figures} contains additional figures, and Appendix
  \ref{app:additional-tables} contains additional tables.
