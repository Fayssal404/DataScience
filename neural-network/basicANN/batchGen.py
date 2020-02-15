
import numpy as np
import pandas as pd


def next_batch(features, output, batch_size):
    """Return random sample from dataset batch_size"""

    for i in range(0, batch_size):
        yield features[i:i + batch_size], output[i:i + batch_size]


if __name__ == "__main__":

    adult = pd.read_csv("adult.csv").drop("Unnamed: 0", 1)
    output = adult["Class"]
    inputs = adult.drop("Class", 1)

    batch = next_batch(inputs, output, 50)

    print(next(batch))
    print(next(batch))
    print(next(batch))
