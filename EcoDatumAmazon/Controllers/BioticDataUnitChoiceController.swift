//
//  BioticDataUnitChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/12/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//
import Foundation
import iosMath
import UIKit

class BioticDataUnitChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  private var bioticEcoData: BioticEcoData!
  
  private var bioticDataType: BioticDataType!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var selectedBioticDataUnit: DataUnit!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    bioticDataType = bioticEcoData!.dataType!
    
    switch bioticDataType! {
    case .Animal(let animalData):
      switch animalData.animalDataType! {
      case .Invertebrate(let invertebrateDataType):
        title = "\(invertebrateDataType.rawValue) Data Unit Choice"
      case .Vertebrate(let vertebrateDataType):
        title = "\(vertebrateDataType.rawValue) Data Unit Choice"
      }
    case .Fungi(let fungiDataType):
      title = "\(fungiDataType.rawValue) Data Unit Choice"
    case .Plant(let plantDataType):
      title = "\(plantDataType.rawValue) Data Unit Choice"
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
    case is BioticDataValueChoiceController:
      let viewController = segue.destination as! BioticDataValueChoiceController
      let newBioticEcoData = bioticEcoData.new(selectedBioticDataUnit)
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

extension BioticDataUnitChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedBioticDataUnit = DataUnit.units(bioticDataType!)[indexPath.row]
    performSegue(withIdentifier: "bioticDataValueChoice", sender: nil)
  }
  
}

extension BioticDataUnitChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return BioticDataUnitChoiceTableViewCell.CELL_HEIGHT
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return DataUnit.units(bioticDataType!).count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath) as! BioticDataUnitChoiceTableViewCell
    cell.dataUnitLabel.latex = DataUnit.units(bioticDataType)[indexPath.row].rawValue
    return cell
  }
  
}

class BioticDataUnitChoiceTableViewCell: UITableViewCell {
  
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
