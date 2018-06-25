//
//  SiteDataController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/20/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class SiteDataController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  /*
  static private let airLogo: UIImage? = UIImage(named: "AirLogo")
  
  static private let animalLogo: UIImage? = UIImage(named: "AnimalLogo")
  
  static private let bioticLogo: UIImage? = UIImage(named: "BioticLogo")
  
  static private let fungiLogo: UIImage? = UIImage(named: "FungiLogo")
  
  static private let soilLogo: UIImage? = UIImage(named: "SoilLogo")
  
  static private let waterLogo: UIImage? = UIImage(named: "WaterLogo")
 */
  
  private var ecoFactors: [EcoFactor] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.add,
      target: self,
      action: #selector(addButtonPressed))
    
    if let site = ViewContext.shared.selectedSite,
      let ecoData = site.ecoData {
      let jsonDecoder = JSONDecoder()
      do {
        ecoFactors = try ecoData.map {
          $0 as! EcoData
        }.map {
          ecoData in
          let ecoFactor = try jsonDecoder.decode(
            EcoFactor.self,
            from: ecoData.jsonData!)
          return ecoFactor
        }
      } catch {
        LOG.error("Failed to load data: \(error)")
      }
    }
    
    collectionView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    parent?.navigationItem.rightBarButtonItem = nil
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    /*
    switch segue.destination {
    case is EcoFactorChoiceController:
      break // do nothing
    case is AbioticDataDetailController:
      if let selectedAbioticData = selectedAbioticData {
        (segue.destination as! AbioticDataDetailController).abioticData = selectedAbioticData
      } else {
        LOG.error("Seleted Abiotic Data was not set")
      }
    default:
      LOG.error("Unexpected segue destination: \(segue.destination)")
    }
  */
  }
  
  @objc func addButtonPressed() {
    if let _ = ViewContext.shared.selectedSite {
      performSegue(withIdentifier: "newEcoFactor", sender: nil)
    }
  }
  
}

extension SiteDataController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    //selectedAbioticData = abioticData[indexPath.row]
    //performSegue(withIdentifier: "abioticDataDetail", sender: nil)
  }
  
}

extension SiteDataController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return ecoFactors.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let siteDataCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "cell",
      for: indexPath) as! SiteDataEcoFactorCell
    
    let ecoFactor = ecoFactors[indexPath.row]
    guard let dataType = ecoFactor.abioticEcoData?.dataType else {
      return UICollectionViewCell()
    }
    
    let backgrounImage: UIImage?
    switch dataType {
    case .Air:
      backgrounImage = #imageLiteral(resourceName: "AirLogo")
    case .Soil:
      backgrounImage = #imageLiteral(resourceName: "SoilLogo")
    case .Water:
      backgrounImage = #imageLiteral(resourceName: "WaterLogo")
    default:
      LOG.error("Unexpected data type: \(dataType)")
    }
    
    if let backgrounImage = backgrounImage {
      siteDataCell.backgroundView = UIImageView(image: backgrounImage)
    }
    siteDataCell.roundedAndDarkBordered()
    
    return siteDataCell
  }
  
}

class SiteDataEcoFactorCell: UICollectionViewCell {
  
  @IBOutlet weak var label: UILabel!
  
}
