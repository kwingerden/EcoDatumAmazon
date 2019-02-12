//
//  BioticDecimalDataValueChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/11/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation
import iosMath
import UIKit

class BioticDecimalDataValueChoiceController: UIViewController {
  
  var parentController: BioticDataValueChoiceController!
  
  var embeddedViewToDisplay: BioticDataValueChoiceController.EmbeddedView!
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var dataValueTextField: UITextField!
  
  @IBOutlet weak var dataUnitView: UIView!
  
  private var dataUnitLabel: MTMathUILabel = MTMathUILabel()
  
  private var bioticEcoData: BioticEcoData! {
    return ecoFactor.bioticEcoData!
  }
  
  private var bioticDataUnit: DataUnit! {
    return bioticEcoData!.dataUnit!
  }
  
  private var isViewDisappearing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard embeddedViewToDisplay == .decimalDataValueView else {
      return
    }
    
    dataValueTextField.keyboardType = .decimalPad
    dataValueTextField.becomeFirstResponder()
    dataUnitLabel.latex = bioticDataUnit.rawValue
    
    dataValueTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard embeddedViewToDisplay == .decimalDataValueView else {
      return
    }
    view.setNeedsLayout()
    isViewDisappearing = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    guard embeddedViewToDisplay == .decimalDataValueView else {
      return
    }
    
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
  
  func doneButtonPressed() {
    guard embeddedViewToDisplay == .decimalDataValueView else {
      return
    }
    
    if let decimalValue = validateDecimalTextField() {
      let ecoData = bioticEcoData.new(.DecimalDataValue(decimalValue))
      parentController.ecoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Biotic(ecoData))
      parentController.performSegue(withIdentifier: "bioticPhotoChoice", sender: nil)
    }
  }
  
  private func validateDecimalTextField() -> String? {
    if let _ = toDouble(), let _ = toDecimal() {
      return dataValueTextField.text
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

extension BioticDecimalDataValueChoiceController: UITextFieldDelegate {
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if isViewDisappearing {
      return true
    }
    return validateDecimalTextField() != nil
  }
  
  func textFieldDidEndEditing(_ textField: UITextField,
                              reason: UITextField.DidEndEditingReason) {
    if isViewDisappearing {
      return
    }
    if reason == .committed {
      doneButtonPressed()
    }
  }
  
}
