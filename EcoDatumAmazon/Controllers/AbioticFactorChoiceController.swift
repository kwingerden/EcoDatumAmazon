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
  
  private var abioticEcoData: AbioticEcoData!
  
  private var selectedAbioticFactor: AbioticFactor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    abioticEcoData = ecoFactor.abioticEcoData!
    
    switch ecoFactor.ecoData! {
    case .Abiotic:
      title = "Abiotic Factor Choice"
    default:
      LOG.error("Unexpected EcoFactor: \(String(describing: ecoFactor))")
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is AbioticDataTypeChoiceController:
      let controller = segue.destination as! AbioticDataTypeChoiceController
      let newAbioticEcoData = abioticEcoData.new(selectedAbioticFactor)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Abiotic(newAbioticEcoData))
      controller.ecoFactor = newEcoFactor
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
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
