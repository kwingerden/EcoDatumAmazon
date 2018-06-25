//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AbioticFactorChoiceController: UIViewController {

  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var selectedAbioticFactor: AbioticFactor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch ecoFactor! {
    case .Abiotic:
      title = "Abiotic Factor Choice"
    default:
      LOG.error("Unexpected EcoFactor: \(ecoFactor)")
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is AbioticDataTypeChoiceController:
      let controller = segue.destination as! AbioticDataTypeChoiceController
      controller.ecoFactor = ecoFactor.new(selectedAbioticFactor)
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
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

extension AbioticFactorChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedAbioticFactor = AbioticFactor.all[indexPath.row]
    performSegue(withIdentifier: "abioticDataTypeChoice", sender: nil)
  }
  
}

extension AbioticFactorChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return AbioticFactor.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = AbioticFactor.all[indexPath.row].rawValue
    return cell
  }
  
}
