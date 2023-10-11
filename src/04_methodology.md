## Construction of Ergo (?)

- What does _Ergo_ look like?
- Where are the sensors placed?

## How the data was collected

- Gravity is included
- 10 sensors, 3 axes per sensor
- 30 dimensional time series, recorded at ~40Hz, about 100 examples per
  class, 50 classes, 1 majority class (g255), around 230k observations.
- Data segmentation is "implicit": There's no nice labels marking the start
  and end of each gesture, the model has to learn 1. how to extract
  gestures from background and 2. how to differentiate between the
  different gestures.
- Data was collected over multiple sessions, performing the same ~5 gestures
  repeatedly and then manually labelling the data

## How the data was labelled

- Each model gets the same data
- Data is a time-series window of observations
- One label per time window

## Splitting the data into train, test, validation

- Data split into training, validation, testing (elaborate on the purpose of
  these datasets, how they were kept separate, and how "leakage" was prevented)

## How is cross validation performed?

## What experiments will be conducted?

- (These should tie into the "research questions" asked in the introduction)

## Model-specific stuff

### HMM

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- Discussion about why the HMMs couldn't be trained on every training
  observation but could be evaluated on every validation observation.
- Probably also need to acknowledge those mad lads with the 5000-class HMM
  classifier

### CuSUM

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- How does CuSUM perform one-vs-rest classification, how does "passing a
  threshold" get transformed into a gesture detection?

### FFNN

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.
- Dropout means that validation and training loss are not directly comparable
- Thoroughly explain the purpose of regularization wrt dropout, L2 norm, etc
- What optimizer is used?
- What loss function?
- activation function?
- How do the inputs get weighted?

### HFFNN

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.

### SVM

- Describe in obscene detail the exact architecture of the HMMs and how they
  ingest observations to finally return predictions.
  - Do they just return binary predictions? Log-likelihood predictions?
    Probability prediction? soft-max predictions?
- Which hyperparameters were tested? (and over what range of values?)
- Is this a multi-class classification model? How was it converted into one?
- Some way of measuring the "volume" of the search space such we can reasonably
  say we've searched each model's search space to the same density.

## How is hyperparameter optimisation done?

- Random search for each model type over their search space.
- Repeated 5 times per model+hyperparameter combination

## Evaluation metrics

- How accuracy falls flat
- precision, specificity, recall, $F_{\beta}$, $F_1$, confusion matrices,
  macro/micro/weighted average.
- For this unbalanced dataset, macro-precision and macro-recall are roughly
  equivalent to high precision/recall on just the non-gesture class
- Justify why macro-f1 score is used as the primary evaluation metric
- How exactly do we convert predictions into evaluation metrics?

## How will the models be ranked?

- ranked based on the performance of the lower bound of the 90% percentile
  - Maybe we need to prove that 90% is reasonable, and the results don't
    really change if we pick 95% nor 99% nor 100%

## How are predictions turned into keystrokes?

---

## Hardware Description

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
