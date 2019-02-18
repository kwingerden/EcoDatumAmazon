//
//  AppDelegate.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import IQKeyboardManagerSwift
import SwiftyBeaver
import UIKit

let LOG = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
    IQKeyboardManager.shared.enable = true
    
    let console = ConsoleDestination()
    LOG.addDestination(console)
    
    do {
      try updateSites()
    } catch let error as NSError {
      LOG.error("\(error), \(error.userInfo)")
    }
    
    return true
  }
  
  private func updateSites() throws {
    let fetchedResultsController = try Site.fetch()
    if let sites = fetchedResultsController.fetchedObjects, sites.count > 0 {
      try sites.forEach {
        try updateSite($0)
      }
    }
  }
  
  private func updateSite(_ site: Site) throws {
    if let photo = site.photo {
      if let ecoData = site.ecoData,
        ecoData.count > 0 {
        let orderedEcoData = ecoData.map {
          $0 as! EcoData
          }.sorted {
            (lhs: EcoData, rhs: EcoData) in
            if lhs.collectionDate == nil {
              return false
            }
            if rhs.collectionDate == nil {
              return false
            }
            return lhs.collectionDate! >= rhs.collectionDate! ? true : false
        }
        let newSitePhoto = try SitePhoto.create(
          site: site,
          date: orderedEcoData[0].collectionDate,
          photo: photo)
        try newSitePhoto.save()
        
        site.photo = nil
        try site.save()
      }
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
    do {
      try PersistenceUtil.shared.saveContext()
    } catch let error as NSError {
      LOG.error("\(error), \(error.userInfo)")
    }
  }
  
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    guard url.pathExtension.lowercased() == "site" else {
      return false
    }
    
    do {
      let site = try Site.load(url)
      try updateSite(site)
      try PersistenceUtil.shared.saveContext()
      ViewContext.shared.selectedSite = site
    } catch {
      LOG.error("Failed to load site file: \(error)")
    }
    
    do {
      try FileManager.default.removeItem(at: url)
    } catch {
      LOG.warning("Failed to delete site file: \(url), \(error)")
    }
      
    return true
  }
  
}

