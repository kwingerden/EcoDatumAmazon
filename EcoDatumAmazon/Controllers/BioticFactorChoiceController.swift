//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class BioticFactorChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var bioticEcoData: BioticEcoData!
  
  private var selectedBioticFactor: BioticFactor!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    
    switch ecoFactor.ecoData! {
    case .Biotic:
      title = "Biotic Factor Choice"
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
    case is BioticPhotoChoiceController:
      let controller = segue.destination as! BioticPhotoChoiceController
      let newBioticEcoData = bioticEcoData.new(selectedBioticFactor)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Biotic(newBioticEcoData))
      controller.ecoFactor = newEcoFactor
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension BioticFactorChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedBioticFactor = BioticFactor.all[indexPath.row]
    performSegue(withIdentifier: "bioticPhotoChoice", sender: nil)
  }
  
}

extension BioticFactorChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return BioticFactor.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = BioticFactor.all[indexPath.row].rawValue
    return cell
  }
  
}

