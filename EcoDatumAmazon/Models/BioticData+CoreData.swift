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

extension BioticData {
  
  static func create(_ ecoFactor: EcoFactor) throws -> BioticData? {
    let encoder = JSONEncoder.ecoDatumJSONEncoder()
    let jsonData = try encoder.encode(ecoFactor)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
      if jsonString.count > 500 {
        LOG.debug(jsonString[..<jsonString.index(jsonString.startIndex, offsetBy: 500)])
      } else {
        LOG.debug(jsonString)
      }
    }
    guard let collectionDate = ecoFactor.collectionDate,
      let bioticEcoData = ecoFactor.bioticEcoData,
      let bioticFactor = bioticEcoData.bioticFactor?.rawValue else {
        LOG.error("Failed to create new EcoFactor because necessary data not available.")
        return nil
    }
    
    let entity = NSEntityDescription.entity(
      forEntityName: "BioticData",
      in: PersistenceUtil.shared.container.viewContext)!
    
    let bioticData = BioticData(
      entity: entity,
      insertInto: PersistenceUtil.shared.container.viewContext)
    
    bioticData.id = UUID()
    bioticData.ecoFactor = ecoFactor.description
    bioticData.collectionDate = collectionDate
    bioticData.bioticFactor = bioticFactor
    bioticData.jsonData = jsonData
    
    return bioticData
  }
  
  static func fetch() throws -> NSFetchedResultsController<BioticData> {
    let fetchRequest = BioticData.fetchRequest() as NSFetchRequest<BioticData>
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(
        key: #keyPath(BioticData.collectionDate),
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
  
  func save() throws {
    try PersistenceUtil.shared.saveContext()
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
}
