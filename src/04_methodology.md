\epigraph{
    We are trying to prove ourselves wrong as quickly as possible, because only
    in that way can we find progress.
}{\textit{ Richard P. Feynman }}

This chapter discusses the process of collecting the dataset, interpreting the
dataset, and running experiments on the dataset. Section
\ref{sec:04-construction-of-ergo} discusses the construction of \emph{Ergo}.
Section \ref{sec:04-gestures-and-class-labels} discusses the gestures which
\emph{Ergo} can recognise, how those gestures are mapped onto class labels, and
how those class labels are converted into keystrokes. Section
\ref{sec:04-data-collection-and-cleaning} discusses how the dataset is
collected, labelled, and cleaned. Section
\ref{sec:04-splitting-the-data-into-train-test-validation} discusses how the
full dataset is split into training, validation, and testing datasets. Section
\ref{sec:04-experimental-procedure} discusses what experiments were conducted
and the procedure followed while conducting those experiments. Section
\ref{sec:04-procedure-for-hyperparameter-optimisation} discusses the procedure
followed for optimising the hyperparameters of each model type. Section
\ref{sec:04-model-design-and-implementation} discusses The implementation
details for each model type. Section
\ref{sec:04-ranking-the-classification-algorithms} discusses a means of ranking
those classifiers.

<!-- TODO: reorder the above list of sections -->

# Construction of Ergo \label{sec:04-construction-of-ergo}

\emph{Ergo} is an accelerometer-based sensor suite, fully designed and
constructed by the author due to the lack of high-fidelity and cost effective
alternatives (see Figure \ref{fig:04_glove}). There are ten acceleration
sensors (one mounted on each of the user's fingernails) which measure fingertip
acceleration in real time. A full circuit diagram is available in the Appendix,
Figure \ref{fig:appendix_circuit_diagram}.

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

For acceleration measurements, the ADXL335 tri-axis linear accelerometer by
Analog Devices (Figure \ref{fig:04_adxl335}) is used. They have low power usage
($350 \mu$A typical), require between 1.8 and 3.6 volts (V), and have an
measurable acceleration range of $\pm 3$g\footnote{$1g$ is the acceleration of
an object in a vacuum near the surface of earth, approximately $9.81 ms^{-2}$}.
In addition to dynamic acceleration they also measure static acceleration due
to gravity. Each accelerometer provides 3 analogue signal lines (one for each
of X, Y, and Z), resulting in 15 signal lines per hand.

The \textbf{Arduino Nano 33 Bluetooth Low Energy} (BLE) module (Figure
\ref{fig:04_nano}) is multi-purpose chip containing a 64 megahertz (MHz) Arm
Cortex-M4F with 1 megabyte (MB) flash and 256 kilobytes (kB) Random Access
Memory (RAM), a 12 megabits per second (Mbps) Universal Serial Bus (USB) serial
connection, and eight 12-bit analogue inputs. One Arduino Nano is used per hand
to read the input from that hand's accelerometers, however as the Arduino Nano
only has 8 analogue inputs but the accelerometers provide 15 analogue signals
per hand, a multiplexer is required.

The \textbf{CD74HC4067} 16-channel analogue multiplexer/demultiplexer (Figure
\ref{fig:04_cd74hc4067}) is a low-power digitally-controlled integrated circuit
which allows one of 16 input signals to be routed to an output signal by
setting four selection signals to have some combination of low and high
voltages. This is required as the Arduino Arduino Nano does not have 15 analogue
inputs. By configuring the Arduino Nano to iterate through the first 15 settings of the
four selection signals on the multiplexer, each of the 15 signals from the
accelerometers can be read and packaged together using only one of the input
pins available on the Arduino Nano.

Before the signals can be sent to the user's computer, the sensor measurements
from the left hand must be joined with the sensor measurements of the right
hand. The Arduino Nano from the left hand is connected via a serial wire to the
right hand using the I\textsuperscript{2}C communication protocol\footnote{The
Inter-Integrated Circuit serial communication protocol is commonly used for
communication between integrated circuits.}. When the left hand's Nano has read
data from every accelerometer on the left hand, it transmits this data to the
right hand via the I\textsuperscript{2}C connection. The right hand's Arduino
Nano then combines the data from the left hand with the data from the right
hand into one complete packet of sensor measurements. This packet is then sent
to the USB port on the user's computer via the serial port on the Arduino Nano.

On the user's computer, a script listens to the serial port and records all
incoming data. When a new packet of sensor measurements is received, the
current time is recorded. If the script is configured to capture data, then all
the accelerometer measurements and time stamps will be stored to disc as one
file. If the script is configured to perform classification, then the sensor
readings will be streamed to a provided classifier and the predictions will be
surfaced to the user.

# Gestures, Class Labels, and Keystrokes \label{sec:04-gestures-and-class-labels}

_Ergo_ can recognise 50 gesture classes and one non-gesture class. The
non-gesture class is used to represent the empty durations in-between gestures,
during which the user's hands may be still. The 50 gesture classes are numbered
from 0 to 49. The non-gesture class is numbered as class 50. The software
powering _Ergo_ takes care of converting a class prediction into a
keystroke\footnote{A valid keystroke for \emph{Ergo} is any sequence of Unicode
Transformation Format 8-bit (UTF-8) characters} via a user-configurable
gesture-to-keystroke mapping.

The movement performed by the user's hands for each gesture is defined as the
Cartesian product of one of ten finger motions and one of five hand
orientations, producing fifty gestures. Each finger motion defines one finger
flexing towards the palm of the user's hand. Each hand orientation defines the
level of supination\footnote{Supination is where the forearm and hand rotate to
bring the palm facing upward.} or pronation\footnote{Pronation is the movement
of the forearm and hand that turns the palm facing downward.} that both hands
make with the horizon: $0^\circ, 45^\circ, 90^\circ, 135^\circ,$ or
$180^\circ$. The way in which these 10 fingers and 5 gestures combine to make
50 gestures is described in Table \ref{tab:05_gestures}.

\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left Hand} & \multicolumn{5}{c|}{Right Hand} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $180^\circ$ & 40 & 41 & 42 & 43 & 44 & 45 & 46 & 47 & 48 & 49 \\
        \hline
        $135^\circ$ & 30 & 31 & 32 & 33 & 34 & 35 & 36 & 37 & 38 & 39 \\
        \hline
        $90^\circ$  & 20 & 21 & 22 & 23 & 24 & 25 & 26 & 27 & 28 & 29 \\
        \hline
        $45^\circ$  & 10 & 11 & 12 & 13 & 14 & 15 & 16 & 17 & 18 & 19 \\
        \hline
        $0^\circ$   &  0 &  1 &  2 &  3 &  4 &  5 &  6 &  7 &  8 &  9 \\
        \hline
    \end{tabular}
    \caption[Class labels $\to$ hand movements]{The cells of this table contain
    the number of the gestures which \emph{Ergo} can recognise. The number of
    each gesture is semantic: the units digits indicate which finger is being flexed
    and the tens digits indicate the orientation of the hands.}
    \label{tab:05_gestures}
\end{table}

As previously mentioned, these 50 gestures classes are mapped to keystrokes via
a gesture-to-keystroke mapping. The default gesture-to-keystroke mapping is
similar to the English QWERTY keyboard, allowing new users to easily learn
which gestures map to which keystrokes. This default mapping is shown in Table
\ref{tab:05_keystrokes}.

\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $180^\circ$ & \texttt{1} & \texttt{2} & \texttt{3} & \texttt{4} & \texttt{5} & \texttt{6} & \texttt{7} & \texttt{8} & \texttt{9} & \texttt{0} \\
        \hline
        $135^\circ$ & \texttt{q} & \texttt{w} & \texttt{e} & \texttt{r} & \texttt{t} & \texttt{y} & \texttt{u} & \texttt{i} & \texttt{o} & \texttt{p} \\
        \hline
        $90^\circ$  & \texttt{a} & \texttt{s} & \texttt{d} & \texttt{f} & \texttt{g} & \texttt{h} & \texttt{j} & \texttt{k} & \texttt{l} & \texttt{;} \\
        \hline
        $45^\circ$  & \texttt{z} & \texttt{x} & \texttt{c} & \texttt{v} & \texttt{b} & \texttt{n} & \texttt{m} & \texttt{,} & \texttt{.} & \texttt{/} \\
        \hline
        $0^\circ$   & \texttt{control} &  \texttt{=} &  \texttt{'} &  \texttt{-} &  \texttt{[} &  \texttt{]} &  \texttt{space} &  \texttt{\textbackslash} &  \text{\textasciigrave} & \texttt{shift} \\
        \hline
    \end{tabular}
    \caption[Hand movements $\to$ keystrokes]{The default keystroke mappings
    for \emph{Ergo}. Note that the layout is identical to the QWERTY keyboard.
    \emph{Ergo} recognises control keys like \texttt{control} and
    \texttt{shift}, so the user can combine gestures to get new keystrokes.}
    \label{tab:05_keystrokes}
\end{table}

The control characters \texttt{control} and \texttt{shift} can also be mapped
to gestures, greatly extendind the number of input a user can give through
combining the control characters with regular character. As is natural for
regular keyboard input, the capital letter \texttt{A} is input by first
performing the gesture for \texttt{shift} and then performing the gesture for
\texttt{a}. The effect of pressing \texttt{shift} before each character is
visible in Table \ref{tab:04_shift_keystrokes}.

\begin{table}[h]
    \centering
    \begin{tabular}{|c|c|c|c|c|c|c|c|c|c|c|}
        \hline
        & \multicolumn{5}{|c|}{Left} & \multicolumn{5}{c|}{Right} \\
        \hline
        & Little & Ring & Middle & Index & Thumb & Thumb & Index & Middle & Ring & Little \\
        \hline
        $180^\circ$ & \texttt{!} & \texttt{@} & \texttt{\#} & \texttt{\$} & \texttt{\%} & \texttt{\textasciicircum} & \texttt{\&} & \texttt{$\ast$} & \texttt{(} & \texttt{)} \\
        \hline
        $135^\circ$ & \texttt{Q} & \texttt{W} & \texttt{E} & \texttt{R} & \texttt{T} & \texttt{Y} & \texttt{U} & \texttt{I} & \texttt{O} & \texttt{P} \\
        \hline
        $90^\circ$  & \texttt{A} & \texttt{S} & \texttt{D} & \texttt{F} & \texttt{G} & \texttt{H} & \texttt{J} & \texttt{K} & \texttt{L} & \texttt{:} \\
        \hline
        $45^\circ$  & \texttt{Z} & \texttt{X} & \texttt{C} & \texttt{V} & \texttt{B} & \texttt{N} & \texttt{M} & \texttt{<} & \texttt{>} & \texttt{?} \\
        \hline
        $0^\circ$   & \texttt{control}  &  \texttt{+} &  \texttt{"} &  \texttt{\_} &  \texttt{\{} &  \texttt{\}} &  \texttt{space} &  | &  \texttt{~} & \texttt{shift} \\
        \hline
    \end{tabular}
    \caption[\emph{Ergo} keystrokes with \texttt{shift} pressed]{
    This table shows what keystroke is emitted by the \emph{Ergo} software
    immediately after the \texttt{shift} control-character has been performed.}
    \label{tab:04_shift_keystrokes}
\end{table}

The \texttt{control} character also allows for some other keystrokes to be made, such
as carriage return (\texttt{ctrl+j} or \texttt{ctrl+m}), backspace
(\texttt{ctrl+h}), or escape (\texttt{ctrl+[}). These key combinations are the
same as in the text editor Vim\footnote{https://vim.org}. See Vim's built-in
help \texttt{:h ins-special-keys} for more details.

If sequential predictions are made of the same class, then a
keystroke will only be emitted the first time that class is predicted. This
will improve the perceived performance of the model, so that one gesture cannot
result in multiple keystrokes if the model predicts that gesture for sequential
timesteps. If a word has duplicated letters (such as the \texttt{o}'s in
\texttt{book}) then those duplicated letters must be performed the same number
of times as they are duplicated. Gesturing the word \texttt{book} is done by
gesturing the letters \texttt{b}, \texttt{o}, \texttt{o}, \texttt{k}, with no
special case for the double \texttt{o}.

# Data Collection and Cleaning \label{sec:04-data-collection-and-cleaning}

To collect the dataset, \emph{Ergo} was worn while performing each of the
gestures described in subsection \ref{sec:04-gestures-and-class-labels}. The
sensor measurements were recorded in real time and stored to disc along with a
timestamp. The order in which gestures are performed is decided by the same
program which stores the data. This order is indicated to the user through an
on-screen display showing the current gesture to be performed as well as the
next gesture to be performed. This allows a gesture label to be stored along
with the sensor data. Due to human error, the labels are unlikely to be
consistently aligned with their gestures; this is fixed by manually adjusting
the labels for every gesture after the data has been recorded.

One gesture was performed by the author every half a second until each gesture
had been performed approximately 100 times. This creates a 30-dimensional time
series with one set of sensor measurements every 0.025 seconds (or
equivalently, 40 sets of sensor measurements every second). Figure
\ref{fig:05_sensors_over_time_3230_30} shows the sensor measurements as one
gesture is being performed.

<!-- TODO: redraw this plot -->
\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/05_sensors_over_time_3230_30}
    \caption[\emph{Ergo} sensor data for one gesture]{The sensor data for
    \emph{Ergo} as a single gesture is being performed.}
    \label{fig:05_sensors_over_time_3230_30}
\end{figure}


To enable the collection and labelling of a large dataset, gestures were
performed in batches of 5 gestures at a time. For example, one data recording
session might record data for gestures 0, 1, 2, 3, 4. Then the next session for
gestures 5, 6, 7, 8, 9. And so on, for all gestures from 0 through to 49. Class
50 is assigned to all sets of sensor measurements which were not assigned a
gesture label.

The measurements recorded from _Ergo_ are stored on disc as several files where
each line contains a time stamp, the 30 sensor values recorded at that time
stamp, and the gesture associated with that time stamp. There are 37MB and 241
762 lines of data, 235 995 of which belong to class 50 and the remaining 5 767
belong to the gesture classes.

To improve performance, the original dataset is broken down into overlapping
segments called windows. See Figure \ref{fig:04_windowing_diagram} for a
diagram explaining this process on a 1-dimensional time series. For the
\emph{Ergo} dataset, each window captures a subset of the 30-dimensional time
series that is 20 consecutive timesteps in length, and subsequent windows have
a one-set overlap with there predecessors. Each window will be referred to as
an observation, and this is what will be provided to each model for it to base
its predictions on. The class labels for each observation are _not_ windowed:
there is one label for each observation\footnote{An alternative formation using
a sequence of 20 class labels to match the 20 time steps of data did not show
significantly better performance during preliminary testing.}.

\begin{figure}
    \centering
    \begin{tikzpicture}
        \def\boxsize{0.8cm}
        \tikzstyle{box} = [draw, minimum size=\boxsize, node distance=0.05cm]
        \tikzstyle{label} = [above, font=\bfseries]
        % Draw a label "full dataset"
        \node[label] at (5.5*\boxsize, 0.45) {Full dataset};
        % Draw 10 boxes in a row for the full dataset
        \foreach \j in {1,...,10} {
            \node[box] (box\j) at (\j*\boxsize, 0) {$t_{\j}$};
        }
        % Draw some cdots to show that the dataset continues past t_10
        \node (boxdots) at (11*\boxsize, -0.1) {$\cdots$};
        % Draw a label for "window 1"
        \node[label] at (4.5*\boxsize, -0.95) {Window 1};
        % Draw the boxes for the first window
        \foreach \j in {1,...,8} {
            \node[box] (box2\j) at (\j*\boxsize, -1.6*\boxsize) {$t_{\j}$};
        }
        % Draw a label for "window 2"
        \node[label] at (5.5*\boxsize, -2.2) {Window 2};
        % Draw the boxes for the second window
        \foreach \j in {2,...,9} {
            \node[box] (box3\j) at (\j*\boxsize, -3.2*\boxsize) {$t_{\j}$};
        }
        % Draw a label for "window 3"
        \node[label] at (6.5*\boxsize, -3.5) {Window 3};
        % Draw the boxes for the third window
        \foreach \j in {3,...,10} {
            \node[box] (box4\j) at (\j*\boxsize, -4.8*\boxsize) {$t_{\j}$};
        }
        % Draw some vdots to indicate that the windows continue
        \node (boxvdots) at (6.5*\boxsize, -4.5) {$\vdots$};

    \end{tikzpicture}
    \caption[Diagram of windowing]{Diagram indicating a dataset $t_1, t_2, t_3,
    \ldots$ being windowed with a window length of eight. Note that since
    \emph{Ergo} is a 30-dimensional time series, each scalar $t_i$ in the
    diagram would be a 30-dimensional vector in the \emph{Ergo} dataset.}
    \label{fig:04_windowing_diagram}
\end{figure}

Note that because the data was collected over multiple sessions, the windowing
operation has to be performed separately for each contiguous session. This
results in a small number of observations at the start of each session not
being used where there is not enough data to create a full window.

# Training, Validation, and Testing Datasets \label{sec:04-splitting-the-data-into-train-test-validation}

There are about 40 times more non-gesture observations than gesture class
observations due to the imbalance between the number of gesture classes
(classes $0\ldots 49$) and the non-gesture class (class $50$). When describing
the training, validation, and testing datasets, both the number of observations
(including the non-gesture class) and the number of gesture observations
(excluding the non-gesture class) will be reported.

Of the full dataset with 241 762 observations, 25% (60 294 observations, 1 442
gesture class observations) is randomly split off and saved as the testing
dataset. This split is stratified based on the class labels, such that the
proportions of each class in the testing dataset and the remainder are
approximately equal. This testing dataset is saved as a single binary file,
completely separate from the training and validation data.

The remaining 75% of the dataset (181 321 total observations, 4 325 gesture
class observations) is saved to disc as a single binary file. This dataset will
be referred to as the training-validation dataset. The training-validation
dataset is only split into separate training and validation datasets at
training time to allow for an arbitrary number of repetitions to be made for
cross validation.

Of the 75% of the full dataset set aside for training and validation, 75% (135
990 observations, 3 243 gesture class observations) is used for training
leaving 25% (45 330 observations, 1 078 gesture class observations) for
validation. This split is also stratified by the class labels, such that the
proportions of each class is kept as equal as possible.

# Hyperparameter Optimisation\label{sec:04-procedure-for-hyperparameter-optimisation}

Many classification models have hyperparameters which control how a model works
and can significantly influence the performance of a model. However, it is
often difficult or impossible to predict if a hyperparameter combination will
result in good performance without actually training a model on that
hyperparameter combination, as the optimal hyperparameters often depend on the
dataset that the model is attempting to learn. Hyperparameter optimisation is
the process of finding performant hyperparameters, often with an auxiliary goal
of minimising the computational cost of finding those performant
hyperparameters.

Finding computationally efficient means for hyperparameter optimisation is a
field of active research. Broadly speaking, there are three kinds of
hyperparameter optimisation: grid search, random search, and various means of
more intelligent search\footnote{\citealt{bergstraAlgorithmsHyperParameterOptimization2011,
jamiesonNonstochasticBestArm2015, shahriariTakingHumanOut2016}}.

**Grid search** is the simplest to implement, but requires that the total
number of hyperparameter combinations be finite. Grid search iterates over
every combination of the hyperparameters, calculating the objective value in
each case. If there are $N$ hyperparameters $h_1, h_2, \ldots, h_N$, and each
hyperparameter $h_i$ has $n_i$ possible values, then the total number of
hyperparameter combinations to search is $\prod_{i=1}^N n_i$. Once every
hyperparameter combination has been evaluated, the hyperparameter combination
which resulted in the optimal objective value is selected as the best. This
approach requires a very large computational budget due to the number of
hyperparameter combinations which must be evaluated. In the common case of
wanting to find the optimal value of a continuous hyperparameter, the
researcher is forced to select a set of values to test; only values from this
set will be tested. This will result in a sub-optimal result being returned if
the values chosen by the researcher are not close to the optimal hyperparameter
value. Grid search is useful in circumstances where interpretability of the
influence of different hyperparameters is valued over the optimisation of the
objective function. Because every combination of hyperparameters is tested, it
is trivial to observe the marginal effect one hyperparameter has on the
objective function without concern of the effect the other hyperparameters
might have on the objective function.

**Random search** trades some amount of the interpretability in return for an
improved ability to find better hyperparameters faster. Random search can
trivially handle continuous hyperparameters. In random search, a distribution
is provided by the researcher for each hyperparameter (this may be the uniform
distribution over some range or some more complicated distribution). A set of
hyperparameters is then selected by drawing a random value from the
distribution for each hyperparameter. The model is trained using these
hyperparameters and its performance is recorded. This process is repeated until
the computational budget is reached. As the randomly selected value for some
continuous hyperparameter $h_i$ is almost surely different from any previous
choice for the same hyperparameter, the marginal search of that hyperparameter
is improved. Random search has the attractive quality that -- in contrast to
grid search -- the computational budget is independent of the number of
hyperparameters one wishes to explore. As a trade off, the ability to directly
infer the influence any hyperparameter has on the objective value is hampered.
This is because one no longer has examples where the hyperparameter of interest
is modified while all other hyperparameters remain constant (as is the case
with grid search).

**Intelligent search** describes a multiple different methods which all attempt
to intelligently maximise performance of a model while minimising the amount of
time spent evaluating different hyperparameter combinations. These methods
often have hyperparameters themselves, which adjust how much the algorithm will
explore the search space or exploit known regions of good performance. These
methods all sacrifice human interpretability, as regions which are suspected of
poor performance are quickly omitted from the search space and regions
suspected of good performance are more frequently evaluated. For this reason,
hyperparameter optimisation though intelligent search was not explored in this
thesis.

# Model Design and Implementation \label{sec:04-model-design-and-implementation}

This section discusses the different classification algorithms that were tested
and how they were implemented. Section \ref{model-specifics-hmm} will discuss
Hidden Markov Models (HMMs), Section \ref{model-specifics-cusum} will discuss
Cumulative Sum (CuSUM), Section \ref{model-specifics-ffnn} will discuss Feed-Forward
Neural Networks (FFNNs), Section \ref{sec:04-model-specifics-hffnn} will
discuss a custom model that combines two FFNNs, the Hierarchical Feed-forward
Neural Network, and Section \ref{models-specifics-svm} will discuss Support
Vector Machines (SVMs).

## Hidden Markov Models \label{model-specifics-hmm}

<!-- TODO:

Describe in detail how the HMM can't really be trained with the full
dataset because it can't fit into memory. And it's beyond the scope to
batch-ify it. And the 50-class FFNNs already show superior performance. Need to
give the math for why HMMs don't work with >100k observations

-->

Hidden Markov Models (introduced in Section \ref{sec:02-hidden-markov-models})
are able to model the progression of time via sequential states and their
transition probability matrices. For this reason, each HMM classifier attempts
to model an observation as a sequence of 22 states: one start state, one state
for each of the 20 timesteps, and one end state. Each state emits a
30-dimensional Gaussian distribution, one dimension for each of the 30 sensors.
The mean vector $\bm{\mu}$ and the covariance matrix $\bm{\Sigma}$ of the
30-dimensional Gaussian distributions are estimated using the Baum-Welch
expectation maximisation algorithm.

HMMs do not natively support multi-class classification so one-vs-rest
classification is used, resulting in one HMM for each class. To reduce the
number of parameters which need to be learned, the covariance matrices for each
HMM can be one of four different types, and each type constrains the covariance
matrix in some different way, such that the full covariance matrix need not be
learned. These types are, in order from most constrained to least constrained:

- **Spherical** covariance matrix: the covariance matrix $\bm{\Sigma}_i$ for
  each state $i$ uses a single variance value that applies to all features:
  $\bm{\Sigma}_i = \lambda_i I$ where $\lambda \in \mathbb{R}$ and $I$ is the
  $30 \times 30$ identity matrix.

- **Diagonal** covariance matrix: the covariance matrix $\bm{\Sigma}_i$ for
  each state $i$ uses a diagonal covariance matrix. $\bm{\Sigma}_i =
  \bm{\lambda}_i I$ where $\bm{\lambda} \in \mathbb{R}^{30}$

- **Tied** covariance matrix:  the covariance matrix $\bm{\Sigma}_i$ is the
  same for all states: $\bm{\Sigma}_i \in \mathbb{R}^{30 \times 30},
  \bm{\Sigma}_i = \bm{\Sigma}_j \,\forall i,j$, given that $\bm{\Sigma}_i$ is a
  valid covariance matrix.

- **Full** covariance matrix: each state uses its own full covariance matrix:
  $\bm{\Sigma}_i \in \mathbb{R}^{30 \times 30}\,\forall i$, given that
  $\bm{\Sigma}_i$ is a valid covariance matrix.

The forward algorithm makes it possible to calculate the log-likelihood that a
given observation originated from a given HMM. To make a class prediction for a
certain observation, the forward algorithm is used to obtain the log-likelihood
of that observation for each of the 50 HMMs. These 50 log-likelihoods are
compared and the HMM providing the maximum log-likelihood is selected as the
prediction for that observation: if the HMM trained on class 5 provided the
maximum log-likelihood for a given observation, then the predicted class would
be class 5.

Significant problems were encountered while training the HMMs due to the large
number of observations of class 50. Training times for the class 50 HMM either
exceeded 6 hours (at which point they were stopped) or were killed by the
operating system due to excessive memory usage. These problems are caused by
the parameter estimation procedure for HMMs which requires the construction and
multiplication of matrices whose size is dependant on the number of
observations (around 140 000) as well as the number of dimensions of each
Gaussian (30). For this reason, all HMMs were only trained on a subset of 1000
randomly selected observations of class 50. During calculation of the
validation performance, all HMMs were evaluated on all validation observations.

Each HMM was trained for 20 iterations of the Baum-Welch parameter estimation
algorithm, and all four covariance types were evaluated: Spherical, Diagonal,
Tied, and Full.

## Cumulative Sum \label{model-specifics-cusum}

Cumulative Sum (CuSUM, introduced in Section \ref{sec:02-cumulative-sum}) is
designed for real-time univariate time-series out-of-distribution detection. It
cannot natively support a multivariate multi-class classification task, and so
some adjustments are required.

The term _CuSUM algorithm_ will be used to refer to the univariate time series
out-of-distribution detection algorithm, as described in Algorithm
\ref{alg:cusum} in Section \ref{sec:02-cumulative-sum}.

The term _CuSUM classifier_ will be used to refer to a collection of 30 CuSUM
algorithms, where one CuSUM algorithm is used for each of the 30 time series.
The $i$\textsuperscript{th} classifier will
learn which of these 30 CuSUM algorithms raise an alert when presented with an
observation from the $i$\textsuperscript{th} class. The procedure for
learning which alerts from which CuSUM algorithms is associated with which
classes is given in Algorithm \ref{alg:04-cusum-training} and the procedure for
performing inference is given in Algorithm \ref{alg:04-cusum-inference}.


\begin{algorithm}
    \caption{CuSUM Training Algorithm}
    \label{alg:04-cusum-training}
    \begin{algorithmic}[1]
        \State $ \text{training\_alerts} \leftarrow \mathbb{0}_{30, n_{\text{classes}}}$
        \For{$i$ in $1 \ldots n_{\text{classes}}$}
            \State $\text{subset} \leftarrow \text{observations belonging to class}\,i$
            \For{$\text{observation}$ in $\text{subset}$}
                \For{$j$ in $1$ to $30$}
                    \If{CuSUM algorithm $j$ alerting for observation?}
                        \State $\text{training\_alerts}_{ij} \gets \text{training\_alerts}_{ij} + 1$
                    \EndIf
                \EndFor
            \EndFor
            \State $\text{training\_alerts}_{ij} = \frac{\text{training\_alerts}_{ij}}{|\text{subset}|}$
        \EndFor
    \end{algorithmic}
\end{algorithm}

\begin{algorithm}
    \caption{CuSUM Inference Algorithm}
    \label{alg:04-cusum-inference}
    \begin{algorithmic}[1]
        \State $\text{alerts} \leftarrow \mathbb{0}_{30}$
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

In order to classify a given observation as belonging to one of 51 classes, a
one-vs-rest approach will be used. 51 different CuSUM classifiers will be
trained, where the $i$\textsuperscript{th} CuSUM classifier predicts whether or
not a given observation belongs to class $i$. Seven different values for the
threshold parameter shall be used: $\{5, 10, 20, 40, 60, 80, 100\}$

## Feed-Forward Neural Networks \label{model-specifics-ffnn}

The Feed-Forward Neural Networks (FFNNs, introduced in Section
\ref{sec:02-artificial-neural-networks}) were implemented using the TensorFlow
library \citep{martinabadiTensorFlowLargeScaleMachine2015} for the Python3
programming language \citep{vanrossumPythonReferenceManual2009}. Each FFNN is
modelled as a sequence layers, where each layer performs a transformation on
its input and provides output to the next layer. The input $20 \times 30$
matrix is flattened into a 600 dimensional vector before being passed to the
FFNN.

FFNNs are sensitive to the scale of the input data, and so the input data is
normalised to have approximately zero mean and approximately unit variance
before being passed to the FFNN. For each of the 600 dimensions, the mean
$\mu_i$ and standard deviation $\sigma_i$ ($i \in \{1, \ldots, 600\}$) of the
training data is calculated. These statistics are not calculated using the
validation data, as that would leak information about the validation data to
the model. These means and standard deviations are then stored. To normalise an
unseen observation $\bm{x}$, each element $x_i$ in $\bm{x}$ has the
$i$\textsuperscript{th} mean subtracted from it and is then divided by the
$i$\textsuperscript{th} standard deviation:

\begin{equation}
    \frac{x_i - \mu_i}{\sigma_i}
\end{equation}

This ensures that the mean of each element in $\bm{x}$ is approximately zero
and the variance is approximately 1.

The loss function of every FFNN is categorical cross entropy loss, defined as:

\begin{equation}
    L(\bm{y}, \hat{\bm{y}}) = -\sum_{i=1}^n y_i \cdot \log(\hat{y}_i) \cdot \text{weight}_i
\end{equation}

Where:

- $y_i \in \{0, 1\}$ is the ground truth prediction for class $i$.
- $\hat{y}_i \in [0, 1]$ is the predicted probability for class $i$.
- $n$ is the number of classes.
- $\text{weight}_i$ is the weight of class $i$, which is calculated as
  $\text{weight}_i = -\log_{10}\left( {\text{count}_i} \right)$, where
  $\text{count}_i$ is the number of samples in the class.

L2 normalisation is applied to the loss function such that the model is
penalised for weights which are too large. The strength of regularisation is
controlled by the L2 coefficient hyperparameter. A regularisation term is added
to the loss function: $\text{L2} \cdot (\sum_b b^2 + \sum_w w^2)$, where L2 is
the L2 coefficient hyperparameter and the sums iterates over every weight and
bias in the network.

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
any neuron is set to zero during training. Neurons which were not set to zero
have their output scaled up by $(1 - \text{dropout rate})^{-1}$. The optimiser
used is the Adam optimiser \citep{kingmaAdamMethodStochastic2014} with a
constant learning rate that is determined by the learning rate hyperparameter.
Constant values of $\beta_1=0.9$, $\beta_2=0.999$, and $\hat{\epsilon}=10^{-7}$
are used for the Adam hyperparameters, as suggested by Kingma and Ba. Every
FFNN completes 40 epochs of training, after which it is evaluated on the
validation dataset. Summary statistics are stored to disc, as well as the full
vectors of ground truth labels and predicted labels for that particular
training-validation split. Table \ref{tab:04_hpar_dists_ffnn} shows the
hyperparameters for the FFNNs.

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

## Hierarchical Feed-forward Neural Networks \label{sec:04-model-specifics-hffnn}

Hierarchical models, where one model is used to filter out the non-gesture
class and another is used to distinguish the different gesture classes, have
shown promising results in the
literature\footnote{\citealt{zhangVisionbasedSignLanguage2004,
wangTrafficPoliceGesture2008, kopukluRealtimeHandGesture2019}} and so are
evaluated here in the form of Hierarchical Feed-forward Neural Networks
(HFFNNs). HFFNNs combine the output of two FFNNs: one FFNN (called the majority
classifier) is a binary classifier that detects whether or not a gesture exists
in the observation, and the other FFNN (called the minority classifier) is only
invoked if there is a gesture present in an observation, as detected by the
majority FFNN. The minority classifier detects _which_ gesture is present in an
observation. Algorithm \ref{alg:hffnn_prediction} shows the procedure for
making a prediction using the majority and minority classifiers.

\begin{algorithm}
    \caption{Prediction Algorithm For HFFNNs}
    \label{alg:hffnn_prediction}
    \begin{algorithmic}
        \Require X
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

The hyperparameters of the majority and minority classifiers are independent
but have the same distributions as those given for the FFNNs in Table
\ref{tab:04_hpar_dists_ffnn}. They have one additional hyperparameter: the
number of epochs for which the majority and minority classifiers are trained,
which can range between 5 and 40 epochs.

## Support Vector Machines \label{models-specifics-svm}

<!---


High `C` can increase training times: Fan, Rong-En, et al., “LIBLINEAR: A
library for large linear classification.”, Journal of machine learning research
9.Aug (2008): 1871-1874.

Rong-En Fan
Kai-Wei Chang
Cho-Jui Hsieh
Xiang-Rui Wang
Chih-Jen Lin

-->

Support Vector Machines (SVMs, introduced in Section
\ref{sec:02-support-vector-machines}) do not support multi-class classification
natively, and so a one-vs-rest technique is used to enable an ensemble of SVMs
to make multi-class classifications. The input $20 \times 30$ matrix is
flattened into a 600 dimensional vector before being passed to the SVMs.

All SVMs were trained for 200 iterations with a linear kernel. One
hyperparameter, the class weight, was iterated to weight the influence of each
class based on it's prevalence in the training dataset. The hyperparameter $C$
controls the regularisation and is used in the same way as described in the
Section \ref{sec:02-support-vector-machines}. Values of $C$ were between
$10^{-6}$ and $1$. The C library \textsc{LIBLINEAR}
\citep{fanLIBLINEARLibraryLarge2008} was used to find the optimal separating
hyperplane for the SVMs.

# Ranking The Classification Algorithms \label{sec:04-ranking-the-classification-algorithms}

A method of ordering the different classification algorithms must be defined
such that a best model can be found. This ordering shall be based on the
unweighted average validation $F_1$-score over all classes for a given model.
As each set of hyperparameters will be evaluated five times, the resulting five
$F_1$-scores can be used to calculate a 90% confidence interval for the
$F_1$-score of that model and hyperparameter combination. The _lower_ bound of
this confidence interval shall be used to rank the models and their
hyperparameters.

Using the lower bound of the confidence interval ensures that a model cannot be
chosen as the best if it had one outlier performance which achieved a high
$F_1$-score. Ranking models based on the lower bound of the confidence interval
ensures that high-ranking models will have consistently achieved a high
$F_1$-score across all validation sets and all random initialisations. This
ensures that the resulting model is more likely to generalise to unseen data.

# Experimental Procedure \label{sec:04-experimental-procedure}

Experiments will be conducted so as to answer the research questions posed in
the Chapter \ref{sec:01-research-questions}. Five different classification
algorithms (CuSUM, HMMs, SVMs, FFNNs, and HFFNNs) will be tested. For each of the
classification algorithms, multiple combinations of hyperparameters will be
tested. Each experiment will be repeated five times. Three different datasets
will be tested, one with 5 classes, one with 50 classes, and one with 51
classes.

The 5-class dataset is constructed by only including classes 0, 1, 2, 3, and 4
from the full training-validation dataset. These are the gestures performed by
the left hand oriented to be parallel to the ground. The 50-class dataset is
constructed by including only gestures 0 through to 49 from the full
training-validation dataset, and excludes the non-gesture class. The 51-class
dataset is equivalent to the full training-validation dataset. Performing
experiments on these datasets with differing numbers of classes will provide
insight into the performance characteristics of each model and hyperparameter
combination. By comparing the 5- and 50-class datasets, the effect of
increasing the number of unique classes can be ascertained. By comparing the
50- and 51-class datasets, the effect of a massive class imbalance can be
ascertained.

For each model and for each of the 5-, 50-, and 51-class datasets, a number of
different hyperparameter combinations will be randomly chosen and tested. The
number of hyperparameter combinations will be proportional to the size of the
search space of the model. Table \ref{tab:04_num_iterations} shows the number
of search space iterations for each model type and each number of classes (5,
50, or 51), and Table \ref{tab:04_fitting_time} shows the amount of time spent
for each model type and each number of classes (5, 50, or 51).

\begin{table}
    \centering
    \begin{tabular}{l|r r r|r}
                        & \textbf{5 classes}  & \textbf{50 classes} & \textbf{51 classes} & \textbf{Total} \\
        \hline
        \textbf{CuSUM}  & 182                 & 68                  & 78                  & 328 \\
        \textbf{FFNN}   & 83                  & 55                  & 148                 & 286 \\
        \textbf{HFFNN}  & -                   & -                   & 150                 & 150 \\
        \textbf{HMM}    & 62                  & 26                  & 20                  & 108 \\
        \textbf{SVM}    & 200                 & 129                 & 57                  & 386 \\
        \hline
        \textbf{Total}  & 527                 & 278                 & 453                 & 1258 \\
    \end{tabular}
    \caption{Total number of iterations per model and per number of gesture classes.}
    \label{tab:04_num_iterations}
\end{table}

<!--- TODO: 25m for 51-class HMM seems wrong... -->

\begin{table}
    \centering
    \begin{tabular}{l|r r r|r}
                        & \textbf{5-classes} & \textbf{50-classes} & \textbf{51-classes} & \textbf{Total} \\
        \hline
        \textbf{CuSUM}  & 43.37s             & 3m 0.95s            & 3h 6m 7.04s         & 3h 9m 51.36s \\
        \textbf{FFNN}   & 8m 51.85s          & 11m 3.45s           & 19h 44m 7.76s       & 20h 4m 3.05s \\
        \textbf{HFFNN}  & -                  & -                   & 15h 26m 53.27s      & 15h 26m 53.27s \\
        \textbf{HMM}    & 5m 45.51s          & 33m 21.18s          & 25m 17.45s          & 1h 4m 24.14s \\
        \textbf{SVM}    & 40.66s             & 10m 53.66s          & 11h 27m 38.20s      & 11h 39m 12.52s \\
        \hline
        \textbf{Total}  & 16m 1.39s          & 58m 19.24s          & 50h 10m 3.73s       & 51h 24m 24.36s \\
    \end{tabular}
    \caption{Total fitting time per model and per number of gesture classes.}
    \label{tab:04_fitting_time}
\end{table}

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
    \State $\bm{C} \gets \{5, 50, 51\}$
    \State $\bm{M} \gets \{$FFNN, HFFNN, CuSUM, HMM, SVM$\}$
    \For{$C$ in $\bm{C}$}
        \For{$M$ in $\bm{M}$}
            \For{$n$ in $1..n_{\text{combinations}}$}
                \State Select a random hyperparameter combination
                \For{$R$ in $1..5$}
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

After experimentation, the best-performing model will be found and evaluated on
the unseen test dataset.

The hardware used to train the various models is a 14-inch 2021 MacBook Pro
laptop with the Apple M1 Pro chip and 16 gigabytes (GB) of Low Power Double
Data Rate 5 (LPDDR5) memory. The machine has 8 performance-oriented cores and 2
efficiency-oriented cores.
