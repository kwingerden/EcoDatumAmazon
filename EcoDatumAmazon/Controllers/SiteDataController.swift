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
  
  private var selectedIndexPath: IndexPath? = nil
  
  private var sectionLabels: [YearMonthDay] = []
  
  private var sectionLabelEcoDataAndFactorsMap: [YearMonthDay: [(EcoData, EcoFactor)]] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.sectionHeadersPinToVisibleBounds = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.add,
      target: self,
      action: #selector(addButtonPressed))
    
    if let site = ViewContext.shared.selectedSite,
      let ecoData = site.ecoData {
      let orderedEcoData = ecoData.map {
        $0 as! EcoData
        }.sorted {
          (lhs: EcoData, rhs: EcoData) in
          if lhs.collectionDate == nil {
            return false
          }
          if rhs.collectionDate == nil {
            return false
          }
          return lhs.collectionDate! >= rhs.collectionDate! ? true : false
      }
    
      var orderedEcoFactors: [EcoFactor] = []
      let jsonDecoder = JSONDecoder()
      do {
        orderedEcoFactors = try orderedEcoData.map {
          ecoData -> EcoFactor in
          let ecoFactor = try jsonDecoder.decode(
            EcoFactor.self,
            from: ecoData.jsonData!)
          return ecoFactor
        }
      } catch {
        LOG.error("Failed to load data: \(error)")
      }
      
      var uniqueYearMonthDaySet: Set<YearMonthDay> = Set()
      orderedEcoFactors.forEach {
        (ecoFactor: EcoFactor) in
        let yearMonthDay = ecoFactor.collectionDate!.toYearMonthDay()
        uniqueYearMonthDaySet.insert(yearMonthDay)
      }
      
      sectionLabels = uniqueYearMonthDaySet.sorted().reversed()
      sectionLabels.forEach {
        (currentYearMonthDay: YearMonthDay) in
        var sectionEcoFactors: [(EcoData, EcoFactor)] = []
        var index = 0
        orderedEcoFactors.forEach {
          (ecoFactor: EcoFactor) in
          let ecoData = orderedEcoData[index]
          let ecoFactorYearMonthDay = ecoFactor.collectionDate!.toYearMonthDay()
          if ecoFactorYearMonthDay == currentYearMonthDay {
            sectionEcoFactors.append((ecoData, ecoFactor))
          }
          index = index + 1
        }
        sectionLabelEcoDataAndFactorsMap[currentYearMonthDay] = sectionEcoFactors
      }
      
    } else {
      
      selectedIndexPath = nil
      sectionLabels = []
      sectionLabelEcoDataAndFactorsMap = [:]
      
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
    case is CollectionDateChoiceController:
      break // do nothing
    case is AbioticDataDetailController:
      let viewController = segue.destination as! AbioticDataDetailController
      viewController.site = ViewContext.shared.selectedSite!
      let sectionLabel = sectionLabels[selectedIndexPath!.section]
      let ecoDataAndFactor = sectionLabelEcoDataAndFactorsMap[sectionLabel]![selectedIndexPath!.row]
      viewController.abioticData = ecoDataAndFactor.0 as! AbioticData
      viewController.ecoFactor = ecoDataAndFactor.1
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

fileprivate struct YearMonthDay: Comparable, CustomStringConvertible, Hashable {
  
  let year: Int
  let month: Int
  let day: Int
  
  var description: String {
    return "\(year)-\(month)-\(day)"
  }
  
  var hashValue: Int {
    return year.hashValue ^ month.hashValue ^ day.hashValue
  }
  
  static func < (lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
    let lhsValue = lhs.year + lhs.month + lhs.day
    let rhsValue = rhs.year + rhs.month + rhs.day
    return lhsValue < rhsValue
  }
  
}

fileprivate extension Date {
  
  func toYearMonthDay() -> YearMonthDay {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: self)
    let month = calendar.component(.month, from: self)
    let day = calendar.component(.day, from: self)
    return YearMonthDay(year: year, month: month, day: day)
  }
  
}

extension SiteDataController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    selectedIndexPath = indexPath
    performSegue(withIdentifier: "abioticDataDetail", sender: nil)
  }
  
}

extension SiteDataController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: "sectionHeader",
      for: indexPath) as! SiteDataEcoFactorSectionHeader
    view.label.text = sectionLabels[indexPath.section].description
    view.lightBordered()
    return view
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sectionLabels.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    let sectionYearMonthDay = sectionLabels[section]
    return sectionLabelEcoDataAndFactorsMap[sectionYearMonthDay]!.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let siteDataCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "cell",
      for: indexPath) as! SiteDataEcoFactorCell
    
    let sectionYearMonthDay = sectionLabels[indexPath.section]
    let ecoDataAndFactor = sectionLabelEcoDataAndFactorsMap[sectionYearMonthDay]![indexPath.row]
    
    guard let dataType = ecoDataAndFactor.1.abioticEcoData?.dataType else {
      return UICollectionViewCell()
    }
    
    let labelText: String?
    let backgrounImage: UIImage?
    switch dataType {
    case .Air(let airDataType):
      labelText = airDataType.rawValue
      backgrounImage = #imageLiteral(resourceName: "AirLogo")
    case .Soil(let soilDataType):
      labelText = soilDataType.rawValue
      backgrounImage = #imageLiteral(resourceName: "SoilLogo")
    case .Water(let waterDataType):
      labelText = waterDataType.rawValue
      backgrounImage = #imageLiteral(resourceName: "WaterLogo")
    }
    
    if let labelText = labelText {
      siteDataCell.label.text = labelText
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

class SiteDataEcoFactorSectionHeader: UICollectionReusableView {
  
  @IBOutlet weak var label: UILabel!
  
}
