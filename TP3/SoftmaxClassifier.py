import numpy as np
from sklearn.base import BaseEstimator, ClassifierMixin


class SoftmaxClassifier(BaseEstimator, ClassifierMixin):
    """A softmax classifier"""

    def __init__(self, lr=0.1, alpha=100, n_epochs=1000, eps=1.0e-5, threshold=1.0e-10, regularization=True,
                 early_stopping=True, use_zero_indexed_classes=True):

        """
            self.lr : the learning rate for weights update during gradient descent
            self.alpha: the regularization coefficient 
            self.n_epochs: the number of iterations
            self.eps: the threshold to keep probabilities in range [self.eps;1.-self.eps]
            self.regularization: Enables the regularization, help to prevent overfitting
            self.threshold: Used for early stopping, if the difference between losses during 
                            two consecutive epochs is lower than self.threshold, then we stop the algorithm
            self.early_stopping: enables early stopping to prevent overfitting
            self.use_zero_indexed_classes: Whether prediction classes should start at 0 (if True) or 1 (if False)
        """

        self.lr = lr
        self.alpha = alpha
        self.n_epochs = n_epochs
        self.eps = eps
        self.regularization = regularization
        self.threshold = threshold
        self.early_stopping = early_stopping
        self.use_zero_indexed_classe = use_zero_indexed_classes

    """
        Public methods, can be called by the user
        To create a custom estimator in sklearn, we need to define the following methods:
        * fit
        * predict
        * predict_proba
        * fit_predict        
        * score
    """

    """
        In:
        X : the set of examples of shape nb_example * self.nb_features
        y: the target classes of shape nb_example *  1

        Do:
        Initialize model parameters: self.theta_
        Create X_bias i.e. add a column of 1. to X , for the bias term
        For each epoch
            compute the probabilities
            compute the loss
            compute the gradient
            update the weights
            store the loss
        Test for early stopping

        Out:
        self, in sklearn the fit method returns the object itself


    """

    def fit(self, X, y=None):

        prev_loss = np.inf
        self.losses_ = []

        self.nb_feature = X.shape[1]
        self.nb_classes = len(np.unique(y))

        X_bias = np.concatenate((X, np.ones((X.shape[0], 1))), axis=1)
        self.theta_ = np.random.normal(scale=0.3, size=(X_bias.shape[1], self.nb_classes))

        for epoch in range(self.n_epochs):
            probabilities = self.predict_proba(X, y)
            loss = self._cost_function(probabilities, y)
            gradient = self._get_gradient(X_bias, y, probabilities)
            self.theta_ -= self.lr * gradient
            self.losses_.append(loss)
            print("Epoch {}: Loss: {}".format(epoch, loss))

            if self.early_stopping:
                if prev_loss - loss < self.threshold:
                    return self

            prev_loss = loss

        return self

    """
        In: 
        X without bias

        Do:
        Add bias term to X
        Compute the logits for X
        Compute the probabilities using softmax

        Out:
        Predicted probabilities
    """

    def predict_proba(self, X, y=None):
        try:
            getattr(self, "theta_")
        except AttributeError:
            raise RuntimeError("You must train classifer before predicting data!")

        X_bias = np.concatenate((X, np.ones((X.shape[0], 1))), axis=1)
        logits = np.matmul(X_bias, self.theta_)

        return np.apply_along_axis(self._softmax, axis=1, arr=logits)

    """
        In: 
        X without bias

        Do:
        Add bias term to X
        Compute the logits for X
        Compute the probabilities using softmax
        Predict the classes

        Out:
        Predicted classes
    """

    def predict(self, X, y=None):
        try:
            getattr(self, "theta_")
        except AttributeError:
            raise RuntimeError("You must train classifer before predicting data!")
        return np.argmax(self.predict_proba(X), axis=1) + (0 if self.use_zero_indexed_classe else 1)

    def fit_predict(self, X, y=None):
        self.fit(X, y)
        return self.predict(X, y)

    """
        In : 
        X set of examples (without bias term)
        y the true labels

        Do:
            predict probabilities for X
            Compute the log loss without the regularization term

        Out:
        log loss between prediction and true labels

    """

    def score(self, X, y=None):
        prob = self.predict_proba(X)
        tempReg = self.regularization
        self.regularization = False
        loss = self._cost_function(prob, y)
        self.regularization = tempReg
        return loss

    """
        Private methods, their names begin with an underscore
    """

    """
        In :
        y without one hot encoding
        probabilities computed with softmax

        Do:
        One-hot encode y
        Ensure that probabilities are not equal to either 0. or 1. using self.eps
        Compute log_loss
        If self.regularization, compute l2 regularization term
        Ensure that probabilities are not equal to either 0. or 1. using self.eps

        Out:
        Probabilities
    """

    def _cost_function(self, probabilities, y):
        one_hot = self._one_hot(y)
        np.clip(probabilities, self.eps, 1 - self.eps)
        l2 = 0
        if self.regularization:
            try:
                getattr(self, "theta_")
            except AttributeError:
                raise RuntimeError("You must train classifer before predicting data!")
            l2 = self.alpha * np.sum((self.theta_[1:, :] ** 2))
        return (-1 / one_hot.shape[0]) * (np.sum(one_hot * np.log(probabilities)) - l2)

    """
        In :
        Target y: nb_examples * 1

        Do:
        One hot-encode y
        [1,1,2,3,1] --> [[1,0,0],
                         [1,0,0],
                         [0,1,0],
                         [0,0,1],
                         [1,0,0]]
        Out:
        y one-hot encoded
    """

    def _one_hot(self, y):
        if not self.use_zero_indexed_classe:
            y = y - 1
        n_values = np.max(y) + 1
        return np.eye(n_values)[y]

    """
        In :
        Logits: (self.nb_features +1) * self.nb_classes

        Do:
        Compute softmax on logits

        Out:
        Probabilities
    """

    def _softmax(self, z):
        z_exp = np.exp(z)
        return z_exp / np.sum(z_exp)

    """
        In:
        X with bias
        y without one hot encoding
        probabilities resulting of the softmax step

        Do:
        One-hot encode y
        Compute gradients
        If self.regularization add l2 regularization term

        Out:
        Gradient

    """

    def _get_gradient(self, X, y, probas):
        one_hot = self._one_hot(y)
        l2 = 0
        if self.regularization:
            try:
                getattr(self, "theta_")
            except AttributeError:
                raise RuntimeError("You must train the classifer to use L2 regularization!")
            l2 = 2 * self.theta_ * self.alpha

        return (1 / one_hot.shape[0]) * (np.matmul(X.T, (probas - one_hot)) + l2)
