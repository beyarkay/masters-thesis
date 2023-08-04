## Ergo Report

- On the issue of unbalanced class frequencies, if you've got the positive
  class occupying 99% of the dataset, then the model will just always predict
  the positive class and easily achieve 99% accuracy. This accuracy is easily
  achieved, because in the space of weights and biases of the model, there are
  many many more regions which always predict "positive" than there are regions
  which predict 99% positive and 1% negative (citation needed).

  One "solution" to this problem is to weight the loss function, so the
  negative labels are 99x worse to get wrong than the positive labels. This is
  alright, but it can lead to a model which predicts positive and negative
  examples with approximately equal proportion, even though the dataset explicitly does
  not contain positive and negative observations in equal proportion.

  I think the issue here is that you want the best of both worlds. So what if
  you start out by training the model on a weighted loss function, but then you
  gradually decrease the imbalance of those weights as training progresses.

  So the weights start out by perfectly counter acting the imbalance in the
  dataset, which leads to a model that can get the minority label correct a lot
  of the time, but often incorrectly predicts that an example from the majority
  class belongs to the minority class. Then, the class weights should be
  changed gradually until they reach an even proportion, so that they have no
  effect on the loss function. This will cause the model to explore a bit and
  hopefully find a set of weights and biases which satisfy both conditions.

  So this is like telling the model to first find a region that satisfies the
  hard problem (classifying the minority class correctly) and then later
  allowing the model to explore this region to find a subregion that also
  correctly classifies the majority class

- As a hyperparameters, dictate how the data is preprocessed:

  - Maybe use an Autoencoder?
  - Maybe try to eliminate most of the `gesture0255` class before sending it on to the actual classifier?
    - Can eliminate via multiple different means

- Maybe a model which learns on the auto encoded embeddings of the dataset?
  - So train it for _ages_ on unlabelled gesture data, so it learns to encode
    what a "gesture" looks like, and then train models on those encodings?
    This might mean that the amount of labelled training data is far far less.
- Maybe a FFNN model which takes in 30 x t data should predict 1 x t labels?
  - or maybe it should predict `n_classes x n_timesteps` data (probabilities for each class for each timestep)?
- Implement Random Forest classifier
- TODO Implement Dynamic Time Warping classifier
- Don't have binary predictions, but rather have sharply decreasing floating point predictions
  - from `0   0   0   1   0   0   0  `
  - to `0.0 0.1 0.5 1.0 0.5 0.1 0.0`
- When evaluating a model, have some secondary measure that is only used to
  inform the researcher that the model is correct, but with the wrong offset.
  - For example, the offset0 accuracy might be `(y_pred == y_true).sum`, but
    the offset+1 accuracy might be `(y_pred[1:] == y_true[:-1]).sum`, and the
    offset `-5` accuracy might be `(y_pred[:-5] == y_true[5:]).sum()`
- Maybe a model that works on the FFT of the data?

# TODO

- Possibly look at RNNs/LSTMs/Transformers for predicting the Ergo data, time
  dependant.
- Maybe a simple idea is to just identify which finger is moving (by simply
  checking if the magnitude of the acceleration vector for each finger exceeds
  some threshold) and then do a mapping from "These fingers are moving" to
  "this gesture is likely".
- Implement auto-correct as a handler in the pipeline
- Make a system for visualising 50 different gestures without confusion.
- What can be done about having non-contiguous time series classes?
- Insight about why some models perform better than others.

## Indexes to look at

10060, 10892, 111177, 111480, 114582, 116990, 119092, 119135, 12001, 124512,
133059, 143410, 144026, 150555, 151844, 15796, 173813, 174551, 17485, 175727,
177679, 177724, 177811, 177899, 177942, 178031, 178120, 178165, 178253, 178341,
178387, 178476, 178562, 178606, 178697, 178781, 178827, 178918, 179011, 179056,
179144, 179228, 179271, 179358, 179441, 179487, 179576, 179659, 179704, 179793,
179877, 179922, 179973, 183371, 190270, 191442, 191797, 192190, 194913, 203236,
212234, 212280, 24840, 29941, 31120, 31163, 40271, 40959, 45473, 52059, 52106,
52241, 52284, 52328, 52464, 52510, 52555, 52599, 53030, 54062, 54822, 67199,
7005, 74753, 80576, 9056, 92033, 92164, 96155,

# Meetings

September hand in, november oral, ~december graduation

December hand in, february

Once a week, Mondays from 14h to 15h.

NOTE: Look into recording a lot more data. This might make the gestures a lot
easier to classify. Experiment with only providing 20%, 40%, 60%, 80%, 100% of
the dataset and see how quickly each model trains. If it looks like we haven't
reached data saturation, then record more data.

Note: Probably should also implement DTW

# List of Journals

## 2023-07-24

Deadlines:

- When is the hand in?

Still to complete:

- Lit Review
- Methodology
- Results
- Conclusion
- Introduction
- Time to run extra experiments if needed?

"Late" graduation: oral exam in the new year

After the oral I'll know if I've passed or not (**Q**: How long between oral
and pass?)

How the oral works:

Guests can be invited to an oral. Or other prospective masters students, or
anyone. It takes about an hour in total. The oral is more just checking if you
actually wrote it. It counts 10% of the final mark, but you can fail if they
see that you didn't actually do the work. Thesis mark is the remaining 90%.
Trienko will do a few dry runs for the oral. Very similar to the honours
presentation.

1. 30m presentation
2. Open questions to the floor from the general audience
3. Guests are then removed
4. Faculty staff ask questions
5. Faculty removed
6. Examiners ask questions (two of them)
7. Student and Supervisor leave venue
8. Examiners deliberate (~10m)
9. Supervisor is informed of the result
10. Supervisor informs the students

Questions:

- Details about what exactly is expected of each chapter

Dates:

- Oct 17 Trienko submits the examiners
- 17 October to 1 November: final hand in (actual latest is 1 January)

Approaches to complete intro&conc:

1. In the intro, describe the problem, write problem statement, write
   contributions, list chapters and what's in them. In the conclusion, just
   summarize the thesis in a bit more detail than the abstract (about 2 pages)

2. **RECOMMENDED**: Small intro to the problem, problem statement, list
   **research questions** that you'll try to answer (ie what's been done,
   what's the best approach for Ergo, how does the system differ from the
   existing literature), then list the chapters and what's in them. In the
   conclusion, write answers to the research questions. half page describing
   the thesis, a few more pages about something...

Always include a "future work" section in the conclusion.

Methodology chapter:

Describe how you utilised the existing knowledge/algorithms/approaches (as
given in the bg chapter) to make them work. Also list any modifications made.
Also describe the dataset. Also describe how ergo looks like. Then explain
experimental setup which will let you answer the research questions made in the
introduction. This is where you describe the exact architecture of the neural
network and the hyperparameters you're iterating over. Also describe how the
HMMs are used for gesture based classification.

Results chapter:

First add the graphs that will be discussed. Then, start writing the content
and analysing the data. This helps because you already have what your data is
and is a lot better than writing what you think your conclusions are before you

Weeks:

- Lit Review: 2 weeks
- pre-methodology to write out what the experiments are, and generate the
  graphs
- Linked together (12 weeks):
  - Results: 8 weeks
  - Methodology: 4 weeks
- Conclusion & Introduction: 1 week
- Appendices!?

- 2023-07-24 [01]: Lit Review
- 2023-07-31 [02]: Lit Review
- 2023-08-07 [03]: Results
- 2023-08-14 [04]: Results
- 2023-08-21 [05]: Results
- 2023-08-28 [06]: Results
- 2023-09-04 [07]: Results
- 2023-09-11 [08]: Results
- 2023-09-18 [09]: Results
- 2023-09-25 [10]: Results
- 2023-10-02 [11]: Methodology
- 2023-10-09 [12]: Methodology
- 2023-10-16 [13]: Methodology
- 2023-10-23 [14]: Methodology
- 2023-11-30 [15]: Conclusion & Introduction
  - Go through intro and conclusion of the other MSc papers
  - 1 November: **Deadline for March Graduation**

Previous timeline:

- March & April: Perform the experiments & do autocomplete
- May: Background
- June: Literature Review
- July: Methodology
- August: Results
- September: Conclusion and Introduction

## 2023-07-20

Thursday meeting due to Trienko's holiday on the Monday

- Literature review still not complete.
- Many more references (300+) than I thought
- Describing each of them in turn isn't going to work out

TODO:

- Summarize by theme, not by year or decade
- focus on the glove-based systems, brief summaries of others
- note the journal and focus on those with a high "impact factor"
- Only describe the high-impact papers, as judged by your own intuition
- Make tables of paper, year, citations, contributions, etc
- make tables with the common hardware, common datasets, common electronics
  pieces
- Make plots:
  - Nodes and edges graph of the papers and their citations: look at the
    islands
  - Citations vs year
  - Datasets over time
  - application over time
- Note that many papers seem to duplicate other research, or do something
  inferior to it
- Make a note that many papers don't reference many other papers except for one
  or two seminal reviews. It seems like a common story that someone will have
  an idea that "gesture based input doesn't exist" and also "gesture based
  input is cool" so they throw together a prototype and publish it.
- Maybe the reason why so many papers have poor literature reviews is because
  there doesn't seem to be any coherence in the field?

## 2023-07-03

- DTW?
- Stellies writing lab/service for grammar checking
- Literature review
- Honeycomb plot kinda like a [radar plot](https://en.wikipedia.org/wiki/Radar_chart)
  - One for each dimensions (number of classes, types of models, type of
    technology)
- Submit dataset of Ergo data to https://zenodo.org/

## 2023-06-28 (feedback on background chapter)

- PS it is unclear how you would use HMM for gesture classification, assuming you will explain this in methodology chapter.
- PS just mention why you can say event intersection matrix in the HMM section.
- You need to discuss some of the neural network initialization schemes.
- See `checkpoints/2022-06-19/`

## 2023-06-26

- What's the difference between a literature review and a survey?
  - How deep should I go? is there an easy yes/no question for what papers I
    should talk about, and what papers I should just say "this exists"?

## 2023-06-19

Autocorrect alternative: look at different ways of calculating the edit
distance between words, specifically "least common subsequence" or "jacard
index".

Have finished bg chapter
will work on lit review

Lit review basics:

- never write more than small paragraph about any paper. Usually a lot less
  than a paragraph
- many short summaries of different literature items
- good idea to write a chronological summary
- give author names and a short summary of what the paper covers
- !important, some students get marked down when they just do blind summaries
  separated by whitespace. Make sure that you show you understand how the
  papers interact with each other and influence each other.
- need to show that you understand the material, not that you're just blindly
  summarising a list
- At the end, give a summary of the different items
- "ball plot": time on the x, number of citations on the y, size of the ball is
  sometimes something else?. Often the size of the ball is the number of
  citations, and the y axis is the different categories of citations (HMMs vs
  NNs vs CuSUM).

- Give a table of all the papers: methodology, tech used, citations, date, etc

> I will present the literature in chronological order
> ...
> Now I'll tie it all together and make a nice summary

What the examiner will look for:

- Number of papers
- Seminal papers must be included
- are the papers well distributed over the years (ie have an equal number in
  each decade)
- Does the student understand the literature. Identified trends and how the
  state of the art changed over time.

? How to figure out what papers to include/exclude

- Citation count
- Generally give one paragraph per main paper, and describe minor papers at the
  end of the major papers.
- Newer papers won't be cited as much as the old papers
- Sometimes its nice to have a tree where the branches represent the changes
  that a paper added and the nodes are different papers

? Should there be different subsections or is it pretty much one long list

- Probably just have everything in one chronological sequence, unless the
  literature kinda goes through periods which are themselves delimited in
  time

## 2023-06-05

June is literature review

I've got a basic autocorrect implemented

- Questions about bg?
- Struggling with what is required for the MSc?
  - How many words/pages
  - how much detail to give?
  - Data isn't easy to analyze, there's no 1 metric which is best.

Background chapter:

- a lot more detail
- self contained
- should be able to understand everything from the background chapter.
- HMM should have all the math. should be able to implement an HMM from what's
  been discussed
  - same for CuSUM, ANNs
- two bg chapters
  - one on hardware/electronics that describes the domain
  - one on the general theory and HMM/CuSUM/FFNN models
- Focus is the NN solution
- Move HMMs and CuSUM to appendix

  - but should still be full chapters

- Short historical intro for all algorithms

  - For NN, look at historical bg from burger/backer
  - for hmms, look at wikipedia historical summary

- MAKE SURE YOU HAVE THE SEMINAL/IMPORTANT REFERENCES FOR A TOPIC!!

- Citations:
  - viterbi algorithm
  - backpropogation
  - cusum

Also say "The following summary was influenced by these books"

Read the CNN chapter by Burger

Chapter on NNs (called background)
Literature review - big ol' table of citations and their aspects

bar graph where you plot per-gesture precision

maybe do a round-robin competition where you don't get a metric for each model,
but you do have a partial ordering

## 2023-05-29

Trienko was unable to make this meeting, but Boyd handed in the background
chapter on Wednesday

## 2023-05-22

- For typing, learn how to type a bit first and then record the data
- Background chapter coming along nicely
- Data recorded of English paragraphs
- Started implementing the autocorrect
  - Evaluate 2+ different techniques for autocorrect
- Experiment data finished, but haven't looked at it much just yet

## 2023-05-15

- No meeting, Trienko asked to cancel
- TODO:
  - Record data of the gloves typing an English paragraph
  - Actually run the experiments
  - Write up the background chapter

## 2023-05-08

- SU Git repo for storing work done?

- References for CuSUM?

- Record data of the gloves typing an English paragraph

## 2023-05-02

- How do we get a real-user impression of accuracy vs usability? Confusion
  matrices are great and all but they don't necessarily describe real-user
  experience?

- [x] Add a hyperparameter for what percentage of the gesture to include

- Multi facet CuSUM model

  - One detects orientation, one detects finger movement

- [x] But rather just compare CuSUM for the gestures 0 through 9. We only care
      about the speed and see what latency NNs have.

- [ ] CuSUM is just here to give a theoretical minimum latency

- [ ] Give CuSUM and HMMs a fighting chance, only look at 10, 15, 20 gestures.

## 2023-04-24

Setup some sort of modular experiment setup.

For HMMs not scaling:

- train FFNNs and HMMs, but change the class counts to have an equal number of
  observations per gesture.
- Then, weight the predictions based on the _a priori_ frequencies. So if
  gesture0255 is 5x more common than gesture0001, increase the predicted
  probability that an unknown observation is gesture0255 by 5x
- Make sure there's math to back it up.

Also:

- keep track of how FFNNs and HMMs scale

CuSUM:

- Play around with the threshold value, as it increases, accuracy should
  increase but there should also be a delay in how long it takes to actually
  make a prediction

### What was done:

- FFNNs have been implemented and work well
- CuSUM works, but accuracy is poor
- HMMs are very slow (~1hr per model/OoM), there are too many classes
  - Maybe replace HMMs with RNNs?

### When comparing the different hyperparameter performances

Make a grid of contour plots / heatmaps:

- row: hyperpar1
- col: hyperpar2
- values: the loss

### For the literature review

for each paper:

- Plot number of gestures
- Plot type of model
- Plot tech used

## 2023-04-17 (no meeting)

- Broke up with Sinead on the Sunday, so I called off the meeting on the Monday

For next meeting:

- Explain why HMMs are so slow, and possibly not good for 50-class ML models

Hold over from last week:

- 30 repetitions of each experiment
- Try using the gloves
- Implement CuSUM

## 2023-04-11 (Tuesday at 10am)

Notes:

- All models should be defensible, in that they should have prior usage in the
  literature. This gives motivation for why we used a particular architecture
- Make sure the hyperpar search uses validation data, not test data.
- Unsupervised training?

For next week:

- 30 repetitions of each experiment (via cross-fold validation)
- Actually have results which can be discussed

## 2023-04-03

This meeting didn't happen because of Easter vacation.

Completed:

- Re-aligned all gestures
  For next week
- Actually test using the glove
- Add in re-alignments to the gesture reading code
- Implement basic RNN
- Implement CuSUM
- Implement experiment framework and start with experiments

## 2023-03-27

Trienko couldn't meet, he was held up at his previous meeting

Completed:

- Implemented LSTM, NN
  For next week:
- Implement basic RNN
- Implement experiment framework and start with experiments
  Discussion points:
- Changed meeting from 13h-14h to 14h-15h
- How exactly should CuSUM work?
- What should be measured in the experiments?
  - Time to make prediction?
  - accuracy?
  - should different types of hyperparameters be looked at as well?

## 2023-03-20

Completed:

- Rewrite code base to use a pipeline of handlers
- CuSUM algorithm
- HMM algorithm

For next week:

- Probably will need to edit pipeline a bit since it hasn't been tested too much
- Implement RNN and LSTM
  - Look at literature to see good reference RNNs/LSTMs
- Implement old NN algorithm in new framework
- Start experiments that compare the different models

## Prior to 2023-03-20

- First meeting and catch up
- Decisions about project name
- Project will need to implement autocorrect
- Project will need comparisons with the literature:
  - HMM
  - CuSUM
  - RNN?
  - LSTM?

# Timeline

- March & April: Perform the experiments & do autocomplete (ie make it something useful, not just a good model)
- May: Background
- June: Literature Review
- July: Methodology
- August: Results
- September: Conclusion and Introduction

# Tasks

- [ ] Methodology
  - [ ] How is the hardware constructed?
  - [ ] How does the hardware get data to the software?
  - [ ] How are the models trained?
  - [ ] Evaluation metric: Need something that is faster than DTW but still
        doesn't care exactly about the time at which a prediction was made.
  - [ ] What would cause the model to predict correctly, but at an offset? This
        seems like a solvable problem
  - [ ] How are the models evaluated offline?
  - [ ] How are the models evaluated online?

# Experiments

## Exotic architectures

- Try training one FFNN for each finger that just predicts if it's moving and also what it's rotation is, and then just hard code it from there
- Try different types of auto encoders/dimensionality reduction
- What if we have one network filtering out the gesture0255 observations and
  another one classifying the 'real' gestures?

## Dependant variables (these are always the same):

- Time to train
- Number of observations it was trained on
- Time to predict
- Number of observations it predicted
- `y_true` vs `y_pred`

## 1. How do the different models scale with more and more gesture classes?

Independent variables:

- Type of model (HMM, FFNN, CuSUM)
- Number of gesture classes (5, 10, 20, 30, 40, 50)

## 2. How do the different models scale with more and more observations per class?

Independent variables:

- Type of model (HMM, FFNN, CuSUM)
- Always use the full 50 classes
- Scale up the number of observations per class (10, 20, 40, 60, 80, 100)

## 3. On the full dataset, what's the best performing FFNN?

Other models architectures don't scale, so we can't compare them here.

Independent variables:

- learning rate
- epochs
- optimizer
- number of neurons per layer
- number of layers
- etc

## 4. Is the FFNN more accurate with greater `n_timesteps`?

- `n_timesteps` in (15, 20, 25, 30, 35)
- For this, it'll probably be easier to pre-portion the data to have
  a `n_timesteps` of 40, and then in pre-processing to discard the latter
  portions of those timesteps as required by the `n_timesteps`.

## 5. What effect does the delay have on the FFNN?

The NN can be trained to predict with windows having a greater amount of data.
So try that.

## 5a. Is the FFNN more accurate with a larger delay?

Try training the FFNN but with the `y_true` offset by some amount, with the offset in
0, 1, 2, 5, 10, 15

### 5b. What's the cost of a larger delay?

Try to figure out what the real-world feeling is when the delay is increased.
How much delay between making a gesture and seeing it appear is acceptable?

## 6. How does the model perform for real world data?

- What's the real-world latency between a gesture being performed and the
  keystroke being emitted?
- How does it perform on some real world data?
  - Record the gloves typing common passages of text like:
    - Python sample (not many special characters)
    - Rust sample (many special characters)
    - English language sample (regular characters)
    - Maybe also a LaTeX sample for s&g? (more likely to be relatable to
      the marker)
  - also try out the glove on a typing speed test
  - On each of the passages, give a git-diff style view showing the real
    passage, the extra characters typed by the model, and the missed
    characters not typed by the model.
  - Also show a typing speed comparison for each character, colouring the
    character based on the typing speed with a QWERTY keyboard and then with
    Ergo.
  - For the test passages, also record video of you typing so that you can
    reference this later.

## 7. How well does the autocorrect work?

For this, autocorrect must be implemented. It's probably only possible to use
this on the read world dataset, since trying to do autocorrect on random text
strings won't be effective

## 8. Do the model predictions improve with some priors applied?

We can construct typing-specific priors so that typing Rust will have a higher prior for the key `<` being typed than if you're just typing regular English
