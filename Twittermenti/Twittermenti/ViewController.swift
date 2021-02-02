//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    // Login da conta de dev do twitter
    let swifter = Swifter(consumerKey: "", consumerSecret: "")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prediction = try! sentimentClassifier.prediction(text: "")
        
        swifter.searchTweet(using: textField.text ?? "", lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in

            guard let data = results[0] else {
                return
            }
            let celestialBodyDescription: JsonResult
            do {
                celestialBodyDescription = try JSONDecoder().decode(JsonResult.self, from: data)
            } catch {
                print(error)
                return
            }
        } failure: { (error) in
            print(error)
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

