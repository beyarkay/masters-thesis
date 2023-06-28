Experiments
===========

## Exotic ideas

- How to get a model that can predict gestures which might overlap? For
  example, maybe you make the gesture for `shift` and the gesture for `g` at
  the same time, and this becomes `G`?
- Try training one FFNN for each finger that just predicts if it's moving and also what it's rotation is, and then just hard code it from there
- Try different types of auto encoders/dimensionality reduction
- What if we have one network filtering out the gesture0255 observations and
  another one classifying the 'real' gestures?
- Maybe get the models to try predict the gesture at every time step instead of
  just at one time step?
    - This leads to much more training data for each gesture
    - Intuitively this feels better

# Dependant variables (these are always the same):

- Time to train
- Number of observations it was trained on
- Time to predict
- Number of observations it predicted
- `y_true` vs `y_pred`

# 1. How do the different models scale with more and more gesture classes?

Independent variables:
- Type of model (HMM, FFNN, CuSUM)
- Number of gesture classes (5, 10, 20, 30, 40, 50)

# 2. How do the different models scale with more and more observations per class?

Independent variables:
- Type of model (HMM, FFNN, CuSUM)
- Always use the full 50 classes
- Scale up the number of observations per class (10, 20, 40, 60, 80, 100)

# 3. On the full dataset, what's the best performing FFNN?

Other models architectures don't scale, so we can't compare them here.

Independent variables:
- learning rate
- epochs
- optimizer
- number of neurons per layer
- number of layers
- etc

# 4. Is the FFNN more accurate with greater `n_timesteps`?

- `n_timesteps` in (15, 20, 25, 30, 35)
- For this, it'll probably be easier to pre-portion the data to have
  a `n_timesteps` of 40, and then in pre-processing to discard the latter
  portions of those timesteps as required by the `n_timesteps`.

# 5. What effect does the delay have on the FFNN?

The NN can be trained to predict with windows having a greater amount of data.
So try that.

# 5a. Is the FFNN more accurate with a larger delay?

Try training the FFNN but with the `y_true` offset by some amount, with the offset in
0, 1, 2, 5, 10, 15

## 5b. What's the cost of a larger delay?

Try to figure out what the real-world feeling is when the delay is increased.
How much delay between making a gesture and seeing it appear is acceptable?

# 6. How does the model perform for real world data?

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

# 7. How well does the autocorrect work?

For this, autocorrect must be implemented. It's probably only possible to use
this on the read world dataset, since trying to do autocorrect on random text
strings won't be effective


# 8. Do the model predictions improve with some priors applied?

We can construct typing-specific priors so that typing Rust will have a higher prior for the key `<` being typed than if you're just typing regular English
