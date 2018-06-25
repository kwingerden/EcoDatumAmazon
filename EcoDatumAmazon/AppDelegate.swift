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
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
    IQKeyboardManager.shared.enable = true
    
    let console = ConsoleDestination()
    LOG.addDestination(console)
    
    return true
  
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
                   options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    guard url.pathExtension.lowercased() == "site" else {
      return false
    }
    
    do {
      let site = try Site.load(url)
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

