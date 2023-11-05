This chapter describes various concepts which _Ergo_ utilizes. The relevant
background information includes different machine learning methods and autocorrect
techniques.

Artificial Neural Networks (ANNs) have shown a lot of promise in a wide range
of classification problems and are discussed in Section
\ref{artificial-neural-networks}.

Hidden Markov Models have historically been used for problems similar to those
which _Ergo_ seeks to solve, and thus they will be used to provide a comparison
between candidate models and the prior work. They are discussed in Section
\ref{hidden-markov-models}.

CuSum is a simple statistical technique used for online change detection in the
distribution of a time series. It will be used as a baseline against which
other models can be compared, and is discussed in Section \ref{cusum}.

Autocorrect is a valuable aid to users operating a virtual keyboard where
mistakes are common due to the nature of the interface, and so it is integrated
into _Ergo_. Autocorrect methods are discussed in Section \ref{autocorrect}

# Artificial Neural Networks \label{sec:02_ffnn}

Artificial Neural Networks (ANNs) are a form of machine learning that started
with the development of the perceptron [@Rosenblatt1963PRINCIPLESON], which
itself was inspired by work done by @McCulloch2021ALC.

This section will first describe the perceptron in subsection
\ref{perceptrons}. Then neural networks will be covered in subsection
\ref{neural-networks}. A mathematical description of how the weights and biases
are tuned via gradient descent is given in subsection \ref{gradient-descent}.
The method by which backpropogation allows for the efficient calculation of the
gradients within a neural network is described in subsection
\ref{backpropogation}, and some details about the loss function used for
multi-class classification problems, cross entropy loss, are described in
subsection \ref{cross-entropy-loss}.

## Perceptrons

A perceptron takes in a finite-dimensional vector of real-valued inputs,
applies some function, and produces a single real-valued output. Rosenblatt
proposed a weighting system that was used to compute the output, whereby each
of the input values $x_0, x_1, \ldots, x_n$ is multiplied by a corresponding
weight $w_0, w_1, \ldots, w_n$ and the results are summed together.

$$
    \text{output} = \sum_{i=1}^N x_i \times w_i
$$

Rosenblatt originally required the inputs and the output to be binary, which
implies that the output would be 1 if and only if the sum of the weighted
inputs passed some threshold value:

$$
    \text{output} = \begin{cases}
        0 & \text{if}\ \sum_i w_i x_i \le \text{threshold} \\
        1 & \text{if}\ \sum_i w_i x_i > \text{threshold} \\
    \end{cases}
$$

Modern implementations of a perceptron have changed many aspects of
Rosenblatt's initial description. The threshold was replaced with the
combination of a scalar bias $b$ term and a comparison with zero:

$$
    \text{output} = \begin{cases}
        0 & \text{if}\ b + \sum_i w_i x_i \le 0 \\
        1 & \text{if}\ b + \sum_i w_i x_i > 0 \\
    \end{cases}
$$

Instead of a comparison to zero and restricting the output to a binary 1 or 0,
a scaling function $\sigma: \mathbb{R} \to (0, 1)$ is used which restricts the
range of the output:

$$
    \text{output} = \sigma \left( \ b + \sum_i w_i x_i \right)
$$

This function is called the activation function, and there have been several
different functions mapping to several different domains have been proposed.
The first was the sigmoid (or logistic) activation function (see Figure
\ref{fig:02_sigmoid}):

<!-- prettier-ignore-start -->
\begin{figure}[!htb]
\centering
\begin{tikzpicture}
    \begin{axis}[
        title = {Sigmoid function $\sigma(x) = \frac{1}{1 + e^{-x}}$},
        axis on top = true,
        axis x line = bottom,
        axis y line = left,
        grid = major,
        xlabel = $x$,
        ylabel = $\sigma(x)$
    ]
        \addplot[
            blue,
            domain = -10:10,
            samples = 100
        ]
            {1/(1+exp(-x))};
    \end{axis}
\end{tikzpicture}
\caption{The sigmoid activation function.}
\label{fig:02_sigmoid}
\end{figure}
<!-- prettier-ignore-end -->

$$
    \sigma(x) = \frac{1}{1 + e^{-x}}
$$

The sigmoid activation function can easily be differentiated, a property that
will become useful when discussing backpropogation in subsection
\ref{backpropogation}.

## Neural Networks

Individual perceptrons can be combined to form a network of perceptrons where
the outputs of some perceptrons become the inputs for other perceptrons (see
Figure \ref{fig:02_nn}).

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

These perceptrons (or "neurons", as they are often
called in this context) are arranged in layers in a directed acyclic graph,
where every output from the neurons in layer $i$ is passed as an input to every
neuron in layer $i+1$. The first layer is called the input layer, and those
neurons simply output the data being modelled. There is one neuron for each
dimension of the input data.

The last layer is called the output layer, and a different activation is
sometimes applied to this layer (depending on the problem being solved). The
intermediate layers between the input and the output are collectively called
the hidden layers.

## Gradient descent

Given a neural network with the correct number of input, hidden, and output
neurons for a problem, how does one find the correct values for the many
weights and biases, such that the network's output $\hat{\bm{y}}$ matches the
expected output $\bm{y}$? Gradient descent solves this question by efficiently
calculating how to change the weights and biases so as to decrease the
difference between $\hat{\bm{y}}$ and $\bm{y}$.

To achieve this, a cost function is defined that gradient descent will minimise:

$$
    C(w, b) = \frac{1}{2n} \sum_x || \bm{y} - \hat{\bm{y}}(w, b, x) ||^2
$$

Where $w$ are the weights of the network, $b$ the biases, $x$ the input data,
and $n$ the number of observations. This particular cost function is known as
the mean squared error, although other cost functions can be used.

Gradient descent can be intuitively understood as evaluating $C(w, b)$ at some
initial $(w, b)$ and then calculating the derivative of $C(w,b)$ at that point.
The derivative will provide information about how to apply a small nudge to
$(w, b)$ so that $C(w, b)$ will decrease. Iteratively applying this approach
will cause the cost function to decrease to a local minimum. There is no
guarantee that gradient descent will find a global minimum.

To control the amount by which we nudge the weights and biases, we define the
_learning rate_ to be a scalar hyperparameter $\eta$. Larger learning rates
will often take fewer iterations to convert (when compared to smaller learning
rates) however a learning rate that is too large will not converge at all. The
optimal learning rate is problem dependant.

Let the weight from the $k$th neuron in the $(l-1)$th layer to the $j$th neuron
in the $l$th layer be referred to as $w_{jk}^l$ and similarly let the bias on
the $j$th neuron in the $l$th layer be $b_j^l$. In order to decrease the cost
function, we will take some step from our starting "location" $(w_{jk}^{l},
b_j^l)$ in the direction of the negative gradient, with the step size
proportional to the magnitude of the learning rate $\eta$

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

Gradient descent can be made more efficient via Stochastic Gradient Descent
(SGD), which batches the data into subsets and only changes the weights and
biases based on the average gradient over the observations in each batch.

Optimisation algorithms other than SGD are more commonly used in practical
machine learning: AdaGrad [@Duchi2011AdaptiveSM] is performant on sparse
gradients, RMSProp [@RMSProp] works well in non-stationary settings, and Adam
[@Kingma2014AdamAM] provides good performance with little tuning.

## Backpropogation

Backpropogation is the process of efficiently calculating the gradient of the
cost function $C(w, b)$ with respect to any weight or bias in the network. It
derives from the method of reverse mode automatic differentiation for networks
of differentiable functions introduced by @Leppo1970 and was popularised for
deep learning applications bby @Rumelhart1986LearningRB.

For notation, $a_j^l$ will refer to the output of the $j$th neuron in the $l$th
layer, and $L$ be the last layer of the network, such that $a^L$ is the output
of the network. The process of forward propagating values through the network
can be seen as applying a function on the outputs of the previous layer's
neuron like so:

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

### The vanishing gradient problem

The above equations provide some insight into how an ANN learns. Specifically,
note that the rate of change of the cost function with respect to any given
weight ($\frac{\partial C}{\partial w_{jk}^l}$) is dependant on the activation
of the neuron in the previous layer:

$$
    \frac{\partial C}{\partial w_{jk}^l} = \frac{\partial C}{\partial z_j^l}
    a_k^{l-1}
$$

This means that if a neuron's activation $a_k^{l-1}$ is close to zero, then the
gradient $\frac{\partial C}{\partial w_{jk}^l}$ will also be close to zero. In
turn, the gradient $\frac{\partial C}{\partial w_{jk}^l}$ directly affects how
quickly the ANN updates its weights through the update equation:

$$
    w_{jk}^l \gets w_{jk}^l - \eta \frac{\partial C}{\partial w_{jk}^l}
$$

So a neuron with low activation in layer $l-1$ will result in all weights in
the next layer $l$ being updated by some very small amount. This decreases how
quickly the ANN can learn since the weights are only being updated by some
small amount. This effect is called the vanishing gradient problem, and was
first identified by @Hochreiter2001GradientFI.

There have been multiple proposed solutions to the vanishing gradient problem,
such as using a different activation function like ReLU
[@Hahnloser2000DigitalSA] or re-centering and re-scaling each layer's inputs
through a process called Batch Normalization [@Ioffe2015BatchNA].

## Cross entropy loss

For multi-class classification problems such as _Ergo_, categorical
cross-entropy is commonly used as the loss function [@Neal2007PatternRA]:

$$
    H(p, q) = - \sum_i p_i \log q_i
$$

Intuitively, categorical cross-entropy compares the expected discrete
probability distribution $p$ to a predicted discrete probability distribution
$q$. The distributions are compared element-wise, and instances where the
elements are not identical are penalised with a higher loss. These elements are
summed together to get the total loss.

Calculating whether or not the elements are identical is done via the
expression $- p_i \log q_i$ which encodes the idea that if the true class is 1,
then the loss is the log of the predicted label for that class.

If the predicted label is close to 1, then the log of that predicted label
will be close to 0 and thus the loss will be close to 0. However, if the
predicted label is close to 0 then the log of that predicted label will
approach negative infinity and thus the loss will be close to positive
infinity.

Note that if the true class is 0, the loss is zero.

# Hidden Markov Models \label{sec:02_hmm}

Hidden Markov Models (HMMs) are a form of machine learning often used to model
a series of observations over time. HMMs were initially proposed by
@Baum1966HMMs in a series of statistical papers with other authors in the late
1960s. In the late 1980s, they became commonplace for sequence analysis
[@Bishop1986MaximumLA], specifically in the field of bioinformatics
[@Durbin1998BiologicalSA].

Markov Models provide a formalism for reasoning about states and state
transitions over time. HMMs then expand on Markov Models so that they can be
applied to the common and general problem of extracting a sequence of unseen
(hence "hidden") states given a sequence of seen observations, where the
distribution of each observation is dependant on the unseen state of the model.

First Markov Models will be discussed in section \ref{markov-models} to provide
a foundation, and then HMMs will be discussed in section
\ref{introduction-to-hmms}.

## Markov Models

Many problems can be simplified to a sequence of events happening over time.
Let us simplify further, and require that

1. Time occurs in discrete timesteps $t \in \{1, 2, 3, \ldots\}$.
2. The events are discrete and taken from a set of possible states $S = \{s_1,
   s_2, \ldots, s_{|S|}\}$.
3. Only one event (notated as $z_t$) can happen at each timestep.

We then have a sequence of events $\{z_1, z_2, z_3, \ldots\}$ where each $z_t
\in S$ describes what happened at timestep $t$. As it stands, the state at a
point in time could be the result of any number of variables, including all
prior states of the system $z_1, z_2, \ldots, z_{t-1}$. We will impose two
assumptions which will allow us to reason mathematically about our model.

1. The _Limited Horizon Assumption_ is that the state of the system at time $t$
   depends only on the state of the system at time $t-1$. Formally, the
   probability of being in some state $z_t$ at timestep $t$ given information
   about all previous timesteps $z_{t-1}, z_{t-2}, \ldots, z_1$ is equal to
   the probability of being in some state $z_t$ at timestep $t$ given
   information about only the most recent timestep $z_{t-1}$:

   $$
       \pr(z_t | z_{t-1}, z_{t-2}, \ldots, z_1) = \pr(z_t | z_{t-1})
   $$

2. The _Stationary Process Assumption_ is that the probabilities for our model
   don't change over time. We can assume that the start, middle, and end of our
   time series has the same underlying probability distribution, and that
   nothing about these probabilities change from timestep to timestep:
   $$
        \pr (z_t|z_{t-1}) = \pr (z_s|z_{s-1}); \quad t,s \in 2, 3, \ldots, T
   $$

By convention, it is also common to assume there is some initial state $s_0$ and some
initial observation $z_0$ which takes on the initial state with probability 1:
$\pr(z_0 = s_0) = 1$.

This convention allows the encoding of a prior probability for as the
probability distribution of $z_1$ given the initial observation $z_0$: $\pr(z_1
| z_0)$.

Now that we have the assumptions and conventions in place, we need some way to
represent how the model can transition from one state to the next. Our
assumptions allow us to encode this as a state transition matrix $A \in
\mathbb{R}^{(|S| + 1) \times (|S| + 1)}$ where the rows of $A$ represent the
state we transition from and the columns of $A$ represent the state we
transition to. For example, the scalar value $A_{ij}$ is the probability that
we transition from state $i$ to state $j$.

Note that because of the stationary process assumption, $A_{ij}$ is the same
for the first time step as it is for any other time step.

A completely hypothetical transition matrix describing an undergraduate's
understanding of x86 Assembly might look like:

$$
    A = \begin{matrix}
                            & s_0  & s_{\text{No knowledge}} & s_{\text{Fear}} & s_{\text{Competence}} &  s_{\text{Mastery}} \\
    s_0                     & 0.00 & 0.99                    & 0.01            & 0.00                  & 0.00                \\
    s_{\text{No knowledge}} & 0.00 & 0.80                    & 0.15            & 0.05                  & 0.00                \\
    s_{\text{Fear}}         & 0.00 & 0.00                    & 0.80            & 0.20                  & 0.00                \\
    s_{\text{Competence}}   & 0.00 & 0.00                    & 0.40            & 0.55                  & 0.05                \\
    s_{\text{Mastery}}      & 0.00 & 0.00                    & 0.10            & 0.25                  & 0.65                \\
    \end{matrix}
$$

Where we can see that undergraduates typically start out in the state of No
knowledge (with probability 99%) but a few of them start out in the state of
Fear (with probability 1%). The only way to transition into the state of
Mastery is from either the state of Competence (at 5% probability) or by having
already been in the state of Mastery (65% probability). Once they have
transitioned out of the state of No knowledge, there is no way to go back to
the state of No knowledge (as represented by the 0.00s in the No knowledge
column).

### From transition matrix to state sequence

Given a transition matrix $A$ and a Markov Model, one might ask what the
probability of a specific sequence of states is. We will prove that it is
simply the product of the corresponding probabilities in the transition matrix
$A$.

Given a series of states $z_1, z_2, \ldots z_t$ we can calculate it's
probability through the chain rule of probability which states that the
probability of two events is the same as the product of the probability of each
event if and only if the two events are independent:

$$
    \pr(A \cap B) = \pr (A) \cdot \pr(B) \iff A \indep B
$$

From this, we write a statement for the probability of every $z_t, z_{t-1},
\ldots, z_1$ occurring given some transition matrix $A$:

<!-- prettier-ignore-start -->
\begin{align*}
    \pr (z_t \cap z_{t-1} \cap \ldots \cap z_1 | A)
    &= \pr (z_t \cap z_{t-1} \cap \ldots \cap z_1 \cap z_0 | A) \\
\intertext{Expand out the union of events}
    &= \pr (z_t | z_{t-1} \cap \ldots \cap z_0 \cap A)
        \cdot \pr (z_{t-1} | z_{t-2} \cap \ldots \cap z_0 \cap A)
        \cdot \ldots
        \cdot \pr (z_1 | z_0 \cap A) \\
\intertext{Use the limited horizon assumption}
    &= \pr (z_t | z_{t-1} \cap A)
        \cdot \pr (z_{t-1} | z_{t-2} \cap A)
        \cdot \ldots
        \cdot \pr (z_1 | z_0 \cap A) \\
\intertext{Rewrite using $\prod$-notation}
    &= \prod_{t=1}^{T} \pr (z_t | z_{t-1} \cap A) \\
\intertext{Express the probabilities using the transition matrix $A$}
    &= \prod_{t=1}^{T} A_{z_{t-1}},{z_t} \\
\end{align*}
<!-- prettier-ignore-end -->

Which indicates that the probability of a sequence of states is simply the
product of the transitions between those states.

For example, we can calculate the probability of an undergraduate student
initially not knowing assembly, then being fearful of it,
then being competent, and finally achieving mastery:

<!-- prettier-ignore-start -->
\begin{align*}
    &\pr(s_0 \to s_{\text{No knowledge}} \to s_{\text{Fear}} \to s_{\text{Competence}} \to s_{\text{Mastery}}) \\
    &= 0.99 \times 0.15 \times 0.2 \times 0.05\\
    &= 0.001485 \\
\end{align*}
<!-- prettier-ignore-end -->

Which should approximately align with intuition.

### From state sequence to transition matrix

Another question one might ask of a Markov model is: given a sequence of states
($\bm{z} = \{z_0, z_1, z_2, \ldots, z_t\}$) which we know to have occurred,
what transition matrix $A$ is most likely to have caused them? More precisely,
we would seek to find the parameters $A$ which maximise the log-likelihood of a
given sequence of observations.

Likelihood can be seen as an "inverse" of probability. Probability describes
the chances of some outcome $\bm{z}$ given some known parameters $A$:

$$
    \text{Probability:} \, \pr (\bm{z} | A)
$$

But likelihood describes the chances of some _parameters_ given some known
_outcomes_:

$$
    \text{Likelihood:} \,\pr (A | \bm{z})
$$

Maximum likelihood estimation is then the process of discovering which
parameters $A$ result in the maximal likelihood given some observations
$\bm{z}$.

Practically, it is often more useful to work with the log-likelihood (notated
$l$), and because $\log(x)$ is monotonically increasing, a value which
maximises the log-likelihood will also maximise the likelihood.

We will define the log-likelihood of a Markov model as:

<!-- prettier-ignore-start -->
\begin{align*}
    l(A) &= \log \pr (\bm{z} | A) \\
    l(A) &= \log \pr (z_0, z_1, z_2, \ldots, z_t | A) \\
    &= \log \left( \prod_{t=1}^T A_{z_{t-1},z_t}\right) \\
    &= \sum_{t=1}^T \log  \left( A_{z_{t-1},z_t} \right)\\
    &= \sum_{i=1}^{|S|} \sum_{j=1}^{|S|} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \log  \left( A_{ij} \right)\\
\end{align*}
<!-- prettier-ignore-end -->

Where $[z_{t-1} = s_i \wedge z_t = s_j]$ is Iverson notation
[@Knuth1992TwoNO] defined as:

$$
    [\text{condition}] = \begin{cases}
        1 & \text{if condition is true}\\
        0 & \text{if condition is false}\\
    \end{cases}
$$

When solving this optimisation problem, we need to enforce that $A$ is still a
valid transition matrix (which requires that all elements are non-negative and
the rows all sum to 1). This can be done with the method of Lagrange
multipliers. We will define the problem to be:

<!-- prettier-ignore-start -->
\begin{align*}
     \max_A l(A) \quad & \\
    \text{such that:}\quad & \sum_{j=1}^{|S|} A_{ij} = 1,\quad i \in \{1,2, \ldots |S|\}\\
    & A_{ij} \ge 0,\quad i,j \in \{1,2, \ldots |S|\}\\
\end{align*}
<!-- prettier-ignore-end -->

We will introduce the equality constraint into the Lagrangian, but we will
prove that the optimal solution can only produce positive values for $A_{ij}$
and so there is no need to explicitly introduce the inequality constraint.

The Lagrangian can therefore be constructed as:

$$
    \mathcal{L}(A, \alpha) =
        \sum_{i=1}^{|S|} \sum_{j=1}^{|S|} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \log  \left( A_{ij} \right)
        + \sum_{i=1}^{|S|} \alpha_i \left( \sum_{j=1}^{|S|} 1 - A_{ij} \right)
$$

Taking the partial derivatives with respect to $A_{ij}$ and setting it equal to
zero, we get:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial \mathcal{L}(A, \alpha)}{\partial A_{ij}}
        &=
        \frac{\partial}{\partial A_{ij}} \left( \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \log  \left( A_{ij} \right) \right)
        + \frac{\partial}{\partial A_{ij}} \alpha_i \left( \sum_{j=1}^{|S|} 1 - A_{ij} \right)\\
     &\Rightarrow\\
      0 &= \frac{1}{A_{ij}} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] - \alpha_i \\
     \alpha_i  &= \frac{1}{A_{ij}} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
     A_{ij}  &= \frac{1}{\alpha_i} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
\end{align*}
<!-- prettier-ignore-end -->

Substituting back in and setting the partial derivative with respect to
$\alpha$ equal to zero:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial \mathcal{L}(A, \beta)}{\partial \alpha_i}
     &= 1 - \sum_{j=1}^{|S|} A_{ij} \\
     &\Rightarrow\\
    0 &= 1 - \sum_{j=1}^{|S|} \frac{1}{\alpha_i} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
    1 &= \frac{1}{\alpha_i} \sum_{j=1}^{|S|}  \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
    \alpha_i &= \sum_{j=1}^{|S|} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
             &= \sum_{t=1}^T [z_{t-1} = s_i] \\
\end{align*}
<!-- prettier-ignore-end -->

When we substitute this expression for $\alpha_i$ into the expression for
$A_{ij}$, we get the maximum likelihood estimate for $A_{ij}$, which we will
term $\hat{A}_{ij}$:

<!-- prettier-ignore-start -->
\begin{align*}
     A_{ij}  &= \frac{1}{\alpha_i} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
    \hat{A}_{ij}  &= \frac{1}{\sum_{t=1}^T [z_{t-1} = s_i]} \sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j] \\
    \hat{A}_{ij}  &= \frac{\sum_{t=1}^T [z_{t-1} = s_i \wedge z_t = s_j]}{\sum_{t=1}^T [z_{t-1} = s_i]}  \\
\end{align*}
<!-- prettier-ignore-end -->

This expression for $\hat{A}_{ij}$ encodes the intuitive explanation that the
maximum likelihood of transitioning from state $i$ to state $j$ is just
fraction of times that we were in state $i$ and then transitioned to state $j$.

$$
    \text{Intuitively: } \quad \hat{A}_{ij}  = \frac{\text{\# $i\to j$}}{\text{\# $\to i$}}
$$

## Introduction to HMMs

With the formalism of Markov models understood, we can motivate _hidden_ markov
models and the additional power they provide.

Regular Markov models have a shortcoming in that they assume we can observe the
state of the world directly. In our undergraduate x86 Assembly example, it is
impossible for us to directly know the exact understanding of an undergraduate
student. We might be able to ask them, or we might be able to have them take a
test or program in assembly and derive some information from the results, but
all of these are indirect measures of the student's understanding. Since these
are indirect, they are very likely to have some amount of error associated with
them. It is cyclical to assume a student could asses their own knowledge of a
topic they don't already know, and no test can perfectly assess a student's
knowledge.

The crux of the idea is not to try figure out exactly how uncertainties are
introduced, but rather realise that they are inevitable. For our example, we
will assume a student takes a test out of 100, and their mark is the value we
observe. We are then interested in trying to estimate the understanding of the
student ($s_{\text{No knowledge}}, s_{\text{Fear}}, s_{\text{Competence}},
s_{\text{Mastery}}$).

Markov models cannot help us here, but Hidden Markov models give us the tools
to express the test mark as coming from a different probability distribution
for each state the student is in. If we knew (for example) that the average
mark achieved by students in the Mastery state was 65% and the average mark
achieved by students in the Competence state was 30%, and we then observed a
student with a mark of 70%, then we can be fairly certain they are in the
Mastery state.

We will express this mathematically by defining an HMM as a Markov model for
which there are a series of observed outputs $\bm{x} = \{x_1, x_2, \ldots,
x_T\}$. Each output $x_i$ is drawn from an output alphabet $V = \{v_1, v_2,
\ldots, v_{|V|}\}$ such that $x_t \in V, t \in \{1, 2, \ldots, T\}$.

As for Markov models, we will define a series of hidden states that the model
takes on $\bm{z} = \{z_1, z_2, \ldots, z_T\}$ which we have no way of observing
but which will provide a useful construct for reasoning about this model. Each
of these states which the model occupies is drawn from a state alphabet $S =
\{s_1, s_2, \ldots, s_{|S|}\}$ such that $z_t \in S, t \in \{1, 2, \ldots,
T\}$. We will again use $A$ as the transition matrix defining the probability
of transitioning from one hidden state to another.

In addition to the above, we will allow the output observations $\bm{x}$ to be
a function of our hidden state $\bm{z}$. For this, we make another assumption:

- _Output independance assumption_: The probability of outputting a value $x_t$
  at time $t$ is dependant only on the hidden state of the model $z_t$ at time
  $t$:

  $$
      \pr(x_t = v_k | z_t = s_j) = \pr(x_t = v_k | x_1, \ldots, x_T, z_1, \ldots, z_t)
  $$

  We will use a new matrix, $B_{jk}$ to represent the probability of the hidden
  state generating some output observation $v_k$ given that the hidden state
  was $s_j$. Therefore $B_{jk} = \pr(x_t = v_k | z_t = s_j)$ (or equivalently,
  $B_{a, b} = \pr(b | a)$ given that $b$ is some output value and $a$ is some
  hidden state).

### What's the probability of observing a certain sequence?

One natural question to ask, given an HMM, is what is the probability that a
certain sequence of observations was emitted by that HMM. If we assume there
exists some series of hidden states $\bm{z}$ and that at each time step $t$ we
select an output $x_t$ which is a function of the state $z_t$: $x_t = f(z_t)$
where $f$ is unknown.

If we want to know the probability of a sequence of observations $x_1, x_2,
\ldots, x_T$ then we will need to sum the likelihood of the data given every
possible series of states $\bm{z}$:

<!-- prettier-ignore-start -->
\begin{align*}
    \pr(\bm{x} | A \cap B)
        &= \sum_{\forall\bm{z}} \pr (\bm{x} \cap \bm{z} | A \cap B) && \text{(Condition over all $\bm{z}$)} \\
        &= \sum_{\forall\bm{z}} \pr (\bm{x} | \bm{z} \cap A \cap B) \pr (\bm{z} | A \cap B) &&\text{(Bayes' Rule)} \\
        &= \sum_{\forall\bm{z}}
            \left( \prod_{t=1}^T \pr (x_t | z_t \cap B) \right)
            \left( \prod_{t=1}^T \pr (z_t | z_{t-1} \cap A) \right) \\
        &= \sum_{\forall\bm{z}}
            \left( \prod_{t=1}^T B_{z_t, x_t} \right)
            \left( \prod_{t=1}^T A_{z_{t-1}, z_t} \right) &&\text{(Defn. of $A$ and $B$)}\\
\end{align*}
<!-- prettier-ignore-end -->

This provides us with a simple expression of the probability we want
$\pr(\bm{x} | A \cap B)$, but this simple expression is intractable to
calculate. It requires a sum over every possible sequence of states, which
means that $z_t$ can take on any one of the $|S|$ states for each timestep $t$.
This means that the calculation will require $O(|S|^T)$ operations.

Luckily, there exists a dynamic programming means of computing the probability,
called the _Forward Procedure_. First we define an intermediate quantity
$\alpha_i(t)$ to represent the probability firstly of all the observations
$x_i$ up until time $t$ and secondly that the HMM is in some specific state
$s_i$ at time $t$:

$$
    \alpha_i(t) := \pr(x_1 \cap x_2 \cap \ldots \cap x_t \cap z_t = s_i | A \cap B)
$$

If we has this quantity, we could express the probability of a certain sequence
of observations $\bm{x}$ much more succinctly as:

<!-- prettier-ignore-start -->
\begin{align*}
    \pr(\bm{x} | A \cap B)
    &= \pr(x_1 \cap x_2 \cap \ldots \cap x_T | A \cap B) \\
    &= \sum_{i=1}^{|S|} \pr(x_1 \cap x_2 \cap \ldots \cap x_t \cap z_t = s_i | A \cap B) \\
    &= \sum_{i=1}^{|S|} \alpha_i(T) \\
\end{align*}
<!-- prettier-ignore-end -->

The _Forward Procedure_ presents an efficient method of computing
$\alpha_i(t)$, which requires only $O(|S|)$ operations at each timestep,
resulting in a complexity of $O(|S| \cdot T)$ instead of $O(|S|^T)$. This
procedure recursive and is given in Algorithm \ref{alg:alphai}.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{Computing $\alpha_i(t)$ efficiently with the forward procedure}
\label{alg:alphai}
\begin{algorithmic}[1]
    \State \textbf{Base case:} $\alpha_i(0) = A_{0i}$
    \State \textbf{Recursive Case:} $\alpha_i(t) = B_{i,x_t} \sum_{j=1}^{|S|} \alpha_j(t - 1) A_{j,i}$
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

The backwards procedure can be used to efficiently calculate the probability of
a sequence $x_{t+1}, \ldots, x_T$ given the initial state and a HMM:
$\beta_i(t)$. This procedure is very similar to the forward procedure and is
given in Algorithm \ref{alg:betai}.

<!-- prettier-ignore-start -->
\begin{algorithm}
\caption{Computing $\beta_i(t)$ efficiently with the backward procedure}
\label{alg:betai}
\begin{algorithmic}[1]
    \State \textbf{Base case:} $\beta_i(T) = 1$
    \State \textbf{Recursive Case:} $\beta_i(t) = \sum^{|S|}_{j=1} \beta_j(t+1) A_{i,j} B_{j,x_{t+1}}$
\end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

### The Viterbi algorithm: What's the most likely series of states for some output?

If we observed a series of outputs from a HMM $x_1, x_2, \ldots, x_T \forall
x_i \in V$, then what is the sequence of hidden states $z_1, z_2, \ldots, z_T
\forall z_i \in S$, which has the highest likelihood? Specifically:

<!-- prettier-ignore-start -->
\begin{align*}
    \argmax_{\bm{z}} \pr(\bm{z} | \bm{x} \cap A \cap B)
    &= \argmax_{\bm{z}} \frac{ \pr(\bm{x} \cap \bm{z} | A \cap B) }{ \sum_{\forall\bm{z}} \pr(\bm{x} \cap \bm{z} | A \cap B) } &&\text{(Bayes' Theorem)} \\
    &= \argmax_{\bm{z}} \pr(\bm{x} \cap \bm{z} | A \cap B)  &&
    \text{(Denominator $\indep \bm{z}$)}\\
\end{align*}
<!-- prettier-ignore-end -->

Here we might again try the naïve approach and evaluate every possible $\bm{z}$
to check which one achieves a maximum. This approach requires $O(|S|^T)$
operations, and so we will be using another dynamic programming approach.

The Viterbi algorithm is very similar to the forward procedure, except that it
tracks the maximum probability of generating the observations seen so far and
records the corresponding state sequence. See the procedure in Algorithm
\ref{alg:viterbi}.

<!-- prettier-ignore-start -->
\begin{algorithm}
  \caption{Viterbi Algorithm}
  \label{alg:viterbi}
  \begin{algorithmic}[1]
    \State \textbf{Input:} Hidden states $S=\{s_0, s_1, \ldots\}$,
    observations, Transition probabilities $A_{i,j}$ from state $i$ to state
    $j$, Emission probabilities $B_{i,j}$ that state $i$ will emit an
    observation $j$.
    \State \textbf{Output:} Most likely sequence of hidden states
    \State \textit{Initialize} the Viterbi table and path table
    \State \textit{Let} $viterbi$ be a 2D array of size $|S| \times num\_observations$
    \State \textit{Let} $path$ be a 2D array of size $|S| \times num\_observations$
    \For{$i$ in $1..|S|$}
        \State $viterbi[i][0] \gets A_{s_0, s_i} \times B_{s_i, \textit{observations[0]}}$
        \State $path[i][0] \gets i$
    \EndFor
    \For{$i$ in $1..$\textit{len(observations)}}
        \For{$j$ in $1..|S|$}
            \State $p_{\text{max}} \gets 0$
            \State $s_{\text{best}} \gets 0$
            \For{$k$ in $1..|S|$}
                \State $p \gets viterbi[k][i-1] \times  A_{s_j, s_i}$
                \If{$p > p_{\text{max}}$}
                    \State $p_{\text{max}} \gets p$
                    \State $s_{\text{best}} \gets k$
                \EndIf
            \EndFor
            \State $viterbi[j][i] \gets p_{\text{max}} \times B_{s_i,
            \textit{observations[i]}}$
            \State $path[j][i] \gets s_{\text{best}}$
        \EndFor
    \EndFor
    \State \textit{Find} final\_state with maximum probability in the last column of the Viterbi table
    \State \textit{Backtrack} from final\_state to construct the most likely sequence
    \Return "Most likely sequence: ", sequence
  \end{algorithmic}
\end{algorithm}
<!-- prettier-ignore-end -->

### Most likely parameters for an HMM

Another question we might ask of our HMM is, given a set of observations, what
values do the transition probabilities $A$ and the emission probabilities $B$
have to take to maximise the likelihood of those observations?

This goal is equivalent to "fitting" or training a neural network so that the
weights and biases minimise the loss function, however the procedure followed
is quite different.

The Baum-Welch algorithm [@Baum1970AMT] is a special case of the
Expectation-Maximisation (EM) algorithm applied to finding the unknown
parameters of an HMM. It consists of three steps which are repeated until a
desired level of convergence is reached such that successive iterations do not
lead to significant changes in the parameters. Note that this algorithm does
not converge to a global maximum, and the performance of the converged
parameters depends on the random initialisation of those parameters.

Recall the following variables:

- $A_{i,j}$ is the transition probability matrix, giving the probability of
  being transitioning from state $i$ to state $j$.
- $B_{j,k}$ is the emission probability matrix, giving the probability of
  emitting some output observation $k$ given that we are in state $j$.
- $x_t$ is the hidden state of the model at time $t$
- $S$ is the set of possible states our model can be in.
- $|S|$ is the total number of possible states.
- $\bm{z}$ is the sequence of states which is known to have occurred.

The **forward procedure** recursively calculates the probability of being in state $i$ at time $t$, $\alpha_i(t)$, and was presented in Algorithm \ref{alg:alphai}.

The **backward procedure** recursively calculates the probability of the rest
of the sequence $z_{t+1}, \ldots, z_T$ given that the HMM is in state $i$ at
time $t$, $\beta_i(t)$, and was presented in Algorithm \ref{alg:betai}.

The **update step** uses the calculated values for $\alpha_i$ and $\beta_i$ to
update the HMM parameters $A$ and $B$.

We will need to calculate some temporary variables:

- $\gamma_i(t)$ is the probability of being in state $i$ at time $t$ given the
  observed sequence $\bm{z}$ and the HMM $(A, B)$

- $\xi_{ij}(t)$ is the probability of being in state $i$ and $j$ at times $t$
  and $t+1$ given the observed sequence $\bm{z}$ and the HMM defined by $A, B$

According to Bayes' theorem:

<!-- prettier-ignore-start -->
\begin{align*}
    \gamma_i(t) &= \pr(x_t = i | \bm{z}, A,B) \\
    &= \frac{ \pr(x_t = i, \bm{z} | A, B)}{ \pr (\bm{z} | A, B)} \\
    &= \frac{\alpha_i(t)\beta_i(t)}{ \sum^N_{j=1} \alpha_i(t)\beta_i(t)} \\
\end{align*}
<!-- prettier-ignore-end -->

And

<!-- prettier-ignore-start -->
\begin{align*}
    \xi_{ij}(t) &= \pr(x_t = i, x_{t+1} = j | \bm{z}, A,B) \\
    &= \frac{\pr(x_t = i, x_{t+1} = j, \bm{z} | A,B)}{\pr(\bm{z} | A,B)} \\
    &= \frac{
        \alpha_i(t) A_{ij} \beta_j(t+1) B_{j,z_{t+1}}
    }{
        \sum_{k=1}^{|S|}
            \sum_{l=1}^{|S|}
                \alpha_k(t) A_{k,l} \beta_l(t+1) B_{l,y_{t+1}}
    } \\
\end{align*}
<!-- prettier-ignore-end -->

We can now update the parameters of the HMM:

- $A_{0i}^* = \gamma_i(1)$
- $A_{ij}^* = \frac{ \sum^{T-1}_{t=1}\xi_{ij}(t) }{ \sum^{T-1}_{t=1}\gamma_i(t) }$ (The expected number of transitions from $i$ to $j$)
- $B_{j,k}^* = \frac{ \sum^T_{t=1} [y_t = k] \gamma_j(t)}{ \sum^T_{t=1}
  \gamma_j(t) }$

The above steps can now be repeated until a convergence within some threshold
is reached.

# Support Vector Machines \label{sec:02_svm}

<!--
Support Vector Machines \label{sec:02_cusum}

High `C` can increase training times: Fan, Rong-En, et al., “LIBLINEAR: A
library for large linear classification.”, Journal of machine learning research
9.Aug (2008): 1871-1874.

LibLinear used for implementation

SKlearn details: https://scikit-learn.org/stable/modules/svm.html

SVMs struggle with large numbers of observations

SVCs use one-vs-rest classification

NOTE: I didn't scale the data... It's recommended to scale the data

Different class weights were attempted
-->

Support Vector Machines (SVMs) are a form of supervised learning that can be
used for classification and regression. As _Ergo_ is a classification problem,
only SVM classifiers will be discussed here. SVMs work well in high dimensions
and perform classifications using a small subset of the training observations,
so are fast and memory efficient. SVMs do not natively support multi-class
classification, however this can be implemented via one-vs-rest classification
which will be discussed in the Methodology chapter, Section
\ref{models-specifics-svm}. The remainder of this section will describe SVMs as
used for binary classification tasks.

SVMs learn to distinguish two classes in a dataset by finding a hyperplane
which will completely separate the two classes. Intuitively, an SVM attempts to
find a hyperplane which splits the dataset, such that 1) the hyperplane
maximises the distance to the nearest observation (regardless of the class of
that observation) and 2) all observations from the same class are on the same
side of the hyperplane. In the case where the data is not linearly separable
and thus no hyperplane exists which can separate the classes, a kernel function
is used to transform the data into a new space in which the classes can be
linearly separated. Kernel functions will be discussed in section \ref{todo}.

Given a dataset with input vectors (features) $x_i$ and corresponding labels
$y_i$, where $y_i$ is either -1 or 1, we want to find a hyperplane represented
by $\bm{w} x + b = 0$. $\bm{w}$ is the weight vector, $x$ is the input
vector, and $b$ is the bias.

Given an observation $x_i$, the sign of $\bm{w} x_i + b$ will indicate which
class it belongs to, according to the SVM classifier.

The _margin_ of a SVM is defined as the distance between the hyperplane and the
nearest data points. In maximising the margin, an SVM is better able to
generalise to unseen data because it creates a better separation between the
classes and a greater chance that an unseen data point will be far from the
hyperplane.

To calculate the value of the margin, recognise first that the margin is equal
to the distance between the two hyperplanes

$$
    \bm{w} x - b = -1 \quad \text{(called the negative hyperplane)}
$$

and

$$
    \bm{w} x - b = +1 \quad \text{(called the negative hyperplane)}
$$

If we define $x_0$ as a point in the negative hyperplane such that

$$
    \bm{w} x_0 - b = -1
$$

then finding the distance between the parallel
hyperplanes is the same as finding the distance between $x_0$ and the positive
hyperplane. We will name this distance $d$.

The unit normal vector of the positive hyperplane is

$$
    \frac{w}{\|w\|}
$$

The point in the positive hyperplane closest to the point $x_0$ can be
calculated as

$$
    x_0 + d \frac{w}{\|w\|}
$$

since $d$ is the distance between the hyperplanes
and $\frac{w}{\|w\|}$ is the direction from the negative hyperplane to the
positive hyperplane.

We then known that this point in the positive hyperplane satisfies the equation

$$
    \bm{w} (x_0 + d \frac{w}{\|w\|}) - b = 1
$$

Expanding and simplifying this equation allows us to calculate the value of $d$
in terms of $\bm{w}$:

<!-- prettier-ignore-start -->
\begin{align*}
     \bm{w} (x_0 + d \frac{\bm{w}}{\|\bm{w}\|}) - b  &= 1 \\
     \bm{w} x_0 - b + d\frac{\bm{ww}}{\|\bm{w}\|}  &= 1 \\
     -1 + d\frac{\|\bm{w}\|^2}{\|\bm{w}\|} &= 1 \\
     -1 + d\|\bm{w}\| - b  &= 1 \\
     -1 &= 1 - d\|\bm{w}\| \\
     d  &= \frac{2}{\|\bm{w}\|}
\end{align*}
<!-- prettier-ignore-end -->

Fitting an SVM is therefore a process of finding $\bm{w}$ and $b$ which
maximise the margin $\frac{2}{\|\bm{w}\|}$, while ensuring that all
observations are correctly classified. This can be expressed as an optimisation
problem like:

$$
    \min_{\bm{w}, b} ||\bm{w}||^2
$$

subject to the constraints

$$
    y_i (\bm{w}^T x_i - b) \ge 1 \quad \forall i \in {1, \ldots, n}.
$$

However, it often is impossible to perfectly separate the two classes, and it
is desirable to allow for some misclassifications in the pursuit of a
separating hyperplane which will generalise better. For these situations, a
soft margin is introduced which shall allow some misclassification.

For each observation $x_i$, a slack variable $\xi_i$ is defined, which is
zero if $x_i$ is correctly classified, greater than 1 if it is misclassified,
and between 0 and 1 if it is correctly classified but is within the SVMs
margin:

$$
    \xi_i = \max(0, 1 - y_i(\bm{w} x_i + b))
$$

The objective function using a soft margin can then be defined with a
regularisation parameter $C$:

<!-- prettier-ignore-start -->
\begin{align*}
    \text{minimize }
        & \frac{1}{2} \|\mathbf{w}\|^2 + C \sum_{i=1}^n \xi_i \\
    \text{subject to }
        &y_i(\mathbf{w}^T x_i + b) \ge 1 - \xi_i \\
    \text{ and } &\, \xi_i \ge 0, \text{ for all } i.
\end{align*}
<!-- prettier-ignore-end -->

<!-- TODO: why is \frac{1}{2} included? -->

$C$ controls the influence misclassifications should have on the hyperplane.
Larger values for $C$ result in less generalisation but fewer
misclassifications. Smaller values for $C$ encourage a wider margin (with more
generalisation) but with more misclassifications.

To solve this constrained optimisation problem, Lagrange multipliers $\alpha_i
\ge 0$ and $\beta_i \ge 0$ are introduced for the constraints
$y_i(\mathbf{w}^T x_i + b) \ge 1 - \xi_i$ and $\xi_i \ge 0$ respectively. The
Lagrangian $\mathcal{L}(\bm{w}, b, \xi, \alpha, \beta)$ is then defined as

<!-- prettier-ignore-start -->
$$
\mathcal{L}(\bm{w}, b, \xi, \alpha, \beta) = \frac{1}{2} \|\bm{w}\|^2
    + C\sum_{i=1}^{n} \xi_i
    - \sum_{i=1}^{n} \alpha_i[y_i(\bm{w} \cdot \bm{x}_i + b) - 1 + \xi_i]
    - \sum_{i=1}^{n} \beta_i \xi_i
$$
<!-- prettier-ignore-end -->

The corresponding set of Karush-Kuhn-Tucker (KKT) conditions are given by

<!-- prettier-ignore-start -->
\begin{align*}
    \alpha_i & \ge 0 \\
    y_i(\bm{w} \cdot \bm{x}_i + b) - 1 + \xi_i & \ge 0 \\
    \alpha_i (y_i (\bm{w} x_i + b) - 1 + \xi_i) & = 0 \\
    \beta_i & \ge 0 \\
    \xi_i & \ge 0 \\
    \beta_i \xi_i & = 0
\end{align*}
<!-- prettier-ignore-end -->

Taking the partial derivative with respect to $\bm{w}$, $b$, and $\xi_i$ and
setting equal to zero, we obtain:

<!-- prettier-ignore-start -->
\begin{align*}
    \frac{\partial \mathcal{L}}{\partial \bm{w}} = 0 \implies &
        \bm{w} = \sum_{i=1}^n \alpha_i y_i x_i \\
    \frac{\partial \mathcal{L}}{\partial b} = 0 \implies &
        0 = \sum_{i=1}^n \alpha_i y_i \\
    \frac{\partial \mathcal{L}}{\partial \xi_i} = 0 \implies &
        \alpha_i = C - \beta_i
\end{align*}
<!-- prettier-ignore-end -->

We can then obtain the dual Lagrangian in the form

$$
    \widetilde{\mathcal{L}}(\bm{\alpha}) = \sum_{i=1}^n \alpha_i
        - \frac{1}{2} \sum_{i=1}^n\sum_{j=1}^n \alpha_i \alpha_j y_i y_j \bm{x}_i^T \bm{x}_j
$$

---

We will use the following definitions: a dataset of $n$ $p$-dimensional
feature-vectors $\bm{x} = x_1, \ldots, x_n$ where $x_i \in \Re^p$, and $n$
corresponding target values $\bm{t} = t_1, \ldots, t_n$ where $t_i \in {-1,
1}$. $y(\bm{x})$ shall be the output of the SVM, and new data points are
classified based on the sign of $y(\bm{x})$. Note that with this formulation, a
correctly classified observation $x_i$ and corresponding label $t_i$ will
satisfy $t_i y(x_i) > 0$

We can define our hyperplane by the set of points such that a weight vector
$\bm{w}$ perpendicular to the hyperplane and a bias $b$:

$$
    \bm{w}^T \bm{x} - b = 0
$$

The decision function for the SVM, $y(\bm{x})$, is then defined as

$$
    y(\bm{x}) = \bm{w}^T\bm{x} + b.
$$

Note that the value $\frac{b}{||\bm{w}||}$ defines the offset of the hyperplane
from the origin, in the direction along the normal vector $\bm{w}$.

## Hard-margin SVMs

If the data is linearly separable, then there exist two parallel hyperplanes
that separate the data and contain no observations between them. The usage of
two parallel hyperplanes (as opposed to one hyperplane which is the maximum
distance from all points and separates the classes) allows the efficacy of an
SVM to be judged based on the distance between the two hyperplanes. The
intuition being that an SVM with hyperplanes that maximally separate the data
will generalise to unseen data better than one which does not.

We can define these two hyperplanes by the equations

$$
    \bm{w}^T \bm{x} - b = +1
$$

and

$$
    \bm{w}^T \bm{x} - b = -1
$$

The margin is then defined as the region bounded by these two hyperplanes, and
the maximum-margin hyperplane is defined as the hyperplane that lies halfway
between them.

To prevent an observation from being inside the margin, we have to require
that for each observation $x_i$ either

$$
    \bm{w}^T x_i - b \ge 1, if t_i = 1
$$

or

$$
    \bm{w}^T x_i - b \le -1, if t_i = -1
$$

which can be simplified as

$$
    t_i (\bm{w}^T x_i - b) \ge 1.
$$

Given these constraints, we can construct the optimisation problem as

$$
    \min_{\bm{w}, b} ||\bm{w}||^2
$$

subject to the constraints

$$
    t_i (\bm{w}^T x_i - b) \ge 1 \quad \forall i \in {1, \ldots, n}.
$$

The values for $\bm{w}$ and $b$ will fully define the SVM, with a
classification of an unseen feature vector $x$ as belonging to either class -1
or class 1 made as:

$$
    \text{sign}(\bm{w}^T x + b).
$$

## Soft-margin SVMs

Hard-margin SVMs have the constraint that the classes be linearly separable.
Soft-margin SVMs remove this constraint by introducing a loss function which
penalises the amount and number of observations which are on the incorrect side
of the decision boundary.

Note that $t_i (\bm{w}^T x_i - b)$ is negative when the observation $x_i$ is
incorrectly classified. The _hinge loss_ function is given by

$$
    \text{loss}(x_i | \bm{w}, b) = \max(0, 1 - t_i (\bm{w}^T x_i - b))
$$

And is therefore zero if the observation in question is correctly classified.
It will be negative if the observation in question is incorrectly classified.

## Solving for the SVM parameters

The method for solving for the parameters $\bm{w}$ and $b$ for a soft-margin
SVM will be discussed here, as a hard-margin SVM is equivalent to a soft-margin
SVM with a sufficiently large regularisation parameter $C$.

We seek to minimise the expression

$$
    \frac{1}{n} \sum_{i=1}^n \max\left(0, 1 - t_i(\bm{w}^T x_i - b)\right)
    + \frac{1}{C} \|\bm{w}\|^2.
$$

To rewrite this in a differentiable form, we introduce a _slack variable_
$\xi_i$ for each observation $x_i$ such that

$$
    \xi_i = \max(0, 1 - t_i (\bm{w}^T x_i - b))
$$

This ensures that $\xi_i$ is the smallest non-negative number such that
$t_i(\bm{w}^T x_i - b) \ge 1 - \xi_i$. The optimisation problem can then be
rewritten as minimising

<!-- prettier-ignore-start -->
\begin{align*}
    \text{minimize }
        &\frac{1}{n} \sum_{i=1}^n \xi_i + \frac{1}{C} \|\mathbf{w}\|^2 \\
    \text{subject to }
        &t_i(\mathbf{w}^T x_i - b) \ge 1 - \xi_i \\
    \text{ and } &\, \xi_i \ge 0, \text{ for all } i.
\end{align*}
<!-- prettier-ignore-end -->

---

The objective of SVMs is to find the hyperplane which maximises the distance to
the nearest observation while minimising the classification error.

We define a _slack variable_ $\xi_i \ge 0$ for each observation $x_i$. $\xi_i$
is zero if the observation is on the correct side of the hyperplane, and is the
perpendicular distance from the observation to the hyperplane otherwise:

$$
    \xi_i = |t_i - y(x_i)|.
$$

When the slack variables are incorporated to the loss function, they allow some
observations to be misclassified if there is an improvement in the decision
boundary.

We therefore seek to minimise the sum of the slack variables (multiplied by
some regularization hyperparameter $C > 0$) and the length of the weights $\bm{w}$

$$
    \frac{1}{2} ||w||^2 + C \sum_{i=1}^n \xi_i.
$$

Note that as $C \to \infty$ the penalisation for misclassifications increases.

The vector $\bm{w}$ then has the same number of elements as an observation
$x_i$. Separating the weights $\bm{w}$ from the bias $b$ allows us to interpret
$\bm{w}$ as a

# Cumulative Sum \label{sec:02_cusum}

Cumulative Sum (CuSUM, @page_continuous_1954) is a sequential method used for
change detection. Given a time series from an initial distribution, it can
alert when the time series deviates from the initial distribution by some
threshold amount.

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

# Autocorrect

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
        \State $\text{deletions} \gets [L + d[1:] \mid L, R \text{ in } \text{splits} \text{ if } R]$
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
