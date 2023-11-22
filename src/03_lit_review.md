<!---
TODO: should also note that the vast majority of glove-based gesture
recognition is very dumb "arm movements" and very little is as dexterous as
Ergo

TODO: Include a plot about the fidelity of the glove-based systems
TODO: Include a plot about the number of classes

- Include a section which describes each of the different hardware items and
  the different technology items
- It would be nice to see papers which do implicit vs explicit segmentation
--->

\epigraph{
    Always remember, however, that there’s usually a simpler and better way to
    do something than the first way that pops into your head.
}{\textit{Donald Knuth}}

This chapter reviews the literature concerning hand gesture recognition and is
divided into four sections. Section \ref{sec:03-overview} provides an overview
of the field and defines some important comparison metrics. Gesture recognition
can be divided into three categories, based on how hand movement is measured:
Section \ref{glove-based-gesture-recognition} discusses the method utilised by
\emph{Ergo} (using a sensor suite mounted in a glove) and Section
\ref{sec:03-vision-and-wifi-based-gesture-recognition} discusses the other two
(using computer vision and WiFi diagnostics respectively).

For the sake of brevity, not every paper represented in the figures in this
chapter is necessarily cited. The reader is directed to the Zenodo dataset
containing the author's database of approximately 750 papers, theses, and
websites which were used to construct these plots. The code required to
reproduce the figures is available [on
GitHub](https://github.com/beyarkay/masters-thesis).
<!-- TODO: add links to these -->

# Overview \label{sec:03-overview}

Automatic gesture recognition has gone through much change since its first
inception in the late 1960s
\citep{experimentaltelevisioncenterComputerImageCorporation1969}. Fragmentation
and duplicated research has prevented the establishment of a common
nomenclature. As such, commonly used terms (such as "gesture" or "real-time")
do not have consistent definitions. Where confusion may arise, terms will be
defined before usage.

Over the years, many authors have published gesture recognition systems, each
dealing with slightly different challenges or with slightly different goals.
Different authors may sometimes describe a task similarly, only for further
inspection to reveal hidden assumptions that make the tasks vary greatly in
difficulty and scope. This review will define several metrics (such as the
technology or algorithm used) to allow for a systematic comparison of different
works in the field. Where authors have tested multiple technologies or
algorithms in one paper, multiple metrics are recorded for that paper. The
metrics are:

**Glove/vision/wifi based systems** There are the three categories of gesture
capture systems: glove-based, vision-based, and WiFi-based systems. Glove-based
systems have a sensor suite physically connected to the person's hands or
forearms. Vision-based systems use RGB cameras\footnote{
    Red-Green-Blue cameras can capture the full spectrum of human-visible light
} and/or LiDAR\footnote{
    LiDAR (Light Detection and Ranging) is a remote sensing technology that
    employs laser beams to measure distances and obtain precise
    three-dimensional representations of a space.
} to capture the colour and/or depth information of the person performing the
gesture. WiFi-based systems are a relatively new development, and use extremely
sensitive WiFi diagnostics information to infer the position of the human body.

**Technology used** This refers to the underlying technology that enables data
collection, such as acceleration sensors or visible-light cameras. A full
description of the various technologies is available in the List of Symbols.

<!-- TODO: Add graphs about the number of classes -->
**Number of classes** The number of classes classified by the system. This is
often 26, one class for each letter _a_ through _z_.

**Model(s) used** The type of model used to classify the data. When a paper
used a derivation of a commonly used model, then the commonly used model is
recorded.

**Hardware used** This is the pre-built hardware used to collect the data. A
full description of the various hardware used is available in the List of
Symbols.

**Gesture fidelity** This refers to the level of precision required to perform
a given gesture. Gesture fidelity is divided into gestures requiring only
arm-level precision (such as waving the arm or tracing a circle in the air),
hand-level precision (such as rotation at the wrists) or finger-level precision
(such as typing or most sign-language gestures).

**Explicit or implicit segmentation** Explicit segmentation is where the
continuous time series of data has been segmented such that the start and end
of each gesture is provided to the model. This might be done by inserting
markers into the continuous time series and providing those markers to the
model, or it might be done by only training the model on the portions of the
time series which contain gestures. Implicit segmentation does not provide any
markers to the model, and requires that the model first detect which
segments of time have gestures and then recognise which gestures are in those
segments.

# Glove-based Gesture Recognition

Glove-based gesture recognition is any gesture recognition system which gathers
hand information using a device physically attached to the user's hands or
upper arms.  Subsection \ref{sec:03-technologies-used} will discuss the
technologies used in building glove-based systems. Subsection
\ref{literature-surveys} will provide an overview of the larger literature
surveys. Subsection \ref{sec:03-hardware-products} will discuss the hardware
products used for glove-based systems. Subsection
\ref{algorithms-used-for-gesture-recognition} reviews the algorithms used for
glove-based gesture recognition.

## Technologies Used \label{sec:03-technologies-used}

<!-- TODO:
You have to make sure it comes across why you made a custom design and not
used one of the existing systems
-->

Different technologies have been used over the decades to instrument the
movement of a user's hands. Descriptions of the different technologies are
available in the List of Symbols.

Early glove-based systems often used hand crafted sensors (presumably due to a
lack of cheap electronic sensors at the time) such as optical tubes which
occlude light when bent \citep{thomasa.defantiUSNEAR60341631977} or flexion
sensors which change their electrical resistance when bent
\citep{garyj.grimesUSPatentDigital1981}. Hall-effect sensors which use magnets
to measure the rotation of different joints were used by some
authors\footnote{\citealt{
    jacobsenUTAHDextrousHand1984,
    jacobsenDesignUtahDextrous1986,
    marcusSensingHumanHand1988}}.

**Flex sensors** measure the bend of a short plastic strip were first placed
across joints and used successfully in the late 1980s and early
1990s\footnote{\citealt{
    zimmermanHandGestureInterface1987,
    abramsgentileentertainmentPowerGlove1989,
    baudelCharadeRemoteControl1993,
    felsGloveTalkIIaNeuralnetworkInterface1998}}.
They are unable to accurately measure very acute angles (such as those between
fingers) but are intuitive to use and the resulting measurements are easy to
interpret. Flex sensors have seen adoption in commercially available
glove-based systems, and have been used in many papers
due to their interpretability and relatively low cost\footnote{\citealt{
    feinerVisualizingDimensionalVirtual1990,
    felsBuildingAdaptiveInterfaces1990,
    wiseEvaluationFiberOptic1990,
    murakamiGestureRecognitionUsing1991,
    takahashiHandGestureCoding1991,
    baudelCharadeRemoteControl1993,
    frankhofmannSensorGloveAnthropomorphicRobot1995,
    kadousGRASPRecognitionAustralian1995,
    kesslerEvaluationCyberGloveWholehand1995,
    liangSignLanguageRecognition1996,
    felsGloveTalkIIaNeuralnetworkInterface1998,
    rung-hueiliangRealtimeContinuousGesture1998,
    laviolaSurveyHandPosture1999,
    immersioncorporationCyberGlove2001,
    alviPakistanSignLanguage2007,
    heumerGraspRecognitionUncalibrated2007,
    atzoriNinaproDatabaseResource2015,
    mardiyantoDevelopmentHandGesture2017,
    leeSmartWearableHand2018,
    leeDeepLearningBased2020,
    wenMachineLearningGlove2020,
    yuanHandGestureRecognition2020}}.

**Accelerometers** are sensors that measure acceleration with little noise, and
often come in very small microcontroller packages. Many mobile devices (such as
phones, game controllers, and smart watches) contain one or more
accelerometers. Accelerometers were first used by
\cite{fukumotoBodyCoupledFingerRing1997} who mounted them in rings worn at the
base of the user's fingertips. These accelerometers were used to detect when
the user tapped their fingers against a flat surface, and mapped this to
certain keystrokes. Acceleration sensors became popular and have been used in
many papers\footnote{\citealt{
    kratzWiizards3DGesture2007,
    wuGestureRecognition3D2009,
    fukumotoBodyCoupledFingerRing1997,
    rekimotoGestureWristGesturePadUnobtrusive2001,
    hernandez-rebollarAcceleGloveWholehandInput2002,
    tuulariSoapBoxPlatformUbiquitous2002,
    mantyjarviEnablingFastEffortless2004,
    mantyjarviGestureInteractionSmall2005,
    mantyjarviIdentifyingUsersPortable2005,
    pylvanainenAccelerometerBasedGesture2005,
    karantonisImplementationRealTimeHuman2006,
    kelaAccelerometerbasedGestureControl2006,
    alviPakistanSignLanguage2007,
    heumerGraspRecognitionUncalibrated2007,
    kimBichannelSensorFusion2008,
    schlomerGestureRecognitionWii2008,
    wangTrafficPoliceGesture2008,
    klingmannAccelerometerBasedGestureRecognition2009,
    kongGestureRecognitionModel2009,
    liuUWaveAccelerometerbasedPersonalized2009,
    parsaniSingleAccelerometerBased2009,
    zhangHandGestureRecognition2009,
    aklAccelerometerbasedGestureRecognition2010,
    bevilacquaContinuousRealtimeGesture2010,
    netoHighLevelProgramming2010,
    aklNovelAccelerometerBasedGesture2011,
    xuzhangFrameworkHandGesture2011,
    raysarkarHandGestureRecognition2013,
    sethujanakiRealTimeRecognition2013,
    songAntLearningAlgorithm2013,
    wangUserindependentAccelerometerbasedGesture2013,
    ammaAirwritingWearableHandwriting2014,
    hamdyaliComparativeStudyUser2014,
    whiteheadGestureRecognitionAccelerometers2014,
    xieAccelerometerGestureRecognition2014,
    atzoriNinaproDatabaseResource2015,
    marasovicMotionBasedGestureRecognition2015,
    galkaInertialMotionSensing2016,
    wuWearableSystemRecognizing2016,
    mardiyantoDevelopmentHandGesture2017,
    kunduHandGestureRecognition2018,
    leeSmartWearableHand2018,
    liHandGestureRecognition2018,
    mummadiRealTimeEmbeddedDetection2018,
    kochRecurrentNeuralNetwork2019,
    makaussovLowCostIMUBasedRealTime2020,
    zhangStackedLSTMBasedDynamic2021,
    patilMarathiSignLanguage2022,
    alzubaidiNovelAssistiveGlove2023}}.

**Surface Electromyography** (EMG) measures the electrical impulse of a user's
muscles through conductive pads attached to the bare skin of the user's
forearms. This method
generally results in a noisy signal and often requires machine learning
techniques to interpret the data, however it is very discrete and leaves the
user's hands completely unencumbered. Many systems have used EMG\footnote{\citealt{
    kimBichannelSensorFusion2008,
    zhangHandGestureRecognition2009,
    xuzhangFrameworkHandGesture2011,
    atzoriNinaproDatabaseResource2015,
    jiangDevelopmentRealtimeHand2016,
    wuWearableSystemRecognizing2016,
    kunduHandGestureRecognition2018,
    kochRecurrentNeuralNetwork2019,
    zhangRealTimeSurfaceEMG2019,
    moinWearableBiosensingSystem2020,
    collialfaroUserIndependentHandGesture2022,
    vasconezHandGestureRecognition2022}}.
A general survey of the field given by
\cite{asgharioskoeiMyoelectricControlSystems2007}.

After the introduction of acceleration and EMG sensors to the field of gesture
recognition, there are a few papers\footnote{\citealt{
    ammaAirwritingWearableHandwriting2014,
    wuWearableSystemRecognizing2016,
    leeSmartWearableHand2018,
    liHandGestureRecognition2018}}
which combine the two in a technique often called "sensor-fusion" to gain
better recognition results than either sensor in isolation.

**Capacitance sensors** measure the changing electrical capacitance of the body
as muscles are contracted and relaxed, and has been used to recognise hand
gestures\footnote{\citealt{rekimotoGestureWristGesturePadUnobtrusive2001,
wongMultiFeaturesCapacitiveHand2021}}.
\cite{rekimotoGestureWristGesturePadUnobtrusive2001} achieved this by using
a bracelet-like device which measures how the capacitance through the upper
forearm changed as the user's muscles moved their fingers.

**Triboelectric textile** uses the triboelectric effect whereby two dissimilar
materials exchange electrons when they come into contact and then separate. The
resulting difference in electrical charge can be harnessed as electrical
energy. Triboelectric textile was used as an energy-capture and motion-capture
system by \cite{wenMachineLearningGlove2020} who were able to perform gesture
prediction using the motion capture data.

Figure \ref{fig:03_tech_for_gloves} shows the different technologies used by
glove-based systems over time. Each point is a paper, and the colour of the
point indicates the number of citations. If a paper used multiple technologies,
then it is represented by multiple points, one point for each technology. If
multiple papers are published in the same year and use the same technology,
then their markers are plotted above or below one another to avoid overlap.
The highly cited paper around 2006 is
\cite{karantonisImplementationRealTimeHuman2006}, which explored using decision
trees and a waist-mounted Inertial Measurement Unit (IMU) for fall detection in
the elderly. Many other gesture recognition papers do not have medical
applications and so this likely contributed to the large number of citations.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/03_tech_for_gloves}
    \caption[Technologies used for glove-based systems]{Different technologies
    used for glove-based systems. EMG refers to
    electromyography. IMU stands for Inertial Measurement Unit, a device
    typically capable of measuring rotational acceleration, linear
    acceleration, and orientation relative to the earth's magnetic field.}
    \label{fig:03_tech_for_gloves}
\end{figure}

## Literature Surveys

The inaugural investigation into glove-based input was undertaken by
\cite{sturmanSurveyGlovebasedInput1994} (following Sturman's dissertation on
whole-hand input \citep{sturmanWholehandInput1992}). Sturman and Zeltzer's
survey comprehensively examined the (predominantly glove-based) systems at that
time and discussed their applications. Following this survey, the interest in
hand gesture recognition increased significantly which prompted the survey by
\cite{laviolaSurveyHandPosture1999} who discussed the models and techniques
used for glove and vision based classification.

\cite{mitraGestureRecognitionSurvey2007} surveyed the software and modelling
developments for human gesture recognition (including face and head tracking).
shortly after which \cite{dipietroSurveyGloveBasedSystems2008} described the
state of glove-based input and focused on how the technology has evolved,
providing a comprehensive summary of the different systems and how they compare
to one another.

Following 2008, there have been several smaller reviews of the literature
\footnote{\citealt{harshithSurveyVariousGesture2010, chenSurveyHandGesture2013,
raysarkarHandGestureRecognition2013, anwarHandGestureRecognition2019,
rashidWearableTechnologiesHand2019, chenSurveyHandPose2020,
kudrinkoWearableSensorBasedSign2021}}
however these reviews are often lacking the depth of prior work.

## Hardware Products \label{sec:03-hardware-products}

Commercially available hand-measurement gloves have historically been a strong
predictor of research into glove-based systems. Without affordable
off-the-shelf hand measurement gloves, the amount of research is limited by the
number of researchers who have expertise in both electronics and computer
science. This subsection explores hardware products which have been used for
glove-based gesture recognition. Figure \ref{fig:03_hardware_for_gloves} shows
the different kinds of hardware used over time for glove-based gesture
recognition systems.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/03_hardware_for_gloves}
    \caption[Hardware used for glove-based gesture recognition]{Different
    hardware used for glove-based systems. The Contactglove was used by
    \cite{felsGloveTalkIIaNeuralnetworkInterface1998}, the Technische
    Universität Berlin (TUB) Sensorglove by
    \cite{hofmannVelocityProfileBased1998}, and the Microsoft Band2 by
    \cite{liHandGestureRecognition2018}. The 5DT DataGlove refers to the
    glove developed by Fifth Dimension Technologies
    \citep{fifthdimensiontechnologies5DTHardware}.}
    \label{fig:03_hardware_for_gloves}
\end{figure}

The Computer Image Corporation of Denver, Colorado developed the Animac, an
archive of which is available via the
\citeauthor{experimentaltelevisioncenterComputerImageCorporation1969} (see
Figure \ref{fig:03_experimental_television_center_computer_1969}. The Animac
was later named the
[Scanimate](https://www.fondation-langlois.org/html/e/page.php?NumPage=442),
and between 1962 and 1971 it performed full-body position capture for use in
computer graphics. It did not have the fidelity for finger-level gesture
capture.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=0.5\textwidth]{src/imgs/03_experimental_television_center_computer_1969}
    \caption[The 1969 Animac system]{The Animac system
    \citep{experimentaltelevisioncenterComputerImageCorporation1969} by the
    Computer Image Corporation of Denver, Colorado.}
    \label{fig:03_experimental_television_center_computer_1969}
\end{figure}

The SayreGlove \citep{thomasa.defantiUSNEAR60341631977} is often cited as the
first glove-based system. It used a combination of optical tubes which occluded
light when bent and parallel conductive pads which touched and therefore
conducted electricity when bent to sense the movement of the user's hand.

Between the 1980s and the early 2000s there were three main commercially
available products: the PowerGlove developed by
\cite{abramsgentileentertainmentPowerGlove1989} for Nintendo, the DataGlove
developed by Visual Programming Languages (VPL)
\citep{sturmanSurveyGlovebasedInput1994}, and the CyberGlove by Immersion Inc\.
\citep{immersioncorporationCyberGlove2001}. These gloves were similar in
nature, using a combination of flex sensors over the knuckles and
accelerometers mounted on the back of the hands. They were occasionally used
with the Polhemus tracker\footnote{\citealt{fisherTelepresenceMasterGlove1987,
baudelCharadeRemoteControl1993, felsGloveTalkIIaNeuralnetworkInterface1998,
wilsonParametricHiddenMarkov1999, wengaoChineseSignLanguage2004}} which was a
device that mounted onto each glove and allowed the approximate location of the
glove in 3D space to be triangulated.

The Utah/M.I.T\.\footnote{Massachusetts Institute of Technology} Dexterous Hand
\cite{jacobsenUTAHDextrousHand1984} and the associated Utah/M.I.T\. Dexterous
HandMaster \citep{jacobsenDesignUtahDextrous1986} was a complex system that
included both a controller which sensed the position of a human hand through a
series of hall-effect sensors (the HandMaster) and a robotic hand which could
be controlled by this HandMaster.

\cite{marcusSensingHumanHand1988} used the VPL DataGlove to control the
Utah/MIT Dexterous Hand, followed by an independent study by
\cite{hongCalibratingVPLDataGlove1989} replicating their findings.

The Nintendo Wiimote was a cheap, commercially available game controller
developed in 2006 for the Nintendo Wii. It contained a 3-axis accelerometer and
so was used by several researchers to explore gesture recognition using the
acceleration data it provided\footnote{\citealt{
    kratzWiizards3DGesture2007,
    wuGestureRecognition3D2009,
    schlomerGestureRecognitionWii2008,
    liuUWaveAccelerometerbasedPersonalized2009,
    netoHighLevelProgramming2010,
    hamdyaliComparativeStudyUser2014}}.

The development of mobile devices with integrated accelerometer microchips also
inspired development, with several papers proposing systems where the user
would simply hold their smart phone
\citep{xieAccelerometerGestureRecognition2014}, smart watch
\citep{xuFingerwritingSmartwatchCase2015}, or Personal Digital Assistant (PDA,
\cite{kelaAccelerometerbasedGestureControl2006}) in their hand and perform a
gesture which would control the device.

The development of the MyoWare Armband resulted in several
papers\footnote{\citealt{vasconezHandGestureRecognition2022,
collialfaroUserIndependentHandGesture2022, zhangRealTimeSurfaceEMG2019}} using
the device for EMG measurements and gesture recognition, as did the Delsys
Myomonitor IV\footnote{\citealt{zhangHandGestureRecognition2009,
kimBichannelSensorFusion2008}}. Notably,
\cite{moinWearableBiosensingSystem2020} developed a custom sheet of very
densely clustered EMG sensors which wrapped around the forearm of the user and
could infer simple gestures, significantly surpassing the resolution of
previous systems.

While there have previously been many commercially available systems, there are
few affordable off-the-shelf options available in the 2020s. The development of
platforms such as Arduino and online hobby electronics forums have made
building a custom solution significantly more accessible. Recent researchers
are generally preferring to build their own systems\footnote{\citealt{
    harrisonOmniTouchWearableMultitouch2011,
    xuzhangFrameworkHandGesture2011,
    ammaAirwritingWearableHandwriting2014,
    whiteheadGestureRecognitionAccelerometers2014,
    galkaInertialMotionSensing2016,
    jiangDevelopmentRealtimeHand2016,
    wuWearableSystemRecognizing2016,
    leeSmartWearableHand2018,
    mummadiRealTimeEmbeddedDetection2018,
    leeDeepLearningBased2020,
    moinWearableBiosensingSystem2020}} due to the increased flexibility and low
start up cost.

## Algorithms Used For Gesture Recognition

Many different algorithms and statistical models have been used for gesture
recognition, although generally machine learning methods (and deep learning in
particular) have been used more and more successfully in recent years. Figure
\ref{fig:03_models_glove_based} shows the models used over time for glove-based
gesture recognition. All acronyms are defined in the List of Symbols.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/03_models_glove_based}
    \caption[Models used for glove-based gesture recognition]{Classification
    models used for glove-based gesture recognition. 13 models were only used
    once and have been excluded from this plot. All acronyms are defined in the
    List of Symbols.The highly-cited Decision tree paper is
    \cite{karantonisImplementationRealTimeHuman2006}, which used a
    waist-mounted tri-axis linear accelerometer to classify activities such as
    walking, sitting, standing, falling, and resting.}
    \label{fig:03_models_glove_based}
\end{figure}

Early on in the field, researchers extracted a custom-designed feature vector
from their data and trained a model on that feature vector. Following this,
Hidden Markov Models (HMMs) have been favoured due to their explicit encoding
of time-dependant data, and have been used by many papers for glove-based
gesture recognition\footnote{\citealt{
    kadousGRASPRecognitionAustralian1995,
    jong-sungkimDynamicGestureRecognition1996,
    liangSignLanguageRecognition1996,
    hofmannVelocityProfileBased1998,
    rung-hueiliangRealtimeContinuousGesture1998,
    wangchunliRealTimeLargeVocabulary2001,
    wangchunliRealTimeLargeVocabulary2002,
    mantyjarviEnablingFastEffortless2004,
    wengaoChineseSignLanguage2004,
    mantyjarviGestureInteractionSmall2005,
    pylvanainenAccelerometerBasedGesture2005,
    kratzWiizards3DGesture2007,
    prekopcsakAccelerometerBasedRealTime2008,
    schlomerGestureRecognitionWii2008,
    klingmannAccelerometerBasedGestureRecognition2009,
    wuGestureRecognition3D2009,
    kongGestureRecognitionModel2009,
    zhangHandGestureRecognition2009,
    bevilacquaContinuousRealtimeGesture2010,
    xuzhangFrameworkHandGesture2011,
    ammaAirwritingWearableHandwriting2014,
    hamdyaliComparativeStudyUser2014,
    whiteheadGestureRecognitionAccelerometers2014,
    marasovicMotionBasedGestureRecognition2015,
    galkaInertialMotionSensing2016,
    fatmiComparingANNSVM2019}}.
Other popular systems employed for gesture recognition have been Support Vector
Machines (SVMs)\footnote{\citealt{
    mohandesAutomationArabicSign2004,
    kimBichannelSensorFusion2008,
    wuGestureRecognition3D2009,
    prekopcsakAccelerometerBasedRealTime2008,
    mohandesRecognitionTwoHandedArabic2013,
    ammaAirwritingWearableHandwriting2014,
    hamdyaliComparativeStudyUser2014,
    xieAccelerometerGestureRecognition2014,
    wuWearableSystemRecognizing2016,
    kunduHandGestureRecognition2018,
    leeSmartWearableHand2018,
    mummadiRealTimeEmbeddedDetection2018,
    fatmiComparingANNSVM2019,
    wongMultiFeaturesCapacitiveHand2021,
    collialfaroUserIndependentHandGesture2022}},
Dynamic Time Warping (DTW)\footnote{\citealt{
    wuGestureRecognition3D2009,
    aklNovelAccelerometerBasedGesture2011,
    sethujanakiRealTimeRecognition2013,
    wangUserindependentAccelerometerbasedGesture2013,
    hamdyaliComparativeStudyUser2014,
    marasovicMotionBasedGestureRecognition2015,
    patilHandwritingRecognitionFree2016,
    liHandGestureRecognition2018}},
and k-Nearest Neighbours (kNN)\footnote{\citealt{
    kimBichannelSensorFusion2008,
    sethujanakiRealTimeRecognition2013,
    hamdyaliComparativeStudyUser2014,
    wuWearableSystemRecognizing2016,
    liHandGestureRecognition2018,
    wongMultiFeaturesCapacitiveHand2021,
    alzubaidiNovelAssistiveGlove2023}}.

\cite{murakamiGestureRecognitionUsing1991} was the first to use Neural Networks
for gesture recognition, and used a recurrent neural network to
classify a dataset of 42 classes. The recent increase in computational power
has allowed neural networks and their variants to be fully utilised for
glove-based gesture recognition: Feed-Forward Neural Networks (FFNNs)
\footnote{\citealt{
    jong-sungkimDynamicGestureRecognition1996,
    felsGloveTalkIIaNeuralnetworkInterface1998,
    damasioAnimatingVirtualHumans2002,
    mehdiSignLanguageRecognition2002,
    netoHighLevelProgramming2010,
    hamdyaliComparativeStudyUser2014,
    fatmiComparingANNSVM2019,
    zhangRealTimeSurfaceEMG2019,
    vasconezHandGestureRecognition2022}},
Recurrent Neural Networks (RNNs)\footnote{\citealt{
    murakamiGestureRecognitionUsing1991,
    wengaoChineseSignLanguage2004,
    riveraRecognitionHumanHand2017,
    kochRecurrentNeuralNetwork2019,
    yuanHandGestureRecognition2020,
    makaussovLowCostIMUBasedRealTime2020,
    zhangStackedLSTMBasedDynamic2021}},
Convolutional Neural Networks (CNNs)\footnote{\citealt{
    maHandGestureRecognition2017,
    wenMachineLearningGlove2020,
    yuanHandGestureRecognition2020}},
and Self-Organising Feature Maps (SOMs, \cite{wengaoChineseSignLanguage2004})
have all shown good results.

HMMs have been used by Chunli and Wen to classify thousands of unique gestures
from Chinese Sign Language between 2001 and 2004: 4800 in
\citep{wangchunliRealTimeLargeVocabulary2001}, 5100 in
\citep{wangchunliRealTimeLargeVocabulary2002} , and 5113 in
\cite{wengaoChineseSignLanguage2004}. To accomplish this,
\cite{wengaoChineseSignLanguage2004} applied a multi-stage approach, where a
SOM was used to reduce the dimensionality of the input data, a simple Recurrent
Neural Network was used to detect if there was a gesture in a particular
observation, and then (conditional on a positive detection) a set of 5113 HMMs
were used to recognise which gesture was in that observation. They applied a
heavily modified version of the Viterbi algorithm (which they named the
"lattice" Viterbi Algorithm) to efficiently evaluate the log-likelihood of the
thousands of HMMs.

# Vision- and WiFi-based Gesture Recognition \label{sec:03-vision-and-wifi-based-gesture-recognition}

This section focuses on vision-based gesture recognition using visible light
and depth data, and WiFi-based gesture recognition using the effect the human
body has on diagnostic information collected in WiFi networks. As this thesis
is primarily concerned with glove-based gesture recognition, the interested
reader is directed to recent review papers of vision-based
systems\footnote{\citealt{rautarayVisionBasedHand2015,
cheokReviewHandGesture2019, oudahHandGestureRecognition2020}} (which cited
between 100 and 270 papers) and WiFi-based systems\footnote{\citealt{
maSurveyWiFiBased2016, maWiFiSensingChannel2020,
hussainReviewCategorizationTechniques2020, wangCSIbasedHumanSensing2021}}
(which cited between 100 and 150 papers)

**How vision-based systems work** Vision-based systems collect videos using the
visible light spectrum (and sometimes also depth information using LiDAR). The
field has evolved with improved hardware: modern systems\footnote{\citealt{
sharmaASL3DCNNAmericanSign2021, chatzisComprehensiveStudyDeep2020,
chenSurveyHandPose2020, hurrooSignLanguageRecognition2020,
oudahHandGestureRecognition2020, zhangGestureRecognitionBased2020,
liuDynamicGestureRecognition2021, mujahidRealTimeHandGesture2021,
qiMultiSensorGuidedHand2021, sahooRealTimeHandGesture2022,
urrehmanDynamicHandGesture2022}} often have colour and
depth information, higher-resolution images, and more frames per second than
older systems\footnote{\citealt{
boltPutthatthereVoiceGesture1980, davisVisualGestureRecognition1994,
eickelerHiddenMarkovModel1998, freemanOrientationHistogramsHand1995,
hofmannVelocityProfileBased1998, hyeon-kyuleeHMMbasedThresholdModel1999,
jenningsComputergraphicModelingAnalysis1988, laviolaSurveyHandPosture1999,
ming-hsuanyangRecognizingHandGesture1999, moeslundComputerVisionBasedHuman1999,
moeslundSummaries107Computer1999, myronw.kruegerArtificialRealityII1991,
pavlovicVisualInterpretationHand1997, rigollHighPerformanceRealtime1998,
segenFastAccurate3D1998, segenHumancomputerInteractionUsing1998,
sharmaMultimodalHumancomputerInterface1998, starnerRealtimeAmericanSign1995,
starnerRealtimeAmericanSign1998, starnerVisualRecognitionAmerican1995,
watsonSurveyGestureRecognition1993, wilsonParametricHiddenMarkov1999,
yamatoRecognizingHumanAction1992}}.

**How WiFi-based systems work** The technology enabling gesture recognition
with WiFi was implemented in the IEEE 802.11n standard, released in 2009
\citep{IEEEStandardInformation2009a}. This standard introduced Channel State
Information (CSI) which provided significantly more diagnostics information
about the noise in an environment than was previously available. The intended
use case of CSI is to allow transmitters in a WiFi network to change how they
transmit data based on the current channel conditions, facilitating more
reliable communication. Since CSI is very sensitive to the surrounding
environment, small changes such as a person typing at a
keyboard\footnote{\citealt{liWhenCSIMeets2016,
aliRecognizingKeystrokesUsing2017, shenWiPassCSIbasedKeystroke2020}}, or even
breathing\footnote{\citealt{liuWiSleepContactlessSleep2014,
wangHumanRespirationDetection2016, wuNonInvasiveDetectionMoving2015}} can cause
a change in the CSI, which can then be inferred using modern machine learning
techniques.

**Datasets** Both vision\footnote{\citealt{guyonChaLearnGestureChallenge2012,
materzynskaJesterDatasetLargeScale2019, zhangEgoGestureNewDataset2018}}- and
WiFi-based\footnote{\citealt{alazraiDatasetWiFibasedHumantohuman2020}} systems
have seen the benefit of standardised hardware that enables the creation of
high-quality and diverse datasets of gestures being performed and recorded on
relevant hardware. These datasets promote research in the field, as they
provide a common baseline against which new algorithms can be tested.

**Chronology** Figure \ref{fig:03_models_no_gloves} shows the models used over
time for vision- and WiFi-based gesture recognition. Vision based systems have
been investigated since the 1980s\footnote{\citealt{
boltPutthatthereVoiceGesture1980, jenningsComputergraphicModelingAnalysis1988,
myronw.kruegerArtificialRealityII1991}} but the first working system was
\cite{yamatoRecognizingHumanAction1992} which recognised human actions using an
HMM trained to recognise feature vectors.
\cite{starnerRealtimeAmericanSign1995} were the first to use vision-based
systems to recognise sign language gestures, using HMMs to recognise 40 signs
from the American Sign Language. Due to the computational power available at
the time, the user had to wear brightly coloured gloves to aid in hand
detection and the system ran at 5 frames per second. HMMs paired with some form
of manual feature extraction would remain the favoured modelling technique for
vision-based systems for many years to come\footnote{\citealt{
yamatoRecognizingHumanAction1992, starnerRealtimeAmericanSign1995,
starnerVisualRecognitionAmerican1995, eickelerHiddenMarkovModel1998,
rigollHighPerformanceRealtime1998, starnerRealtimeAmericanSign1998,
hyeon-kyuleeHMMbasedThresholdModel1999, wilsonParametricHiddenMarkov1999,
yoonHandGestureRecognition2001, chenHandGestureRecognition2003,
keskinRealTimeHand2003, ramamoorthyRecognitionDynamicHand2003,
zhangVisionbasedSignLanguage2004, binhRealTimeHandTracking2005,
elmezainGestureRecognitionAlphabets2007, elmezainRealTimeCapableSystem2008,
elmezainHandGestureRecognition2009, naidooSouthAfricanSign2010,
yangDynamicHandGesture2012, frieslaarRobustSouthAfrican2014,
ghotkarDynamicHandGesture2016, wuDeepDynamicNeural2016,
zhaoRealtimeHeadGesture2017}}.

\begin{figure}[!ht]
    \centering
    \includegraphics[width=\textwidth]{src/imgs/graphs/03_models_no_gloves}
    \caption[Models used for vision- and WiFi-based gesture recognition]{Models
    used for recognising gestures in vision- and WiFi-based
    systems over time. PCA stands for Principal Component Analysis.}
    \label{fig:03_models_no_gloves}
\end{figure}

\cite{halperinToolReleaseGathering2011} published a tool which provided a
detailed picture of the wireless channel conditions using CSI information. The
release of this tool made apparent the sensitivity of CSI to changes in the
environment. Adib and Katabi first applied the data available in CSI to
recognise human gestures \citep{adibSeeWallsWiFi2013} and were followed by
papers investigating many diverse applications such as breathing
detection\footnote{\citealt{ liuWiSleepContactlessSleep2014,
wuNonInvasiveDetectionMoving2015, wangHumanRespirationDetection2016}}, sign
language recognition\citep{liWiFingerTalkYour2016}, fall
detection\footnote{\citealt{wangRTFallRealTimeContactless2017,
wangWiFallDeviceFreeFall2017}}, distinguishing different people from one
another based on their movement or gait\footnote{\citealt{
wangGaitRecognitionUsing2016, zengWiWhoWiFiBasedPerson2016,
zhangWiFiIDHumanIdentification2016}}, keystroke and password
inference\footnote{\citealt{liWhenCSIMeets2016,
aliRecognizingKeystrokesUsing2017, shenWiPassCSIbasedKeystroke2020}}, sleep
detection \citep{liuWiSleepContactlessSleep2014}, speech recognition
\citep{wangWeCanHear2014}, and the monitoring of vital signs
\citep{liuTrackingVitalSigns2015}.

Convolutional Neural Networks (CNNs) were first used for gesture recognition in
2015 by \cite{jiehuangSignLanguageRecognition2015} and neural network based
models have been used by many researchers for gesture
recognition\footnote{\citealt{jiehuangSignLanguageRecognition2015,
wuDeepDynamicNeural2016, hakimDynamicHandGesture2019,
kopukluRealtimeHandGesture2019, luOneshotLearningHand2019,
mohammedDeepLearningBasedEndtoEnd2019, funkeUsing3DConvolutional2019,
hurrooSignLanguageRecognition2020, zhangGestureRecognitionBased2020,
sharmaASL3DCNNAmericanSign2021, liuDynamicGestureRecognition2021,
mujahidRealTimeHandGesture2021, sahooRealTimeHandGesture2022,
urrehmanDynamicHandGesture2022}}.

The applications of vision-based gesture recognition have been less varied than
those of WiFi-based gesture recognition, with an emphasis on sign
language\footnote{\citealt{starnerRealtimeAmericanSign1995,
starnerVisualRecognitionAmerican1995, starnerRealtimeAmericanSign1998,
ming-hsuanyangRecognizingHandGesture1999, bowdenVisionBasedInterpretation2003,
chenHandGestureRecognition2003, bowdenLinguisticFeatureVector2004,
kadirMinimalTrainingLarge2004, zhangVisionbasedSignLanguage2004,
binhRealTimeHandTracking2005, nelIntegratedSignLanguage2013,
jiehuangSignLanguageRecognition2015, ghotkarDynamicHandGesture2016,
elbadawyArabicSignLanguage2017, liang3DConvolutionalNeural2018,
avolaExploitingRecurrentNeural2019, bhagatIndianSignLanguage2019,
hurrooSignLanguageRecognition2020, sharmaASL3DCNNAmericanSign2021,
sahooRealTimeHandGesture2022}}. Other applications have included
augmented/virtual reality\footnote{\citealt{buchmannFingARtipsGestureBased2004,
sagayamHandPostureGesture2017}}, video game
control\footnote{\citealt{freemanOrientationHistogramsHand1995,
marceloGeFightersExperimentGesturebased2006}}, generic gesture recognition
\citep{ahujaHandGestureRecognition2015}, various medical
applications\footnote{\citealt{wanExploreEfficientLocal2016,
funkeUsing3DConvolutional2019}}, and remote robot control\footnote{\citealt{
ramamoorthyRecognitionDynamicHand2003, wanExploreEfficientLocal2016,
qiMultiSensorGuidedHand2021}}.
