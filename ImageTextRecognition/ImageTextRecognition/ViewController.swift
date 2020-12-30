//
//  ViewController.swift
//  ImageTextRecognition
//
//  Created by Ronaldo Gomes on 12/11/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var symbolImage: UIImageView!
    @IBOutlet weak var analiseButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        setButtonImage()
    }
    
    func setButtonImage() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(buttonAction))
        symbolImage.addGestureRecognizer(gesture)
    }
    
    @objc func buttonAction() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //image = image.fixOrientation()
            if let data = image.pngData() {
                symbolImage.image = UIImage(data: data)
                //UserDefaults.standard.set(data, forKey: "userImage")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func analiseButton(_ sender: UIButton) {
        
    }
    
}

