# Introduction

\footnote{TODO: rewrite the introduction}

Ergo comes from Ergonomic or the latin for *therefore*.

----

<!---
\begin{figure}[!htb]
\centering
\includegraphics[width=0.6\textwidth, angle=270]{src/imgs/glove.png}
\caption{\emph{Ergo} collects data from sensors mounted at the user's
fingertips. These data are classified into gestures, which are mapped to
keystrokes and then sent to the user's computer as regular keyboard input.}
\label{fig:glove}
\end{figure}
--->

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
