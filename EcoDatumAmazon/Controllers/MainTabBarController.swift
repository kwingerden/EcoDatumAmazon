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
  
  static var shared: MainTabBarController?
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  private var isObservingIsNewSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MainTabBarController.shared = self
    
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    navigationItem.leftItemsSupplementBackButton = true
    
    selectedIndex = ViewContext.shared.selectedTabIndex
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingSelectedSiteKeyPath = true
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.isNewSiteKeyPath,
      options: [.new],
      context: nil)
    isObservingIsNewSiteKeyPath = true
  }
  
  deinit {
    if isObservingSelectedSiteKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.selectedSiteKeyPath)
    }
    if isObservingIsNewSiteKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.isNewSiteKeyPath)
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
    } else if let keyPath = keyPath, keyPath == ViewContext.isNewSiteKeyPath {
      selectedIndex = 0
    }
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if let selectedTabIndex = tabBar.items?.index(of: item) {
      ViewContext.shared.selectedTabIndex = selectedTabIndex
    }
  }
    
}
