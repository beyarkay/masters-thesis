<!--

TODO Discuss the difficulties of segmentation and how most of the literature
does not attempt this.


Notes on writing a conclusion from TG:

1. "summary of thesis": a bit like the introduction has a summary, but this
   should give the key results from each chapter
2. "Answering RQ": answer the research questions one by one
3. Recommendations: Used to convince the reader that I know what's what. What
   are the take-home messages? What would I want to know if I were doing this
   again? How can I prove that I'm not a question-answering parrot and that I
   actually did gain something from this MSc
4. Future work. Because there's always more to do.


TODO: Get a friend to do the afrikaans translations for you.
-->

This report has presented a suite of sensors which are worn on the user's hands
and connect to a classifier hosted on the user's computer. This classifier is
capable of distinguishing 50 unique gestures and using those classifications to
act as a keyboard. This enables the user to type by moving their hands through
the air. The device was built from off-the-shelf components by the author and
provides more sensor measurement data than previously seen in the formal
literature or by hobbyists. This additional sensor data allowed a nuanced
classifier to be trained, which can recognise individual finger movements.
Related work has been limited to whole-hand movements. This classifier can
segment a continuous stream of sensor data into meaningful gesture predictions
without requiring the user to manually indicate the start or end of each
gesture.

The large number of recognisable gestures means that the device is a functional
keyboard, which can input the full English alphabet, the numerals 0--9, as well
as many punctuation, white-space, and control characters.

The primary use-case advertised in this report is to use this device as a
keyboard-proxy, allowing the user to perform full-keyboard input. Other uses
are possible, but will require more work to become fully functional.

Future work will focus on portability: improving the form factor of the
physical device and making it completely wireless such that it can connect to
any Bluetooth capable computer or smartphone. This will require the difficult
task of compressing the model such that it can perform inference on the
resource constrained microcontrollers.
