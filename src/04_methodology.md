# Methodology

> Things to explain:
>
> - HMM theory to HMM multi-class classification implementation
> - CuSUM theory to CuSUM multi-class classification implementation
> - What does a perfect model's confusion matrix look like?
> - What does a random-finger model's confusion matrix look like?
> - What does a random-orientation model's confusion matrix look like?
>
> - Describe the dataset
>   - Gesture g255 is by far the majority class: create plot showing this
>     imbalance
>   - Multiple time series plots showing what a gesture "looks" like, in terms
>     of the acceleration readings
>   - 50 other classes that need to be distinguished
>   - 30 dimensional time series, recorded at ~40Hz, about 100 examples per
>     class, 50 classes, 1 majority class (g255), around 230k observations.
>   - Gravity is included in the acceleration readings
>   - 50 gestures = 10 fingers x 5 orientations (show pictures of some
>     different gestures being performed)
>   - Data segmentation is "implicit": There's no nice labels marking the start
>     and end of each gesture, the model has to learn 1. how to extract
>     gestures from background and 2. how to differentiate between the
>     different gestures.
> - Accuracy vs recall vs precision (vs F1 Score)
> - Data split into training, validation, testing (elaborate on the purpose of
>   these datasets, how they were kept separate, and how "leakage" was prevented)
> - Hyperparameter optimisation: Random search over the hyperparameter search
>   space

From discussion with Trienko:

> Methodology chapter:
>
> Describe how you utilised the existing knowledge/algorithms/approaches (as
> given in the bg chapter) to make them work. Also list any modifications made.
> Also describe the dataset. Also describe how ergo looks like. Then explain
> experimental setup which will let you answer the research questions made in the
> introduction. This is where you describe the exact architecture of the neural
> network and the hyperparameters you're iterating over. Also describe how the
> HMMs are used for gesture based classification.

NOTE:

- HMMs OOM when trying to train on 100k observations, so only train on the
  first 200

> Indeed, L² regularization and weight decay regularization are equivalent for
> standard stochastic gradient descent (when rescaled by the learning rate).
> This is not necessarily true for all gradient-based learning algorithms, and
> was recently shown to not be the case for adaptive gradient algorithms, such
> as Adam.
> Ilya Loshchilov & Frank Hutter Decoupled Weight Decay Regularization

## Converting HMMs into a multi-class classifier

> Make note about the technical problems with training the HMMs on 200k
> observations

## Converting CuSUM into a multi-class classifier

- Threshold needs to be crossed in certain sensors for a prediction to be made

---

## Design and Implementation

This section describes the development of _Ergo_ and the implementation
thereof.

Section \ref{defining-the-gestures-to-be-used} describes the structured system
by which gestures are named in the context of this report. Section
\ref{hardware-description} discusses how the raw sensor data is collected and
transmitted to the user's computer at a hardware level. Section
\ref{recording-sensor-measurements} describes how sensor data collected by the
user's computer is either stored (in preparation for model training) or to be
consumed by an already-trained machine learning model.

Section \ref{pre-processing-the-recorded-data} details the method by which
saved sensor data is pre-processed into a form consumable by a machine learning
model. Section \ref{model-architecture} defines the model architecture that is
used to classify sensor data into gestures, as well as defining which aspects
of the model architecture are hyperparameters which will be fine-tuned. The
process of fine-tuning the hyperparameters is discussed in Section
\ref{hyperparameter-optimisation}. This section also defines the metrics by
which models are compared.

Section \ref{model-evaluation} discusses the best performing model found after
hyperparameter optimisation. Section \ref{post-processing-model-predictions}
describes how the forty predictions per second which the model provides is
converted into keystrokes. Section \ref{using-ergo-as-a-keyboard} evaluates the
end-to-end use of _Ergo_ as a keyboard. Section \ref{lines-of-code-written}
lists the number of lines of code written.

### Defining the Gestures to be Used

_Ergo_ does not directly classify sensor measurements as particular keystrokes,
as this would unnecessarily couple hand movements with keystrokes. Rather,
_Ergo_ classifies sensor measurements as particular gestures, and these
gestures are mapped to keystrokes via a user-defined configuration file. This
allows for different configuration files to be used depending on either user
preferences or on the application.

In this report, a gesture is defined as a motion of the hands and/or fingers
that takes less than half a second to complete. The gestures known by _Ergo_
are labelled in an ordered manner. First the form of the labels will be
described and then the gestures associated with each label will be given.

Each gesture is assigned a label in the form `gesture0000`, `gesture0001`,
`gesture0003`, `gesture0004`, and so on, through to `gesture9999`. This
provides more than enough unique gesture labels for the current report, and
provides flexibility in how gestures are assigned to labels. Due to the number
of gestures which are recognised by _Ergo_, an abbreviated form is often
necessary for annotating graphs.

For the gesture labels `gesture0000` through to `gesture0999`, the abbreviated
form is created by replacing `gesture0` with the letter `g`, such that the
first few gestures become `g000`, `g001`, `g003`, and so on. The gesture labels
from `gesture1000` to `gesture9999` are not used in this report, and so their
abbreviated form is of no consequence.

The gesture labels `gesture0000` through to `gesture0049` are each assigned to
gestures in which only one finger is moving. Each of these gestures consists of
a single finger starting slightly bent in a resting position, making a quick
flexion (bending towards the palm of the hand) and then extension (returning to
the resting position) while all other fingers are still and the hands do not
move. See Figure \ref{fig:hand_movements} for visual example.

\begin{figure}
\centering
\includegraphics[width=0.9\textwidth]{src/imgs/hand_movements.png}
\caption{Two example gestures: \texttt{gesture0034} on the left (frames
$1a$, $1b$, $1c$) and \texttt{gesture0025} on the right (frames $2a$, $2b$,
$2c$). Frames $1a$ and $2a$ show the initial resting state before the
gesture is performed. Frames $1b$ and $2b$ show the hand states in the
middle of the gesture as the thumb is in flexion. Frames $1c$ and $2c$ show
the hand states once the gesture has been completed and the hands have
returned to a resting position.}
\label{fig:hand_movements}
\end{figure}

The exact movement of the hands for a gesture is dictated by the final two
digits of the gesture label for that gesture. For example, in `gesture0012`,
the `1` describes one aspect of the gesture (described below) and the `2`
describes another aspect of the gesture (also described below). First the
"units" position is discussed, then the "tens" position is discussed.

The "units" position of the gesture label dictates which one of the ten fingers
is in motion. The relationship between gesture labels and which finger is in
motion is given in Table \ref{tab:gesturelabels_to_fingers}, where a question
mark is used as a placeholder for any digit. For example, the gesture labels
ending in `0` (`gesture0000`, `gesture0010`, `gesture0020`, `gesture0030`,
`gesture0040`) all indicate that the left hand's little finger moves while all
other fingers are still. The gesture labels ending in `1` (`gesture0001`,
`gesture0011`, `gesture0021`, `gesture0031`, `gesture0041`) all indicate that
the left hand's ring finger moves while all other fingers are still. This
format continues for the remaining eight digits `2` through `9` and the
remaining eight fingers: left hand middle finger, index finger, thumb, and the
right hand's thumb, index finger, middle finger, ring finger, and little
finger.

\begin{table}
\centering
\caption{Correspondance between gesture labels and which finger is in
motion. A question mark represents any digit.}
\begin{tblr}{
hlines,
vlines,
}
\textbf{Gesture Label} & \textbf{Hand and Finger} \\
\texttt{gesture00?0} & Left hand little finger \\
\texttt{gesture00?1} & Left hand ring finger \\
\texttt{gesture00?2} & Left hand middle finger \\
\texttt{gesture00?3} & Left hand index finger \\
\texttt{gesture00?4} & Left hand thumb \\
\texttt{gesture00?5} & Right hand thumb \\
\texttt{gesture00?6} & Right hand index finger \\
\texttt{gesture00?7} & Right hand middle finger \\
\texttt{gesture00?8} & Right hand ring finger \\
\texttt{gesture00?9} & Right hand little finger
\end{tblr}
\label{tab:gesturelabels_to_fingers}
\end{table}

In a similar fashion, the rotation of each hand is dictated by the "tens"
position of the gesture label. For example, `gesture0003` is the gesture label
corresponding to the left hand is facing towards the ground as the left hand's
middle finger making a quick flexion towards the palm of the hand.
`gesture0023` is the gesture made with the left hand's middle finger while the
left hand is rotated at the wrist such that the thumb is directly above the
little finger. The correspondence between gesture label and hand rotation is
given in Table \ref{tab:gesturelabels_to_orientation}.

\begin{table}
\centering
\caption{Correspondance between gesture labels and rotation of the hand.
Ellipses denote an inclusive range from one gesture label to another.}
\begin{tblr}{
hlines,
vlines,
}
\textbf{Gesture Label} & \textbf{Hand rotation} \\
\texttt{gesture0000}\ldots\texttt{gesture0004} & Left palm towards the ground. \\
\texttt{gesture0005}\ldots\texttt{gesture0009} & Right palm towards the ground. \\
\texttt{gesture0010}\ldots\texttt{gesture0014} & Left palm at $45^{\circ}$ to the ground. \\
\texttt{gesture0015}\ldots\texttt{gesture0019} & Right palm at $45^{\circ}$ to the ground. \\
\texttt{gesture0020}\ldots\texttt{gesture0024} & Left palm at $90^{\circ}$ to the ground.\\
\texttt{gesture0025}\ldots\texttt{gesture0029} & Right palm at $90^{\circ}$ to the ground.\\
\texttt{gesture0030}\ldots\texttt{gesture0034} & Left palm at $135^{\circ}$ to the ground.\\
\texttt{gesture0035}\ldots\texttt{gesture0039} & Right palm at $135^{\circ}$ to the ground.\\
\texttt{gesture0040}\ldots\texttt{gesture0044} & Left palm towards the sky.\\
\texttt{gesture0045}\ldots\texttt{gesture0049} & Right palm towards the sky.\\
\end{tblr}
\label{tab:gesturelabels_to_orientation}
\end{table}

Note that the rotation only applies to the hand which has a finger in motion.
For example, `gesture0044` describes the gesture where the user's left palm is
facing the sky while their left hand's thumb flexes towards the user's palm and
then returns to a resting position. This gesture only defines the movement for
the left hand, and so the right hand can be in any position.

The gesture label `gesture0255` is special, and designates instants in time
where the user is not performing any other gesture. For example, consider the
sequence of predictions that would be made if the user performed `gesture0000`,
waited a short while, and then performed `gesture0001`. This sequence would
start with a series of `gesture0000` predictions, followed by a series of
`gesture0255` predictions (representing the short period in between gestures
when the user is not moving their hands), and would terminate with a series of
`gesture0001` predictions.

The gesture labels `gesture0050` through to `gesture9999` are unused (except
for `gesture0255`) as they are reserved for future work.

### Hardware Description

_Ergo_ consists of ten ADXL335 tri-axis linear accelerometers, each one of
which is mounted to the back of the user's fingertips (see Figure
\ref{fig:accelerometers}).

\begin{figure}[!htb]
\centering
\includegraphics[width=0.5\textwidth]{src/imgs/accelerometers.jpg}
\caption{The user's left hand while wearing \textit{Ergo}, with the
accelerometers highlighted in red.}
\label{fig:accelerometers}
\end{figure}

These accelerometers can measure linear acceleration in three
orthogonal directions, but cannot measure rotational acceleration. Due to how
the accelerometers are built, the measurements they provide _do_ include
gravity. For example, an accelerometer at rest will register a large
acceleration towards the centre of the earth. This makes distinguishing
acceleration due to finger movement and acceleration due to gravity impossible
based off of the linear acceleration alone. Appendix
\ref{the-adxl335-accelerometers} contains more information about the
accelerometers.

Each accelerometer measures linear acceleration in the orthogonal X, Y, and Z
directions (see Figure \ref{fig:adxl335-xyz}). This results in fifteen
measurements for each hand.

\begin{figure}[!htb]
\centering
\includegraphics[width=0.5\textwidth]{src/imgs/accel_xyz.jpg}
\caption{The user's left hand while wearing \textit{Ergo} with the
accelerometer directions indicated. The X direction is in red, the Y
direction is in green, and the Z direction is in blue.}
\label{fig:adxl335-xyz}
\end{figure}

The fifteen measurements provided by the five accelerometers on the left hand
are collected by an Arduino Nano 3.3v BLE microcontroller which is mounted to
the back of the user's left hand. Similarly, the fifteen measurements provided
by the accelerometers on the right hand are collected by another Arduino Nano
3.3v BLE microcontroller, this one mounted on the back of the user's right
hand. Appendix \ref{the-arduino-nano-33-ble} describes these microcontrollers
in greater detail.

The 15 sensor readings from the microcontroller on the left hand are
transmitted to the microcontroller on the right hand by a wired serial
connection. These thirty measurements are then sent by a wired serial
connection to the host computer.

A full description of the hardware used is
given in Appendix \ref{app:hardware} and a circuit diagram in Appendix
\ref{app:circuit-diagram}.

### Recording Sensor Measurements

The python program `ergo.py` is able to read the serial data coming from the
microcontrollers. It is able to accept a new set of thirty acceleration
measurements at a rate of forty times per second. The thirty acceleration
measurements come from the ten accelerometers, each providing three
acceleration measurements.

Each set of acceleration measurements is associated with a gesture label which
describes the gesture being performed by the user. By default this gesture
label is `gesture0255` for every gesture, but when `ergo.py` being used to
record new data, the program will prompt the user to perform a certain gesture.
The full process for associating gesture labels with sensor measurements is as
follows:

1. The user attaches _Ergo_ to their hands and from the terminal runs the
   command which will save sensor data to disc: `python3 ergo.py --save`.
2. `ergo.py` starts reading sensor measurements and storing them to disc,
   initially labelling _every_ set of sensor measurements as belonging to
   `gesture0255`.
3. The program displays a gesture label and a one second countdown to the user.
   For ease of explanation, let us assume the displayed gesture label was
   `gesture0000`. While the countdown approaches zero, the program continues to
   receive sensor measurements and saves each set of them as `gesture0255`.
4. The user, seeing the countdown approaching zero, starts to perform the
   gesture associated with the gesture label: `gesture0000`.
5. While the countdown is within 30ms of reaching zero, the program will record
   all sets of sensor measurements as belonging to `gesture0000` instead of
   `gesture0255`. During this time the user is still in the process of
   performing `gesture0000`.
6. When the countdown reaches zero, the countdown will be reset back to one
   second and a new gesture label will be displayed to the user. By this time
   the user will likely be finishing the gesture.
7. This process then repeats, labelling all sets of sensor measurements as
   belonging to `gesture0255` except the few sets of sensor measurements that
   occurs within 30ms of when the countdown reaches zero.

An example of this procedure is given in Figure
\ref{fig:explain_recording_procedure}.

\begin{figure}[!htb]
\centering
\includegraphics[width=1.0\textwidth]{src/imgs/explain_recording_procedure.png}
\caption{An annotated plot describing the gesture process. Each plot in the
figure describes the sensor readings over time for one finger's three-axis
accelerometer. Starting at time step $00$, the countdown is initialised and
begins to approach zero. When the user sees that the countdown is close to
zero, they will begin to start performing \texttt{gesture0000} (indicated
by the vertical red bar labelled $4$). When the countdown is within 30ms of
zero, it will start labelling every time step as \texttt{gesture0000}
(indicated by the vertical red bar labelled $5$). When the countdown
reaches zero, it will stop labelling every time step as `gesture0000` and
start labelling every time step as \texttt{gesture0255} and reset back to
one second (indicated by the vertical red bar labelled $6$). This process
repeats the next time the countdown reaches zero, around time step 56.}
\label{fig:explain_recording_procedure}
\end{figure}

Only one or two sets of sensor measurements are labelled as `gesture0001` even
though the actual gesture took place over multiple sets of gesture
measurements. This discrepancy is amended during pre-processing, described in
Section \ref{pre-processing-the-recorded-data}.

This procedure results in a highly imbalanced dataset, where `gesture0255`
occupies between 95% (if there are two non-`gesture0255` gesture labels each
second) and 98% (if there is one non-`gesture0255` gesture label each second)
of the dataset. A simplistic model will therefore be able to achieve 95% to 98%
accuracy by simply predicting `gesture0255` for every single time step. This is
not favourable, and methods for preventing this behaviour are discussed in
Section \ref{model-architecture}. Note that this imbalance correctly represents
the real-world usage of _Ergo_, and so any model should predict `gesture0255`
the majority of the time.

Segmentation of the dataset also presents a challenge, as there are no explicit
start or end markers that delimitate each gesture. A model will therefore have
to handle gestures which are arbitrarily offset within the time window of
sensor measurements it is provided with. Note that this problem is desirable,
as it allows the user to simply make a gesture whenever they want. Requiring
the user to delimitate each gesture would imply the user presses a button of
some sort at the start and end of each gesture, which is functionally
equivalent to just typing on a keyboard.

The program `ergo.py` also records the time stamp at which each set of sensor
measurements is recorded. This information is written to disc as a
Comma-Separated Value (CSV) file. The first column of this CSV file is the time
stamp of the measurements. The second column is the label associated with the
gesture, and the subsequent 30 columns are the 30 raw sensor values from the
ten accelerometers. For example:

\begin{lstlisting}[basicstyle=\fontsize{8}{8}\ttfamily]
...
2022-10-08T19:55:43.792444,gesture0255,570,482,570,570,537,...
2022-10-08T19:55:43.811681,gesture0001,592,493,594,572,551,...
2022-10-08T19:55:43.836730,gesture0001,539,584,529,519,531,...
2022-10-08T19:55:43.861219,gesture0255,542,684,572,542,508,...
2022-10-08T19:55:43.877689,gesture0255,521,547,581,521,509,...
2022-10-08T19:55:43.902813,gesture0255,534,533,531,538,514,...
2022-10-08T19:55:43.926830,gesture0255,549,539,599,549,502,...
...
\end{lstlisting}

The units with which each accelerometer measures acceleration are correlated
with the resistance in the accelerometer caused by that acceleration, and are
not pre-calibrated to be in any standard units.

A new CSV file is created each time the program is restarted. These CSV files
are combined into one dataset during pre-processing.

In total 180 000 sets of sensor measurements occupying 30MB on disc were
collected, corresponding to approximately 9 000 unique non-`gesture0255`
gestures and approximately 180 unique gestures per gesture label.

### Pre-Processing the Recorded Data

The data saved to CSV files by the command `python3 ergo.py --save` is not
immediately suitable for training a machine learning model. This is because
only one or two sets of sensor measurements are associated with a
non-`gesture0255` gesture label even though each gesture takes about a quarter
of a second to perform and so will occur over several sensor measurements.

This is remedied by defining a hyperparameter `label_expansion`, which
"expands" each label forwards and backwards in time by some amount. For
example, a `label_expansion` of one would result in each `gesture0255` label
that is within one time step of a non-`gesture0255` label to be replaced with
that non-`gesture255` gesture label. See Figure \ref{fig:label_expansion} for
an visual description.

\begin{figure}
\centering
\includegraphics[width=0.9\textwidth]{src/imgs/label_expansion.png}
\caption{An excerpt of the labels before (top) and after (bottom) a label
expansion of one was applied.}
\label{fig:label_expansion}
\end{figure}

For the machine learning model to be better able to predict which gesture is
being performed, it should also have access to a time window of sensor
measurements, and not just the sensor measurements taken at one instant in
time. For this reason, the CSV files are converted into a set of
observation-label pairs. Each label is the gesture label at some point in time,
and each observation is a matrix of size `(window_size, number_of_sensors)`.
The `window_size` is the number of sequential sensor measurements provided to
the model. All the sensor measurements from some time step `i` through to a
previous time step `i-window_size` are grouped together to make one
observation. For example, a `window_size` of 10 results in the sensor
measurements from the current time step through to the sensor measurements 9
time steps before being grouped into one observation. `window_size` is usually
between 5 and 40, and is fine tuned in Section
\ref{hyperparameter-optimisation}. The `number_of_sensors` is always thirty, as
there are ten accelerometers which each provide three sensor measurements.

Note that there is a large number of shared sensor measurements between
observations. For example, if one observation starts at time step `i-10` and
ends at time step `i`, then there will be another observation that starts at
time step `i-9` and ends at time step `i+1`, as well as another observation
that starts at time step `i-11` and ends at time step `i-1`. Those three
observations will share exactly the same sensor measurements from time steps
`i-9` through to `i-1`. For a visual example, please see Figure
\ref{fig:window_size}.

\begin{figure}
\centering
\includegraphics[width=0.9\textwidth]{src/imgs/window_size.png}
\caption{An example of how measurements are grouped together into
observations and associated with labels. This example uses a window size of
four for simplicity. Note how observation 8 contains the
measurements from time steps 5, 6, 7, and 8, and is labelled with the
gesture label from time step 8. In a similar fashion, observation 9
contains the measurements from time steps 6, 7, 8, and 9, and is labelled
with the gesture label at time step 9.}
\label{fig:window_size}
\end{figure}

The values of the sensor measurements during a gesture can be seen in Figure
\ref{fig:gesture_over_time}. In this figure, `gesture0036` starts at
approximately 13:20:40.497 and ends at approximately 13:20:40.775.

\begin{figure}
\centering
\includegraphics[width=1.0\textwidth]{src/imgs/gesture_over_time.pdf}
\caption{An example of the sensor readings over time. Each plot in this
figure describes the sensor readings from one finger. The time stamp is
along the x-axis, and the normalised sensor readings are along the y-axis.
The three lines on each plot represent the three acceleration directions:
red is X, green is Y, and blue is Z. The shaded region on each plot
indicates the sensor measurements which have a non-\texttt{gesture0255}
gesture label. Looking at the plots for the right hand's index and middle
finger, one can see that \texttt{gesture0036} started at approximately
13:20:40.497 and ended at approximately 13:20:40.775, but only time steps
at 13:20:41.083 and 13:20:41.108 are labelled as being from
\texttt{gesture0036}.}
\label{fig:gesture_over_time}
\end{figure}

This pre-processing results in there being approximately 180 000 observations,
where each observation is of size `(window_size, 30)`, resulting in
`window_size*30` features per observation. Approximately 170 000 of those
observations are labelled as `gesture0255`, with the exact number dependant on
the `label_expansion` hyperparameter.

These observations and labels are randomly split into training and validation
sets, with 25% of observations becoming the validation set. The data in the
training set is normalised to have zero mean and unit variance. The mean and
variance of the training set is used to standardise the validation set in the
same fashion.

### Model Architecture

A Feed Forward Neural Network (FFNN) was chosen as the model architecture which
would be fit to the data, due to the speed at which they can make predictions
and their relative efficiency in many dimensions. See @ geron2019 for a review
of Feed Forward Neural Networks.

The classification problem presented by _Ergo_ is a many-class one, where the
model should classify a given observation into one of many classes. The
categorical cross-entropy loss function (described in Appendix \ref{app:cce})
intuitively measures the difference between two distributions, and will be used
as the loss function for the FFNN.

The input layer of the FFNN has `window_size * 30` neurons, and the final layer
has 51 neurons, one for each gesture. The final layer uses the softmax
activation function (see Appendix \ref{app:softmax} for a description). Dropout
[@ srivastava2014] is applied after each of the hidden layers.

The `window_size`, `label_expansion`, activation function of each hidden layer,
number of hidden layers, number of neurons per hidden layer, optimiser used,
learning rate, and dropout rate are all hyperparameters which are optimised via
random search. Details of this are given in Section
\ref{hyperparameter-optimisation}.

The dataset is significantly imbalanced, such that 95% of observations belong
to the `gesture0255` class. This is problematic, as a simplistic model could
predict `gesture0255` for every observation and get 95% accuracy. One method to
combat this would be discard enough observations labelled `gesture0255` such
that the classes were balanced. However, this is not desirable as a model
trained on a balanced dataset would significantly under-predict `gesture0255`
and over-predict all other gestures during real-world use. The imbalance must
be maintained because it is realistic for there to be many more observations
labelled `gesture0255` than there are observations labelled as any other
gesture.

To combat the class imbalance, the loss function will be weighted such that the
loss for incorrectly predicting a non-`gesture0255` is greater than the loss
for incorrectly predicting `gesture0255`. This has the effect of penalising the
model more for incorrectly predicting a non-`gesture0255` gesture, which will
prevent a model which only ever predicts `gesture0255` from achieving a good
categorical cross-entropy.

@ karpathy2019 recommends initialising the biases of the final layer of the FFNN
such that an untrained model predicts each gesture with approximately the
correct frequency. This means that if `gesture0255` occurs approximately 1000
times as frequently as any other gesture, then the biases of the final layer of
the FFNN should be initialised such that the otherwise untrained model will
predict `gesture0255` approximately 1000 more frequently than any other
gesture.

This is desirable as it means that an untrained model with bias initialisation
will not have to waste training epochs learning that the dataset is unbalanced.
For this reason, the biases of the final layer are initialised as recommended
by @ karpathy2019. The correct bias initialisation is dependant on the
activation function of the final layer. Because _Ergo_ uses the softmax
activation function for the final layer, the proper initialisations for each
bias can be calculated based on the frequency of each class:

$$
    \text{bias}_i = \ln \left(\frac{1}{\text{frequency}_i}\right)
$$

For $K$ classes and $i \in 1, \ldots, K$.

Using the biases initialised as above, a gesture which is twice as frequent in
the dataset will be predicted twice as often, even before the model has been
trained.

At the end of each epoch, the validation precision, recall, and $F_1$-score for
every gesture is calculated. See Appendix \ref{app:prec_rec_f1} for
definitions of precision, recall, and the $F_1$-score.

### Hyperparameter Optimisation

The hyperparameters `window_size`, `label_expansion`, the activation function
of each hidden layer, the number of hidden layers, the number of neurons per
hidden layer, the optimiser used, the learning rate, and the dropout rate were
all optimised via random search [@ bergstra2012]. This method defines
distributions for each hyperparameter and then samples from each of these
distributions to acquire a set of hyperparameters. The distributions of the
hyperparameters is given in Table \ref{tab:hyperpar_dists}

<!---
\begin{table}
\centering
\caption{Distribution of Hyperparameter values}
\begin{tabular}{ll}
\textbf{Hyperparameter} & \textbf{Values} \\
\hline
Activation Function & ReLU or ELU \\
Batch Size & 16, 32, 64, 128, 256, 512 \\
Dropout Fraction & $[0.5, 0.8]$ \\
Learning Rate & $[0.0001, 0.1]$ \\
Hidden units in layer 1 & $16, 17, 18, \ldots, 256$\\
Hidden units in layer 2 & $16, 17, 18, \ldots, 256$\\
Optimiser & ADAM, SGD, or RMSProp \\
\texttt{label_expansion} & $1, 2, 3, \ldots, 10$\\
\texttt{window_size} & $5, 6, 7, \ldots, 40$ \\
\hline
\end{tabular}
\label{tab:hyperpar_dists}
\end{table}
--->

During hyperparameter optimisation, it was found that the categorical cross
entropy does not always reflect the intuitive measure of a good model. To
explain this, consider a model which predicts every gesture perfectly, but
always predicts five time steps too late. So if this model should predict
`gesture0001` for time steps `i` through `i+10`, it will only predict
`gesture0001` for time steps `i+5` through `i+15` and predict `gesture0255` for
every other time step. This will significantly impact the model's cross-entropy
loss, as only five of the predictions were correct (those from `i+5` through to
`i+10`) and ten of the predictions were incorrect (those from `i` through to
`i+4`, and those from `i+11` through to `i+15`). On paper, this model has an
accuracy of only 33%. However, a delay of five time steps is only 0.125
seconds, meaning that this model will actually perform quite well in practice.
The delay will probably be noticeable, but predicting a gesture correctly every
time with a 0.125 second delay is a much better user experience than
immediately predicting the gesture, but only giving a correct prediction 33% of
the time.

For this reason, Dynamic Time Warping (abbreviated as DTW, see @ senin2008 for a
review) is used to calculate a measure of similarity between the predicted and
true probability distributions. DTW is a method used in signal processing when
two time-series signals are known to differ by some small amount of warping
which causes one signal to be slightly faster or slower than the other. DTW can
calculate a distance measure between the two time-series which is invariant to
all temporal shifting and scaling.

For this project, DTW is used to calculate the distance between the true
probability of a gesture occurring over time and the predicted probability of a
gesture occurring over time. If the distance provided by DTW is low, then the
prediction probabilities will be very similar to the true probabilities, but
may or may not be aligned perfectly with them. The DTW distance is calculated
for every non-`gesture0255` gesture, and the mean of those distances is used
for comparisons.

Each model was trained for 15 epochs during hyperparameter optimisation. A
total of 228 different models were trained, each on a different set of
hyperparameters. The parallel coordinates plot of this training is available in
Figure \ref{fig:par_coords}.

\begin{figure}
\centering
\includegraphics[width=0.9\textwidth]{src/imgs/par_coords.png}
\caption{A parallel coordinates plot showing each of the 228 models as a
different line. Each vertical bar represents a different hyperparameter,
and the ten models with the lowest DTW distance are highlighted for
clarity.}
\label{fig:par_coords}
\end{figure}

### Model Evaluation

After hyperparameter optimisation, the model with the following hyperparameters
was found to perform the best:

- Activation Function: ReLU
- Batch Size: 128
- Dropout Fraction: 0.5682
- Learning Rate: 0.0001832
- Hidden units in the first layer: 175
- Hidden units in the second layer: 97
- Optimiser: ADAM
- `label_expansion`: 8
- `window_size`: 14

The validation and training categorical cross-entropy loss for this model is
given in Figure \ref{fig:catxentropy}. The validation loss of this model is
consistently lower than the training loss. This is caused by the regularisation
effect of dropout, which is only applied when calculating the training loss and
is not applied when calculating the validation loss.

This trained model is compared to a "baseline" model which predicts that every
gesture is `gesture0255`. The baseline model has a categorical cross entropy of
0.78 on the validation set whereas the trained model achieved a categorical
cross entropy of 0.51 on the validation set

\begin{figure}
\centering
\includegraphics[width=0.45\textwidth]{src/imgs/catxentropy.pdf}
\caption{The categorical cross-entropy loss over time for the best
performing model found by hyperparameter optimisation, as well as for a
baseline model which always predicts \texttt{gesture0255}.}
\label{fig:catxentropy}
\end{figure}

Figure \ref{fig:precision_recall_f1} shows the precision, recall, and $F_1$
score for every gesture. It can be seen that the recall for `gesture0255`
starts out at 1.0 and the recall for all other gestures start out near zero.
This indicates that the model initially only predicted `gesture0255` for every
observation. The recall for `gesture0255` and all other gestures start to
converge as the model learns to distinguish the gestures from the noise and
stops always predicting `gesture0255`. At the end of training, the precision
for both `gesture0255` and for all other gestures is quite high at around 80%,
indicating that the model is rarely misclassifying gestures.

\begin{figure}
\centering
\includegraphics[width=0.8\textwidth]{src/imgs/precision_recall_f1.pdf}
\caption{The precision, recall, and $F_1$-score for the best performing
model found by hyperparameter optimisation. \texttt{gesture0255} is in
blue, the mean of all other gestures is in orange, and one standard
deviation around the mean is indicated by the orange shaded region.}
\label{fig:precision_recall_f1}
\end{figure}

Figure \ref{fig:val_confusion_matrices} shows the confusion matrix for the
validation set of nearly 45 000 observations. It is apparent that the model has
two main error states. The one error state is predicting `gesture0255` when the
true gesture was not `gesture0255`, shown by the column of coloured cells on
the far right of the confusion matrix. The other error state is predicting some
gesture that was not `gesture0255` when the correct gesture actually was
`gesture0255`, shown by the row of coloured cells along the bottom of the
confusion matrix. There are a few times when the model classifies one gesture
as another, but these are in the minority. It is likely that this is caused by
the model either predicting the start of a gesture too soon or too late.

\begin{figure}
\centering
\includegraphics[width=1.0\textwidth]{src/imgs/val_confusion_matrices.pdf}
\caption{The confusion matrix of the validation dataset of the best
performing model found by hyperparameter optimisation. The number in each
cell is the percentage of the total dataset contained in that cell. If a
cell does not contain a number, then exactly 0\% of observations are in that
cell. Most of the cells contain the digit 0, indicating nearly 0\% of
observations fall into that cell. This is because of the class imbalance
which causes the vast majority of observations to belong to
\texttt{gesture0255}. Each cell is coloured based on its content, so darker
cells have fewer observations and lighter cells have more observations.}
\label{fig:val_confusion_matrices}
\end{figure}

### Post-Processing Model Predictions

The previously discussed model is able to predict the gesture label when it is
provided with a time window of sensor measurements. These predictions require
preprocessing before they can be used to send keyboard input.

For maximum flexibility, the user can define a mapping from gesture predictions
to keystrokes in the form of a YAML file. This file defines how each predicted
gesture should be converted into a keystroke.

In order to increase the number of keys which the user can type while not
requiring significantly more gestures, certain sequences of gestures are
combined to make just one keystroke. Some of these will be intuitive to the
user, such as `Shift` + `a` combining to type the upper case letter `A`. This
style of replacements extends to all the Shift-based replacements used on an
International Standards for Organization (ISO) English keyboard (standard
ISO/IEC 9995-2). Some additional replacements are taken from the Vim insert
mode commands in order to reduce the number of non-printing characters which
will need explicit gestures. For example, `Control` + `[` will be replaced with
the Escape keystroke. A full list of these replacements (such as Enter and
Backspace) is also available in Appendix \ref{app:replacements}.

### Using _Ergo_ as a Keyboard

When _Ergo_ is being used as a keyboard via the command `python ergo.py
--as-keyboard`, the trained model is invoked at every time step and the
predicted gesture is stored. When the predicted gesture changes from
`gesture0255` to a non-`gesture0255` gesture, then the gesture to keystroke
mapping is used to map that non-`gesture0255` gesture to a keystroke. If the
user has provided sufficient privileges to the program, then the program will
send the keystroke to the Operating System, allowing the program to exactly
like a regular keyboard. If the program does not have sufficient privileges,
then the keystrokes will be written sequentially to a file.

### Lines of Code Written

Note that Arduino files (loaded onto the Arduino Nano) have the extension
`.ino`. Also, IPython Notebook files contain metadata beyond just the source
code, so need some pre-processing with the commandline json-parsing tool `jq`
before the lines of code can be extracted.

There are 2349 lines of Arduino and Python code:

\begin{lstlisting}[basicstyle=\fontsize{8}{8}\ttfamily]
$ wc -l arduino/_.ino machine_learning/_.py
94 arduino/left_main/left_main.ino
173 arduino/right_main/right_main.ino
76 arduino/test_bt_peri/test_bt_peri.ino
62 arduino/test_functionality/test_functionality.ino
31 arduino/test_multiplexor/test_multiplexor.ino
622 machine_learning/ergo.py
232 machine_learning/ergo.test.py
919 machine_learning/ml_utils.py
72 machine_learning/qt_predict.py
68 machine_learning/train_via_wandb.py
2349 total
\end{lstlisting}

And there are 289 lines of source code in the notebook:

\begin{lstlisting}[basicstyle=\fontsize{8}{8}\ttfamily]
$ jq '.cells[] | select(.cell_type == "code") .source[]'
machine_learning/tensorflow.ipynb
| wc -l

289
\end{lstlisting}

This totals to 2638 lines of code present in the code base. The total number of
lines added or removed can be tracked by the version control tool
[`git`](https://git-scm.com/) as:

\begin{lstlisting}[basicstyle=\fontsize{8}{8}\ttfamily]
$ git log --numstat --pretty="%H" $(git log --pretty="%H" | tail -1)..HEAD
| grep "\(\.py\|ipynb\|.rs\|\.ino\)"
| awk 'NF==3 {plus+=$1; minus+=$2} END {printf(
"%d lines added\n%d lines removed\n%d lines difference\n",
plus, minus, plus-minus)}'

14969 lines added
11955 lines removed
3014 lines difference
\end{lstlisting}

This means that 15 000 lines of code (in the languages Python, Rust, or
Arduino) were written over the course of the project, with 12 000 of those
lines ending up being removed.
