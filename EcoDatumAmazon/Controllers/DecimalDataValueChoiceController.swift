import Foundation
import iosMath
import UIKit

class DecimalDataValueChoiceController: UIViewController {
  
  var parentController: AbioticDataValueChoiceController!
  
  var embeddedViewToDisplay: AbioticDataValueChoiceController.EmbeddedView!
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var dataValueTextField: UITextField!
  
  @IBOutlet weak var dataUnitView: UIView!
  
  @IBOutlet weak var nextButton: UIButton!
  
  private var dataUnitLabel: MTMathUILabel = MTMathUILabel()
  
  private var abioticEcoData: AbioticEcoData! {
    return ecoFactor.abioticEcoData!
  }
  
  private var abioticDataUnit: AbioticDataUnit! {
    return abioticEcoData!.dataUnit!
  }
  
  private var isViewDisappearing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard embeddedViewToDisplay == .decimalDataValueView else {
      return
    }
    
    dataValueTextField.keyboardType = .decimalPad
    dataValueTextField.becomeFirstResponder()
    dataUnitLabel.latex = abioticDataUnit.rawValue
    
    dataValueTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isViewDisappearing = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    isViewDisappearing = true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    guard embeddedViewToDisplay == .decimalDataValueView else {
      return
    }
    
    if let index = dataUnitView.subviews.index(of: dataUnitLabel) {
      dataUnitView.subviews[index].removeFromSuperview()
    }
    dataUnitView.addSubview(dataUnitLabel)
    dataUnitLabel.textAlignment = .center
    dataUnitLabel.textColor = .black
    dataUnitLabel.font = MTFontManager().latinModernFont(withSize: 25)
    dataUnitLabel.frame.size = dataUnitView.frame.size
    
  }

  @IBAction func touchUpInside(_ sender: UIButton) {
    if sender == nextButton {
      if let decimalValue = validateDecimalTextField() {
        parentController.selectedDataValue = .DecimalDataValue(decimalValue)
        parentController.performSegue(withIdentifier: "abioticDataDetail", sender: nil)
      }
    }
  }
  
  private func validateDecimalTextField() -> Decimal? {
    if let _ = toDouble(), let decimal = toDecimal() {
      return decimal
    }
    displayInvalidDecimalAlert()
    return nil
  }
  
  private func toDouble() -> Double? {
    if let text = dataValueTextField.text {
      return Double(text)
    }
    return nil
  }
  
  private func toDecimal() -> Decimal? {
    if let text = dataValueTextField.text {
      return Decimal(string: text)
    }
    return nil
  }
  
  private func displayInvalidDecimalAlert() {
    let alert = UIAlertController(
      title: "Invalid Decimal Value",
      message: "The value must a decimal number (i.e. 33, 22.4, -78.18).",
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true)
  }
  
}

extension DecimalDataValueChoiceController: UITextFieldDelegate {
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if isViewDisappearing {
      return true
    }
    return validateDecimalTextField() != nil
  }
  
  func textFieldDidEndEditing(_ textField: UITextField,
                              reason: UITextFieldDidEndEditingReason) {
    if isViewDisappearing {
      return
    }
    if reason == .committed,
      let decimalValue = validateDecimalTextField() {
      parentController.selectedDataValue = .DecimalDataValue(decimalValue)
      parentController.performSegue(withIdentifier: "abioticDataDetail", sender: nil)
    }
  }
  
}
