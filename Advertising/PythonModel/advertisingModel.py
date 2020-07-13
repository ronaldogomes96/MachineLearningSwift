
import pandas as pd
import sklearn.model_selection as ms
import sklearn.linear_model as lm
import sklearn.svm as svm
import coremltools

adver = pd.read_csv("Advertising.csv", usecols = [1,2,3,4])

#Dividindo em base de dados em input e output
X, y = adver.iloc[:,:-1] , adver.iloc[:,-1]

#Base de teste e de treino

X_train, X_test, y_train, y_test = ms.train_test_split(X, y, test_size = 0.25, random_state = 24)

#Regressao linear
regressao = lm.LinearRegression()
regressao.fit(X_train, y_train)
score = regressao.score(X_test, y_test)

#Support vector machine
svr = svm.LinearSVR(random_state=42)
svr.fit(X_train, y_train)
score = svr.score(X_test, y_test)

#Importacao para coreml

#Nome das features
input_features = ["tv", "radio", "newspaper"]
output_feature = "sales"

model = coremltools.converters.sklearn.convert(regressao, input_features, output_feature)
model.save("Advertising.mlmodel")
