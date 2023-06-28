# Bibliography

::: {#refs}
:::

\footnote{TODO: rewrite the appendix}

\appendix

## Hardware Components \label{app:hardware}

This appendix details the different hardware components used.

### The ADXL335 Accelerometers

\begin{figure}[!htb]
\centering
\includegraphics[width=0.3\textwidth]{src/imgs/ADXL335.jpg}
\caption{One ADXL335 is used per finger in order to measure the linear
acceleration in the X, Y, and Z directions.}
\label{fig:adxl335}
\end{figure}

_Ergo_ has ten ADXL335 3-axis linear-accelerometers (built by @adxl335) which
are mounted on the user's fingertips. Each of these accelerometers measure the
amount of linear acceleration relative to the accelerometer along the X, Y, and
Z axes. Each accelerometer therefore outputs three continuous signals,
resulting in 15 continuous signals per hand.

The output signal is a value between 0 and 1024. The output signal has a small
amount of noise. A value of 512 roughly corresponds to no acceleration, with
values closer to zero corresponding to negative acceleration and values closer
to 1024 corresponding to positive acceleration. The accelerometers _do_ measure
the acceleration due to gravity, so the magnitude of the X, Y, and Z sensor
readings of a sensor at rest will be constant in the direction of gravity.

### The Arduino Nano 33 BLE

\begin{figure}[!htb]
\centering
\includegraphics[width=0.3\textwidth]{src/imgs/nano.jpg}
\caption{One Arduino Nano 33 BLE is used on each hand.}
\label{fig:nano}
\end{figure}

The Arduino Nano 33 BLE [@arduinoNano] is a 3.3V microcontroller. It has a
64MHz processor with 256 KB SRAM (for variable storage) and 1MB flash memory
(for program storage). With dimensions of 18mm by 45mm and weighing 5g, it is
small and light enough to be mounted on the back of the user's hand. One
Arduino Nano is used per hand.

### The CD74HC4067 16-to-1 Multiplexer

\begin{figure}[!htb]
\centering
\includegraphics[width=0.1\textwidth]{src/imgs/CD74HC4067.jpg}
\caption{One CD74HC4067 multiplexor is used per hand in order to multiplex
the fifteen signals into one.}
\label{fig:multiplexor}
\end{figure}

15 analogue input signals are required per hand for the accelerometers, but the
Arduino Nano does not have 15 analogue inputs pins. The 15 inputs from the
accelerometers are therefore multiplexed via a 16-to-1 multiplexer
[@cd74hc4067], and the 16th input to the multiplexer is ignored.

## Circuit Diagram of \emph{Ergo} \label{app:circuit-diagram}

Figure \ref{fig:circuit*diagram} shows the circuit diagram of \_Ergo*.

\begin{figure}[!htb]
\centering
\includegraphics[width=0.9\textwidth]{src/imgs/circuit_diagram.pdf}
\caption{Circuit diagram of one hand of \emph{Ergo}. The accelerometers and
multiplexer are in blue, and the Arduino Nano is in white.}
\label{fig:circuit_diagram}
\end{figure}

Please see appendix \ref{app:hardware} for details about off-the-shelf hardware
components. The two units that make up _Ergo_ are identical in terms of
circuitry, so what follows is the description of one unit.

Each of the five accelerometers produce three analogue outputs and take a 3.3v
power supply. These 15 analogue inputs are wired to the multiplexer which
outputs a single analogue signal from the `SIG` pin that is wired to the `A0`
pin of the Arduino Nano. The 4 selection pins labelled `S0` through `S3` on the
multiplexer allow the Arduino Nano to select which of the 15 analogue inputs
should be directed to the `A0` pin. These selection pins are connected to pins
`D11` through `D8` on the Arduino Nano.

To read the 15 analogue inputs, the Arduino Nano sets each of the four
selection pins to be above some threshold (`HIGH`) or below some threshold
(`LOW`). In this way, 16 unique values can be addressed. The multiplexer reads
the values on these four selection pins and then routes the corresponding
analogue input to its `SIG` pin, which is connected to the `A0` pin on the
Arduino Nano. For example, to read analogue input number eight, the Arduino
Nano would set `D11` to `HIGH` and `D10`, `D9`, `D8` to `LOW`. This corresponds
to the multiplexer's `S3` pin being `HIGH` and `S2`, `S1`, `S0` all being
`LOW`. The multiplexer then routes the signal from input pin `C8` to output pin
`SIG`. This `SIG` pin on the multiplexer is directly connected to the `A0` pin
on the Arduino Nano. The Arduino Nano can now read the value of the `A0` pin to
get the value of the eighth analogue input. By iterating over all 15 input
pins, the Arduino Nano can read a value for every analogue sensor every 5 to
15 milliseconds.

The multiplexer also has an enable pin `EN` which is connected to ground so
that the multiplexer is enabled. There is a $10k\Omega$ pull-down resistor that
connects the `SIG` pin to ground. This ensures the output signal will be zero
if the accelerometers are disconnected by mistake.

## Formulae

This appendix defines several formulae which are used in the report.

### Softmax \label{app:softmax}

The softmax activation function is defined as:

$$
    \sigma (\bm{z})_i = \frac{e^{z_i}}{\sum_{j=1}^{K} e^{z_j}}
$$

For $K$ classes and $i \in 1, \ldots, K$.

### Precision, Recall, and $F_1$-scores \label{app:prec_rec_f1}

Precision for a given classification model can be intuitively understood as
answering the question: For all observations labelled as belonging to class X,
how many actually do belong to class X? It is calculated as:

$$
    \text{precision} = \frac{\text{true positives}}{\text{all actual positives}}
$$

Where $\text{true positives}$ is the number of positive observations the model
classified as positive, and $\text{all actual positives}$ is the total number of
positive observations.

A model with poor precision will over-predict, classifying many negative
observations as being positive. For example, the two lines below represent a
time series from left to right, with each character being an observation in
that time series. The true labels are on top (a period `.` for a negative
observation, and `1` for a positive observation) and the predicted labels are
on the bottom

```
Model with low precision:
y_true: .......11111.......
y_pred: .....111111111.....
```

One can see that all the `1`s get correctly classified, but many periods get
incorrectly classified as being a `1`.

Recall for a given classification model can be intuitively understood as
answering the question: For all items that belong in class X, how many
were actually predicted to belong to class X? It is calculated as:

$$
    \text{recall}(k) = \frac{\text{true positives}}{\text{all predicted positives}}
$$

Where $\text{all predicted positives}$ is the number of observations the model
predicted as being positive.

A model with poor recall will under-predict, classifying not enough positive
observations as being positive. For example:

```
Model with low recall:
y_true: .......11111.......
y_pred: .........1.........
```

One can see that all the periods get correctly classified, but many `1`s get
incorrectly classified as being a period.

Given the definitions for recall and precision, the $F_1$-score is the harmonic
mean of precision and recall, defined as:

$$
    F_1 = 2 \cdot \frac{\text{precision} \cdot \text{recall}}{\text{precision} + \text{recall}}
$$

The $F_1$-score equally weights precision and recall. If one of precision or
recall were deemed more important for a particular task, then the more general
$F_{\beta}$ score allows the researcher to specify this importance by the
parameter $\beta$. $\beta$ is chosen such that recall is considered $\beta$
times as important as precision, and the $F_{\beta}$ score is defined as:

$$
    F_{\beta} = (1 + \beta^2) \cdot \frac{\text{precision} \cdot \text{recall}}{(\beta^2 \cdot \text{precision}) + \text{recall}}
$$

### Categorical Cross Entropy \label{app:cce}

The categorical cross-entropy loss function is defined as:

$$
    \text{loss}(\bm{true}, \bm{pred}) = - \sum_{\substack{t_i \in \bm{true}\\p_i \in \bm{pred}}} t_i \cdot \ln(p_i)
$$

Where $\bm{true}$ are the target predictions, and $\bm{pred}$ are the actual
predictions. Intuitively, this compares the discrete distributions of
$\bm{true}$ and $\bm{pred}$, with large differences between the distributions
resulting in a larger loss.

## Previous Work by the Author

It must be noted that the author's idea for an alternative computer input
method originated before he started his Honours degree in Computer Science at
Stellenbosch University.

Before the start of his Honours degree, the author built a single unit that
used sensors which could measure the degree to which four of his fingers were
bent. The goal of this project was to record the user's finger motions as they
typed, and use that data to train a model that allows the user to 'type'
without requiring an actual keyboard. For example, the user could make the same
motions as typing, but on a flat surface without a keyboard, and have those
motions be converted to keystrokes.

This project achieved a test accuracy of 87% after some initial model training.
See Figure \ref{fig:vvim_confusion_matrix} for the confusion matrix of this
model.

\begin{figure}[!htb]
\centering
\includegraphics[width=0.9\textwidth]{src/imgs/vvim_confusion_matrix.png}
\caption{The confusion matrix for the project done \emph{before} the author
started their Honours degree. Note the difficulty the model has with
distinguishing between characters \texttt{b} and \texttt{h}. This is
because the sensors measured flex in the fingers, and their position made
splaying motions difficult to detect.}
\label{fig:vvim_confusion_matrix}
\end{figure}

This report presents similar root ideas, but with a completely different
implementation and end goal. The sensors used for _Ergo_ measure acceleration
of the fingertips instead of the bend of the fingers as was used previously.
The custom-designed circuity is completely different from that used prior to
the author starting their Honours degree. The goal of _Ergo_ is to allow the
user to make arbitrary freehand gestures and have those be converted to
keystrokes. Whereas previous work interpreted the motions of the user's fingers
as they type keystrokes.

## Keystroke Replacements \label{app:replacements}

The full list of keystroke replacements is given in Table
\ref{tab:replacements}.

\begin{table}
\centering
\caption{Correspondance between gesture labels and rotation of the hand.}
\begin{tabular}{ll}
\hline
\textbf{Typed Keys} & \textbf{Replacement} \\
\hline
\texttt{Shift 1} & \texttt{!} \\
\hline
\texttt{Shift 2} & \texttt{@} \\
\hline
\texttt{Shift 3} & \texttt{\#} \\
\hline
\texttt{Shift 4} & \texttt{\$} \\
\hline
\texttt{Shift 5} & \texttt{\%} \\
\hline
\texttt{Shift 6} & \texttt{\^} \\
\hline
\texttt{Shift 7} & \texttt{\&} \\
\hline
\texttt{Shift 8} & \texttt{\*} \\
\hline
\texttt{Shift 9} & \texttt{(} \\
\hline
\texttt{Shift 0} & \texttt{)} \\
\hline
\texttt{Shift -} & \texttt{\_} \\
\hline
\texttt{Shift =} & \texttt{+} \\
\hline
\texttt{Shift [} & \texttt{\{} \\
\hline
\texttt{Shift ]} & \texttt{\}} \\
\hline
\texttt{Shift |} & \texttt{\textbackslash} \\
\hline
\texttt{Shift :} & \texttt{;} \\
\hline
\texttt{Shift '} & \texttt{"} \\
\hline
\texttt{Shift ,} & \texttt{<} \\
\hline
\texttt{Shift .} & \texttt{>} \\
\hline
\texttt{Shift /} & \texttt{?} \\
\hline
\texttt{Shift \`} & \texttt{\~} \\
\hline
\texttt{Control [} & \texttt{Escape} \\
\hline
\texttt{Control h} & \texttt{Backspace} \\
\hline
\texttt{Control m} & \texttt{Return} \\
\texttt{Control j} & \texttt{Return} \\
\hline
\end{tabular}
\label{tab:replacements}
\end{table}
