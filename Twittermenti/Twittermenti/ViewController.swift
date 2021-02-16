//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import CoreML
import SwifteriOS
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    //Carrega o modelo coreml
    let sentimentClassifier = TweetSentimentClassifier()
    
    // Login da conta de dev do twitter
    let swifter = Swifter(consumerKey: "O8ZQlOZWwm8Wxholrx3xeVOia",
                          consumerSecret: "oUMdkmLVSjqCYR4Uru727Ct9qZL1RC0jebLZHceqUzHJHBvRR6")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Usa a api pra fazer a busca do tweet 
        swifter.searchTweet(using: textField.text ?? "", lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in

            // Inicializa um array que ira ter os inputs do tipo do modelo
            var tweets = [TweetSentimentClassifierInput]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    
                    //Transforma a string em tipo input do modelo
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
            }
            
            do {
                // Faz a predicao do array de inputs
                let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                var sentimentScore = 0
                
                for pred in predictions {
                    if pred.label == "pos" {
                        sentimentScore += 1
                    } else if pred.label == "neg" {
                        sentimentScore -= 1
                    }
                }
            } catch {
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

