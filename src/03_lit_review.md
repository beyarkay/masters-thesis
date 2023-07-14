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

![ANIMAC, @experimentaltelevisioncenterComputerImageCorporation1969](src/imgs/03_experimental_television_center_computer_1969.jpg)

The first glove-based system which could capture per-finger movement was the
Sayre Glove [@thomasa.defantiUSNEAR60341631977]. The Sayre glove was based on an idea
by their colleague, Richard Sayre. The glove used flexible tubes which would
occlude a light source from a sensor placed at opposite ends of the tubes.

![Sayre glove, By @thomasa.defantiUSNEAR60341631977](src/imgs/03_thomas_a_defanti_us_1977_2.png)

![Sayre glove, By @thomasa.defantiUSNEAR60341631977](src/imgs/03_thomas_a_defanti_us_1977_1.png)

In 1981 Gary J. Grimes filed a patent through Bell Telephone Laboratories Inc.
for a Digital data entry glove interface [@garyj.grimesUSPatentDigital1981]. This glove
used 4 "knuckle-bend-sensors", 18 touch sensors, 2 tilt sensors, and a mode
switch which in combination would allow the user to sign the English alphabet
and the numerals 0 through to 9 in a manner similar to American Sign Language.

![Digital data entry glove interface, @garyj.grimesUSPatentDigital1981](src/imgs/03_gary_j_grimes_us_1981.png)

The Dexterous HandMaster [@jacobsenUTAHDextrousHand1984, @marcusSensingHumanHand1988] was
developed in 1984 as a controller for the Utah/MIT Dexterous Hand robot
[@jacobsenDesignUtahDextrous1986], and has since been redesigned and was sold
commercially by Exos. It uses 20 hall-effect\footnote{define these} sensors to
measure the flexion of the interphalangeal joints, with 4 sensors for each
finger and thumb. @watsonSurveyGestureRecognition1993 reports the price of the Dexterous Hand
Robot at US$15 000 in 1993.

![Dexterous HandMaster, @marcusSensingHumanHand1988](src/imgs/03_marcus_sensing_1988.png)

@fisherTelepresenceMasterGlove1987 working at NASA's Ames research centre created a
glove which was capable of transmitting data to the host computer in real time.
This glove used 15 flex sensors per hand and a "3D magnetic digitizing
device" capable of reporting the X, Y, Z, azimuth, elevation, and roll
coordinates to the host computer (see Figure \ref{TODO}).

![NASA telepresence, @fisherTelepresenceMasterGlove1987](src/imgs/03_fisher_telepresence_1987.png)

@zimmermanHandGestureInterface1987 developed the DataGlove which measured 10 finger joints,
and was significantly easier to use and weighed less than previous devices.
This was commercialised by VPL Research. The device used optical fibres aligned
along the fingers. Bending the finger reduces the amount of light which can
reach the end of the fibre optic. This reduction can be measured by a
photo-resistor, which allows the glove to calculate the flexion at each joint.
@watsonSurveyGestureRecognition1993 reports the price of the DataGlove at US$8 000 in 1993.
\footnote{TODO: Note that the DataGlove could be combined with a Polhemus 3D tracker}

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

![VPL DataGlove, @zimmermanHandGestureInterface1987](src/imgs/03_zimmerman_hand_1987.png)

![The outer glove and glove lining of the DataGlove. Flex sensors and fibre
optic cables are visible, as well as the interface board used to read the
sensors' measurements. @wiseEvaluationFiberOptic1990](src/imgs/03_wise_evaluation_1990.png)

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

![Powerglove, @abramsgentileentertainmentPowerGlove1989](src/imgs/03_abrams_gentile_entertainment_powerglove_1989.jpg)

@kramerTalkingGlove1988 developed the Talking Glove, which would later become the
VirTex CyberGlove. The talking glove was designed for general purpose communication
with deaf-blind or non-vocal people. For sensors, the Talking Glove used
flexible strain gauges to detect the amount of flexion in each finger. Gestures
are recognised using $k$-Nearest-Neighbours with $k=1$, such that only one
training example is required for each gesture.

![Talking glove, @kramerTalkingGlove1988](src/imgs/03_kramer_talking_1988.png)

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
@laviolaSurveyHandPosture1999](src/imgs/03_laviola_survey_1999.png)

@wiseEvaluationFiberOptic1990 evaluated the DataGlove as an alternative to manual
goniometry, such that the range of motion of the hand can be automatically
captured. The repeatability and accuracy was measured on five participants, and
the DataGlove was found to have an average error of $5.6^{\circ}$. This was
comparable to manual measurement, however the DataGlove is unable to measure
adduction, abduction, wrist motion, or the full range of motion for the thumb.
They concluded that the DataGlove could become an effective clinical tool with
further development.

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

Surveys by @watsonSurveyGestureRecognition1993 and
@sturmanSurveyGlovebasedInput1994 on glove-based input provided a comprehensive
description of gesture sensing at the time.

@baudelCharadeRemoteControl1993 utilized the DataGlove to give a presentation and proposed
a set of design guidelines for using glove-based input effectively. A custom
set of icons was developed to describe a gesture, and included symbols for open
or closed fingers and palm orientation

![Charade custom gesture description symbols, @baudelCharadeRemoteControl1993](src/imgs/03_baudel_charade_1993.png)

@kesslerEvaluationCyberGloveWholehand1995 performed a critical evaluation of the CyberGlove for
whole-hand input. They concluded that different hand sizes do not significantly
impact the user's ability to use the device, but calibration of the glove could
increase repeatability and accuracy.

From 1995, there was a significant increase in the use of glove-based systems
for sign-language input and interpretation:

@kadousGRASPRecognitionAustralian1995 (later published as @kadousMachineRecognitionAuslan1996) used data from the
PowerGlove to recognise 95 signs from Australian Sign Language, comparing a
variety of simple machine learning methods such as C4.5 [@quinlanC4ProgramsMachine1992] and
instance-based learning [@ahaInstancebasedLearningAlgorithms1991]. This more than doubled the
previous state of the art [@starnerVisualRecognitionAmerican1995] in terms of the number of
signs recognised and showed that glove-based systems did not need significant
precision in order to distinguish between different gestures.

@liang3DConvolutionalNeural2018 used data from the DataGlove to recognise 50 signs from
Taiwanese Sign Language using a set of hidden Markov models, with one model for
each sign.

@felsBuildingAdaptiveInterfaces1990 used multiple neural networks to convert
the DataGlove input into phonemes which could then be emitted as spoken words.

@rung-hueiliangRealtimeContinuousGesture1998 expanded their previous work
[@liang3DConvolutionalNeural2018], using the DataGlove to recognise 65 different states (51
postures, 6 orientations, and 8 motions) via a set of hidden Markov models and
a language model to discard syntactically improbably predictions.

@laviolaSurveyHandPosture1999 reviewed the state of the art for gesture recognition
techniques, covering both glove-based and vision-based systems. The different
glove-based systems are enumerated and compared, describing their accuracy,
price, and ease-of-use. Different algorithms used for processing the vision- or
glove-based data into gesture classifications were also discussed.

### 2000s

@alviPakistanSignLanguage2007

@chunliRealTimeLargeVocabulary2002

@damasioAnimatingVirtualHumans2002

@dipietroSurveyGloveBasedSystems2008

@fifthdimensiontechnologiesDataGlove52005

@gaoChineseSignLanguage2004

@hernandez-rebollarAcceleGloveWholehandInput2002

@heumerGraspRecognitionUncalibrated2007

@immersioncorporationCyberGlove2001

@immersionincImmersionIncCyberGlove2005

@karantonisImplementationRealTimeHuman2006

@kelaAccelerometerbasedGestureControl2006

@klingmannAccelerometerBasedGestureRecognition2009

@kolschKeyboardsKeyboardsSurvey2002

@kongGestureRecognitionModel2009

@kratzWiizards3DGesture2007

@liuUWaveAccelerometerbasedPersonalized2009

@mantyjarviEnablingFastEffortless2004

@mantyjarviGestureInteractionSmall2005

@mantyjarviIdentifyingUsersPortable2005

@mehdiSignLanguageRecognition2002

@mitraGestureRecognitionSurvey2007

@mohandesAutomationArabicSign2004

@ongAutomaticSignLanguage2005

@parsaniSingleAccelerometerBased2009

@prekopcsakAccelerometerBasedRealTime2008

@pylvanainenAccelerometerBasedGesture2005

@rekimotoGestureWristGesturePadUnobtrusive2001

@salibaCompactGloveInput2004

@schlomerGestureRecognitionWii2008

@tuulariSoapBoxPlatformUbiquitous2002

@wangRealTimeLargeVocabulary2001

@wangTrafficPoliceGesture2008

@wuGestureRecognition3D2009

@zhangHandGestureRecognition2009

TODO: When do the first accelerometer based gloves appear?

### 2010s

### 2020s

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
\marginpar{flesh this out a bit more}

![Put-that-there, @boltPutthatthereVoiceGesture1980](src/imgs/03_bolt_put-that-there_1980.png)

### 1990s

@yamatoRecognizingHumanAction1992

@davisVisualGestureRecognition1994 https://www.semanticscholar.org/paper/Visual-gesture-recognition-Davis-Shah/99ad93149fcdcae534e2361a32b0389e83003113/figure/0

@freemanOrientationHistogramsHand1995
@starnerRealtimeAmericanSign1995
@starnerVisualRecognitionAmerican1995

@pavlovicVisualInterpretationHand1997

@rigollHighPerformanceRealtime1998
@hofmannVelocityProfileBased1998
@segenHumancomputerInteractionUsing1998
@starnerRealtimeAmericanSign1998
@sharmaASL3DCNNAmericanSign2021
@segenFastAccurate3D1998
@eickelerHiddenMarkovModel1998

@ming-hsuanyangRecognizingHandGesture1999
@hyeon-kyuleeHMMbasedThresholdModel1999
@moeslundComputerVisionBasedHuman1999
@moeslundSummaries107Computer1999
@laviolaSurveyHandPosture1999
@wilsonParametricHiddenMarkov1999

TODO: see background of @wilsonParametricHiddenMarkov1999

### 2000s

@moeslundSurveyAdvancesVisionbased2006

TODO

### 2010s

TODO

### 2020s

TODO

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

# Overview

This is where you show that you actually understand the work at hand

# Glossary of terms

TODO

## Electronic Sensors

TODO

- Flex sensor
- Hall effect sensor
- Accelerometer
- Inertial Measurement Unit
- Surface Electromyography

## Hardware Products

TODO

- Microsoft Kinect
- CyberGlove
- VPL DataGlove
- PowerGlove

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

![@MedicalGalleryBlausen2014](src/imgs/03_bones.png)

The joints between bones are, logically, named according the bones they
connect:

- _Carpometacarpal_ (CMC): Those joints connecting the carpal (wrist) bones to
  the metacarpal (palm) bones.

- _Metacarpophalangeal_ (MCP): Those joints connecting the metacarpal (palm)
  bones to the palangeal (finger) bones.

- _Interphalangeal_ (IP): Those joints between the phalangeal (finger) bones.
  Due to the number of phalangeal bones, these are subdivided into the _distal
  interphalangeal_ bones (DIP, closest to the fingertip) and the _proximal
  interphalangeal_ bones (PIP, closest to the palm).

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

![@cabibihanSuitabilityOpenlyAccessible2021](src/imgs/03_movements.png)

## Gestures vs Poses

The English word "gesture" is usually used exclusively for the act of moving a
body part. However, some authors use the word to refer to a particular position
_or_ a movement of a body part. For clarity, this review will define "gesture"
as a movement of one or more body parts, and "pose" as the position of one or
more body parts.

Unless otherwise specified, a gesture or a pose will refer to that of the hand
or hands, as opposed to a gesture/pose involving the participant's entire body.

# References
