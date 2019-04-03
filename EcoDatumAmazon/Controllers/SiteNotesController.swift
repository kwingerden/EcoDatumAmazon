//
//  MainMapController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/14/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import MapKit
import UIKit

class SiteNotesController: UIViewController {
  
  @IBOutlet weak var notesTextView: UITextView!
  
  @IBOutlet weak var stackView: UIStackView!
  
  private var currrentlySelectedSite: Site?
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    notesTextView.delegate = self
    notesTextView.roundedAndLightBordered()
    notesTextView.allowsEditingTextAttributes = true
    
    stackView.isHidden = true
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingSelectedSiteKeyPath = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    DispatchQueue.main.async {
      if let mainTabBarController = MainTabBarController.shared {
        mainTabBarController.navigationItem.rightBarButtonItems = []
      }
    }
  }
  
  deinit {
    if isObservingSelectedSiteKeyPath {
      ViewContext.shared.removeObserver(
        self,
        forKeyPath: ViewContext.selectedSiteKeyPath)
    }
  }
      
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      if let site = change?[NSKeyValueChangeKey.newKey] as? Site {
        
        if let notes = site.notes as? NSAttributedString {
          notesTextView.attributedText = notes
        } else {
          notesTextView.attributedText = nil
        }
        
        currrentlySelectedSite = site
        stackView.isHidden = false
        
      } else {
        
        currrentlySelectedSite = nil
        stackView.isHidden = true
        
      }
    }
  }
  
  private func save() {
    if let site = currrentlySelectedSite {
      site.notes = notesTextView.attributedText
      do {
        try site.save()
      } catch {
        LOG.error("Failed to save notes: \(error)")
      }
    }
  }
}

extension SiteNotesController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    save()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    save()
  }
  
}
