Ergo Report
-----------

# TODO

- Why could the HMM practical with signatures from Honours MLA predict multiple
  signatures but I need multiple?
- Possibly look at RNNs/LSTMs/Transformers for predicting the Ergo data, time
  dependant.

- Make sure citations are high enough when you're looking at a paper.

- Willem & Cornelia: Maybe get feedback from them wrt Honours thesis?

- Explain that *Ergo* comes from ergonomic/consequently/therefore
- Potential problem: NNs take continuous data, HMMs emit discrete data
- Something about post-processing: Filtering the predictions of the model with
  something like autocomplete (or maybe adding in priors for the model) - this
  was mentioned by Brink.
    - Use two existing out-of-the-box autocomplete programs to help out with
      this, and compare the two programs.

# Meetings

Once a week, Mondays from 13h to 14h.

# Timeline

- March & April: Perform the experiments & do autocomplete (ie make it
  something useful, not just a good model)
- May: Background
- June: Literature Review
- July: Methodology
- August: Results
- September: Conclusion and Introduction

# Outline

1. Introduction
    1. A statement of the problem
    2. Description of remaining chapters
2. Literature Review
    - Very thorough
3. Background
    - Hidden Markov Models
    - CUSUM
    - Neural Networks
4. Methodology
    - Entire design of the project: hardware, software
    - All experiments conducted
    - How the thing was built
    - Experimental setup
5. Results
    - Comparison to HMM
    - Comparison to CUSUM
6. Conclusion

# Literature

- eickeler1998: HMM Based Continuous Online Gesture Recognition
    - yamato1992: Recognizing Human Action in Time Sequential Images Using HMMs
    - starner1995: Visual Recognition of American Sign Language Using HMMs
    - rigoll1997a: New improved feature extraction methods for real-time high
      performance image sequence recognition
    - rigoll1997b: High Performance Real-Time Gesture Recognition Using HMMs

