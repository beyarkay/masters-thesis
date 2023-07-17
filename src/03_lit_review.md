# Literature Review

TODO Brief overview and description of structure (vision, glove, and WiFi based
systems)

Glove-based systems are described in \ref{glove-based-systems}.
Vision-based systems are described in \ref{vision-based-systems}.
WiFi-based systems are described in \ref{wifi-based-systems}.
An overview of the literature and comparisons are provided in \ref{overview}.
A glossary of useful terms is provided in \ref{glossary-of-terms}.

# Literature, divided by the technology used

This section will review the literature as related to gesture detection. There
are three primary methods of sensing the movement of a user's hands:
glove-based, vision-based, and (most recently) WiFi-based. These three methods
will be explored in subsections \ref{glove-based-systems},
\ref{vision-based-systems}, and \ref{wifi-based-systems} respectively.

## Glove-based systems

Glove-based systems are characterised by electronic sensors which were embedded
in a "glove" that the user would wear (See figure \ref{TODO} for examples).
Many different sensor types have been proposed over the decades measuring
acceleration, skin capacitance, joint flexion, and muscle-based electrical
impulses.

The lack of an affordable high-fidelity sensor glove has resulted in a high
barrier to entry. Those researchers who are able to acquire or build a sensor
glove have often had to reinvent the wheel, as the findings from one sensor
suite will not be applicable to any other sensor suite.

### Before the 1990s

The Computer Image Corporation of Denver, Colorado developed the ANIMAC (later
named the
[Scanimate](https://www.fondation-langlois.org/html/e/page.php?NumPage=442))
between 1962 and 1971 which performed full body capture for use in computer
graphics, but did not have the fidelity for finger-level gesture capture (see
Figure \ref{TODO}).

![ANIMAC, @experimentaltelevisioncenterComputerImageCorporation1969](src/imgs/03_experimental_television_center_computer_1969.jpg){ width=50% }

The first glove-based system which could capture per-finger movement was the
Sayre Glove [@thomasa.defantiUSNEAR60341631977]. The Sayre glove was based on an idea
by their colleague, Richard Sayre. The glove used flexible tubes which would
occlude a light source from a sensor placed at opposite ends of the tubes.

![Sayre glove, By @thomasa.defantiUSNEAR60341631977](src/imgs/03_thomas_a_defanti_us_1977_2.png){ width=50% }

![Sayre glove, By @thomasa.defantiUSNEAR60341631977](src/imgs/03_thomas_a_defanti_us_1977_1.png){ width=50% }

In 1981 Gary J. Grimes filed a patent through Bell Telephone Laboratories Inc.
for a Digital data entry glove interface [@garyj.grimesUSPatentDigital1981]. This glove
used 4 "knuckle-bend-sensors", 18 touch sensors, 2 tilt sensors, and a mode
switch which in combination would allow the user to sign the English alphabet
and the numerals 0 through to 9 in a manner similar to American Sign Language.

![Digital data entry glove interface, @garyj.grimesUSPatentDigital1981](src/imgs/03_gary_j_grimes_us_1981.png){ width=50% }

The Dexterous HandMaster [@jacobsenUTAHDextrousHand1984, @marcusSensingHumanHand1988] was
developed in 1984 as a controller for the Utah/MIT Dexterous Hand robot
[@jacobsenDesignUtahDextrous1986], and has since been redesigned and was sold
commercially by Exos. It uses 20 hall-effect\sidenote{define these} sensors to
measure the flexion of the interphalangeal joints, with 4 sensors for each
finger and thumb. @watsonSurveyGestureRecognition1993 reports the price of the Dexterous Hand
Robot at US$15 000 in 1993.

![Dexterous HandMaster, @marcusSensingHumanHand1988](src/imgs/03_marcus_sensing_1988.png){ width=50% }

@fisherTelepresenceMasterGlove1987 working at NASA's Ames research centre created a
glove which was capable of transmitting data to the host computer in real time.
This glove used 15 flex sensors per hand and a "3D magnetic digitising
device" capable of reporting the X, Y, Z, azimuth, elevation, and roll
coordinates to the host computer (see Figure \ref{TODO}).

![NASA telepresence, @fisherTelepresenceMasterGlove1987](src/imgs/03_fisher_telepresence_1987.png){ width=50% }

@zimmermanHandGestureInterface1987 developed the DataGlove which measured 10 finger joints,
and was significantly easier to use and weighed less than previous devices.
This was commercialised by VPL Research. The device used optical fibres aligned
along the fingers. Bending the finger reduces the amount of light which can
reach the end of the fibre optic. This reduction can be measured by a
photo-resistor, which allows the glove to calculate the flexion at each joint.
@watsonSurveyGestureRecognition1993 reports the price of the DataGlove at US$8 000 in 1993.
\sidenote{TODO: Note that the DataGlove could be combined with a Polhemus 3D tracker}

The DataGlove was used in many research applications. @fisherVirtualEnvironmentDisplay1987 and
@scotts.fisherVIRTUALENVIRONMENTSPERSONAL1991 who used it to interact with their Virtual
Environment Display System. @zeltzerIntegratedGraphicalSimulation1989 used it to grab, move, and
throw virtual objects. @kaufmanToolsInteractionThree1989 used it to interact with a 3D
animation and graphics platform. @takemuraEvaluation3DObject1989 used it to compare
3D and 2D input devices. @weimerSyntheticVisualEnvironment1989 used the DataGlove to interact
with CAD and teleoperation software. @brooksDataGloveManmachineInterface1989 used a set of
Kohonen networks [@kohonenSelforganizedFormationTopologically1982] to recognised gestures made
while wearing the DataGlove, with each Kohonen network recognising one gesture.
@paoTransformationHumanHand1989 mapped human hand poses to hand poses of the Utah/MIT
Dexterous Hand robot using algebraic transformation matrices, allowing the user
to form the desired pose with their own hand and for the robot to assume a
similar position, despite kinematic differences. In a different approach to the
same problem, @hongCalibratingVPLDataGlove1989 used the DataGlove and the Utah/MIT
Dexterous Hand robot, but determined the position of the user's fingertips
using the DataGlove, and moved the Dexterous Hand's fingertips to match those
positions.

![VPL DataGlove, @zimmermanHandGestureInterface1987](src/imgs/03_zimmerman_hand_1987.png){ width=50% }

![The outer glove and glove lining of the DataGlove. Flex sensors and fibre
optic cables are visible, as well as the interface board used to read the
sensors' measurements. @wiseEvaluationFiberOptic1990](src/imgs/03_wise_evaluation_1990.png){ width=50% }

The Mattel Toy company produced the PowerGlove in 1989
[@abramsgentileentertainmentPowerGlove1989] as a low-cost game controller,
intended for use with Nintendo home video games. The device uses resistive-ink
flex sensors that measure the bending of the thumb, index, middle, and ring
fingers. Two ultrasonic transmitters mounted on the back of the glove and
paired with three ultrasonic receivers mounted at known relative distances on
the user's monitor allow the glove to calculate the locations of the
transmitters via triangulation. The device was discontinued after two years,
but its low cost prompted many researchers to continue using the glove as an
input device [@todo, @todo, @todo] for years to come. @watsonSurveyGestureRecognition1993
reports the price of the PowerGlove as US$20 in 1993.

![Powerglove, @abramsgentileentertainmentPowerGlove1989](src/imgs/03_abrams_gentile_entertainment_powerglove_1989.jpg){ width=50% }

@kramerTalkingGlove1988 developed the Talking Glove, which would later become
the VirTex CyberGlove. The talking glove was designed for general purpose
communication with deaf-blind or non-vocal people. For sensors, the Talking
Glove used flexible strain gauges to detect the amount of flexion in each
finger. Gestures are recognised using $k$-Nearest-Neighbours with $k=1$, such
that only one training example is required for each gesture. \sidenote{mention
Pohelmus 3SPACE }

![Talking glove, @kramerTalkingGlove1988](src/imgs/03_kramer_talking_1988.png){ width=50% }

### 1990s

@feinerVisualizingDimensionalVirtual1990 used the DataGlove to explore $n$-dimensional spaces.
@felsBuildingAdaptiveInterfaces1990 used the DataGlove for speech synthesis, utilising the
fine-grained control to realistically combine different phonemes into words.

The Virtex CyberGlove was developed in 1990 by James Kramer after creating the
talking glove [@kramerTalkingGlove1988]. The CyberGlove was a commercial product,
sold by Virtual Technologies, Inc. which would later be acquired by Immersion
Corporation in 2000 [@immersioncorporationCyberGlove2001]. The CyberGlove had
either 18 or 22 flex sensors (depending on the model purchased) which were used
to measure the relative positions of the fingers and thumb.

![CyberGlove with its control box,
@laviolaSurveyHandPosture1999](src/imgs/03_laviola_survey_1999.png){ width=50% }

@wiseEvaluationFiberOptic1990 evaluated the DataGlove as an alternative to manual
goniometry, such that the range of motion of the hand can be automatically
captured. The repeatability and accuracy was measured on five participants, and
the DataGlove was found to have an average error of $5.6^{\circ}$. This was
comparable to manual measurement, however the DataGlove is unable to measure
adduction, abduction, wrist motion, or the full range of motion for the thumb.
They concluded that the DataGlove could become an effective clinical tool with
further development.

#### 1991

@murakamiGestureRecognitionUsing1991 used the DataGlove to capture hand movement information
for 42 symbols from the Japanese sign language which were then processed by an
Elman recurrent neural network [@elmanDistributedRepresentationsSimple2004]. This was the first
instance of anyone using a recurrent neural network for gesture recognition.

@takahashiHandGestureCoding1991 used the DataGlove to recognise 46 Japanese kana manual
alphabet gestures and succeeded in recognising 30 of them.

The Space Glove was developed by W Industries for use of their virtual reality
gaming product "Virtuality" in 1991 [@sturmanSurveyGlovebasedInput1994]. This device also
uses flex-sensors to measure the bend of the finger joints, with one sensor per
finger and two sensors for the thumb.

#### 1992

Sturman's PhD thesis [@sturmanWholehandInput1992] and subsequent paper
[@sturmanDesignMethodWholehand1993] provided a survey of existing whole hand input methods
and discussed questions about the appropriateness of whole-hand input.
Challenges such as gesture ambiguity, real-time-control, and comfort were also
discussed. A _design method_ was proposed which, if followed, would ensure that
the resultant whole-hand input method was well suited to the designated task.
Various glove-based systems available at the time were compared against each
other as well as against common non-glove-based systems (such as a set of
dials). Computer mice and joysticks were omitted from the comparison due to
technical incompatibility with the software being used.

#### 1993

Surveys by @watsonSurveyGestureRecognition1993 and
@sturmanSurveyGlovebasedInput1994 on glove-based input provided a comprehensive
description of gesture sensing at the time.

@baudelCharadeRemoteControl1993 utilised the DataGlove to give a presentation and proposed
a set of design guidelines for using glove-based input effectively. A custom
set of icons was developed to describe a gesture, and included symbols for open
or closed fingers and palm orientation

![Charade custom gesture description symbols, @baudelCharadeRemoteControl1993](src/imgs/03_baudel_charade_1993.png){ width=50% }

#### 1995

@kesslerEvaluationCyberGloveWholehand1995 performed a critical evaluation of the CyberGlove for
whole-hand input. They concluded that different hand sizes do not significantly
impact the user's ability to use the device, but calibration of the glove could
increase repeatability and accuracy.

@kadousGRASPRecognitionAustralian1995 (later published as @kadousMachineRecognitionAuslan1996) used data from the
PowerGlove to recognise 95 signs from Australian Sign Language, comparing a
variety of simple machine learning methods such as C4.5 [@quinlanC4ProgramsMachine1992] and
instance-based learning [@ahaInstancebasedLearningAlgorithms1991]. This more than doubled the
previous state of the art [@starnerVisualRecognitionAmerican1995] in terms of the number of
signs recognised and showed that glove-based systems did not need significant
precision in order to distinguish between different gestures.

#### 1996

@liangSignLanguageRecognition1996 used data from the DataGlove to recognise 50 signs from
Taiwanese Sign Language using a set of hidden Markov models, with one model for
each sign.

#### 1998

@felsGloveTalkIIaNeuralnetworkInterface1998 used multiple neural networks to convert
the DataGlove input into phonemes which could then be emitted as spoken words.

@rung-hueiliangRealtimeContinuousGesture1998 expanded their previous work
[@liang3DConvolutionalNeural2018], using the DataGlove to recognise 65 different states (51
postures, 6 orientations, and 8 motions) via a set of hidden Markov models and
a language model to discard syntactically improbably predictions.

#### 1999

@laviolaSurveyHandPosture1999 reviewed the state of the art for gesture recognition
techniques, covering both glove-based and vision-based systems. The different
glove-based systems are enumerated and compared, describing their accuracy,
price, and ease-of-use. Different algorithms used for processing the vision- or
glove-based data into gesture classifications were also discussed.

### 2000s

\sidenote{TODO: When do the first accelerometer based gloves appear?}

@rekimotoGestureWristGesturePadUnobtrusive2001 introduced devices designed to
provide input for wearable computers: the GestureWrist and the GesturePad. The
GesturePad will not be discussed in this review as -- despite its name -- it
does not allow for arbitrary gestures to be recognised, but is rather designed
to be embedded into regular clothing.

The GestureWrist is a wearable device resembling a wristband that consists of a
single transmitter and multiple receiver electrodes. When worn, the receiver
electrodes make contact with the wearer's skin. The transmitter emits a square
wave signal that traverses through the wearer's wrist and reaches the
receivers. The received signal's amplitude is influenced by the capacitance
between the transmitter and the wrist. As the wearer moves their hand, the
capacitance of their wrist fluctuates, resulting in corresponding changes in
the amplitude of the received signal. By analysing these changes, it becomes
possible to predict and associate specific gestures with the wearer's
movements. The GestureWrist also has a tilt sensor which measures the
horizontal inclination of the device.

![GestureWrist, @rekimotoGestureWristGesturePadUnobtrusive2001](src/imgs/03_rekimotoGestureWristGesturePadUnobtrusive2001.png){ width=50% }

#### 2002

@@chunliRealTimeLargeVocabulary2002 (continuing work from
@wangRealTimeLargeVocabulary2001) used two CyberGloves and a 3D tracker to
recognise 5100 different signs from the Chinese Sign Language. The system used
one HMM for each sign, resulting in 5100 HMMs. To query all 5100 HMMs in real
time, the emission distributions of the HMMs were first clustered into a small
number of groups based on similarity. Instead of querying all the HMMs, only
the clusters were queried, and then all the HMMs from the cluster which best
fit the data were queried.

@hernandez-rebollarAcceleGloveWholehandInput2002 \sidenote{TODO: First to use
accelerometers?} used six accelerometers mounted in rings on the back of the
middle phalanges, on the distal phalange of the thumb, and on the back of the
wrist. The authors briefly mention developing virtual hand software which could map
accelerometer readings to hand positions, but no further detail is provided.

![AcceleGlove, @hernandez-rebollarAcceleGloveWholehandInput2002](src/imgs/03_damasioAnimatingVirtualHumans2002.png){ width=50% }

@kolschKeyboardsKeyboardsSurvey2002 is a survey of various alphanumeric input
devices, with a focus on being able to touch-type with those devices. Many
keyboard-like devices are briefly covered, with coverage of general-purpose
gesture input devices was limited.

@mehdiSignLanguageRecognition2002 used the 5DT DataGlove to classify 26 signs
from the American Sign Language alphabet using a neural network.

@tuulariSoapBoxPlatformUbiquitous2002 recognised the short lifetime of many
hardware-interface prototypes, and designed a platform (the Sensing, Operating
and Activating Peripheral Box, or SoapBox) which is designed to be a
multipurpose solution to wired and wireless communication with built-in
sensors.

#### 2004

@salibaCompactGloveInput2004 built a glove with the aim of more precisely
measuring the posture of one hand, including the roll of the forearm. Their
glove had several potentiometers which measured the flexion of the middle and
ring finger, the roll of the forearm, the pitch of the wrist, and the angular
position of the thumb.

@mohandesAutomationArabicSign2004 used a PowerGlove and a support vector
machine to classify signs from the Arabic sign language. \sidenote{TODO no PDF
could be found for this}

@mantyjarviEnablingFastEffortless2004 used HMMs to recognise
accelerometer-based gestures with an emphasis on minimal user effort during
training. The SoapBox [@tuulariSoapBoxPlatformUbiquitous2002] was used to make
the gestures, with a button press indicating the start and finish of each
gesture.

@gaoChineseSignLanguage2004 developed a Chinese Sign Language recognition system using
a combination of Self-organising feature maps
[@kohonenSelforganizedFormationTopologically1982], Simple Recurrent Networks,
and Hidden Markov Models. Capturing the data from two CyberGloves and three
Pohelmus 3SPACE-position trackers, 5113 different classes were able to be
distinguished.

#### 2005

@mantyjarviIdentifyingUsersPortable2005 showed that it was possible to identify
users based on their walking gait via data collected from an accelerometer
mounted near the small of their back. \sidenote{TODO:Maybe this is a little
off-topic?}

@mantyjarviGestureInteractionSmall2005 proposed using the accelerometer built
into mobile phones and personal digital agents (PDAs) could be used for
multimedia control, and trained HMMs to recognise 18 gestures made while
holding those devices. @pylvanainenAccelerometerBasedGesture2005 also used HMMs
to recognise gestures recorded by an accelerometer built into a handheld
device.

#### 2006

@karantonisImplementationRealTimeHuman2006 used accelerometers to monitor
and classify human movement in real time using decision trees and custom
metrics derived from the acceleration data.

@kelaAccelerometerbasedGestureControl2006 used the SoapBox
[@tuulariSoapBoxPlatformUbiquitous2002] as a control device for interaction
with a virtual reality centre. The virtual reality centre used wall-sized
projection displays that allowed users to be completely immersed in engineering
sketches or CAD prototypes which were projected onto the walls. Users remarked
on the speed of use and naturalness of the system when compared to a mouse and
keyboard. The authors did not describe how the gestures were recognised nor
exactly what gestures were performed.

#### 2007

@mitraGestureRecognitionSurvey2007 surveyed both glove- and vision-based
gesture recognition, however the vision-based portion of the survey will be
discussed in Section \ref{vision-based-systems}. Mitra notes that statistical
modelling techniques (PCA, HMMs, Kalman filters, particle filtering,
condensation algorithms, Dynamic Time Warping
[@myersComparativeStudySeveral1981], Neural Networks) are often employed, but
that Finite State Machines have also been used effectively. Mitra also notes
that sign language recognition is the subject of a lot of research.

@alviPakistanSignLanguage2007 used statistical template matching to recognise
33 one-handed signs from the Pakistan Sign Language and 26 one-handed signs
from American Sign Language. The data was recorded with a 5DT DataGlove5 (the
successor to the original DataGlove). \sidenote{TODO should I define
statistical template matching?}

@heumerGraspRecognitionUncalibrated2007 performed a survey of various
grasp-recognition methods with 28 different classification models.
Historically, glove-based systems needed a lengthy calibration process by which
the range of the sensors could be detected. Heumer found that calibration is
rarely required to achieve acceptable accuracy, and performed a thorough
comparison of the advantages and disadvantages of the different classifiers.

@kratzWiizards3DGesture2007 used data from a Wii Remote, classified by a HMM,
to control a simple multiplayer video game in which the player could perform
"spells" by moving the Wii Remote in certain patterns.

![Wiizards, @kratzWiizards3DGesture2007](src/imgs/03_kratzWiizards3DGesture2007.png){ width=50% }

![A Wii Remote, @schlomerGestureRecognitionWii2008](src/imgs/03_schlomerGestureRecognitionWii2008.png){ width=50% }

#### 2008

@dipietroSurveyGloveBasedSystems2008 provided an extremely extensive review of
glove-based gesture recognition systems, summarising the work since the survey
by @sturmanSurveyGlovebasedInput1994 and discussing the limitations of the
technology of the time. The focus is on the hardware development of glove-based
systems and their applications, rather than on the software used to classify
the data being emitted from the hardware. Dipietro also notes the limitations
of different glove-based systems, and provides a set of metrics to consider
when constructing or selecting a glove for a particular purpose: Number, type,
and placement of sensors; Glove measurement repeatability and accuracy; and
calibration procedure. Dipietro specifically notes that future work should
address the limitations of 1) mounting sensors onto cloth, 2) lengthy
calibration procedures, 3) the lack of portability/wirelessness, and 4) cost.

@prekopcsakAccelerometerBasedRealTime2008 used a Sony-Ericsson W910i mobile
phone (which has an accelerometer built in) as the input method by which 10
different gestures can be recognised. An HMM and a SVM were constructed and
trained on the dataset, achieving similar performance.

@schlomerGestureRecognitionWii2008 used the accelerometer inside of a Wii
Remote to classify 5 different gestures using k-means clustering and an HMM.

@wangTrafficPoliceGesture2008 used two accelerometers, one mounted in the back
of each hand, to recognise the 9 gestures used by the traffic police of China
to direct traffic manually.

#### 2009

@liuUWaveAccelerometerbasedPersonalized2009 developed a model "uWave"
explicitly designed for one-shot recognition of gestures using a single
three-axis accelerometer such as those embedded in consumer electronics. uWave
is identical to Dynamic Time Warping [@myersComparativeStudySeveral1981],
except the acceleration data are quantised into 32 discrete buckets before DTW
is applied.

@wuGestureRecognition3D2009 developed a variant of SVMs, the _Frame-based
Descriptor and multi-class SVM_ (FDSVM), to classify gestures based on
time-series data from a single three-axis accelerometers. Wu compared the
results of FDSVM to C4.5, HMM, DTW, and Naïve Bayes and found the FDSVM to be
superior when classifying 12 gestures and gathering data from a Nintendo
Wii remote.

@zhangHandGestureRecognition2009 combines information from a three axis
accelerometer and multi-channel surface electromyography sensors (sEMG or EMG)
to recognise 18 different gestures. A HMM is used for classification. Zhang
shows that an HMM trained on both the EMG data and the acceleration data
outperforms HMMs trained on either the EMG or acceleration data

![Sensors for the four-channel EMG and 3-axis accelerometer, @zhangHandGestureRecognition2009](src/imgs/03_zhangHandGestureRecognition2009.png){ width=50% }

### 2010s

#### 2011

#### 2012

#### 2013

#### 2014

#### 2015

#### 2016

#### 2017

#### 2018

#### 2019

### 2020s

#### 2021

#### 2022

#### 2023

## Vision-based systems

When digital video recording systems became commercially viable around the
TODO, live video feed started to be used as input data from which hand position
could be extracted. This was first done by @todo. The launch of the Microsoft
Kinect (an affordable RGB camera system with infrared depth sensing) in 2010
produced a boom of vision-based systems (see Figure \ref{TODO}), as the Kinect
provided an easy way for high quality datasets to be obtained. From these
common datasets, researchers could build off of each others work to make
greater and greater progress.

Split by decade, noting any trends along the way. Note the seminal paper.

### 1980s and before

@boltPutthatthereVoiceGesture1980 augmented voice input with gestural input, allowing
the user to point at digital objects on a monitor and move them with spoken
commands. This took the appearance of a "media room" which was envisioned to be
a completely immersive replacement for a computer terminal:

> The interactions [...] are staged in the MIT Architecture Machine
> Group's "Media Room," a physical facility where the user's terminal is
> literally a room into which one steps, rather than a desk-top CRT before
> which one is perched.

The media room contained numerous computers, an armchair fitted with some
controls in the armrest, and projector which displays an image on one wall.
\sidenote{flesh this out a bit more}

![Put-that-there, @boltPutthatthereVoiceGesture1980](src/imgs/03_bolt_put-that-there_1980.png){ width=50% }

### 1990s

#### 1991

#### 1992

@yamatoRecognizingHumanAction1992

#### 1993

#### 1994

[@davisVisualGestureRecognition1994](https://www.semanticscholar.org/paper/Visual-gesture-recognition-Davis-Shah/99ad93149fcdcae534e2361a32b0389e83003113/figure/0)

#### 1995

@freemanOrientationHistogramsHand1995
@starnerRealtimeAmericanSign1995
@starnerVisualRecognitionAmerican1995

#### 1996

#### 1997

@pavlovicVisualInterpretationHand1997

#### 1998

@rigollHighPerformanceRealtime1998
@hofmannVelocityProfileBased1998
@segenHumancomputerInteractionUsing1998
@starnerRealtimeAmericanSign1998
@sharmaASL3DCNNAmericanSign2021
@segenFastAccurate3D1998
@eickelerHiddenMarkovModel1998

#### 1999

@ming-hsuanyangRecognizingHandGesture1999
@hyeon-kyuleeHMMbasedThresholdModel1999
@moeslundComputerVisionBasedHuman1999
@moeslundSummaries107Computer1999
@laviolaSurveyHandPosture1999
@wilsonParametricHiddenMarkov1999

TODO: see background of @wilsonParametricHiddenMarkov1999

### 2000s

#### 2001

#### 2002

#### 2003

#### 2004

#### 2005

@ongAutomaticSignLanguage2005 provided a survey of sign language recognition,
emphasising the significance of non-manual signs (those made with the body or
face) and the lack of attention to those signs in the literature. They also
critiqued how sign languages are often treated as an encoding of some spoken
language, instead of a language of its own right. For example, the signs for
"you" and "study" can be recognised by observing the hands alone, but observing
the body of the signer will reveal the true meaning "Are you studying very
hard?" in how the body is leaning forward, the head thrust out, and the raised
eyebrows towards the end of the sentence. \sidenote{TODO also describe the SoTA
for vision-based recognition}

#### 2006

\sidenote{TODO: add GeFighters}

@moeslundSurveyAdvancesVisionbased2006

#### 2007

#### 2008

#### 2009

TODO

### 2010s

#### 2011

#### 2012

#### 2013

#### 2014

#### 2015

#### 2016

#### 2017

#### 2018

#### 2019

### 2020s

#### 2021

#### 2022

#### 2023

## WiFi-based systems

In the year TODO, it was realised that the signals used for household WiFi were
sensitive enough that they would be affected by small changes in the
environment, such as a person breathing or chewing. @todo were the first to
show that device-free gesture detection was possible via this mechanism, and
since then many researchers have explored this area. Because WiFi-based systems
are dependant only on commercially available routers, many high quality
datasets have been gathered and released. These datasets facilitate the
advancement of WiFi-based gesture detection because they drastically lower the
complexity required to get started, allow for results to be reproduced, and
allow for new techniques to be compared to old ones.

Split by decade, noting any trends along the way. Note the seminal paper.

### 2010s

### 2020s

# Overview

This is where you show that you actually understand the work at hand

# Glossary of terms

TODO

## Electronic Sensors

TODO

- Flex sensor
- Hall effect sensor
- tilt sensor (ADXL202 as used in @rekimotoGestureWristGesturePadUnobtrusive2001)
- Accelerometer
- Inertial Measurement Unit
- Surface Electromyography
- Linear and rotational potentiometers

## Hardware Products

TODO

- Popularisation of accelerometers in phones and PDAs.
- Microsoft Kinect
- Nintendo Wii
- CyberGlove
  - Pohelmus 3SPACE
- VPL DataGlove
- Nintendo PowerGlove

## Anatomy of the hand

The human hand contains 27 bones which are split into three regions: the 14
_phalanges_ (three for each finger and two for the thumb), the 5 _metacarpal
bones_ (the palm bones, each of which connect to a finger or the thumb), and
the 8 _carpal bones_ (the wrist bones, which are arranged in two rows going
across the wrist).

The carpals connect to the bones of the arm: the _radius_ (which is closest to
the thumb) and the _ulnar_ (which is closest to the little finger)

See Figure \ref{todo} for a visual description. An glossary of all anatomy
terms is provided in Appendix \ref{TODO}.

![@MedicalGalleryBlausen2014](src/imgs/03_bones.png){ width=50% }

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

See Figure \ref{TODO} for a visual description.

![@cabibihanSuitabilityOpenlyAccessible2021](src/imgs/03_movements.png){ width=50% }

## Gestures vs Poses

The English word "gesture" is usually used exclusively for the act of moving a
body part. However, some authors use the word to refer to a particular position
_or_ a movement of a body part. For clarity, this review will define "gesture"
as a movement of one or more body parts, and "pose" as the position of one or
more body parts.

Unless otherwise specified, a gesture or a pose will refer to that of the hand
or hands, as opposed to a gesture/pose involving the participant's entire body.

# References
