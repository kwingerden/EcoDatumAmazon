//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AbioticDataValueChoiceController: UIViewController {
  
  enum EmbeddedView {
    case soilTextureDataValueView
    case scaleDataValueView
    case decimalDataValueView
  }
  
  var ecoFactor: EcoFactor!
  
  var embeddedViewToDisplay: EmbeddedView {
    switch abioticDataUnit! {
      
    case ._Air_Ozone_Scale_,
         ._Soil_Potassium_Scale_,
         ._Water_Odor_Scale_,
         ._Water_pH_Scale_,
         ._Water_Turbidity_Scale_:
      return .scaleDataValueView
      
    case ._Soil_Texture_Scale_:
      return .soilTextureDataValueView
      
    case .DegreesCelsius,
         .DegreesFahrenheit,
         .FeetPerSecond,
         .JacksonTurbidityUnits,
         .Lux,
         .MegawattsPerMeterSquared,
         .MetersPerSecond,
         .MicromolesPerMetersSquaredAndSeconds,
         .MicrosiemensPerCentimeter,
         .MilesPerHour,
         .MilligramsPerLiter,
         .NephelometricTurbidityUnits,
         .PartsPerMillion,
         .Percent,
         .PhotosyntheticPhotonFluxDensity,
         .PoundsPerAcre:
      return .decimalDataValueView
      
    default:
      fatalError()
      
    }
    
  }
  
  private var abioticEcoData: AbioticEcoData!
  
  private var abioticDataUnit: DataUnit! 
  
  @IBOutlet weak var soilTextureDataValueView: UIView!
  
  @IBOutlet weak var scaleDataValueView: UIView!
  
  @IBOutlet weak var decimalDataValueView: UIView!
  
  private var soilTextureDataValueChoiceController: SoilTextureDataValueChoiceController!
  
  private var scaleDataValueChoiceController: ScaleDataValueChoiceController!
  
  private var decimalDataValueChoiceController: DecimalDataValueChoiceController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    abioticEcoData = ecoFactor.abioticEcoData!
    abioticDataUnit = abioticEcoData.dataUnit!
    
    switch abioticDataUnit! {
      
    case ._Air_Ozone_Scale_,
         ._Soil_Potassium_Scale_,
         ._Water_Odor_Scale_,
         ._Water_pH_Scale_,
         ._Water_Turbidity_Scale_:
      title = "Select Value"
      
    case ._Soil_Texture_Scale_:
      title = "Select Values"
      
    case .DegreesCelsius,
         .DegreesFahrenheit,
         .FeetPerSecond,
         .JacksonTurbidityUnits,
         .Lux,
         .MegawattsPerMeterSquared,
         .MetersPerSecond,
         .MicromolesPerMetersSquaredAndSeconds,
         .MicrosiemensPerCentimeter,
         .MilesPerHour,
         .MilligramsPerLiter,
         .NephelometricTurbidityUnits,
         .PartsPerMillion,
         .Percent,
         .PhotosyntheticPhotonFluxDensity,
         .PoundsPerAcre:
      title = "Enter Value"
      
    default:
      fatalError()
      
    }
    
    scaleDataValueView.isHidden = !(embeddedViewToDisplay == .scaleDataValueView)
    soilTextureDataValueView.isHidden = !(embeddedViewToDisplay == .soilTextureDataValueView)
    decimalDataValueView.isHidden = !(embeddedViewToDisplay == .decimalDataValueView)
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
    abioticEcoData = ecoFactor.abioticEcoData!
    abioticDataUnit = abioticEcoData.dataUnit!
    
    switch segue.destination {
    case is SoilTextureDataValueChoiceController:
      soilTextureDataValueChoiceController = (segue.destination as! SoilTextureDataValueChoiceController)
      soilTextureDataValueChoiceController.parentController = self
      soilTextureDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      soilTextureDataValueChoiceController.ecoFactor = ecoFactor
    
    case is ScaleDataValueChoiceController:
      scaleDataValueChoiceController = (segue.destination as! ScaleDataValueChoiceController)
      scaleDataValueChoiceController.parentController = self
      scaleDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      scaleDataValueChoiceController.ecoFactor = ecoFactor
      
    case is DecimalDataValueChoiceController:
      decimalDataValueChoiceController = (segue.destination as! DecimalDataValueChoiceController)
      decimalDataValueChoiceController.parentController = self
      decimalDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      decimalDataValueChoiceController.ecoFactor = ecoFactor
    
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func doneButtonPressed() {
    soilTextureDataValueChoiceController.doneButtonPressed()
    scaleDataValueChoiceController.doneButtonPressed()
    decimalDataValueChoiceController.doneButtonPressed()
  }
  
  func saveData() {
    if let site = ViewContext.shared.selectedSite {
      do {
        let newAbioticData = try AbioticData.create(ecoFactor)
        site.addToEcoData(newAbioticData!)
        try site.save()
      } catch {
        LOG.error("Faield to create and save abiotic data: \(error)")
      }
    } else {
      LOG.error("No selected site")
    }
  }
  
  func popToMainTabBarController() {
    dismiss(animated: true, completion: nil)
  }
  
}
