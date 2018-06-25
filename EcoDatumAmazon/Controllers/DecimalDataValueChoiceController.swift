import Foundation
import iosMath
import UIKit

class DecimalDataValueChoiceController: UIViewController {
  
  var embeddedViewToDisplay: AbioticDataValueChoiceController.EmbeddedView!
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var dataValueTextField: UITextField!
  
  @IBOutlet weak var dataUnitView: UIView!
  
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
    
    if dataUnitView.subviews.index(of: dataUnitLabel) == nil {
      dataUnitView.addSubview(dataUnitLabel)
      dataUnitLabel.textAlignment = .left
      dataUnitLabel.fontSize = 25
      dataUnitLabel.textColor = .black
      dataUnitLabel.frame.size = dataUnitView.frame.size
    }
    
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is AbioticDataDetailController:
      let viewController = segue.destination as! AbioticDataDetailController
      viewController.ecoFactor = ecoFactor
    default:
      LOG.error("Unrecognized segue destination \(segue.destination)")
    }
  }
  private func validateDecimalTextField() -> Decimal? {
    if let _ = toDouble(), let decimal = toDecimal() {
      dataValueTextField.resignFirstResponder()
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
  
  private func saveData(_ dataValue: Decimal) {
    do {
      let dataValue = AbioticDataValue.DecimalDataValue(dataValue)
      let newAbioticEcoData = abioticEcoData.new(dataValue)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Abiotic(newAbioticEcoData))
      if let site = ViewContext.shared.selectedSite,
        let newAbioticData = try AbioticData.create(newEcoFactor) {
        site.addToEcoData(newAbioticData)
        try PersistenceUtil.shared.saveContext()
      } else {
        LOG.error("No selected site")
      }
    } catch {
      LOG.error("Faield to create and save abiotic data: \(error)")
    }
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
      let dataValue = validateDecimalTextField() {
      saveData(dataValue)
      parent?.performSegue(withIdentifier: "abioticDataDetail", sender: nil)
    }
  }
  
}
