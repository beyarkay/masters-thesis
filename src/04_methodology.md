<!-- prettier-ignore-start -->
\epigraph{
    We are trying to prove ourselves wrong as quickly as possible, because only
    in that way can we find progress.
}{\textit{  Richard P. Feynman  }}
<!-- prettier-ignore-end -->

The construction of \emph{Ergo} is discussed in Section
\ref{sec:04-construction-of-ergo}. Section
\ref{sec:04-gestures-and-class-labels} discusses the gestures which \emph{Ergo}
can recognise and how those gestures are systematically mapped onto class
labels. The method by which gestures are converted into keystrokes via class
predictions is discussed in Section
\ref{sec:04-the-conversion-of-class-predictions-into-keystrokes}. The procedure
for collecting, labelling, and cleaning the dataset is discussed in Section
\ref{sec:04-data-collection-and-cleaning}. The method for splitting the dataset
into training, validation, and testing datasets is discussed in Section
\ref{sec:04-splitting-the-data-into-train-test-validation}. The procedure
followed for conducting the experiments is discussed in Section
\ref{sec:04-experimental-procedure}. The procedure for converting binary
classifiers into multi-class classifiers is discussed in Section
\ref{sec:04-binary-and-multi-class-classifiers}. The procedure followed for
optimising the hyperparameters of each model type is discussed in Section
\ref{sec:04-procedure-for-hyperparameter-optimisation}. The implementation
details for each model type is discussed in Section
\ref{sec:04-model-design-and-implementation}. A means of ordering those classifiers is
discussed in Section \ref{sec:04-an-ordering-over-multi-class-classifiers}.

# Construction of Ergo \label{sec:04-construction-of-ergo}

\emph{Ergo} is a completely bespoke sensor suite, designed and constructed by
the author. \emph{Ergo} uses a suite of acceleration sensors mounted on the
user's fingernails to measure fingertip acceleration in real time (see Figure
\ref{fig:04_glove}). A full circuit diagram is available in the Appendix,
Figure \ref{fig:appendix_circuit_diagram}.

<!-- prettier-ignore-start -->
\begin{table}[!ht]
    \centering
    \begin{tabular}{cc}
        \begin{subfigure}{0.45\textwidth}
            \centering
            \includegraphics[height=4cm]{src/imgs/glove}
            \caption[\emph{Ergo} from user's perspective]{The left and right
            hands of \emph{Ergo}, showing the accelerometers mounted onto the
            fingernails and the Nano microcontrollers on the back of the user's
            hands.}
            \label{fig:04_glove}
        \end{subfigure} &
        \begin{subfigure}{0.45\textwidth}
            \centering
            \includegraphics[height=4cm]{src/imgs/ADXL335}
            \caption[ADXL335 accelerometer]{The ADXL335 tri-axis accelerometer,
            shown mounted on a breakout board.}
            \label{fig:04_adxl335}
        \end{subfigure} \\
        \begin{subfigure}{0.45\textwidth}
            \centering
            \includegraphics[height=4cm]{src/imgs/nano}
            \caption[Arduino Nano 33 BLE]{The Arduino Nano 33 BLE, shown with
            the header pins soldered onto the board.}
            \label{fig:04_nano}
        \end{subfigure} &
        \begin{subfigure}{0.45\textwidth}
            \centering
            \includegraphics[height=4cm]{src/imgs/CD74HC4067}
            \caption[CD74HC4067 multiplexer]{The CD74HC4067 multiplexer, shown
            mounted on a breakout board.}
            \label{fig:04_cd74hc4067}
        \end{subfigure}
    \end{tabular}
    \caption{The hardware components of \emph{Ergo}.}
    \label{tab:04_hardware}
\end{table}
<!-- prettier-ignore-end -->

The \textbf{ADXL335} tri-axis linear accelerometer by Analog Devices (Figure
\ref{fig:04_adxl335}) is used for acceleration measurements. They have low
power usage ($350 \mu$A typical), require 1.8V to 3.6V, and have an
acceleration range of $\pm 3$g. They measure static acceleration due to
gravity, making them useful in some applications for measuring the tilt of an
object relative to gravity. Ten ADXL335s are used (one per finger) and are
mounted onto the back of the user's fingernails to measure acceleration at the
fingertips. Each ADXL335 provides 3 analogue signal lines (one for each of X,
Y, and Z), resulting in 15 signal lines per hand.

The \textbf{Nano 33 Bluetooth Low Energy} (BLE) module by Arduino (Figure
\ref{fig:04_nano}) is multi-purpose chip containing a 64 megahertz (MHz) Arm
Cortex-M4F with 1 megabyte (MB) flash and 256 kilobytes (kB) Random Access
Memory (RAM), a 12 megabits per second (Mbps) Universal Serial Bus (USB) serial
connection, and eight 12-bit analogue inputs. One Nano is used per hand to read
the input from that hand's ADXL335s, however as the Nano only has 8 analogue
inputs but the ADXL335s provide 15 analogue signals per hand, a multiplexer is
required.

The \textbf{CD74HC4067} 16-channel analogue multiplexer/demultiplexer (Figure
\ref{fig:04_cd74hc4067}) is a low-power digitally controlled integrated circuit
which allow one of 16 signal lines to be selected by bringing each of the four
control lines to a high or low voltage. The four control lines act as a binary
selector: taking all four lines to a low voltage selects the first signal line,
and taking all four lines to a high voltage selects the 16\textsuperscript{th}
signal line.

By multiplexing 15 signal lines from the ADXL335s via the CD74HC4067 and
configuring the Nano to iterate through the signal lines, each of the 15
signals from the ADXL335s can be read and packaged together using only one of
the eight analogue input pins available on the Nano.

Before the signals can be sent to the user's computer, the packages from the
left and right hand must be combined. The Nano from the left hand is connected
via a serial wire to the right hand using the I\textsuperscript{2}C
(Inter-Integrated Circuit) serial communication protocol, commonly used for
communication between integrated circuits. When the left hand's Nano has read
data from every left-hand ADXL335, it transmits this data to the right hand via
this I\textsuperscript{2}C connection. The right hand then combines the data
from the left hand with the data from the right hand into one complete packet.

The Nano on the right hand then sends this complete packet to the user's
computer via a wired serial connection from serial port on the Nano to the USB
port on the user's computer.

On the user's computer, a script listens to the serial port and records all
incoming data. When a new packet of sensor measurements is received, the
current time is recorded. What happens next is dependant on whether the
software is configured to capture the data or to feed the data to a
classification model in real time. If configured to capture data, then all the
accelerometer measurements and time stamps will be stored to disc as one file,
each newline being one set of sensor readings. If configured to perform
classification, then the sensor readings will be streamed to a provided
classifier and the predictions will be surfaced to the user.

# Gestures and Class Labels \label{sec:04-gestures-and-class-labels}

_Ergo_ can recognise 50 gesture classes and one non-gesture class. The
non-gesture class is used to represent the empty durations in-between gestures
during which the user's hands may be still: the transitioning period from the
end of one gesture to the start of the next. The 50 gesture classes are
numbered from 0 to 49. The non-gesture class is numbered as class 50 The
software powering _Ergo_ takes care of converting a class prediction in the
range $[0, \ldots 50]$ into a keystroke (any Unicode Transformation Format
8-bit -- UTF8 -- character) via a user-configurable gesture-to-keystroke
mapping.

The motion for each gesture is defined as the Cartesian product of a finger
motion and a hand orientation. There are 10 finger motions: each motion defines
one finger flexing towards the palm of the user's hand. There are five
orientations: each defines the angle both hands make with the horizon, and are
$0^\circ, 45^\circ, 90^\circ, 135^\circ, 180^\circ$. The way in which these 10
fingers and 5 gestures combine to make 50 gestures is described in Table
\ref{tab:05_gestures}.

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left Hand} & \multicolumn{5}{c|}{Right Hand} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   &  0 &  1 &  2 &  3 &  4 &  5 &  6 &  7 &  8 &  9 \\
        \hline
        $45^\circ$  & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 \\
        \hline
        $90^\circ$  & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 \\
        \hline
        $135^\circ$ & 30 & 31 & 32 & 33 & 34 & 35 & 36 & 37 & 38 & 39 \\
        \hline
        $180^\circ$ & 40 & 41 & 42 & 43 & 44 & 45 & 46 & 47 & 48 & 49 \\
        \hline
    \end{tabular}
    \caption[Class labels $\to$ hand movements]{The cells of this table contain the different indices of the
    gestures which \emph{Ergo} can recognise. The index of each gesture is
    semantic: the units digit refers to the finger being flexed and the tens
    digit refers to the orientation of the hands. Each column of the table
    contains gestures where the finger being flexed is the same, and each row
    of the table contains gesture indices where the orientation of the gesture
    is the same.}
    \label{tab:05_gestures}
\end{table}
<!-- prettier-ignore-end -->

As previously mentioned, these 50 gestures are mapped to keystrokes via a
gesture-to-keystroke mapping. The default mapping is shown in Table
\ref{tab:05_keystrokes}. The gestures are defined in a manner that is similar
to the English QWERTY keyboard. For example, the gestures with an orientation
of $90^\circ$ are ordered in the same way as the keys on the home row of the
QWERTY keyboard. Flexing one's left little finger with an orientation of
$90^\circ$ is the same as using ones left little finger on the home row of the
QWERTY keyboard: both result in the keystroke "a". This allows new users to
easily learn which gestures map to which keystrokes.

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   & \texttt{control} &  \texttt{=} &  \texttt{'} &  \texttt{-} &  \texttt{[} &  \texttt{]} &  \texttt{space} &  \texttt{\textbackslash} &  \texttt{\`} &  \texttt{shift} \\
        \hline
        $45^\circ$  & \texttt{z} & \texttt{x} & \texttt{c} & \texttt{v} & \texttt{b} & \texttt{n} & \texttt{m} & \texttt{,} & \texttt{.} & \texttt{/} \\
        \hline
        $90^\circ$  & \texttt{a} & \texttt{s} & \texttt{d} & \texttt{f} & \texttt{g} & \texttt{h} & \texttt{j} & \texttt{k} & \texttt{l} & \texttt{;} \\
        \hline
        $135^\circ$ & \texttt{q} & \texttt{w} & \texttt{e} & \texttt{r} & \texttt{t} & \texttt{y} & \texttt{u} & \texttt{i} & \texttt{o} & \texttt{p} \\
        \hline
        $180^\circ$ & \texttt{1} & \texttt{2} & \texttt{3} & \texttt{4} & \texttt{5} & \texttt{6} & \texttt{7} & \texttt{8} & \texttt{9} & \texttt{0} \\
        \hline
    \end{tabular}
    \caption[Hand movements $\to$ keystrokes]{The default keystroke mappings for \emph{Ergo}. Note that the
    layout is similar to the QWERTY. \emph{Ergo} recognises control keys like
    \texttt{control} and \texttt{shift}, so the user can combine gestures to
    get new keystrokes.}
    \label{tab:05_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

# The Conversion of Class Predictions into Keystrokes \label{sec:04-the-conversion-of-class-predictions-into-keystrokes}

Converting sensor measurements into classifications is not enough, as they
still need to be converted into keystrokes. There are a few ambiguities to
clear up in order to make this process clear.

As only the neural-network based models natively support probabilities,
predictions will be assumed to be just one class label, as opposed to a
one-hot-encoded vector or a matrix of class probabilities. It is trivial to
convert between these formats, so there is no loss of generality.

If sequential predictions are made of the same class, then a keystroke will
only be emitted the first time that class is predicted. This will improve the
perceived performance of the model, so that one gesture does not result in
multiple keystrokes if the model predicts that gesture in multiple sequential
time steps. If a word has duplicated letters (such as the \texttt{o}'s in
\texttt{book}) then those duplicated letters must be performed the same number
of times as they are duplicated. Gesturing the word \texttt{book} is done by
gesturing the letters \texttt{b},\texttt{o}, \texttt{o}, \texttt{k}, with no
special case for the double \texttt{o}.

The predicted classes are converted to keystrokes using the
gesture to keystroke mapping. This mapping is configurable by the user, but by
default it is set up to mirror the QWERTY keyboard as closely as possible. The
mapping is visible in Table \ref{tab:04_keystrokes}

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   & \texttt{control} &  \texttt{=} &  \texttt{'} &  \texttt{-} &  \texttt{[} &  \texttt{]} &  \texttt{space} &  \texttt{\textbackslash} &  \texttt{\`} &  \texttt{shift} \\
        \hline
        $45^\circ$  & \texttt{z} & \texttt{x} & \texttt{c} & \texttt{v} & \texttt{b} & \texttt{n} & \texttt{m} & \texttt{,} & \texttt{.} & \texttt{/} \\
        \hline
        $90^\circ$  & \texttt{a} & \texttt{s} & \texttt{d} & \texttt{f} & \texttt{g} & \texttt{h} & \texttt{j} & \texttt{k} & \texttt{l} & \texttt{;} \\
        \hline
        $135^\circ$ & \texttt{q} & \texttt{w} & \texttt{e} & \texttt{r} & \texttt{t} & \texttt{y} & \texttt{u} & \texttt{i} & \texttt{o} & \texttt{p} \\
        \hline
        $180^\circ$ & \texttt{1} & \texttt{2} & \texttt{3} & \texttt{4} & \texttt{5} & \texttt{6} & \texttt{7} & \texttt{8} & \texttt{9} & \texttt{0} \\
        \hline
    \end{tabular}
    \caption[The default keystroke mappings for \emph{Ergo}]{The default
    keystroke mappings for \emph{Ergo}. Note that the layout is similar to the
    QWERTY. \emph{Ergo} recognises control keys like \texttt{control} and
    \texttt{shift}, so the user can combine gestures to get new keystrokes.}
    \label{tab:04_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

The mapping allows certain gestures to emit the \texttt{control} and the
\texttt{shift} non-printing characters. These characters, in addition to the
other printing characters, greatly extends the number of input a user can give.
As is natural for regular keyboard input, performing the gesture for
\texttt{shift} and then the gesture for the letter \texttt{a} would result in
the keystroke \texttt{A} being sent. This applies for all alphabetical
characters a--z, as well as the numerals 0--9 and various punctuation
characters. The effect of pressing \texttt{shift} before each character is
visible in Table \ref{tab:04_shift_keystrokes}. Empty cells indicate that shift
has no effect.

<!-- prettier-ignore-start -->
\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $0^\circ$   &   &  \texttt{+} &  \texttt{"} &  \texttt{\_} &  \texttt{\{} &  \texttt{\}} &    &  | &  \texttt{\~} &   \\
        \hline
        $45^\circ$  & \texttt{Z} & \texttt{X} & \texttt{C} & \texttt{V} & \texttt{B} & \texttt{N} & \texttt{M} & \texttt{<} & \texttt{>} & \texttt{?} \\
        \hline
        $90^\circ$  & \texttt{A} & \texttt{S} & \texttt{D} & \texttt{F} & \texttt{G} & \texttt{H} & \texttt{J} & \texttt{K} & \texttt{L} & \texttt{:} \\
        \hline
        $135^\circ$ & \texttt{Q} & \texttt{W} & \texttt{E} & \texttt{R} & \texttt{T} & \texttt{Y} & \texttt{U} & \texttt{I} & \texttt{O} & \texttt{P} \\
        \hline
        $180^\circ$ & \texttt{!} & \texttt{@} & \texttt{\#} & \texttt{\$} & \texttt{\%} & \texttt{\^} & \texttt{\&} & \texttt{$\ast$} & \texttt{(} & \texttt{)} \\
        \hline
    \end{tabular}
    \caption[\emph{Ergo} keystrokes with \texttt{shift} pressed]{
    This table shows what keystroke is emitted by the \emph{Ergo} software
    immediately after the \texttt{shift} control-character has been performed.}
    \label{tab:04_shift_keystrokes}
\end{table}
<!-- prettier-ignore-end -->

The \texttt{control} character also allows for some other keystrokes to be made, such
as carriage return (\texttt{ctrl+j} or \texttt{ctrl+m}), backspace
(\texttt{ctrl+h}), or escape (\texttt{ctrl+[}). These key combinations are the
same as in the text editor Vim\footnote{https://vim.org}. See vim's built-in
help \texttt{:h ins-special-keys} for more details.

# Data Collection and Cleaning \label{sec:04-data-collection-and-cleaning}

<!-- TODO: Picture of the data??? -->

To collect training data, the author wore _Ergo_ and performed each of the
pre-specified gestures sequentially, repeating each gesture until there was
approximately 100 observations of each gesture. The sensor measurements were
stored to disc as the gestures were being performed, along with a timestamp of
when the measurements were received from the hardware.

Real-time data labelling of the data with the gesture being performed is not
possible due to the author's hands being required to perform the data.

One gesture was performed approximately every half a second, with error due to
the human difficulty of timing a hand gesture within 0.025 seconds. In order to
facilitate the labelling of this data, annotations were made every half second,
and each gesture was performed such that they were aligned with the annotation.
These annotations serves no purpose other than to indicate that a gesture was
performed close to it.

After recording the data, labels are manually assigned to a single time step.
Each gesture gets a different label, and the labels for each gesture are
positioned such that they are all aligned to the same part of a gesture. For
example, each label might represent the peak of a gesture, in which case
_every_ label is positioned such that all observations of the same gesture are
maximally similar to one another.

The labelling process has to be done with care, as preliminary model training
showed that poorly aligned labels lead to very poor performance. If one label
is aligned with the start of a gesture and the other with the middle of the
gesture, all models struggle to generalise.

To enable the collection and labelling of a large dataset, gestures were
performed in batches of 5 unique classes at a time. For example, one data
recording session might record data for gestures 0, 1, 2, 3, 4. Then the next
session for gestures 5, 6, 7, 8, 9. And the next for gestures 10, 11, 12, 13, 14.
And so on, for all gestures from 0 through to 49. The data from each session
was saved in a separate file. Reducing the number of gestures present in a file
allowed for easier labelling. The sensor data immediately before and after an
annotation could be manually analysed and compared against the known five
gesture classes which are present in that file. The annotation can then be replaced
with a label for that gesture class, and the position in time of that label can
be adjusted such that the new observation and all previous observations are
aligned as close as possible to one another.

The measurements recorded from _Ergo_ are stored on disk as several files which
lists the time stamp, the 30 sensor values recorded at that time stamp, and the
gesture associated with that time stamp. There are 37MB and 241 762
observations, 235 995 of which belong to class 50 and the remaining 5 767 are
the gesture classes.

# Splitting the Data into Train, Test, Validation \label{sec:04-splitting-the-data-into-train-test-validation}

Preliminary modelling showed that models trained on just a single instant of time
did not perform as well as models provided with a historical window of 20 time
steps of data.

For this reason, the dataset is windowed such that it contains a sequence of
observations, where each observation has 20 time steps of history and 30 sensor
values per time step. Each observation has an overlap of 19 time steps with the
observations immediately preceding and following it. Each observation only has
1 label which is the label for the most recent time step in its 20 time steps.
20 time steps is equivalent to half a second of sensor measurements. <!-- TODO:
I think a figure will be good here to clarify what you mean.... --> Every model
is presented with the same data format, although some models cannot handle
two-dimensional data and so the input is flattened to one dimension before
being used for inference.

Note that the imbalance between the gesture classes and the non-gesture class
means that there are about 40 times more non-gesture observations than
gesture-class observations. When describing the training, validation, and
testing datasets, both the number of observations (including the non-gesture
class) and the number of gesture observations (excluding the non-gesture class)
will be reported.

25% of the dataset (60 294 observations, 1 442 gesture class observations) is
split off and saved as the testing dataset. The testing dataset is saved as a
single binary file, completely separate from the training and validation data.
The test-set splitting procedure was stratified by the class labels, ensuring
that the frequency of the different classes is maintained. Apart from this
constraint, the subset of data used for the testing set is random.

The remaining 75% of the dataset (181 321 total observations, 4 325 gesture
class observations) is saved to disc as a single binary file. This dataset will
be referred to as the training-validation dataset. The training-validation
dataset is only split into separate training and validation datasets at
training time, just before each model is fit to the training subset.

This split is random, but the pseudo-random number generator (PRNG) used to
make the split is initialised with a seed based on the model type,
hyperparameter set, and repetition number. This ensures that each
training-validation split is different but can be reproduced.

Splitting the dataset into training and validation datasets based on a PRNG
also allows for an arbitrary number of repetitions to be made for cross
validation. Of the 75% of the dataset set aside for training/validation, 75%
(135 990 observations, 3 243 gesture class observations) is used for training
leaving 25% (45 330 observations, 1 078 gesture class observations) for
validation. This split is also stratified by the class labels, such that the
proportions of each class is kept as equal as possible.

A confidence interval can be obtained for the performance of each model, as
each set of hyperparameters is trained and evaluated multiple times on a random
subset of the training-validation dataset. Because the exact same model is
trained on different subsets of the training-validation dataset, a distribution
of the performance of that model can be estimated. From this distribution, the
90% confidence interval can be obtained by calculating the performance range
that 90% of models with the same hyperparameters would achieve. This
distribution can be used to compare models and evaluate which will most likely
perform well on on the test set and other unseen data which might have a
different underlying distribution to the training-validation dataset.

# Experimental Procedure \label{sec:04-experimental-procedure}

Experiments will be conducted so as to answer the research questions posed in
the Chapter \ref{sec:01-research-questions}. As each model type has a
different hyperparameter space, the experiments for each of the five model
types will be performed separately. Additionally, there will be experiments for
5-, 50-, and 51-class datasets.

The 5-class dataset is constructed by only including classes 0, 1, 2, 3, and 4
from the full training-validation dataset. These are the gestures performed by
the left hand oriented to be parallel to the ground. This excludes class 50
(the non-gesture class). The 50-class dataset is constructed by including only
gestures 0 through to 49 from the full training-validation dataset, also
excluding the non-gesture class. The 51-class dataset is equivalent to the full
training-validation dataset.

For each model and each of the 5-, 50-, and 51-class datasets, a number of
different hyperparameter combinations will be randomly chosen and tested. The
number of hyperparameter combinations will depend on the model type, as the
size of the search space of each model is different.

For example, the HMMs have only one discrete hyperparameters (covariance type)
which can take on four values. This means that the HMM hyperparameter search
space can be fully explored with only four hyperparameter combinations. This is
a stark contrast to the HFFNNs, which have 18 continuous hyperparameters (nine
per FFNN). These 18 continuous hyperparameters will need significantly more
than four hyperparameter combinations in order to explore this continuous
18-dimensional search space. Table \ref{tab:04_num_iterations} shows the number
of search space iterations for each model type and each number of classes (5,
50, or 51), and Table \ref{tab:04_fitting_time} shows the amount of time spent
for each model type and each number of classes (5, 50, or 51).

<!-- TODO: add better details talking about these tables -->

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \begin{tabular}{l|r r r|r}
                        & \textbf{5 classes}  & \textbf{50 classes} & \textbf{51 classes} & \textbf{Total} \\
        \hline
        \textbf{CuSUM}  & 182                 & 68                  & 78                  & 328 \\
        \textbf{FFNN}   & 83                  & 55                  & 148                 & 286 \\
        \textbf{HFFNN}  & -                   & -                   & 88                  & 88 \\
        \textbf{HMM}    & 62                  & 26                  & 20                  & 108 \\
        \textbf{SVM}    & 200                 & 129                 & 57                  & 386 \\
        \hline
        \textbf{Total}  & 527                 & 278                 & 391                 & 1196 \\
    \end{tabular}
    \caption{Total number of iterations per model and per number of gesture classes.}
    \label{tab:04_num_iterations}
\end{table}
<!-- prettier-ignore-end -->

<!--- TODO 25m for 51-class HMM seems wrong... -->

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \begin{tabular}{l|r r r|r}
                        & \textbf{5-classes} & \textbf{50-classes} & \textbf{51-classes} & \textbf{Total} \\
        \hline
        \textbf{CuSUM}  & 43.37s             & 3m 0.95s            & 3h 6m 7.04s         & 3h 9m 51.36s \\
        \textbf{FFNN}   & 8m 51.85s          & 11m 3.45s           & 19h 44m 7.76s       & 20h 4m 3.05s \\
        \textbf{HFFNN}  & -                  & -                   & 9h 50m 56.30s       & 9h 50m 56.30s \\
        \textbf{HMM}    & 5m 45.51s          & 33m 21.18s          & 25m 17.45s          & 1h 4m 24.14s \\
        \textbf{SVM}    & 40.66s             & 10m 53.66s          & 11h 27m 38.20s      & 11h 39m 12.52s \\
        \hline
        \textbf{Total}  & 16m 1.39s          & 58m 19.24s          & 44h 34m 6.76s       & 45h 48m 27.39s \\
    \end{tabular}
    \caption{Total fitting time per model and per number of gesture classes.}
    \label{tab:04_fitting_time}
\end{table}
<!-- prettier-ignore-end -->

For all models, each hyperparameter combination will be tested five times, each
time using different randomly selected partitions of the training-validation
dataset.

For each repetition, the predictions the model makes on both its training and
validation data is stored to disc, along with the ground truth labels for that
data. For ease of analysis, some summary metrics are calculated and recorded
such as training and validation $F_1$-score, recall, and precision. The time
taken to fit each model is stored, along with the time taken to perform
inference. The FFNNs also have their final training and validation loss stored
to disc. This procedure is described in Algorithm
\ref{alg:04_model_evaluation}.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{Hyperparameter Search and Model Evaluation}
\label{alg:04_model_evaluation}
\begin{algorithmic}
\State $\bm{C} \gets \{5, 50, 51\}$ \Comment{Number of classes}
\State $\bm{M} \gets \{$FFNN, HFFNN, CuSUM, HMM, SVM$\}$ \Comment{Model types}
\For{$C$ in $\bm{C}$} \Comment{Iterate over number of classes}
    \For{$M$ in $\bm{M}$} \Comment{Iterate over model types}
        \For{$n$ in $1..n_{\text{combinations}}$} \Comment{Number of combinations for the model type}
            \State Select a random hyperparameter combination
            \For{$R$ in $1..5$} \Comment{Five repetitions}
                \State Split the training-validation dataset
                \State Train model $M$ on the training dataset
                \State Evaluate model $M$ on the validation dataset
                \State Save model performance
            \EndFor
        \EndFor
    \EndFor
\EndFor
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

After experimentation, all the data required to evaluate which model performs
the best on the validation dataset has been collected. When a best-performing
model has been identified, the test dataset will be used to gauge how
well that model is able to generalise to unseen data.

In addition to evaluating the best-performing model on the unseen test dataset,
the model will be evaluated on an unseen English language dataset. This dataset
is small (9405 observations, 44 gestures), but contains sensor measurements
recorded while the user performed the gestures for an English sentence. This
dataset gives insight into the real-time performance an end-user will
experience.

The hardware used to train the various models is an 14-inch 2021 MacBook Pro
laptop with the Apple M1 Pro chip and 16 gigabytes (GB) of Low Power Double
Data Rate 5 (LPDDR5) memory. The machine has 8 performance-oriented cores and 2
efficiency-oriented cores.

# Binary and Multi-class Classifiers \label{sec:04-binary-and-multi-class-classifiers}

Some classification algorithms have support for multi-class classification
built-in to the classification procedure. Examples would be Feed Forward Neural
Networks or Decision trees. The training and classification procedure for these
algorithms does not depend on whether the task is binary or multi-class
classification.

Other classification algorithms only support binary classification and cannot
natively perform multi-class classification. Examples would be Hidden Markov
Models or Support Vector Machines. Binary classification algorithms can be
converted into $n$-class ($n>2$) classification algorithms by creating an
ensemble of $n$ binary classifiers. In this setup, the $i$-th binary classifier
would be trained to predict if a given observation belongs either to class $i$
or to some class other than class $i$.

To predict the class of an observation, each of these $n$ classifiers will make
a prediction for that same observation. A well trained ensemble will have only
one binary classifier predicting YES and all other classifiers predicting NO
for a given observation. This procedure for using an ensemble of binary
classifiers as a multi-class classifier is called one-vs-rest classification.

# Procedure for Hyperparameter Optimisation \label{sec:04-procedure-for-hyperparameter-optimisation}

Hyperparameter optimisation is the procedure of searching over a space of
hyperparameters, with the goal of finding a set of hyperparameters which
optimise some objective function. As _Ergo_ has five different model types with
five different hyperparameter spaces, hyperparameter optimisation is done
separately for each model type. Each procedure is identical, except for the
model type being evaluated.

Finding new methods for computationally efficient hyperparameter optimisation
is a field of active research. Broadly there are three kinds of hyperparameter
optimisation: grid search, random search, and various means of more intelligent
search\footnote{\cite{bergstraAlgorithmsHyperParameterOptimization2011,
jamiesonNonstochasticBestArm2015, shahriariTakingHumanOut2016}}.

Grid search is the simplest to implement, and requires that each hyperparameter
is a finite set. Grid search will then iterate over every
combination of the hyperparameters, calculating the objective value in each
case. If there are $N$ hyperparameters $h_1, h_2, \ldots, h_N$, and
each hyperparameter $h_i$ has $n_i$ possible values, then the total number of
hyperparameter combinations to search is $\prod_{i=1}^N n_i$.

Once every hyperparameter combination has been evaluated, the hyperparameter
combination which resulted in the optimal objective value is selected as the
best.

This approach often requires a very large computational budget due to the
number of hyperparameter combinations which must be evaluated. The researcher
is also required to discretise continuous hyperparameters, and only these
chosen values will be tested. If the optimal hyperparameter combination is far
from the values chosen by the researcher, a sub-optimal result will be
returned.

Grid search is useful in circumstances where interpretability of the influence
of different hyperparameters is valued over the optimisation of the objective
function. Because every combination of hyperparameters is tested, it is trivial
to observe the marginal effect one hyperparameter has on the objective function
without concern of the effect the other hyperparameters might have on the
objective function.

Random search trades some amount of the interpretability return for an improved
ability to find better hyperparameters faster. Random search can trivially
handle continuous hyperparameters. As the randomly selected value for some
continuous hyperparameter $h_i$ is almost surely different from any previous
choice for the same hyperparameter, the marginal search of that
hyperparameter is improved.

Random search has the attractive quality that -- in contrast to grid search --
the computational budget is independent of the number of hyperparameters one
wishes to explore. As a trade off, the ability to directly infer the influence
any hyperparameter has on the objective value is hampered. This is because one
no longer has examples where the hyperparameter of interest is modified while
all other hyperparameters remain constant.

As a comparison between grid search and random search, consider a search space
of five continuous hyperparameters, with a computational budget of 1000
evaluations of the objective function.

This is enough to either search $\approx 4$ values of each of the five
hyperparameters (for grid search), or 1000 values of all five hyperparameters
(for random search), with the caveat that the influence of each hyperparameter
can not be compared as easily. As the number of hyperparameters increases, the
number of values per hyperparameter collapses exponentially.

The final method for hyperparameter search, intelligent search, is a collection
of intelligent methods which all attempt to explore the hyperparameter space
and then automatically exploit regions of search space which look promising.

These methods often have a hyperparameter themselves, which adjusts how much
the algorithm will explore the search space or exploit known regions of good
performance. These methods all sacrifice human interpretability, as regions
which are suspected of poor performance are quickly omitted from the search
space. For this reason, they were not explored as options for hyperparameter
optimisation.

# Model Design and Implementation \label{sec:04-model-design-and-implementation}

This section discusses each model type and explains the implementation thereof.
Hidden Markov Models will be described in Section \ref{model-specifics-hmm},
Cumulative Sum in Section \ref{model-specifics-cusum},
Feed-Forward Neural Networks in Section \ref{model-specifics-ffnn},
Hierarchical Feed-forward Neural Networks in Section \ref{sec:04-model-specifics-hffnn},
and Support Vector Machines in Section \ref{models-specifics-svm}.

## Hidden Markov Models \label{model-specifics-hmm}

<!-- TODO:

Describe in detail how the HMM can't really be trained with the full
dataset because it can't fit into memory. And it's beyond the scope to
batch-ify it. And the 50-class FFNNs already show superior performance. Need to
give the math for why HMMs don't work with >100k observations

-->

Hidden Markov Models (HMMs, introduced in Section
\ref{sec:02-hidden-markov-models}) are able to model the progression of time
via sequential states and their transition probability matrices. For this
reason, each HMM classifier attempts to model an observation as a sequence of
22 states: a start state, one state for each of the 20 time steps, and an end
state. Each state emits a 30-dimensional Gaussian distribution (one dimension
for each of the 30 sensors). The mean vector $\bm{\mu}$ and the covariance
matrix $\bm{\Sigma}$ of the Gaussian are estimated using the Baum-Welch
expectation maximisation algorithm.

HMMs do not natively support multi-class classification, and as such
one-vs-rest classification is used. There is one HMM for each class, including
the non-gesture class. To reduce the number of parameters which need to be
learned, the covariance matrices for each HMM can be one of four different
types. These covariance types each constrain the covariance matrix such that
the full matrix need not be learned. In order from most constrained to least
constrained:

- Spherical covariance matrix: each state uses a single variance value that
  applies to all features: $\lambda I$ where $\lambda \in \mathbb{R}$ and $I$
  is the $30 \times 30$ identity matrix.
- Diagonal covariance matrix: each state uses a diagonal covariance matrix.
  $\bm{\lambda} I$ where $\bm{\lambda} \in \mathbb{R}^{30}$
- Tied covariance matrix: each state use the same shared, full covariance
  matrix.
- Full covariance matrix: each state uses its own full, unrestricted,
  covariance matrix.

Calculating the number of parameters in each of the covariance types provides a
crude estimate for the complexity, and can be seen in Table
\ref{tab:04_covariance_comparison}.

<!-- prettier-ignore-start -->
\begin{table}[!ht]
    \centering
    \caption{Comparison of Covariance Types in a Gaussian Mixture Model}
    \label{tab:04_covariance_comparison}
    \begin{tabular}{|c|c|c|c|c|}
        \hline
        Covariance Type & \#Gaussians   & Parameters/Gaussian & Total Parameters \\
        \hline
        Full            & 22            & $30 \times 30$      & 19800            \\
        Tied            & 1             & $30 \times 30$      & 900              \\
        Diagonal        & 22            & 30                  & 660              \\
        Spherical       & 22            & 1                   & 22               \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

The forward algorithm makes it possible to calculate the log-likelihood that a
given observation originated from a given HMM. To make a class prediction for a
certain observation, the forward algorithm is used to obtain the log-likelihood
of that observation for each HMM. These 50 log-likelihoods are compared and the
HMM providing the maximum log-likelihood is selected as the prediction for that
observation. If the HMM trained on class 5 provided the maximum log-likelihood
for a given observation, then the predicted class would be class 5.

Significant problems were encountered while training the HMMs due to the number
of observations of class 50. Training times for the class 50 HMM either
exceeded 6 hours (at which point they were stopped) or were killed by the
operating system due to excessive memory usage. For this reason, all HMMs were
only trained on a subset of 1000 randomly selected observations of class 50.
During calculation of the validation performance, all HMMs were evaluated on
all validation observations.

Table \ref{tab:04_hpar_dists_hmm} shows the hyperparameters for the HMMs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{HMM hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_hmm}
    \begin{tabular}{|c|c|c|c|}
        \hline
         Hyperparameter & Range & Distribution \\
        \hline
        Number of Iterations & 20                                          & Fixed \\
        Covariance Type      & $\{ \text{Spherical}, \text{Diagonal}, \text{Full}, \text{Tied} \}$ & Categorical \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Cumulative Sum \label{model-specifics-cusum}

Cumulative Sum (CuSUM, introduced in Section \ref{sec:02-cumulative-sum}) is designed
for real-time univariate time-series out-of-distribution detection. It cannot
natively support multivariate multi-class classification, and so some
adjustments are required.

The term _CuSUM algorithm_ will be used to refer to the univariate time series
out-of-distribution detection algorithm, as described in Algorithm
\ref{alg:cusum} in Section \ref{sec:02-cumulative-sum}.

In order to classify a given observation as belonging to one of 51 classes, a
one-vs-rest approach will be used. 51 different CuSUM classifiers will be
trained, where the $i$th CuSUM classifier predicts whether or not a given
observation belongs to class $i$.

Each of these classifiers will be made up of 30 CuSUM algorithms, one for each
time series of sensor measurements. The $i$th classifier will learn which of
these 30 CuSUM algorithms raise an alert when presented with an observation
belonging to the $i$th class. The procedure for learning which alerts from
which CuSUM algorithms is associated with which classes is given in Algorithm
\ref{alg:04-cusum-training} and the procedure for performing inference is given
in Algorithm \ref{alg:04-cusum-inference}.

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption{CuSUM Training Algorithm}
    \label{alg:04-cusum-training}
    \begin{algorithmic}[1]
        \State $ \text{training\_alerts} \leftarrow \mathbb{0}_{30, n_{\text{classes}}}$ \Comment{Initialise training\_alerts to a matrix of zeros}
        \For{$i$ in $1 \ldots n_{\text{classes}}$}
            \State $\text{subset} \leftarrow \text{observations belonging to class}\,i$
            \For{$\text{observation}$ in $\text{subset}$}
                \For{$j$ in $1$ to $30$}
                    \If{CuSUM algorithm $j$ alerting for observation?}
                        \State $\text{training\_alerts}_{ij} \mathrel{+}= 1$
                    \EndIf
                \EndFor
            \EndFor
            \State $\text{training\_alerts}_{ij} = \frac{\text{training\_alerts}_{ij}}{|\text{subset}|}$
        \EndFor
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption{CuSUM Inference Algorithm}
    \label{alg:04-cusum-inference}
    \begin{algorithmic}[1]
        \State $\text{alerts} \leftarrow \mathbb{0}_{30}$ \Comment{Initialise alerts to vector of zeros}
        \For{$j$ in $1\ldots 30$}
            \If{CuSUM algorithm $j$ alerting for observation?}
                \State $\text{alerts}_j \leftarrow 1$
            \EndIf
        \EndFor
        \State $\text{best\_class} \leftarrow \text{None}$
        \State $\text{best\_distance} \leftarrow \infty$
        \For{$i$ in $1\ldots n_{\text{classes}}$}
            \State $\text{distance} \leftarrow \|\text{alerts} - \text{training\_alerts}_i\|$
            \If{$\text{distance} \mathrel{<} \text{best\_distance}$}
                \State $\text{best\_distance} \leftarrow \text{distance}$
                \State $\text{best\_class} \leftarrow i$
            \EndIf
        \EndFor
        \State \textbf{return} $\text{best\_class}$
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

Table \ref{tab:04_hpar_dists_cusum} shows the hyperparameter values for CuSUM.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{CuSUM hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_cusum}
    \begin{tabular}{|c|c|c|}
        \hline
        Hyperparameter & Range & Distribution \\
        \hline
        Threshold            & $\{5, 10, 20, 40, 60, 80, 100\}$            & Categorical \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Feed-Forward Neural Networks \label{model-specifics-ffnn}

The Feed-Forward Neural Networks (FFNNs, introduced in Section
\ref{sec:02-artificial-neural-networks}) were implemented using the TensorFlow library for the
Python3 programming language. Each FFNN is modelled as a sequence layers, where
each layer performs a transformation on its input and provides output to the
next layer. The input $20 \times 30$ matrix is flattened into a 600 dimensional
vector before being passed to the FFNN.

FFNNs are sensitive to the scale of the input data, and so the input data is
normalised to have approximately zero mean and approximately unit variance
before being passed to the FFNN. For each of the 600 dimensions, the mean
$\mu_i$ and standard deviation $\sigma_i$ ($i \in \{1, \ldots, 600\}$) of the
training data is calculated. These statistics are not calculated using the
validation data, as that would leak information about the validation data to
the model. These means and standard deviations are then stored.

To normalise an unseen observation $\bm{x}$, each element $x_i$ in $\bm{x}$ has
the $i$-th mean subtracted from it and is then divided by the $i$-th standard
deviation:

$$
    \frac{x_i - \mu_i}{\sigma_i}
$$

This ensures that the mean of each element in $\bm{x}$ is approximately zero
and the variance is approximately 1.

The loss function of every FFNN is categorical cross entropy loss, defined as:

$$
    L(\bm{y}, \hat{\bm{y}}) = -\sum_{i=1}^n y_i \cdot \log(\hat{y}_i) \cdot \text{weight}_i
$$

Where:

- $y_i \in \{0, 1\}$ is the ground truth prediction for class $i$.
- $\hat{y}_i \in [0, 1]$ is the predicted probability for class $i$.
- The summation is performed over all $n$ classes.
- $\text{weight}_i$ is the weight of class $i$.

The weight of each class is determined by $\text{weight}_i = -\log_{10}\left(
{\text{count}_i} \right)$, where $\text{count}_i$ is the number of samples in
the class.

L2 normalisation is applied to the loss function such that the model is
penalised for weights which are too large. The strength of regularisation is
controlled by the L2 coefficient hyperparameter. A regularisation term is added
to the loss function: $\text{L2} \cdot \sum_w w^2$, where L2 is the L2
coefficient hyperparameter and the sum iterates over every weight in the
network.

The activation function of each fully connected layer is the ReLU activation
function:

<!-- prettier-ignore-start -->
\begin{align*}
    \text{ReLU}(x) = \begin{cases}
        x, & \text{if } x > 0 \\
        0, & \text{if } x \leq 0
    \end{cases}
\end{align*}
<!-- prettier-ignore-end -->

The dropout rate hyperparameter controls the probability that the activation of
any neuron is set to zero during training. To compensate for the lower sum of
activations being passed to the next layer, the neurons which were not set to
zero have their output scaled up by $(1 - \text{dropout rate})^{-1}$. This
ensures the sum of the output of all neurons remains the same regardless of
exactly how many neurons were dropped out. Dropout is only applied during
training, as it is a regularisation technique to decrease overfitting; no
neurons have their output set to zero during inference.

The number of neurons in the last layer of the FFNN depends on the number of
classes being predicted, and is either 5, 50, or 51.

The optimiser used is the Adam optimiser \citep{kingmaAdamMethodStochastic2014}
with a constant learning rate that is determined by the learning rate
hyperparameter. Constant values of $\beta_1=0.9$, $\beta_2=0.999$, and
$\hat{\epsilon}=10^{-7}$ are used for the Adam hyperparameters, as suggested by
Kingma and Ba.

Every FFNN completes 40 epochs of trainined, after which it is evaluated on the
validation dataset. Summary statistics are stored to disc, as well as the full
vectors of ground truth labels and predicted labels for that particular
training-validation split. Table \ref{tab:04_hpar_dists_ffnn} shows the
hyperparameters for the FFNNs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{FFNN hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_ffnn}
    \begin{tabular}{|c|c|c|c|}
        \hline
         Hyperparameter & Range & Distribution \\
        \hline
         Epochs               & 40                                          & Fixed \\
         Batch Size           & $[2^6, 2^8]$                                & Logarithmic \\
         Learning Rate        & $[10^{-6}, 10^{-1}]$                        & Logarithmic \\
         Optimizer            & Adam                                        & Fixed \\
         Number of Layers     & \{1, 2, 3\}                                 & Categorical \\
         Nodes per Layer      & $[2^2, 2^9]$                                & Logarithmic \\
         L2 Coefficient       & $[10^{-7}, 10^{-4}]$                        & Logarithmic \\
         Dropout Rate         & $[0.0, 0.5]$                                & Linear \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Hierarchical Feed-forward Neural Networks \label{sec:04-model-specifics-hffnn}

Hierarchical Feed-forward Neural Networks (HFFNNs) are an extended version of
the FFNN and operate by combining the output of two FFNNs, each of which is
trained on a different subset of the training data.

One FFNN (called the majority classifier) is a binary classifier in charge of
detecting whether or not a gesture exists in the observation. The other FFNN
(called the minority classifier) is only invoked if there is a gesture present
in an observation, as detected by the majority FFNN.

Algorithm \ref{alg:hffnn_prediction} shows the procedure for making a
prediction using the majority and minority classifiers.

<!-- prettier-ignore-start -->
\begin{algorithm}
    \caption{Prediction Algorithm For HFFNNs}
    \label{alg:hffnn_prediction}
    \begin{algorithmic}
        \Require X \Comment{Array of observations}
        \State Initialize an empty array $\bm{y}$ of the same length as $X$
        \For{$i = 1$ to length($X$)}
            \If{\Call{PredictWithMajority}{$X_i$} = 0}
                \State $y_i \gets$ \Call{PredictWithMinority}{$X_i$}
            \Else
                \State $y_i \gets 50$
            \EndIf
        \EndFor
        \State \textbf{return} $\bm{y}$
    \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

The minority and majority classifiers each have the same hyperparameters as the
FFNNs, with the addition that the majority and minority FFNN can be trained for
a variable number of epochs each, in the range from 5 to 40. Table
\ref{tab:04_hpar_dists_hffnn} shows the hyperparameters for the HFFNNs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{HFFNN hyperparameters, ranges, and distributions. The
    hyperparameter distributions are the same but independent for the majority
    and minority classifiers.}
    \label{tab:04_hpar_dists_hffnn}
    \begin{tabular}{|c|c|c|}
        \hline
        Hyperparameter & Range & Distribution \\
        \hline
        Epochs               & $[5, 40]$                                   & Linear \\
        Batch Size           & $[2^6, 2^8]$                                & Logarithmic \\
        Learning Rate        & $[10^{-6}, 10^{-1}]$                        & Logarithmic \\
        Optimizer            & Adam                                        & Fixed \\
        Number of Layers     & \{1, 2, 3\}                                 & Categorical \\
        Nodes per Layer      & $[2^2, 2^9]$                                & Logarithmic \\
        L2 Coefficient       & $[10^{-7}, 10^{-4}]$                        & Logarithmic \\
        Dropout Rate         & $[0.0, 0.5]$                                & Linear \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

## Support Vector Machines \label{models-specifics-svm}

Support Vector Machines (SVMs, introduced in Section \ref{sec:02-support-vector-machines}) do not
support multi-class classification natively, and so a one-vs-rest technique is
used to enable an ensemble of SVMs to make multi-class classifications. The
input $20 \times 30$ matrix is flattened into a 600 dimensional vector before
being passed to the SVMs.

All SVMs were trained for 200 iterations with a linear kernel. One
hyperparameter, the class weight, was iterated to weight the influence of each
class based on it's prevalence in the training dataset. The hyperparameter $C$
controls the regularisation and is used in the same way as described in the
Section \ref{sec:02-support-vector-machines}. Table \ref{tab:04_hpar_dists_svm}
describes the hyperparameters for the SVMs.

<!-- prettier-ignore-start -->
\begin{table}
    \centering
    \caption{SVM hyperparameters, ranges, and distributions}
    \label{tab:04_hpar_dists_svm}
    \begin{tabular}{|c|c|c|c|}
        \hline
         Hyperparameter & Range & Distribution \\
        \hline
         $C$                  & $[10^{-6}, 1]$                              & Logarithmic \\
         Class Weights        & $\{ \text{Balanced}, \text{Unbalanced} \}$  & Categorical \\
         Maximum Iterations   & 200                                         & Fixed \\
        \hline
    \end{tabular}
\end{table}
<!-- prettier-ignore-end -->

# An Ordering Over Multi-class Classifiers \label{sec:04-an-ordering-over-multi-class-classifiers}

In order that the best model can be chosen, an ordering must be defined. This
ordering should work given solely the list of predictions and the list of
ground truth values.

A single metric will be calculated using the unweighted average $F_1$-score
over all classes.

Each set of hyperparameters will be evaluated five times, each time calculating
the unweighted average $F_1$-score on the validation dataset. From these five
$F_1$-scores, a 90% confidence interval will be calculated. The lower bound of
this confidence interval shall be used to rank the models.

Using the lower bound of the confidence ensures that the best-ranked model did
not just have a single outlier performance which achieved a high $F_1$-score,
but rather consistently achieved a high $F_1$-score across all validation sets
and all random initialisations. This means that the resulting model is more
likely to generalise to unseen data.
