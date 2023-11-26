<!--
    \chapter{Additional Analysis}\label{app:additional-analysis}
  #Performance vs dropout rate and L2 coefficient \label{sec:appendix_51_ffnn_regularisation}

Figure \ref{fig:05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers} shows the dropout rate
against the $F_1$-score for the 1-, 2-, and 3-layer FFNNs, with the colour of
each point indicating the L2 coefficient.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers}}
    \caption[FFNN 51-class dropout rate vs $F_1$ and L2]{The dropout rate of each of the 51-class FFNNs against the
    $F_1$-score and with the L2 coefficient indicated by the colour of each
    point and the shared colour bar on the right. One plot each is assigned to
    the 1-, 2-, and 3-layer FFNNs. A small amount of random noise is applied to
    each point such that they do not overlap.}
    \label{fig:05_51ffnn,x=dropout,y=f1,h=l2,c=nlayers}
\end{figure}

The dropout rate has little to no effect on the 1-layer FFNNs, while the 2- and
3-layer FFNNs generally benefit from a low dropout rate. For the 2- and 3-layer
FFNNs, a low dropout rate was not the sole factor which resulted in a high
$F_1$-score, however having a high dropout rate rarely resulted in high
$F_1$-scores. The L2 coefficient had little impact on the $F_1$-scores of any
of the FFNNs, with no range of L2 coefficient showing superior performance.
Because dropout has the effect of setting a subset of nodes' output to zero,
it is not surprising that dropout worked best for models with more layers.

Figure \ref{fig:05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers} shows the
dropout rate against the number of nodes in the last layer for the 1-, 2-, and
3-layer FFNNs, with the colour of each point indicating the $F_1$-score.

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics{src/imgs/graphs/05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers}}
    \caption[FFNN 51-class dropout rate vs $F_1$ and number of nodes per
    layer]{The dropout rate of each of the 51-class FFNNs against the number of
    nodes in the last layer of the FFNN, with the $F_1$-score indicated by the
    colour of each point and the shared colour bar on the right. One plot each
    is assigned to the 1-, 2-, and 3-layer FFNNs. A small amount of random
    noise is applied to each point such that they do not overlap.}
    \label{fig:05_51fffnn,x=dropout,y=npl-1,h=npl1,c=nlayers}
\end{figure}

Since increasing the dropout rate has the effect of suppressing the output of a
random subset of nodes in each layer, one might expect that FFNNs with a high
dropout rate would require a large number of nodes in order to achieve good
performance. This can be seen to some extent in the plot for 1-layer FFNNs, in
which only the FFNNs with a low dropout rate and a low number of nodes in their
singular layer have a high $F_1$-score. There are no 1-layer FFNNs which
simultaneously have a high dropout rate, few nodes in their singular layer, and
a high $F_1$-score. One can see that an increase in the dropout rate usually
requires an increase in the number of nodes in the singular layer for the FFNN
to maintain a high $F_1$-score.

The 2- and 3-layer FFNNs both show behaviour whereby a FFNN performs well if it
has a low dropout rate and a high number of nodes in its final layer. This
behaviour is less distinct for the 3-layer FFNNs, which is to be expected as
the extra layer introduces more complexity into its performance characteristics.
-->


<!--

===============================================================================
===============================Additional Figures==============================
===============================================================================

-->

\chapter{Additional Figures}\label{app:additional-figures}

\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_analysis_ffnn_classes5_yval_macro_avg_f1_score_hueNone}
    \caption[FFNN 5-class $F_1$ vs all hyperparameters]{The $F_1$-score for all
    5-class FFNNs plotted against the various hyperparameters.}
    \label{fig:appendix_ffnn_hpar_analyis_classes5}
\end{figure}

\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_analysis_ffnn_classes50_yval_macro_avg_f1_score_hueNone}
    \caption[FFNN 50-class $F_1$ vs all hyperparameters]{The $F_1$-score for
    all 50-class FFNNs plotted against the various hyperparameters.}
    \label{fig:appendix_ffnn_hpar_analyis_classes50}
\end{figure}

\begin{figure}[!ht]
    \centering
    \includegraphics{src/imgs/graphs/05_hpar_analysis_ffnn_classes51_yval_macro_avg_f1_score_hueNone}
    \caption[FFNN 51-class $F_1$ vs all hyperparameters]{The $F_1$-score for
    all 51-class FFNNs plotted against the various hyperparameters.}
    \label{fig:appendix_ffnn_hpar_analyis_classes51}
\end{figure}

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.4\textwidth]{src/imgs/graphs/05_hpar_analysis_ffnn_pairplot}}
    \caption[FFNN 51-class all hyperparameter pairplot]{Pairplot of all hyperparameters for 51-class FFNNs.}
    \label{fig:appendix_hpar_analysis_ffnn_pairplot}
\end{figure}

\begin{figure}[!ht]
    \centering
    \makebox[\textwidth][c]{\includegraphics[width=1.2\textwidth]{src/imgs/ergo_schematic}}
    \caption[Circuit Schematic]{Circuit schematic for the left and right hand
    of Ergo.}
    \label{fig:appendix_circuit_diagram}
\end{figure}

<!--

===============================================================================
===============================Additional Tables===============================
===============================================================================

-->

\chapter{Additional Tables}\label{app:additional-tables}

\input{src/tables/05_best_ffnn_hpars.tex}

\input{src/tables/05_best_majority_hffnn_hpars.tex}

\input{src/tables/05_best_minority_hffnn_hpars.tex}

\input{src/tables/05_best_svm_hpars.tex}

\input{src/tables/05_best_hmm_hpars.tex}

\input{src/tables/05_best_cusum_hpars.tex}

\chapter{The Human Hand}\label{app:the-human-hand}

The human hand contains 27 bones which are split into three regions: the 14
_phalanges_ (three for each finger and two for the thumb), the 5 _metacarpal
bones_ (the palm bones, each of which connect to a finger or the thumb), and
the 8 _carpal bones_ (the wrist bones, which are arranged in two rows going
across the wrist).

The carpals connect to the bones of the arm: the _radius_ (which is closest to
the thumb) and the _ulnar_ (which is closest to the little finger)

\begin{figure}[!htb]
\centering
\includegraphics[width=0.6\textwidth]{src/imgs/03_bones.png}
\caption{Medical diagram of the bones of the hand.}
\label{fig:}
\end{figure}

The joints between bones are, logically, named according the bones they
connect:

- _Carpometacarpal_ (CMC): Those joints connecting the carpal (wrist) bones to
  the metacarpal (palm) bones.

- _Metacarpophalangeal_ (MCP): Those joints connecting the metacarpal (palm)
  bones to the palangeal (finger) bones.

- _Interphalangeal_ (IP): Those joints between the phalangeal (finger) bones.
  Due to the number of phalangeal bones, these are subdivided into the _distal
  interphalangeal_ joints (DIP, closest to the fingertip) and the _proximal
  interphalangeal_ joints (PIP, closest to the palm).

In addition to the bones and joints, there are terms for each movement of the
hand. These are named based on the direction of movement.

"Splaying" movements:

- _Abduction_: moving the fingers away from the middle finger ("splaying" the
  fingers").
- _Radial abduction_: moving the thumb towards the radius.
- _Adduction_: moving the fingers towards the middle finger.
- _Radial adduction_: moving the thumb towards the middle finger.

"Closing/Opening" movements:

- _Extension_: moving the fingers or thumb "outwards", "opening" the
  fingers or thumb of the hand.
- _Flexion_: moving the fingers or thumb "inwards", "closing" the
  fingers or thumb of the hand.
- _Palmar adduction_: moving the thumb towards the back of the palm.
- _Palmar abduction_: moving the thumb "down" away from the palm.

"Curving" movements:

- _Retroposition_: Rotating the thumb to be in the same plane as the palm.
- _Opposition_: Rotating the thumb to be directly above the metacarpal of the
  index finger.
- _Bending_: Curving the metacarpal bones of the palm towards each other.
- _Flattening_: Flattening the metacarpal bones of the palm to be in the same
  plane.

The hand can also be rotated at the wrist about three axes:

- _Pronation_ and _Supination_: Rotating the hand and forearm so that the palm
  faces downward or upward respectively
- _Wrist Flexion_ and _Wrist Extension_: Moving the palm of the hand downward
  toward or away from the inner side of the forearm.
- _Radial Deviation_ and _Ulnar Deviation_: Moving the hand and wrist toward or
  away from the thumb side.

\begin{figure}[!htb]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/03_movements.png}
    \caption{Movements of the hand.}
    \label{fig:03_movements}
\end{figure}
