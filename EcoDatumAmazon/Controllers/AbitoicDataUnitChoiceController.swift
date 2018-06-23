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
  
  var abioticDataTypeChoice: AbioticDataTypeChoice!
  
  @IBOutlet weak var tableView: UITableView!
  
  var selectedAbioticDataUnitChoice: AbioticDataUnitChoice!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch abioticDataTypeChoice! {
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
      barButtonSystemItem: UIBarButtonSystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is AbioticDataValueChoiceController:
      (segue.destination as! AbioticDataValueChoiceController).abioticDataUnitChoice =
      selectedAbioticDataUnitChoice
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

extension AbitoicDataUnitChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch abioticDataTypeChoice! {
    case .Air(let airDataType):
      selectedAbioticDataUnitChoice = AbioticDataUnitChoice.units(.Air(airDataType))[indexPath.row]
    case .Soil(let soilDataType):
      selectedAbioticDataUnitChoice = AbioticDataUnitChoice.units(.Soil(soilDataType))[indexPath.row]
    case .Water(let waterDataType):
      selectedAbioticDataUnitChoice = AbioticDataUnitChoice.units(.Water(waterDataType))[indexPath.row]
    }
    performSegue(withIdentifier: "dataValueChoice", sender: nil)
  }
  
}

extension AbitoicDataUnitChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return DataUnitChoiceTableViewCell.CELL_HEIGHT
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch abioticDataTypeChoice! {
    case .Air(let airDataType):
      return AbioticDataUnitChoice.units(.Air(airDataType)).count
    case .Soil(let soilDataType):
      return AbioticDataUnitChoice.units(.Soil(soilDataType)).count
    case .Water(let waterDataType):
      return AbioticDataUnitChoice.units(.Water(waterDataType)).count
    }
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath) as! DataUnitChoiceTableViewCell
    switch abioticDataTypeChoice! {
    case .Air(let airDataType):
      cell.dataUnitLabel.latex = dataUnitValue(dataUnits(airDataType), indexPath)
    case .Soil(let soilDataType):
      cell.dataUnitLabel.latex = dataUnitValue(dataUnits(soilDataType), indexPath)
    case .Water(let waterDataType):
      cell.dataUnitLabel.latex = dataUnitValue(dataUnits(waterDataType), indexPath)
    }
    return cell
  }
  
  private func dataUnits(_ airDataType: AirDataType) -> [AbioticDataUnitChoice] {
    return AbioticDataUnitChoice.units(.Air(airDataType))
  }
  
  private func dataUnits(_ soilDataType: SoilDataType) -> [AbioticDataUnitChoice] {
    return AbioticDataUnitChoice.units(.Soil(soilDataType))
  }
  
  private func dataUnits(_ waterDataType: WaterDataType) -> [AbioticDataUnitChoice] {
    return AbioticDataUnitChoice.units(.Water(waterDataType))
  }
  
  private func dataUnitValue(_ dataUnitChoices: [AbioticDataUnitChoice],
                             _ indexPath: IndexPath) -> String {
    return dataUnitChoices[indexPath.row].rawValue
  }
  
}

class DataUnitChoiceTableViewCell: UITableViewCell {
  
  static let CELL_HEIGHT: CGFloat = 80
  
  @IBOutlet weak var dataUnitView: UIView!
  
  var dataUnitLabel: MTMathUILabel = MTMathUILabel()
  
  var presentDataUnitChoice: (() -> Void)!
  
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
