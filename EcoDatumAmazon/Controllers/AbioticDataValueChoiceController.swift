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
  
  var ecoFactor: EcoFactor!
  
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
      scaleDataValueView.isHidden = false
      soilTextureDataValueView.isHidden = true
      decimalDataValueView.isHidden = true
      
    case ._Soil_Texture_Scale_:
      title = "Enter Values"
      scaleDataValueView.isHidden = true
      soilTextureDataValueView.isHidden = false
      decimalDataValueView.isHidden = true
      
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
      scaleDataValueView.isHidden = true
      soilTextureDataValueView.isHidden = true
      decimalDataValueView.isHidden = false
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is SoilTextureDataValueChoiceController:
      let controller = segue.destination as! SoilTextureDataValueChoiceController
      controller.ecoFactor = ecoFactor
    case is ScaleDataValueChoiceController:
      let controller = segue.destination as! ScaleDataValueChoiceController
      controller.ecoFactor = ecoFactor
    case is DecimalDataValueChoiceController:
      let controller = segue.destination as! DecimalDataValueChoiceController
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
