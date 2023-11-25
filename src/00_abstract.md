\begin{abstract}[english]%===================================================

This thesis presents \emph{Ergo}, a bespoke glove-based sensor suite designed
to fully replace the regular QWERTY keyboard in terms of both number of input
keys and speed of input. \emph{Ergo} collects acceleration data from each of
the user's 10 fingertips at a rate of 40 times per second and is able to
predict which of 50 different gestures is being performed at the same rate. The
user does not need to explicitly mark the start or end of each gesture, as
\emph{Ergo} is able to detect the lack of intentional movement and react
accordingly. When a known gesture is detected, a corresponding keystroke is
emitted, allowing the user to ``type'' on their computer by performing gestures
in sequence. Five different classification models are evaluated (Hidden Markov
Models, Support Vector Machines, Cumulative Sum, and two different Neural
Network architectures) and Neural Networks are found to be the most performant.
The difference in difficulty between classification tasks which either do or do
not include observations without intentional movement is also evaluated. The
additional requirement to be able to distinguish intentional gestures from
other hand movements is found to increase the difficulty of the task
significantly.

\end{abstract}

\begin{abstract}[afrikaans]%=================================================
Afrikaans abstract has not been written
\end{abstract}
