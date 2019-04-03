//
//  Base64EncodedString.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/20/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

typealias Base64Encoded = String

extension String {
  
  func base64Encode() -> Base64Encoded? {
    return data(using: .utf8)?.base64EncodedString()
  }
  
  func base64Decode() -> Data? {
    return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
  }
  
}

extension NSAttributedString {
  
  static func base64Decode(_ base64Encoded: Base64Encoded) throws -> NSAttributedString {
    let decoded = String(data: base64Encoded.base64Decode()!, encoding: .utf8)!
    let data = decoded.data(using: .utf8)!
    return try NSAttributedString(
      data: data,
      options: [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ],
      documentAttributes: nil)
  }
  
  func base64Encode() throws -> Base64Encoded? {
    let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [
      .documentType : NSAttributedString.DocumentType.html
    ]
    let htmlData = try data(
      from: NSRange(location: 0, length: length),
      documentAttributes: documentAttributes)
    return htmlData.base64EncodedString()
  }
  
}

extension UIImage {
  
  func base64Encode() -> Base64Encoded? {
    if let jpeg = defaultJpegData() {
      return jpeg.base64EncodedString()
    }
    return nil
  }
  
  static func base64Decode(_ jpeg: Base64Encoded) -> UIImage? {
    if let data = jpeg.base64Decode() {
      return UIImage(data: data)
    }
    return nil
  }
  
}

