---
header-includes: |
    \usepackage{pdfpages}
    \usepackage{bm}
    \usepackage{booktabs}
    \usepackage{graphicx}
    \usepackage{algorithm}
    \usepackage{algpseudocode}
    \usepackage{xcolor}
---

# Background

This chapter describes various concepts which *Ergo* builds upon. The goal of
*Ergo* is to take a 30-dimensional time series dataset with a sampling
frequency of 40Hz, classify it in real-time into one of 51 gesture classes, and
then map those gestures to keystrokes. After this mapping, the keystrokes
must be forwarded onto the OS of the user's computer and autocorrect applied
(which should correct any common typing mistakes).

The relevant background information includes a wide variety of topics,
including different machine learning methods, autocorrect techniques, a
description of the gestures used, and a description of the hardware employed.

Artificial Neural Networks (ANNs) have shown a lot of promise in a wide range
of classification problems and are discussed in Section
\ref{artificial-neural-networks}. Multiple ANNs will be investigated, as they
have many desirable properties which make them suited to this problem.

Hidden Markov Models have historically been used for problems similar to that
which *Ergo* seeks to solve, and thus they will be used to provide a comparison
between candidate models and the prior work. They are discussed in Section
\ref{hidden-markov-models}.

CuSUM is a very simple baseline model which will provide an upper bound for how
quickly a non-trivial prediction can be made. It is discussed in Section
\ref{cusum}.

Section \ref{hardware-used} describes the hardware employed to capture
acceleration data from the user's fingertips.

Section \ref{gesture-classes} provides a description of the data and the
distribution of the different classes in this multi-class classification
problem.

Autocorrect is a valuable aid to users operating a virtual keyboard where
mistakes are common due to the nature of the interface, and so it is integrated
into *Ergo*. Autocorrect methods are discussed in Section \ref{autocorrect}

## Artificial Neural Networks

Artificial Neural Networks are a form of machine learning algorithm which have
shown good performance on a wide variety of problems. The core design is very
modular, presenting small building blocks which can be combined to create more
complicated architectures.

An ANN is best described as a directed acyclic graph with weights on every edge
of the graph. Each node accepts the weighted sum of all the edges directed to
it, adds a bias term, applies a non-linear \emph{activation function}, and then
provides the result of this activation function to the next nodes in the graph.
The weights and biases are learnt during training via a process called
\emph{backpropogation}. The changing of these parameters is what allows the ANN
to model a wide variety of different functions [@Hornik1989MultilayerFN].

A non-linear activation function is required, because the linearly weighted sum
of linearly weighted sums is just another linearly weighted sum. The activation
function enables the entire ANN to model non-linear functions. It is usually
chosen to be computationally efficient and differentiable. Common activation
functions are the Rectified Linear Unit (ReLU):

$$
    \text{ReLU}(x) = \max(x, 0),
$$

the sigmoid activation function:

$$
    \sigma(x) = \frac{1}{1 + e^{-x}},
$$

and the hyperbolic tangent function:

$$
    \tanh(x) = \frac{e^x - e^{-x}}{e^x + e^{-x}}.
$$

Given an ANN, the weight from neuron $k$ in layer $l-1$ to neuron $j$ in layer
$l$ can be labelled $w^l_{jk}$. The bias applied to neuron $j$ in layer $l$ can
be notated as $b^l_j$, and the activation function as $\sigma$. We will define
the output (also known as the _activation_) of a neuron $j$ in layer $l$ to be
$a^l_j$.

The output of a neuron can, therefore, be calculated recursively based on the
output of the neurons before it:

$$
    a^l_j = \sigma \left(\sum_k w^l_{jk} a^{l-1}_{k} + b^l_j \right)
$$

As a base case to this recursive definition, we define the "output" of the
first layer of the ANN to be equal to the input data:

$$
    a^0_j = x_j
$$

After repeated performing the multiplication of the weights, the addition of
the bias, and the application of the activation function, the output of the
final layer's neurons are the predictions for the ANN.

A loss function calculates a measure that approaches zero as a model's
predictions get closer to the true outputs. During the training process of an
ANN, the gradient of the loss function is used to tweak the weights and biases
of the ANN in the direction of the steepest descent, thereby decreasing the loss
and improving the model's performance.

For multi-class classification problems such as *Ergo*, categorical
cross-entropy is commonly used as the loss function [@Neal2007PatternRA].
Intuitively, categorical cross-entropy compares the expected discrete
probability distribution $p$ to a predicted discrete probability distribution
$q$. The distributions are compared element-wise, and instances where the
elements are not identical are penalised with a higher loss. These elements are
summed together to get the total loss.

Calculating whether or not the elements are identical is done via the
expression $- p_i \log q_i$. This expression encodes the idea that if the true
class is 1, then the loss is the log of the predicted label for that class
(which is negated because a log of a value between 0 and 1 is negative,
and we want non-negative loss).

If the predicted label is close to 1, then the log of that predicted label
will be close to 0 and thus the loss will be close to 0. However, if the
predicted label is close to 0 then the log of that predicted label will
approach negative infinity and thus the loss will be close to positive
infinity.

Note that if the true class is 0, the loss is zero.

The full expression for categorical cross-entropy loss is given by:

$$
    H(p, q) = - \sum_i p_i \log q_i
$$

## Hidden Markov Models

Hidden Markov Models (HMMs) are statistical prediction models used for
sequences of data. They describe a probabilistic finite state machine in which
the model moves from one state to another with certain transition
probabilities. The state in which the model is is not known to the observer
(hence it is "hidden"), but when a model enters a state it emits a value which
is observed as the collected training data. The distribution of this data is
dependent on the state in which the model is.

For HMMs to be used as multi-class classifiers, a one-vs-all approach must be
used where one HMM is trained on each class and the output of these HMMs are
compared. To predict which class an unknown observation is from, each HMM must
score that observation and the class of the maximum scoring HMM is used as the
predicted class.

## CuSum

CuSum [@page_continuous_1954] is a sequential method used for change detection.
Given a time series and some baseline value, it can alert when the time series
deviates from the baseline value over a series of steps.

The method works by keeping track of a cumulative sum and alerting if that
cumulative sum passes above some threshold value. The threshold value is
configurable, where lower thresholds result in faster alerts but more frequent
false positives. In order to detect both an increase and a decrease in the time
series, two CuSum algorithms must be used, one to detect an increase and one to
detect a decrease.

CuSum starts with a process $x_0, x_1, \ldots$ and a weight $\omega$ used to
tune the sensitivity of the algorithm. The cumulative sum is then initialised
to zero $S_0 = 0$ and each subsequent cumulative sum is calculated as:

$$
    S_{n+1} = \max(0, S_n + x_{n+1} - \omega)
$$

This cumulative sum is monitored, and if it exceeds some pre-selected threshold
value then a change is said to have been found.

The details of how this algorithm can be applied to a multi-class
classification problem diverge significantly from "background" information, and
so will be described in detail in the Methodology chapter.

## Hardware Used

The hardware that allows *Ergo* to sense the user's hand movements is made up
of ten accelerometers which measure linear acceleration (but not rotational
acceleration) in three orthogonal axes: X, Y, and Z. These accelerometers are
mounted on the user's fingertips, one per finger. For each axis, a 10-bit value
is emitted which is polled at a frequency of approximately 40Hz. This 10-bit
value is the acceleration reading for each axis, and it includes the force of
gravity.

Two Arduino Nano 33 BLEs are each mounted on the back of the user's hand, and
package the data from the accelerometers before it is transferred to the user's
computer.

Due to a lack of hardware input/output (IO) ports on the Arduino Nanos, the
sensors are not directly connected to the Arduino Nanos. On each hand, the five
accelerometers are connected to a CD74HC4067 16-to-1 multiplexer, which is
connected to and controlled by the Arduino Nano for that hand.

In order to transmit the acceleration reading from each Arduino Nano to the
user's computer, the data from the left hand is first transmitted via a wired
serial connection to the right hand. The data from the right hand is then
combined with the data from the left hand, and this is passed onto the user's
computer via a wired serial connection. Software on the user's computer is then
able to read the acceleration readings from the ten sensors in real-time. These
ten sensors each provide three acceleration readings 40 times per second,
resulting in the 40Hz 30-dimensional time series.

## Gesture Classes

In this report, a gesture is defined as a motion of the hands and/or fingers
that takes less than 500ms to complete.

For full keyboard functionality, fifty gesture classes are required. These
fifty classes will allow the 26 letters of the English alphabet, the numerals
zero through to nine, several non-printing or white-space keys, and twelve
punctuation characters.

The 30-dimensional time series is labelled in a way that assigns the label
corresponding to a gesture to the time step when the gesture begins. All other
time steps in the series are labelled with a NULL label. This results in there
being 51 total classes.

The hand movements associated with the 50 non-null gesture classes are defined
systematically as a Cartesian product of a hand supination/pronation (rotation
at the wrist) and a single-finger flexion (rotation) at the proximal
interphalangeal (PIP) joint (the joint on the fingers closest to the knuckle).
Five rotations and ten fingers result in the required fifty non-null gestures.

## Autocorrect

Autocorrect is a tool used when the nature of the interface means that small
user errors are common. This is ideal for *Ergo*, as new users may not be
familiar with the input method and autocorrect can make their experience much
better. Autocorrect will generally change words as they are typed, replacing
a misspelt word with its nearest match. The definition of "near" depends on
the implementation, but it is generally defined to minimise the number of
changes required to transform one word into another.

One of the simplest methods for autocorrect was popularised by Peter Norvig in
his spelling corrector [@norvig_how_2007]. This method takes an input source
text (a \emph{corpus}) and calculates prior probabilities for each word in that
source. These priors can then be used to create a model of the target language,
such that given some word $w$ that was not in the corpus, the program can
calculate which of the words similar to $w$ are most likely to be what the
author intended to type.

"Similarity" is a key word here, and exactly how one defines it can have a
great impact on the performance of the program. A complex model might make
assumptions about the layout of the keyboard or attempt to achieve better
priors for certain words based on the context. For example, both `planed` and
`planned` are valid English words, however given the sentence `We planed to
meet after dinner`, the word `planed` does not make sense in the context, and
should be replaced by `planned`.

Norvig defines similarity in an intentionally naïve but computationally
efficient manner, by considering all words that are one "edit" away from a
source word, where an edit can be any deletion, replacement, or insertion of a
single character, or the swapping of two adjacent characters.

When evaluating a word for possible mistakes, it then only considers all other
words in the corpus which are two "edits" away from the source word and
assesses their prior. If an edited word has a higher prior probability than the
source word, then it will replace the source word.

This error correction method was implemented in *Ergo* so that the user is able
to type without correcting every mistake.

This procedure is given in Algorithm \ref{alg:autocorrect}.

\begin{algorithm}
    \caption{Norvig Spelling Correction}
    \label{alg:autocorrect}
    \begin{algorithmic}[1]
    \State $\text{wordsAndCounts} \gets \textsc{GetWordCounts}(\textsc{ReadFile}(\text{`all\_words.txt'}))$

    \State
    \Function{FilterUnknown}{words} \Comment{Filter out unknown words}
        \State \Return $\{w \mid w \in \text{words} \text{ and } w \in \text{wordsAndCounts}\}$
    \EndFunction

    \State
    \Function{SingleEdits}{word}
        \State $\text{letters} \gets \text{`abcdefghijklmnopqrstuvwxyz'}$
        \State $\text{splits} \gets [(word[:i], word[i:]) \mid i \text{ in 0..}(word.length + 1)]$
        \State $\text{deletions} \gets [L + R[1:] \mid L, R \text{ in } \text{splits} \text{ if } R]$
        \State $\text{transpositions} \gets [L + R[1] + R[0] + R[2:] \mid L, R \text{ in } \text{splits} \text{ if } \text{length}(R) > 1]$
        \State $\text{replacements} \gets [L + c + R[1:] \mid L, R \text{ in } \text{splits} \text{ if } R \text{ for } c \text{ in } \text{letters}]$
        \State $\text{insertions} \gets [L + c + R \mid L, R \text{ in } \text{splits} \text{ for } c \text{ in } \text{letters}]$
        \State \Return $\text{unique}(\text{deletions} , \text{transpositions} , \text{replacements} , \text{insertions})$
    \EndFunction

    \State
    \Function{DoubleEdits}{word}
        \State \Return $[secondEdit \mid$ \\
        \quad \quad $firstEdit \text{ in } \textsc{SingleEdits}(word)$ \\
        \quad \quad $\text{and } secondEdit \text{ in } \textsc{SingleEdits}(firstEdit)]$
    \EndFunction

    \State
    \Function{GetCandidateCorrections}{word}
        \State \Return \textsc{unique}( \\
            \qquad \textsc{FilterUnknown}([word]), \\
            \qquad \textsc{FilterUnknown}(\textsc{SingleEdits}(word)), \\
            \qquad \textsc{FilterUnknown}(\textsc{DoubleEdits}(word)), \\
            \qquad \textsc{[word]})
    \EndFunction

    \State
    \Function{ProbabilityOfWord}{word}
        \State $totalWords \gets \sum(\text{wordsAndCounts.counts}())$
        \State \Return $\frac{\text{wordsAndCounts[word]}}{totalWords}$
    \EndFunction

    \State
    \Function{GetCorrectedWord}{word}
        \State \Return $\textsc{Max}($ \\
        \quad \quad $\textsc{GetCandidateCorrections}(word),$ \\
        \quad \quad $\textsc{Key}=ProbabilityOfWord)$
    \EndFunction

    \end{algorithmic}
\end{algorithm}



# References
