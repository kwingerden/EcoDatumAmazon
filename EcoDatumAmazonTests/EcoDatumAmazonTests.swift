//
//  EcoDatumAmazonTests.swift
//  EcoDatumAmazonTests
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import XCTest
@testable import EcoDatumAmazon

class EcoDatumAmazonTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  struct Test: Codable, Equatable {
    let dataType: EcoFactor
    
    static func ==(lhs: Test, rhs: Test) -> Bool {
      return lhs.dataType == rhs.dataType
    }
  }
  
  func test1() throws {
    let ecoFactor = EcoFactor(
      collectionDate: Date(),
      ecoData: EcoFactor.EcoData.Abiotic(
        AbioticEcoData(
          abioticFactor: AbioticFactor.Air,
          dataType: AbioticDataType.Air(.CarbonDioxide),
          dataUnit: DataUnit.PartsPerMillion,
          dataValue: DataValue.DecimalDataValue("34.3"))))
    
    let encodedTest = Test(dataType: ecoFactor)
    let encoder = JSONEncoder.ecoDatumJSONEncoder(.prettyPrinted)
    let encodedData = try encoder.encode(encodedTest)
    let encodedString = String(data: encodedData, encoding: .utf8)!
    print(encodedString)
    
    let decodedData = encodedString.data(using: .utf8)!
    let decoder = JSONDecoder.ecoDatumJSONDecoder()
    let decodedTest = try decoder.decode(Test.self, from: decodedData)
    
    assert(encodedTest == decodedTest)
  }
  
  func test2() throws {
    let ecoFactor = EcoFactor(
      collectionDate: Date(),
      ecoData: EcoFactor.EcoData.Biotic(
        BioticEcoData(
          bioticFactor: BioticFactor.Plant,
          dataType: BioticDataType.Plant(.Algae),
          dataUnit: DataUnit.KilogramsOfCarbon,
          dataValue: DataValue.DecimalDataValue("34.3"))))
    
    let encodedTest = Test(dataType: ecoFactor)
    let encoder = JSONEncoder.ecoDatumJSONEncoder(.prettyPrinted)
    let encodedData = try encoder.encode(encodedTest)
    let encodedString = String(data: encodedData, encoding: .utf8)!
    print(encodedString)
    
    let decodedData = encodedString.data(using: .utf8)!
    let decoder = JSONDecoder.ecoDatumJSONDecoder()
    let decodedTest = try decoder.decode(Test.self, from: decodedData)
    
    assert(encodedTest == decodedTest)
  }
  
  func test3() throws {
    let animalData = AnimalData(animalFactor: .Invertebrate, animalDataType: .Invertebrate(.Arthropod))
    let ecoFactor = EcoFactor(
      collectionDate: Date(),
      ecoData: EcoFactor.EcoData.Biotic(
        BioticEcoData(
          bioticFactor: BioticFactor.Animal,
          dataType: BioticDataType.Animal(animalData),
          dataUnit: DataUnit.PartsPerMillion,
          dataValue: DataValue.DecimalDataValue("34.3"))))
    
    let encodedTest = Test(dataType: ecoFactor)
    let encoder = JSONEncoder.ecoDatumJSONEncoder(.prettyPrinted)
    let encodedData = try encoder.encode(encodedTest)
    let encodedString = String(data: encodedData, encoding: .utf8)!
    print(encodedString)
    
    let decodedData = encodedString.data(using: .utf8)!
    let decoder = JSONDecoder.ecoDatumJSONDecoder()
    let decodedTest = try decoder.decode(Test.self, from: decodedData)
    
    assert(encodedTest == decodedTest)
  }
 
  func test4() throws {
    let animalData = AnimalData(animalFactor: .Vertebrate, animalDataType: .Vertebrate(.Amphibian))
    let ecoFactor = EcoFactor(
      collectionDate: Date(),
      ecoData: EcoFactor.EcoData.Biotic(
        BioticEcoData(
          bioticFactor: BioticFactor.Animal,
          dataType: BioticDataType.Animal(animalData),
          dataUnit: nil,
          dataValue: nil)))
    
    let encodedTest = Test(dataType: ecoFactor)
    let encoder = JSONEncoder.ecoDatumJSONEncoder(.prettyPrinted)
    let encodedData = try encoder.encode(encodedTest)
    let encodedString = String(data: encodedData, encoding: .utf8)!
    print(encodedString)
    
    let decodedData = encodedString.data(using: .utf8)!
    let decoder = JSONDecoder.ecoDatumJSONDecoder()
    let decodedTest = try decoder.decode(Test.self, from: decodedData)
    
    assert(encodedTest == decodedTest)
  }
  
}
