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

This chapter describes various concepts which *Ergo* builds upon. The dataset
recorded by the *Ergo* hardware is a 30-dimensional time series with a sampling
frequency of 40 Hz, and so the relevant background work includes different
machine learning methods, autocorrect, and a more detailed description of the
dataset.

A system is required that can classify this time series into one of 51 classes.
Due to the number of classes and the subtle differences between different
classes, different machine learning models were investigated. *Ergo* is also
designed to work in real-time, which makes the prediction time of a candidate
machine learning model of high importance.

Background about the machine learning models tested in the development of
*Ergo* is provided in this chapter. Information about the hardware used, the
autocorrect mechanism for typing assistance, and how the different gesture
classes are structured are also provided.

Artificial Neural Networks (ANNs) have shown a lot of promise in a wide
range of classification problems. Multiple FFNNs will be investigated, as they
have many desirable properties which make them suited to this problem.

Hidden Markov Models have historically been used for problems similar to that
which *Ergo* seeks to solve, and thus they will be used to provide a comparison
between candidate models and the prior work.

CuSUM is a very simple baseline model which will provide an upper bound for how
quickly a non-trivial prediction can be made.

These three model types are described in detail below.

## Artificial Neural Networks

Artificial Neural Networks (ANN) are a form of machine learning algorithm which have
shown good performance on a wide variety of problems. They core design is very
modular, presenting small building blocks which can be combined to create more
complicated architectures.

An ANN is best described as a directed acyclic graph (DAG) with weights on
every edge of the graph. Each node accepts the weighted sum of all the edges
directed to it, adds a bias term, applies a non-linear \emph{activation
function}, and then provides the result of this activation function to the next
nodes in the graph. The weights of the edges are learnt during training via a
process called \emph{backpropogation}, and are what allows the ANN to model a
wide variety of different functions.

A non-linear activation function is required, because the linearly weighted sum
of linearly weighted sums is just another linearly weighted
sum\footnote{reference?}. The activation enables the entire ANN to model
non-linear functions. The activation function is usually chosen to be
computationally efficient and differentiable, although the effect of different
activation functions is not entirely understood. Common activation functions
are the Rectified Linear Unit (ReLU):

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

This process of taking the weighted sum of the inputs, adding a bias, applying
the activation function, and passing the result to the next layer of nodes
continues until the last layer of nodes is reached. The result of the
activation functions from this layer of nodes is then the output as predicted
by the mode $\hat{y}$. Depending on the problem at hand, this might be one
value or multiple.

Given an ideal output $y$, an error can then be calculated, usually via a
\emph{loss function} which describes how an ANN is penalised for incorrect
predictions. This loss is then distributed backwards through the network,
tweaking the weights of each edge by some amount proportional to the effect
that edge had on the final output. This process is called backpropogation
\footnote{Is a more precise definition required?}.

By repeating this process for available training data multiple times,
backpropogation will cause the weights of the edges to change such that the
output produced by the model approaches the training output. In this way it can
be said that the ANN is able to "learn" what output is expected for certain
input.

ANNs have shown great ability in a wide variety of problems including
regression, classification, image recognition, speech to text, fraud
detection, automatic translation, and others\footnote{references}.

### Mathematical foundation

Given an ANN, the weights can be labelled $w^l_{jk}$, the biases $b^l_j$, and
the activation function $\sigma$. We will define the output (also known as the
_activation_) of a neuron to be $a^l_j$.

The output of a neuron can therefore be calculated recursively based on the
output of the neurons before it:

$$
    a^l_j = \sigma \left(\sum_k w^l_{jk} a^{l-1}_{k} + b^l_j \right)
$$

As a base case to this recursive definition, we define the "output" of the
input layer of the ANN to be equal to the input data:

$$
    a^0_j = x_j
$$

The output of the final layer's neurons are then used as the predictions for
the ANN.

A loss function calculates a measure that approaches zero as a model's
predictions get closer to the true outputs. During the training process of an
ANN, the gradient of the loss function is used to tweak the weights and biases
of the ANN in the direction of steepest descent, thereby decreasing the loss
and improving the model's performance.

For multi-class classification problem such as *Ergo*, categorical
cross-entropy is commonly used as the loss function\footnote{TODO reference}.
Intuitively, categorical cross-entropy compares the expected discrete
probability distribution $p$ to a predicted discrete probability distribution
$q$. The distributions are compared element-wise, and instances where the
elements are not identical are penalised with a higher loss. These elements are
summed together to get the total loss.

Calculating whether or not the elements are identical are done via the
expression $- p_i \log q_i$. This expression encodes the idea that if the true
class is one, then the loss is the log of the predicted label for that class
(which is negated because a log of a value between zero and one is negative,
and we want non-negative loss).

If the predicted label is close to one, then the log of that predicted label
will be close to zero and thus the loss will be close to zero. However, if the
predicted label is close to zero then the log of that predicted label will
approach negative infinity and thus the loss will be close to positive
infinity.

Note that if the true class is zero, no loss is contributed.

The full expression for categorical cross entropy loss is given by:

$$
    H(p, q) = - \sum_i p_i \log q_i
$$


## Hidden Markov Models

Hidden Markov Models (HMMs) are a kind of statistical prediction model used for
sequences of data. They describe a probabilistic finite state machine in which
the model moves from one state to another with certain transition
probabilities. The state which the model is in is not known to the observer
(hence it is "hidden"), but when a model enters a state it emits an item in the
observation of data that is observed. The distribution of this data is
dependant on the state which the model is in.

HMMs can only produce a score for the likelihood that a given observation was
from the data it was trained on. For HMMs to be used as multi-class
classifiers, a one-vs-all approach must be used where one HMM is trained on
each class. To predict which class an unknown observation is from, each
HMM must be polled and the class of the maximum scoring HMM is used as the
predicted class.

Generally there are three tasks involved when working with HMMs. The first is
to determine the likelihood that a given observation is from a given HMM. The
second is, given a model and a observation, to determine the most likely
series of states that that observation passed through via the HMM. The third
is, given an observation, find the parametrization of a HMM that maximises the
likelihood of that observation.

An HMM can be defined as a set of $n$ states $S$, a transition probability
matrix $T \in \Re^{n \times n}$, and a set of emission probability
distributions $E$, where $|E| = |S|$.

In $T$, each element $t_{ij}$ is the probability that the HMM will transition
from state $i$ to state $j$ (with $i, j \in [1, 2, 3, \ldots, n]$).

Each emission probability distribution defines the probability of observing a
certain output given that the model is in some hidden state. For examplethe
emission probability distribution for state $s_1$ might have a high probability
of emitting numbers close to 1, and the emission probability distribution might
have a high probability of emitting numbers close to $2$, and so on. Note that
it might still be possible to emit a 2 when in state $s_1$, but it is less
likely than emitting a $1$.

## CuSum

CuSum (cumulative sum) [@page_continuous_1954] is a sequential method used for
change detection. Given a time series and some baseline value, it is a very
simple method that can alert when the time series deviates from the baseline
value over a series of steps.

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
combined with the data from the left hand, and this is passed on to the user's
computer via a wired serial connection. Software on the user's computer is then
able to read the acceleration readings from the ten sensors in real time. These
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
a misspelt word with it's nearest match. The definition of "near" depends on
the implementation, but it is generally defined to minimise the number of
changes required to transform one word into another.

One of the simplest methods for autocorrect was popularised by Peter Norvig in
his spelling corrector [@norvig_how_2007]. This method takes an input source
text (a \emph{corpus}) and calculates prior probabilities for each word in that
source. These priors can then be used to create a model of the target language,
such that given some word $w$ that was not in the corpus, the program can
calculate which of the words similar to $w$ are most likely to be what the
author intended to type.

"Similarity" is a key word here, and exactly how one defines it can have great
impact on the performance of the program. A complex model might make
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
words in the corpus which are two "edits" away from the source word, and
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


