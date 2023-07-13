# Literature Review

Brief overview and description of structure (vision, glove, and WiFi based
systems)

Useful terminology and disambiguations are given in \ref{terminology}.
Vision-based systems are described in \ref{vision-based-systems}. Glove-based
systems are described in \ref{glove-based-systems}. WiFi-based systems are
described in \ref{wifi-based-systems}. An overview of the literature and
comparisons are provided in \ref{overview}. A glossary of useful terms is
provided in \ref{glossary-of-terms}.

# Terminology

A brief description of the terminology used in this review will be
advantageous, as many authors use differing or conflicting terms.

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

![@noauthor_medical_2014](src/imgs/03_bones.png)

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

![@cabibihan_suitability_2021](src/imgs/03_movements.png)

## Gestures vs Poses

The English word "gesture" is usually used exclusively for the act of moving a
body part. However, some authors use the word to refer to a particular position
_or_ a movement of a body part. For clarity, this review will define "gesture"
as a movement of one or more body parts, and "pose" as the position of one or
more body parts.

Unless otherwise specified, a gesture or a pose will refer to that of the hand
or hands, as opposed to a gesture/pose involving the participant's entire body.

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

![@experimental_television_center_computer_1969](src/imgs/03_experimental_television_center_computer_1969.jpg)

The first glove-based system which could capture per-finger movement was the
Sayre Glove [@thomas_a_defanti_us_1977], invented in
[1977](https://mlab.taik.fi/briefhistory/old/vr_timeline/sayre.html) or
[1976](https://www.evl.uic.edu/pubs/2296) by Dan Sandin and Thomas Defanti. The
Sayre glove was based on an idea by their colleague, Richard Sayre. The glove
used flexible tubes which would occlude a light source from a sensor placed at
opposite ends of the tubes.

![By @thomas_a_defanti_us_1977](src/imgs/03_thomas_a_defanti_us_1977_2.png)

![By @thomas_a_defanti_us_1977](src/imgs/03_thomas_a_defanti_us_1977_1.png)

In 1981 Gary J. Grimes filed a patent through Bell Telephone Laboratories Inc.
for a Digital data entry glove interface [@gary_j_grimes_us_1981]. This glove
used 4 "knuckle-bend-sensors", 18 touch sensors, 2 tilt sensors, and a mode
switch which in combination would allow the user to sign the English alphabet
and the numerals 0 through to 9 in a manner similar to American Sign Language.

![@gary_j_grimes_us_1981](src/imgs/03_gary_j_grimes_us_1981.png)

The Dexterous HandMaster [@jacobsen_utahmit_1984, @marcus_sensing_1988] was
developed in 1984 as a controller for the Utah/MIT Dexterous Hand robot
[@jacobsen_design_1986], and has since been redesigned and was sold
commercially by Exos. It uses 20 hall-effect\footnote{define these} sensors to
measure the flexion of the interphalangeal joints, with 4 sensors for each
finger and thumb. @watson_survey_1993 reports the price of the Dexterous Hand
Robot at US$15 000 in 1993.

![@marcus_sensing_1988](src/imgs/03_marcus_sensing_1988.png)

@fisher_telepresence_1987 working at NASA's Ames research centre created a
glove which was capable of transmitting data to the host computer in real time.
This glove used 15 flex sensors per hand and a "3D magnetic digitizing
device" capable of reporting the X, Y, Z, azimuth, elevation, and roll
coordinates to the host computer (see Figure \ref{TODO}).

![@fisher_telepresence_1987](src/imgs/03_fisher_telepresence_1987.png)

@zimmerman_hand_1987 developed the DataGlove which measured 10 finger joints,
and was significantly easier to use and weighed less than previous devices.
This was commercialised by VPL Research. The device used optical fibres aligned
along the fingers. Bending the finger reduces the amount of light which can
reach the end of the fibre optic. This reduction can be measured by a
photo-resistor, which allows the glove to calculate the flexion at each joint.
@watson_survey_1993 reports the price of the DataGlove at US$8 000 in 1993.

![@zimmerman_hand_1987](src/imgs/03_zimmerman_hand_1987.png)

The Mattel Toy company produced the PowerGlove in 1989
[@abrams_gentile_entertainment_powerglove_1989] as a low-cost game controller,
intended for use with Nintendo home video games. The device uses resistive-ink
flex sensors that measure the bending of the thumb, index, middle, and ring
fingers. Two ultrasonic transmitters mounted on the back of the glove and
paired with three ultrasonic receivers mounted at known relative distances on
the user's monitor allow the glove to calculate the locations of the
transmitters via triangulation. The device was discontinued after two years,
but its low cost prompted many researchers to continue using the glove as an
input device [@TODO, @TODO, @TODO] for years to come. @watson_survey_1993
reports the price of the PowerGlove as US$20 in 1993.

![@abrams_gentile_entertainment_powerglove_1989](src/imgs/03_abrams_gentile_entertainment_powerglove_1989.jpg)

### 1990s

The CyberGlove was developed by James Kramer for his company Virtual
Technologies, Inc. in 1990. Virtual Technologies, Inc. was acquired by
Immersion Corporation in 2000 [@immersion_corporation_cyber_2001]. The
CyberGlove had either 18 or 22 sensors (depending on the model purchased) and
used flex sensors to measure the relative positions of the fingers and thumb.

The Space Glove was developed by W Industries for use of their virtual reality
gaming product "Virtuality" in 1991 [@sturman_survey_1994]. This device also
uses flex-sensors to measure the bend of the finger joints, with one sensor per
finger and two sensors for the thumb.

Surveys by @watson_survey_1993 and @sturman_survey_1994 on glove-based input
provided a comprehensive description of gesture sensing at the time.

### 2000s

### 2010s

### 2020s

### Common hardware

Note that the term "dataglove" has both been used when referring to a
particular device and when referring to the set of devices which are worn as a
glove and collect data about the wearer's hand position. For clarity, the term
"glove" will be used to refer to all glove-based gesture recognition systems
and the term dataglove will be clarified with the creator of the dataglove in
question.

TODO define:

- Flex sensor
- Hall effect sensor
- Accelerometer

#### CyberGlove (5DT Systems)

#### Tri-axis accelerometers

#### Inertial Measurement Units

#### Surface Electromyography (EMG or sEMG)

#### Flex sensors

## Vision-based systems

When digital video recording systems became commercially viable around the
TODO, live video feed started to be used as input data from which hand position
could be extracted. This was first done by @TODO. The launch of the Microsoft
Kinect (an affordable RGB camera system with infrared depth sensing) in 2010
produced a boom of vision-based systems (see Figure \ref{TODO}), as the Kinect
provided an easy way for high quality datasets to be obtained. From these
common datasets, researchers could build off of each others work to make
greater and greater progress.

Split by decade, noting any trends along the way. Note the seminal paper.

### Common hardware

#### Microsoft Kinect

## WiFi-based systems

In the year TODO, it was realised that the signals used for household WiFi were
sensitive enough that they would be affected by small changes in the
environment, such as a person breathing or chewing. @TODO were the first to
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

# References
