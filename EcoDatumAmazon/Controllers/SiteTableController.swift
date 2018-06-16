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
  
  private let SITE_NAME_PLACEHOLDER = "<Site Name>"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    refresh()
  }
  
  @IBAction func touchUpInside(_ sender: UIBarButtonItem) {
    
    switch sender {
      
    case addBarButton:
      do {
        try Site.new().save()
      } catch let error as NSError {
        print("Failed to save site: \(error), \(error.userInfo)")
      }
      refresh()
      
    default:
      print("Unrecognized button")
      
    }
    
  }
  
  private func refresh() {
    do {
      try fetchedResultsController = Site.fetch()
    } catch let error as NSError {
      print("Failed to fetch sites: \(error), \(error.userInfo)")
    }
    tableView.reloadData()
  }
  
}

extension SiteTableController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if let site = fetchedResultsController?.object(at: indexPath) {
      ViewContext.shared.selectedSite = site
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
          // do nothing
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
