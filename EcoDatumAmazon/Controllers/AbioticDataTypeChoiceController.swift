//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AbioticDataTypeChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var abioticEcoData: AbioticEcoData! {
    return ecoFactor.abioticEcoData!
  }
  
  private var abioticFactor: AbioticFactor! {
    return abioticEcoData.abioticFactor!
  }
  
  private var selectedAbioticDataType: AbioticDataType!
  
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
    switch segue.destination {
    case is AbitoicDataUnitChoiceController:
      let viewController = segue.destination as! AbitoicDataUnitChoiceController
      let newAbioticEcoData = abioticEcoData.new(selectedAbioticDataType)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Abiotic(newAbioticEcoData))
      viewController.ecoFactor = newEcoFactor
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

extension AbioticDataTypeChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch abioticFactor! {
    case .Air:
      selectedAbioticDataType = .Air(AirDataType.all[indexPath.row])
    case .Soil:
      selectedAbioticDataType = .Soil(SoilDataType.all[indexPath.row])
    case .Water:
      selectedAbioticDataType = .Water(WaterDataType.all[indexPath.row])
    }
    performSegue(withIdentifier: "abioticDataUnitChoice", sender: nil)
  }
  
}

extension AbioticDataTypeChoiceController: UITableViewDataSource {
  
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
