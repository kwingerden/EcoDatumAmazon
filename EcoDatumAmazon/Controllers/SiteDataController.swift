//
//  SiteDataController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/20/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class SiteDataController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private let testData: [String] = [
    "Ken",
    "Becky",
    "Matt",
    "Sarah"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    collectionView.delegate = self
    collectionView.dataSource = self
  
    /*
    setToolbarItems(
      [
        editButtonItem,
        UIBarButtonItem( UIBarButtonSystemItem.flexibleSpace,
        addBarButtonItem
      ],
      animated: false)
 */
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    print("Editing: \(editing)")
  }
  
}

extension SiteDataController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let siteDataCell = collectionView.cellForItem(at: indexPath) as! SiteDataCell
    print(siteDataCell.testLabel.text)
  }
  
}

extension SiteDataController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return testData.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let siteDataCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "siteDataCell",
      for: indexPath) as! SiteDataCell
    siteDataCell.testLabel.text = testData[indexPath.row]
    return siteDataCell
  }
  
}

class SiteDataCell: UICollectionViewCell {
  
  @IBOutlet weak var testLabel: UILabel!
  
}
