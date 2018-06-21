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
  
  private var waterLogoImage: UIImage? = UIImage(named: "WaterLogo")
  
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
    
    if let siteDataDetailController = segue.destination as? SiteDataDetailController,
      let selectedAbioticData = selectedAbioticData {
      siteDataDetailController.abioticData = selectedAbioticData
    }
  }
  
  @objc func addButtonPressed() {
    if let site = ViewContext.shared.selectedSite {
      do {
        selectedAbioticData = try AbioticData.create()
        site.addToEcoData(selectedAbioticData!)
        let _ = try site.save()
        performSegue(withIdentifier: "dataDetail", sender: nil)
      } catch {
        LOG.error("Failed to create and save new Abiotic Data: \(error)")
      }
    }
  }
  
}

extension SiteDataController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    selectedAbioticData = abioticData[indexPath.row]
    performSegue(withIdentifier: "dataDetail", sender: nil)
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
    siteDataCell.backgroundView = UIImageView(image: waterLogoImage)
    siteDataCell.backgroundView?.alpha = 0.2
    siteDataCell.roundedAndLightBordered()
    return siteDataCell
  }
  
}

class SiteDataCell: UICollectionViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  
}
