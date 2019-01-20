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
    let encoder = JSONEncoder.ecoDatumJSONEncoder()
    let jsonData = try encoder.encode(ecoFactor)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
      LOG.debug(jsonString)
    }
    guard let collectionDate = ecoFactor.collectionDate,
      let abioticEcoData = ecoFactor.abioticEcoData,
      let abioticFactor = abioticEcoData.abioticFactor?.rawValue else {
      LOG.error("Failed to create new EcoFactor because necessary data not available.")
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
  
  func save() throws {
    try PersistenceUtil.shared.saveContext()
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
}
