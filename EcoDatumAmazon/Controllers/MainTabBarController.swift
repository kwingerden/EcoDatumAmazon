//
//  MainTabBarController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/18/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
  
  @IBOutlet weak var actionBarButton: UIBarButtonItem!
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    navigationItem.leftItemsSupplementBackButton = true
  
    selectedIndex = ViewContext.shared.selectedTabIndex
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingSelectedSiteKeyPath = true
  }
  
  @IBAction func touchUpInside(_ sender: UIBarButtonItem) {
    
    switch sender {
      
    case actionBarButton:
      guard let site = ViewContext.shared.selectedSite else {
        return
      }
      guard let siteName = site.name else {
        LOG.warning("Site needs to have a name")
        return
      }
      guard let siteData = try? site.encode() else {
        LOG.warning("Failed to encode site \(site)")
        return
      }
      guard let siteDataFileUrl = try? saveToFile(siteName, siteData) else {
        LOG.warning("Failed to save site \(site)")
        return
      }
      
      let activityController = UIActivityViewController(
        activityItems: [siteDataFileUrl],
        applicationActivities: nil)
      activityController.popoverPresentationController?.barButtonItem = actionBarButton
          
      present(activityController, animated: true, completion: nil)
      
    default:
      LOG.error("Unrecognized button \(sender)")
      
    }
    
  }
  
  deinit {
    if isObservingSelectedSiteKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.selectedSiteKeyPath)
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      if let site = change?[NSKeyValueChangeKey.newKey] as? Site {
        title = site.name
      } else {
        title = nil
      }
    }
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if let selectedTabIndex = tabBar.items?.index(of: item) {
      ViewContext.shared.selectedTabIndex = selectedTabIndex
    }
  }
    
  private func saveToFile(_ name: String, _ data: Data) throws -> URL {
    let fileManager = FileManager.default
    let documentDirectory = try fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor:nil,
      create:false)
    let fileURL = documentDirectory.appendingPathComponent("\(name).site")
    try data.write(to: fileURL)
    return fileURL
  }
  
}
