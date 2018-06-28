//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import iosMath
import UIKit

class BioticDataDetailController: UIViewController {
  
  var site: Site!
  
  var bioticData: BioticData!
  
  var ecoFactor: EcoFactor!
  
  var collectionDate: Date {
    return ecoFactor.collectionDate!
  }
  
  var ecoData: EcoFactor.EcoData! {
    return ecoFactor.ecoData!
  }
  
  var bioticEcoData: BioticEcoData! {
    return ecoFactor.bioticEcoData!
  }
  
  var bioticFactor: BioticFactor! {
    return bioticEcoData.bioticFactor!
  }
  
  var bioticPhoto: UIImage! {
    return bioticEcoData.image!
  }
  
  var bioticNotes: NSAttributedString! {
    return bioticEcoData.notes!
  }
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch ecoData! {
    case .Abiotic:
      LOG.error("Unexpected Abiotic ecodata")
      return
    case .Biotic:
      title = "\(bioticFactor.rawValue) EcoData"
    }
    
    imageView.image = bioticPhoto
    imageView.roundedAndLightBordered()
    
    textView.attributedText = bioticNotes
    textView.roundedAndLightBordered()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.done,
      target: self,
      action: #selector(doneButtonPressed))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.trash,
      target: self,
      action: #selector(trashButtonPressed))
  }
  
  @objc func doneButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func trashButtonPressed() {
    let alert = UIAlertController(
      title: "Delete Data Confirmation",
      message: "Are you sure you want to delete this data value?",
      preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
      alertAction in
      do {
        try self.bioticData.delete()
        try self.bioticData.save()
      } catch {
        LOG.error("Failed to delete biotic data: \(error)")
      }
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true)
  }
  
}

