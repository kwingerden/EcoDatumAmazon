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
    }
  }
  
  private var abioticEcoData: AbioticEcoData! {
    return ecoFactor.abioticEcoData!
  }
  
  private var abioticDataUnit: AbioticDataUnit! {
    return abioticEcoData!.dataUnit!
  }
  
  @IBOutlet weak var soilTextureDataValueView: UIView!
  
  @IBOutlet weak var scaleDataValueView: UIView!
  
  @IBOutlet weak var decimalDataValueView: UIView!
  
  private var soilTextureDataValueChoiceController: SoilTextureDataValueChoiceController!
  
  private var scaleDataValueChoiceController: ScaleDataValueChoiceController!
  
  private var decimalDataValueChoiceController: DecimalDataValueChoiceController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch abioticDataUnit! {
      
    case ._Air_Ozone_Scale_,
         ._Soil_Potassium_Scale_,
         ._Water_Odor_Scale_,
         ._Water_pH_Scale_,
         ._Water_Turbidity_Scale_:
      title = "Select Value"
      
    case ._Soil_Texture_Scale_:
      title = "Enter Values"
      
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
    }
    
    scaleDataValueView.isHidden = !(embeddedViewToDisplay == .scaleDataValueView)
    soilTextureDataValueView.isHidden = !(embeddedViewToDisplay == .soilTextureDataValueView)
    decimalDataValueView.isHidden = !(embeddedViewToDisplay == .decimalDataValueView)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.done,
      target: self,
      action: #selector(doneButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is SoilTextureDataValueChoiceController:
      soilTextureDataValueChoiceController = segue.destination as! SoilTextureDataValueChoiceController
      soilTextureDataValueChoiceController.parentController = self
      soilTextureDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      soilTextureDataValueChoiceController.ecoFactor = ecoFactor
    
    case is ScaleDataValueChoiceController:
      scaleDataValueChoiceController = segue.destination as! ScaleDataValueChoiceController
      scaleDataValueChoiceController.parentController = self
      scaleDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      scaleDataValueChoiceController.ecoFactor = ecoFactor
      
    case is DecimalDataValueChoiceController:
      decimalDataValueChoiceController = segue.destination as! DecimalDataValueChoiceController
      decimalDataValueChoiceController.parentController = self
      decimalDataValueChoiceController.embeddedViewToDisplay = embeddedViewToDisplay
      decimalDataValueChoiceController.ecoFactor = ecoFactor
    
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
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
    let mainTabBarController = navigationController?.viewControllers.first {
      $0 is MainTabBarController
    }
    if let mainTabBarController = mainTabBarController {
      navigationController?.popToViewController(mainTabBarController, animated: true)
    }
  }
  
}
