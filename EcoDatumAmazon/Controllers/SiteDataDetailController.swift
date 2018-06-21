//
//  SiteDataController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/20/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class SiteDataDetailController: UIViewController {
  
  var abioticData: AbioticData!
  
  @IBOutlet weak var testLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Abiotic Data"
    testLabel.text = abioticData.collectionDate?.description ?? "??"
  }
  
}

