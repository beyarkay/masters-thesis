# Literature Review

This section will review the literature as related to human hand gesture
detection. There are three primary methods of sensing the movement of a user's
hands: glove-based, vision-based, and (most recently) WiFi-based.

This review is divided into four sections. The first will provide an overview
of the field and some important metrics which will be used to compare different
works. The second section discusses glove-based gesture recognition (Section
\ref{glove-based-gesture-recognition}). This contains the most detail as a
glove-based system for gesture recognition is the subject of this thesis.
Section \ref{vision--and-wiki-based-gesture-recognition} will cover other means
of gesture recognition that do not use a physical glove of some sort, namely
vision-based and WiFi-based. Finally, Section
\ref{applications-of-gesture-recognition} will discuss how gesture recognition
has been used over the decades and how that has affected its development.

There are many different mechanical and electrical technologies involved. These
will be given a brief explanation when they are first mentioned, but the reader
is guided towards the Glossary of Terms \ref{glossary-of-terms} for a more
thorough description

## Overview

Automatic gesture recognition has gone through several periods since the first
attempts in the 1970s, however there are a few themes which have survived
throughout. This literature review covers the periods and themes rather than
the specific papers published, due to the quantity and diversity of work. That
is not to say that reference will not be made to the work done in the field,
but rather that the emphasis will be on the progress made and on relevant
literature surveys.

Automatic gesture recognition has largely evaded a well-established
terminology, with different terms being defined for various concepts based on
the requirements at hand. Nonetheless, these differing definitions are often
guided by similar intuition and so do not result in significant conflict with
one another.

Some of the systems developed aim for "real-time" usage, although a consistent
definition for real-time is lacking. One definition would be to consider the
response time of the system in terms of the number of predictions per second.
This metric is often used, however papers have claimed "real-time" predictions
when their systems make predictions at a rate between 15Hz [@TODO] and 400Hz
[@TODO]. Some papers neglect to mention the prediction rate, and only describe
the system as "real-time" [@TODO]. \footnote{TODO should a description of what
this paper will consider "real-time" be included here?}

\footnote{TODO Note: Many vision-based papers declare the cumber
of glove-based systems, and many glove-based systems declare the background
sensitivity/occlusion problems of vision-based software. Both systems seem
entirely unaware of WiFi-based systems. Possibly because a popular survey
(Mitra 2007) came out just before WiFi CSI tech was discovered.}

This review will use several metrics to enable systematic comparison across
different works in the literature. Different authors have tackled tasks which
are often described similarly, but vary significantly in their difficulty. For
this reason, oft-reported metrics such as model accuracy or number of gesture
classes are rarely directly comparable.

Note that not all authors publicise enough data to describe every metric, and
some papers might have tested multiple systems, resulting in multiple metrics
recorded for that paper.

The metrics are listed below, with short explanations. More detailed
explanations are also given for the metrics which require them.

### Glove/Vision/Wifi based

There are (broadly speaking) three main categories of gesture capture systems:
Glove-based, Vision-based, and (most recently) WiFi-based. Glove-based systems
have some instrument physically connected to the person's hands or forearms.
Vision-based systems use cameras to capture the colour (and possibly also
depth) information of the person performing the gesture. WiFi-based systems are
a relatively new development, and use the noise WiFi signals to infer the
position of the human body.

### Technology Used

This refers to the underlying technology that enables data collection, for
example: flexion sensors, accelerometers, electromyography, RGB cameras with
depth information.

### Number of Classes

The number of classes classified by the system. This is often 26 (one class for
each letter a through z) or 36 (the letters a through z and the numerals 0
through 9).

### Number of Participants

The total number of people who contributed gesture data to the entire dataset,
before the dataset is split into training/validation/testing subsets. One
person recording data in different locations or on different days is still
considered as one person.

### Number of Repetitions

The number of times each person repeated each class. Papers which attempted
one-shot learning often only recorded one repetition for each class.

### Model(s) Used

The type of model used to classify the data. Multiple models can be recorded
for each paper. When a paper used a derivation of a commonly used model, then
the commonly used model was recorded.

### Hardware Used

This is the pre-built hardware used to collect the data. For example, this
might be the Microsoft Kinect, the Nintendo PowerGlove, or a commercially
available webcam.

### Gestures vs Postures

A "gesture" is often used to mean a movement of one or two hands. Sometimes a
"gesture" includes a static position of one or more hands [@TODO], and
sometimes a "gesture" is not limited to hands but also encompasses arm or full
body movement [@TODO]. Sometimes the word "posture" or "pose" is used to
distinguish a hand movement from a hand position [@TODO], despite the
distinction being made in the literature since 1999
@laviolaSurveyHandPosture1999. This review will use the term "gesture" to cover
both static and dynamic hand movements, with the clarification of "dynamic
gesture" or "static gesture" when confusion could arise. Gestures shall also be
assumed to be of the hands and fingers (and not of the arms or body) unless
explicitly noted.

TODO: Note that some sign languages require a temporal element but this is
ignored by some papers. For example, the American Sign Language "j" and "z"
require moving a finger in a "j" or "z" shape respectively, but these are
often ignored.

### Gesture Fidelity

The granularity or level of detail of the gesture. The ability to recognise
someone waving their arms in the air is very different from the ability to
distinguish the dexterous movements required while typing.

The fidelity of a gesture is not often reported, but has great impact on the
difficulty of the problem being attempted. A high-fidelity gesture would be one
which requires the precise control of the user's fingers or thumbs (such as
tapping fingertips together), while a medium-fidelity gesture would require
only the movement of the hand (such the "royal wave" which doesn't move the
arm). A low-fidelity gesture would only require movement of the whole arm, such
as a shaking-of-fists. Higher fidelity gestures are generally a lot trickier to
measure accurately as there are greater degrees of freedom involved and the
absolute amount of motion is less. For ease of comparison, this survey will
discretise fidelity into three levels: finger-fidelity, hand-fidelity, and
arm-fidelity. Further clarification will be provided if these categories do not
adequately classify a certain gesture.

### Explicit and Implicit Segmentation

Do all observations contain _some_ gesture, or does the classification system
have to make that distinction? Explicit segmentation is where the observations
have been segmented such that the start and end of each gesture is provided to
the model, whereas implicit segmentation requires that the classifier first
detect which observations have gestures and then recognise which gestures are
in those observations.

Gesture recognition and gesture detection are sometimes used interchangeably
[@TODO] and sometimes distinguished. This review will define gesture detection
as the boolean classification task of identifying whether _any_ gesture is
present in some data sample, and will define gesture recognition as the
multi-class classification problem of identifying _which_ gesture is present in
some data sample. Note that a gesture recognition system could be trained to
recognise the lack of a gesture as itself being a kind of "null" gesture.

This distinction will prove useful as there have been enough papers which
either 1) train a two-stage system where the gesture recogniser is only invoked
upon successful gesture detection or 2) completely exclude the task of gesture
detection and only train a gesture recognition system.

Note that the second approach (which assumes every observation is a valid
gesture) drastically reduces the practicality of those systems, as any
real-world system would need some way to eliminate the portions of the dataset
which do not contain any gestures.

## Glove-based Gesture Recognition

Glove-based gesture recognition can be defined as any gesture recognition
system which gathers hand information using a device physically attached to the
user's hands or upper arms. While there are some devices which fit this
definition but would not typically be described as a glove [@TODO], they share
enough technical challenges with glove-like devices that this definition will
prove to be a logical one.

### Technologies Used

Different electronic and mechanical technologies have been used over the
decades to instrument the movement of a users hand(s). While they all take a
measurement via different means, the movement they are attempting to capture is
necessarily limited to one of the following: the angle between two bones at
some joint, the physical touching of two parts of the hand, the orientation of
some part of the hand, or the acceleration of some part of the fingers.
Measuring the angle between two bones has typically either involved placing a
strip of material across the joint and measuring the stretching of that
material, or placing a device capable of measuring rotation at the axis of
rotation of the joint. This subsection will solely look at technologies used to
sense changes in hand or arm position and collection of the data. Discussion of
how that data is classified will be done in subsection
\ref{models-and-recognition-techniques}.

The very first devices often used hand crafted sensors (presumably due to a
lack of cheap, small batch electronic sensors at the time) such as optical
tubes which occluded light when bent [@thomasa.defantiUSNEAR60341631977] or
flexion sensors where two parallel conductive metal strips touched when bent
[@garyj.grimesUSPatentDigital1981]. Hall-effect sensors were used by some
[@jacobsenDesignUtahDextrous1986; @jacobsenUTAHDextrousHand1984;
@marcusSensingHumanHand1988] to measure the rotation of different joints.

Commercially available flex sensors (which measured the bend of a short plastic
strip) were first placed across joints and used successfully in several papers
[@abramsgentileentertainmentPowerGlove1989; @baudelCharadeRemoteControl1993;
@felsGloveTalkIIaNeuralnetworkInterface1998;
@zimmermanHandGestureInterface1987]. Flex sensors are unable to accurately
measure very acute angles (such as those between fingers) but are very
intuitive to use, so would see use in commercial applications like the
CyberGlove, the PowerGlove, and the DataGlove.

Accelerometers measure linear acceleration in up to three axes, and Inertial
Measurement Units (IMUs) can measure linear and rotational acceleration,
although the exact details about what is measured often depend on the product
being used. When attached to the user's hand, they provide low-noise
acceleration data which can be used for gesture recognition. Many mobile
devices (such as phones, game controllers, smart watches) contain either an IMU
or an accelerometer and so they provide an easily available means of measuring
movement information if the user holds their device while performing the
gesture. They have been used in many systems, either via a pre-built product
which contained the sensor, or by embedding the sensor into a custom designed
device.

![Different technologies used for glove-based systems](src/imgs/graphs/03_tech_for_gloves.pdf)

Accelerometers were first used by @fukumotoBodyCoupledFingerRing1997 and were
mounted in rings worn at the base of the fingertips. These accelerometers
measured the jerk caused when the user tapped their fingers against a table or
flat surface, and mapped certain jerks to certain keystrokes. Following
@fukumotoBodyCoupledFingerRing1997, acceleration sensors would become popular
for gesture recognition due to their small size and
interpretability\footnote{TODO maybe include more references here?}.

Surface Electromyography (sEMG or EMG) measures the electrical impulses of a
user's muscles. This method generally involves a very noisy signal and does not
have the interpretability of a flex sensor and so requires advanced machine
learning techniques to classify the data. A general overview of the use of
myoelectric signals is provided by the survey
@asgharioskoeiMyoelectricControlSystems2007.

After acceleration and EMG sensors are introduced, there are a few papers
[@zhangHandGestureRecognition2009, @xuzhangFrameworkHandGesture2011,
@kimBichannelSensorFusion2008] which combine acceleration and EMG sensors (often
called "sensor-fusion") to gain better recognition results than either sensor
in isolation.

@rekimotoGestureWristGesturePadUnobtrusive2001 used the changing capacitance of
the body to recognise gestures. This was done by using a bracelet-like device
which would measure how the capacitance through the upper forearm changed as
the user's muscles moved their fingers.

@wenMachineLearningGlove2020 used triboelectric textile sensors to measure the
stretch of a textile glove.

### Landmark Papers

The inaugural investigation into glove-based input was undertaken by Sturman
and Zeltzer in 1994 @sturmanSurveyGlovebasedInput1994 (following Sturman's
dissertation @sturmanWholehandInput1992 on whole-hand input). Sturman and
Zeltzer's survey comprehensively examines the predominant glove-based systems
that were accessible during that period and delves into their respective
applications. Regrettably, the primary accounts concerning these systems have
succumbed to the passage of time, rendering Sturman and Zeltzer's work as the
sole surviving repository of knowledge on the state of the field during that
time.

Following @sturmanSurveyGlovebasedInput1994 the interest in hand gesture
recognition increased significantly, prompting the survey by LaViola
@laviolaSurveyHandPosture1999 which discussed the models and techniques used
for glove and vision based classification, a perspective not present in
@sturmanSurveyGlovebasedInput1994.

In 2007, Mitra and Acharya @mitraGestureRecognitionSurvey2007 surveyed the
software and modelling developments for human gesture recognition (including
face and head tracking)

Shortly after, Dipietro \emph{et~al.} @dipietroSurveyGloveBasedSystems2008
describes the state of glove-based input and how the technology has evolved,
providing a comprehensive summary of the different systems and how they compare
to one another.

Following 2008, there have been several smaller reviews of the literature
[@anwarHandGestureRecognition2019; @chenSurveyHandGesture2013;
@chenSurveyHandPose2020; @harshithSurveyVariousGesture2010;
@kudrinkoWearableSensorBasedSign2021; @rashidWearableTechnologiesHand2019;
@raysarkarHandGestureRecognition2013] however the field has largely moved
towards vision-based systems due to the availability of high quality vision
datasets and the computational power to process them.

![Trend of glove/vision/WiFi based systems over time](src/imgs/graphs/03_based_on_over_time.pdf)

### Hardware Products

Commercially available gloves which can measure the movement of a user's hands
often result in research using those gloves, as the researchers capable of
purchasing a glove-based system are a strict subset of researchers capable of
designing and building a glove-based system. This subsection explores hardware
products which have been used for glove-based gesture recognition.

The Computer Image Corporation of Denver, Colorado developed the ANIMAC (later
named the
[Scanimate](https://www.fondation-langlois.org/html/e/page.php?NumPage=442))
between 1962 and 1971 which performed full body capture for use in computer
graphics, but did not have the fidelity for finger-level gesture capture.

![ANIMAC, @experimentaltelevisioncenterComputerImageCorporation1969](src/imgs/03_experimental_television_center_computer_1969.jpg){ width=50% }

The SayreGlove [@thomasa.defantiUSNEAR60341631977] is often credited as the
first glove-based system developed. It used a combination of optical tubes
which occluded light when bent and parallel conductive pads which touched and
therefore conducted electricity when bent to sense the movement of the user's
hand.

In the 1990s there were three main commercially available products: The
DataGlove developed by VPL systems [@sturmanSurveyGlovebasedInput1994], the
PowerGlove developed Abrams Gentile Entertainment for Nintendo
[@sturmanSurveyGlovebasedInput1994], and the CyberGlove
[@sturmanSurveyGlovebasedInput1994]. These gloves were similar in nature, with
some combination of flex sensors over the phalanges and accelerometers mounted
on the back of the hands.

The Utah/MIT Dexterous Hand and the associated Utah/MIT Dexterous HandMaster
[@jacobsenUTAHDextrousHand1984; @jacobsenDesignUtahDextrous1986] was a complex
system that included both a controller which sensed the position of a human
hand through a series of hall-effect sensors (the HandMaster) and a robotic
hand which could be controlled by this HandMaster.

@marcusSensingHumanHand1988 and @hongCalibratingVPLDataGlove1989 used the VPL
DataGlove to control the Utah/MIT Dexterous Hand.

The Nintendo Wii Remote (often called the Wiimote) was a cheap, commercially
available game controller developed for the Nintendo Wii. It contained a 3-axis
accelerometer and so was used by several researchers to explore gesture
recognition using the acceleration data it provided
[@kratzWiizards3DGesture2007; @netoHighLevelProgramming2010;
@schlomerGestureRecognitionWii2008].

![Different hardware used for glove-based systems](src/imgs/graphs/03_hardware_for_gloves.pdf)

The development of mobile devices with integrated IMU microchips also inspired
development, with several papers proposing systems where the user would simply
hold their smart phone [@xieAccelerometerGestureRecognition2014], smart watch
[@xuFingerwritingSmartwatchCase2015], or Personal Digital Assistant (PDA)
[@kelaAccelerometerbasedGestureControl2006] in their hand and perform a gesture
which would control the device.

The development of the MyoWare Armband resulted in several papers
[@vasconezHandGestureRecognition2022;
@collialfaroUserIndependentHandGesture2022; @zhangRealTimeSurfaceEMG2019].

The Delsys Myomonitor IV was used by @zhangHandGestureRecognition2009 and
@kimBichannelSensorFusion2008.

Notably, @moinWearableBiosensingSystem2020 developed a custom sheet of densely
clustered sEMG sensors which wrapped around the forearm of the user.

### Datasets

There has largely been a lack of commonly used datasets for glove-based systems
due to the lack of commonly used hardware solutions. Some researchers
have recently started making their datasets and code public in the interest of
reproducibility. However, there are no datasets in common use as it is often
easier to develop custom hardware than to try and recreate another researcher's
hardware. There is also a lack of clearly superior glove-based hardware, which
incentivises the development of new hardware and new datasets, instead of using
existing datasets recorded using existing hardware.

The widespread adoption of some standard glove-based system would likely
accelerate the development of superior gesture recognition systems, as curious
researchers would not have to create the hardware themselves but would be able
to focus on creating the classification models. This has already occurred in
vision-based systems, where there now exist widely used datasets recorded on
standard and easily available hardware (see subsection
\ref{non-glove-datasets}).

While commercially available systems do exist, they are largely aimed
at industrial applications and are generally too costly for exploratory
research. It is unlikely for glove-based datasets to become commonly used until
a glove-based system becomes commonly used, and that will require the
glove-based system to be easy to build, cost effective, and applicable to a
wide range of different applications. The SoapBox
[@tuulariSoapBoxPlatformUbiquitous2002] was proposed as such a device, but it
did not receive widespread adoption.

### Models and Recognition Techniques

![Models used for gesture recognition](src/imgs/graphs/03_models.pdf)

Different techniques have been applied to recognise gestures. The exact
application of the model depends on the dataset collected, however some high
level trends can be noticed. The datasets being classified often take the form
of a multi-dimensional time series.

Early on in the field, many researchers extracted a custom designed feature
vector from their data and trained a model on that feature vector. This
approach has recently fallen out of favour, with many recent papers using a
variety of deep learning based methods to learn the features implicitly.

Hidden Markov Models (HMMs) have often been favoured due to their explicit encoding of
time-dependant data. Support Vector Machines (SVMs), Dynamic Time Warping
(DTW), and k-Nearest Neighbours (kNN) have all also been frequently used.

Neural Network based approaches first appeared with
@murakamiGestureRecognitionUsing1991 using a recurrent neural network to
classify a dataset of 42 classes.

Papers which attack implicit segmentation (where not every observation
necessarily contains a gesture, often resulting in a highly imbalanced
dataset) often use a two-model approach, with one model being used for
gesture detection (without attempting to classify which gesture is being
observed) and a second (often more complex) model being used for gesture
recognition _given_ that the observation already contains a gesture. These two
models are chained together, such that the gesture recogniser is only applied
to observations which the gesture detector has found to actually contain a
gesture.

The training times and inference times of different models scale in different
ways. HMMs are unable of performing multi-class classification, and the only
way to create a HMM-based classifier for multiple classes is to train one HMM
for each class. At inference time, every HMM must output the log-likelihood of
the given observation being generated. These log-likelihoods are then compared,
and the class associated with the most likely HMM is selected as the
classifiers prediction. This is called one-vs-rest classification. SVMs also
require one-vs-rest classification.

The problem with one-vs-rest classification is that it scales linearly with the
number of classes being predicted. So performing inference on a dataset with 5
classes will take approximately 10 times shorter than performing inference on a
dataset with 50 classes.

Notably, HMMs have been used by researchers Wang Chunli and Gao Wen to classify
thousands of unique gestures from Chinese Sign Language:
@chunliwangRealTimeLargeVocabulary2001 classified 4800 signs,
@wangchunliRealTimeLargeVocabulary2002 classified 5100 signs, and
@wengaoChineseSignLanguage2004 classified 5113 signs.
@wengaoChineseSignLanguage2004 applied a multi-stage approach, where a
Self-Organising Feature Map (SOM) was used to reduce the dimensionality of the
input data. A simple Recurrent Neural Network was used to detect if there was a
gesture in a particular observation, and then (conditional on a positive
detection) a set of 5113 HMMs were used to recognise which gesture was in that
observation. They applied a modified version of the Viterbi algorithm (the
"lattice" Viterbi Algorithm) to efficiently evaluate the most likely of the
many different HMMs.

The inference and prediction times for neural network based methods do not tend
to grow linearly with the number of classes being predicted. This is due to
their internal architecture being able to support multi-class classification.

## Vision- and WiFi-based Gesture Recognition

TODO: Include some indication of how big the two fields are. Maybe give a bunch
of recent surveys and the number of references each of them have?

This section focuses on non-glove based gesture recognition, which resolves to
just two categories: vision-based (using visible light and depth data), and
WiFi-based (using the effect the human body has on diagnostic information
collected in WiFi networks). This section will not be as detailed as Section
\ref{glove-based-gesture-recognition}, due to the focus of the thesis being
glove-based systems. There is a wealth of research in each of these fields,
with recent review papers of WiFi-based systems citing 157
[@maWiFiSensingChannel2020], 141 [@hussainReviewCategorizationTechniques2020],
68 [@wangCSIbasedHumanSensing2021], and 50 [@maSurveyWiFiBased2016] papers.
Recent reviews of vision-based systems cited 273
[@rautarayVisionBasedHand2015], 150 [@cheokReviewHandGesture2019], and 100
[@oudahHandGestureRecognition2020], papers. While the number of cited papers is
not a precise measure of the size of the field, is does provide an
approximation. The interested reader is directed towards these reviews for a
more detailed treatment of the material.

**How Vision-based systems work** Vision-based systems collect visual data
using video cameras and more recently, depth information, either using LiDAR or
by measuring the reflection of a known infrared projection. The field has
progressed with improved hardware: earlier systems did not have depth
information, had lower-resolution images, did not have colour information, and
had fewer frames per second when compared to modern hardware.

**How WiFi-based systems work** The technology enabling gesture-recognition
with WiFi was implemented in 2009 in the IEEE 802.11n standard. This standard
introduced Channel State Information (CSI) which provided significantly more
information about the noise in an environment than was previously available.
CSI allows transmitters in a WiFi network to change how they transmit data
based on the current channel conditions, which enables more reliable
communication.

Since CSI is very sensitive to the surrounding environment, changes such as a
person moving within a room [@wuWiTrajRobustIndoor2023] or even just breathing
[@wangWeCanHear2014] can induce a change in the CSI, which can then be
detected.

**Datasets** Both vision- and WiFi-based systems have benefited from
standardised hardware, which enables the creation of high-quality diverse
datasets of gestures being performed and recorded on relevant hardware
[@guyonChaLearnGestureChallenge2012, @materzynskaJesterDatasetLargeScale2019,
@alazraiDatasetWiFibasedHumantohuman2020,]. These datasets promote research in
the field, as they provide a common baseline against which new algorithms can
be tested. They also reduce the barrier to entry, as researchers skilled in
modelling but without the resources to collect a large amount of data can still
contributed to the field.

### Chronology of Non-glove-based Systems

##### 1980s

Vision based systems have been discussed since the 1980s
[@boltPutthatthereVoiceGesture1980;
@jenningsComputergraphicModelingAnalysis1988;
@myronw.kruegerArtificialRealityII1991] but the first working system was Yamato
\emph{et~al.}'s paper recognising human actions using feature vectors
recognised by a HMM [@yamatoRecognizingHumanAction1992].

##### 2010s

In 2011, a Halperin \emph{et~al.} published a tool
[@halperinToolReleaseGathering2011] which provided a detailed picture of the
wireless channel conditions using CSI information. The release of this tool
made apparent the level of detail available in CSI and how that information
changes with changes to the environment. Adib and Katabi first applied the data
available in CSI to recognise human gestures [@adibSeeWallsWiFi2013] and were
followed by numerous papers exploring this technique.

---

## Applications of Gesture Recognition

![Applications of gesture recognition](src/imgs/graphs/03_applications.pdf)

One of the most common applications for gesture recognition is classification
of the sign language local to the researcher (for example, American Sign
Language for the USA or Japanese Sign Language for Japan). These languages
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

![Sign Language applications of gesture recognition](src/imgs/graphs/03_sl_applications.pdf)

This has raised some critique from sign language communities [@TODO], however
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

This section provides some useful terms regarding hand anatomy (subsection
\ref{anatomy-of-the-hand}, electronic sensors used when building glove-based
systems (subsection \ref{electronic-sensors}) and hardware products often used
for collecting gesture data (subsection \ref{hardware-products}).

## Anatomy of the hand

The human hand contains 27 bones which are split into three regions: the 14
_phalanges_ (three for each finger and two for the thumb), the 5 _metacarpal
bones_ (the palm bones, each of which connect to a finger or the thumb), and
the 8 _carpal bones_ (the wrist bones, which are arranged in two rows going
across the wrist).

The carpals connect to the bones of the arm: the _radius_ (which is closest to
the thumb) and the _ulnar_ (which is closest to the little finger)

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

![@cabibihanSuitabilityOpenlyAccessible2021](src/imgs/03_movements.png){ width=50% }

## Electronic Sensors

TODO This section is incomplete

- Flex sensor
- Hall effect sensor
- tilt sensor (ADXL202 as used in @rekimotoGestureWristGesturePadUnobtrusive2001)
- Accelerometer
- Inertial Measurement Unit
- Surface Electromyography
- Linear and rotational potentiometers

## Hardware Products

TODO This section is incomplete

- Popularisation of accelerometers in phones and PDAs.
- Microsoft Kinect
- Nintendo Wii
- CyberGlove
  - Pohelmus 3SPACE
- VPL DataGlove
- Nintendo PowerGlove

# Tables

TODO

## Table of common datasets

## Table of common products

## Table of references

# References
