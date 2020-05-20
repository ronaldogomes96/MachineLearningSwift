
import UIKit
import CoreML

class PoemViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var poemTextView: UITextView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var resultTable: UITableView!

  // MARK: - Properties
  var probabilities: [(String, Double)]?

  private lazy var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    return formatter
  }()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    poemTextView.layer.borderWidth = 1.0
    poemTextView.layer.borderColor = UIColor.darkGray.cgColor
    poemTextView.layer.cornerRadius = 4
    poemTextView.delegate = self
  }
}

// MARK: - Internal
private extension PoemViewController {

  func analyze(text: String) {
    
    //Inicializa uma variável para armazenar a saída de wordCounts(text:)
    let counts = wordCounts(text: text)
    
    //Cria uma instância do modelo Core ML
    let model = Poets()
    
    //Agrupa a lógica de previsão em um bloco do/catch porque pode gerar um erro.
    do {
      //Passa o texto analisado para a prediction(text:)função que executa o modelo.
      let prediction = try model.prediction(text: counts)
      updateWithPrediction(poet: prediction.author,
                           probabilities: prediction.authorProbability)
    } catch {
      //Registra um erro, se houver.
      print(error)
    }
  }
  
  func updateWithPrediction(poet: String, probabilities: [String: Double]) {
    titleLabel.text = "Written by: \(poet)"
    titleLabel.textColor = .darkText
    
    self.probabilities = probabilities.sorted { a, b in
      a.value > b.value
    }
    resultTable.reloadData()
  }
  
  func updateWithError(error: Error) {
    titleLabel.text = error.localizedDescription
    titleLabel.textColor = .red
    probabilities = nil
    resultTable.reloadData()
  }
  
  func wordCounts(text:String) -> [String: Double] {
    
    //Inicializa seu dicionário de palavras.
    var bagOfWords: [String: Double] = [:]
    
    //Cria uma NSLinguisticTaggerconfiguração para marcar todos os tokens (palavras, pontuação, espaço em branco) em uma sequência.
    let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
    
    //O etiquetador opera sobre a NSRange, então você cria um intervalo para toda a cadeia.
    let range = NSRange(text.startIndex..., in: text)
    
    //Define as opções para ignorar pontuação e espaço em branco ao marcar a sequência.
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
    
    //Defina a string do marcador para o parâmetro de texto.
    tagger.string = text
    
    //Aplica o bloco a todas as tags encontradas na string para cada palavra.Essa combinação de parâmetros identifica todas as palavras na sequência e, em seguida, incrementa um valor do dicionário para a palavra, que funciona como a chave do dicionário.
    tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _ , tokenRange, _ in
      let word  = (text as NSString).substring(with: tokenRange)
      bagOfWords[word, default: 0] += 1
    }
    
    //Retorna o dicionario de palavras
    return bagOfWords
  }
}

// MARK: - UITextViewDelegate
extension PoemViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard text == "\n" else {
      return true
    }

    textView.resignFirstResponder()
    return false
  }
  
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    analyze(text: textView.text)
  }
}

// MARK: - UITableViewDataSource
extension PoemViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return probabilities?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
    if let poet = probabilities?[indexPath.row] {
      let percent = formatter.string(for: poet.1)!
      cell.configureCell("\(poet.0): \(percent)", progress: Float(poet.1))
    }
    return cell
  }
}
