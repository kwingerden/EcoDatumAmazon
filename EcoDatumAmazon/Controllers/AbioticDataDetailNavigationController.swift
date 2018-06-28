//
//  AbioticDataDetailNavigationController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/28/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AbioticDataDetailNavigationController: UINavigationController {
  
  var site: Site!
  
  var abioticData: AbioticData!
  
  var ecoFactor: EcoFactor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewController = topViewController as! AbioticDataDetailController
    viewController.site = site
    viewController.abioticData = abioticData
    viewController.ecoFactor = ecoFactor
  }
  
}
