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
  
  private var abioticDataUnit: AbioticDataUnit! {
    return ecoFactor.abioticEcoData!.dataUnit!
  }
  
  @IBOutlet weak var soilTextureDataValueView: UIView!
  
  @IBOutlet weak var scaleDataValueView: UIView!
  
  @IBOutlet weak var decimalDataValueView: UIView!
  
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
      barButtonSystemItem: UIBarButtonSystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is SoilTextureDataValueChoiceController:
      let controller = segue.destination as! SoilTextureDataValueChoiceController
      controller.embeddedViewToDisplay = embeddedViewToDisplay
      controller.ecoFactor = ecoFactor
    case is ScaleDataValueChoiceController:
      let controller = segue.destination as! ScaleDataValueChoiceController
      controller.embeddedViewToDisplay = embeddedViewToDisplay
      controller.ecoFactor = ecoFactor
    case is DecimalDataValueChoiceController:
      let controller = segue.destination as! DecimalDataValueChoiceController
      controller.embeddedViewToDisplay = embeddedViewToDisplay
      controller.ecoFactor = ecoFactor
    case is AbioticDataDetailController:
      let controller = segue.destination as! AbioticDataDetailController
      controller.ecoFactor = ecoFactor
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    let mainTabBarController = navigationController?.viewControllers.first {
      $0 is MainTabBarController
    }
    if let mainTabBarController = mainTabBarController {
      navigationController?.popToViewController(mainTabBarController, animated: true)
    }
  }
  
}
