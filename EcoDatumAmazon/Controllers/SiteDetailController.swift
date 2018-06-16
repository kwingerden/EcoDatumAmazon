//
//  SiteDetailController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class SiteDetailController: UIViewController {
  
  @IBOutlet weak var siteName: UITextField!
  
  @IBOutlet weak var latitude: UITextField!
  
  @IBOutlet weak var longitude: UITextField!
  
  @IBOutlet weak var saveButton: UIButton!
  
  @IBOutlet weak var stackView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    siteName.delegate = self
    latitude.delegate = self
    longitude.delegate = self
    
    stackView.isHidden = true
    
    let viewContext = ViewContext.shared
    viewContext.addObserver(self, forKeyPath: "selectedSite", options: .new, context: nil)
    
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == "selectedSite" {
      if let selectedSite = ViewContext.shared.selectedSite {
        siteName.text = selectedSite.name
        if let selectedLatitude = selectedSite.latitude {
          latitude.text = selectedLatitude.stringValue
        } else {
          latitude.text = nil
        }
        if let selectedLongitude = selectedSite.longitude {
          longitude.text = selectedLongitude.stringValue
        } else {
          longitude.text = nil
        }
        stackView.isHidden = false
      } else {
        stackView.isHidden = true
      }
    }
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {

    if sender == saveButton, let selectedSite = ViewContext.shared.selectedSite {
      do {
        selectedSite.name = siteName.text
        selectedSite.notes = nil
        selectedSite.latitude = 3.4
        selectedSite.longitude = 4.533
        try selectedSite.save()
      } catch let error {
        print(error)
      }
    }
    
  }

}

extension SiteDetailController: UITextFieldDelegate {
  
  
}
