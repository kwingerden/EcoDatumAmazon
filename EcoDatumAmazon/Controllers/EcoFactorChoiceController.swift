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
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var selectedEcoData: EcoFactor.EcoData!
  
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
      let viewController = segue.destination as! AbioticFactorChoiceController
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: selectedEcoData)
      viewController.ecoFactor = newEcoFactor
    case is BioticFactorChoiceController:
      let viewController = segue.destination as! BioticFactorChoiceController
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: selectedEcoData)
      viewController.ecoFactor = newEcoFactor
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension EcoFactorChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedEcoData = EcoFactor.EcoData.all[indexPath.row]
    switch selectedEcoData! {
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
    return EcoFactor.EcoData.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    switch EcoFactor.EcoData.all[indexPath.row] {
    case .Abiotic:
      cell.textLabel?.text = "Abiotic"
    case .Biotic:
      cell.textLabel?.text = "Biotic"
    }
    return cell
  }
  
}
