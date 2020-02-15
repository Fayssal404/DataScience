#!/usr/bin/python3.6m


"""Implement XOR network using sigmoid activation functions in the hidden layers as well in the output"""


import tensorflow as tf


#Create placeholders for training inputs and output labels
x_ = tf.placeholder(tf.float32, shape = [4,2], name = "x-input")
y_ = tf.placeholder(tf.float32, shape = [4,1], name = "y-input")


with tf.name_scope("weights"):

    #Define the weights to the hidden and output layer respectively
    wone = tf.Variable(tf.random_normal((2,2), -1, 1), name="Weights1")
    wtwo = tf.Variable(tf.random_normal((2,1), -1,1), name = "Weights2")


with tf.name_scope("bias"):
    #Define the bias to the hidden and output layers respectively
    bone = tf.Variable(tf.zeros([2]), name="Bias1")
    btwo = tf.Variable(tf.zeros([1]), name = "Bias2")



with tf.name_scope("prediction"):
    #The final output through forward pass

    z2 = tf.sigmoid(tf.matmul(x_, wone) + bone)
    pred = tf.sigmoid(tf.matmul(z2, wtwo) + btwo)



with tf.name_scope("training"):
    #Define the cross-entropy/Log-loss Cost function based on the output label y 
    #and predicted probability by the forward pass

    cost = tf.reduce_mean(((y_ * tf.log(pred))+ ((1-y_)*tf.log(1.0-pred)))*-1)
    learning_rate = 0.01

    train_step =tf.train.GradientDescentOptimizer(learning_rate).minimize(cost)


def main():
    """ Train XOR neural network """
    XOR_X = [[0,0], [0,1], [1,0], [1,1]]
    XOR_Y = [[0], [1], [1], [0]]


    with tf.Session() as sess:
        sess.run(tf.initialize_all_variables())
        writer = tf.summary.FileWriter("./XOR1_logs", sess.graph_def)

        for _ in range(100):
            sess.run(train_step, feed_dict={x_ : XOR_X, y_: XOR_Y})
    
        print("Output Probability Predictions", sess.run(pred, feed_dict={x_ : XOR_X, y_: XOR_Y}))


if __name__ == "__main__":
    main()
