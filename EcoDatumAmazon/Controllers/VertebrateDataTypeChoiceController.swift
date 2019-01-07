//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class VertebrateDataTypeChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!

  private var bioticEcoData: BioticEcoData!

  private var bioticFactor: BioticFactor!

  private var selectedVertebrateDataType: VertebrateDataType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    bioticFactor = bioticEcoData.bioticFactor!

    title = "Vertebrate Data Type Choice"
    
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
      let viewController = segue.destination as! BioticPhotoChoiceController
      let newBioticDataType = BioticDataType.Animal(.Vertebrate(selectedVertebrateDataType))
      let newBioticEcoData = bioticEcoData.new(newBioticDataType)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Biotic(newBioticEcoData))
      viewController.ecoFactor = newEcoFactor

    default:
      LOG.error("Unknown segue destination: \(segue.destination)")

    }
  }

  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }

}

extension VertebrateDataTypeChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedVertebrateDataType = VertebrateDataType.all[indexPath.row]
    performSegue(withIdentifier: "bioticPhotoChoice", sender: nil)
  }
  
}

extension VertebrateDataTypeChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return VertebrateDataType.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = VertebrateDataType.all[indexPath.row].rawValue
    return cell
  }
  
}
