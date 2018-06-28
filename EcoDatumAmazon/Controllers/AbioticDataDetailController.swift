//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import iosMath
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
      title = "\(abioticFactor.rawValue) EcoData"
    case .Biotic:
      LOG.error("Unexpected Biotic ecodata")
      return
    }
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.done,
      target: self,
      action: #selector(doneButtonPressed))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.trash,
      target: self,
      action: #selector(trashButtonPressed))
  }
  
  @objc func doneButtonPressed() {
    dismiss(animated: true, completion: nil)
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
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true)
  }
  
}

extension AbioticDataDetailController: UITableViewDelegate {
  
}

extension AbioticDataDetailController: UITableViewDataSource {
  
  static let DEFAULT_CELL_HEIGHT: CGFloat = 90
  static let DATA_UNIT_CELL_HEIGHT: CGFloat = 130
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == TableCellIndex.AbioticDataUnit.rawValue {
      return AbioticDataDetailController.DATA_UNIT_CELL_HEIGHT
    } else {
      return AbioticDataDetailController.DEFAULT_CELL_HEIGHT
    }
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return TableCellIndex.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == TableCellIndex.AbioticDataUnit.rawValue {
      
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "dataUnitCell",
        for: indexPath) as! AbioticDataUnitCell
      cell.dataTitleLabel.text = "Data Unit:"
      cell.dataUnitLabel.latex = abioticDataUnit.rawValue
    
      return cell
      
    } else {
    
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "genericDataCell",
        for: indexPath) as! AbioticGenericDataCell
      
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

      case TableCellIndex.AbioticDataValue.rawValue:
        cell.dataTitleLabel.text = "Data Value:"
        switch abioticDataValue! {
          
        case .DecimalDataValue(let decimal):
          cell.dataValueLabel.text = decimal
          
        case .AirOzoneScale(let airOzoneScale):
          switch airOzoneScale {
          case let .LessThan90(_, label): cell.dataValueLabel.text = label
          case let .Between90And150(_, label): cell.dataValueLabel.text = label
          case let .GreaterThan150To210(_, label): cell.dataValueLabel.text = label
          case let .GreaterThan210(_, label): cell.dataValueLabel.text = label
          }
          
        case .SoilPotassiumScale(let soilPotassiumScale):
          switch soilPotassiumScale {
          case let .Low(_, label): cell.dataValueLabel.text = label
          case let .Medium(_, label): cell.dataValueLabel.text = label
          case let .High(_, label): cell.dataValueLabel.text = label
          }
          
        case .SoilTextureScale(let soilTextureScale):
          let percentSand = "Sand \(soilTextureScale.percentSand)%"
          let percentSilt = "Silt \(soilTextureScale.percentSilt)%"
          let percentClay = "Clay \(soilTextureScale.percentClay)%"
          cell.dataValueLabel.text = "\(percentSand), \(percentSilt), \(percentClay)"
          
        case .WaterOdorScale(let waterOdorScale):
          switch waterOdorScale {
          case let .NoOdor(_, label): cell.dataValueLabel.text = label
          case let .SlightOdor(_, label): cell.dataValueLabel.text = label
          case let .Smelly(_, label): cell.dataValueLabel.text = label
          case let .VerySmelly(_, label): cell.dataValueLabel.text = label
          case let .Devastating(_, label): cell.dataValueLabel.text = label
          }
          
          
        case .WaterTurbidityScale(let waterTurbidityScale):
          switch waterTurbidityScale {
          case let .CrystalClear(_, label): cell.dataValueLabel.text = label
          case let .SlightlyCloudy(_, label): cell.dataValueLabel.text = label
          case let .ModeratelyCloudy(_, label): cell.dataValueLabel.text = label
          case let .VeryCloudy(_, label): cell.dataValueLabel.text = label
          case let .BlackishOrBrownish(_, label): cell.dataValueLabel.text = label
          }
        }
        
      default:
        LOG.error("Unexpected index path: \(indexPath)")
      }
      return cell
    }
  }
}

class AbioticGenericDataCell: UITableViewCell {
  
  @IBOutlet weak var dataTitleLabel: UILabel!
  
  @IBOutlet weak var dataValueLabel: UILabel!
  
}

class AbioticDataUnitCell: UITableViewCell {
  
  @IBOutlet weak var dataTitleLabel: UILabel!
  
  @IBOutlet weak var dataUnitView: UIView!
  
  var dataUnitLabel: MTMathUILabel = MTMathUILabel()
  
  override func layoutSubviews() {
    
    if dataUnitView.subviews.index(of: dataUnitLabel) == nil {
      dataUnitView.addSubview(dataUnitLabel)
      dataUnitLabel.textAlignment = .left
      dataUnitLabel.fontSize = 25
      dataUnitLabel.textColor = .black
      dataUnitLabel.frame.size = dataUnitView.frame.size
    }
    
    super.layoutSubviews()
    
  }
  
}

