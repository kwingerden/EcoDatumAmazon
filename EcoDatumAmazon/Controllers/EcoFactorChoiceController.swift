//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class EcoFactorChoiceController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var selectedEcoFactor: EcoFactor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Eco-Factor Choice"
    
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
    case is AbioticFactorChoiceController:
      (segue.destination as! AbioticFactorChoiceController).ecoFactor = selectedEcoFactor
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

extension EcoFactorChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedEcoFactor = EcoFactor.all[indexPath.row]
    switch EcoFactor.all[indexPath.row] {
    case .Abiotic:
      performSegue(withIdentifier: "abioticFactorChoice", sender: nil)
    case .Biotic:
      performSegue(withIdentifier: "bioticFactorChoice", sender: nil)
    }
  }
  
}

extension EcoFactorChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return EcoFactor.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    switch EcoFactor.all[indexPath.row] {
    case .Abiotic:
      cell.textLabel?.text = "Abiotic"
    case .Biotic:
      cell.textLabel?.text = "Biotic"
    }
    return cell
  }
  
}