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
  
  @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var actionBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var fetchedResultsController: NSFetchedResultsController<Site>?
  
  private var isObservingRefreshSiteTableKeyPath: Bool = false
  
  private var isObservingSelectedSiteTableKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.refreshSiteTableKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingRefreshSiteTableKeyPath = true
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingSelectedSiteTableKeyPath = true
  }
  
  deinit {
    if isObservingRefreshSiteTableKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.refreshSiteTableKeyPath)
    }
    if isObservingSelectedSiteTableKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.selectedSiteKeyPath)
    }
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    tableView.setEditing(editing, animated: true)
  }
  
  @IBAction func touchUpInside(_ sender: UIBarButtonItem) {
    
    switch sender {
      
    case actionBarButtonItem:
      guard let site = ViewContext.shared.selectedSite else {
        return
      }
      guard let siteName = site.name else {
        LOG.warning("Site needs to have a name")
        return
      }
      guard let siteData = try? site.encode() else {
        LOG.warning("Failed to encode site \(site)")
        return
      }
      guard let siteDataFileUrl = try? saveToFile(siteName, siteData) else {
        LOG.warning("Failed to save site \(site)")
        return
      }
      
      let activityController = UIActivityViewController(
        activityItems: [siteDataFileUrl],
        applicationActivities: nil)
      activityController.popoverPresentationController?.barButtonItem = actionBarButtonItem
      
      present(activityController, animated: true, completion: nil)
      
    case addBarButtonItem:
      do {
        let site = try Site.create()
        try site.save()
        ViewContext.shared.selectedSite = site
        ViewContext.shared.isNewSite = NSObject()
      } catch let error as NSError {
        LOG.error("\(error), \(error.userInfo)")
      }
      refresh()
      
    default:
      LOG.error("Unrecognized button \(sender)")
      
    }
    
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    guard let keyPath = keyPath else {
      return
    }
    if keyPath == ViewContext.refreshSiteTableKeyPath ||
      keyPath == ViewContext.selectedSiteKeyPath {
      refresh()
    }
  }
  
  private func saveToFile(_ name: String, _ data: Data) throws -> URL {
    let fileManager = FileManager.default
    let documentDirectory = try fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor:nil,
      create:false)
    let fileURL = documentDirectory.appendingPathComponent("\(name).site")
    try data.write(to: fileURL)
    return fileURL
  }
  
  private func refresh() {
    
    do {
      try fetchedResultsController = Site.fetch()
    } catch let error as NSError {
      LOG.error("\(error), \(error.userInfo)")
    }
  
    tableView.reloadData()
  
    if let sites = fetchedResultsController?.fetchedObjects, sites.count > 0 {
      editButtonItem.isEnabled = true
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
    } else {
      editButtonItem.isEnabled = false
    }
    
  }
  
}

extension SiteTableController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let site = fetchedResultsController?.object(at: indexPath) {
      ViewContext.shared.selectedSite = site
      performSegue(withIdentifier: "showDetail", sender: nil)
    }
  }
    
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
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
            try PersistenceUtil.shared.saveContext()
            try self.fetchedResultsController = Site.fetch()
          } catch let error as NSError {
            LOG.error("\(error), \(error.userInfo)")
          }
          if let count = self.fetchedResultsController?.fetchedObjects?.count,
            count == 0 {
            ViewContext.shared.selectedSite = nil
          } else {
            self.refresh()
          }
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

