//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class BioticDataTypeChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var bioticEcoData: BioticEcoData!
  
  private var bioticFactor: BioticFactor!
  
  private var selectedBioticDataType: BioticDataType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    bioticFactor = bioticEcoData.bioticFactor!
    
    title = "\(bioticFactor.rawValue) Data Type Choice"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    let newBioticEcoData = bioticEcoData.new(selectedBioticDataType)
    let newEcoFactor = EcoFactor(
      collectionDate: ecoFactor.collectionDate,
      ecoData: EcoFactor.EcoData.Biotic(newBioticEcoData))

    switch segue.destination {

    case is BioticPhotoChoiceController:
      let viewController = segue.destination as! BioticPhotoChoiceController
      viewController.ecoFactor = newEcoFactor

    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }

}

extension BioticDataTypeChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch bioticFactor! {
    case .Fungi:
      selectedBioticDataType = .Fungi(FungiDataType.all[indexPath.row])
    case .Plant:
      selectedBioticDataType = .Plant(PlantDataType.all[indexPath.row])
    default:
      fatalError()
    }
    performSegue(withIdentifier: "bioticPhotoChoice", sender: nil)
  }
  
}

extension BioticDataTypeChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch bioticFactor! {
    case .Animal:
      return AnimalFactor.all.count
    case .Fungi:
      return FungiDataType.all.count
    case .Plant:
      return PlantDataType.all.count
    }
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    switch bioticFactor! {
    case .Animal:
      cell.textLabel?.text = AnimalFactor.all[indexPath.row].rawValue
    case .Fungi:
      cell.textLabel?.text = FungiDataType.all[indexPath.row].rawValue
    case .Plant:
      cell.textLabel?.text = PlantDataType.all[indexPath.row].rawValue
    }
    return cell
  }
  
}
