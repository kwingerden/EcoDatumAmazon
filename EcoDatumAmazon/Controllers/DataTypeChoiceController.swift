//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class DataTypeChoiceController: UIViewController {
  
  var abioticFactor: AbioticFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  var selectedAbioticDataType: AbioticDataType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(abioticFactor.rawValue) Data Type Choice"
    
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

extension DataTypeChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}

extension DataTypeChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch abioticFactor! {
    case .Air:
      return AirDataType.all.count
    case .Soil:
      return SoilDataType.all.count
    case .Water:
      return WaterDataType.all.count
    }
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    switch abioticFactor! {
    case .Air:
      cell.textLabel?.text = AirDataType.all[indexPath.row].rawValue
    case .Soil:
      cell.textLabel?.text = SoilDataType.all[indexPath.row].rawValue
    case .Water:
      cell.textLabel?.text = WaterDataType.all[indexPath.row].rawValue
    }
    return cell
  }
  
}
