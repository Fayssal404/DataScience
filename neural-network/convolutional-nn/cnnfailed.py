# Tensorflow failed structure
from keras.layers import Dense, Conv2D, Flatten


#create model
model = Sequential()

#add model layers
model.add(Conv2D(64, kernel_size=5, activation='relu', input_shape=(50,50,1)))
model.add(Conv2D(32, kernel_size=5, activation='relu'))
# Serve as connection between conv & dense layers
model.add(Flatten())
model.add(Dense(25, activation='softmax'))


#compile model using accuracy to measure model performance
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

X_train = X_train.reshape(-1,50,50,1)
X_test = X_test.reshape(-1,50,50,1)

model.fit(X_train, y_train, validation_data=(X_test, y_test), epochs=3)
class CnnStructure:
    # Parameters Values
    learning_rate = 0.01
    epochs =2
    batch_size = 250
    num_batches = 2700/batch_size

    input_height = 50
    input_width = 50

    n_classes= 25 # 25 letters
    dropout = 0.75

    display_step = 1
    filter_height = 5
    filter_width=5

    depth_in = 1  # Number of channels (1 if only gray else 3 for RGB channels )
    depth_out1=64
    depth_out2 = 128

cnn_struct = CnnStructure()

x = tf.placeholder(tf.float32, [None, cnn_struct.input_width, cnn_struct.input_height,1])
y = tf.placeholder(tf.float32, [None, cnn_struct.n_classes])
keep_prob = tf.placeholder(tf.float32)

weights = {
'wc1' : tf.Variable(tf.random_normal([cnn_struct.filter_height,cnn_struct.filter_width,cnn_struct.depth_in,cnn_struct.depth_out1])),
'wc2' : tf.Variable(tf.random_normal([cnn_struct.filter_height,cnn_struct.filter_width,cnn_struct.depth_out1,cnn_struct.depth_out2])),
'wd1' : tf.Variable(tf.random_normal([(round(cnn_struct.input_height/4))*(round(cnn_struct.input_height/4))* cnn_struct.depth_out2,1024])),
'out' : tf.Variable(tf.random_normal([1024,cnn_struct.n_classes]))
}
weights

(cnn_struct.input_height//4) *(cnn_struct.input_height//4) * cnn_struct.depth_out2

biases = {
'bc1' : tf.Variable(tf.random_normal([64])),
'bc2' : tf.Variable(tf.random_normal([128])),
'bd1' : tf.Variable(tf.random_normal([1024])),
'out' : tf.Variable(tf.random_normal([cnn_struct.n_classes]))
}
biases

def conv2d(x,W,b,strides=1):
    """ Convolution Layer """
    x = tf.nn.conv2d(x,W,strides=[1,strides,strides,1],padding='SAME')
    
    # Add bias for each output feature map
    x = tf.nn.bias_add(x,b)
    return tf.nn.relu(x) # add non-linearity to the system


def maxpool2d(x,stride=2):
    """ Max Pooling Layer """
    return tf.nn.max_pool(x,ksize=[1,stride,stride,1],strides=[1,stride,stride,1],padding='SAME')


def conv_net(x, weights, biases, dropout):
    """ Feedforward model;
        1st dimension - image index
        2nd dimension - height
        3rd dimension - width
        4th dimension - depth
    """
    
    x = tf.reshape(x,shape=[-1, 50,50,1])
    
    # Convolutional Layer
    conv1 = conv2d(x, weights['wc1'], biases['bc1'])
    conv1 = maxpool2d(conv1,2)
    
    ## Convolutional layer 2
    conv2 = conv2d(conv1,weights['wc2'],biases['bc2'])
    conv2 = maxpool2d(conv2,2)
    
    ## Now comes the fully connected layer
    fc1 = tf.reshape(conv2,[-1,weights['wd1'].get_shape().as_list()[0]])
    fc1 = tf.add(tf.matmul(fc1,weights['wd1']),biases['bd1'])
    fc1 = tf.nn.relu(fc1)
    
    ## Apply Dropout
    fc1 = tf.nn.dropout(fc1,dropout)
    
    ## Output class prediction
    out = tf.add(tf.matmul(fc1,weights['out']),biases['out'])
    return out

pred = conv_net(x,weights,biases,keep_prob)
# Define loss function and optimizer
cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=pred,labels=y))
optimizer = tf.train.AdamOptimizer(learning_rate=cnn_struct.learning_rate).minimize(cost)
# Evaluate model
correct_pred = tf.equal(tf.argmax(pred,1),tf.argmax(y,1))
accuracy = tf.reduce_mean(tf.cast(correct_pred,tf.float32))

def next_batch(features, output, batch_size):
    """Return random sample from dataset batch_size"""

    for i in range(0, batch_size):
        yield features[i:i + batch_size], output[i:i + batch_size]

import time

## initializing all variables
init = tf.global_variables_initializer()
####################################################
## Launch the execution Graph
####################################################
start_time = time.time()
with tf.Session() as sess:
    sess.run(init)
    for i in range(cnn_struct.epochs):
        
        # Image Generator
        data_gen = next_batch(X_train, y_train, cnn_struct.batch_size)
        for j in range(int(cnn_struct.num_batches)):
            batch_x,batch_y = next(data_gen)
            print(batch_x.shape, batch_y.shape)
            sess.run(optimizer, feed_dict={x:batch_x,y:batch_y,keep_prob:cnn_struct.dropout})
            loss,acc = sess.run([cost,accuracy],feed_dict={x:batch_x,y:batch_y,keep_prob: 1.})
            if epochs % display_step == 0:
                print("Epoch:", '%04d' % (i+1),
                "cost=", "{:.9f}".format(loss),
                "Training accuracy","{:.5f}".format(acc))
            print('Optimization Completed')
            y1 = sess.run(pred,feed_dict={x:X_test[:cnn_struct.batch_size],keep_prob: 1})
            test_classes = np.argmax(y1,1)
            print('Testing Accuracy:',sess.run(accuracy,feed_dict={x:X_train[:cnn_struct.batch_size],y:y_test[:cnn_struct.batch_size],keep_prob: 1}))
            f, a = plt.subplots(1, 10, figsize=(10, 2))
            for i in range(10):
                a[i].imshow(np.reshape(X_test[i],(28, 28)))
                print(y_test[i])
                
end_time = time.time()
print('Total processing time:',end_time - start_time)

