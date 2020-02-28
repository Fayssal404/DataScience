#!/usr/bin/python3.6m

import tensorflow as tf
import numpy as np


import time


class TfRegression:

    def __init__(self, inputs, output):
        self.n_samples, self.n_features = inputs.shape
        self.inputs = inputs
        self.output = output

        self.x_ = tf.placeholder(
            tf.float32, shape=[None, self.n_features + 1], name='X')
        self.y_ = tf.placeholder(tf.float32, shape=[None, 1], name='Y')

    def next_batch(self, inputs, output, batch_size):
        """Return random sample from dataset batch_size"""

        for i in range(0, batch_size):
            yield inputs[i:i + batch_size], output[i:i + batch_size]

    def append_bias(self, x_batch):
        """ Add bias terms to features matrix """

        # Intercept Column
        intercept_ = np.ones((x_batch.shape[0], 1))

        # Add Intercept Column
        X = np.concatenate((intercept_, x_batch), axis=1)

        X = np.reshape(X, [x_batch.shape[0], x_batch.shape[1] + 1])

        return X

    def model(self, inputs, w):
        return tf.matmul(inputs, w)

    def train_model(self, learning_rate=0.001, num_epochs=100, batch_size=50):
        """ Train Regression Model """
        cost_trace = []


        # Fix Inputs & output inializer
        # Pass Batch Sample and compute the new predicted output and parameters
        # Evaluate loss function with new batch sample
        inputs_ = self.append_bias(self.inputs)

        w = tf.Variable(tf.random_normal((self.n_features + 1, 1),
                                         name="weight", dtype=tf.float64))

        with tf.name_scope("prediction"):
            y_pred = self.model(inputs_, w)
            mse = tf.reduce_mean(tf.square(self.output - y_pred))

        with tf.name_scope("Train"):
            optimizer = tf.train.GradientDescentOptimizer(
                learning_rate)
            train_op = optimizer.minimize(mse)

        with tf.Session() as sess:
            # Setup a session & initialize all variables
            sess.run(tf.global_variables_initializer())

            for epoch in range(num_epochs):
                for x_batch, y_batch in self.next_batch(random_X, random_Y, batch_size):
                    x_batch_plus_intercept = self.append_bias(x_batch)
                    cost_trace.append(
                        sess.run(mse, feed_dict={self.x_: x_batch_plus_intercept, self.y_: y_batch}))
                #print("Parameters Estimation: ", w.eval())
                #print("Cost Trace Values", cost_trace)
        return w, cost_trace


if __name__ == "__main__":

    start = time.time()
    n_sample = 100

    random_X = np.random.normal(size=(n_sample, 4))
    random_Y = np.random.normal(size=(n_sample, 1))

    model = TfRegression(inputs=random_X, output=random_Y)
    trainmodel = model.train_model()
    end = time.time()

    print("Training regression model {} sec.".format(end - start))
