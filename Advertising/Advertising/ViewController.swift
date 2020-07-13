

import UIKit

final class ViewController: UIViewController {
  @IBOutlet private var tvSlider: UISlider!
  @IBOutlet private var radioSlider: UISlider!
  @IBOutlet private var newspaperSlider: UISlider!
  @IBOutlet private var tvLabel: UILabel!
  @IBOutlet private var radioLabel: UILabel!
  @IBOutlet private var newspaperLabel: UILabel!
  @IBOutlet private var salesLabel: UILabel!
  private let numberFormatter = NumberFormatter()
  
  //Classe coreml
  private let advertising = Advertising()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 1
    
    sliderValueChanged()
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider? = nil) {
    let tv = Double(tvSlider.value)
    let radio = Double(radioSlider.value)
    let newspaper = Double(newspaperSlider.value)
    
    let input = AdvertisingInput(tv: tv, radio: radio, newspaper: newspaper)
    guard let output = try? advertising.prediction(input: input) else {
      return
    }
    
    //O valor da predicao
    let sales = output.sales
    
    tvLabel.text = numberFormatter.string(from: tv as NSNumber)
    radioLabel.text = numberFormatter.string(from: radio as NSNumber)
    newspaperLabel.text = numberFormatter.string(from: newspaper as NSNumber)
    salesLabel.text = numberFormatter.string(from: sales as NSNumber)
  }
}
