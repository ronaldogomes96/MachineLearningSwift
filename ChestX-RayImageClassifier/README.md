# Chest X-Ray Image Classifier

Chest X-Ray Image Classifier is a complete personal machine learning project, as it is done by choosing the database, creating the model and applying it in an iOS application.

The database was extracted from the [kaggle](https://www.kaggle.com/paultimothymooney/chest-xray-pneumonia) and consists of almost 6,000 chest X-rays of people with and without pneumonia. This base was divided into training and testing.

CreateML was used to create the CoreMl model. 25 interactions of the neural network were configured and their performance was satisfactory, with 92% accuracy in the test base.

After, the coreML model was exported, the project was done in xcode. It consists of choosing an image from the gallery or taking a photo and results in the possible diagnosis. Of course, this diagnosis cannot be considered the end, as the professional opinion of a doctor always has greater validity, however applications like this can help a lot in the diagnosis of diseases.
