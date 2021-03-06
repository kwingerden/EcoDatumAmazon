//
//  BioticPhotoChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/27/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class BioticNotesChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var textView: UITextView!
  
  private var bioticEcoData: BioticEcoData!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    
    switch ecoFactor.ecoData! {
    case .Biotic(let bioticEcoData):
      title = "\(bioticEcoData.bioticFactor!.rawValue) Notes"
    default:
      LOG.error("Unexpected EcoFactor: \(String(describing: ecoFactor))")
    }
    
    textView.roundedAndLightBordered()
    textView.allowsEditingTextAttributes = true
    textView.attributedText = nil
    textView.delegate = self
    textView.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.done,
      target: self,
      action: #selector(doneButtonPressed))
  }
  
  @objc func doneButtonPressed() {
    if let site = ViewContext.shared.selectedSite {
      do {
        let newBioticEcoData = bioticEcoData.new(textView.attributedText)
        let newEcoFactor = EcoFactor(
          collectionDate: ecoFactor.collectionDate,
          ecoData: EcoFactor.EcoData.Biotic(newBioticEcoData))
        let newBioticData = try BioticData.create(newEcoFactor)
        site.addToEcoData(newBioticData!)
        try site.save()
      } catch {
        LOG.error("Faield to create and save biotic data: \(error)")
      }
    } else {
      LOG.error("No selected site")
    }

    dismiss(animated: true, completion: nil)
  }
  
}

extension BioticNotesChoiceController: UITextViewDelegate {
  
  func textViewDidEndEditing(_ textView: UITextView) {
    doneButtonPressed()
  }
  
}



