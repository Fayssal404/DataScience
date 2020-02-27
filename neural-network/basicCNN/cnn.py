
import cv2




class CNN:
    

    def __init__(self):

        self.input_height=28
        self.input_width = 28

        self.n_classes =10 
        
        # Image Input
        self.x = tf.placeholder(tf.float32, [None, self.input_height * self.input_width])

        # Image Class
        self.y = tf.placeholder(tf.float32, [None, n_classes])

        self.keep_prob = tf.placeholder(tf.float32)
        
        self.depth_in = 1
        self.depth_out1 = 64
        self.depth_out2 = 128

    def initialize_weights(self, filter_height, filter_width):

        return dict(wc1=tf.Variable(tf.random_normal([filter_height,filter_width,self.depth_in,self.depth_out1]),
            wc2 = tf.Variable(tf.random_normal([filter_height, filter_width, self.depth_out1, self.depth_out2])),
            wd1 = tf.Variable(tf.random_normal([(input_height//4)* (input_heigh//4) * seld.depth_out2, 1024])),
            out = tf.Variable(tf.random_normal([1024, self.n_classes])))
    
    def initialize_biases(self):
        
        return dict(bc1 = tf.Variable(tf.random_normal([64])),
           bc2 = tf.Variable(tf.random_normal([128])),
           bd1 = tf.Variable(tf.random_normal([1024])),
           out = tf.Variable(tf.random_normal([self.n_classes])))
    
    def conv2d(self, x, W, b, strides=1, padding = 'SAME'):          
        """ Convolution Layer + Recitfied Linear Unit """
        x = tf.nn.conv2d(x,W,strides=[1,strides,strides,1],padding=padding)

        # Add bias for each output feature map
        x = tf.nn.bias_add(x,b)
        return tf.nn.relu(x) # add non-linearity to the system


    def maxpool2d(self, x,stride=2, padding= 'SAME'):
        """ Max Pooling Layer """
        return tf.nn.max_pool(x,ksize=[1,stride,stride,1],strides=[1,stride,stride,1],padding=padding)
    

    def conv_net(self, x, weights, biases, dropout):
        """ Feedforward model;
            1st dimension - image index
            2nd dimension - height
            3rd dimension - width
            4th dimension - depth
        """
        
        x = tf.reshape(x,shape=[-1, self.input_heigh,self.input_width,1])
        
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
                

        




