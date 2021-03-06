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

let SITE_NAME_PLACEHOLDER = "<Site Name>"

extension Site {
  
  static func create(
    id: UUID? = nil,
    name: String? = nil,
    latitude: Decimal? = nil,
    longitude: Decimal? = nil,
    coordinateAccuracy: Decimal? = nil,
    altitude: Decimal? = nil,
    altitudeAccuracy: Decimal? = nil,
    photo: Data? = nil,
    notes: NSAttributedString? = nil,
    place: String? = nil,
    street: String? = nil,
    city: String? = nil,
    state: String? = nil,
    postalCode: String? = nil,
    country: String? = nil) throws -> Site {
    let entity = NSEntityDescription.entity(
      forEntityName: "Site",
      in: PersistenceUtil.shared.container.viewContext)!
    
    let site = Site(
      entity: entity,
      insertInto: PersistenceUtil.shared.container.viewContext)
    
    if let id = id {
      site.id = id
    } else {
      site.id = UUID()
    }
    
    if let name = name {
      site.name = name
    } else {
      site.name = SITE_NAME_PLACEHOLDER
    }
    
    if let latitude = latitude {
      site.latitude = NSDecimalNumber(decimal: latitude)
    } else {
      site.latitude = nil
    }
    
    if let longitude = longitude {
      site.longitude = NSDecimalNumber(decimal: longitude)
    } else {
      site.longitude = nil
    }
    
    if let coordinateAccuracy = coordinateAccuracy {
      site.coordinateAccuracy = NSDecimalNumber(decimal: coordinateAccuracy)
    } else {
      site.coordinateAccuracy = nil
    }
    
    if let altitude = altitude {
      site.altitude = NSDecimalNumber(decimal: altitude)
    } else {
      site.altitude = nil
    }
    
    if let altitudeAccuracy = altitudeAccuracy {
      site.altitudeAccuracy = NSDecimalNumber(decimal: altitudeAccuracy)
    } else {
      site.altitudeAccuracy = nil
    }
    
    site.photo = photo
    site.notes = notes
    site.place = place
    site.street = street
    site.city = city
    site.state = state
    site.postalCode = postalCode
    site.country = country
    
    return site
  }
  
  static func fetch() throws -> NSFetchedResultsController<Site> {
    let fetchRequest = Site.fetchRequest() as NSFetchRequest<Site>
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: #keyPath(Site.name), ascending: true)
    ]
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: PersistenceUtil.shared.container.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    try fetchedResultsController.performFetch()
    return fetchedResultsController
  }
  
  func save() throws {
    try PersistenceUtil.shared.saveContext()
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
  func encode() throws -> Data {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return try encoder.encode(SiteCodable(site: self))
  }
  
  static func decode(_ data: Data) throws -> Site {
    let decoder = JSONDecoder()
    let formatter = ISO8601DateFormatter()
    
    // A custom decoder function is needed since some of the older data was collected using date's
    // default decoding strategy. The standard is now to use ISO 8601 date format. To accomodate
    // this, test to see of the date is encoded in either the ISO 8601 date format or date's
    // default encoding strategy.
    func customDecoder(_ decoder: Decoder) throws -> Date {
      var date: Date?
      switch decoder.codingPath.last {
      // Right now, the collectionDate is the only date that needs to be handled.
      case EcoFactor.CodingKeys.collectionDate?:
        let container = try decoder.singleValueContainer()
        do {
          let iso8601FormattedString = try container.decode(String.self)
          date = formatter.date(from: iso8601FormattedString)
        } catch {
          let value = try container.decode(Double.self)
          date = Date(timeIntervalSinceReferenceDate: value)
        }
      default:
        break
      }
      if let date = date {
        return date
      } else {
        let errorContext = DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Failed to convert date")
        throw DecodingError.typeMismatch(Date.self, errorContext)
      }
    }
    
    decoder.dateDecodingStrategy = .custom(customDecoder)
    return try decoder.decode(SiteCodable.self, from: data).site
  }
  
  static func load(_ fileUrl: URL) throws -> Site {
    let data = try Data(contentsOf: fileUrl)
    return try decode(data)
  }
  
}

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
    case ecoFactors
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
    
    let ecoFactors = try container.decodeIfPresent(
      [EcoFactor].self,
      forKey: CodingKeys.ecoFactors)
    if let ecoFactors = ecoFactors {
      try ecoFactors.forEach {
        (ecoFactor: EcoFactor) in
        if ecoFactor.abioticEcoData != nil,
          let abioticData = try AbioticData.create(ecoFactor) {
          site.addToEcoData(abioticData)
        } else if ecoFactor.bioticEcoData != nil,
          let bioticData = try BioticData.create(ecoFactor) {
            site.addToEcoData(bioticData)
        } else {
          LOG.error("Failed to load EcoFactor: \(ecoFactor)")
        }
      }
      try site.save()
    }
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
    
    if let ecoData = site.ecoData {
      let jsonDecoder = JSONDecoder()
      let ecoFactors = try ecoData.map {
        $0 as! EcoData
        }.map {
          (ecoData: EcoData) -> EcoFactor in
          let ecoFactor = try jsonDecoder.decode(
            EcoFactor.self,
            from: ecoData.jsonData!)
          return ecoFactor
      }
      try container.encode(ecoFactors, forKey: CodingKeys.ecoFactors)
    }
  }
  
}
