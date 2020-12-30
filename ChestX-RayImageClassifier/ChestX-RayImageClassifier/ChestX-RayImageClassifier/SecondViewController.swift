//
//  SecondViewController.swift
//  ChestX-RayImageClassifier
//
//  Created by Ronaldo Gomes on 29/12/20.
//

import UIKit
import CoreML
import Vision

class SecondViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var textResult: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.textResult.text = ""
    }
    
    @IBAction func chosePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Cannot convert to CIImage")
            }
            detectClassification(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detectClassification(image: CIImage) {
        //Carrega o modelo feito pelo createML, usando o VNCoreMLModel, do framework vision
        guard let model = try? VNCoreMLModel(for: ChestX_RayImageClassifier_1(configuration: .init()).model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        //Cria o request desse model de forma assicrona
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            //Recebe os resultados desse request
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            //Pega o primeiro resultado, que é o com maior probabilidade de estar certo
            if let firstResult = results.first {
                self.textResult.text = firstResult.identifier.capitalized
                print (firstResult.confidence)
            }
        }
        
        //Objeto do request da imagem
        let handle = VNImageRequestHandler(ciImage: image)
        
        do {
            //Faz o request da imagem com o coreML request configurado
            try handle.perform([request])
        } catch {
            print(error)
        }
    }
}
