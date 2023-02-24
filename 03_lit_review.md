# Literature Review


This is some literature review

## Related Work

Prior work has been done both in the formal literature and on various platforms
by hobbyists or open source communities.  Note that some works in the
literature use the word "gesture" to refer to a hand position without movement.
Where clarification is required, the word "posture" shall be used to refer to a
particular positioning of the hands, while "gesture" shall be reserved for a
specific movement of the hands.

### Formal Literature

A formal literature review is presented in this section on the topic of
gesture-centric human-computer interaction methods. A chronological order is
adopted for the review.

@murakami1991 trained an Elman recurrent neural network to recognise ten
dynamic gestures from the Japanese Finger Alphabet. These gestures were all
single hand motions which involved a single hand in motion while the fingers
remained still. The input data came from a "Data Glove", although the make and
model of the glove was not specified. The Data Glove provided ten values
describing the bend of the fingers and six auxiliary values describing the
position of the Data Glove.

@starner1995 describe a Hidden Markov Model (HMM) capable of classifying 40
gestures from the American Sign Language. These gestures usually include motion
of both hands. The input data are frames from a video, at a rate of five frames
per second. These frames are of a seated user who wear coloured gloves to
assist with segmentation of the user's hands from the background.

@segen1998a describe a camera-based system which can recognise two static
single-hand positions and one dynamic single finger motion. This is used for
video game control and as a scene editor which can pick and move virtual
objects. Their system required the user's hand to be in front of a plain black
background with no other items in the frame.

@eickeler1998 extended an existing HMM-based image
classification system to facilitate continuous online recognition of
spontaneous gestures. The input data was the difference of adjacent frames of a
video (to help emphasise the motion in the video). They are able to classify
six gestures in real time.

@hofmann1998 used the SensorGlove developed by the Technical University of
Berlin [@hofmann1995] to segment and classify continuous input data into
gesture predictions by using a HMM.

@lee1999 presented a HMM-based image classification system able to classify ten
gestures, and is also able to discard unknown or unseen patterns. These
gestures were single hand motions which traced arcs or patterns in front of the
camera.

@keskin2003 developed a HMM-based system which classifies gestures based on
video input of brightly coloured gloves (similar to @starner1995). The system
is able to classify eight dynamic gestures consisting of single hand motions
which trace out simple shapes in front of the camera.

@kadous1995 used a one-hand Nintendo PowerGlove to distinguish between 95
different signs from Australian Sign Language. The start and end of each sign
had to be manually indicated by pressing a button on the PowerGlove. These
signs are often dynamic gestures in which both hands trace some path but keep
the finger positions still. Only one PowerGlove was used, despite many of the
signs being two-handed. The author discarded the idea of building a PowerGlove
equivalent themselves, as that effort was considered to be a thesis in and of
itself.

@manresayee2005 developed a project which controls a video game based on static
single-hand postures. These postures are captured from video stills taken from
a web camera Four static single hand postures were recognised.

@rekimoto2001 developed a watch-like device named GestureWrist which recognises
human hand gestures by measuring changes in wrist shape via capacitive sensors,
as well as measuring forearm movement based on acceleration sensors. It
requires the start and end of each gesture to be indicated by the user, and
gestures were made up of simple full arm transitions such as palm facing
upwards to palm facing downwards.

@mantyjarvi2004 developed a HMM which used linear acceleration in three axes to
classify eight gestures. This work was built upon by @kela2006 who utilised the
Sensing, Operating, and Activating Peripheral Box (SoapBox) developed by
@tuulari2002 to collect motion data which was classified into gestures by a
HMM. The resulting classifications were used to interact with a custom designed
suite of software which was tailored to make use of the more intuitive gesture
interface. The number of gestures that their system could recognise was not
reported.

@marcelo2006 created GeFighters, a fighting game where the primary means of
interacting with the game comes from gestures performed in front of a camera.
This system requires large fiducial markers to be held in the user's hands.
These black and white markers are recognised by the computer system and their
relative positioning is used as input to the GeFighters game engine. A total of
nine gestures were recognisable by the system.

@kratz2007 combined the Nintendo Wii remote with a HMM in order to allow two
users to compete in a game. In this game, the players must draw shapes with the
Nintendo Wii remote. This model was trained on ten gestures performed by
multiple users, and used the 3-axis accelerometer data as input. See Section
\ref{the-adxl335-accelerometers} for details about accelerometer sensors and
the values provided by them.

@alvi2007 used a single-handed DataGlove5 (developed by
@fifthdimensiontechnologies) to recognise 31 signs from Pakistan Sign Language
(PSL) based on the standard deviations a given input gesture was from any of
several reference gestures. Gestures using two hands was not attempted.

@heumer2007 presented a literature review of machine learning models used to
classify postures, and compares the different proposed methods. Their focus was
on methods that do not require that the data glove being used to be calibrated.
This review re-implemented a wide variety of previously proposed classifiers,
and evaluated them on the task of classifying six postures representing a user
holding various objects (such as pencils, soda cans, and floppy discs). The
data glove used was the wireless CyberGlove II by @immersioninc. Only one hand
was used in this review.

@wu2009 presented the Frame-based Descriptor and Multi-Class SVM (FDSVM) as an
accelerometer-based gesture recognition model. They trained FDSVM on 12
gestures in order to prove that it outperforms approaches based on HMMs, Naïve
Bayes, Dynamic Time Warping (see @senin2008 for a review), and C4.5
[@quinlan1992]. The Nintendo Wii remote was employed as the device by which
sensor data was collected.

@liu2009 presented an efficient gesture recognition method based on Dynamic
Time Warping called uWave. uWave accepts sensor readings from a single 3-axis
accelerometer as input, and notably requires a single training sample per
unique gesture. They learnt eight full hand dynamic gesture patterns with data
recorded from multiple users.

@akl2011 used a single three-axis accelerometer and dynamic time warping to
classify 18 gestures comprised of single hand motions. These gestures were
simple single handed pattens traced out in the air, such as circles, lines, and
triangles.

@whitehead2014 used discrete HMMs to recognise gestures from three-axis linear
accelerometer data captured by a watch-like device strapped to the user's
forearm. Seven gestures were learnt by the trained models and only single
handed gestures were considered.

@hurroo2020 trained a 2D Convolutional Neural Network (CNN) to recognise
segmented images of ten letters signed in American Sign Language. This work
does not attempt live recognition, but rather takes images of a hand on a plain
background and attempts to recognise the sign being performed.

### Informal Work

In addition to the formal literature, work has been done by hobbyists and
amateur roboticists in either building their own sensor glove or in processing
the information from a given sensor glove. These works are discussed below.

The [Sensor Glove](https://github.com/SensorGlove/SensorGlove) (only available
in Spanish, and unrelated to the SensorGlove developed by the Technical
University of Berlin [@hofmann1995]) was a project in 2017 by six alumni from
the University of Madrid. They built a textile glove with an accelerometer
which could be used to control a remote control car by holding one's hand in
the correct orientation. There is not enough detail available on the project's
website to determine the number of gestures which could be recognised by the
Sensor Glove.

[LucidVR](https://github.com/LucidVR/lucidgloves) is a project which aims to
provide affordable hand tracking for Virtual Reality (VR) games. LucidVR has an
emphasis on integrated force feedback, which allows the user to sense solid
objects in VR. User input is limited to measuring the amount by which each
finger is bent.

The [gesture recognition
bracer](https://github.com/ATLTVHEAD/Atltvhead-Gesture-Recognition-Bracer)
created by live streamer [atltvhead](https://www.twitch.tv/atltvhead) is a
bracer that straps to the user's forearm and allows them to control various
live streaming settings by moving their forearm. The bracer contains a linear
6-axis accelerometer which provides linear and rotational acceleration for the
two machine learning models which are trained: a CNN and a Long-Short Term
Memory (LSTM) network.

The [Gesture Recognition Toolkit](https://github.com/nickgillian/grt) (GRT)
contains numerous machine learning algorithms for creating gesture recognition
applications from sensor data. It was initially developed by @gillian2014 and
later expanded on by volunteer contributors. The GRT is unmaintained as of
2019.

The project named [Gesture Recognition Using Accelerometer and
ESP](https://create.arduino.cc/projecthub/mellis/gesture-recognition-using-accelerometer-and-esp-71faa1)
uses Dynamic Time Warping to allow any user to download the software and
classify up to nine user-specified gestures from a three-axis accelerometer. It
was built on top of the Gesture Recognition Toolkit developed by @gillian2014.
