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

class AbitoicDataUnitChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  private var abioticEcoData: AbioticEcoData!
  
  private var abioticDataType: AbioticDataType!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var selectedAbioticDataUnit: DataUnit!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    abioticEcoData = ecoFactor.abioticEcoData!
    abioticDataType = abioticEcoData!.dataType!
    
    switch abioticDataType! {
    case .Air(let airDataType):
      title = "\(airDataType.rawValue) Data Unit Choice"
    case .Soil(let soilDataType):
      title = "\(soilDataType.rawValue) Data Unit Choice"
    case .Water(let waterDataType):
      title = "\(waterDataType.rawValue) Data Unit Choice"
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
    case is AbioticDataValueChoiceController:
      let viewController = segue.destination as! AbioticDataValueChoiceController
      let newAbioticEcoData = abioticEcoData.new(selectedAbioticDataUnit)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Abiotic(newAbioticEcoData))
      viewController.ecoFactor = newEcoFactor
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension AbitoicDataUnitChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch abioticDataType! {
    case .Air(let airDataType):
      selectedAbioticDataUnit = DataUnit.units(.Air(airDataType))[indexPath.row]
    case .Soil(let soilDataType):
      selectedAbioticDataUnit = DataUnit.units(.Soil(soilDataType))[indexPath.row]
    case .Water(let waterDataType):
      selectedAbioticDataUnit = DataUnit.units(.Water(waterDataType))[indexPath.row]
    }
    performSegue(withIdentifier: "abioticDataValueChoice", sender: nil)
  }
  
}

extension AbitoicDataUnitChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return DataUnitChoiceTableViewCell.CELL_HEIGHT
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch abioticDataType! {
    case .Air(let airDataType):
      return DataUnit.units(.Air(airDataType)).count
    case .Soil(let soilDataType):
      return DataUnit.units(.Soil(soilDataType)).count
    case .Water(let waterDataType):
      return DataUnit.units(.Water(waterDataType)).count
    }
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath) as! DataUnitChoiceTableViewCell
    switch abioticDataType! {
    case .Air(let airDataType):
      cell.dataUnitLabel.latex = dataUnitValue(dataUnits(airDataType), indexPath)
    case .Soil(let soilDataType):
      cell.dataUnitLabel.latex = dataUnitValue(dataUnits(soilDataType), indexPath)
    case .Water(let waterDataType):
      cell.dataUnitLabel.latex = dataUnitValue(dataUnits(waterDataType), indexPath)
    }
    return cell
  }
  
  private func dataUnits(_ airDataType: AirDataType) -> [DataUnit] {
    return DataUnit.units(.Air(airDataType))
  }
  
  private func dataUnits(_ soilDataType: SoilDataType) -> [DataUnit] {
    return DataUnit.units(.Soil(soilDataType))
  }
  
  private func dataUnits(_ waterDataType: WaterDataType) -> [DataUnit] {
    return DataUnit.units(.Water(waterDataType))
  }
  
  private func dataUnitValue(_ dataUnitChoices: [DataUnit],
                             _ indexPath: IndexPath) -> String {
    return dataUnitChoices[indexPath.row].rawValue
  }
  
}

class DataUnitChoiceTableViewCell: UITableViewCell {
  
  static let CELL_HEIGHT: CGFloat = 80
  
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
