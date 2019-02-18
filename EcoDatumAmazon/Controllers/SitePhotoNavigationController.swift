//
//  SitePhotosNavigationController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/17/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

import UIKit

class SitePhotoNavigationController: UINavigationController {
    
  var photo: SitePhoto!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewController = topViewController as! SitePhotoDetailController
    viewController.photo = photo
  }
  
}
