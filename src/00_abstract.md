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

\begin{abstract}[Afrikaans]%=================================================

Hierdie tesis stel \emph{Ergo} bekend - ‘n pasgemaakte stel sensors wat ontwerp
is om die algemene QWERTY-sleutelbord in terme van die aantal invoersleutels en
die spoed van invoering heeltemal te vervang.

\emph{Ergo} versamel versnellingsdata van elk van die gebruiker se 10
vingerpunte teen ‘n tempo van 40 keer per sekonde en kan voorspel watter van
die 50 verskillende bewegings teen dieselfde tempo uitgevoer word.

Die gebruiker hoef nie die begin of einde van elke beweging noukeurig aan te
dui nie aangesien \emph{Ergo} ‘n gebrek aan doelbewuste beweging kan opspoor en
dienooreenkomstig kan reageer. Wanneer ‘n bekende beweging waargeneem word,
word ‘n ooreenstemmende toetsaanslag uitgestuur, en kan die gebruiker op sy of
haar rekenaar ``tik'' deur bewegings in volgorde uit te voer.

Vyf verskillende klassifikasiemodelle word geëvalueer (Versteekte
Markov-modelle, Ondersteuningsvektormasjiene, Kumulatiewe som en twee
verskillende Neurale Netwerk-argitekture). Daar is bevind dat die Neurale
Netwerke die klassifikasiemodel met die beste resultate is.

Die verskil in moeilikheidsgraad tussen klassifikasietake wat waarnemings
sonder doelbewuste beweging insluit of nie insluit nie, word ook geëvalueer.

Daar is gevind dat die bykomende vereiste om doelbewuste bewegings van ander
handbewegings te kan onderskei, die moeilikheidsgraad van die taak aansienlik
verhoog.

\end{abstract}
