<!---
Note: What you bring to the table is _fidelity_. There has been oodles of work
trying to classify big obvious gestures, but nothing that comes close to
replacing the keyboard. Nobody wants to wave their hands around just to type
the letter "a", but Ergo lets you do a simple motion and it is done.

Contributions:

- Gestures are far more subtle than found before
- Gestures can be completed far faster than before
- Application is explicitly for full computer interaction
- Many more gestures than before
- Glove is very unintrusive due to the fingernail design
- Segmentation is done automatically, which is often not considered
--->


\epigraph{
    In the beginning there was nothing, which exploded.
}{\textit{ Terry Pratchett }}

# Overview \label{sec:01-overview}

This thesis explores hand gesture recognition using an acceleration-based
fingertip-mounted sensor suite, with the goal of completely replicating the
functionality of a computer keyboard. The first attempts at automated hand
gesture recognition were in 1969 by the
\citeauthor{experimentaltelevisioncenterComputerImageCorporation1969}. Later
attempts used hand-mounted sensors to measure movement
 \citep{garyj.grimesUSPatentDigital1981,
kohonenSelforganizedFormationTopologically1982, jacobsenUTAHDextrousHand1984,
jacobsenDesignUtahDextrous1986, fisherTelepresenceMasterGlove1987,
zimmermanHandGestureInterface1987, thomasa.defantiUSNEAR60341631977}. Due to
improvements in video capture technology and computer vision algorithms, many
recent attempts used labelled videos of people performing different gestures
for gesture
recognition \citep{alazraiDatasetWiFibasedHumantohuman2020,
atzoriNinaproDatabaseResource2015, guyonChaLearnGestureChallenge2012,
materzynskaJesterDatasetLargeScale2019, zhangEgoGestureNewDataset2018}. Recent
changes in commercially available Wi-Fi routers
\citep{halperinToolReleaseGathering2011} have also enabled the detection of
hand gestures by analysing diagnostic data from these routers
\citep{puWholehomeGestureRecognition2013}. This is largely made possible by the
sensitivity of the diagnostics information to movements of the human body.

Gesture detection systems can be divided based on whether the user is required
to explicitly mark the start and end of their gestures (defined as "explicit
segmentation") or whether the user is allowed to make gestures at arbitrary
points in time (defined as "implicit segmentation"). Allowing the user to make
gestures at arbitrary points in time dramatically improves the experience for
the user and may be considered a requirement for a commercial product. Explicit
segmentation significantly reduces the complexity of classifying gestures. This
thesis will present an adequate solution to the more challenging problem of
implicit segmentation.

Gesture detection systems can also be divided by the number of gesture classes
that can be recognised. Media playback (such as pausing, playing, and skipping
songs) can be controlled with fewer than 10 gesture classes. Being able to
input the full English alphabet requires 26 gesture classes. This thesis will
present a solution capable of recognising 50 gesture classes, allowing the
input of the full English alphabet, the numbers 0 through 9, various
punctuation characters, and two meta-characters (shift and control).

This thesis uses a bespoke sensor suite named \emph{Ergo}, constructed for the
purpose of real-time high-fidelity gesture recognition (see Figure
\ref{fig:01_glove}).

\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.5\textwidth]{src/imgs/glove}
    \caption[Picture of \emph{Ergo}]{The sensor suite, \emph{Ergo}, as viewed
    from the user's perspective. The ten accelerometers (blue chips on the
    user's fingertips) are capable of recording 30 linear acceleration
    measurements at a rate of 40 times per second.}
    \label{fig:01_glove}
\end{figure}

One acceleration sensor is mounted onto each of the user's ten fingertips. Each
acceleration sensor is capable of recording a three-dimensional acceleration vector
every $\frac{1}{40} = 0.025$ seconds. This is equivalent to 1200 measurements
per second.

While wearing \emph{Ergo}, 50 different gestures are performed and the resulting
measurements are saved. This data is used to train several multi-class
classification algorithms to 1) distinguish intentional gestures from regular
hand movements, and 2) to predict which one of the 50 learnt gestures is being
performed. Regular hand movements are represented by the 51\textsuperscript{st}
class, while all other gestures are represented by first 50 classes.

To evaluate the difficulty of implicit segmentation when compared to explicit
segmentation, all classification algorithms are evaluated on three different
datasets. The first dataset has only five classes made up entirely of intentional
gestures. The second dataset is also made up entirely of intentional gestures,
but contains all 50 gestures for which data was captured. These two datasets
are representative of explicit segmentation. The third dataset contains all 50
gestures for which the data was captured, as well as the data representing
regular hand movements that occur before and after a gesture is made. This
dataset is representative of implicit segmentation.

The rest of this chapter is as follows: Section \ref{sec:01-problem-statement}
will describe the problem to be solved. Section \ref{sec:01-research-questions}
will pose the research questions related to the problem. Section
\ref{sec:01-contributions} lists the software and the dataset contributions of
the thesis. Section \ref{sec:01-thesis-structure} describes the structure of
the rest of the thesis and the layout of the chapters.

# Problem Statement \label{sec:01-problem-statement}

The problem statement is as follows:

\begin{framed}
    Ascertain the feasibility of a commercially-viable gesture recognition
    device that is capable of implicit segmentation, and evaluate its ability
    to replace a full QWERTY keyboard as an input device.
\end{framed}

The study evaluates multiple classification algorithms on three datasets with
5, 50, and 51 classes based on data collected from a custom made sensor suite.
An analysis of the performance and inference speed is performed, with a focus
on how completely \emph{Ergo} could replace a user's computer keyboard in
day-to-day use.

# Research Questions\label{sec:01-research-questions}

This study aims to address the following questions:

1. **Hardware construction and data capture**: The viability of off-the-shelf
   hardware components for high-frequency data capture is assessed. A custom
   sensor suite is designed and built to capture the movement of a user's
   fingertips with enough accuracy that many different gestures can be
   distinguished.
2. **Performance of different classification algorithms**: Five classification
   algorithms are assessed on the same dataset, each over a wide variety of
   hyperparameter combinations\footnote{\emph{hyperparameter} is defined as a
   parameter of an algorithm that is chosen by the researcher, as opposed to
   being chosen by the algorithm itself.}. The performance of each algorithm
   and of the different hyperparameter combinations is compared.
3. **Detecting gestures from background noise**: An assessment is made of the
   capability of any one algorithm to perform implicit segmentation.
4. **Performance impact of background sensor noise**: The requirement for an
   algorithm to perform implicit segmentation is likely to have a detrimental
   effect on that algorithm's performance. This impact is examined and
   discussed.
5. **Classification speed**: As _Ergo_ is to be a real-time keyboard
   replacement, the speed with which different classification algorithms can
   make accurate class predictions is recorded and evaluated.

# Contributions \label{sec:01-contributions}

The dataset used in this thesis containing acceleration measurements from
\emph{Ergo} is freely available on Zenodo:
\url{https://zenodo.org/records/10209419}. Both the raw sensor readings are
available, as well as the preprocessed data. During the process of performing a
literature review, a large number of papers were indexed by various metrics
(discussed in Section \ref{sec:03-overview}). A dataset of these papers and
metrics quantifying the papers is also available in the same Zenodo dataset.

The code used to train the classification algorithms, control the hardware, and
to make predictions using the raw sensor data in real time is available on
GitHub: \url{https://github.com/beyarkay/masters-code/}. The source code for
this thesis, as well as the code used to analyse the dataset of the literature,
is also available on GitHub: \url{https://github.com/beyarkay/masters-thesis/}.

# Thesis Structure \label{sec:01-thesis-structure}

The structure of the thesis is as follows:

- Chapter \ref{chap:introduction} has introduced the goals of the thesis.
- Chapter \ref{chap:background} provides background information related to the
  concepts discussed in this thesis.
- Chapter \ref{chap:literature-review} reviews the gesture-detection literature
  over the past 50 years.
- Chapter \ref{chap:methodology} describes how the data was collected, how the
  classification algorithms were trained, and how the performance of the
  classification algorithms was evaluated.
- Chapter \ref{chap:results} presents the results and evaluates the relative
  performance of each classification algorithms.
- Chapter \ref{chap:conclusion} concludes the thesis, summarising the findings
  and providing recommendations for future work.
- The Appendix has several sections, none of which are required for the thesis
  but which are presented for the interested reader: Appendix
  \ref{app:additional-figures} contains additional figures, Appendix
  \ref{app:additional-tables} contains additional tables, and Appendix
  \ref{app:the-human-hand} contains anatomical details about the human hand.
