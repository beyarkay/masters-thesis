# Literature Review

This section will review the literature as related to human hand gesture
detection. There are three primary methods of sensing the movement of a user's
hands: glove-based, vision-based, and (most recently) WiFi-based.

A glossary of useful electronic and anatomical terms is provided in Section
\ref{glossary-of-terms}.

## Overview

Automatic gesture recognition has gone through several periods since the first
attempts in the 1970s, however there are a few themes which have survived
throughout. This literature review covers the periods and themes rather than
the specific papers published, due to the quantity and diversity of work. That
is not to say that reference will not be made to the work done in the field,
but rather that the emphasis will be on the progress made and on relevant
literature surveys.

Automatic gesture recognition has largely evaded a well-established terminology,
with different terms being defined for various concepts based on the
requirements at hand. Nonetheless, these differing definitions are often guided
by similar intuition and so rarely conflict with one another.

A "gesture" is often used to mean a movement of one or two hands. Sometimes a
"gesture" includes a static position of one or more hands [@TODO], and
sometimes a "gesture" is not limited to hands but also encompasses arm or full
body movement [@TODO]. Sometimes the word "posture" or "pose" is used to
distinguish a hand movement from a hand position [@TODO]. This review will use
the term "gesture" to cover both static and dynamic hand movements, with the
clarification of "dynamic gesture" or "static gesture" when confusion could
arise. Gestures shall also be assumed to be of the hands and fingers (and not
of the arms or body) unless explicitly noted.

The fidelity or granularity of a gesture is not often reported, but has great
impact on the difficulty of the problem being attempted. A high-fidelity
gesture would be one which requires the precise control of the user's fingers
or thumbs (such as tapping fingertips together), while a medium-fidelity
gesture would require only the movement of the hand (such the "royal wave"
which doesn't move the arm). A low-fidelity gesture would only require movement
of the whole arm, such as a shaking-of-fists. Higher fidelity gestures are
generally a lot trickier to measure accurately as there are greater degrees of
freedom involved and the absolute amount of motion is less. For ease of
comparison, this survey will discretise fidelity into three levels:
finger-fidelity, hand-fidelity, and arm-fidelity.\footnote{TODO: do these need
precise definitions?} Further clarification will be provided if these
categories do not adequately classify a certain gesture.

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
which do not contain any gestures. This is often [@TODO] called the
segmentation problem.

Some of the systems developed aim for "real-time" usage, although a consistent
definition for real-time in this field is lacking. One approach would be to
consider the response time of the system in terms of the number of predictions
per second. This metric is often used, however papers have claimed "real-time"
predictions when their systems operate at anywhere between 15Hz [@TODO] and
400Hz [@TODO]. Some papers neglect to mention the prediction rate, and only
describe the system as "real-time" [@TODO].\footnote{TODO should a description
of what this paper will consider "real-time" be included here?}

The majority of this review will discuss glove-based gesture recognition
(subsection \ref{glove-based-gesture-recognition}) as the subject of this
thesis is a glove-based system for gesture recognition. Subsection
\ref{vision--and-wiki-based-gesture-recognition} will cover other means of
gesture recognition that do not use a physical glove of some sort. Finally,
subsection \ref{applications-of-gesture-recognition} will discuss how gesture
recognition has been used over the decades and how that has affected its
development.

There are many different mechanical and electrical technologies involved. These
will be given a brief explanation when they are first mentioned in a section,
but the reader is guided towards the Glossary of Terms \ref{glossary-of-terms}
for a more thorough description

\footnote{TODO Note: Many vision-based papers declare the clumber
of glove-based systems, and many glove-based systems declare the background
sensitivity/occlusion problems of vision-based software. Both systems seem
entirely unaware of wifi-based systems. Possibly because a popular survey
(Mitra 2007) came out just before wifi CSI tech was discovered.}

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

Surface Electromyography (sEMG or EMG) measures the electrical impulses of a
user's muscles. This method generally involves a very noisy signal and does not
have the interpretability of a flex sensor and so requires advanced machine
learning techniques to classify the data. It was used for gesture recognition
by @zhangHandGestureRecognition2009. A general overview of the use of
Myoelectric signals provided by the survey
@asgharioskoeiMyoelectricControlSystems2007.

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

Accelerometers were first used by @fukumotoBodyCoupledFingerRing1997 and were
mounted in rings worn at the base of the fingertips. These accelerometers
measured the jerk caused when the user tapped their fingers against a table or
flat surface, and mapped certain jerks to certain keystrokes. Following
@fukumotoBodyCoupledFingerRing1997, acceleration sensors would become popular
for gesture recognition due to their small size and
interpretability\footnote{TODO maybe include more references here?}.

@rekimotoGestureWristGesturePadUnobtrusive2001 used the changing capacitance of
the body to recognise gestures. This was done by using a bracelet-like device
which would measure how the capacitance through the upper forearm changed as
the user's muscles moved their fingers.

---

Note: sEMG becomes popular and sEMG+IMU often can solve many issues with
recognising sign language (since some signs have nearly identical features for
IMU but are distinguishable with sEMG, however sEMG isn't enough to distinguish
many other gestures easily)

### Landmark Papers

Landmark papers in the field

### Hardware Products

Hardware products that got released

- MyoWare product

### Datasets

Commonly used datasets and the lack of common base upon which development can
be made.

### Models and Recognition Techniques

Trends in the types of models used

## Vision- and WiFi-based Gesture Recognition

Landmark papers in the field

Trends in the type of sensors used

Hardware products that got released

Commonly used datasets and the lack of common base upon which development can
be made.

Trends in the types of models used

## Applications of Gesture Recognition

- Sign language is like the Utah Teapot
  - The point often isn't sign language, it's just the first set of
    non-trivial easy-to-explain signs that most people know about.

---

What themes should be covered?

To include:

- Table of common datasets
- Table of common products
- Table of references
- Make it obvious when one paper doesn't contribute much
- Details about the stand-out papers
- Cover the large themes

Themes to make Ergo look good:

- What level of detail do the gestures permit? (phalange, finger, hand, arm,
  body?). Are they static or dynamic?
- How many gestures can be recognised?
- Is segmentation automatic or does the user have to specify the start/end of
  the gesture?
- How much freedom does the user have when moving their hands?

## Glove-based systems

Glove-based systems are characterised by electronic sensors which were embedded
in a "glove" that the user would wear. Many different sensor types have been
proposed over the decades measuring acceleration, skin capacitance, joint
flexion, and muscle-based electrical impulses.

The lack of an affordable high-fidelity sensor glove has resulted in a high
barrier to entry. Those researchers who are able to acquire or build a sensor
glove have often had to reinvent the wheel, as the findings from one sensor
suite will not be applicable to any other sensor suite.

## Vision-based systems

## WiFi-based systems

In the year 2001, it was realised that the signals used for household WiFi were
sensitive enough that they would be affected by small changes in the
environment, such as a person breathing or chewing
[@halperinToolReleaseGathering2011]. @adibSeeWallsWiFi2013 were the first to
show that device-free gesture detection was possible via this mechanism, and
since then many researchers have explored this area. Because WiFi-based systems
are dependant only on commercially available routers, many high quality
datasets have been gathered and released. These datasets facilitate the
advancement of WiFi-based gesture detection because they drastically lower the
complexity required to get started, allow for results to be reproduced, and
allow for new techniques to be compared to old ones.

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

This section is incomplete

- Flex sensor
- Hall effect sensor
- tilt sensor (ADXL202 as used in @rekimotoGestureWristGesturePadUnobtrusive2001)
- Accelerometer
- Inertial Measurement Unit
- Surface Electromyography
- Linear and rotational potentiometers

## Hardware Products

This section is incomplete

- Popularisation of accelerometers in phones and PDAs.
- Microsoft Kinect
- Nintendo Wii
- CyberGlove
  - Pohelmus 3SPACE
- VPL DataGlove
- Nintendo PowerGlove

# References
