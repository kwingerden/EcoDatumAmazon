//
//  Site.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation

let SITE_NAME_PLACEHOLDER = "<Site Name>"

extension Site {
  
  static func create(id: UUID? = nil,
                     name: String? = nil) throws -> Site {
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
  
  func save() throws -> Site {
    try PersistenceUtil.shared.saveContext()
    return self
  }
  
  func delete() throws {
    try PersistenceUtil.shared.delete(self)
  }
  
  func encode() throws -> Data {
    return try JSONEncoder().encode(SiteCodable(site: self))
  }
  
  static func decode(_ data: Data) throws -> Site {
    return try JSONDecoder().decode(SiteCodable.self, from: data).site
  }
  
}

fileprivate class SiteCodable: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
  }
  
  var id: UUID? {
    return site.id
  }
  
  var name: String? {
    return site.name
  }
  
  let site: Site
  
  init(site: Site) {
    self.site = site
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decodeIfPresent(UUID.self, forKey: CodingKeys.id)
    let name = try container.decodeIfPresent(String.self, forKey: CodingKeys.name)
    site = try Site.create(id: id, name: name)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(site.id, forKey: CodingKeys.id)
    try container.encodeIfPresent(site.name, forKey: CodingKeys.name)
  }
  
}
