# Beating CAPTCHAS
Extracting text from images by using neural networks for predicting each letter.
- Algorithms to detect & understand images
- Understanding & recognizing objects

__Objective:__ creating a program that can beat *CAPTCHAS*.

# CAPTCHAS
Completely Automated Public Turing Test to tell Computers and Humans aparts.
Captachs:
- Easy for humans to solve
- Hard for computers to solve

Many websites use them for registration and commenting systems to stop
automated programs with fake accounts and spam comments.

Beating *CAPTCHAS* requires four steps:
- Break images into individual letters
- Classify individual letters
- Recombine letter to form word

# Drawing CAPTCHAS 
Easy captchas will be generated first, which consist mostly of word images in different fonts and styles. More complex captchas display bluish images or  with Gaussian noise. 

In order to form a classification system for individual letters, it is necessary to have data, therefore a data generator imitating CAPTCHAS photos is available.

__Assumptions:__
- Whole-valid four character English word
- Only contain upercase letter

# Training & Classifying
- Build a neural network that will take an image as input and try to predict
which (single) letter is in the image.
- Training data consists of generated image letters with each image character being labeled at the letter position alphabetically.
- Outputs will be 26 values between 0 and 1, higher values indicate a higher 
likelihood that the associated letter is the letter represented by the input.
