//
//  ImageUtil.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/17/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  func defaultJpegData() -> Data? {
    return  jpegData(compressionQuality: 0.5)
  }
  
}
