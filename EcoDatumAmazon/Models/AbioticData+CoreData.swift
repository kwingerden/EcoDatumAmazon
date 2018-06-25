//
//  Site.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import UIKit

extension AbioticData {
  
  static func create(_ ecoFactor: EcoFactor) throws -> AbioticData? {
    let jsonData = try JSONEncoder().encode(ecoFactor)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
      LOG.debug(jsonString)
    }
    guard let abioticEcoData = ecoFactor.abioticEcoData,
      let abioticFactor = abioticEcoData.abioticFactor?.rawValue,
      let collectionDate = abioticEcoData.collectionDate else {
      return nil
    }
    
    let entity = NSEntityDescription.entity(
      forEntityName: "AbioticData",
      in: PersistenceUtil.shared.container.viewContext)!
    
    let abioticData = AbioticData(
      entity: entity,
      insertInto: PersistenceUtil.shared.container.viewContext)
    
    abioticData.id = UUID()
    abioticData.ecoFactor = ecoFactor.description
    abioticData.collectionDate = collectionDate
    abioticData.abioticFactor = abioticFactor
    abioticData.jsonData = jsonData
 
    return abioticData
  }
  
  static func fetch() throws -> NSFetchedResultsController<AbioticData> {
    let fetchRequest = AbioticData.fetchRequest() as NSFetchRequest<AbioticData>
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(
        key: #keyPath(AbioticData.collectionDate),
        ascending: true)
    ]
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceUtil.shared.container.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    try fetchedResultsController.performFetch()
    return fetchedResultsController
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
  /*
  func encode() throws -> Data {
    return try JSONEncoder().encode(SiteCodable(site: self))
  }
  
  static func decode(_ data: Data) throws -> Site {
    return try JSONDecoder().decode(SiteCodable.self, from: data).site
  }
  
  static func load(_ fileUrl: URL) throws -> Site {
    let data = try Data(contentsOf: fileUrl)
    return try decode(data)
  }
 */
  
}

/*
fileprivate class SiteCodable: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case latitude
    case longitude
    case coordinateAccuracy
    case altitude
    case altitudeAccuracy
    case notes
    case photo
    case place
    case street
    case city
    case state
    case postalCode
    case country
  }
  
  let site: Site
  
  init(site: Site) {
    self.site = site
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let id = try container.decodeIfPresent(
      UUID.self,
      forKey: CodingKeys.id)
    
    let name = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.name)
    
    let latitude = try container.decodeIfPresent(
      Decimal.self,
      forKey: CodingKeys.latitude)
    
    let longitude = try container.decodeIfPresent(
      Decimal.self,
      forKey: CodingKeys.longitude)
    
    let coordinateAccuracy = try container.decodeIfPresent(
      Decimal.self,
      forKey: CodingKeys.coordinateAccuracy)
    
    let altitude = try container.decodeIfPresent(
      Decimal.self,
      forKey: CodingKeys.altitude)
    
    let altitudeAccuracy = try container.decodeIfPresent(
      Decimal.self,
      forKey: CodingKeys.altitudeAccuracy)
    
    var notes: NSAttributedString?
    if let notesBase64Encoded = try container.decodeIfPresent(
      Base64Encoded.self,
      forKey: CodingKeys.notes) {
      notes = try NSAttributedString.base64Decode(notesBase64Encoded)
    }
    
    var photo: Data?
    if let photoBase64Encoded = try container.decodeIfPresent(
      Base64Encoded.self,
      forKey: CodingKeys.photo) {
      photo = photoBase64Encoded.base64Decode()
    }
    
    let place = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.place)
    
    let street = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.street)
    
    let city = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.city)
    
    let state = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.state)
    
    let postalCode = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.postalCode)
    
    let country = try container.decodeIfPresent(
      String.self,
      forKey: CodingKeys.country)
    
    site = try Site.create(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      coordinateAccuracy: coordinateAccuracy,
      altitude: altitude,
      altitudeAccuracy: altitudeAccuracy,
      photo: photo,
      notes: notes,
      place: place,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encodeIfPresent(site.id, forKey: CodingKeys.id)
    try container.encodeIfPresent(site.name, forKey: CodingKeys.name)
    
    if let latitude = site.latitude {
      try container.encodeIfPresent(
        latitude.decimalValue,
        forKey: CodingKeys.latitude)
    }
    
    if let longitude = site.longitude {
      try container.encodeIfPresent(
        longitude.decimalValue,
        forKey: CodingKeys.longitude)
    }
    
    if let coordinateAccuracy = site.coordinateAccuracy {
      try container.encodeIfPresent(
        coordinateAccuracy.decimalValue,
        forKey: CodingKeys.coordinateAccuracy)
    }
    
    if let altitude = site.altitude {
      try container.encodeIfPresent(
        altitude.decimalValue,
        forKey: CodingKeys.altitude)
    }
    
    if let altitudeAccuracy = site.altitudeAccuracy {
      try container.encodeIfPresent(
        altitudeAccuracy.decimalValue,
        forKey: CodingKeys.altitudeAccuracy)
    }
    
    try container.encodeIfPresent(
      site.photo?.base64EncodedString(),
      forKey: CodingKeys.photo)
    
    if let notes = site.notes as? NSAttributedString,
      let base64EncodedNotes = try? notes.base64Encode() {
      try container.encodeIfPresent(
        base64EncodedNotes,
        forKey: CodingKeys.notes)
    }
    
    try container.encodeIfPresent(site.place, forKey: CodingKeys.place)
    try container.encodeIfPresent(site.street, forKey: CodingKeys.street)
    try container.encodeIfPresent(site.city, forKey: CodingKeys.city)
    try container.encodeIfPresent(site.state, forKey: CodingKeys.state)
    try container.encodeIfPresent(site.postalCode, forKey: CodingKeys.postalCode)
    try container.encodeIfPresent(site.country, forKey: CodingKeys.country)
  }
  
}
 */
