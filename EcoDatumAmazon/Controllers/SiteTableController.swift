//
//  SiteDataController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class SiteTableController: UIViewController {
  
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var fetchedResultsController: NSFetchedResultsController<Site>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.refreshSiteTableKeyPath,
      options: [.initial, .new],
      context: nil)
  }
  
  @IBAction func touchUpInside(_ sender: UIBarButtonItem) {
    
    switch sender {
      
    case addBarButton:
      do {
        ViewContext.shared.selectedSite = try Site.new().save()
      } catch let error as NSError {
        print("Failed to save site: \(error), \(error.userInfo)")
      }
      refresh()
      
    default:
      print("Unrecognized button")
      
    }
    
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.refreshSiteTableKeyPath {
      refresh()
    }
  }
  
  private func refresh() {
    
    do {
      try fetchedResultsController = Site.fetch()
    } catch let error as NSError {
      print("Failed to fetch sites: \(error), \(error.userInfo)")
    }
  
    tableView.reloadData()
  
    if let count = fetchedResultsController?.fetchedObjects?.count,
      count == 0 {
      ViewContext.shared.selectedSite = nil
    } else if let sites = fetchedResultsController?.fetchedObjects {
      var row = 0
      if let selectedSite = ViewContext.shared.selectedSite,
        let index = sites.index(of: selectedSite) {
        row = index
      } else {
        ViewContext.shared.selectedSite = sites[0]
      }
      tableView.selectRow(
        at: IndexPath(row: row, section: 0),
        animated: true,
        scrollPosition: .none)
    }
    
  }
  
}

extension SiteTableController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let site = fetchedResultsController?.object(at: indexPath) {
      ViewContext.shared.selectedSite = site
      //performSegue(withIdentifier: "showDetail", sender: nil)
    }
  }
    
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCellEditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      guard let site = fetchedResultsController?.object(at: indexPath) else {
        return
      }
      
      let okAction = UIAlertAction(
        title: "OK",
        style: .default) {
          (action) in
          do {
            try site.delete()
          } catch let error as NSError {
            print(error)
          }
          self.refresh()
      }
      let cancelAction = UIAlertAction(
        title: "Cancel",
        style: .cancel) {
          (action) in
          self.tableView.selectRow(
            at: indexPath,
            animated: true,
            scrollPosition: .none)
      }

      let alertController = UIAlertController(
        title: "Delete \(site.name ?? SITE_NAME_PLACEHOLDER)?",
        message: "Are you sure you want to delete \(site.name ?? SITE_NAME_PLACEHOLDER)?",
        preferredStyle: .alert)
      alertController.addAction(okAction)
      alertController.addAction(cancelAction)

      present(alertController, animated: true, completion: nil)
      
    }
  }
  
}

extension SiteTableController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController?.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let site = fetchedResultsController?.object(at: indexPath)
    cell.textLabel?.text = site?.name ?? SITE_NAME_PLACEHOLDER
    return cell
  }
  
}
