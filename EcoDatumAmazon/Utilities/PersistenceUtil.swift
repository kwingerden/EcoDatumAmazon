//
//  PersistenceUtil.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import CoreData

class PersistenceUtil {
  
  static var shared: PersistenceUtil = {
    let container = NSPersistentContainer(name: "EcoDatumAmazon")
    container.loadPersistentStores {
      storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return PersistenceUtil(container)
  }()
  
  let container: NSPersistentContainer
  
  private init(_ container: NSPersistentContainer) {
    self.container = container
  }
  
  func saveContext() {
    let context = container.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let error = error as NSError
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
}
