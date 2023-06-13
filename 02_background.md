---
header-includes: |
  \usepackage{algorithm}
  \usepackage{algpseudocode}
  \usepackage{bm}
  \usepackage{booktabs}
  \usepackage{graphicx}
  \usepackage{pdfpages}
  \usepackage{soul}
  \usepackage{tikz}
  \usepackage{xcolor}
---

# Background

\marginpar{rewrite}

This chapter describes various concepts which _Ergo_ builds upon. The goal of
_Ergo_ is to take a 30-dimensional time series dataset with a sampling
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
which _Ergo_ seeks to solve, and thus they will be used to provide a comparison
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
into _Ergo_. Autocorrect methods are discussed in Section \ref{autocorrect}

## Artificial Neural Networks

Artificial Neural Networks (ANNs, also known as multi-layer perceptrons or
MLPs) are a form of machine learning which started with the development of the
perceptron by @Rosenblatt1963PRINCIPLESON and was itself inspired by
@McCulloch2021ALC.

This section will first describe the perceptron in subsection
\ref{perceptrons}. Then neural networks will be covered in subsection
\ref{neural-networks}. Proof that one-layer ANNs can approximate any function
is given in subsection \ref{universality-theorem}, and a mathematical
description of how the weights and biases are tuned via gradient descent is given in subsection \ref{gradient-descent}.

The method by which backpropogation allows for the efficient calculation of the
gradients within a neural network is described in subsection
\ref{backpropogation}, and some details about the loss function used for
multi-class classification problems, cross entropy loss, is described in
subsection \ref{cross-entropy-loss}.

### Perceptrons

A perceptron takes in a finite dimensional vector of real-valued inputs,
applies some function, and produces a single real-valued output. Rosenblatt
proposed a weighting system which was used to compute the output, whereby each
of the input values $x_0, x_1, \ldots, x_n$ is multiplied by a corresponding
weight $w_0, w_1, \ldots, w_n$ and the results are summed together.

Rosenblatt originally required the inputs and the output to be binary, which
implies that the output would be 1 if and only if the sum of the weighted
inputs passed some threshold value:

$$
    \text{output} = \begin{cases}
        0 & \text{if}\ \sum_j w_j x_j \le \text{threshold} \\
        1 & \text{if}\ \sum_j w_j x_j > \text{threshold} \\
    \end{cases}
$$

Modern implementations of a perceptron have changed many aspects of
Rosenblatt's initial description. The threshold was replaced with the
combination of a bias $b$ term and a comparison with zero:

$$
    \text{output} = \begin{cases}
        0 & \text{if}\ b + \sum_j w_j x_j \le 0 \\
        1 & \text{if}\ b + \sum_j w_j x_j > 0 \\
    \end{cases}
$$

Instead of a comparison to zero and restricting the output to a binary 1 or 0,
a scaling function $\sigma: \mathbb{R} \to (0, 1)$ is used which restricts the
range of the output:

$$
    \text{output} = \sigma \left( \ b + \sum_j w_j x_j \right)
$$

This function is called the activation function, and there have been several
different functions proposed. The first was the sigmoid (or logistic)
activation function (see Figure \ref{fig:02_sigmoid}).

$$
    \sigma(x) = \frac{1}{1 + e^{-x}}
$$

The sigmoid activation function can easily be differentiated, a property which
will become useful when discussing backpropogation in subsection
\ref{backpropogation}.

\begin{figure}[!htb]
\centering
\includegraphics[width=0.3\textwidth]{imgs/02_sigmoid.png}
\caption{The sigmoid activation function.}
\label{fig:02_sigmoid}
\end{figure}

### Neural Networks

Individual perceptrons can be combined to form a network of perceptrons where
the outputs of some perceptrons become the inputs for other perceptrons (see
Figure \ref{fig:02_nn}). These perceptrons (or "neurons", as they are often
called in this context) are arranged in layers in a directed acyclic graph,
where every output from the neurons in layer $i$ is passed as an input to every
neuron in layer $i+1$. The first layer is called the input layer, and those
neurons simply output the data being modelled. There is one neuron for each
dimension of the input data.

The last layer is called the output layer, and a different activation is
sometimes applied to this layer (depending on the problem being solved). The
intermediate layers between the input and the output are collectively called
the hidden layers.

<!-- prettier-ignore-start -->
\begin{figure}
    \centering
    \label{fig:02_nn}
    \begin{tikzpicture}
        % Number of input neurons
        \newcommand{\inputnum}{3}

        % Number of neurons in the hidden layer
        \newcommand{\hiddennum}{5}

        % Number of output neurons
        \newcommand{\outputnum}{2}

        % Input Layer
        \foreach \i in {1,...,\inputnum} {
            \node[
                circle,
                minimum size = 6mm,
                draw=black
            ] (Input-\i) at (0,-\i) {};
        }

        % Hidden Layer
        \foreach \i in {1,...,\hiddennum} {
            \node[
                circle,
                minimum size = 6mm,
                draw=black,
                yshift=(\hiddennum-\inputnum)*5 mm
            ] (Hidden-\i) at (2.5,-\i) {};
        }

        % Output Layer
        \foreach \i in {1,...,\outputnum} {
            \node[
                circle,
                minimum size = 6mm,
                draw=black,
                yshift=(\outputnum-\inputnum)*5 mm
            ] (Output-\i) at (5,-\i) {};
        }

        % Connect neurons In-Hidden
        \foreach \i in {1,...,\inputnum} {
            \foreach \j in {1,...,\hiddennum} {
                \draw[->, shorten >=1pt] (Input-\i) -- (Hidden-\j);
            }
        }

        % Connect neurons Hidden-Out
        \foreach \i in {1,...,\hiddennum} {
            \foreach \j in {1,...,\outputnum} {
                \draw[->, shorten >=1pt] (Hidden-\i) -- (Output-\j);
            }
        }

        % Inputs
        \foreach \i in {1,...,\inputnum} {
            \draw[<-, shorten <=1pt] (Input-\i) -- ++(-1,0)
            node[left]{$x_{\i}$};
        }

        % Outputs
        \foreach \i in {1,...,\outputnum} {
            \draw[->, shorten <=1pt] (Output-\i) -- ++(1,0)
            node[right]{$y_{\i}$};
        }
    \end{tikzpicture}
    \caption{A neural network with three input neurons, five hidden neurons,
    and two output neurons}
\end{figure}
<!-- prettier-ignore-end -->

Intuitively it would seem like this symphony of perceptrons would be more
useful than just one perceptron, and this intuition does hold true, given some
requirements which will be discussed in Section \ref{TODO:UniversalityTheorem}.

### Universality Theorem

TODO

### Gradient descent

Given a neural network with the correct number of input, hidden, and output
neurons for your problem, how do we find the correct values for the many
weights and biases such that the networks output $\hat{\bm{y}}$
matches our expected output $\bm{y}$?

Given a large number of observations and their expected output, gradient
descent calculates how to change the weights and biases so as to decrease the
difference between $\hat{\bm{y}}$ and $\bm{y}$.

To achieve this, we define a cost function which gradient descent will
minimise:

$$
    C(w, b) = \frac{1}{2n} \sum_x || \bm{y} - \hat{\bm{y}}(w, b, x) ||^2
$$

Where $w$ are the weights of the network, $b$ the biases, $x$ the input data,
and $n$ the number of observations. This cost function is known as the mean
squared error.

Gradient descent can be intuitively understood as evaluating $C(w, b)$ at some
initial $(w, b)$ and then calculating the derivative of $C(w,b)$ at that point.
The derivative will provide information about how to apply a small nudge to
$(w, b)$ so that $C(w, b)$ will decrease. Iteratively applying this approach
will cause the cost function to decrease to either a local minimum. There are
some theoretical and practical issues, but this intuition is helpful when
describing the mathematics behind the process.

To control the amount by which we nudge $(w, b)$, we define the _learning rate_
to be a scalar hyperparameter $\eta$. Large learning rates will often converge
on a minimum with fewer iterations than small values, but values too large will
not converge at all.

Let the weight from the $k$th neuron in the $(l-1)$th layer to the $j$th neuron
in the $l$th layer be referred to as $w_{jk}^l$ and similarly let the bias on
the $j$th neuron in the $l$th layer be $b_j^l$. In order to decrease the cost
function, we will take some step proportional in magnitude to the learning rate
$\eta$ in the direction of the negative gradient:

$$
    w_{jk}^l \gets w_{jk}^l - \eta \frac{\partial C}{\partial w_{jk}^l}
$$

$$
    b_j^l \gets b_j^l - \eta \frac{\partial C}{\partial b_j^l}
$$

Note that '$\gets$' is being used to indicate an update to the weight $w_{jk}^l$
or bias $b_j^l$. These equations define the change which would decrease the
cost function, but they rely on knowing the gradient of the cost function with
respect to any weight $w_{jk}^l$ or bias $b_j^l$. The calculation of this
gradient is done by backpropogation, the subject of the next subsection.

Gradient descent can be made more efficient via an adjusted algorithm called
Stochastic Gradient Descent (SGD), which works by batching the data into
subsets and only changing the weights and biases based on the average gradient
over the observations in each batch.

Optimisation algorithms other than SGD are more commonly used in practical
machine learning, such as AdaGrad [@Duchi2011AdaptiveSM] which is performant on
sparse gradients, RMSProp [@RMSProp] which works well in non-stationary
settings, and Adam [@Kingma2014AdamAM] which provides good performance with
little tuning.

### Backpropogation

Backpropogation is the process of efficiently calculating the gradient of the
cost function $C(w, b)$ with respect to any weight or bias in the network. It
derives from the method of reverse mode automatic differentiation for networks
of differentiable functions introduced by @Leppo1970 and was popularised for
deep learning applications in @Rumelhart1986LearningRB.

For notation, we will use $w_{jk}^l$ to refer to the weight from the $k$th
neuron in the $(l-1)$th layer to the $j$th neuron in the $l$th layer.
Similarly, $b_j^l$ will refer to the bias on the $j$th neuron in the $l$th
layer. $a_j^l$ will refer to the output of the $j$th neuron in the $l$th layer.
Finally, let $L$ be the last layer of the network, such that $a^L$ is the
output of the network.

With this notation, the process of forward propagating values through the
network can be seen as applying a function on the outputs of the previous
layer's neuron like so:

$$
    a^{l}_j = \sigma\left( \sum_k w^{l}_{jk} a^{l-1}_k + b^l_j \right)
$$

By defining a matrix of weights $w^l$, a vector of biases $b^l$, and a vector
of activations $a^l$, we can rewrite the above equation in matrix notation as

$$
    a^{l} = \sigma\left( w^{l} a^{l-1} + b^l \right).
$$

We will also define an intermediate quantity $z^l = w^{l} a^{l-1} + b^l$.

Using the chain rule, the partial derivative of the cost function with respect
to an arbitrary weight $w_{jk}^l$ is expanded to include $z_j^l$

$$
    \frac{\partial C}{\partial w_{jk}^l} = \frac{\partial C}{\partial z_j^l} \frac{\partial z_j^l}{\partial w_{jk}^l}
$$

which can then be simplified to be in terms of the activation of the previous
layer $a_k^{l-1}$:

$$
    \frac{\partial C}{\partial w_{jk}^l} =
    \frac{\partial C}{\partial z_j^l}
        \frac{\partial \left(
                w_{jk}^l a_{j}^{l-1} + b_j^l
        \right)}{\partial w_{jk}^l}
    = \frac{\partial C}{\partial z_j^l} a_k^{l-1}
$$

The partial derivative of the cost function with respect to an arbitrary bias
is expanded and calculated similarly:

$$
    \frac{\partial C}{\partial b_j^l} =
    \frac{\partial C}{\partial z_j^l} \frac{\partial z_j^l}{\partial b_j^l}
    = \frac{\partial C}{\partial z_j^l}
        \frac{\partial \left(
                w_{jk}^l a_{j}^{l-1} + b_j^l
        \right)}{\partial w_{jk}^l}
    = \frac{\partial C}{\partial z_j^l}
$$

The chain rule can be applied in order to express the partial derivative
$\frac{\partial C}{\partial z_j^L}$ in terms of the partial derivative of the
activations of the last layer and the derivative of the activation function:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial C}{\partial z_j^L} &= \frac{\partial C}{\partial a_j^L}
    \frac{\partial a_j^L}{\partial z^L_j} \\
    &= \frac{\partial C}{\partial a_j^L}
    \frac{\partial \left( \sigma(z_j^L) \right)}{\partial z^L_j} \\
    &= \frac{\partial C}{\partial a_j^L} \sigma'(z_j^L)
\end{align*}
<!-- prettier-ignore-end -->

Note that all terms in the expression $\frac{\partial C}{\partial a_j^L}
\sigma'(z_j^L)$ are easily calculated. $\frac{\partial C}{\partial a_j^L}$ will
depend on the cost function, but for the mean squared error cost function it is
simply $a^L_j - y_j$:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial C}{\partial a_j^L} &= \frac{\partial }{\partial a_j^L}
    \left[ \frac{1}{2} \sum_j ||y_j - a_j^L||^2 \right] \\
        &= a^L_j - y_j\\
\end{align*}
<!-- prettier-ignore-end -->

$\sigma'$ is also efficiently calculated as the activation function does not
change. For the sigmoid activation function, the derivative is $\sigma(x) (1 -
\sigma(x))$:

<!-- prettier-ignore-start -->
\begin{align*}
\sigma'(x) &= \frac{d}{dx} \left( 1 + \mathrm{e}^{-x} \right)^{-1} \\
    &= \frac{e^{-x}}{\left(1 + e^{-x}\right)^2} \\
    &= \frac{1}{1 + e^{-x}\ } \cdot \frac{e^{-x}}{1 + e^{-x}}  \\
    &= \sigma(x) \cdot \frac{(1 + e^{-x}) - 1}{1 + e^{-x}}  \\
    &= \sigma(x) \cdot \left( \frac{1 + e^{-x}}{1 + e^{-x}} - \frac{1}{1 + e^{-x}} \right) \\
    &= \sigma(x) \cdot \left( 1 - \frac{1}{1 + e^{-x}} \right) \\
    &= \sigma(x) (1 - \sigma(x))
\end{align*}
<!-- prettier-ignore-end -->

Which in turn means that $\sigma'(z_j^L)$ is easily calculated as $z_j^L$ can
be stored during the forward pass.

Given that we know $\frac{\partial C}{\partial a_j^L} \sigma'(z_j^L)$, we can
calculate the partial derivatives $\frac{\partial C}{\partial z_j^l}$ one at a
time moving backwards through the layers of the network using the following
result:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial C}{\partial z_j^l}
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \frac{\partial }{\partial z_j^l} \left[ z_i^{l+1} \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \frac{\partial}{\partial z_j^l} \left[
        \sum_k w_{ik}^{l+1} a_k^l + b_i^{l+1}
        \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \frac{\partial}{\partial z_j^l} \left[
        \sum_k w_{ik}^{l+1} \sigma(z_k^l) + b_i^{l+1}
        \right] \\
\intertext{
    Note that the partial derivative of the sum over $k$
    ($\frac{\partial}{\partial z_j^l} \sum_k$) is all zeros except where $j=k$
}
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \left[
        0 + \ldots + w_{ij}^{l+1} \sigma'(z_j^l) + \ldots + 0
        \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} w_{ij}^{l+1} \sigma'(z_j^l)
\end{align*}
<!-- prettier-ignore-end -->

This shows that the partial derivative of each layer $\frac{\partial
C}{\partial z_j^l}$ is a function of the partial derivative of the next layer
$\frac{\partial C}{\partial z_j^{l+1}}$

Backpropogation then proceeds as follows

1. During the forward pass, store the pre-activation $z_j^l$ and activations
   $a_j^l$ for all layers.
2. Calculate $\frac{\partial C}{\partial z_j^L}$:

   $$
       \frac{\partial C}{\partial z_j^L} = \frac{\partial C}{\partial a_j^L}
       \sigma'(z_j^L)
   $$

3. Move backwards through the layers, using the value of $\frac{\partial
   C}{\partial z_j^{l+1}}$ to calculate $\frac{\partial C}{\partial z_j^l}$ for
   each $l \in [L-1, L-2, \ldots, 2, 1]$. This calculation is done through the
   expression:

   $$
        \frac{\partial C}{\partial z_j^l} = \sum_i \frac{\partial C}{\partial z_i^{l+1}} w_{ij}^{l+1} \sigma'(z_j^l)
   $$

   Where the $\sigma'(z_j^l)$ is easily calculated as $z_j^l$ was stored during
   the forward pass and $\sigma'$ can be calculated through a simple
   expression.

4. Using the values for $\frac{\partial C}{\partial z_j^l}$, calculate the
   partial derivative of the cost function with respect to the weights
   ($\frac{\partial C}{\partial w_{jk}^l}$) and biases ($\frac{\partial
   C}{\partial b_j^l}$) in each layer:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial C}{\partial w_{jk}^l}
        &= \frac{\partial C}{\partial z_j^l} a_k^{l-1}\\
    \frac{\partial C}{\partial b_j^l}
        &= \frac{\partial C}{\partial z_j^l} \\
\end{align*}
<!-- prettier-ignore-end -->

5. With the partial derivative of the cost function with respect to the weights
   ($\frac{\partial C}{\partial w_{jk}^l}$) and biases ($\frac{\partial
   C}{\partial b_j^l}$) in each layer, update the respective weights and biases
   according to the learning rate $\eta$:

<!-- prettier-ignore-start -->
\begin{align*}
    w_{jk}^l &\gets w_{jk}^l - \eta \frac{\partial C}{\partial w_{jk}^l} \\
    b_j^l &\gets b_j^l - \eta \frac{\partial C}{\partial b_j^l} \\
\end{align*}
<!-- prettier-ignore-end -->

This completes one iteration of the gradient descent algorithm. Multiple
iterations over a large dataset of observations are required in practice for an
ANN to accurately match some target function.

#### Some observations

\marginpar{TODO writeup about vanishing gradient}
\marginpar{TODO writeup about saturation}

The above equations provide some insight into how an ANN learns, and what might
be detrimental to it's learning. Specifically, note that the rate of
change of the cost function with respect to any given weight ($\frac{\partial
C}{\partial w_{jk}^l}$) is dependant on the activation of the neuron in the
previous layer:

$$
    \frac{\partial C}{\partial w_{jk}^l} = \frac{\partial C}{\partial z_j^l}
    a_k^{l-1}
$$

This means that if a neuron's activations are close to zero, then the gradient
(and therefore the update applied to the weight) will also be close to zero,
implying that the weights will be updated less and that the neural network will
learn less. This phenomena is called the vanishing gradient problem. This
problem will propagate forwards through a network, so it initially caused
problems for "deep" neural networks with many layers.

Similarly, the equation for \marginpar{TODO}.

### Cross entropy loss

For multi-class classification problems such as _Ergo_, categorical
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

\marginpar{rewrite}

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

\marginpar{rewrite}

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

\marginpar{rewrite}

The hardware that allows _Ergo_ to sense the user's hand movements is made up
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

\marginpar{rewrite}

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

\marginpar{rewrite}

Autocorrect is a tool used when the nature of the interface means that small
user errors are common. This is ideal for _Ergo_, as new users may not be
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

This error correction method was implemented in _Ergo_ so that the user is able
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
