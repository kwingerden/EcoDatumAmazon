//
//  SiteDataController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class SiteTableController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func touchUpInside(_ sender: UIBarButtonItem) {
    
    if sender == addBarButton {
      let site = Site.newSite(name: "Test", latitude: 1.23, longitude: 34.33)
      PersistenceUtil.shared.saveContext()
    }
    
  }
  
}
