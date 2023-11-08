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

# Overview

This thesis explores gesture recognition using an acceleration-based
fingertip-mounted sensor suite, with the goal of completely replicating the
functionality of a computer keyboard.

Gesture recognition has a long history, going back to the first attempts in
19XX (TODO: reference). Initial attempts used various kinds of sensors mounted
on the user's hands to measure movement. With the improvements in computer
vision algorithms, many recent attempts focus on improving performance on
shared datasets containing labelled videos of people performing different
gestures. Recent changes in commercially available Wi-Fi routers have also
enabled the detection of hand gestures by analysing diagnostics data from these
routers.

Work done on gesture detection is notably divided based on whether the
application allows the user to make gestures at arbitrary points in time
(implicit segmentation), or whether the user is required to explicitly mark the
start and end of their gestures (explicit segmentation). Implicit segmentation
dramatically improves the experience for the user and may be considered a
requirement for a commercial product. Explicit segmentation significantly
reduces the complexity of classifying gestures. This thesis will succeed at the
former.

A bespoke sensor suite, named \emph{Ergo}, has been constructed and is used to
measure the acceleration of a user's fingertips in real time. This sensor suite
was designed and constructed by the author for the purpose of gesture
recognition, and is capable of recording one 3-dimensional acceleration vector
for each of the user's ten fingertips every 0.025 seconds. This is equivalent
to 1200 measurements per second.

Using this data, several multi-class classification algorithms are trained 1)
to distinguish intentional gestures from regular hand movements, and if an
intentional gesture is detected, 2) to predict which one of 51 learnt gestures
is being performed.

To evaluate the difficulty of implicit segmentation when compared to explicit
segmentation, all classification algorithms are evaluated on three different
datasets. The first is explicitly segmented and has only five classes. The
second is also explicitly segmented but includes 50 different gesture classes.
The third requires the classification algorithm to implicitly segment the
intentional gestures from the background hand movements and has 51 classes
(with the 51\textsuperscript{st} class representing all background hand
movements).

# Problem Statement

Existing glove-based gesture classification research either requires the start
and end of each gesture to be explicitly marked or is only able to recognise a
small number of gestures. Either of these constraints render the research
impractical for real-world usage as a keyboard replacement.

Recent developments in computational hardware and machine learning research
mean that using glove-based acceleration data to classify gestures is more
likely than ever to succeed. Such success would provide a product that could
replace regular computer keyboards with a more ergonomic alternative.

A study of the above description is considered, evaluating multiple
classification algorithms on datasets with 5, 50, and 51 classes. The 5- and
50-class datasets include only intentional gestures, while the 51-class dataset
uses the 51\textsuperscript{st} class to represent the background movement
which is unrelated to any gestures being made by the user. An analysis of the
inference speed is performed, with a focus on how completely \emph{Ergo} could
replace a user's computer keyboard in day-to-day use.

# Research Questions

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
   hyperparameter\footnote{Is hyperparameter too much jargon for the
   introduction?} combinations. The performance of each algorithm is compared,
   as well as the impact different hyperparameters have on each algorithm's
   performance.
1. **Detecting gestures from background noise**: The capability of any one
   algorithm to both detect a gesture from the background noise and classify
   that gesture into one of 50 gesture classes is assessed.
1. **Performance impact of background noise**: The requirement for an algorithm
   to distinguish background noise is likely to have a detrimental effect on
   the model's performance on classifying the gestures. This impact is examined
   and discussed, with reference to research that does not attempt to recognise
   gestures from background noise.
1. **Classification speed**: As _Ergo_ is to be a real-time keyboard
   replacement, the speed with which different models can make gesture
   predictions is recorded and evaluated.

<!--
TODO: Nothing is said about how high-fidelity Ergo is compared to other work
which just strapped a sensor onto the back of someone's hand and called it
done. Ergo is able to pick up much smaller movements than anything else out
there, so the user has a much nicer time and doesn't have to make unwieldy
full-hand movements.
-->

# Contributions

The dataset used in this thesis is freely available on
[Zenodo](https://zenodo.org/). Both the raw sensor readings are available, as
well as the pre-windowed and processed data.

The code used to train the classification algorithms, control the hardware, and
to make predictions using the raw sensor data in real time is available on
[GitHub](https://github.com/beyarkay/masters-code/).

# Thesis Structure

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

<!-- TODO:
This report describes _Ergo_, a novel gesture-based method of interacting with
a computer, visible in Figure \ref{fig:glove}. _Ergo_ provides an intuitive
means of data input, and can be customised to fit the user's requirements.

Extensive use of a regular computer keyboard can cause chronic hand, wrist, and
forearm pain for the user [@roll2016]. One common cause is that the repetitive
motions required to operate a regular commercial keyboard often put the fingers
in awkward or uncomfortable positions for long periods of time [@rempel2008].

_Ergo_ is a method for interacting with a computer that allows the user to
customise how their hands need to move for each keystroke. It consists of ten
accelerometers, with one accelerometer mounted on the back of each of the
user's fingertips. This allows the acceleration in each fingertip to be
measured. The user is able to make pre-defined movements in the air such as
flexing individual fingers, and _Ergo_ is able to classify these movements as
one of a set of known gestures. These classifications are automatically mapped
to keyboard input, allowing the user to move their hands and control their
computer.

_Ergo_ allows users who either have, or are at risk of having, hand pain to
avoid certain hand motions. _Ergo_ also allows advanced users to fully
customise how they interact with their computer.

To accomplish this, the sensor measurements from the ten accelerometers are
collected at a rate of forty times per second. A fixed-size time window of the
most recent measurements are kept, such that in each time step a new measurement
is added to the time window and the oldest measurement is removed from the time
window. The size of this time window is determined from the training data, but
is usually between 5 and forty time steps (between 0.125 seconds and 1 second).
This time window is passed through a machine learning model which classifies
the motions being made by the user's hands as one of a pre-determined set of
gestures.

The model makes a new prediction at every time step, and this stream of
predictions is converted to keystrokes via a user-defined configuration file.
This file describes which gestures should be mapped to what keyboard input.
Some post-processing is done to ensure that only a single keystroke is emitted
for each gesture, even though the model is making a new prediction forty times per
second.

The remainder of this report is as follows. Section \ref{requirements}
describes the functional and technical requirements of _Ergo_. Section
\ref{design-and-implementation} goes through the hardware and software design
and provides details about the gestures used, how the models were trained, how
the models were evaluated, and the usage of _Ergo_ as a keyboard replacement.
Section \ref{testing} describes how the software controlling _Ergo_ was tested.
The Appendix \ref{appendix} contains sections relating to the hardware
components, various formulae and definitions, and a review of previous work
done by the author.

This report focusses on the software engineering aspects of interfacing with
the purpose-built hardware, training machine learning models to predict
gestures, and mapping those gestures to keystrokes. A review of research done
in the formal literature as well as by hobbyists is available in Appendix
\ref{related-work}.
-->
