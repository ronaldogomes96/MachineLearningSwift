
import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var scene: UIImageView!
  @IBOutlet weak var answerLabel: UILabel!

  // MARK: - Properties
  let vowels: [Character] = ["a", "e", "i", "o", "u"]

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let image = UIImage(named: "train_night") else {
      fatalError("no starting image")
    }

    scene.image = image
    
    //Possibilita o uso do framework
    guard let ciImage = CIImage(image: image) else {
      fatalError("couldn't convert UIImage to CIImage")
    }

    detectScene(image: ciImage)
  }
}

// MARK: - IBActions

// MARK: - Methods

extension ViewController {

  //Funcao que o processo de analise da imagem
  func detectScene(image: CIImage) {
    answerLabel.text = "detecting scene..."
    
    //O fluxo de trabalho padrão do Vision é criar um modelo, criar uma ou mais solicitações e criar e executar
    //um manipulador de solicitações.
  
    // Carregando o modelo de ML atraves da classe gerada pelo GoogLeNetPlaces
    guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
      fatalError("can't load Places ML model")
    }
    
    //Criacao da requisicao de vision\
    //VNCoreMLRequest é um analisador de imagem que usa CoreML
    /*
      Você verifica em request.results se há uma matriz de VNClassificationObservationobjetos, que é o que
      a estrutura Vision retorna quando o modelo Core ML é um classificador , em vez de um preditor ou
      processador de imagem.
      A VNClassificationObservationtem duas propriedades: identifier- a String- e confidence- um número
      entre 0 e 1 - que é a probabilidade de a classificação estar correta.
      Entao em results.first é o primeiro e maior valor de confianca
     */
    let request = VNCoreMLRequest(model: model) { [weak self] request, error in
      guard let results = request.results as? [VNClassificationObservation],
        let topResult = results.first else {
          fatalError("unexpected result type from VNCoreMLRequest")
      }

      // Enviando para a fila principal
      let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
      DispatchQueue.main.async { [weak self] in
        self?.answerLabel.text = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
      }
    }
    
    // Execute o classificador Core ML GoogLeNetPlaces na fila
    let handler = VNImageRequestHandler(ciImage: image)
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        try handler.perform([request])
      } catch {
        print(error)
      }
    }
  }
}

extension ViewController {

  @IBAction func pickImage(_ sender: Any) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = .savedPhotosAlbum
    present(pickerController, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    dismiss(animated: true)

    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      fatalError("couldn't load image from Photos")
    }

    scene.image = image
    
    //Possibilita o uso do framework
    guard let ciImage = CIImage(image: image) else {
      fatalError("couldn't convert UIImage to CIImage")
    }

    detectScene(image: ciImage)
  }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}
