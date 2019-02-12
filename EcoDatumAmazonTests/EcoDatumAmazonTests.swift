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
    
    XCTAssert(encodedTest == decodedTest)
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
    
    XCTAssert(encodedTest == decodedTest)
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
    
    XCTAssert(encodedTest == decodedTest)
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
    
    XCTAssert(encodedTest == decodedTest)
  }
  
  func test5() {
    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: "Site1", withExtension: "site"),
      let site = try? Site.load(url) else {
        XCTFail("Failed to load test resource Site1.site")
        return
    }
    
    guard let siteName = site.name else {
      XCTFail("Failed to get Site name")
      return
    }
    XCTAssert(siteName == "Site1")
    
    guard let siteEcoData = site.ecoData else {
      XCTFail("Failed to get site EcoData")
      return
    }
    XCTAssert(siteEcoData.count == 5)
    
    let sortedSiteEcoData = siteEcoData.filter {
      $0 is EcoData
      }.map {
        $0 as! EcoData
      }.sorted {
        $0.collectionDate! > $1.collectionDate!
    }
    
    let jsonDecoder = JSONDecoder.ecoDatumJSONDecoder()
    guard let jsonData1 = sortedSiteEcoData[0].jsonData,
      let ecoFactor1 = try? jsonDecoder.decode(EcoFactor.self, from: jsonData1),
      let jsonData2 = sortedSiteEcoData[1].jsonData,
      let ecoFactor2 = try? jsonDecoder.decode(EcoFactor.self, from: jsonData2),
      let jsonData3 = sortedSiteEcoData[2].jsonData,
      let ecoFactor3 = try? jsonDecoder.decode(EcoFactor.self, from: jsonData3),
      let jsonData4 = sortedSiteEcoData[3].jsonData,
      let ecoFactor4 = try? jsonDecoder.decode(EcoFactor.self, from: jsonData4),
      let jsonData5 = sortedSiteEcoData[4].jsonData,
      let ecoFactor5 = try? jsonDecoder.decode(EcoFactor.self, from: jsonData5) else {
        XCTFail("Failed to load site EcoData as JSON")
        return
    }
    
    XCTAssert(ecoFactor1.abioticEcoData != nil)
    XCTAssert(ecoFactor2.abioticEcoData != nil)
    XCTAssert(ecoFactor3.abioticEcoData != nil)
    XCTAssert(ecoFactor4.bioticEcoData != nil)
    XCTAssert(ecoFactor5.bioticEcoData != nil)
    
    let abioticEcoData1 = ecoFactor1.abioticEcoData!
    guard let abioticFactor1 = abioticEcoData1.abioticFactor,
      let dataType1 = abioticEcoData1.dataType,
      let dataUnit1 = abioticEcoData1.dataUnit,
      let dataValue1 = abioticEcoData1.dataValue else {
        XCTFail("Failed to parse Abiotic EcoData1")
        return
    }
    XCTAssert(abioticFactor1 == .Air)
    XCTAssert(dataType1 == .Air(.CarbonDioxide))
    XCTAssert(dataUnit1 == .PartsPerMillion)
    XCTAssert(dataValue1 == .DecimalDataValue("557"))
    
    let abioticEcoData2 = ecoFactor2.abioticEcoData!
    guard let abioticFactor2 = abioticEcoData2.abioticFactor,
      let dataType2 = abioticEcoData2.dataType,
      let dataUnit2 = abioticEcoData2.dataUnit,
      let dataValue2 = abioticEcoData2.dataValue else {
        XCTFail("Failed to parse Abiotic EcoData2")
        return
    }
    XCTAssert(abioticFactor2 == .Soil)
    XCTAssert(dataType2 == .Soil(.Potassium))
    XCTAssert(dataUnit2 == ._Soil_Potassium_Scale_)
    XCTAssert(dataValue2 == .SoilPotassiumScale(SoilPotassiumScale.all[1]))
    
    let abioticEcoData3 = ecoFactor3.abioticEcoData!
    guard let af3 = abioticEcoData3.abioticFactor,
      let dataType3 = abioticEcoData3.dataType,
      let dataUnit3 = abioticEcoData3.dataUnit,
      let dataValue3 = abioticEcoData3.dataValue else {
        XCTFail("Failed to parse Abiotic EcoData3")
        return
    }
    XCTAssert(af3 == .Air)
    XCTAssert(dataType3 == .Air(.RelativeHumidity))
    XCTAssert(dataUnit3 == .Percent)
    XCTAssert(dataValue3 == .DecimalDataValue("56"))
    
  }
  
}
