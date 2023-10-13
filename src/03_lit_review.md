This chapter reviews the literature as related to human hand gesture
recognition. There are three primary methods of sensing the movement of a user's
hands: glove-based, vision-based, and (most recently) WiFi-based.

This review is divided into four sections. The first (Section \ref{overview})
will provide an overview of the field and some important metrics which will be
used to compare different works. The second (Section
\ref{glove-based-gesture-recognition}) discusses glove-based gesture
recognition, and contains the most detail as the subject of this thesis is a
glove-based system for gesture recognition. The third section (Section
\ref{vision--and-wifi-based-gesture-recognition}) will cover other means of
gesture recognition that do not use a physical glove of some sort, namely
vision-based and WiFi-based. The fourth section (Section
\ref{applications-of-gesture-recognition}) will discuss how gesture recognition
has been used over the decades and how that has affected its development.

The topic of gesture recognition touches upon many diverse fields from the
electromagnetic spectrum to computer science to anatomy. The relevant concepts
will be given a brief explanation when they are first mentioned, but the reader
is guided towards the Glossary of Terms (Section \ref{glossary-of-terms}) for a more
thorough description.

<!---
TODO:
- This lacks the alpha that some tikz diagrams will provide

Notes from Trienko meeting:
- Use the harvard referencing style
  - Can't use too many long lists of references. Either have a few references,
    or refer to a table
- Need to somewhere discuss what a swarm plot is and the methodology behind how
  it is generated.
- Need to reference the figures in the text and give stand alone captions
- It seems like the papers which are discussed are a bit arbitrary. Should
  explicitly say that the papers which represent a change in the state of the
  art. This should be done across the different metrics
- Should colour/label/marker the papers which get explicitly referenced
- Need to make the colouring of vision/glove/wifi consistent
- Need to explicitly mention how much of an outlier the 5113 class HMM paper
  is.
- Sometimes paragraphs kinda say the same thing, try to avoid duplicating this.
- Try to really cleanly separate the different metrics: hardware etc
- Have to put in a paragraph "many ML approaches are referenced in this review,
  but are not in the background chapter. The reader is referred to external
  reviews X, Y, Z. Note that all approaches implemented in the thesis are
  discussed in the background"
- Include a section which describes each of the different hardware items and
  the different technology items
  - Probably in a table, in the glossary (?)
- Some papers have multiple technologies: Should clarify this by using
  different colours/styles/markers
- In the lit review: describe
- In the methodology: Need to explicitly describe why building a new glove is
  not really an option and why building a custom glove enabled greater
  fidelity.
--->

## Overview

Automatic gesture recognition has gone through several periods since the first
attempts in the 1970s, however there are a few themes which have survived
throughout. The field has largely evaded a well-established
terminology, with different terms being defined for different concepts based on
the requirements at hand. Nonetheless, these differing definitions are often
guided by similar intuition and so do not result in significant conflict with
one another. Where confusion may arise, reference will be made to the existing
terminology before defining what will be used in this review.

Over the years, numerous authors have published a wide range of gesture
recognition systems, each dealing with slightly different challenges in their
unique ways. This diversity makes it tricky to compare the various research
papers. To address this, this review will use several metrics to allow for a
systematic comparison of different works in the field. The tasks tackled by
different authors may sound similar, but they vary significantly in difficulty.
Note that not all authors publicise enough data to describe every metric, and
some papers might have tested multiple systems, resulting in multiple metrics
recorded for that paper.

The metrics are listed below, with short explanations. More detailed
explanations are also given for the metrics which require them.

**Glove/vision/wifi based** There are (broadly speaking) three main categories
of gesture capture systems: Glove-based, Vision-based, and (most recently)
WiFi-based. Glove-based systems have some instrument physically connected to
the person's hands or forearms. Vision-based systems use cameras to capture the
colour (and possibly also depth) information of the person performing the
gesture. WiFi-based systems are a relatively new development, and use the noise
present in WiFi signals to infer the position of the human body.

**Technology used** This refers to the underlying technology that enables data
collection, for example: flexion sensors, accelerometers, electromyography, or
RGB cameras with depth information.

**Number of classes** The number of classes classified by the system. This is
often 26 (one class for each letter _a_ through _z_) or 36 (the letters _a_ through _z_
and the numerals _0_ through _9_).

**Number of participants** The total number of people who contributed gesture
data to the entire dataset, before the dataset is split into
training/validation/testing subsets. One person recording data in different
locations or on different days is still considered as one person.

**Number of repetitions** The number of observations recorded by each person
for each class. Papers which attempted one-shot learning often only recorded
one repetition for each class.

**Model(s) used** The type of model used to classify the data. Multiple models
can be recorded for each paper, and this is often the case for papers comparing
different classification methods. When a paper used a derivation of a commonly
used model, then the commonly used model is recorded.

**Hardware used** This is the pre-built hardware used to collect the data. For
example, this might be the Microsoft Kinect or the Nintendo PowerGlove.

**Gestures vs postures** A "gesture" is often used to mean a movement of one or
two hands. This review uses the term "gesture" to cover both static and dynamic
hand movements, with the clarification of "dynamic gesture" or "static gesture"
when confusion could arise. Gestures shall also be assumed to be of the hands
and fingers (and not of the arms or body) unless explicitly noted.

**Gesture fidelity** The granularity or level-of-detail of the gesture. The
ability to recognise someone waving their arms in the air is very different
from the ability to distinguish the dexterous movements required while typing.

The fidelity of a gesture is not often reported directly, despite having great
impact on the difficulty of the problem being attempted. A high-fidelity
gesture would be one which requires the precise control of the user's fingers
or thumbs (such as tapping fingertips together), while a medium-fidelity
gesture would require only the movement of the hand (such the "royal wave"
which doesn't move the arm). A low-fidelity gesture would only require movement
of the whole arm, such as a shaking-of-fists. Higher fidelity gestures are
generally a lot trickier to measure accurately as there are greater degrees of
freedom involved and the absolute amount of motion is less. For ease of
comparison, this review categorises fidelity into three levels:
finger-fidelity, hand-fidelity, and arm-fidelity.

**Explicit and implicit segmentation** Explicit segmentation is where the
continuous time series of data has been segmented such that the start and end
of each gesture is provided to the model. This might be done by marking the
continuous time series and providing those markings to the model, or it might
be done by only training the model on the portions of the time series which
contain gestures. Implicit segmentation requires that the classifier first
detect which observations have gestures and then recognise which gestures are
in those observations.

Gesture _detection_ can be defined as the boolean classification task of
identifying whether any gesture is present in some data sample. Gesture
_recognition_ can be defined as the multi-class classification problem of
identifying _which_ gesture is present in some data sample. Note that a gesture
recognition system could be trained to recognise the lack of a gesture as
itself being a kind of "null" gesture, and so gesture recognition is a
generalisation of gesture detection.

The distinction between detection and recognition will prove useful, as there
have been a number of papers which either 1) train a two-stage system where the
gesture recogniser is only invoked upon successful gesture detection or 2)
completely exclude the task of gesture detection and only train a gesture
recognition system. Some papers only attempt gesture recognition of known
gestures, while other papers attempt both the detection of gestures in a
continuous time series as well as the recognition of those gestures.

Note that only attempting gesture recognition (which assumes every observation
is a valid gesture) drastically reduces the practicality of the developed
model, as any real-world system would need some way to eliminate the portions
of the dataset which do not contain any gestures.

## Glove-based Gesture Recognition

Glove-based gesture recognition can be defined as any gesture recognition
system which gathers hand information using a device physically attached to the
user's hands or upper arms. First the technologies used in building the gloves
will be discussed (Subsection \ref{technologies-used}). Then an overview of the
seminal papers and larger surveys will be provided (Subsection
\ref{landmark-papers}). The hardware products produced (and sometimes sold
commercially) will be discussed in subsection \ref{hardware-products}. Datasets
used in glove-based systems (or the lack thereof) will be discussed in
Subsection \ref{datasets}. Finally, Subsection
\ref{models-and-recognition-techniques} reviews the different models and
recognition techniques used for glove-based gesture recognition.

### Technologies Used

Different electronic and mechanical technologies have been used over the
decades to instrument the movement of a user's hand or hands. The movement
captured by each system is necessarily limited to one of the following: 1) the
angle between two bones at some joint, 2) the physical touching of two parts of
the hand, 3) the orientation of some part of the hand, or 4) the acceleration
of some part of the fingers. Measuring the angle between two bones has
typically either involved placing a strip of material across the joint and
measuring the stretching of that material, or placing a device capable of
measuring rotation at the axis of rotation of the joint. This subsection will
solely look at technologies used to sense changes in hand or arm position and
collection of the data. Discussion of how that data is classified will be done
in subsection \ref{models-and-recognition-techniques}.

Early glove-based systems often used hand crafted sensors (presumably due to a
lack of cheap electronic sensors at the time) such as optical tubes which
occluded light when bent [@thomasa.defantiUSNEAR60341631977] or flexion sensors
where two parallel conductive metal strips touched when bent
[@garyj.grimesUSPatentDigital1981]. Hall-effect sensors were used by some
authors [@jacobsenDesignUtahDextrous1986; @jacobsenUTAHDextrousHand1984;
@marcusSensingHumanHand1988] to measure the rotation of different joints.

Commercially available flex sensors (which measure the bend of a short plastic
strip) were first placed across joints and used successfully in the late 1980s
and early 1990s [@abramsgentileentertainmentPowerGlove1989;
@baudelCharadeRemoteControl1993; @felsGloveTalkIIaNeuralnetworkInterface1998;
@zimmermanHandGestureInterface1987]. Flex sensors are unable to accurately
measure very acute angles (such as those between fingers) but are very
intuitive to use, so would see use in commercial applications like the
CyberGlove [@immersioncorporationCyberGlove2001], the PowerGlove
[@abramsgentileentertainmentPowerGlove1989], and the DataGlove by VPL
[@sturmanSurveyGlovebasedInput1994]. They have since been used in many papers
due to their interpretability and relatively low cost
[@alviPakistanSignLanguage2007; @atzoriNinaproDatabaseResource2015;
@baudelCharadeRemoteControl1993; @feinerVisualizingDimensionalVirtual1990;
@felsBuildingAdaptiveInterfaces1990;
@felsGloveTalkIIaNeuralnetworkInterface1998;
@frankhofmannSensorGloveAnthropomorphicRobot1995;
@heumerGraspRecognitionUncalibrated2007; @immersioncorporationCyberGlove2001;
@kadousGRASPRecognitionAustralian1995;
@kesslerEvaluationCyberGloveWholehand1995; @laviolaSurveyHandPosture1999;
@leeDeepLearningBased2020; @leeSmartWearableHand2018;
@liangSignLanguageRecognition1996; @mardiyantoDevelopmentHandGesture2017;
@murakamiGestureRecognitionUsing1991;
@rung-hueiliangRealtimeContinuousGesture1998; @takahashiHandGestureCoding1991;
@wenMachineLearningGlove2020; @wiseEvaluationFiberOptic1990;
@yuanHandGestureRecognition2020]. They are discussed in more detail in subsection
\ref{hardware-products}.

Accelerometers measure linear acceleration in up to three axes. Inertial
Measurement Units (IMUs) can measure linear and rotational acceleration,
although the exact details about what is measured often depend on the product
being used. When attached to the user's hand, accelerometers and IMUs provide
low-noise acceleration data which can be used for gesture recognition. Many
mobile devices (such as phones, game controllers, smart watches) contain either
an IMU or an accelerometer and so provide an easily available means of
measuring acceleration while a user holds their device and performs a gesture.

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_tech_for_gloves.pdf}
\caption{Different technologies used for glove-based systems.}
\label{fig:03_tech_for_gloves}
\end{figure}

Accelerometers were first used by Fukumoto and Tonomura in 1997
@fukumotoBodyCoupledFingerRing1997, who mounted them in rings worn at the base
of the user's fingertips. These accelerometers measured the jerk caused when
the user tapped their fingers against a table or flat surface, and mapped the
amount of jerk in certain fingers to certain keystrokes. Acceleration sensors became popular
for gesture recognition due to their small size and interpretability
[@aklAccelerometerbasedGestureRecognition2010;
@aklNovelAccelerometerBasedGesture2011; @alviPakistanSignLanguage2007;
@alzubaidiNovelAssistiveGlove2023; @ammaAirwritingWearableHandwriting2014;
@atzoriNinaproDatabaseResource2015; @bevilacquaContinuousRealtimeGesture2010;
@galkaInertialMotionSensing2016; @hamdyaliComparativeStudyUser2014;
@hernandez-rebollarAcceleGloveWholehandInput2002;
@heumerGraspRecognitionUncalibrated2007;
@karantonisImplementationRealTimeHuman2006;
@kelaAccelerometerbasedGestureControl2006; @kimBichannelSensorFusion2008;
@klingmannAccelerometerBasedGestureRecognition2009;
@kochRecurrentNeuralNetwork2019; @kongGestureRecognitionModel2009;
@kratzWiizards3DGesture2007; @kunduHandGestureRecognition2018;
@leeSmartWearableHand2018; @liHandGestureRecognition2018;
@liuUWaveAccelerometerbasedPersonalized2009;
@makaussovLowCostIMUBasedRealTime2020; @mantyjarviEnablingFastEffortless2004;
@mantyjarviGestureInteractionSmall2005;
@mantyjarviIdentifyingUsersPortable2005;
@marasovicMotionBasedGestureRecognition2015;
@mardiyantoDevelopmentHandGesture2017; @mummadiRealTimeEmbeddedDetection2018;
@netoHighLevelProgramming2010; @parsaniSingleAccelerometerBased2009;
@patilMarathiSignLanguage2022; @pylvanainenAccelerometerBasedGesture2005;
@raysarkarHandGestureRecognition2013;
@rekimotoGestureWristGesturePadUnobtrusive2001;
@schlomerGestureRecognitionWii2008; @sethujanakiRealTimeRecognition2013;
@songAntLearningAlgorithm2013; @tuulariSoapBoxPlatformUbiquitous2002;
@wangTrafficPoliceGesture2008;
@wangUserindependentAccelerometerbasedGesture2013;
@whiteheadGestureRecognitionAccelerometers2014; @wuGestureRecognition3D2009;
@wuWearableSystemRecognizing2016; @xieAccelerometerGestureRecognition2014;
@xuzhangFrameworkHandGesture2011; @zhangHandGestureRecognition2009;
@zhangStackedLSTMBasedDynamic2021].

Surface Electromyography (EMG) measures the electrical impulses of a user's
muscles through two or three conductive pads attached to the user's bare skin.
This method generally results in a very noisy signal and does not have the
interpretability of a flex sensor. This often means a more powerful machine
learning technique is required in order to classify the data. Many systems have
used EMG [@atzoriNinaproDatabaseResource2015;
@collialfaroUserIndependentHandGesture2022; @jiangDevelopmentRealtimeHand2016;
@kimBichannelSensorFusion2008; @kochRecurrentNeuralNetwork2019;
@kunduHandGestureRecognition2018; @moinWearableBiosensingSystem2020;
@vasconezHandGestureRecognition2022; @wuWearableSystemRecognizing2016;
@xuzhangFrameworkHandGesture2011; @zhangHandGestureRecognition2009;
@zhangRealTimeSurfaceEMG2019] with a general overview of the field given by
Asghari and Hu's survey in 2007 @asgharioskoeiMyoelectricControlSystems2007.

After the introduction of acceleration and EMG sensors to the field of gesture
recognition, there are a few papers [@ammaAirwritingWearableHandwriting2014;
@leeSmartWearableHand2018; @liHandGestureRecognition2018;
@wuWearableSystemRecognizing2016] which combine the two in a technique often
called "sensor-fusion" to gain better recognition results than either sensor in
isolation.

The changing capacitance of the body has also been used to recognise gestures
[@rekimotoGestureWristGesturePadUnobtrusive2001;
@wongMultiFeaturesCapacitiveHand2021]. Rekimoto
[@rekimotoGestureWristGesturePadUnobtrusive2001] achieved this by using a
bracelet-like device which measures how the capacitance through the upper
forearm changed as the user's muscles moved their fingers.

Wen \emph{et~al.} @wenMachineLearningGlove2020 used triboelectric textile
sensors to measure the stretch of a textile glove.

### Landmark Papers

The inaugural investigation into glove-based input was undertaken by Sturman
and Zeltzer in 1994 @sturmanSurveyGlovebasedInput1994 (following Sturman's
dissertation on whole-hand input @sturmanWholehandInput1992 ). Sturman and
Zeltzer's survey comprehensively examined the predominant glove-based systems
that were accessible during that period and delves into their respective
applications. Regrettably, the primary accounts concerning these systems have
succumbed to the passage of time, often rendering Sturman and Zeltzer's work as
the sole surviving repository of knowledge on the state of the field during
that time.

Following @sturmanSurveyGlovebasedInput1994 the interest in hand gesture
recognition increased significantly, prompting the survey by LaViola in 1999
@laviolaSurveyHandPosture1999 which discussed the models and techniques used
for glove and vision based classification, a perspective not present in
@sturmanSurveyGlovebasedInput1994.

In 2007, Mitra and Acharya @mitraGestureRecognitionSurvey2007 surveyed the
software and modelling developments for human gesture recognition (including
face and head tracking).

Shortly after @mitraGestureRecognitionSurvey2007, Dipietro \emph{et~al.}
@dipietroSurveyGloveBasedSystems2008 described the state of glove-based input
and focused on how the technology has evolved, providing a comprehensive
summary of the different systems and how they compare to one another.

Following 2008, there have been several smaller reviews of the literature
[@anwarHandGestureRecognition2019; @chenSurveyHandGesture2013;
@chenSurveyHandPose2020; @harshithSurveyVariousGesture2010;
@kudrinkoWearableSensorBasedSign2021; @rashidWearableTechnologiesHand2019;
@raysarkarHandGestureRecognition2013] however these reviews are often lacking
the depth of prior work.

<!---
TODO probably should include a graph of surveys over time, split by
glove/vision/wifi or something. Or maybe a graph of paper types over time, just
for glove-based systems
--->

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_based_on_over_time.pdf}
\caption{Trend of glove/vision/WiFi based systems over time}
\label{fig:03_based_on_over_time}
\end{figure}

### Hardware Products

Commercially available gloves which can measure the movement of a user's hands
often result in research using those gloves, as the researchers capable of
purchasing a glove-based system are a strict subset of researchers capable of
designing and building a glove-based system. This subsection explores hardware
products which have been used for glove-based gesture recognition.

The Computer Image Corporation of Denver, Colorado developed the ANIMAC
@experimentaltelevisioncenterComputerImageCorporation1969 (later named the
[Scanimate](https://www.fondation-langlois.org/html/e/page.php?NumPage=442))
between 1962 and 1971 which performed full body capture for use in computer
graphics, but did not have the fidelity for finger-level gesture capture.

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/03_experimental_television_center_computer_1969.jpg}
\caption{The ANIMAC system.}
\label{fig:03_experimental_television_center_computer_1969}
\end{figure}

The SayreGlove [@thomasa.defantiUSNEAR60341631977] is often credited as the
first glove-based system developed. It used a combination of optical tubes
which occluded light when bent and parallel conductive pads which touched and
therefore conducted electricity when bent to sense the movement of the user's
hand.

In the 1990s there were three main commercially available products: The
DataGlove developed by Visual Programming Languages (VPL)
[@sturmanSurveyGlovebasedInput1994], the PowerGlove developed Abrams Gentile
Entertainment for Nintendo [@abramsgentileentertainmentPowerGlove1989], and the
CyberGlove by Immersion Inc [@immersioncorporationCyberGlove2001]. These gloves
were similar in nature, with some combination of flex sensors over the
phalanges and accelerometers mounted on the back of the hands.

The Utah/MIT Dexterous Hand [@jacobsenUTAHDextrousHand1984] and the associated
Utah/MIT Dexterous HandMaster [@jacobsenDesignUtahDextrous1986] was a complex
system that included both a controller which sensed the position of a human
hand through a series of hall-effect sensors (the HandMaster) and a robotic
hand which could be controlled by this HandMaster.

Marcus and Churchill used the VPL DataGlove to control the Utah/MIT Dexterous
Hand in 1988 @marcusSensingHumanHand1988, followed by Hong and Tan
@hongCalibratingVPLDataGlove1989 accomplishing the same task in 1989.

The Nintendo Wii Remote (often called the Wiimote) was a cheap, commercially
available game controller developed in 2006 for the Nintendo Wii. It contained
a 3-axis accelerometer and so was used by several researchers to explore
gesture recognition using the acceleration data it provided
[@kratzWiizards3DGesture2007; @netoHighLevelProgramming2010;
@schlomerGestureRecognitionWii2008].

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_hardware_for_gloves.pdf}
\caption{Different hardware used for glove-based systems}
\label{fig:03_hardware_for_gloves}
\end{figure}

The development of mobile devices with integrated IMU microchips also inspired
development, with several papers proposing systems where the user would simply
hold their smart phone [@xieAccelerometerGestureRecognition2014], smart watch
[@xuFingerwritingSmartwatchCase2015], or Personal Digital Assistant (PDA)
[@kelaAccelerometerbasedGestureControl2006] in their hand and perform a gesture
which would control the device.

The development of the MyoWare Armband resulted in several papers
[@vasconezHandGestureRecognition2022;
@collialfaroUserIndependentHandGesture2022; @zhangRealTimeSurfaceEMG2019] using
the device for EMG measurements and gesture recognition, as did the Delsys
Myomonitor IV [@zhangHandGestureRecognition2009;
@kimBichannelSensorFusion2008]. Notably, in 2020 Moin \emph{et~al.}
@moinWearableBiosensingSystem2020 developed a custom sheet of very densely
clustered EMG sensors which wrapped around the forearm of the user and could
infer simple gestures, significantly surpassing the resolution of previous
systems.

### Datasets

There is a lack of commonly used datasets for glove-based systems due to the
lack of commonly used hardware solutions. Some researchers have recently
started making their datasets and code public in the interest of
reproducibility. However, there are no datasets in common use as it is often
easier to develop custom hardware than to try and recreate another researcher's
hardware. Much of the existing hardware used for glove-based systems have
significant flaws, and these flaws incentivise the development of new hardware
and new datasets. It is likely that commonly used datasets will only become
widely used if the state of the hardware used to create those datasets settles.

The widespread adoption of some standard glove-based system would likely
accelerate the development of superior gesture recognition systems, as curious
researchers would not have to create the hardware themselves but would be able
to focus on creating the classification models. This has already occurred in
vision-based systems, where there now exist widely used datasets recorded on
standard and easily available hardware (see subsection
\ref{vision--and-wifi-based-gesture-recognition}).

While commercially available systems do exist, they are largely aimed
at industrial applications and are generally too costly for exploratory
research. It is unlikely for glove-based datasets to become commonly used until
a glove-based system becomes commonly used, and that will require the
glove-based system to be easy to build, cost effective, and applicable to a
wide range of different applications. The SoapBox
[@tuulariSoapBoxPlatformUbiquitous2002] was proposed as such a device, but it
did not receive widespread adoption.

### Models and Recognition Techniques

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_models.pdf}
\caption{Models used for gesture recognition}
\label{fig:03_models}
\end{figure}

Different techniques have been applied to recognise gestures. The exact
application of the model depends on the dataset collected, however some high
level trends can be noticed. The datasets being classified often take the form
of a multi-dimensional time series.

Early on in the field, many researchers extracted a custom-designed feature
vector from their data and trained a model on that feature vector. This
approach has recently fallen out of favour, with many recent papers using a
variety of deep learning based methods to learn features implicitly.

Hidden Markov Models (HMMs) have often been favoured due to their explicit
encoding of time-dependant data, and have been used by many papers for
glove-based gesture recognition [@ammaAirwritingWearableHandwriting2014;
@bevilacquaContinuousRealtimeGesture2010;
@chunliwangRealTimeLargeVocabulary2001; @fatmiComparingANNSVM2019;
@galkaInertialMotionSensing2016; @hamdyaliComparativeStudyUser2014;
@hofmannVelocityProfileBased1998; @jong-sungkimDynamicGestureRecognition1996;
@kadousGRASPRecognitionAustralian1995;
@klingmannAccelerometerBasedGestureRecognition2009;
@kongGestureRecognitionModel2009; @kratzWiizards3DGesture2007;
@liangSignLanguageRecognition1996; @mantyjarviEnablingFastEffortless2004;
@mantyjarviGestureInteractionSmall2005;
@marasovicMotionBasedGestureRecognition2015;
@prekopcsakAccelerometerBasedRealTime2008;
@pylvanainenAccelerometerBasedGesture2005;
@rung-hueiliangRealtimeContinuousGesture1998;
@schlomerGestureRecognitionWii2008; @wangchunliRealTimeLargeVocabulary2002;
@wengaoChineseSignLanguage2004; @whiteheadGestureRecognitionAccelerometers2014;
@wuGestureRecognition3D2009; @xuzhangFrameworkHandGesture2011;
@zhangHandGestureRecognition2009].

Other popular systems have been Support Vector Machines (SVMs)
[@ammaAirwritingWearableHandwriting2014;
@collialfaroUserIndependentHandGesture2022; @fatmiComparingANNSVM2019;
@hamdyaliComparativeStudyUser2014; @kimBichannelSensorFusion2008;
@kunduHandGestureRecognition2018; @leeSmartWearableHand2018;
@mohandesAutomationArabicSign2004; @mohandesRecognitionTwoHandedArabic2013;
@mummadiRealTimeEmbeddedDetection2018;
@prekopcsakAccelerometerBasedRealTime2008;
@wongMultiFeaturesCapacitiveHand2021; @wuGestureRecognition3D2009;
@wuWearableSystemRecognizing2016; @xieAccelerometerGestureRecognition2014],
Dynamic Time Warping (DTW) [@aklNovelAccelerometerBasedGesture2011;
@hamdyaliComparativeStudyUser2014; @liHandGestureRecognition2018;
@marasovicMotionBasedGestureRecognition2015;
@patilHandwritingRecognitionFree2016; @sethujanakiRealTimeRecognition2013;
@wangUserindependentAccelerometerbasedGesture2013;
@wuGestureRecognition3D2009], and k-Nearest Neighbours (kNN)
[@alzubaidiNovelAssistiveGlove2023; @hamdyaliComparativeStudyUser2014;
@kimBichannelSensorFusion2008; @liHandGestureRecognition2018;
@sethujanakiRealTimeRecognition2013; @wongMultiFeaturesCapacitiveHand2021;
@wuWearableSystemRecognizing2016].

Neural Network based approaches first appeared with in 1922 when Murakami and
Taguchi @murakamiGestureRecognitionUsing1991 used a recurrent neural network to
classify a dataset of 42 classes. The recent increase in computational power
has allowed neural networks and their variants to be fully utilised for
glove-based gesture recognition: Feed-Forward Neural Networks (FFNNs)
[@damasioAnimatingVirtualHumans2002; @fatmiComparingANNSVM2019;
@felsGloveTalkIIaNeuralnetworkInterface1998; @hamdyaliComparativeStudyUser2014;
@jong-sungkimDynamicGestureRecognition1996; @mehdiSignLanguageRecognition2002;
@netoHighLevelProgramming2010; @vasconezHandGestureRecognition2022;
@zhangRealTimeSurfaceEMG2019], Recurrent Neural Networks (RNNs)
[@kochRecurrentNeuralNetwork2019; @makaussovLowCostIMUBasedRealTime2020;
@murakamiGestureRecognitionUsing1991; @riveraRecognitionHumanHand2017;
@wengaoChineseSignLanguage2004;@yuanHandGestureRecognition2020;
@zhangStackedLSTMBasedDynamic2021], Convolutional Neural Networks (CNNs)
[@maHandGestureRecognition2017; @wenMachineLearningGlove2020;
@yuanHandGestureRecognition2020], and Self-Organising Feature Maps (SOMs)
[@wengaoChineseSignLanguage2004] have all shown good results.

Papers which attack implicit segmentation (where not every observation
necessarily contains a gesture, thus resulting in a highly imbalanced dataset
with many no-gesture observations) often use a two-model approach, with one
model being used for gesture detection (without attempting to classify which
gesture is being observed) and a second (often more complex) model being used
for gesture recognition _given_ that the observation already contains a
gesture. These two models are chained together, such that the gesture
recogniser is only applied to observations which the gesture detector has
predicted as actually containing a gesture.

The training times and inference times of different models scale in different
ways. Regular HMMs are unable of performing multi-class classification, and the
only way to create a HMM-based classifier for multiple classes is to train one
HMM for each class. At inference time, every HMM must output the log-likelihood
of the given observation being generated. These log-likelihoods are then
compared, and the class associated with the most likely HMM is selected as the
classifiers prediction. This is called one-vs-rest classification. SVMs also
require one-vs-rest classification for similar reasons.

The problem with one-vs-rest classification is that it scales linearly with the
number of classes being predicted. So performing inference on a dataset with 50
classes will take approximately 10 times longer than performing inference on a
dataset with 5 classes.

While this fact has likely dissuaded many researchers from using HMMs for
many-class gesture classification, they have nonetheless been used successfully
by Chunli and Wen to classify thousands of unique gestures from Chinese Sign
Language between 2001 and 2004: @chunliwangRealTimeLargeVocabulary2001
classified 4800 signs, @wangchunliRealTimeLargeVocabulary2002 classified 5100
signs, and @wengaoChineseSignLanguage2004 classified 5113 signs.

In @wengaoChineseSignLanguage2004, Chunli and Wen applied a multi-stage
approach, where a Self-Organising Feature Map (SOM) was used to reduce the
dimensionality of the input data. A simple Recurrent Neural Network was used to
detect if there was a gesture in a particular observation, and then
(conditional on a positive detection) a set of 5113 HMMs were used to recognise
which gesture was in that observation. They applied a modified version of the
Viterbi algorithm (the "lattice" Viterbi Algorithm) to efficiently evaluate the
most likely of the many different HMMs.

The inference and prediction times for neural network based methods do not tend
to grow linearly with the number of classes being predicted. This is due to
their internal architecture being able to support multi-class classification.
This fact has lead to more neural network based approaches being used in recent
years.

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_models_glove_based.pdf}
\caption{Glove-based gesture detection papers.}
\label{fig:03_models_glove_based}
\end{figure}

## Vision- and WiFi-based Gesture Recognition

This section focuses on non-glove based gesture recognition, which resolves to
just two categories: vision-based (using visible light and depth data), and
WiFi-based (using the effect the human body has on diagnostic information
collected in WiFi networks). This section will not be as detailed as Section
\ref{glove-based-gesture-recognition}, due to the focus of the thesis being
glove-based systems. There is a wealth of research in these two fields, with
recent review papers of WiFi-based systems citing between 100 and 150 papers
[@maWiFiSensingChannel2020; @hussainReviewCategorizationTechniques2020;
@wangCSIbasedHumanSensing2021; @maSurveyWiFiBased2016]. Recent reviews of
vision-based systems cited between 100 and 270 papers
[@rautarayVisionBasedHand2015; @cheokReviewHandGesture2019;
@oudahHandGestureRecognition2020]. While the number of papers cited is not a
precise measure of the size of the field, is does provide an approximation. The
interested reader is directed towards those reviews for a more detailed
treatment of the material.

**How vision-based systems work** Vision-based systems collect visual data
using video cameras and more recently, depth information, either using LiDAR or
by measuring the reflection of a known infrared projection. The field has
progressed with improved hardware: earlier systems did not have depth
information, had lower-resolution images, did not have colour information, and
had fewer frames per second when compared to modern hardware.

**How WiFi-based systems work** The technology enabling gesture-recognition
with WiFi was implemented in the IEEE 802.11n standard released in 2009. This
standard introduced Channel State Information (CSI) which provided
significantly more information about the noise in an environment than was
previously available. CSI allows transmitters in a WiFi network to change how
they transmit data based on the current channel conditions, which enables more
reliable communication.

Since CSI is very sensitive to the surrounding environment, changes such as a
person moving within a room [@wuWiTrajRobustIndoor2023] or even just breathing
[@wangWeCanHear2014] can induce a change in the CSI, which can then be
recognised using modern machine learning techniques.

**Datasets** Both vision- and WiFi-based systems have seen the benefit of
standardised hardware that enables the creation of high-quality and diverse
datasets of gestures being performed and recorded on relevant hardware. These
datasets [@guyonChaLearnGestureChallenge2012;
@materzynskaJesterDatasetLargeScale2019;
@alazraiDatasetWiFibasedHumantohuman2020] promote research in the field, as
they provide a common baseline against which new algorithms can be tested. They
also reduce the barrier to entry, as researchers skilled in modelling but
without the resources to collect a large amount of data can still contributed
to the field.

### Chronology of Non-glove-based Systems

Vision based systems have been discussed since the 1980s
[@boltPutthatthereVoiceGesture1980;
@jenningsComputergraphicModelingAnalysis1988;
@myronw.kruegerArtificialRealityII1991] but the first working system was Yamato
\emph{et~al.}'s paper recognising human actions using an HMM trained to
recognise feature vectors [@yamatoRecognizingHumanAction1992]. Starner and
Pentland @starnerRealtimeAmericanSign1995 were the first to use vision-based
systems to recognise sign language gestures, using HMMs to recognise 40 signs
from the American Sign Language. Due to the computational power available at
the time, the user had to wear brightly coloured gloves to aid in hand
detection and the system ran at 5 frames per second. HMMs paired with some form
of manual feature extraction would remain the favoured modelling technique for
vision-based systems for many years [@binhRealTimeHandTracking2005;
@chenHandGestureRecognition2003; @eickelerHiddenMarkovModel1998;
@elmezainGestureRecognitionAlphabets2007; @elmezainHandGestureRecognition2009;
@elmezainRealTimeCapableSystem2008; @frieslaarRobustSouthAfrican2014;
@ghotkarDynamicHandGesture2016; @hyeon-kyuleeHMMbasedThresholdModel1999;
@keskinRealTimeHand2003; @naidooSouthAfricanSign2010;
@ramamoorthyRecognitionDynamicHand2003; @rigollHighPerformanceRealtime1998;
@starnerRealtimeAmericanSign1995; @starnerRealtimeAmericanSign1998;
@starnerVisualRecognitionAmerican1995; @wilsonParametricHiddenMarkov1999;
@wuDeepDynamicNeural2016; @yamatoRecognizingHumanAction1992;
@yangDynamicHandGesture2012; @yoonHandGestureRecognition2001;
@zhangVisionbasedSignLanguage2004; @zhaoRealtimeHeadGesture2017].

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_models_no_gloves.pdf}
\caption{Models used for recognising gestures in vision- and WiFi-based systems over time.}
\label{fig:03_models_no_gloves}
\end{figure}

In 2011, Halperin \emph{et~al.} published a tool
[@halperinToolReleaseGathering2011] which provided a detailed picture of the
wireless channel conditions using CSI information. The release of this tool
made apparent the level of detail available in CSI and how that information
changes with changes to the environment. Adib and Katabi first applied the data
available in CSI to recognise human gestures [@adibSeeWallsWiFi2013] and were
followed by papers investigating many diverse applications such as breathing
detection [@liuWiSleepContactlessSleep2014; @wangHumanRespirationDetection2016;
@wuNonInvasiveDetectionMoving2015], sign language recognition
[@liWiFingerTalkYour2016], fall detection [@wangRTFallRealTimeContactless2017;
@wangWiFallDeviceFreeFall2017], distinguishing different people from one
another based on their movement or gait [@wangGaitRecognitionUsing2016;
@zengWiWhoWiFiBasedPerson2016; @zhangWiFiIDHumanIdentification2016], keystroke
and password inference [@aliRecognizingKeystrokesUsing2017;
@liWhenCSIMeets2016; @shenWiPassCSIbasedKeystroke2020], sleep detection
[@liuWiSleepContactlessSleep2014], speech recognition [@wangWeCanHear2014], and
the monitoring of vital signs [@liuTrackingVitalSigns2015].

The applications of vision-based gesture recognition have been less varied,
with an emphasis on sign language [@avolaExploitingRecurrentNeural2019;
@bhagatIndianSignLanguage2019; @binhRealTimeHandTracking2005;
@bowdenLinguisticFeatureVector2004; @bowdenVisionBasedInterpretation2003;
@chenHandGestureRecognition2003; @elbadawyArabicSignLanguage2017;
@ghotkarDynamicHandGesture2016; @hurrooSignLanguageRecognition2020;
@jiehuangSignLanguageRecognition2015; @kadirMinimalTrainingLarge2004;
@liang3DConvolutionalNeural2018; @ming-hsuanyangRecognizingHandGesture1999;
@nelIntegratedSignLanguage2013; @sahooRealTimeHandGesture2022;
@sharmaASL3DCNNAmericanSign2021; @starnerRealtimeAmericanSign1995;
@starnerRealtimeAmericanSign1998; @starnerVisualRecognitionAmerican1995;
@zhangVisionbasedSignLanguage2004]. Other applications have included
augmented/virtual reality [@buchmannFingARtipsGestureBased2004;
@sagayamHandPostureGesture2017], video game control
[@freemanOrientationHistogramsHand1995;
@marceloGeFightersExperimentGesturebased2006], generic gesture recognition
[@ahujaHandGestureRecognition2015], various medical applications
[@funkeUsing3DConvolutional2019; @wanExploreEfficientLocal2016], and remote
robot control [@qiMultiSensorGuidedHand2021;
@ramamoorthyRecognitionDynamicHand2003; @wanExploreEfficientLocal2016].

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_wifi_vision_applications.pdf}
\caption{Wifi- and Vision-based applications.}
\label{fig:03_wifi_vision_applications}
\end{figure}

Convolutional Neural Networks (CNNs) were first used for gesture recognition in
2015 by Huang \emph{et~al.} [@jiehuangSignLanguageRecognition2015] and neural
network based models have been used by many researchers for gesture recognition
[@funkeUsing3DConvolutional2019; @hakimDynamicHandGesture2019;
@hurrooSignLanguageRecognition2020; @jiehuangSignLanguageRecognition2015;
@kopukluRealtimeHandGesture2019; @liuDynamicGestureRecognition2021;
@luOneshotLearningHand2019; @mohammedDeepLearningBasedEndtoEnd2019;
@mujahidRealTimeHandGesture2021; @sahooRealTimeHandGesture2022;
@sharmaASL3DCNNAmericanSign2021; @urrehmanDynamicHandGesture2022;
@wuDeepDynamicNeural2016; @zhangGestureRecognitionBased2020].

## Applications of Gesture Recognition

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_applications.pdf}
\caption{The varied applications of gesture recognition.}
\label{fig:03_applications}
\end{figure}

One of the most common applications for gesture recognition is classification
of the sign language local to the researcher. These languages
appear ideal at first glance, as they provide a large set of non-trivial
gestures which do not require extensive description. The ability to
automatically translate a sign language into a spoken language has immediate
and clear benefit.

However, sign language communication goes beyond the simple hand signs that are
popularly shown in simple charts. Sign languages include non-manual markers which
use the face or body posture of the signer to convey grammatical structure and
lexical distinctions, for example questions or negations.

This means that the common task of developing a system to recognise sign
language is often reported as a complete system, even though it is a partial
solution.

\begin{figure}[!htb]
\centering
\includegraphics[width=\textwidth]{src/imgs/graphs/03_sl_applications.pdf}
\caption{The Sign Language applications of gesture recognition.}
\label{fig:03_sl_applications}
\end{figure}

This has raised some critique from sign language communities, however
it should be noted that many authors use gestures from their local sign
language simply as a useful collection of gestures, and the fact that the
gestures have distinct meaning is not of direct interest to the research being
performed.

An analogy can be made to the Utah Teapot [@torrenceMartinNewellOriginal2006],
common in computer graphics research. The utility of the Utah Teapot is not
that it is an accurate representation of a specific teapot, but rather that it
is a shape complex enough to be non-trivial and common enough that it does not
require significant explanation. Similarly, The utility of using gestures from
a sign language is not that they have semantic meaning, but rather that they
are complex enough to be non-trivial and common enough that they do not require
significant explanation.

# Glossary of terms

This section provides some useful terms regarding hand anatomy.

## Anatomy of the hand

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

\begin{figure}[!htb]
\centering
\includegraphics[width=0.6\textwidth]{src/imgs/03_movements.png}
\caption{Movements of the hand.}
\label{fig:03_movements}
\end{figure}

# References
