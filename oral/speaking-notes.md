# Boyd Kane MSc Oral

Speaking notes

# Pre-oral prep

- MS teams set up?
- external examiner can hear & see the screen and can speak?

Notes from chatting with Trienko:

- _do_ show the introduction video
- Add YouTube link to all the things, thesis included
- explain all graphs and images, you can't just include something because it's
  pretty
- Define explicit, implicit, fidelity
- Say that _Ergo_ comes from _ergonomic_ or _therefore_.
- Add explicit headings to the slides
- One of the contributions is the dataset which is the biggest and the open
  description of the model

# Overview

## A video demonstration

- Play the video
- TODO: Make the video more stand-alone
  - describe what each of the frames does
  - explain the slow-down

# Introduction

## Research questions

### Evaluate hardware performance

### Compare algorithm performance

### Extract gestures from background noise

### Assess impact of noise on performance

### Assess classification speed

# Background

## Models and Algorithms

Show one picture for each model, and give one short explainer for each model,
giving seminal reference.

Give a slide describing $F_1$ score, macro average, weighted confusion
matrices, why I chose to column norm, and how this relates to precision (and
not recall)

### FFNNs

### SVMs

### HMMs

### CuSUM

## Evaluation Metrics

# Literature Review

Always go back to the research questions. The lit review should justify why you
made the choices you did.

Explain the swarm plot and how to read it

Don't skimp on the literature review. The lit review explains why you did what
you did (wrt tech, hardware, etc). Explain this explicitly, "I used HMMs
because they're popular"

## Seminal work

Give a slide on Sturman, initial surveys, how the field started, etc

## Tech used

## Number of classes

## Model(s) used

## Gesture fidelity

## Explicit or implicit segmentation

# Methodology

## Circuit diagram

10x accelerometers -> multiplexer (&why) -> Nano -> computer
TODO: explain why the multiplexer

## Gestures to Keystrokes

- 50 gestures required for full keyboard input
  - numerals, punctuation, letters, white space, control characters)
- Use ten fingers and five orientations

## Gesture indices

- Each gesture is given an index, between 0 and 49 (inclusive)
- Gestures are labelled semantically, so that the tens digit corresponds to the
  orientation of the hands and the units digit corresponds to the finger being
  flexed.
- For example: gesture 6 is the spacebar, and is right hand index finger at
  0deg rotation. gesture 34 is left hand thumb at 135deg orientation and would
  type a `t`.

## Class 50 - Background Noise

- Explain what class 50 is
- Explain that it's important and will come up later
- Explain that most time steps are labelled as gesture 50, the minority are
  split between the other 50 classes.

## Data Windowing

TODO

Emphasis that we want 50 gestures for full keyboard input (numerals,
punctuation, letters, white space, control characters). We have 10 fingers, so
lets do the Cartesian product with 5 orientations.

Spend lots of time describing how the gestures work, that you came up with them
yourself, and that they are designed to be easy for the lay-person to learn.
Clearly explain how the mapping is similar to the qwerty keyboard

Elaborate on how the classifier makes 40 predictions per second, and that the
gesture label is positioned at the start of the gesture. Add a nice graphic for
this (maybe 4.1 paired with gesture labels?). Explain that all other gestures are labelled as gesture 50. Emphasis that
this will be important later on as the models will struggle with gesture 50.

Add in Figure 4.2 that explains how the full dataset gets windowed. do this
before explaining how each model is trained.

Just say that hyperparameter optimisation was done via random search, don't go into the
details.

## Hyperparameter optimisation

Done via random search

## HFFNN

also need to describe these

# Results

Maybe add a quick refresher about what a good confusion matrix looks like

## CuSUM

## HMMs

## SVMs

## FFNNs

## HFFNNs

For each of the models:

- CuSUM: incl figure 5.1, show that it works for 5 classes but not the others
  (explain the confusion matrix again). Explain why CuSUM fails
- Other models?...

Need to show some plot that shows the models work in real time. Include
stripplot for validation inference time and a line at 0.025s, showing that most
models succeed in this metric.

Skip over the test set, just say the F1 score and that it shows nothing new

Go to the real-world dataset and explain how it works in practice. Explain that
it's good, and that there's a post-processing step that ensures that if a
letter is predicted sequentially, only the first prediction is made.

# Conclusion

Answer the research questions one by one, with reference to the parts of the
talk that answered them

One of the contributions of this work is the largest labelled
accelerometer-based dataset publicly available. Hopefully will lead to more
developments and better insight
