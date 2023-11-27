\epigraph{
    Always remember, however, that there’s usually a simpler and better way to
    do something than the first way that pops into your head.
}{\textit{Donald Knuth}}

This chapter describes the mathematics behind the classification algorithms
used by \emph{Ergo}, as well as providing some background to the problem at
hand.
Section \ref{sec:02-artificial-intelligence-and-machine-learning} provides a
brief history of artificial intelligence, machine learning, and the
nomenclature therein.
Section \ref{sec:02-artificial-neural-networks} discusses Artificial Neural
Networks (ANNs) which have shown a lot of promise in a wide range of
classification problems\footnote{\citealt{zhangRealTimeSurfaceEMG2019,
netoHighLevelProgramming2010, mehdiSignLanguageRecognition2002,
jong-sungkimDynamicGestureRecognition1996,
felsGloveTalkIIaNeuralnetworkInterface1998}}.
Section \ref{sec:02-hidden-markov-models} discusses Hidden Markov Models
(HMMs), which historically have been used for problems similar to those which
_Ergo_ seeks to solve\footnote{\citealt{galkaInertialMotionSensing2016,
bevilacquaContinuousRealtimeGesture2010, xuzhangFrameworkHandGesture2011,
wuGestureRecognition3D2009, zhangHandGestureRecognition2009,
schlomerGestureRecognitionWii2008, mantyjarviEnablingFastEffortless2004,
wengaoChineseSignLanguage2004, rung-hueiliangRealtimeContinuousGesture1998,
liangSignLanguageRecognition1996}}. These are used to provide a
comparison between candidate models and the prior work.
Section \ref{sec:02-support-vector-machines} discusses Support Vector Machines
which have been used with success for gesture recognition in prior
work\footnote{\citealt{leeSmartWearableHand2018,
wuWearableSystemRecognizing2016, wuGestureRecognition3D2009,
kimBichannelSensorFusion2008}}.
Section \ref{sec:02-cumulative-sum} discusses CuSum which is a simple
statistical technique used for online change detection in the distribution of a
time series. It will be used as a baseline against which other models can be
compared.

Section \ref{sec:02-evaluation-metrics} discusses the evaluation metrics by
which multi-class classification algorithms can be compared. Section
\ref{sec:02-binary-and-multi-class-classifiers} discusses the procedure for
converting binary classifiers into multi-class classifiers.

# Artificial Intelligence and Machine Learning \label{sec:02-artificial-intelligence-and-machine-learning}

Artificial Intelligence (AI) refers to the development of non-human systems
that can perform tasks typically requiring human intelligence. These non-human
systems often refer to computer systems, although
\cite{bostromEthicalIssuesAdvanced2003} notes that this is not necessarily
required. \cite{johnmccarthyProposalDartmouthSummer1955} founded the field in 1955
and went through periods of optimism in the capabilities of AI, as well as
subsequent periods of scepticism which are often referred to as the "AI
winters".

The term "Machine learning" was coined by Arthur Samuel
in his 1959 paper studying the popular board game of checkers
\citep{samuelStudiesMachineLearning1959}. The development of deep learning with
AlexNet, described in \citealp{krizhevskyImageNetClassificationDeep2012} renewed interest
in the field. Machine learning has solved many problems once thought
impossible, beating humans at games such as Chess\citep{campbellDeepBlue2002},
Go \citep{silverMasteringGameGo2016}, StarCraft
II\citep{vinyalsGrandmasterLevelStarCraft2019}, and Dota 2
\citep{openaiDotaLargeScale2019}. Additionally, machine learning has
solved or made substantial progress in tasks such as protein folding
\citep{jumperHighlyAccurateProtein2021} and natural language processing
\citep{openaiGPT4TechnicalReport2023}.

A machine learning task can require varying levels of information about what the
"correct" answer is, or how much supervision the machine learning algorithm
gets as it learns from the data. _Supervised_ machine learning is where the
machine learning model is provided with ideal output for a set of inputs and is
required to learn the pattern connecting the inputs to the output.
_Unsupervised_ machine learning is where the model is not provided with any
desired output, but is required to learn the structure of the data. Hybrid
approaches ("semi-supervised") are also possible, which combine elements of
supervised and unsupervised learning.

Many supervised machine learning tasks can be divided into either a regression
or a classification problem. A regression problem requires the estimation of a
function that maps a set of input features $\bm{x}$ to an output value $y$,
where $y\in\mathbb{R}^p, p\in\mathbb{N}$. Classification problems require the
estimation of a function that maps a set of input features $\bm{x}$ to an
output value $y$, where $y$ is an element of some finite set $A$.

# Artificial Neural Networks \label{sec:02-artificial-neural-networks}

Artificial Neural Networks (ANNs) are a form of machine learning built up of
modular components called perceptrons. The development of the perceptron by
\cite{whitePrinciplesNeurodynamicsPerceptrons1963} was inspired by
\cite{warrens.mccullochLogicalCalculusIdeas1944}.

The algorithm for efficiently estimating the parameters of an ANN (named
backpropogation) was derived from the method of reverse mode automatic
differentiation for networks of differentiable functions. This was introduced
by \cite{linnainmaaAlgoritminKumulatiivinenPyoristysvirhe1970}\footnote{This
was later published in English as
\citealt{linnainmaaTaylorExpansionAccumulated1976}}.

Paul Werbos laid the theoretical foundation for backpropagation based on
Linnainmaa's work during Werbos' PhD thesis
\citep{werbosRegressionNewTools1974}, however he experienced repeated
difficulty in actually publishing the work\footnote{As reported in
\citealt{werbosRootsBackpropagationOrdered1994}.} until
\cite{werbosApplicationsAdvancesNonlinear1982}.

\cite{rumelhartLearningRepresentationsBackpropagating1986} later demonstrated
the practical applications of using backpropagation to efficiently train ANNs.
When asked about
\citeauthor{rumelhartLearningRepresentationsBackpropagating1986}'s work, Werbos
reported that he "[was] not accusing anyone of plagiarism"
\citep[p\.251]{rodriguezHistoricalSociologyNeural1991} but nonetheless that he
did "believe that the idea did spread from me to the relevant places".
Rumelhart firmly denied any knowledge of Werbos' work or that it had any
influence on his 1986 paper, and that "As far as I know his work was entirely
hidden, and nobody knew about
it"\citep[p\.252]{rodriguezHistoricalSociologyNeural1991}.

Regardless of the pedigree of backpropogation, its development brought ANNs
from the realm of the theoretical to the land of the practical. Many different
methods of organising ANNs to better solve different problems have been
introduced, such as the Long Short-Term Memory network for sequence learning
(introduced by \citealt{hochreiterLongShortTermMemory1997}) or the
convolutional neural network for image processing (introduced by
\citealt{lecunGradientbasedLearningApplied1998}).

This section on ANNs will first describe the perceptron in subsection
\ref{perceptrons}. Then neural networks will be covered in subsection
\ref{neural-networks}. A mathematical description of how the weights and biases
are tuned via gradient descent is given in subsection \ref{gradient-descent}.
The method by which backpropogation allows for the efficient calculation of the
gradients within a neural network is described in subsection
\ref{backpropogation}, and some details about the loss function used for
multi-class classification problems, cross entropy loss, are described in
subsection \ref{categorical-cross-entropy-loss}. Section \ref{l2-normalisation}
describes the L2 normalisation technique for regularisation of an ANN. Section
\ref{dropout-regularisation} describes dropout regularisation.

## Perceptrons

Artificial Neural Networks are made of perceptrons connected together. A
perceptron accepts a finite-dimensional vector of real-valued inputs, applies
some function, and produces a single real-valued output. To compute the output,
\cite{whitePrinciplesNeurodynamicsPerceptrons1963} proposed a weighting system
whereby each of the input values $x_1, x_2, \ldots, x_n$ is multiplied by a
corresponding weight $w_1, w_2, \ldots, w_n$ and the results are summed
together:

\begin{equation}
    \text{output} = \sum_{i=1}^n x_i w_i.
\end{equation}

Rosenblatt originally required that the inputs and output be either one or
zero, such that the output would be 1 if and only if the sum of the
weighted inputs passed some specified threshold value:

\begin{equation}
    \text{output} = \begin{cases}
        0 & \text{if}\ \sum_i w_i x_i \le \text{threshold} \\
        1 & \text{if}\ \sum_i w_i x_i > \text{threshold} \\
    \end{cases}
\end{equation}

Modern implementations of a perceptron have changed many aspects of
Rosenblatt's initial description. The threshold is replaced with the
combination of a scalar bias $b$ term and a comparison with zero:

\begin{equation}
    \text{output} = \begin{cases}
        0 & \text{if}\ b + \sum_i w_i x_i \le 0 \\
        1 & \text{if}\ b + \sum_i w_i x_i > 0 \\
    \end{cases}
\end{equation}

Additionally, instead of a comparison to zero and restricting the output to a
binary 1 or 0, a scaling or _activation_ function (often denoted as $\sigma$)
is used. The purpose of the activation function is to introduce a non-linearity
such that the sequential combination of multiple perceptrons is not equivalent
to one perceptron with a precisely chosen weights and bias (as would be the
case if all perceptrons applied a linear transformation to their input). The
activation function is applied to the result of the linear transformation like
so:

\begin{equation}
    \text{output} = \sigma \left( \ b + \sum_i w_i x_i \right)
\end{equation}

Several different activation functions (each mapping to different
domains) have been proposed such as \emph{tanh}
\citep{rumelhartLearningRepresentationsBackpropagating1986} and ReLU
\citep{nairRectifiedLinearUnits2010}. The first was the sigmoid activation
function which is derived from the logistic function:

<!-- NOTE graphic of the sigmoid function removed for space constraints
\begin{figure}[!ht]
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

-->

\begin{equation}
    \sigma(x) = \frac{1}{1 + e^{-x}}
\end{equation}

It is simple to calculate the derivative of the sigmoid activation function.
This property will become useful when discussing backpropogation in subsection
\ref{backpropogation}.

## Artificial Neural Networks \label{neural-networks}

When individual perceptrons are combined as the nodes of a directed acyclic
graph, the graph is referred to as an Artificial Neural Network (ANN). In this
ANN, the outputs of some perceptrons are redirected to become the inputs for
other perceptrons. These perceptrons (or "neurons", as they are often called in
this context) are arranged in layers, where every output from the neurons in
layer $i$ is redirected as an input to every neuron in layer $i+1$ (see Figure
\ref{fig:02_nn}). The first layer is called the input layer, and those neurons
simply output the data being modelled, with one neuron for each dimension of
the input data.

\begin{figure}
    \centering
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
    \caption[Example Neural Network Figure]{A neural network with three input
    neurons, five hidden neurons, and two output neurons}
    \label{fig:02_nn}
\end{figure}

The last layer is called the output layer, and a different activation function
is applied to this layer, depending on the problem being solved. The
intermediate layers between the input and the output are collectively called
the hidden layers.

## Gradient Descent

Given an ANN, how does one find the correct weights and biases such that the
network's output $\hat{\bm{y}}$ matches the expected output $\bm{y}$? Gradient
descent solves this question by efficiently calculating how to change the
weights and biases so as to decrease the difference between $\hat{\bm{y}}$ and
$\bm{y}$.

To achieve this, a cost function is defined that gradient descent will
minimise. One possible cost function is the mean squared error:

\begin{equation}
    C(\bm{W}, \bm{b}, \bm{x}) = \frac{1}{2n} \sum_{i=1}^n || \bm{y} - \hat{\bm{y}}(\bm{W}, \bm{b}, x_i) ||^2
\end{equation}

The weights of the network are $\bm{W}$, the biases are $\bm{b}$, the input
data is $\bm{x}$, the output of the ANN is $\hat{\bm{y}}(\bm{W}, \bm{b}, x_i)$,
and the number of observations is $n$.

Gradient descent can be intuitively understood as evaluating $C(\bm{W},
\bm{b})$ at some initial starting set of weights and biases $(\bm{W}, \bm{b})$,
and then calculating the gradient of $C(\bm{W}, \bm{b})$ at that point. The
gradient will provide information about how to slightly change the weights $\bm{W}$
and biases $\bm{b}$ so that $C(\bm{W}, \bm{b})$ will decrease. The direction of
this small change is given by the negative of the gradient. Performing this
operation iteratively will cause the cost function to decrease to a local
minimum. There is no guarantee that gradient descent will find a global
minimum.

Let the weight from the $k$\textsuperscript{th} neuron in the
$(l-1)$\textsuperscript{th} layer to the $j$\textsuperscript{th} neuron in the
$l$\textsuperscript{th} layer be referred to as $w_{jk}^l$ and similarly let
the bias on the $j$\textsuperscript{th} neuron in the $l$\textsuperscript{th}
layer be $b_j^l$. Let $a_j^l$ be the output of the $j$\textsuperscript{th}
neuron in the $l$\textsuperscript{th} layer, and let $L$ be the last layer of
the network, such that $a^L$ is the output of the network.

To control the amount by which we nudge the weights and biases, we define the
_learning rate_ to be a scalar hyperparameter $\eta$. When we slightly change
the weights $\bm{W}$ and biases $\bm{b}$ we will do so by an amount
proportional to $\eta$. Larger learning rates will often take fewer iterations
to convert (when compared to smaller learning rates) however a learning rate
that is too large will not converge at all. The optimal learning rate is
problem dependant.

In order to decrease the cost function, we will take some step from our
starting weight and bias $(w_{jk}^{l}, b_j^l)$ in the direction of the negative
gradient:

\begin{equation}
    w_{jk}^l \gets w_{jk}^l - \eta \frac{\partial C}{\partial w_{jk}^l},
\end{equation}
\begin{equation}
    b_j^l \gets b_j^l - \eta \frac{\partial C}{\partial b_j^l}.
\end{equation}

Note that '$\gets$' is being used to indicate an update to the weight $w_{jk}^l$
or bias $b_j^l$. These equations define the change which would decrease the
cost function, but they rely on knowing the gradient of the cost function with
respect to any weight $w_{jk}^l$ or bias $b_j^l$. The calculation of this
gradient is done by backpropogation, the subject of the next subsection.

Gradient descent can be made more efficient via Stochastic Gradient Descent
(SGD, introduced by \citealt{rosenblattPerceptronProbabilisticModel1958}),
which batches the data into subsets and only changes the weights and biases
based on the average gradient over the observations in each batch. Other
optimisation algorithms have also been suggested and are commonly used: AdaGrad
\citep{duchiOnlineLearningStochastic2011} is performant on sparse gradients,
RMSProp \citep{geoffreyhintonCourseraNeuralNetworks2012} works well in
non-stationary settings, and Adam \citep{kingmaAdamMethodStochastic2014}
provides good performance with little tuning.

## Backpropogation

Backpropogation is the process of efficiently calculating the gradient of the
cost function $C(\bm{W}, \bm{b})$ with respect to any weight or bias in the
network.

The process of propagating values forward through the network can be seen as
the repeated application of a function on the outputs of the previous layer's
neuron, like so:

\begin{equation}
    a^{l}_j = \sigma\left( \sum_k w^{l}_{jk} a^{l-1}_k + b^l_j \right).
\end{equation}

By defining a matrix of weights $\bm{W}^l$, a vector of biases $\bm{b}^l$, and a vector
of activations $\bm{a}^l$, we can rewrite the above equation in matrix notation as

\begin{equation}
    \bm{a}^{l} = \sigma\left( \bm{W}^{l} \bm{a}^{l-1} + \bm{b}^l \right).
\end{equation}

We will also define an intermediate quantity, named the pre-activation, as
$\bm{z}^l = \bm{W}^{l} \bm{a}^{l-1} + \bm{b}^l$.

Using the chain rule, the partial derivative of the cost function with respect
to an arbitrary weight $w_{jk}^l$ is expanded to include $z_j^l$:

\begin{equation}
    \frac{\partial C}{\partial w_{jk}^l} = \frac{\partial C}{\partial z_j^l} \frac{\partial z_j^l}{\partial w_{jk}^l}.
\end{equation}

This can then be rewritten in terms of the activation of the previous layer
$a_k^{l-1}$:

\begin{equation}\label{eqn:dC/dw=dC/dza}
    \frac{\partial C}{\partial w_{jk}^l} =
    \frac{\partial C}{\partial z_j^l}
        \frac{\partial \left(
                w_{jk}^l a_{j}^{l-1} + b_j^l
        \right)}{\partial w_{jk}^l}
    = \frac{\partial C}{\partial z_j^l} a_k^{l-1}.
\end{equation}

The partial derivative of the cost function with respect to an arbitrary bias
is expanded and calculated similarly:

\begin{equation}
    \frac{\partial C}{\partial b_j^l} =
    \frac{\partial C}{\partial z_j^l} \frac{\partial z_j^l}{\partial b_j^l}
    = \frac{\partial C}{\partial z_j^l}
        \frac{\partial \left(
                w_{jk}^l a_{j}^{l-1} + b_j^l
        \right)}{\partial w_{jk}^l}
    = \frac{\partial C}{\partial z_j^l}
\end{equation}

Using the chain rule, the partial derivative $\frac{\partial C}{\partial
z_j^L}$ can be expressed in terms of the partial derivative of the activations
of the last layer and the derivative of the activation function:

\begin{align}
    \frac{\partial C}{\partial z_j^L} = \frac{\partial C}{\partial a_j^L}
    \frac{\partial a_j^L}{\partial z^L_j}
    = \frac{\partial C}{\partial a_j^L}
    \frac{\partial \left( \sigma(z_j^L) \right)}{\partial z^L_j}
    = \frac{\partial C}{\partial a_j^L} \sigma'(z_j^L).
\end{align}

Note that both $\frac{\partial C}{\partial a_j^L}$ and $\sigma'(z_j^L)$ are
easily calculated. $\frac{\partial C}{\partial a_j^L}$ will depend on the cost
function $C$. For the mean squared error cost function, $\frac{\partial
C}{\partial a_j^L}$ is simply $a^L_j - y_j$:

<!-- TODO: Explain why this cost function differs from the previous C(W,b) -->

\begin{align}
    \frac{\partial C}{\partial a_j^L} &= \frac{\partial }{\partial a_j^L}
    \left[ \frac{1}{2} \sum_j ||y_j - a_j^L||^2 \right] = a^L_j - y_j.
\end{align}

$\sigma'(z_j^L)$ is also efficiently calculated, as the activation function
does not change and so its derivative does not change. For the sigmoid
activation function, the derivative is $\sigma(x) (1 - \sigma(x))$:

\begin{align}
\sigma'(x) &= \frac{d}{dx} \left( 1 + \mathrm{e}^{-x} \right)^{-1} \\
    &= \frac{e^{-x}}{\left(1 + e^{-x}\right)^2} \\
    &= \sigma(x) \cdot \frac{(1 + e^{-x}) - 1}{1 + e^{-x}}  \\
    &= \sigma(x) \cdot \left( \frac{1 + e^{-x}}{1 + e^{-x}} - \frac{1}{1 + e^{-x}} \right) \\
    &= \sigma(x) (1 - \sigma(x)).
\end{align}

Since $\sigma'$ is easily calculated and $z_j^L$ does not need to be
recalculated (as it would have already been calculated during the forward pass
through the network), $\sigma'(z_j^L)$ can easily be calculated as well.

Given that we know $\frac{\partial C}{\partial a_j^L} \sigma'(z_j^L)$, we can
calculate the partial derivatives $\frac{\partial C}{\partial z_j^l}$ one at a
time moving backwards through the layers of the network using the following
result:

\begin{align}
    \frac{\partial C}{\partial z_j^l}
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \frac{\partial }{\partial z_j^l} \left[ z_i^{l+1} \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \frac{\partial}{\partial z_j^l} \left[
        \sum_k w_{ik}^{l+1} a_k^l + b_i^{l+1}
        \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \frac{\partial}{\partial z_j^l} \left[
        \sum_k w_{ik}^{l+1} \sigma(z_k^l) + b_i^{l+1}
        \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} \left[
        0 + \ldots + w_{ij}^{l+1} \sigma'(z_j^l) + \ldots + 0
        \right] \\
        &= \sum_i \frac{\partial C}{\partial z_i^{l+1}} w_{ij}^{l+1} \sigma'(z_j^l).
\end{align}

Note that the partial derivative of the sum over $k$ ($\frac{\partial}{\partial
z_j^l} \sum_k$) is all zeros except where $j=k$. This shows that the partial
derivative of each layer $\frac{\partial C}{\partial z_j^l}$ is a function of
the partial derivative of the next layer $\frac{\partial C}{\partial
z_j^{l+1}}$.

Backpropogation then proceeds as follows:

<!-- TODO: Is the forward pass defined anywhere? -->

1. During the forward pass, the pre-activation $z_j^l$ and activations
   $a_j^l$ are stored for all layers.
2. Calculate $\frac{\partial C}{\partial z_j^L}$:

\begin{equation}
    \frac{\partial C}{\partial z_j^L} = \frac{\partial C}{\partial a_j^L} \sigma'(z_j^L).
\end{equation}

3. Move backwards through the layers, use the value of $\frac{\partial
   C}{\partial z_j^{l+1}}$ to calculate $\frac{\partial C}{\partial z_j^l}$ for
   each $l \in [L-1, L-2, \ldots, 2, 1]$. $\frac{\partial C}{\partial z_j^l}$
   is calculated using the expression:

\begin{equation}
    \frac{\partial C}{\partial z_j^l} = \sum_i \frac{\partial C}{\partial z_i^{l+1}} w_{ij}^{l+1} \sigma'(z_j^l)
\end{equation}

   Where the $\sigma'(z_j^l)$ is easily calculated as $z_j^l$ was stored during
   the forward pass and the activation can be chosen such that $\sigma'$ is
   easily obtained.

4. Using the values for $\frac{\partial C}{\partial z_j^l}$, calculate the
   partial derivative of the cost function with respect to the weights
   ($\frac{\partial C}{\partial w_{jk}^l}$) and biases ($\frac{\partial
   C}{\partial b_j^l}$) in each layer:

\begin{align}
    \frac{\partial C}{\partial w_{jk}^l} &= \frac{\partial C}{\partial z_j^l} a_k^{l-1}\\
    \frac{\partial C}{\partial b_j^l} &= \frac{\partial C}{\partial z_j^l}\\
\end{align}

5. Using the partial derivative of the cost function with respect to the weights
   ($\frac{\partial C}{\partial w_{jk}^l}$) and biases ($\frac{\partial
   C}{\partial b_j^l}$) in each layer, update the respective weights and biases
   by an amount proportional to the learning rate $\eta$:

\begin{align}
    w_{jk}^l &\gets w_{jk}^l - \eta \frac{\partial C}{\partial w_{jk}^l} \\
    b_j^l &\gets b_j^l - \eta \frac{\partial C}{\partial b_j^l} \\
\end{align}

This completes one iteration of the backpropogation algorithm. Multiple
iterations over a large dataset of observations are required in practice for an
ANN to approximate some target function.

### The Vanishing Gradient Problem

The above equations provide some insight into how an ANN learns. Specifically,
note that the rate of change of the cost function with respect to any given
weight ($\frac{\partial C}{\partial w_{jk}^l}$) is dependant on the activation
of the neuron in the previous layer, as given by Equation \eqref{eqn:dC/dw=dC/dza}:

\begin{equation}
    \frac{\partial C}{\partial w_{jk}^l} = \frac{\partial C}{\partial z_j^l}
    a_k^{l-1}.
\end{equation}

This means that if a neuron's activation $a_k^{l-1}$ is close to zero, then the
gradient $\frac{\partial C}{\partial w_{jk}^l}$ will also be close to zero. In
turn, the gradient $\frac{\partial C}{\partial w_{jk}^l}$ directly affects how
quickly the ANN updates its weights through the update equation:

\begin{equation}
    w_{jk}^l \gets w_{jk}^l - \eta \frac{\partial C}{\partial w_{jk}^l}
\end{equation}

So a neuron with low activation in layer $l-1$ will result in all weights in
the next layer $l$ being updated by some very small amount. This decreases how
quickly the ANN can learn since the weights are only being updated by some
small amount. This effect is called the vanishing gradient problem, and was
first identified by \cite{hochreiterGradientFlowRecurrent2001}.

There have been several proposed solutions to the vanishing gradient problem.
\cite{nairRectifiedLinearUnits2010} proposes a different activation function
(named ReLU) for this purpose. Different means of initialising the ANN's
weights and biases have also been proposed, such as random initialisation
\citep{glorotUnderstandingDifficultyTraining2010}, Xavier/Glorot initialisation
\citep{glorotUnderstandingDifficultyTraining2010}, and He initialisation
\citep{heDelvingDeepRectifiers2015}. Re-centering and re-scaling each layer's
inputs through a process called batch normalization
\citep{ioffeBatchNormalizationAccelerating2015} has also been proposed.

## Categorical Cross-Entropy Loss

For multi-class classification problems such as _Ergo_, categorical
cross-entropy is commonly used as the loss function
\citep{nealPatternRecognitionMachine2007}:

\begin{equation}
    H(\bm{p}, \bm{q}) = - \sum_{i\in\mathcal{C}} p_i \log q_i
\end{equation}

Where:

- $H(\bm{p}, \bm{q})$ defines the categorical cross entropy loss for one
  observation.
- $\mathcal{C}$ is the set of possible classes, and $|\mathcal{C}|$ the number
  of different classes.
- $\bm{p} \in \{0, 1\}^{|\mathcal{C}|}$ is a one-hot-encoded vector of the
  expected discrete probability distribution such that $\sum_{i\in\mathcal{C}}
  p_i = 1$.
- $\bm{q} \in [0, 1]^{|\mathcal{C}|}$ is a vector of the predicted discrete
  probability distribution such that $\sum_{i\in\mathcal{C}} q_i = 1$.

Intuitively, categorical cross-entropy compares the expected discrete
probability distribution $\bm{p}$ to a predicted discrete probability
distribution $\bm{q}$. The distributions are compared element-wise, and
instances where the elements are not identical are penalised with a higher
loss. These elements are summed together to get the total loss.

Calculating whether or not the elements are identical is done via the
expression $- p_i \log q_i$ which encodes the idea that if the true class is 1,
then the loss is the log of the predicted label for that class.

If the predicted label is close to 1, then the log of that predicted label will
be close to 0 and thus the loss will be close to 0. However, if the predicted
label is close to 0 then the log of that predicted label will approach negative
infinity and thus the loss will be close to positive infinity. Note that if the
$p_i$ is 0, then the prediction $q_i$ contributes nothing to the loss as $-0
\cdot q_i = 0$.

## L2 Normalisation

L2 normalisation is a regularisation technique for ANNs which penalises large
weights and biases, thereby improving the generalisation capabilities of the
ANN. This technique defines an amended cost function $C'$ which is used
instead of the ANN's regular cost function $C$. $C'$ is defined as:

\begin{equation} C'(\bm{W}, \bm{b}, \bm{x}) = C'(\bm{W}, \bm{b}, \bm{x}) + l
\sum_w w^2 + l \sum_b b^2, \end{equation} where $l$ is a hyperparameter that
controls the amount of regularisation to apply to the model. Lower values of
$l$ will result in less regularisation being applied, leading to a model that
is more likely to overfit on the training data and perform worse on unseen
data. Larger values of $l$ result in an ANN with less reliance on any single
neuron. Ensuring that the magnitude of the weights and biases do not become too
large during training also helps with numerical stability.

## Dropout Regularisation

Dropout \citep{srivastavaDropoutSimpleWay2014} is another regularisation
technique used while training an ANN in order to help prevent overfitting.
Dropout will set the activation of a random subset of neurons to zero during
training. The fractions of neurons set to zero is controlled by a
hyperparameter, the dropout rate $r$. Setting randomly selected neurons to zero
prevents the ANN from relying too heavily on specific neurons,
making it more robust to variations in the input data. Dropout can also be
viewed as training a large ensemble of neural networks which all share
different portions of the same set of weights, biases, and architecture.

During training, the neurons whose activations were not dropped out have their
activation scaled up by $\frac{1}{1-r}$ to account for the fact that (on
average) $1-r$ fraction of neurons are active. When the model is performing
inference, no dropout is applied and the output of every neuron is scaled by
$r$ so that the sum of the activations for any given layer remains consistent
between training and inference.

# Hidden Markov Models \label{sec:02-hidden-markov-models}

Hidden Markov Models (HMMs) are a form of machine learning often used to model
a sequence of observations over time. HMMs were initially proposed by
\cite{baumStatisticalInferenceProbabilistic1966} in a series of statistical
papers with other authors in the late 1960s. In the late 1980s, they became
commonplace for sequence analysis \citep{bishopMaximumLikelihoodAlignment1986},
specifically in the field of bioinformatics
\citep{durbinBiologicalSequenceAnalysis1998}.

Markov Models provide a formal structure for reasoning about states and
transitions between those states over time. Hidden Markov Models (HMMs) build
upon Markov Models. They are designed to address the challenge of extracting a
sequence of unseen states, referred to as "hidden", from a sequence of observed
states. In this context, the distribution of each observation is dependent on
the hidden state of the model. HMMs are particularly useful for modelling
systems where the underlying states are not directly observable but can be
inferred from observable outcomes.

First Markov Models will be discussed in subsection \ref{markov-models} to provide
a foundation, and then HMMs will be discussed in subsection
\ref{sec:02-hidden-markov-models}.

## Markov Models

Many problems can be simplified to a sequence of events happening over time.
Let us simplify further, and require that

1. Time occurs in discrete timesteps $t \in \{1, 2, 3, \ldots\}$, and one
   "event" happens at each time step.
2. Events are notated as $z_1, z_2, z_3, \ldots$.
3. Each event is an element from a set of possible states $S = \{s_1, s_2,
   \ldots, s_{|S|}\}$ such that $z_t \in S\,\forall t = 1, 2, 3, \ldots$.

We then have a sequence of events $[z_1, z_2, \ldots]$ where each $z_t \in S$
describes the event that occurred at timestep $t$. We will describe the
probability that a Markov Model takes on state $s_i$ at time $t$ as $\pr(z_t =
s_i)$. As it stands, the event $z_t$ be dependent on any number of variables,
including all prior states of the system $z_{t-1}, \ldots, z_2, z_1$. In order
to more easily reason about our model, we will impose two assumptions about the
system modelled by a Markov Model:

1. The _Limited Horizon Assumption_ is that the state of the system at time $t$
   depends only on the state of the system at time $t-1$. Formally, the
   probability of being in some state $z_t$ at timestep $t$ given information
   about all previous timesteps $z_{t-1}, z_{t-2}, \ldots, z_1$ is equal to
   the probability of being in some state $z_t$ at timestep $t$ given
   information about only the most recent timestep $z_{t-1}$:

\begin{equation}
    \pr(z_t | z_{t-1}, z_{t-2}, \ldots, z_1) = \pr(z_t | z_{t-1})
\end{equation}

2. The _Stationary Process Assumption_ is that the probabilities for our model
   don't change over time. We can assume that the start, middle, and end of our
   time series have the same underlying probability distribution, and that
   nothing about these probabilities change from timestep to timestep:

\begin{equation}
    \pr (z_t|z_{t-1}) = \pr (z_s|z_{s-1}) \quad \forall\,t,s \in 2, 3, \ldots
\end{equation}

It is conventional and convenient to also assume that there is some initial
observation $z_0$ which takes on some initial state $s_0$ with probability 1:
$\pr(z_0 = s_0) = 1$. This convention allows the prior probability of the
initial states of the Markov Model to be expressed as the probability
distribution of $z_1$ given the initial observation $z_0$: $\pr(z_1 | z_0)$.

We now require a means to represent how the Markov Model can transition from
one state to the next. The limited horizon assumption and the stationary
process assumption allow us to encode the transitions between states as a
_state transition matrix_:

\begin{equation}
    \bm{A} \in \mathbb{R}^{(|S| + 1) \times (|S| + 1)}.
\end{equation}

Where:

1. All entries are non-negative: $\bm{A}_{ij} \geq 0 \forall\, i, j$.
2. The sum of each row is equal to 1: $\sum_{j} \bm{A}_{ij} = 1 \forall\, i$.

The rows of $\bm{A}$ represent the state we transition _from_ and the columns
of $\bm{A}$ represent the state we transition _to_. For example, the scalar
value $A_{ij}$ contains the probability of transitioning from state $i$ to
state $j$ at any time step (due to the stationary process assumption). The
matrix has $(|S| + 1)$ and $(|S| + 1)$ rows such that the initial state $s_0$
can be encoded, in addition to the other states $S$ of the Markov Model.

A completely hypothetical transition matrix describing an undergraduate's
understanding of x86 Assembly\footnote{x86 Assembly is a low-level programming
language designed for x86-based processors, and is commonly taught in
undergraduate Computer Science courses.} might look like:

\begin{equation}
    \bm{A} = \begin{matrix}
                            & s_0  & s_{\text{No knowledge}} & s_{\text{Fear}} & s_{\text{Competence}} &  s_{\text{Mastery}} \\
    s_0                     & 0.00 & 0.99                    & 0.01            & 0.00                  & 0.00                \\
    s_{\text{No knowledge}} & 0.00 & 0.80                    & 0.15            & 0.05                  & 0.00                \\
    s_{\text{Fear}}         & 0.00 & 0.00                    & 0.80            & 0.20                  & 0.00                \\
    s_{\text{Competence}}   & 0.00 & 0.00                    & 0.40            & 0.55                  & 0.05                \\
    s_{\text{Mastery}}      & 0.00 & 0.00                    & 0.10            & 0.25                  & 0.65                \\
    \end{matrix}
\end{equation}

As $s_0$ encodes the initial state, we can look at the $s_0$ row to see that
undergraduates typically start out in the state of No knowledge (with
probability 99%) but a few of them start out in the state of Fear (with
probability 1%).

The means by which a student could transition into the state of Mastery can be
seen by looking at the $s_{\text{Mastery}}$ column. They can enter the Mastery
state either by having already been in the state of Mastery (with 65%
probability) or from the state of Competence (with 5% probability). Once they
have transitioned out of the state of No knowledge, there is no way to go back
to the state of No knowledge.

### From transition matrix to state sequence

Given a transition matrix $\bm{A}$ and a Markov Model, one might ask what the
probability of a specific sequence of states is. We will prove that it is
simply the product of the corresponding probabilities in the transition matrix
$\bm{A}$.

We can calculate the probability of a series of states $z_1, z_2, \ldots z_t$
occurring through the chain rule of probability

\begin{equation}
    \pr(X \cap Y) = \pr (Y|X) \cdot \pr(Y),
\end{equation}

Where:

- $\pr(X)$ is the probability that some event $X$ will occur.
- $\pr(X | Y)$ is the conditional probability of $X$ occurring, given that $Y$
  has occurred.
- $X \cap Y$ represents the event where both $X$ and $Y$ occur.

Two events are said to be _independent_ if the probability distribution of the
one is not effected by the probability distribution of the other. The
independence of $X$ and $Y$ is notated as $X \indep Y$. If $X$ and $Y$ are
independent, then the probability of $Y$ does not depend on the probability of
$X$, which means that $\pr(Y|X) = \pr(Y)$. This gives us the definition of
independence of two events from the chain rule of probability:

\begin{equation}
    X \indep Y \iff \pr(X \cap Y) = \pr (X) \cdot \pr(Y).
\end{equation}

From this, we write a statement for the probability of the occurrence of every
$z_t, z_{t-1}, \ldots, z_1$, given some transition matrix $\bm{A}$ and that the
initial state $s_0$ takes on the initial observation $z_0$ with probability 1:

\begin{align}
    &\pr (z_t \cap z_{t-1} \cap \ldots \cap z_1 | \bm{A})
    = \pr (z_t \cap z_{t-1} \cap \ldots \cap z_1 \cap z_0 | \bm{A}) \\
\intertext{Expanding out the union of events using the chain rule of probability:}
    &= \pr (z_t | z_{t-1} \cap \ldots \cap z_0 \cap \bm{A})
        \cdot \pr (z_{t-1} | z_{t-2} \cap \ldots \cap z_0 \cap \bm{A})
        \cdot \ldots
        \cdot \pr (z_1 | z_0 \cap \bm{A}) \\
\intertext{Using the limited horizon assumption}
    &= \pr (z_t | z_{t-1} \cap \bm{A})
        \cdot \pr (z_{t-1} | z_{t-2} \cap \bm{A})
        \cdot \ldots
        \cdot \pr (z_1 | z_0 \cap \bm{A}) \\
\intertext{Rewriting using $\prod$-notation}
    &= \prod_{t=1}^{T} \pr (z_t | z_{t-1} \cap \bm{A}) \\
\intertext{Expressing the probabilities using the transition matrix $\bm{A}$,
recalling that $A_{ij}$ is the probability of a transition from state $i$ to
state $j$}
    &= \prod_{t=1}^{T} A_{z_{t-1} z_t}.
\end{align}
This indicates that the probability of a sequence of states $\pr (z_t \cap
z_{t-1} \cap \ldots \cap z_1 | \bm{A})$ is simply the product of the
transitions between those states $\prod_{t=1}^{T} A_{z_{t-1} z_t}$.

For example, we can calculate the probability of an undergraduate student
initially not knowing x86 Assembly, then being fearful of it, then being
competent, and finally achieving mastery:

\begin{align}
    &\pr(s_0 \to s_{\text{No knowledge}} \to s_{\text{Fear}} \to s_{\text{Competence}} \to s_{\text{Mastery}}) \\
    &= 0.99 \times 0.15 \times 0.2 \times 0.05\\
    &= 0.001485. \\
\end{align}

This result should approximately align with intuition.

### From state sequence to transition matrix

Another question one might ask of a Markov Model is: given a sequence of states
($\bm{z} = \{z_0, z_1, z_2, \ldots, z_t\}$) which we know to have occurred,
what transition matrix $\bm{A}$ is most likely to have caused them? We define
the likelihood function $\mathbb{L}(\bm{A}|\bm{z})$  as the probability of observing
$\bm{z}$ given the parameters $\bm{A}$:

\begin{equation}
    \mathbb{L}(\bm{A}|\bm{z}) := \pr(\bm{z}|\bm{A}).
\end{equation}

We would like to estimate the parameters $\bm{A}$ which maximise the likelihood
of a given sequence of observations $\bm{z}$.

Practically, it is often more convenient to work with the log-likelihood:

\begin{equation}
    l(\bm{A}|\bm{z}) := \log \mathbb{L}(\bm{A}|\bm{z}).
\end{equation}

A value which maximises the log-likelihood will also maximise the likelihood,
as $\log(x)$ is monotonically increasing. We will define the log-likelihood of
a Markov model as:

\begin{align}
    l(\bm{A}|\bm{z}) &= \log \pr (\bm{z} | \bm{A}) \\
    l(\bm{A}|\bm{z}) &= \log \pr (z_0, z_1, z_2, \ldots, z_t | \bm{A}) \\
    &= \log \left( \prod_{t=1}^T A_{z_{t-1} z_t}\right) \\
    &= \sum_{t=1}^T \log  \left( A_{z_{t-1} z_t} \right)\\
    &= \sum_{i=1}^{|S|} \sum_{j=1}^{|S|} \sum_{t=1}^T [(z_{t-1} = s_i) \cap (z_t = s_j)] \log  \left( A_{ij} \right)\\
\end{align}

Where $[z_{t-1} = s_i \cap z_t = s_j]$ is Iverson notation
\citep{knuthTwoNotesNotation1992}, defined as:

\begin{equation*}
    [\text{condition}] = \begin{cases}
        1 & \text{if condition is true}\\
        0 & \text{if condition is false}\\
    \end{cases}
\end{equation*}

When solving this optimisation problem, we need to enforce that $\bm{A}$ is still a
valid transition matrix (which requires that all elements are non-negative and
the rows all sum to 1). This can be done with the method of Lagrange
multipliers. We will define the problem to be:

\begin{align}
     \max_{\bm{A}} l(\bm{A}|\bm{z}) \quad & \\
    \text{such that:}\quad & \sum_{j=1}^{|S|} A_{ij} = 1,\quad i \in \{1,2, \ldots |S|\}\\
    & A_{ij} \ge 0,\quad i,j \in \{1,2, \ldots |S|\}\\
\end{align}

We will introduce the equality constraint into the Lagrangian, but we will
prove that the optimal solution can only produce positive values for $A_{ij}$
and so there is no need to explicitly introduce the inequality constraint.

The Lagrangian can therefore be constructed as:

\begin{equation}
    \mathcal{L}(\bm{A}, \bm{\alpha}) =
        \sum_{i=1}^{|S|} \sum_{j=1}^{|S|} \sum_{t=1}^T [(z_{t-1} = s_i) \cap (z_t = s_j)] \log A_{ij}
        + \sum_{i=1}^{|S|} \alpha_i \left( \sum_{j=1}^{|S|} 1 - A_{ij} \right)
\end{equation}

Taking the partial derivatives with respect to $A_{ij}$ and setting it equal to
zero, we get:

\begin{align}
    \frac{\partial \mathcal{L}(\bm{A}, \bm{\alpha})}{\partial A_{ij}}
        &=
        \frac{\partial}{\partial A_{ij}} \left( \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \log A_{ij} \right)
        + \frac{\partial}{\partial A_{ij}} \alpha_i \left( \sum_{j=1}^{|S|} 1 - A_{ij} \right) \\
      0 &= \frac{1}{A_{ij}} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] - \alpha_i
\end{align}
which implies
\begin{align}
     \alpha_i  &= \frac{1}{A_{ij}} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \\
     A_{ij}  &= \frac{1}{\alpha_i} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j]. \label{eqn:Aij}
\end{align}

Substituting back in and setting the partial derivative with respect to
$\bm{\alpha}$ equal to zero:

\begin{align}
    \frac{\partial \mathcal{L}(\bm{A}, \bm{\alpha})}{\partial \alpha_i}
     &= 1 - \sum_{j=1}^{|S|} A_{ij},
\end{align}
which implies that
\begin{align}
    0 &= 1 - \sum_{j=1}^{|S|} \frac{1}{\alpha_i} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \\
    1 &= \frac{1}{\alpha_i} \sum_{j=1}^{|S|}  \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \\
    \alpha_i &= \sum_{j=1}^{|S|} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \\
             &= \sum_{t=1}^T [z_{t-1} = s_i].
\end{align}

When we substitute the expression for $\alpha_i$ into Equation \eqref{eqn:Aij}
(the expression for $A_{ij}$), we get the maximum likelihood estimate for
$A_{ij}$ which we will term $\hat{A}_{ij}$:

\begin{align}
     A_{ij}  &= \frac{1}{\alpha_i} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \\
    \hat{A}_{ij}  &= \frac{1}{\sum_{t=1}^T [z_{t-1} = s_i]} \sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j] \\
    \hat{A}_{ij}  &= \frac{\sum_{t=1}^T [z_{t-1} = s_i \cap z_t = s_j]}{\sum_{t=1}^T [z_{t-1} = s_i]}. \label{eqn:ahatij}
\end{align}

Equation \eqref{eqn:ahatij} encodes the intuitive explanation that the maximum
likelihood of transitioning from state $i$ to state $j$ is just the fraction of
times that we were in state $i$ and then transitioned to state $j$.

\begin{equation}
    \text{Intuitively: } \quad \hat{A}_{ij}  = \frac{\text{\# $i\to j$}}{\text{\# $\to i$}}
\end{equation}

With #$i\to j$ representing the number of transitions from state $i$ to state
$j$ and #$\to i$ representing the number of transitions from any state to
state $i$.

## Hidden Markov Models\label{sec:02-hidden-markov-models}

With the formalism of Markov Models understood, we can motivate _Hidden_ Markov
Models (HMMs) and the additional power they provide.

Regular Markov Models have a shortcoming in that they assume we can observe the
state of the world directly. In our undergraduate x86 Assembly example, it is
impossible for us to directly know the exact understanding of an undergraduate
student. We might estimate this value (by having them take a test or program in
assembly), but all of these are indirect measures of the student's
understanding. Since these are indirect, they are very likely to have some
amount of error associated with them.

The crux of the idea behind HMMs is not to try to figure out exactly how
uncertainties are introduced, but rather to realise that they are inevitable.
For our example, we will assume a student takes a test out of 100, and their
mark is the value we observe. We are then interested in trying to estimate
which state the student is in: $s_{\text{No knowledge}}, s_{\text{Fear}},
s_{\text{Competence}}$ or $s_{\text{Mastery}}$.

HMMs give us the tools to express the test mark as coming from a probability
distribution that depends on the state the student is in. Because of this
dependence, we can infer the most likely hidden state based on the observed
test mark.

For example, if we knew that the average mark achieved by students in the
Mastery state was 65% and the average mark achieved by students in the
Competence state was 30%, and we then observed a student with a mark of 70%,
then we can be fairly certain they are in the Mastery state. This certainty
will be made rigorous in the coming subsections.

We will express this mathematically by defining an HMM as a Markov model for
which:

- There are a series of observed outputs $\bm{x} = \{x_1, x_2, \ldots, x_T\}$.
- Each output $x_t \forall\, t \in \{1, 2, \ldots, T\}$ is a member of an output
  alphabet $V = \{v_1, v_2, \ldots, v_{|V|}\}$ such that $x_t \in V, t \in \{1,
  2, \ldots, T\}$.
- There is a set of hidden states that the model takes on $\bm{z} = \{z_1, z_2,
  \ldots, z_T\}$ which we have no way of observing.
- Each of these hidden states which the model occupies is drawn from a state
  alphabet $S = \{s_1, s_2, \ldots, s_{|S|}\}$ such that $z_t \in S, t \in \{1,
  2, \ldots, T\}$.

We will again use $\bm{A}$ as the transition matrix defining the probability of
transitioning from one hidden state to another. We will allow the output
observations $\bm{x}$ to be a function of our hidden state $\bm{z}$. For this,
we make another assumption:

- _Output independance assumption_: The probability of outputting a value $x_t$
  at time $t$ is dependant only on the hidden state of the model $z_t$ at time
  $t$:

\begin{equation}
    \pr(x_t = v_k | z_t = s_j) = \pr(x_t = v_k | x_1, \ldots, x_T, z_1, \ldots, z_t)
\end{equation}

We will use a matrix $\bm{B}$ to represent the emission probabilities, where
the element $B_{jk}$ represents the probability of $v_k$ being emitted given
that the model is in state $s_j$.

\begin{equation}
    B_{jk} := \pr(x_t = v_k | z_t = s_j).
\end{equation}

### The probability of observing a certain sequence

We wish to calculate $\pr(\bm{x} | \bm{A} \cap \bm{B})$, the probability that
a certain sequence of observations $\bm{x}$ was emitted by an HMM with matrices
$\bm{A}$ and $\bm{B}$. To do this, we need to sum the likelihoods of the
observed data $\bm{x}$ given every possible series of states $\bm{z}$:

\begin{align}
    \pr(\bm{x} &| \bm{A} \cap \bm{B}) \\
        &= \sum_{\forall\bm{z}} \pr (\bm{x} \cap \bm{z} | \bm{A} \cap \bm{B}) && \text{(Condition over all $\bm{z}$)} \\
        &= \sum_{\forall\bm{z}} \pr (\bm{x} | \bm{z} \cap \bm{A} \cap \bm{B}) \pr (\bm{z} | \bm{A} \cap \bm{B}) &&\text{(Chain rule)} \\
        &= \sum_{\forall\bm{z}}
            \left( \prod_{t=1}^T \pr (x_t | z_t \cap \bm{B}) \right)
            \left( \prod_{t=1}^T \pr (z_t | z_{t-1} \cap \bm{A}) \right) \\
        &= \sum_{\forall\bm{z}}
            \left( \prod_{t=1}^T B_{z_t, x_t} \right)
            \left( \prod_{t=1}^T A_{z_{t-1}, z_t} \right) &&\text{(Defn. of $\bm{A}$ and $\bm{B}$)} \label{eqn:hmm-simple}
\end{align}

Equation \eqref{eqn:hmm-simple} is conceptually simple but intractable to
calculate, as it requires a sum over every possible sequence of states. This
implies that $z_t$ can take on any one of the $|S|$ states for each of the
$|T|$ timesteps, requiring $O(|S|^T)$ operations.

There exists a dynamic programming means of computing the probability, called
the _Forward Procedure_ \citep{rabinerTutorialHiddenMarkov1989}. We define an
intermediate quantity $\alpha_i(t)$ to represent the probability that 1) we
observed all $x_i$ up until time $t$ and 2) that the HMM is in state $s_i$ at
time $t$:

\begin{equation*}
    \alpha_i(t) := \pr(x_1 \cap x_2 \cap \ldots \cap x_t \cap z_t = s_i | \bm{A} \cap \bm{B}).
\end{equation*}

If we knew the value of $\alpha_i(t)$, we could express the probability of a
certain sequence of observations $\bm{x}$ much more succinctly as:

\begin{align}
    \pr(\bm{x} | \bm{A} \cap \bm{B})
    &= \pr(x_1 \cap x_2 \cap \ldots \cap x_T | \bm{A} \cap \bm{B}) \\
    &= \sum_{i=1}^{|S|} \pr(x_1 \cap x_2 \cap \ldots \cap x_T \cap z_T = s_i | \bm{A} \cap \bm{B}) \\
    &= \sum_{i=1}^{|S|} \alpha_i(T)
\end{align}

The _Forward Procedure_ presents an efficient means by which $\alpha_i(t)$ can
be calculated, requiring only $O(|S|)$ operations at each timestep, resulting
in a complexity of $O(|S| \cdot T)$ instead of $O(|S|^T)$. This procedure is
recursive and is given in Algorithm \ref{alg:alphai}.

\begin{algorithm}
\caption{Computing $\alpha_i(t)$ efficiently with the forward procedure}
\label{alg:alphai}
\begin{algorithmic}[1]
    \State \textbf{Base case:} $\alpha_i(0) = A_{0i}$
    \State \textbf{Recursive Case:} $\alpha_i(t) = B_{i,x_t} \sum_{j=1}^{|S|} \alpha_j(t - 1) A_{j,i}$
\end{algorithmic}
\end{algorithm}

The _Backwards Procedure_ can be used to efficiently calculate the probability
of 1) being in a state $s_i$ at time $t$ and 2) the sequence $x_{t+1}, \ldots,
x_T$ given parameters of an HMM $\bm{A}$ and $\bm{B}$, which is defined as:

\begin{equation}
    \beta_i(t) := \pr(x_T \cap x_{T-1} \cap \ldots \cap x_{t+1} \cap z_t = s_i | \bm{A} \cap \bm{B}).
\end{equation}

This procedure is very similar to the forward procedure and is given in
Algorithm \ref{alg:betai}.

\begin{algorithm}
\caption{Computing $\beta_i(t)$ efficiently with the backward procedure}
\label{alg:betai}
\begin{algorithmic}[1]
    \State \textbf{Base case:} $\beta_i(T) = 1$
    \State \textbf{Recursive Case:} $\beta_i(t) = \sum^{|S|}_{j=1} \beta_j(t+1) A_{i j} B_{j x_{t+1}}$
\end{algorithmic}
\end{algorithm}

### Evaluating the most likely series of states for some output: The Viterbi algorithm

If we observed a series of outputs $\bm{x}$ from an HMM with matrices  $\bm{A}$
and $\bm{B}$, what is the sequence of hidden states $\bm{z}$, which would
maximise the likelihood of those outputs? Specifically, we'd like to find:

\begin{align}
    \argmax_{\bm{z}} &\,\pr(\bm{z} | \bm{x} \cap \bm{A} \cap \bm{B}) \\
    &= \argmax_{\bm{z}} \frac{ \pr(\bm{x} \cap \bm{z} | \bm{A} \cap \bm{B}) }{ \sum_{\forall\bm{z}} \pr(\bm{x} \cap \bm{z} | \bm{A} \cap \bm{B}) } &&\text{(Bayes' Theorem)} \\
    &= \argmax_{\bm{z}} \pr(\bm{x} \cap \bm{z} | \bm{A} \cap \bm{B})  &&
    \text{(Denominator $\indep \bm{z}$)}
\end{align}

Here we might again try the naïve approach and evaluate every possible $\bm{z}$
to check which one achieves a maximum. This approach requires $O(|S|^T)$
operations, and so we will be using another dynamic programming approach.

The Viterbi algorithm \citep{viterbiErrorBoundsConvolutional1967} is very
similar to the forward procedure, except that it tracks the maximum probability
of generating the observations seen so far and records the corresponding state
sequence. See the procedure in Algorithm \ref{alg:viterbi}.

\begin{algorithm}
  \caption{Viterbi Algorithm}
  \label{alg:viterbi}
  \begin{algorithmic}[1]
    \State \textbf{Input:} observations $\bm{x}$, states $S$, transition
    probability matrix $\bm{A}$, emission probability matrix $\bm{B}$.
    \State \textbf{Output:} Most likely sequence of hidden states
    \State \textit{Initialize} the Viterbi table and path table
    \State \textit{Let} $viterbi$ be a 2D array of size $|S| \times n$
    \State \textit{Let} $path$ be a 2D array of size $|S| \times n$
    \For{$i$ in $1..|S|$}
        \State $viterbi[i][0] \gets A_{s_0 s_i} \times B_{s_i x_0}$
        \State $path[i][0] \gets i$
    \EndFor
    \For{$i$ in $1..n$}
        \For{$j$ in $1..|S|$}
            \State $p_{\text{max}} \gets 0$
            \State $s_{\text{best}} \gets 0$
            \For{$k$ in $1..|S|$}
                \State $p \gets viterbi[k][i-1] \times  A_{s_j s_i}$
                \If{$p > p_{\text{max}}$}
                    \State $p_{\text{max}} \gets p$
                    \State $s_{\text{best}} \gets k$
                \EndIf
            \EndFor
            \State $viterbi[j][i] \gets p_{\text{max}} \times B_{s_i
            x_i}$
            \State $path[j][i] \gets s_{\text{best}}$
        \EndFor
    \EndFor
    \State Find final\_state with maximum probability in the last column of \textit{viterbi}
    \State Backtrack from final\_state to construct the most likely sequence
    \State \textbf{Return:} the most likely sequence
  \end{algorithmic}
\end{algorithm}

### Most likely parameters for an HMM: The Baum-Welch algorithm

Another question we might ask of our HMM is, given a set of observations
$\bm{x}$, what values do the transition probability matrix $\bm{A}$ and the
emission probability matrix $\bm{B}$ have to take to maximise the likelihood of
those observations? This question is answered by the Baum-Welch algorithm
\citep{baumStatisticalInferenceProbabilistic1966}, which is a special case of
the Expectation-Maximisation (EM) algorithm. The Baum-Welch algorithm consists
of three steps which are repeated until either successive repetitions do not
lead to significant changes in the parameters or the computational budget has
been reached. The Baum-Welch algorithm does not guarantee convergence on a
global maximum, and the performance of the converged parameters depends on the
random initialisation of those parameters.

First, the forward procedure is used to calculate $\alpha_i(t)$, the
probability of being in state $i$ at time $t$. Then the backward procedure is
used to calculate $\beta_i(t)$, the probability of the rest of the sequence
$z_{t+1}, \ldots, z_T$ given that the HMM is in state $i$ at time $t$. The
calculated values for $\alpha_i(t)$ and $\beta_i(t)$ are used to update the HMM
parameters $\bm{A}$ and $\bm{B}$.

To perform this update, we define some temporary variables:

- $\gamma_i(t) := \pr(z_t = s_i | \bm{x} \cap \bm{A} \cap \bm{B})$ is the probability of
  being in state $s_i$ at time $t$ given the observed sequence $\bm{x}$ and a
  HMM with parameters $\bm{A}$ and $\bm{B}$.
- $\xi_{ij}(t) := \pr(z_t = s_i \cap z_{t+1} = s_j | \bm{x} \cap \bm{A}\cap\bm{B})$ is the
  probability of being in state $i$ at time $t$ and state $j$ at time $t+1$
  given the observed sequence $\bm{x}$ and a HMM with parameters $\bm{A}$ and
  $\bm{B}$.

Bayes' theorem can be used to calculate $\gamma_i(t)$ based on $\alpha_i(t)$
and $\beta_i(t)$:

\begin{align} \label{eqn:gamma_it}
    \gamma_i(t) :=& \pr(z_t = s_i | \bm{z} \cap \bm{A} \cap \bm{B}) \\
                =& \frac{\pr(\bm{x} \cap z_t = s_i  | \bm{A} \cap  \bm{B})}{ \pr (\bm{z} | \bm{A} \cap \bm{B})} \\
                =& \frac{
                    \pr(x_1 \cap \ldots \cap x_t \cap z_t = s_i | \bm{A} \cap  \bm{B})
                    \pr(x_{t+1} \cap \ldots \cap x_T \cap z_t = s_i | \bm{A} \cap \bm{B})
                }{ \pr (\bm{z} | \bm{A} \cap \bm{B})} \\
                =& \frac{\alpha_i(t)\beta_i(t)}{ \sum^{|S|}_{j=1} \alpha_j(t)\beta_j(t)}.
\end{align}

Similarly, Bayes' theorem can be used to calculate $\xi_{ij}(t)$ based on
$\alpha_i(t)$ and $\beta_i(t)$:

\begin{align}
    \xi_{ij}(t) :=& \pr(x_t = s_i \cap x_{t+1} = s_j | \bm{z} \cap \bm{A}\cap\bm{B}) \\
    =& \frac{\pr(x_t = s_i \cap x_{t+1} = s_j \cap \bm{z} | \bm{A} \cap \bm{B})}{\pr(\bm{z} | \bm{A} \cap \bm{B})} \\
    =& \frac{
        \alpha_i(t) A_{i j} \cdot \beta_j(t+1) B_{j\,z_{t+1}}
    }{
        \sum_{k=1}^{|S|} \sum_{l=1}^{|S|} \alpha_k(t) A_{k l} \cdot \beta_l(t+1) B_{l\,z_{t+1}}
    }.
\end{align}

With these temporary values, we can update the parameters of the HMM:

- We recalculate the probability of transitioning from the initial state to a
  state $s_i$ using the probability of being in that state at time step 1:

\begin{equation}
    A_{0i} \gets \gamma_i(1)
\end{equation}

- We recalculate all other state transitions based on the expected transitions
  from $i$ to $j$:

\begin{equation}
    A_{ij} \gets \frac{\sum^{T-1}_{t=1}\xi_{ij}(t)}{\sum^{T-1}_{t=1}\gamma_i(t)}
\end{equation}

- We recalculate the emission probabilities $B_{j k}$ based on the proportion
  of times we were in state $s_j$ and observed an emission of $v_k$ compared to
  the total number of times we were in state $s_j$:

\begin{equation}
    B_{j k} \gets \frac{\sum^T_{t=1} [z_t = v_k] \gamma_j(t)}{\sum^T_{t=1} \gamma_j(t)}
\end{equation}


The above steps, starting from the recalculation of $\gamma_i(t)$ in Equation
\eqref{eqn:gamma_it}, can now be repeated until either a convergence within
some threshold is reached, or some set number of iterations have been
performed.

# Support Vector Machines \label{sec:02-support-vector-machines}

Support Vector Machines (SVMs) are a form of supervised learning that can be
used for classification or regression. As _Ergo_ is a classification problem,
only SVM classifiers will be discussed here. SVMs work well in high dimensions
and perform classifications using a small subset of the training observations,
making them relatively fast and memory efficient.

The theoretical foundations of using linear separation for classification and
finding the optimal separating hyperplane comes from work by
\cite{vapnik1964note} in the Soviet Union. They developed this theory while
working on pattern recognition and structural risk minimisation. Vapnik
continued to work on the theory of SVMs during the 1970s and 1980s while at the
Institute of Control Sciences in Moscow, but the Cold War prevented his work
from becoming widely known to the European and American scientific communities.
SVMs were later extended to handle non-linear decision boundaries with the
"kernel trick" \citep{boserTrainingAlgorithmOptimal1992} which enabled the
algorithm to implicitly operate in higher dimensional feature spaces.
\cite{cortesSupportvectorNetworks1995} introduced SVMs as they are commonly
used today with a "soft margin" that improves the generalisation capabilities
of the SVM.

Intuitively, an SVM performs binary classification by attempting to find a
hyperplane that splits the dataset in two, such that 1) the hyperplane
maximises the distance to the nearest observation regardless of the class of
that observation and 2) all observations from the same class are on the same
side of the hyperplane. Many classification tasks are not linearly separable in
this way, and thus a certain amount of "slack" is often permitted in the
mathematical formulation of an SVM which permits some observations to be on the
wrong side of the hyperplane. This is called the "soft margin" formulation for
SVMs. These misclassified observations incur a penalty, the magnitude of which
is controlled by a regularisation hyperparameter often just termed $C$. In some
cases it is advantageous to use a kernel function to transform the data into a
new space and the hyperplane is found in this new space.

This exposition will center its attention on Support Vector Machines (SVMs)
employed for soft-margin linear-kernel binary-classification, consistent with
the configuration employed by \emph{Ergo}. The interested reader is directed to
\cite[Chap. 7]{bishopPatternRecognitionMachine2007} for an explanation
regarding the other formulations of SVMs.

Given a set of input vectors $\bm{x} = \{x_1, x_2, \ldots x_n\}, \bm{x} \in
\mathbb{R}^{p \times n}$ and corresponding labels $\bm{y} = \{y_1, y_2, \ldots
y_n\}, \bm{y} \in \{-1, 1\}^n$, the task of an SVM is to find a hyperplane
$\bm{w} x_i + b = 0$ to split the two classes, where $\bm{w}$ is the weight
vector and $b$ is a bias scalar. Given an observation $x_i$, the predicted
class $\hat{y}_i$ is given by:

\begin{equation}
    \hat{y}_i = \begin{cases}
        -1 & \text{if}\quad \bm{w} x_i + b < 0 \\
        +1 & \text{if}\quad \bm{w} x_i + b \ge 0 \\
    \end{cases}
\end{equation}

The _margin_ of a SVM is defined as the smallest distance between the
hyperplane and the nearest data point(s). In maximising the margin, an SVM is
better able to generalise to unseen data because it creates a better separation
between the classes. This results in a greater probability that an unseen data
point will be further from the hyperplane. Figure \ref{fig:svm-tikz} shows an
example SVM with the margin and separating hyperplane indicated.

\tikzset{
    leftNode/.style={circle,minimum width=.5ex, fill=none,draw},
    rightNode/.style={circle,minimum width=.5ex, fill=black,thick,draw},
    rightNodeInLine/.style={solid,circle,minimum width=.7ex, fill=black,thick,draw=white},
    leftNodeInLine/.style={solid,circle,minimum width=.7ex, fill=none,thick,draw},
}
\begin{figure}[!ht]
    \centering
    \begin{tikzpicture}[
        scale=2.5,
        important line/.style={thick}, dashed line/.style={dashed, thin},
        every node/.style={color=black},
    ]
        \draw[dashed line, yshift=.4cm, xshift=-.4cm]
            (.5,.5) coordinate (sls) -- (3,3) coordinate (sle)
            node[solid,circle,minimum width=2.8ex,fill=none,thick,draw] (name) at (2,2){}
            node[leftNodeInLine] (name) at (2,2){}
            node[solid,circle,minimum width=2.8ex,fill=none,thick,draw] (name) at (1.5,1.5){}
            node[leftNodeInLine] (name) at (1.5,1.5){}
            node [above right] {$\bm{w}\cdot x + b > 1$};
        \draw[important line]
            (0.5, 0.5) coordinate (lines) -- (3,3) coordinate (linee)
            node [above right] {$\bm{w}\cdot x + b = 0$};
        \draw[dashed line, yshift=-.4cm, xshift=.4cm]
            (.5,.5) coordinate (ils) -- (3,3) coordinate (ile)
            node[solid,circle,minimum width=2.8ex,fill=none,thick,draw] (name) at (1.8,1.8){}
            node[rightNodeInLine] (name) at (1.8,1.8){}
            node [above right] {$\bm{w}\cdot x + b < -1$};
        \draw[very thick,->] (1.8,1.8) -- (1.8+0.4,1.8-0.4)
            node[above, pos=0.5, rotate=-45] {margin};
        \foreach \Point in {(.9,2.2), (1.6,2.7), (1.3,2.9), (1.5,3.4), (1,2.7)}{
            \draw \Point node[leftNode]{};
        }
        \foreach \Point in {(2.8,1.6), (2.1,.5), (3.4,.2), (1.9,0.8), (2.6,1.1)}{
            \draw \Point node[rightNode]{};
        }
    \end{tikzpicture}
    \caption[Example of an SVM Hyperplane]{An example SVM with the separating
    hyperplane as a solid line, the two classes as filled and empty circles,
    and the support vectors indicated by the double circles.}
    \label{fig:svm-tikz}
\end{figure}


The margin is equal to half the distance between the hyperplanes $\bm{w}x-b=-1$
and $\bm{w}x-b=+1$. For clarity, $\bm{w}x-b=-1$ will be named the negative
hyperplane and $\bm{w}x-b=+1$ the positive hyperplane.

If we define $x_0$ as a point on the negative hyperplane such that
$\bm{w}x_0-b=-1$, then finding the distance between the parallel hyperplanes is
the same as finding the distance between $x_0$ and the positive hyperplane. We
will name this distance $d$. The unit normal vector of the positive hyperplane
is

\begin{equation}
    \frac{w}{\|w\|}
\end{equation}
and the point in the positive hyperplane closest to the point $x_0$ can be
calculated as
\begin{equation}
    x_0 + d \frac{w}{\|w\|}
\end{equation}
since $d$ is the distance between the hyperplanes and $\frac{w}{\|w\|}$ is the
direction from the negative hyperplane to the positive hyperplane.

We then known that this point in the positive hyperplane satisfies the equation

\begin{equation}
    \bm{w} (x_0 + d \frac{w}{\|w\|}) - b = 1.
\end{equation}

Expanding and simplifying this equation allows us to calculate the value of $d$
in terms of $\bm{w}$:

\begin{align}
     \bm{w} (x_0 + d \frac{\bm{w}}{\|\bm{w}\|}) - b  &= 1 \\
                    d\frac{\|\bm{w}\|^2}{\|\bm{w}\|} &= 1 - (\bm{w} x_0 - b)\\
                                         d\|\bm{w}\| &= 2 \\
                                                  d  &= \frac{2}{\|\bm{w}\|}
\end{align}

Fitting an SVM is therefore a process of finding values for $\bm{w}$ and $b$
which maximise the magnitude of the margin $\frac{2}{\|\bm{w}\|}$, while
ensuring that all observations are correctly classified. This can be expressed
as an optimisation problem like:

\begin{equation}
    \min_{\bm{w}, b} ||\bm{w}||^2
\end{equation}
subject to the constraints
\begin{equation}
    y_i (\bm{w}^T x_i - b) \ge 1 \quad \forall i \in {1, \ldots, n}.
\end{equation}


For each observation $x_i$, a slack variable $\xi_i$ is defined as follows:
$\xi_i$ is zero if $x_i$ is correctly classified, greater than 1 if it is
misclassified, and between 0 and 1 if it is correctly classified but is within
the SVM's margin. This can be succinctly expressed as:

\begin{equation}
    \xi_i = \max(0, 1 - y_i(\bm{w} x_i + b)) \quad \forall i \in {1, \ldots, n}.
\end{equation}

The soft-margin objective function can then be defined with a regularisation
parameter $C$ which controls the degree of influence misclassifications have on
the hyperplane. Larger values for $C$ result in less generalisation but fewer
misclassifications. Smaller values for $C$ encourage a wider margin (with more
generalisation) but with more misclassifications. This soft-margin objective
function is as follows:

\begin{align}
    \text{minimize }_{\bm{w}, b}
        & \frac{1}{2} \|\mathbf{w}\|^2 + C \sum_{i=1}^n \xi_i \\
    \text{subject to }
        &y_i \cdot (\mathbf{w}^T x_i + b) \ge 1 - \xi_i \\
    \text{ and } &\, \xi_i \ge 0, \forall i \in {1, \ldots, n}.
\end{align}

# Cumulative Sum \label{sec:02-cumulative-sum}

Cumulative Sum (CuSUM) is a sequential method used for change detection
developed by \cite{pageCONTINUOUSINSPECTIONSCHEMES1954}. Given a time series
$\bm{x} = x_1, x_2, \ldots$ from an initial distribution, CuSUM can alert when
the parameters defining the underlying distribution deviate by some threshold
amount. Lower thresholds result in faster alerts but more frequent false
positives. In order to detect both an increase and a decrease in the time
series, two CuSum algorithms must be used, one to detect an increase and one to
detect a decrease. The procedure for a two-sided CuSUM is given in Algorithm
\ref{alg:cusum}.

Each CuSUM algorithm requires a reference value against which any deviations
will be compared. This reference value is set to be the first 10 values in the
given time series. The CuSUM algorithm will alert if the time series becomes
either too high or too low. Each CuSUM algorithm only has one parameter, the
threshold value, which defines how much deviation is permitted before an alert
is raised. The procedure for performing CuSUM on a stream of data is presented
in Algorithm \ref{alg:cusum}.

\begin{algorithm}
    \caption{CuSUM Algorithm}
    \label{alg:cusum}
    \begin{algorithmic}
        \Require Data stream: $x_1, x_2, \ldots, x_n$
        \Require Threshold: $t$
        \State $U_0 = 0$, $L_0 = 0$
        \State $r = \frac{1}{10}\sum_{i=1}^{10} x_i$
        \For{$i = 1$ to $n$}
            \State $d_i = x_i - r$
            \If{$d_i > 0$}
                \State $U_i = U_{i-1} + d_i$
                \State $L_i = L_{i-1}$
            \Else
                \State $U_i = U_{i-1}$
                \State $L_i = L_{i-1} - d_i$
            \EndIf

            \If{$U_i > t$ \textbf{or} $L_i > t$}
                \State \textbf{Alarm condition met}
            \EndIf
        \EndFor
        \State \textbf{Alarm condition not met}
    \end{algorithmic}
\end{algorithm}

The details of how this algorithm can be applied to a multi-class
classification problem are described in detail in Section
\ref{model-specifics-cusum}.

# Evaluation Metrics \label{sec:02-evaluation-metrics}

There are several means of comparing multi-class classifiers, these are
discussed in the following subsection. The task is to compare the performance
of several classifiers at classifying $n$ observations into a set of classes $C
= \{c_1, c_2, \ldots\}$. The predictions of a classifier will be notated
as $\bm{p}: p_i \in C \,\forall\, i \in {1, \ldots, n}$ and the corresponding
ground truth as $\bm{t}: t_i \in C \,\forall\, i \in {1, \ldots, n}$

The following subsections will describe different means of comparing
multi-class classifiers.

## Accuracy

The accuracy of a classifier is defined as the number of correct predictions
divided by the total number of predictions:

\begin{equation}
    \text{Accuracy} = \frac{1}{n}\sum_{j=1}^{n} [t_j = p_j].
\end{equation}

This is commonly used for evaluating classifiers, but has some limitations for
the multi-class case. It is sensitive to class imbalances and will be biased
towards the majority class. If 99% of the data belongs to a positive class
while 1% of the data belongs to the negative class, then a naïve classifier can
achieve 99% accuracy by always predicting positive. As the _Ergo_ dataset has a
large class imbalance, accuracy will not be used as a metric for comparing
models.

## Confusion Matrices

Confusion matrices collate a model's performance by grouping each combination of
predicted and ground truth\footnote{
    The \emph{Ground truth} labels are the known correct labels for a given
    dataset. This is what a classification algorithm will attempt to predict.
} label. For a $|C|$-class classification problem, a
confusion matrix is a $|C| \times |C|$ matrix of values, where the the
$i$\textsuperscript{th} row and the $j$\textsuperscript{th} column is the
number of times a classifier predicted an observation that belongs to class $i$
as belonging to class $j$. The element-wise definition of a confusion matrix is

\begin{equation}
    \text{Confusion Matrix}_{ij} = \sum_{k=1}^{n} [(t_k = j ) \cap (p_k = i)].
\end{equation}

An example confusion matrix is given in the top-left plot of Figure
\ref{fig:04_example_conf_mat}. Note that elements in the confusion matrix which
are zero are left uncoloured and are not annotated with a 0: for confusion
matrices with few classes and few observations this will not matter
significantly, however for confusion matrices with many classes and many
observations it will prove informative to be able to distinguish one
misprediction from zero mispredictions.

\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_example_conf_mat}
    \caption[Example Confusion Matrices]{Four example confusion matrices, each showing the same data but
    visualised under four different normalisation schemes.}
    \label{fig:04_example_conf_mat}
\end{figure}

In practice, confusion matrices are often normalised. This aids in the
interpretation of the model's performance. The previously-discussed top-left
plot of Figure \ref{fig:04_example_conf_mat}is an unnormalised confusion
matrix. Column normalisation divides each element by the sum of its column,
such that each column sums to one (top-right plot). Row normalisation is
similar, and ensures that each row sums to one (bottom left plot).
Row-normalization and column-normalization ensure that each element in the
matrix represents the proportion of ground truth or predicted labels concerning
the total number of ground truth or predicted labels for the associated class,
respectively. Confusion matrices can also be total-normalised (as seen in the
bottom-right plot) in which case every element is divided by the sum over the
entire confusion matrix. This allows each element to be interpreted as a
fraction of the total number of observations.

Unless otherwise specified, all confusion matrices presented in this thesis are
column-normalised, as this allows for easier interpretation of the distribution
of a given model's predictions for each class.

It is also useful to compare the confusion matrices for all instances of a
model across two or more values of a discrete hyperparameter. For example,
comparing the confusion matrices for Feed-forward Neural Networks (FFNNs) with
one, two, and three layers. In these cases, the weighted confusion matrix shall
be shown. The weighted confusion matrix is calculated by taking the
unnormalised confusion matrix for a model, multiplying each value in that
confusion matrix by the model's $F_1$-score, and then adding all confusion
matrices together element-wise. The resulting sum of weighted confusion
matrices is then divided by the sum of all $F_1$-scores and then finally the
confusion matrix is column-normalised. This procedure is given in Algorithm
\ref{alg:04_weighted_cm}.

\begin{algorithm}
    \caption[Weighted confusion matrices]{Comparison of Weighted Confusion Matrices}
    \label{alg:04_weighted_cm}
    \begin{algorithmic}[1]
        \Require A set of models
        \Require A method for computing the confusion matrix for a model
        \Require A method for computing the $F_1$-score for a model
        \State $\bm{C}_{weighted} \gets \mathbf{0}_{n\times n}$
        \State $\Sigma F_1 \gets 0$
        \For{$model$ in $models$}
            \State $\bm{C} \gets$ \Call{ComputeConfusionMatrix}{model}
            \State $F_1 \gets$ \Call{$\text{ComputeF}_1\text{Score}$}{model}
            \State $\bm{C}_{weighted} \gets \bm{C}_{weighted} + (F_1 \cdot \bm{C})$
            \State $\Sigma F_1 \gets \Sigma F_1 + F_1$
        \EndFor
        \State $C_{weighted} \gets \frac{\bm{C}_{weighted}}{\Sigma F_1}$
        \State $C_{weighted} \gets$ \Call{ColumnNormalize}{$C_{weighted}$}
    \end{algorithmic}
\end{algorithm}

## Precision, Recall, and $F_1$-score \label{sec:02-prec-rec-f1}

Confusion matrices aid in the interpretation of large numbers of predictions,
but do not have a total ordering and so cannot be used to rank different
models. To this end, we will define first the per-class precision, recall, and
$F_1$-score. These metrics depend on four summary statistics which are defined
for each class: $\text{TP}_i$, $\text{TN}_i$, $\text{FP}_i$, $\text{FN}_i$,

$\text{TP}_i$ is the number of true positives for class $i$, and is defined
as the number of labels for which both the ground truth and the predicted class
are $i$:

\begin{equation}
    \text{TP}_i = \sum_{j=1}^n [t_j = p_j = i].
\end{equation}

$\text{TN}_i$ is the number of true negatives for class $i$ and is defined as
the number of labels for which both the ground truth and the predicted class
are _not_ $i$:

\begin{equation}
    \text{TN}_i = \sum_{j=1}^n [t_j \neq i \land p_j \neq i].
\end{equation}

$\text{FP}_i$ is the number of false positives for class $i$ and is defined
as the number of labels for which the predicted class is $i$ but the true
label is _not_ $i$:

\begin{equation}
    \text{FP}_i = \sum_{j=1}^n [p_j = i \land t_j \neq i].
\end{equation}

$\text{FN}_i$ is the number of false negatives for class $i$ and is defined
as the number of labels for which the predicted label is not $i$ but the true
label is $i$:

\begin{equation}
    \text{FN}_i = \sum_{j=1}^n [p_j \neq i \land t_j = i].
\end{equation}

The precision for some class $i$ can be intuitively understood as a metric that
penalises classifiers which too frequently predict class $i$. It is defined as

\begin{equation}
    \text{Precision}_i = \frac{\text{TP}_i}{\text{TP}_i + \text{FP}_i}.
\end{equation}

Likewise, the recall for some class $i$ can be understood as a metric that
penalises classifiers which do not predict class $i$ frequently enough. It is
defined as

\begin{equation}
    \text{Recall}_i = \frac{\text{TP}_i}{\text{TP}_i + \text{FN}_i}.
\end{equation}

The $F_1$-score for some class $i$ ($F_{1 i}$) is defined as the harmonic
mean of the precision and recall of that class:

\begin{equation}
    F_{1 i} = 2 \cdot \frac{
            \text{Precision}_i \cdot \text{Recall}_i
        }{
            \text{Precision}_i + \text{Recall}_I
        }
\end{equation}

The fact that the harmonic mean is used to calculate the $F_1$-score ensures
that both a high precision and high recall are required to obtain a high
$F_1$-score. This property can clearly be seen in Figure
\ref{fig:04_precision_recall_f1} where contours join precision and recall
values that have the same $F_1$-score.

\begin{figure}[!h]
    \centering
    \includegraphics{src/imgs/graphs/04_precision_recall_f1}
    \caption[Precision and Recall with $F_1$ as Contours]{Precision and recall
    with the calculated $F_1$-score plotted as contours. Both a high recall and
    a high precision are required for a high $F_1$-score.}
    \label{fig:04_precision_recall_f1}
\end{figure}

Occasionally it will be useful to visualise the precision, recall, and
$F_1$-score of a model. In these cases, a heatmap with one column per class and
one row for each of precision, recall, and $F_1$-score will be used. A sample
plot is shown in Figure \ref{fig:04_prec_rec_f1_example}, where the data is the
same as was used to construct the confusion matrices in Figure
\ref{fig:04_example_conf_mat}.

\begin{figure}[!h]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/04_prec_rec_f1_example}
    \caption[Example Precision, Recall, $F_1$ Heatmap]{Precision, recall, and $F_1$
    score for the confusion matrix in Figure \ref{fig:04_example_conf_mat}.}
    \label{fig:04_prec_rec_f1_example}
\end{figure}

From Figure \ref{fig:04_prec_rec_f1_example} it is apparent that the classes
with perfect precision (classes 0, 1, and 3) have columns in the confusion
matrix which are zero except for the element on the principle diagonal.
Likewise, the class with perfect recall (class 2) has a row in the confusion
matrix which is zero except for the element on the principle diagonal.
Precision can therefore be gleaned from a confusion matrix by observing the
columns of the appropriate confusion matrix, and recall by observing
the rows.

## Weighted and Unweighted Averages

While precision, recall, and $F_1$-score provide a much more concise
representation of a classifier's performance than a confusion matrix, they
still do not provide a single number which can be used to give classifiers a
total ordering. To this end, we will calculate the unweighted arithmetic mean
of the per-class precision, recall, and $F_1$-scores\footnote{The unweighted
average is sometimes referred to as the macro average, and the weighted average
as the micro average.}:

\begin{align}
    \text{Unweighted Precision} &= \frac{1}{|C|}\sum_{i=1}^{|C|} \text{Precision}_i \\
    \text{Unweighted Recall} &= \frac{1}{|C|}\sum_{i=1}^{|C|} \text{Recall}_i \\
    \text{Unweighted } F_{1} &= \frac{1}{|C|}\sum_{i=1}^{|C|} F_{1 i}
\end{align}


The unweighted mean is desirable for the task at hand as the _Ergo_ dataset is
highly imbalanced, with one class being assigned to 97% of the observations. If
the weighted mean was used instead, then a classifier would be able to achieve
very high performance by ignoring the minority classes and only focusing on
predicting the majority class correctly.

For these reasons, the terms "precision", "recall", and "$F_1$-score" will
always be the unweighted arithmetic mean over the per-class precisions,
recalls, and $F_1$-scores respectively.

It is important to note that one cannot calculate the unweighted $F_1$-score
using the unweighted precision and recall due to the non-linear relationship
between the $F_1$-score and precision and recall. This has the unfortunate
implication that a plot showing the unweighted precision and unweighted recall
of a model does _not_ allow the viewer to infer its unweighted $F_1$-score.

# Binary and Multi-class Classifiers \label{sec:02-binary-and-multi-class-classifiers}

Some classification algorithms are able to perform multi-class classification
without significant adjustment, such as Feed Forward Neural Networks or
Decision trees. The training and classification procedures for these algorithms
does not depend on whether the task is binary or multi-class classification.

Other classification algorithms only support binary classification and cannot
perform multi-class classification without extensive adjustment to their
training and classification procedures. Examples would be Hidden Markov Models
or Support Vector Machines. Binary classification algorithms can be converted
into $n$-class ($n>2$) classification algorithms by creating an ensemble of $n$
binary classifiers. In this setup, the $i$\textsuperscript{th} binary
classifier would be trained to predict if a given observation belongs either to
class $i$ or to some class other than class $i$.

To predict the class of an observation, each of these $n$ classifiers will make
a prediction for that same observation. A well trained ensemble will have only
one binary classifier predicting YES and all other classifiers predicting NO
for a given observation. This procedure for using an ensemble of binary
classifiers as a multi-class classifier is called one-vs-rest classification.

