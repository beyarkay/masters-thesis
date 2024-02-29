# _Ergo_: A Gesture-Based Computer Interaction Device (thesis)

This repository contains the pandoc-markdown thesis for the Computer Science
Master's Thesis:

> _Ergo_: A Gesture-Based Computer Interaction Device

It is accompanied by [this Zenodo dataset](https://zenodo.org/records/10209419)
containing the raw datasets and [this
repository](https://github.com/beyarkay/masters-code) containing the source
code for the project.

# Corrections & Improvements

On 13 February 2024, the following corrections and suggestions were improved.
They have been summarised:

> Many pages of text are overflowing into the right hand margin. `\mbox`
> hyphenates overflowing words

> Full stops were not added to stand-alone equations consistently. The examiner
> doesn't want full stops at the end of equations.

> Foot note in middle of the page on page 61 (issue with LaTeX floating
> environments, figure 4.2)

> Some remnants of LaTeX code in document (page 106)

> They _really_ didn't like the dim yellow used in the `Spectral` colour
> palette, need to create a custom colour map to solve this. (or maybe I can
> get away with setting an outline for all of the points)

> y-axes (for the confusion matrices, and "many graphs") have zero at the top,
> where the convention is to have zero at the bottom.

- The above point, for the confusion matrices, isn't actually consistent
  because confusion matrices are usually oriented so that a perfect model's
  confusion matrix would look like the Identity, with a negatively-sloped
  diagonal. But I do see the confusion, and will relabel the confusion matrices
  to be "gesture 0", "gesture 1", ...

> "Axes annotations on some graphs are very crowded. Try using a smaller font"

> Citations were not consistent, some were placed in footnotes and some were
> placed inline with the text.

> Some other changes provided
