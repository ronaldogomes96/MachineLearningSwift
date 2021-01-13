import Cocoa
import CreateML

let data  = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/ronaldogomes/Desktop/MachineLearningSwift/Twittermenti/TweetSentimentModelMaker.playground/Resources/twitter-sanders-apple3.csv"))

let (trainingData, testData) = data.randomSplit(by: 0.8)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let metadata = MLModelMetadata(author: "Ronaldo Gomes", shortDescription: "A model trained for classifer sentiment on Twitter", license: nil, version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/ronaldogomes/Desktop/MachineLearningSwift/Twittermenti/TweetSentimentClassifier.mlmodel"), metadata: metadata)
