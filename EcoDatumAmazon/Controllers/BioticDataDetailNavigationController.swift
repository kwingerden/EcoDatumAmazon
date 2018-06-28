//
//  AbioticDataDetailNavigationController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/28/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class BioticDataDetailNavigationController: UINavigationController {
  
  var site: Site!
  
  var bioticData: BioticData!
  
  var ecoFactor: EcoFactor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewController = topViewController as! BioticDataDetailController
    viewController.site = site
    viewController.bioticData = bioticData
    viewController.ecoFactor = ecoFactor
  }
  
}
