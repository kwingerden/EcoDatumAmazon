//
//  BioticDataValueChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/11/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//
import Foundation
import UIKit

class BioticDataValueChoiceController: UIViewController {
  
  enum EmbeddedView {
    case decimalDataValueView
  }
  
  var ecoFactor: EcoFactor!
  
  var embeddedViewToDisplay: EmbeddedView {
      return .decimalDataValueView
  }
  
  private var bioticEcoData: BioticEcoData!
  
  private var bioticDataUnit: DataUnit!
  
  @IBOutlet weak var decimalDataValueView: UIView!
  
  private var decimalDataValueChoiceController: BioticDecimalDataValueChoiceController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    bioticDataUnit = bioticEcoData.dataUnit!
    
    title = "Enter Value"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(
        barButtonSystemItem: UIBarButtonItem.SystemItem.done,
        target: self,
        action: #selector(doneButtonPressed)),
      UIBarButtonItem(
        barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
        target: self,
        action: #selector(cancelButtonPressed))
    ]
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    bioticEcoData = ecoFactor.bioticEcoData!
    bioticDataUnit = bioticEcoData.dataUnit!
    
    switch segue.destination {
      
    case is BioticDecimalDataValueChoiceController:
      decimalDataValueChoiceController = (segue.destination as! BioticDecimalDataValueChoiceController)
      decimalDataValueChoiceController.parentController = self
      decimalDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      decimalDataValueChoiceController.ecoFactor = ecoFactor
      
    case is BioticPhotoChoiceController:
      let viewController = segue.destination as! BioticPhotoChoiceController
      viewController.ecoFactor = ecoFactor
      
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func doneButtonPressed() {
    decimalDataValueChoiceController.doneButtonPressed()
  }
  
  func saveData() {
    if let site = ViewContext.shared.selectedSite {
      do {
        let newBioticData = try BioticData.create(ecoFactor)
        site.addToEcoData(newBioticData!)
        try site.save()
      } catch {
        LOG.error("Faield to create and save biotic data: \(error)")
      }
    } else {
      LOG.error("No selected site")
    }
  }
  
  func popToMainTabBarController() {
    dismiss(animated: true, completion: nil)
  }
  
}
