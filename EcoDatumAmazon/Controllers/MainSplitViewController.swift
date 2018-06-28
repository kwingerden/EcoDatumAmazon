//
//  MainSplitViewController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class MainSplitViewController: UISplitViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    preferredDisplayMode = .allVisible
  }
  
}

extension MainSplitViewController: UISplitViewControllerDelegate {

  func splitViewController(
    _ splitViewController: UISplitViewController,
    collapseSecondary secondaryViewController: UIViewController,
    onto primaryViewController: UIViewController) -> Bool {
    // Return true to prevent UIKit from applying its default behavior
    return true
  }

}
