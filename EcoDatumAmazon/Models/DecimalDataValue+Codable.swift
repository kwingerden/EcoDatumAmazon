//
//  DecimalDataValue.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation

struct DecimalDataValue: Codable, CustomStringConvertible {
  
  let sign: NumberSign
  let number: String
  let decimalPoint: Bool
  let fraction: String?
  
  var description: String {
    return toString()
  }
  
  var doubleValue: Double {
    return Double(toString())!
  }
  
  init(sign: NumberSign = .positive,
       number: String = "0",
       decimalPoint: Bool = false,
       fraction: String? = nil) {
    self.sign = sign
    self.number = number
    self.decimalPoint = decimalPoint
    self.fraction = fraction
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    sign = try container.decode(NumberSign.self, forKey: .sign)
    number = try container.decode(String.self, forKey: .number)
    decimalPoint = try container.decode(Bool.self, forKey: .decimalPoint)
    fraction = try container.decodeIfPresent(String.self, forKey: .fraction)
  }
  
  enum CodingKeys: String, CodingKey {
    case sign
    case number
    case decimalPoint
    case fraction
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(sign, forKey: .sign)
    try container.encode(number, forKey: .number)
    try container.encode(decimalPoint, forKey: .decimalPoint)
    try container.encode(fraction, forKey: .fraction)
  }
  
  func toggleSign() -> DecimalDataValue {
    
    if doubleValue == 0 {
      
      return DecimalDataValue(
        sign: .positive,
        number: number,
        decimalPoint: decimalPoint,
        fraction: fraction)
      
    } else {
      
      return DecimalDataValue(
        sign: sign == .positive ? .negative : .positive,
        number: number,
        decimalPoint: decimalPoint,
        fraction: fraction)
      
    }
    
  }
  
  func addDecimalPoint() -> DecimalDataValue {
    
    if decimalPoint {
      
      return self
      
    } else {
      
      return DecimalDataValue(
        sign: sign,
        number: number,
        decimalPoint: true,
        fraction: nil)
      
    }
    
  }
  
  func addDigit(_ digit: Int) -> DecimalDataValue {
    
    if let fraction = fraction {
      
      return DecimalDataValue(
        sign: sign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: "\(fraction)\(digit)")
      
    } else if decimalPoint {
      
      return DecimalDataValue(
        sign: sign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: "\(digit)")
      
    } else {
      
      var newNumber = "\(number)\(digit)"
      if doubleValue == 0 {
        newNumber = "\(digit)"
      }
      return DecimalDataValue(
        sign: sign,
        number: newNumber,
        decimalPoint: false,
        fraction: nil)
      
    }
    
  }
  
  func deleteDigit() -> DecimalDataValue {
    
    var newSign = sign
    if doubleValue == 0 {
      newSign = .positive
    }
    
    if let fraction = fraction {
      
      var newFraction = fraction
      newFraction.removeLast()
      return DecimalDataValue(
        sign: newSign,
        number: number,
        decimalPoint: decimalPoint,
        fraction: newFraction.count == 0 ? nil : newFraction)
      
    } else if decimalPoint {
      
      return DecimalDataValue(
        sign: newSign,
        number: number,
        decimalPoint: false,
        fraction: nil)
      
    } else {
      
      var newNumber = number
      newNumber.removeLast()
      
      if newNumber.count == 0 {
        newSign = .positive
      } else if let intNumber = Int(newNumber),
        intNumber == 0 {
        newSign = .positive
      }
      
      return DecimalDataValue(
        sign: newSign,
        number: newNumber.count == 0 ? "0" : newNumber,
        decimalPoint: false,
        fraction: nil)
      
    }
    
  }
  
  static func ==(_ lhs: DecimalDataValue, _ rhs: DecimalDataValue) -> Bool {
    return lhs.sign == rhs.sign &&
      lhs.number == rhs.number &&
      lhs.decimalPoint == rhs.decimalPoint &&
      lhs.fraction == rhs.fraction
  }
  
  private func toString() -> String {
    
    let sign = self.sign == .positive ? "" : "-"
    let decimalPoint = self.decimalPoint ? "." : ""
    
    if let fraction = fraction {
      return "\(sign)\(number).\(fraction)"
    } else if Int(number) == 0 {
      return "0\(decimalPoint)"
    } else {
      return "\(sign)\(number)\(decimalPoint)"
    }
    
  }
  
}
