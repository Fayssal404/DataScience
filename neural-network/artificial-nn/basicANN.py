
import tensorflow as tf

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from batchGen import next_batch


class AnnBasicClassifier:
    """ Build neural network """

    def __init__(self, n_inputs, n_hidden1, n_output, n_hidden2=None, learning_rate=0.01, batch_size=50, n_epoch=1, test_size=0.25):

        # General Config

        # General Constant
        self.LEARNINGRATE = learning_rate
        self.NEPOCHS = n_epoch
        self.BATCHSIZE = batch_size
        self.TESTSIZE = test_size

        # ANN Structure
        self.n_inputs = n_inputs
        self.n_output = n_output
        self.n_hidden1 = n_hidden1
        self.n_hidden2 = n_hidden2

        # Input layer
        self.X = tf.placeholder(tf.float32, shape=(
            None, self.n_inputs), name="X")

        # Output layer
        self.y = tf.placeholder(tf.int64, shape=(None), name="y")

    def hiddenlayer(self, X, n_neurones, name, activation=None):
        """ Create hidden layers and output layers """

        with tf.name_scope(name):
            n_inputs = int(X.get_shape()[1])
            stddev = 2 / np.sqrt(n_inputs)

            # Initialize Weights
            init = tf.truncated_normal((n_inputs, n_neurones), stddev=stddev)

            # z =  X.Weights + b
            W = tf.Variable(init, name="Weights")
            b = tf.Variable(tf.zeros([n_neurones]), name="biases")

            z = tf.matmul(X, W) + b

            if activation == "relu":
                return tf.nn.relu(z)

            else:
                return z

    def createDNN(self):
        """ Initialize internal Structure """

        with tf.name_scope("dnn"):
            self.hidden1 = self.hiddenlayer(
                self.X, self.n_hidden1, "hidden1", activation="relu")

            # TODO: Put condition of n_hidden2 is  None
            self.hidden2 = self.hiddenlayer(
                self.hidden1, self.n_hidden2, "hidden2", activation="relu")
            # logits outputs will be passed to the softmax functions
            self.logits = self.hiddenlayer(
                self.hidden2, self.n_output, "Predicted")

        with tf.name_scope("loss"):
            """ Node for loss function computation """
            self.xentropy = tf.nn.sparse_softmax_cross_entropy_with_logits(
                labels=self.y, logits=self.logits)
            self.loss = tf.reduce_mean(self.xentropy, name="loss")

        with tf.name_scope("train"):
            """ Train ANN model"""
            self.optimizer = tf.train.AdamOptimizer(self.LEARNINGRATE)
            self.training_op = self.optimizer.minimize(self.loss)

        with tf.name_scope("eval"):
            self.correct = tf.nn.in_top_k(self.logits, self.y, 1)
            self.accuracy = tf.reduce_mean(tf.cast(self.correct, tf.float32))

    def trainDNN(self, inputs_, output_):
        """ Train deep neural network"""
        self.createDNN()
        # Save trained model parameters to disk
        self.saver = tf.train.Saver()
        # Create a nod to initialize all variables
        init = tf.global_variables_initializer()

        xtr, xtst, ytr, ytst = train_test_split(
            inputs_, output_, test_size=self.TESTSIZE)

        with tf.Session() as sess:
            init.run()
            for epoch in range(self.NEPOCHS):
                batches = next_batch(xtr, ytr, self.BATCHSIZE)
                for iteration in range(inputs.shape[0] // self.BATCHSIZE):
                    try:
                        # write a function that get XBAtch and Ybacth
                        X_batch, y_batch = next(batches)
                        # Run training node
                        sess.run(self.training_op, feed_dict={
                            self.X: X_batch.values, self.y: y_batch.values})
                    except StopIteration:
                        # If there is no other batch skip to the next step
                        pass
                # Evaluate accuracy node
                acc_train = self.accuracy.eval(
                    feed_dict={self.X: X_batch, self.y: y_batch})
                acc_test = self.accuracy.eval(
                    feed_dict={self.X: xtst, self.y: ytst})

                print(epoch, "Train accuracy:", acc_train,
                      "Test acccuracy:", acc_test)

            save_path = self.saver.save(sess, "./my_model_final.ckpt")

        return "Trained Successfully"

    def predict(self, newinput):
        """ Predict new input variables """
        try:
            with tf.Session() as sess:
                self.saver.restore(sess, "./my_model_final.ckpt")
                z = self.logits.eval(feed_dict={self.X: newinput})
                y_pred = np.argmax(z, axis=1)
                return y_pred
        except:
            print("Didn't find trained model.")


if __name__ == "__main__":
    classifier = AnnBasicClassifier(
        n_inputs=6, n_output=2, n_hidden2=100, n_hidden1=300, batch_size=200, n_epoch=2)

    adult = pd.read_csv("adult.csv").drop("Unnamed: 0", 1)
    output = adult["Class"]
    inputs = adult.drop("Class", 1).select_dtypes("int64")
    print(classifier.trainDNN(inputs_=inputs, output_=output))
    print(classifier.predict(inputs[:2]))
    print(output[:2])
