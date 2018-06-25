import Foundation
import iosMath
import UIKit

class DecimalDataValueChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var dataValueTextField: UITextField!
  
  @IBOutlet weak var dataUnitView: UIView!
  
  private var dataUnitLabel: MTMathUILabel = MTMathUILabel()
  
  private var isBackButtonPressed = false
  
  private var abioticDataUnit: AbioticDataUnit! {
    return ecoFactor.abioticEcoData!.dataUnit!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataValueTextField.keyboardType = .decimalPad
    dataValueTextField.becomeFirstResponder()
    dataUnitLabel.latex = abioticDataUnit.rawValue
    
    dataValueTextField.delegate = self
    dataValueTextField.keyboardToolbar.doneBarButton.setTarget(
      self,
      action: #selector(doneButtonClicked))
  }
  
  override func viewDidLayoutSubviews() {
    if dataUnitView.subviews.index(of: dataUnitLabel) == nil {
      dataUnitView.addSubview(dataUnitLabel)
      dataUnitLabel.textAlignment = .left
      dataUnitLabel.fontSize = 25
      dataUnitLabel.textColor = .black
      dataUnitLabel.frame.size = dataUnitView.frame.size
    }
    
    super.viewDidLayoutSubviews()
  }
  
  override func willMove(toParentViewController parent: UIViewController?) {
    super.willMove(toParentViewController: parent)
    isBackButtonPressed = parent == nil
  }
  
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    isBackButtonPressed = parent == nil
  }
  
  @objc private func doneButtonClicked() {
    let _ = validateDecimalTextField()
  }
  
  private func validateDecimalTextField() -> Bool {
    guard !isBackButtonPressed && isValidDecimal() else {
      displayInvalidDecimalAlert()
      return false
    }
    return true
  }
  
  private func isValidDecimal() -> Bool {
    if let text = dataValueTextField.text,
      let _ = Decimal(string: text) {
      return true
    } else {
      return false
    }
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
    return validateDecimalTextField()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return validateDecimalTextField()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField,
                              reason: UITextFieldDidEndEditingReason) {
    if reason == .committed {
      let _ = validateDecimalTextField()
    }
  }
  
}
