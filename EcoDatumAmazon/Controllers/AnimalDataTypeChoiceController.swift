//
//  EcoFactorChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/21/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class AnimalDataTypeChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var bioticEcoData: BioticEcoData!
  
  private var bioticFactor: BioticFactor!
  
  private var selectedAnimalFactor: AnimalFactor!
  
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

    switch segue.destination {

    case is InvertebrateDataTypeChoiceController:
      let viewController = segue.destination as! InvertebrateDataTypeChoiceController
      viewController.ecoFactor = ecoFactor

    case is VertebrateDataTypeChoiceController:
      let viewController = segue.destination as! VertebrateDataTypeChoiceController
      viewController.ecoFactor = ecoFactor

    default:
      LOG.error("Unknown segue destination: \(segue.destination)")

    }
  }
  
  @objc func cancelButtonPressed() {
    dismiss(animated: true, completion: nil)
  }

}

extension AnimalDataTypeChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedAnimalFactor = AnimalFactor.all[indexPath.row]
    switch selectedAnimalFactor! {
    case .Invertebrate:
      performSegue(withIdentifier: "bioticInvertebrateDataTypeChoice", sender: nil)
    case .Vertebrate:
      performSegue(withIdentifier: "bioticVertebrateDataTypeChoice", sender: nil)
    }
  }
  
}

extension AnimalDataTypeChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return AnimalFactor.all.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = AnimalFactor.all[indexPath.row].rawValue
    return cell
  }
  
}
