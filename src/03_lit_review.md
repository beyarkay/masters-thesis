# Literature Review

MSc literature review should basically be a survey. A very good literature
review should be able to submit it as a survey paper. Rather err to having too
much information. A survey paper would also include the challenges in the
field, but the literature review doesn't need to include this.

For referencing survey papers,

- First list the survey papers and how they grouped the literature. Then go
  through each of the direct papers.
- They give you an idea about how to group different papers (can use own
  strategy, or use a strategy already used in a review)
- Can use the survey papers to find the references

## Outline

- Describe commercial products

  - Nintendo Wiimote
  - Microsoft Kinect
  - Microsoft Hololens
  - [Intel Realsense](https://www.intelrealsense.com/)
  - [Hi5 VR Glove](https://hi5vrglove.com/)
  - The Humanglove, Humanware

- Describe previous surveys

  - 0002 citations @Park2019AdvancedML
  - 0025 citations @Chatzis2020ACS
  - 0051 citations @Li2019ASO
  - 0065 citations @AlShamayleh2018ASL
  - 0078 citations @Vuletic2019SystematicLR
  - 0154 citations @Supani2015DepthBasedHP
  - 0301 citations @Cheok2019ARO
  - 0884 citations @Erol2007VisionbasedHP
  - 1300 citations @Rautaray2012VisionBH
  - @Cai2017RGBDDU RGB-D datasets using microsoft kinect or similar sensors: a survey
  - @Chen2020ASO A Survey on Hand Pose Estimation with Wearable Sensors and Computer-Vision-Based Methods
  - @Cheng2016SurveyO3 Survey on 3D Hand Gesture Recognition
  - @Harshith2010SurveyOV Survey on Various Gesture Recognition Techniques for Interfacing Machines Based on Ambient Intelligence
  - @Pavlovic1997VisualIO Visual Interpretation of Hand Gestures for Human-Computer Interaction: A Review
  - @Sturman1994ASO: A survey of glove-based input (~850 citations)
  - @khan2012hand: Hand gesture recognition: a literature review
  - @oudah2020hand: Hand gesture recognition based on computer vision: a review of techniques
  - @suarez2012hand: Hand gesture recognition with depth images: A review

- Describe the anatomical structure of the hand

  - Name of the bones
  - Name of the movements (adduction, flexion, etc)

- Different tasks:

  - Hand pose estimation (regression) vs hand gesture estimation (classification)
  - Number of items to classify
  - Vision-based, Glove-based

    - Vision-based: Depth, RGB, RGB-D, fiducial markers or not, monocular/multi-ocular
    - Glove based: bend(flex), IMU(acceleration),
    - Glove based: bend/flex, stretch, IMU/acceleration, magnetic
      > "As summarized by @Rashid2018WearableTF, there are typically four types
      > of sensors that can be used for hand-related tasks: bend sensors,
      > stretch sensors, inertial measurement units (IMUs), and magnetic
      > sensors."

  - Application: Novel computer input, virtual reality, sign language
    recognition, computer game control, unspecified

## Scratchpad

To lookup:

- @madadiFG2017 Occlusion aware hand pose recovery from sequences of depth
  images (ChaLearn Gesture Recognition dataset)
- American Sign Language (ASL) alphabet dataset
- MSRC-12 Kinect Gesture Dataset
- Cui, Z., Wang, Y., Wang, J., & Luo, J. (2017). Hand gesture recognition based
  on template matching and triangle area algorithm. Multimedia Tools and
  Applications, 76(15), 16157-16175.(TODO: Check this)
- Yang, J., Li, W., Sun, M., & Wang, S. (2018). A survey of vision-based hand
  gesture recognition. Journal of Visual Communication and Image
  Representation, 53, 175-191(TODO: Check this).
- Mittal, M., Tripathi, S., & Mishra, A. (2019). Hand gesture recognition
  techniques: A survey. Artificial Intelligence Review, 52(2), 1273-1308.(TODO: Check this)
- Cao, S., Liu, Y., Zhang, J., & He, Z. (2020). A deep learning framework for
  hand gesture recognition based on convolutional neural networks. Sensors,
  20(11), 3212.(TODO: Check this)
- Pu, S., & Han, J. (2021). A survey on hand gesture recognition. ACM Computing
  Surveys, 54(3), 1-34.(TODO: Check this)
- @fang2007real: A real-time hand gesture recognition method
- @freeman1995orientation: Orientation histograms for hand gesture recognition

- @Zhang2009HandGR Hand gesture recognition and virtual game control based on
  3D accelerometer and EMG sensors
- @jimaging6080073 Hand Gesture Recognition Based on Computer Vision: A Review of Techniques
- @Fang2007ARTH A Real-Time Hand Gesture Recognition Method
- @liu2004HandGRU Hand gesture recognition using depth data
- @chen2003hand Hand gesture recognition using a real-time tracking method and hidden Markov models
- @Baudel1993CharadeRC Charade: remote control of objects using free-hand gestures
- @Liu2009uWaveAP uWave: Accelerometer-based personalized gesture recognition and its applications
- @Mntyjrvi2004EnablingFA: Enabling fast and effortless customisation in accelerometer based gesture interaction
- @Rekimoto2001GestureWristAG: GestureWrist and GesturePad: unobtrusive wearable interaction devices
- @Kela2006AccelerometerbasedGC Accelerometer-based gesture control for a design environment
- @Erol2007VisionbasedHP Vision-based hand pose estimation: A review
- @Sharma1998TowardMH toward multimodal human-computer interface
- @Li2016WiFingerTT WiFinger: talk to your smart devices with finger-grained
  gesture

- @Kessler1995EvaluationOT Evaluation of the CyberGlove as a whole-hand input device

- Keyglove and [similar](https://keyglove.net/resources/similar/)

- Have a long look at [Jani Mäntyjärvi](https://scholar.google.com/citations?user=uvLXYPMAAAAJ)

With acceleration data:

- Wilson, A. D., & Bobick, A. F. (1997). Parametric hidden Markov models forgarg2009vision
  gesture recognition. IEEE International Conference on Computer Vision, 1997.
  Proceedings, 1, 695-701.(TODO: Check this)
- Starner, T., & Pentland, A. (1995). Real-time American sign language
  recognition from video using hidden Markov models. IEEE Transactions on
  Pattern Analysis and Machine Intelligence, 17(6), 583-591.(TODO: Check this)
- Anderson, D. V., Luke, R. H., & Brown, L. M. (2007). Gesture recognition
  using accelerometers. IEEE International Workshop on Haptic Audio Visual
  Environments and Games, 37-42.(TODO: Check this)
- Lahane, P., & Patil, A. (2014). Gesture recognition system using Wii remote.
  International Journal of Advanced Research in Computer Science and Software
  Engineering, 4(6), 568-572.(TODO: Check this)
- Yang, Y., Zhu, S., Chen, L., & Ji, Q. (2014). Egocentric hand gesture
  recognition with depth images. IEEE Transactions on Pattern Analysis and
  Machine Intelligence, 36(9), 1815-1827.(TODO: Check this)
- Luo, C., & Jin, S. (2015). Hand gesture recognition based on wearable motion
  sensors. Sensors, 15(12), 29088-29105.(TODO: Check this)
- Bernhard, D., Gruhn, R., Schreiner, J., & Lukowicz, P. (2015). Continuous
  gesture recognition using inertial sensors. IEEE International Symposium on
  Wearable Computers, 2015, 96-99.(TODO: Check this)
- Supartono, B., Purwohandoko, A., Widyawan, W., & Azhari, A. (2016). Hand
  gesture recognition using accelerometer sensor on Android smartphone.
  International Journal of Computer Applications, 148(7), 19-23.(TODO: Check this)
- Beltramelli, T., Dèchelette, T., & Paleari, M. (2017). Hand gesture
  recognition with IMU: A benchmark. IEEE International Workshop on Machine
  Learning for Signal Processing, 1-6.(TODO: Check this)
- De Castro, C. C., & Minetto, R. (2018). Hand gesture recognition using
  accelerometer data from a smartwatch. IEEE Latin American Conference on
  Computational Intelligence, 2018, 1-6.(TODO: Check this)

Visual data:

- @garg2009vision Vision based hand gesture recognition
- Wang, H., Ullah, H., Kläser, A., Laptev, I., & Schmid, C. (2013). Evaluation
  of local spatio-temporal features for action recognition. Proceedings of the
  British Machine Vision Conference, 2013.(TODO: Check this)
- Rahim, M. S., Azil, N. M., Sulaima, M. F., Ghani, M. K. A., & Hamid, N. F. A.
  (2015). Hand gesture recognition using depth and skeleton information from
  Kinect. International Journal of Computer Applications, 127(3), 1-6.(TODO: Check this)
- Hu, W., Tan, T., Wang, L., & Maybank, S. (2004). A survey on visual
  surveillance of object motion and behaviors. IEEE Transactions on Systems,
  Man, and Cybernetics, Part C (Applications and Reviews), 34(3), 334-352.(TODO: Check this)
- Moeslund, T. B., Hilton, A., & Krüger, V. (2006). A survey of advances in
  vision-based human motion capture and analysis. Computer Vision and Image
  Understanding, 104(2-3), 90-126.(TODO: Check this)
- Zhou, H., Neskovic, P., & Cooper, L. N. (2008). Audio-visual fusion for
  robust face recognition. Image and Vision Computing, 26(5), 648-659.(TODO: Check this)
- Lepetit, V., & Fua, P. (2005). Monocular model-based 3D tracking of rigid
  objects: A survey. Foundations and Trends® in Computer Graphics and Vision,
  1(1), 1-89.(TODO: Check this)
- Oikonomidis, I., Kyriazis, N., & Argyros, A. A. (2011). Efficient model-based
  3D tracking of hand articulations using Kinect. Proceedings of the IEEE
  International Conference on Computer Vision Workshops, 2011, 623-630.(TODO: Check this)
- Ye, J. C., & Rehg, J. M. (2002). Saliency detection for videos using 3D FFT
  local spectra. Proceedings of the IEEE Computer Society Conference on
  Computer Vision and Pattern Recognition, 2002, 2, II-374.(TODO: Check this)
- Wachs, J. P., Kölsch, M., Stern, H., & Edan, Y. (2011). Vision-based
  hand-gesture applications. Communications of the ACM, 54(2), 60-71.(TODO: Check this)
- Ziaei, A., & Stiefelhagen, R. (2017). Discriminative gesture understanding
  using 3D convolutional neural networks. IEEE Transactions on Human-Machine
  Systems, 47(6), 958-969.(TODO: Check this)

Alternative data collection:

- @Kundu2018HandGR Hand Gesture Recognition Based Omnidirectional Wheelchair Control Using IMU and EMG Sensors

- Li, W., & Zhang, Z. (2012). EMG-based continuous human-computer interaction
  approaches: Challenges and potential solutions. International Journal of
  Pattern Recognition and Artificial Intelligence, 26(03), 1252003.(TODO: Check this)
- Karantonis, D. M., Narayanan, M. R., Mathie, M., Lovell, N. H., & Celler, B.
  G. (2006). Implementation of a real-time human movement classifier using a
  triaxial accelerometer for ambulatory monitoring. IEEE Transactions on
  Information Technology in Biomedicine, 10(1), 156-167.(TODO: Check this)
- Li, Y., Niu, L., Zhou, X., Wang, Z., & Yang, X. (2015). MyoWatch: Recognizing
  and visualizing full-hand gestures on a smartwatch with electromyography and
  inertial sensors. Proceedings of the ACM International Joint Conference on
  Pervasive and Ubiquitous Computing, 857-868.(TODO: Check this)
- Stisen, A., Blunck, H., Bhattacharya, S., Prentow, T. S., Kjærgaard, M. B., &
  Dey, A. (2015). Smart devices are different: Assessing and mitigatingmobile
  sensing heterogeneities for activity recognition. Proceedings of the ACM
  International Joint Conference on Pervasive and Ubiquitous Computing,
  939-950.(TODO: Check this)
- Thomas, D., Garg, A., Sauppe, A., & Thorpe, C. (2013). TapSense: Enhancing
  finger interaction on touch surfaces. Proceedings of the ACM International
  Conference on Interactive Tabletops and Surfaces, 373-376.(TODO: Check this)
- Ren, X., Meng, H., Zhu, X., & Ma, Y. (2016). CapStouch: Leveraging capacitive
  sensing for accurate touch gesture recognition on commodity smartphones. IEEE
  Transactions on Mobile Computing, 15(2), 480-493.(TODO: Check this)
- Seo, J., Jang, M., Park, S., & Kim, H. (2015). Respiratory monitoring system
  using capacitive sensors for detecting gestures of patients on a bed.
  Sensors, 15(10), 27118-27134.(TODO: Check this)
- van Beijnum, B. J., Hermens, H. J., & van den Heuvel, H. (2010). Dynamics of
  a gesture therapy for patients with an incomplete spinal cord injury. Journal
  of NeuroEngineering and Rehabilitation, 7(1), 1-11.(TODO: Check this)
- Amft, O., & Troster, G. (2008). Recognition of dietary activity events using
  on-body sensors. Artificial Intelligence in Medicine, 42(2), 121-136.(TODO: Check this)
- Ostermann, J., & Ullrich, C. (2013). Classifying everyday activities with
  capacitive sensing. Proceedings of the ACM International Joint Conference on
  Pervasive and Ubiquitous Computing, 741-750.(TODO: Check this)

Different technologies and algorithms used for gesture classification along
with relevant papers for each:

Other:

- @Sun2020GestureRA Gesture recognition algorithm based on multi-scale feature
  fusion in RGB-D images

Kinect:

- @Zhao2016MultifeatureGR Multi-feature gesture recognition based on Kinect

Recurrent Neural Networks:

- @Koch2019ARN A Recurrent Neural Network for Hand Gesture Recognition based on Accelerometer Data

EMG based:

- @Zhang2019RealTimeSE Real-Time Surface EMG Pattern Recognition for Hand
  Gestures Based on an Artificial Neural Network

RGBD based:

- @Wan2016ExploreEL Explore Efficient Local Features from RGB-D Data for
  One-Shot Learning Gesture Recognition

Wifi based:

- @Alqaness2016WiGeRWG WiGeR: WiFi-Based Gesture Recognition System
- @He2015WiGWG WiG: WiFi-Based Gesture Recognition System

1. Hidden Markov Models (HMMs):

   - @Wilson1999ParametricHM Wilson, A. D., & Bobick, A. F. (1997). Parametric
     hidden Markov models for gesture recognition. IEEE International
     Conference on Computer Vision, 1997. Proceedings, 1, 695-701.
   - @Starner1995RealtimeAS Starner, T., & Pentland, A. (1995). Real-time
     American sign language recognition from video using hidden Markov models.
     IEEE Transactions on Pattern Analysis and Machine Intelligence, 17(6),
     583-591. (and @Starner1998RealTimeAS)

2. Convolutional Neural Networks (CNNs):

- @Ma2017HandGR Hand gesture recognition with convolutional neural networks for
  the multimodal UAV control
- @Hakim2019DynamicHG Dynamic Hand Gesture Recognition Using 3DCNN and LSTM
  with FSM Context-Aware Model
- @zhang2020gesture: Gesture recognition based on deep deformable 3D
  convolutional neural networks
- @Huang2014SignLR Sign Language Recognition using 3D convolutional neural networks
- @Funke2019Using3C Using 3D Convolutional Neural Networks to Learn
  Spatiotemporal Features for Automatic Surgical Gesture Recognition in Video.
- @Lu2019OneshotLH One-shot learning hand gesture recognition based on modified
  3d convolutional neural networks
- @UrRehman2022DynamicHG Dynamic Hand Gesture Recognition Using 3D-CNN and
  LSTM Networks
- @Wu2016DeepDN Deep Dynamic Neural Networks for Multimodal Gesture
  Segmentation and Recognition
- @ElBadawy2017ArabicSL Arabic sign language recognition with 3D convolutional
  neural networks
- @Liang20183DCN 3D Convolutional Neural Networks for Dynamic Sign Language Recognition
- @Bhagat2019IndianSL Indian Sign Language Gesture Recognition using Image
  Processing and Deep Learning
- @Huang2015SignLR Sign Language Recognition using 3D convolutional neural networks
- @Sharma2021ASL3DCNNAS ASL-3DCNN: American sign language recognition technique
  using 3-D convolutional neural networks

3. Dynamic Time Warping (DTW):

   - Nafornita, C., Florea, A. M., Florea, C., & Vertan, C. (2015). Hand
     gesture recognition using dynamic time warping on depth maps for natural
     interaction with TV. International Journal of Human-Computer Studies, 73,
     22-34.(TODO: Check this)
   - Li, S., Liu, Y., & Liu, X. (2016). Dynamic time warping based hand gesture
     recognition using leap motion controller. International Journal of Control
     and Automation, 9(1), 423-434.(TODO: Check this)

4. Support Vector Machines (SVMs):

   - Huang, L., Li, M., & Ye, J. (2006). Support vector machines with
     automatically selected critical instances. IEEE Transactions on Pattern
     Analysis and Machine Intelligence, 28(8), 1252-1256.(TODO: Check this)
   - Kumar, A., Roy, P. P., & Dogra, D. P. (2014). Hand gesture recognition
     using support vector machine. Journal of Computational Intelligence in
     Bioinformatics, 7(1), 9-16.(TODO: Check this)

5. Random Forests:

- Breiman, L. (2001). Random forests. Machine Learning, 45(1), 5-32.(TODO: Check this)
- Zhang, L., Ji, X., Wu, Y., Zhang, Z., & Shi, Y. (2019). Hand gesture
  recognition based on random forest and HOG features. Journal of Physics:
  Conference Series, 1157(4), 042019.(TODO: Check this)

6. Artificial Neural Networks (ANNs):

- Jain, A., & Nigam, R. (2015). Human hand gesture recognition using artificial
  neural networks. International Journal of Computer Science and Information
  Technologies, 6(5), 4487-4491.(TODO: Check this)
- Ahuja, N., & Kumar, M. (2018). Real-time hand gesture recognition using
  convolutional neural network. International Journal of Advanced Computer
  Science and Applications, 9(6), 540-546. (TODO: Check this)
- @Mohammed2019ADL A Deep Learning-Based End-to-End Composite System for Hand Detection and Gesture Recognition

Literature by the decade, in chronological order:

## 1980s

- todo

## 1990s

- todo

## 2000s

- todo

## 2010s

- todo

## 2020s

- todo

## Discussion

todo

## Tabular Summary

todo

table:

\input{src/03_literature_table.tex}

---

## Related Work

Prior work has been done both in the formal literature and on various platforms
by hobbyists or open source communities. Note that some works in the
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

@kadous1995 used a one-hand Nintendo PowerGlove to distinguish between 95
different signs from Australian Sign Language. The start and end of each sign
had to be manually indicated by pressing a button on the PowerGlove. These
signs are often dynamic gestures in which both hands trace some path but keep
the finger positions still. Only one PowerGlove was used, despite many of the
signs being two-handed. The author discarded the idea of building a PowerGlove
equivalent themselves, as that effort was considered to be a thesis in and of
itself.

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

@rekimoto2001 developed a watch-like device named GestureWrist which recognises
human hand gestures by measuring changes in wrist shape via capacitive sensors,
as well as measuring forearm movement based on acceleration sensors. It
requires the start and end of each gesture to be indicated by the user, and
gestures were made up of simple full arm transitions such as palm facing
upwards to palm facing downwards.

@keskin2003 developed a HMM-based system which classifies gestures based on
video input of brightly coloured gloves (similar to @starner1995). The system
is able to classify eight dynamic gestures consisting of single hand motions
which trace out simple shapes in front of the camera.

@mantyjarvi2004 developed a HMM which used linear acceleration in three axes to
classify eight gestures. This work was built upon by @kela2006 who utilised the
Sensing, Operating, and Activating Peripheral Box (SoapBox) developed by
@tuulari2002 to collect motion data which was classified into gestures by a
HMM. The resulting classifications were used to interact with a custom designed
suite of software which was tailored to make use of the more intuitive gesture
interface. The number of gestures that their system could recognise was not
reported.

@manresayee2005 developed a project which controls a video game based on static
single-hand postures. These postures are captured from video stills taken from
a web camera. Four static single hand postures were recognised.

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
later expanded on by volunteer contributors. The GRT is unmaintained as of 2019.

The project named [Gesture Recognition Using Accelerometer and
ESP](https://create.arduino.cc/projecthub/mellis/gesture-recognition-using-accelerometer-and-esp-71faa1)
uses Dynamic Time Warping to allow any user to download the software and
classify up to nine user-specified gestures from a three-axis accelerometer. It
was built on top of the Gesture Recognition Toolkit developed by @gillian2014.
