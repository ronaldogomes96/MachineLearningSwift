//
//  ViewController.swift
//  SentimentAnalisys
//
//  Created by Ronaldo Gomes on 06/10/20.
//

import UIKit
import NaturalLanguage
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func analise(_ sender: Any) {
        
        let text = userText.text
        let mlModel = try? SentimentPolarity(configuration: MLModelConfiguration()).model

        
        //let sentimentPrediction = try? NLModel(mlModel: mlModel!)
        let prediction = mlModel?.prediction(from: text)
        
        //print(sentimentPrediction!)
        //print(prediction!)
        
        sentimentLabel.text = prediction
    }
    
}

