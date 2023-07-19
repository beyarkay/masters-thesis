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

The Dexterous HandMaster [@jacobsenUTAHDextrousHand1984,
@marcusSensingHumanHand1988] was developed in 1984 as a controller for the
Utah/MIT Dexterous Hand robot [@jacobsenDesignUtahDextrous1986], and has since
been redesigned and was sold commercially by Exos. It uses 20
hall-effect\sidenote{define these} sensors to measure the flexion of the
interphalangeal joints, with 4 sensors for each finger and thumb.
@watsonSurveyGestureRecognition1993 reports the price of the Dexterous Hand
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
transmitters via triangulation. The device was discontinued after two years.
@watsonSurveyGestureRecognition1993 reports the price of the PowerGlove as
US$20 in 1993.

![Powerglove, @abramsgentileentertainmentPowerGlove1989](src/imgs/03_abrams_gentile_entertainment_powerglove_1989.jpg){ width=50% }

@kramerTalkingGlove1988 developed the Talking Glove, which would later become
the VirTex CyberGlove. The talking glove was designed for general purpose
communication with deaf-blind or non-vocal people. For sensors, the Talking
Glove used flexible strain gauges to detect the amount of flexion in each
finger. Gestures are recognised using $k$-Nearest-Neighbours with $k=1$, such
that only one training example is required for each gesture. \sidenote{mention
Pohelmus 3SPACE }

![Talking glove, @kramerTalkingGlove1988](src/imgs/03_kramer_talking_1988.png){ width=50% }

### 1990s {#sss:glove-based-1990s}

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

#### 1999 {#ssss:glove-based-1990s-1999}

@laviolaSurveyHandPosture1999 reviewed the state of the art for gesture recognition
techniques, covering both glove-based and vision-based systems. The different
glove-based systems are enumerated and compared, describing their accuracy,
price, and ease-of-use. Different algorithms used for processing the vision- or
glove-based data into gesture classifications were also discussed.

### 2000s {#sss:glove-based-2000s}

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

#### 2007 {#ssss:glove-based-2000s-2007}

@mitraGestureRecognitionSurvey2007 surveyed both glove- and vision-based
gesture recognition, however the vision-based portion of the survey will be
discussed in subsection \ref{ssss:vision-based-2000s-2007}. Mitra notes that
statistical modelling techniques (PCA, HMMs, Kalman filters, particle
filtering, condensation algorithms, Dynamic Time Warping
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

### 2010s {#sss:glove-based-2010s}

@aklAccelerometerbasedGestureRecognition2010

@bevilacquaContinuousRealtimeGesture2010

@harshithSurveyVariousGesture2010

@netoHighLevelProgramming2010

#### 2011

@aklNovelAccelerometerBasedGesture2011

@cooperSignLanguageRecognition2011 explores automated sign language
recognition. They note that sign language recognition shares many difficulties
with gesture recognition, but is a problem of its own right due to non-manual
signs (signs involving the face or other parts of the body).

@xuzhangFrameworkHandGesture2011

#### 2013

@chenSurveyHandGesture2013

@mohandesRecognitionTwoHandedArabic2013

@premaratneAustralianSignLanguage2013

@raysarkarHandGestureRecognition2013

@sethujanakiRealTimeRecognition2013

@songAntLearningAlgorithm2013

@wangUserindependentAccelerometerbasedGesture2013

#### 2014

@ammaAirwritingWearableHandwriting2014

@hamdyaliComparativeStudyUser2014

@whiteheadGestureRecognitionAccelerometers2014

@xieAccelerometerGestureRecognition2014

#### 2015

@marasovicMotionBasedGestureRecognition2015

@xuFingerwritingSmartwatchCase2015

#### 2016

@galkaInertialMotionSensing2016

@jiangDevelopmentRealtimeHand2016

@patilHandwritingRecognitionFree2016

@wuWearableSystemRecognizing2016

#### 2017

@maHandGestureRecognition2017

@mardiyantoDevelopmentHandGesture2017

@riveraRecognitionHumanHand2017

#### 2018

@kunduHandGestureRecognition2018

@leeSmartWearableHand2018

@liHandGestureRecognition2018

@mummadiRealTimeEmbeddedDetection2018

#### 2019

@anwarHandGestureRecognition2019

@fatmiComparingANNSVM2019

@kochRecurrentNeuralNetwork2019

@rashidWearableTechnologiesHand2019

@zhangRealTimeSurfaceEMG2019

### 2020s {#sss:glove-based-2020s}

@chenSurveyHandPose2020

@leeDeepLearningBased2020

@makaussovLowCostIMUBasedRealTime2020

@moinWearableBiosensingSystem2020

@wenMachineLearningGlove2020

@yuanHandGestureRecognition2020

#### 2021

@ahmedRealtimeSignLanguage2021

@chuSensorBasedHandGesture2021

@kudrinkoWearableSensorBasedSign2021

@qaroushSmartComfortableWearable2021

@wongMultiFeaturesCapacitiveHand2021

@zhangStackedLSTMBasedDynamic2021

#### 2022

@collialfaroUserIndependentHandGesture2022

@patilMarathiSignLanguage2022

@vasconezHandGestureRecognition2022

#### 2023

@alzubaidiNovelAssistiveGlove2023

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

### 1980s and before {#sss:vision-based-1980s}

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
Additionally, a Polhemus ROPAMS (Remote Object Position Attitude Measurement
System) is used to sense the location and orientation of the user's hand. The
device takes the form of a transmitter cube (about 4cm on each edge) and a
sensor cube (about 2cm on each edge). The sensor cube is mounted onto the back
of the user's hand. Inside each cubes, there are three coils mounted to be
orthogonal to each other. Each coil creates an antenna such that when an
alternating current is applied through each of the three coils in the
transmitter cube, some amount of current will be induced in each of the coils
in the sensor cube. The strength and frequency of these three induced
alternating currents can be used to calculate the relative orientations of the
cubes, and the location of the sensor cube can be calculated by the
$\frac{1}{R^3}$ decay of the signal strength, or by triangulating the signals
from multiple transmitter cubes.

![Put-that-there, @boltPutthatthereVoiceGesture1980](src/imgs/03_bolt_put-that-there_1980.png){ width=50% }

### 1990s {#sss:vision-based-1990s}

#### 1992

@yamatoRecognizingHumanAction1992 extracted feature-vectors from a grayscale
video feed (at $200 \times 200$ resolution) with 30 frames per second (fps).
These feature-vectors were then classified by an HMM. The feature vectors were
calculated via mesh-features[@umedaRecognitionMultiFontPrinted1982], a method
similar to the average pooling layer used in Convolutional Neural Networks. Six
different tennis actions were classified, as performed by three people.

#### 1993

@watsonSurveyGestureRecognition1993 largely concentrated on glove-based systems
of the time (see Section \ref{glove-based-systems}), noting the Salk Institutes
work [@jenningsComputergraphicModelingAnalysis1988] in analysing sign language
which could not be done in real time due to computational constraints. Watson
also notes that @myronw.kruegerArtificialRealityII1991 was able to track
participants using a single video camera, a process enabled by extracting only
the silhouette of the figure. There is a noticeable dearth of literature
utilising vision-based gesture recognition systems from this time due to the
lack of affordable consumer camera systems and the computational power
available to researchers for image-processing.

#### 1994

@davisVisualGestureRecognition1994 used images sampled at 4fps on a Sun
Microsystems
SPARC-1\sidenote{\href{https://en.wikipedia.org/wiki/SPARC}{Wikipedia}} to
classify seven gestures using a finite state machine. Fingertips were tracked
between frames to calculate trajectories and those trajectories are then
matched against a list of known gestures.

#### 1995

@freemanOrientationHistogramsHand1995 introduces _orientation histograms_ as a
dimensionality reduction technique that extracted a feature vector from images.
The orientation histograms were then used to recognise grayscale ten hand gestures in
real time with no special hardware.

![Images with different lighting conditions (a,b) and their corresponding local
orientations (c,d),
@freemanOrientationHistogramsHand1995](src/imgs/03_freemanOrientationHistogramsHand1995.png){ width=50% }

@starnerRealtimeAmericanSign1995 (which was derived from the author's Master's
thesis @starnerVisualRecognitionAmerican1995 and later revised and accepted in
@starnerRealtimeAmericanSign1998) uses a single grayscale camera (at $320
\times 240$ resolution) and HMMs to recognise 40 signs from American Sign
Language in real time.

#### 1997

@pavlovicVisualInterpretationHand1997 provides a review of vision-based gesture
recognition systems, noting that the field is still in its infancy and there
exist many theoretical and practical challenges to be overcome before fluent
vision-based gesture interaction is possible.

#### 1998

@eickelerHiddenMarkovModel1998 achieves position-independence, unknown-gesture
rejection, and continuous real-time recognition without requiring the user to
delimitate each gesture. The images are preprocessed by taking the difference
of sequential images (as a heuristic for movement) and then calculating various
moments from these difference images. This moments are then classified by an
HMM.

@rigollHighPerformanceRealtime1998 also extracts the difference between
sequential frames, calculates a bespoke feature-vector, and classifies those
feature-vectors into 24 gestures using a HMM. The 24 gestures were performed by
14 people. The video sequences were grayscale with a resolution of $96 \times
72$ pixels and recorded at 16 frames per second. Each observation was made of
50 frames.

@segenFastAccurate3D1998 describe a two-camera system that recognises three
gestures at 60fps. The system finds the outline of the user's hand, and then
calculates the fingertips by identifying points on this outline with curvature
greater than some threshold value. This system is used to control video games
such as Doom (by ID software) as well as flight simulation software.

![Controlling the video game Doom using hand gestures,
@segenFastAccurate3D1998](src/imgs/03_segenFastAccurate3D1998.png){ width=50% }

The authors expanded this work in @segenHumancomputerInteractionUsing1998, to
provide 10 degrees of freedom.

@sharmaMultimodalHumancomputerInterface1998 surveyed the literature for
multimodal human-computer interface methods. They note that vision-based
systems need to work in real-time to be useful, but the massive quantity of
data involved in image processing makes this difficult.

#### 1999

@hyeon-kyuleeHMMbasedThresholdModel1999 uses two staggered HMMs to continuously
classify 10 gestures from grayscale images. The first HMM detects if there is a
known gesture in the observation. If the likelihood from the first HMM exceeds
some threshold, then the second HMM is used to classify that observation as
some gesture. In this way the user can perform gestures without needing to
inform the recognition system.

@laviolaSurveyHandPosture1999 performed a review of hand gesture recognition,
including tracking, glove-based systems (see
\ref{#ssss:glove-based-1990s-1999}), vision-based systems, algorithms,
and applications. It is noted that both glove- and vision-based systems have
their own flaws, and that the better system will likely depend on the
application.

@ming-hsuanyangRecognizingHandGesture1999 finds matching regions in sequential
frames to generate trajectories for those regions. These trajectories are then
learned using a time-delay neural network [@waibelPhonemeRecognitionUsing1989],
where a time delay is introduced between the layers of a feed-forward neural
network to represent the temporal relationships. The video observations had a
resolution of $160 \times 120$ pixels and were taken at 30fps.

@moeslundComputerVisionBasedHuman1999 surveys computer vision-based human
motion capture. It describes the field at a high level, with sections on the
sensors used, the simplifying assumptions, tracking, pose estimation, and
gesture recognition. It is noted that depth information will likely be required
before precise gesture tracking can be implemented. This PhD thesis is
accompanied by @moeslundSummaries107Computer1999 which contains alphabetical
summaries of the 107 referenced papers. This is later published as
@moeslundSurveyComputerVisionBased2001.

@wilsonParametricHiddenMarkov1999 introduces a parameterised HMM which is then
used for identifying the position of a user's hand in 3D space. The hand position is
first calculated using an existing system, the Stereo Interactive Virtual
Environment (STIVE). STIVE operates at 20fps and outputs the Cartesian
coordinates of the two hands at each time step. These coordinates are used as
the ground truth on which the HMM is trained.

![An example of the STIVE stereo camera system with views from the two cameras and the calculated locations of the hands and head, @wilsonParametricHiddenMarkov1999](src/imgs/03_wilsonParametricHiddenMarkov1999.png){ width=50% }

In 1999, ARToolKit [@hirokazokatoARToolKit1999] was developed, providing
researchers with comprehensive software tooling to develop Augmented Reality
applications. This toolkit will be used by many researchers in the new
millennium.

### 2000s {#sss:vision-based-2000s}

@pengyuhongGestureModelingRecognition2000 uses video data to extract the
locations of the head and hands. These are tracked over the course of the
video, and clustered using k-means. These clusters are used to construct a
Finite State Machine (FSM) of clusters and temporal transitions between
clusters. The constructed FSM is then compared to a database of FSMs
representing known gestures. If there is a match, then the gesture is
recognised.

@yeasinVisualUnderstandingDynamic2000 interprets five different hand positions
as states of a Finite State Machine (FSM), and then classifies gestures as
different FSMs that only accept certain sequences of states. The resolution of
the grayscale camera is $256 \times 256$ and the video is taken at 15fps.

#### 2001 {#ssss:vision-based-2000s-2001}

@yoonHandGestureRecognition2001 used an HMM to classify 48 unique hand gestures
based on calculated hand trajectories and other bespoke features.

#### 2003 {#ssss:vision-based-2000s-2003}

@bowdenVisionBasedInterpretation2003 was able to classify 55 unique signs from
the British Sign Language using Markov chains trained on video observations.

@chenHandGestureRecognition2003 extracted feature vectors from grayscale 30fps
video data with a resolution of $256 \times 256$. An set of HMMs were then used
to classify 20 unique gestures in real time, with one HMM for each gesture.

@ramamoorthyRecognitionDynamicHand2003 used Kalman filters to track hand
positions in real time and HMMs to classify 3 hand gestures based on those hand
positions. Images were processed at 25fps.

#### 2004 {#ssss:vision-based-2000s-2004}

@bowdenLinguisticFeatureVector2004 introduced a one-shot sign-language
classification system which first extracts high level hand descriptors and then
classifies those descriptors using a set of Markov chains. There is one Markov
chain for each sign, and 49 signs are classified from a 25fps video.

@buchmannFingARtipsGestureBased2004 introduces a fingertip-based system
designed to be used to interact with virtual objects in AR. Fiducial markers
are used to aid with tracking. The user wears an i-visor Head Mounted Display
(HMD) with a web camera attached. Both the camera and i-visor have a resolution
of $640 \times 480$ and the application runs at 20fps. The fiducial markers
largely remove the need for gesture tracking, as they are designed to be easily
and automatically recognised by ARToolKit [@hirokazokatoARToolKit1999].

![FingARtips with the fiducial markers clearly visible on the table and on the
user's gloves. The web camera and i-visor HMD are also visible.
@buchmannFingARtipsGestureBased2004](src/imgs/03_buchmannFingARtipsGestureBased2004.png){
width=50% }

@kadirMinimalTrainingLarge2004 designed a single-camera system capable of
classifying 164 different gestures, significantly more than all previous work.
The system works at 25fps and needs few training examples (with good
performance achieved using only one example per gesture). The gestures are
signs from the British Sign Language, and one Markov chain was trained for each
gesture.

@zhangVisionbasedSignLanguage2004 uses coloured gloves to recognise 439 signs
from Chinese Sign Language. Principle Component Analysis is first used for
dimensionality reduction, after which an HMM is used to perform the
classification. The resolution of the camera was $320 \times 240$

#### 2005 {#ssss:vision-based-2000s-2005}

@binhRealTimeHandTracking2005 introduces a 25fps hand gesture recognition
system using HMMs and Kalman filters. 36 signs from the American Sign Language
are classified.

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

#### 2006 {#ssss:vision-based-2000s-2006}

@marceloGeFightersExperimentGesturebased2006 presents a 3D fighting game where
the players use gestures to control their characters. For each player, two
fiducial markers (one on each hand) are recognised using ARToolKit [@hirokazokatoARToolKit1999]
and their relative position is used to indicate the game command.

@moeslundSurveyAdvancesVisionbased2006 surveyed over 300 publications between
2000 and 2006, following up from @moeslundSurveyComputerVisionBased2001.

#### 2007 {#ssss:vision-based-2000s-2007}

@elmezainGestureRecognitionAlphabets2007 uses HMMs to recognise the 26 letters
of the American Sign Language alphabet using a stereo camera with an image
resolution of $240 \times 320$.

@fangRealTimeHandGesture2007 uses AdaBoost to detect hands in the video, which
are then tracked and classified by examining the hand and finger locations. The
resolution was $320 \times 240$ and the recognition was processed at about
10fps.

@mitraGestureRecognitionSurvey2007 surveys the state of gesture recognition,
both glove- and vision-based. See subsection \ref{ssss:glove-based-2000s-2007}
for discussion on the glove-based parts of the survey. Mitra notes that
connectionist approaches (neural networks and similar) have been effectively
utilised for gesture recognition, and that while static pose recognition can
typically be accomplished by simple models, dynamic gesture recognition has
often required time to be explicitly modelled, often with techniques such as
time-compressing templates, dynamic time warping, HMMs, and Time-Delayed Neural
Networks.

#### 2008 {#ssss:vision-based-2000s-2008}

@elmezainRealTimeCapableSystem2008 developed a system to recognise 36
one-handed gestures from colour video using HMMs. The gestures consisted of
writing out a simplified version the upper-case English alphabet (A-Z) and
numerals (0-9) in the air with one hand.

@hassanpourVisionBasedHand2008 surveys the state of vision-based hand gesture
recognition and finds that while much research has been completed, there still
exist largely unexplored problems such as automatically segmenting hands from
the background or classifying gestures performed against complex backgrounds.
These problems hinder real-world application of the findings. Occlusion is also
an unsolved problem, with researchers either turning to expensive multi-camera
or depth based systems.

@zinnenNewApproachEnable2008

#### 2009 {#ssss:vision-based-2000s-2009}

@elmezainHandGestureRecognition2009 proposes a method by which the English
alphabet (A-Z) and numerals (0-9) can be recognised when drawn by the hand in
the air in front of a colour camera with depth information. This method uses
HMMs after a feature vector containing hand position information is extracted
using Kalman filters.

@moniHMMBasedHand2009 conducted a review on using HMMs for vision-based hand
gesture recognition, noting that a unique HMM is required for each gesture
class and how this constraint restricts HMM-based approaches.

@wangEvaluationLocalSpatiotemporal2009 reviews different action recognition
methods for vision-based systems from the literature. The reviewed methods and
algorithms often are evaluated on unrealistic dataset (easily segmented
background, unmoving camera position, static lighting conditions, low skin
colour diversity). Wang implements numerous methods and compares them on a
diverse dataset of different human actions (not limited to human gestures).
They note that dense sampling [@fei-feiliBayesianHierarchicalModel2005]
consistently performs all other methods, at the cost of producing 15-20 times
more features.

@zabulisVisionBasedHandGesture2009 develops a gesture recognition system of
four static single-hand postures. Classification is done by identifying the
points on the outline of the hand with high curvature, labelling those as
fingertips, and then counting the number of fingertips and orientation thereof.
This information is enough to classify the four postures.

### 2010s {#sss:vision-based-2010s}

@naidooSouthAfricanSign2010 presents a vision-based gesture recognition system
for South African Sign Language using feature vectors classified by HMMs, with
a resultant classification rate of 69%.

#### 2011 {#ssss:vision-based-2010s-2011}

@chaudharySurveyHandGesture2011 survey vision-based hand gesture recognition
in the context of soft computing (neural networks, fuzzy logic, genetic
algorithms). They note that many researchers use fingertip identification as
the primary feature with which they recognise gestures.

@cooperSignLanguageRecognition2011 explores automated sign language
recognition. They note that sign language recognition shares many difficulties
with gesture recognition, but is a problem of its own right due to non-manual
signs (signs involving the face or other parts of the body). Future progress,
they note, should be focussed on continuous sign recognition, signer
independence, and the inclusion of non-manual signs into classification models.

@harrisonOmniTouchWearableMultitouch2011 created the OmniTouch wearable
depth-sensing and projection system which projects a display onto any surface
and allows the user to interact with that display. Finger segmentation is
performed with template matching using the depth data.

#### 2012 {#ssss:vision-based-2010s-2012}

@khanSurveyGestureRecognition2012 surveys gesture recognition from images of
hand postures. They note that posture recognition is composed of three main
phases: hand detection, feature extraction, and gesture recognition. Major
preprocessing steps include segmentation, edge detection, and noise removal.

@suarezHandGestureRecognition2012 reviews the use of depth data for hand
tracking and gesture recognition, examining 37 papers. The Microsoft Kinect and
the OpenNI libraries for hand tracking are often used. It is found that the
release of the Kinect increased the amount of research using depth-based
information, and moved the focus of research papers from gesture classification
to the applications of gesture-based input.

#### 2013 {#ssss:vision-based-2010s-2013}

@nelIntegratedSignLanguage2013 recognised 50 static signs from the South African Sign
Language with an accuracy of 74%, and is robust against skin colour.

@raysarkarHandGestureRecognition2013 surveyed vision-based hand gesture
recognition systems, enumerating papers by their approaches to different
problems such as hand segmentation, background segmentation, robustness to
skin-colour, scene illumination, and noise removal. \footnote{TODO: From here
on, surveys were not included, as about half the papers are just surveys, and
there are already too many references to cover each paper consistently.}

#### 2014 {#ssss:vision-based-2010s-2014}

@frieslaarRobustSouthAfrican2014 explored the classification of signs from the
South African Sign Language using a combination of HMMs and Support Vector
Machines (SVMs) called Hidden Markov Support Vector machines (HMSVMs). It is
able to recognise 35 signs.

#### 2015 {#ssss:vision-based-2010s-2015}

@jiehuangSignLanguageRecognition2015 used 3D Convolutional Neural Networks
(3DCNNs) to extracts features from the images and depth information of video
streams. The Microsoft Kinect is used to collect the data, which provides RGB
video data, depth information, and a description of the skeleton of the user.
25 custom defined gestures are classified with both a 3DCNN and a Gaussian
Mixture Model-Hidden Markov Model (GMM-HMM). The results concluded that the
3DCNN outperformed the GMM-HMM.

@michahialHandGestureRecognition2015 used edge detection and Histogram of
Gradients for feature extraction from video data. These features are then
classified into one of 20 gestures using SVMs.

#### 2016 {#ssss:vision-based-2010s-2016}

@chaiTwoStreamsRecurrent2016 used two Recurrent Neural Networks (RNNs) to
classify continuous gestures from video with depth data. The first RNN segments
the continuous stream of data to isolate the gestures, and the second RNN
classifiers those gestures.

@ghotkarDynamicHandGesture2016 classified 20 dynamic hand gestures using a HMM
with video, depth, and skeleton data from a Microsoft Kinect. The gestures came
from Indian Sign Language

@wuDeepDynamicNeural2016 used deep neural networks to perform continuous
gesture classification using video with depth data. 20 gestures are classified.

#### 2019 {#ssss:vision-based-2010s-2019}

@avolaExploitingRecurrentNeural2019 used recurrent neural networks (RNNs)
trained on the data from Leap Motion Controllers to recognise a subset of 28
gestures from the American Sign Language. The Leap Motion Controller uses depth
information to extract a candidate skeleton model of the hand.

@funkeUsing3DConvolutional2019 used 3D Convolutional Neural Networks (3DCNNs)
to recognise ten surgical gestures from video data.

@hakimDynamicHandGesture2019 used a video feed with depth information to
classify 24 gestures using a 3DCNN to extract features and a LSTM to extract
temporal features. These temporal features were then classified using a Finite
State Machine.

@kopukluRealtimeHandGesture2019 used a CNN to classify dynamic hand gestures
from a video stream in real time. The system uses one CNN to detect if a
gesture is present, and another CNN to detect _which_ gesture is present, given
that a gesture _is_ present.

@mohammedDeepLearningBasedEndtoEnd2019 used a two-stage approach to detect
hands in four hand detection datasets and two gesture classification datasets,
where one CNN was trained to output bounding boxes containing hands, and
another CNN was trained to classify those hands as gestures. The system was
designed to be adaptable to different datasets. The two gesture classification
datasets contained 81 and 7 unique gestures.

### 2020s {#sss:vision-based-2020s}

@chatzisComprehensiveStudyDeep2020

@chenSurveyHandPose2020

@dangAirGestureRecognition2020

@hurrooSignLanguageRecognition2020

@oudahHandGestureRecognition2020

@zhangGestureRecognitionBased2020

#### 2021 {#ssss:vision-based-2020s-2021}

@liuDynamicGestureRecognition2021

@mujahidRealTimeHandGesture2021

@qiMultiSensorGuidedHand2021

@sharmaASL3DCNNAmericanSign2021

#### 2022 {#ssss:vision-based-2020s-2022}

@sahooRealTimeHandGesture2022

@urrehmanDynamicHandGesture2022

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

@halperinToolReleaseGathering2011

@adibSeeWallsWiFi2013
@puWholehomeGestureRecognition2013

@abdelnasserWigestUbiquitousWifibased2014
@kelloggBringingGestureRecognition2014
@liuWiSleepContactlessSleep2014
@wangEeyesDevicefreeLocationoriented2014
@wangWeCanHear2014

@aliKeystrokeRecognitionUsing2015
@heWiGWiFiBasedGesture2015
@kotaruSpotFiDecimeterLevel2015
@liuTrackingVitalSigns2015
@sunWiDrawEnablingHandsfree2015
@wangUnderstandingModelingWiFi2015
@wuNonInvasiveDetectionMoving2015
@zengAnalyzingShopperBehavior2015

@al-qanessWiGeRWiFiBasedGesture2016
@liWhenCSIMeets2016
@liWiFingerTalkYour2016
@tanWiFingerLeveragingCommodity2016
@vasishtDecimeterLevelLocalizationSingle2016
@wangGaitRecognitionUsing2016
@wangHumanRespirationDetection2016
@zengWiWhoWiFiBasedPerson2016
@zhangMudraUserfriendlyFinegrained2016
@zhangWiFiIDHumanIdentification2016

@aliRecognizingKeystrokesUsing2017
@liIndoTrackDeviceFreeIndoor2017
@qianWidarDecimeterLevelPassive2017
@shangRobustSignLanguage2017
@virmaniPositionOrientationAgnostic2017
@wangDeviceFreeHumanActivity2017
@wangRTFallRealTimeContactless2017
@wangWiFallDeviceFreeFall2017
@yousefiSurveyBehaviorRecognition2017

@maSignFiSignLanguage2018
@qianWidar2PassiveHuman2018

@chenWiFiCSIBased2019
@fengWiMultiThreePhaseSystem2019
@zengFarSensePushingRange2019

### 2020s

@ahmedDFWiSLRDeviceFreeWiFibased2020
@alazraiDatasetWiFibasedHumantohuman2020
@alazraiEndtoEndDeepLearning2020
@dangAirGestureRecognition2020
@haoWiSLContactlessFineGrained2020
@hussainReviewCategorizationTechniques2020
@maWiFiSensingChannel2020
@shenWiPassCSIbasedKeystroke2020
@shengDeepSpatialTemporal2020
@thariqahmedDeviceFreeHuman2020

@wangCSIbasedHumanSensing2021
@zhangWidar3ZeroEffortCrossDomain2021

@wangPlacementMattersUnderstanding2022

@chenCrossDomainWiFiSensing2023
@wuWiTrajRobustIndoor2023

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
