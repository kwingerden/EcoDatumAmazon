//
//  SitePhotosController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/17/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class SitePhotosController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var selectedSite: Site?
  
  private var selectedPhoto: SitePhoto? = nil
  
  private var sectionLabels: [YearMonthDay] = []
  
  private var sectionLabelMap: [YearMonthDay: [SitePhoto]] = [:]
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.sectionHeadersPinToVisibleBounds = true
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingSelectedSiteKeyPath = true
  }
  
  deinit {
    if isObservingSelectedSiteKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.selectedSiteKeyPath)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let mainTabBarController = MainTabBarController.shared {
      mainTabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: UIBarButtonItem.SystemItem.add,
        target: self,
        action: #selector(addButtonPressed))
    }
    
    refresh()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
      
    case is SitePhotoNavigationController:
      let viewController = segue.destination as! SitePhotoNavigationController
      viewController.photo = selectedPhoto!
      
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
      
    }
  }
  
  @objc func addButtonPressed() {
    if let _ = ViewContext.shared.selectedSite {
      performSegue(withIdentifier: "newSitePhoto", sender: nil)
    }
  }
  
  private func refresh() {
    if let site = ViewContext.shared.selectedSite {
      if let photos = site.photos {
        let orderedPhotos = photos.map {
          $0 as! SitePhoto
          }.sorted {
            (lhs: SitePhoto, rhs: SitePhoto) in
            if lhs.date == nil {
              return false
            }
            if rhs.date == nil {
              return false
            }
            return lhs.date! >= rhs.date! ? true : false
        }
        
        var uniqueYearMonthDaySet: Set<YearMonthDay> = Set()
        orderedPhotos.forEach {
          (photo: SitePhoto) in
          let yearMonthDay = photo.date!.toYearMonthDay()
          uniqueYearMonthDaySet.insert(yearMonthDay)
        }
        
        sectionLabels = uniqueYearMonthDaySet.sorted().reversed()
        sectionLabels.forEach {
          (currentYearMonthDay: YearMonthDay) in
          var sectionPhotos: [SitePhoto] = []
          var index = 0
          orderedPhotos.forEach {
            (photo: SitePhoto) in
            let photo = orderedPhotos[index]
            let photoYearMonthDay = photo.date!.toYearMonthDay()
            if photoYearMonthDay == currentYearMonthDay {
              sectionPhotos.append(photo)
            }
            index = index + 1
          }
          sectionLabelMap[currentYearMonthDay] = sectionPhotos
        }
      }
      
    } else {
      
      selectedPhoto = nil
      sectionLabels = []
      sectionLabelMap = [:]
      
    }
    
    collectionView.reloadData()
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      if let site = change?[NSKeyValueChangeKey.newKey] as? Site {
        selectedSite = site
        refresh()
        collectionView.isHidden = false
      } else {
        collectionView.isHidden = true
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    parent?.navigationItem.rightBarButtonItem = nil
  }
  
}

extension SitePhotosController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let sectionYearMonthDay = sectionLabels[indexPath.section]
    selectedPhoto = sectionLabelMap[sectionYearMonthDay]![indexPath.row]
    performSegue(withIdentifier: "sitePhotoDetail", sender: nil)
  }
  
}

extension SitePhotosController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: "sectionHeader",
      for: indexPath) as! SitePhotoSectionHeader
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
    return sectionLabelMap[sectionYearMonthDay]!.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let sitePhotoCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "cell",
      for: indexPath) as! SitePhotoCell
    
    let sectionYearMonthDay = sectionLabels[indexPath.section]
    let image = sectionLabelMap[sectionYearMonthDay]![indexPath.row].image()!
    sitePhotoCell.backgroundView = UIImageView(image: image)
    
    sitePhotoCell.roundedAndDarkBordered()
    
    return sitePhotoCell
  }
  
}

class SitePhotoCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
}

class SitePhotoSectionHeader: UICollectionReusableView {
  
  @IBOutlet weak var label: UILabel!
  
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
