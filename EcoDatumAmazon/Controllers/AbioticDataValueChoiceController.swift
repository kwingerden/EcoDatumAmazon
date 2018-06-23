//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AbioticDataValueChoiceController: UIViewController {
  
  var abioticDataUnitChoice: AbioticDataUnitChoice!
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: UIBarButtonSystemItem.cancel,
        target: self,
        action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
  
  @objc func cancelButtonPressed() {
    let mainTabBarController = navigationController?.viewControllers.first {
      $0 is MainTabBarController
    }
    if let mainTabBarController = mainTabBarController {
      navigationController?.popToViewController(mainTabBarController, animated: true)
    }
  }
  
}

extension AbioticDataValueChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}

extension AbioticDataValueChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
}

