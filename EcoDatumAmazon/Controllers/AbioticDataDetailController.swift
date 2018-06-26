//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AbioticDataDetailController: UIViewController {
  
  var site: Site!
  
  var abioticData: AbioticData!
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  var collectionDate: Date {
    return ecoFactor.collectionDate!
  }
  
  var ecoData: EcoFactor.EcoData! {
    return ecoFactor.ecoData!
  }
  
  var abioticEcoData: AbioticEcoData! {
    return ecoFactor.abioticEcoData!
  }
  
  var abioticFactor: AbioticFactor! {
    return abioticEcoData.abioticFactor!
  }
  
  var abioticDataType: AbioticDataType! {
    return abioticEcoData.dataType!
  }
  
  var abioticDataUnit: AbioticDataUnit! {
    return abioticEcoData.dataUnit!
  }
  
  var abioticDataValue: AbioticDataValue! {
    return abioticEcoData.dataValue!
  }
  
  enum TableCellIndex: Int {
    case CollectionDate
    case AbioticFactor
    case AbioticDataType
    case AbioticDataUnit
    case AbioticDataValue
    
    static let all: [TableCellIndex] = [
      .CollectionDate,
      .AbioticFactor,
      .AbioticDataType,
      .AbioticDataUnit,
      .AbioticDataValue
    ]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    switch ecoData! {
    case .Abiotic:
      title = "Abiotic Eco-Data"
    case .Biotic:
      title = "Biotic Eco-Data"
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.trash,
      target: self,
      action: #selector(trashButtonPressed))
  }
  
  @objc func trashButtonPressed() {
    let alert = UIAlertController(
      title: "Delete Data Confirmation",
      message: "Are you sure you want to delete this data value?",
      preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
      alertAction in
      do {
        try self.abioticData.delete()
        try self.abioticData.save()
      } catch {
        LOG.error("Failed to delete abiotic data: \(error)")
      }
      let mainTabBarController = self.navigationController?.viewControllers.first {
        $0 is MainTabBarController
      }
      if let mainTabBarController = mainTabBarController {
        self.navigationController?.popToViewController(
          mainTabBarController,
          animated: true)
      }
    }
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true)
  }
  
}

extension AbioticDataDetailController: UITableViewDelegate {
  
}

extension AbioticDataDetailController: UITableViewDataSource {
  
  static let CELL_HEIGHT: CGFloat = 80
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return AbioticDataDetailController.CELL_HEIGHT
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return TableCellIndex.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "dataValueCell",
      for: indexPath) as! AbioticDataValueCell
    switch indexPath.row {
    
    case TableCellIndex.CollectionDate.rawValue:
      cell.dataTitleLabel.text = "Collection Date:"
      cell.dataValueLabel.text = collectionDate.mediumFormattedDateString()
    
    case TableCellIndex.AbioticFactor.rawValue:
      cell.dataTitleLabel.text = "Abiotic Factor:"
      cell.dataValueLabel.text = abioticFactor.rawValue
      
    case TableCellIndex.AbioticDataType.rawValue:
      cell.dataTitleLabel.text = "Data Type:"
      switch abioticDataType! {
      case .Air(let airDataType):
        cell.dataValueLabel.text = airDataType.rawValue
      case .Soil(let soilDataType):
        cell.dataValueLabel.text = soilDataType.rawValue
      case .Water(let waterDataType):
        cell.dataValueLabel.text = waterDataType.rawValue
      }
      
    case TableCellIndex.AbioticDataUnit.rawValue:
      cell.dataTitleLabel.text = "Data Unit:"
      cell.dataValueLabel.text = abioticDataUnit.rawValue
      
    case TableCellIndex.AbioticDataValue.rawValue:
      cell.dataTitleLabel.text = "Data Value:"
      switch abioticDataValue! {
      case .DecimalDataValue(let decimal):
        cell.dataValueLabel.text = decimal.description
      default:
        break
      }
      
    default:
      LOG.error("Unexpected index path: \(indexPath)")
      
    }
    return cell
  
  }
  
}

class AbioticDataValueCell: UITableViewCell {
  
  @IBOutlet weak var dataTitleLabel: UILabel!
  
  @IBOutlet weak var dataValueLabel: UILabel!
  
}

