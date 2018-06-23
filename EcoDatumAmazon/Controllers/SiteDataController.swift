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
  
  private var abioticData: [AbioticData] = []
  
  private var selectedAbioticData: AbioticData?
  
  static private let airLogo: UIImage? = UIImage(named: "AirLogo")
  
  static private let animalLogo: UIImage? = UIImage(named: "AnimalLogo")
  
  static private let bioticLogo: UIImage? = UIImage(named: "BioticLogo")
  
  static private let fungiLogo: UIImage? = UIImage(named: "FungiLogo")
  
  static private let soilLogo: UIImage? = UIImage(named: "SoilLogo")
  
  static private let waterLogo: UIImage? = UIImage(named: "WaterLogo")
  
  private let logos: [UIImage?] = [
    airLogo,
    animalLogo,
    bioticLogo,
    fungiLogo,
    soilLogo,
    waterLogo
  ]
  
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
      abioticData = ecoData.map {
        data in
        data as! AbioticData
        }.sorted {
          (lhs: AbioticData, rhs: AbioticData) in
          guard let lhsCollectionDate = lhs.collectionDate else {
            return true
          }
          guard let rhsCollectionDate = rhs.collectionDate else {
            return false
          }
          return lhsCollectionDate < rhsCollectionDate
      }
    } else {
      abioticData = []
    }
    
    collectionView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    parent?.navigationItem.rightBarButtonItem = nil
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
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
    selectedAbioticData = abioticData[indexPath.row]
    performSegue(withIdentifier: "abioticDataDetail", sender: nil)
  }
  
}

extension SiteDataController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return abioticData.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let siteDataCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "siteDataCell",
      for: indexPath) as! SiteDataCell
    siteDataCell.dateLabel.text = abioticData[indexPath.row].collectionDate?.description ?? "??"
    let index = Int(arc4random_uniform(UInt32(logos.count)))
    siteDataCell.backgroundView = UIImageView(image: logos[index])
    siteDataCell.roundedAndDarkBordered()
    return siteDataCell
  }
  
}

class SiteDataCell: UICollectionViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  
}
