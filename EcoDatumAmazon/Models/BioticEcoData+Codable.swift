//
//  BioticEcoData.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

struct BioticEcoData: Codable {

  let bioticFactor: BioticFactor?
  let dataType: BioticDataType?
  let dataUnit: DataUnit?
  let dataValue: DataValue?
  let image: UIImage?
  let notes: NSAttributedString?

  init(bioticFactor: BioticFactor? = nil,
       dataType: BioticDataType? = nil,
       dataUnit: DataUnit? = nil,
       dataValue: DataValue? = nil,
       image: UIImage? = nil,
       notes: NSAttributedString? = nil) {
    self.bioticFactor = bioticFactor
    self.dataType = dataType
    self.dataUnit = dataUnit
    self.dataValue = dataValue
    self.image = image
    self.notes = notes
  }

  enum CodingKeys: String, CodingKey {
    case bioticFactor
    case dataType
    case dataUnit
    case dataValue
    case image
    case notes
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    bioticFactor = try container.decodeIfPresent(BioticFactor.self, forKey: .bioticFactor)

    switch bioticFactor {
    case .Animal?:
      dataType = BioticDataType.Animal(try container.decode(AnimalData.self, forKey: .dataType))
    case .Fungi?:
      dataType = BioticDataType.Fungi(try container.decode(FungiDataType.self, forKey: .dataType))
    case .Plant?:
      dataType = BioticDataType.Plant(try container.decode(PlantDataType.self, forKey: .dataType))
    default: fatalError()
    }

    dataUnit = try container.decodeIfPresent(DataUnit.self, forKey: .dataUnit)

    if let dataValue = try container.decodeIfPresent(String.self, forKey: .dataValue) {
      self.dataValue = DataValue.DecimalDataValue(dataValue)
    } else {
      dataValue = nil
    }

    if let imageBase64Encoded = try container.decodeIfPresent(Base64Encoded.self, forKey: .image) {
      image = UIImage.base64Decode(imageBase64Encoded)
    } else {
      image = nil
    }

    if let notesBase64Encoded = try container.decodeIfPresent(Base64Encoded.self, forKey: .notes) {
      notes = try NSAttributedString.base64Decode(notesBase64Encoded)
    } else {
      notes = nil
    }
    
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(bioticFactor, forKey: .bioticFactor)

    switch dataType {
    case .Animal(let animalDataType)?:
      try container.encode(animalDataType, forKey: .dataType)
    case .Fungi(let fungiDataType)?:
      try container.encode(fungiDataType, forKey: .dataType)
    case .Plant(let plantDataType)?:
      try container.encode(plantDataType, forKey: .dataType)
    default:
      fatalError()
    }

    try container.encodeIfPresent(dataUnit, forKey: .dataUnit)

    switch dataValue {

    case .DecimalDataValue(let decimalDataValue)?:
      try container.encode(decimalDataValue, forKey: .dataValue)

    default:
      break // Do nothing

    }

    try container.encodeIfPresent(image?.base64Encode(), forKey: .image)

    try container.encodeIfPresent(notes?.base64Encode(), forKey: .notes)

  }

  func new(_ bioticFactor: BioticFactor?) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue,
      image: image,
      notes: notes)
  }

  func new(_ dataType: BioticDataType) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue,
      image: image,
      notes: notes)
  }

  func new(_ dataUnit: DataUnit) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue,
      image: image,
      notes: notes)
  }

  func new(_ dataValue: DataValue?) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue,
      image: image,
      notes: notes)
  }

  func new(_ image: UIImage?) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue,
      image: image,
      notes: notes)
  }

  func new(_ notes: NSAttributedString) -> BioticEcoData {
    return BioticEcoData(
      bioticFactor: bioticFactor,
      dataType: dataType,
      dataUnit: dataUnit,
      dataValue: dataValue,
      image: image,
      notes: notes)
  }

}
