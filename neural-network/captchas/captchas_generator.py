
""" Create program that can recover the word from image """

import numpy as np
from sklearn.utils import check_random_state
from PIL import Image, ImageDraw, ImageFont
from skimage import transform as trsf
from matplotlib import pyplot as plt



class CaptchasGenerator:
    
    def __init__(self):
        self.random_state = check_random_state(14)
        self.letters = list('ABCEFGHIJKLMNOPQRSTUVWXYZ')
        self.shear_values = np.arange(0,0.5,0.05)

    def create_captcha(self, text,shear=0, size=(100,24)):
        """ Create CAPTCHAS image. """
        im = Image.new("L", size, "black")
        draw=ImageDraw.Draw(im)

        # Set font
        font = ImageFont.truetype(r'Coval-Thin.otf',22)
        draw.text((2,2), text, fill=1, font=font)
        image = np.array(im)
        affine_tf = trsf.AffineTransform(shear=shear)
        image = trsf.warp(image, affine_tf)
        return image / image.max()

    def generate_sample(self, capt_num):
        """ Generate Captchas Training set """
        random_state = check_random_state(self.random_state)
        i = 0
        while i < capt_num:
            letter = random_state.choice(self.letters)
            shear = random_state.choice(self.shear_values)
            yield self.create_captcha(letter,shear,size=(50,50)) , self.letters.index(letter)
            i+=1

    def display_word(self, image,cmap='Greys'):
        return plt.imshow(image, cmap=cmap)

    def display_subimages(self, subimages, figsize=(10,3), cmap='gray'):
        f, axes = plt.subplots(1,len(subimages), figsize=figsize)
        for subimage in range(len(subimages)):
            axes[i].imshow(subimage[i], cmap=cmap)
        return f, axes
