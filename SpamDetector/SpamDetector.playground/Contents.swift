import Foundation
import CreateML

/*
    Primeiro, criamos uma constante chamada data, que é um tipo de MLDataTable para nosso arquivo spam.json.
    MLDataTable é um objeto totalmente novo usado para criar uma tabela determinada para treinar ou avaliar um modelo de ML
 */
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/ronaldogomes/Desktop/MachineLearningSwift/SpamDetector/SpamDetector.playground/Resources/spam.json"))

/*
    Dividimos nossos dados em trainingData e testingData. Como antes, a proporção é de 80-20 e a
    semente é 5. A semente se refere a onde o classificador deve começar.
 */

let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

/*
    Em seguida, definimos um MLTextClassifier chamado spamClassifier com nossos dados de treinamento,
    definindo quais valores dos dados são texto e quais valores são rótulos.
 */

let spamClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label")

/*
    Criamos duas variáveis chamadas trainingAccuracy e validationAccuracy usadas para determinar o quão
    preciso é o nosso classificador. No painel lateral, você poderá ver a porcentagem.
 */

let trainingAccuracy = (1.0 - spamClassifier.trainingMetrics.classificationError) * 100
let validationAccuracy = (1.0 - spamClassifier.validationMetrics.classificationError) * 100

/*
    Também verificamos como a avaliação foi realizada. (Lembre-se de que a avaliação são os resultados
    usados no texto que o classificador não viu antes e o quão preciso os obteve.)
*/

let evaluationMetrics = spamClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "label")
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

/*
    Por fim, criamos alguns metadados para o modelo de ML, como autor, descrição e versão.
    Usamos a função write () para salvar o modelo no local de nossa escolha!
 */

let metadata = MLModelMetadata(author: "Ronaldo Gomes", shortDescription: "A model trained to classify spam messages", version: "1.0")
try spamClassifier.write(to: URL(fileURLWithPath: "/Users/ronaldogomes/Desktop/MachineLearningSwift/SpamDetector/SpamDetector.mlmodel"), metadata: metadata)
