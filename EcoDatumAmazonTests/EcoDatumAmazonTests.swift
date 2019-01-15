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
  
  struct Test: Codable {
    let dataType: EcoFactor
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
    
    let test = Test(dataType: ecoFactor)
    let encoder = JSONEncoder()
    let data = try encoder.encode(test)
    let string = String(data: data, encoding: .utf8)!
    print(string)
  }
  
  func test2() throws {
    let ecoFactor = EcoFactor(
      collectionDate: Date(),
      ecoData: EcoFactor.EcoData.Biotic(
        BioticEcoData(
          bioticFactor: BioticFactor.Plant,
          dataType: BioticDataType.Plant(.Algae),
          dataUnit: DataUnit.PartsPerMillion,
          dataValue: DataValue.DecimalDataValue("34.3"))))
    
    let test = Test(dataType: ecoFactor)
    let encoder = JSONEncoder()
    let data = try encoder.encode(test)
    let string = String(data: data, encoding: .utf8)!
    print(string)
  }
  
  func test3() throws {
    let ecoFactor = EcoFactor(
      collectionDate: Date(),
      ecoData: EcoFactor.EcoData.Biotic(
        BioticEcoData(
          bioticFactor: BioticFactor.Animal,
          dataType: BioticDataType.Animal(AnimalDataType.Invertebrate(.Arthropod)),
          dataUnit: DataUnit.PartsPerMillion,
          dataValue: DataValue.DecimalDataValue("34.3"))))
    
    let test = Test(dataType: ecoFactor)
    let encoder = JSONEncoder()
    let data = try encoder.encode(test)
    let string = String(data: data, encoding: .utf8)!
    print(string)
  }
  
}
