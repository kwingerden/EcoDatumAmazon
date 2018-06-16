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
  
  @IBOutlet weak var siteNameTextField: UITextField!
  
  @IBOutlet weak var notesTextView: UITextView!
  
  @IBOutlet weak var latitudeTextField: UITextField!
  
  @IBOutlet weak var longitudeTextField: UITextField!
  
  @IBOutlet weak var saveButton: UIButton!
  
  @IBOutlet weak var stackView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    siteNameTextField.delegate = self
    notesTextView.delegate = self
    notesTextView.roundedAndLightBordered()
    notesTextView.allowsEditingTextAttributes = true
    latitudeTextField.delegate = self
    longitudeTextField.delegate = self
    
    stackView.isHidden = true
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      if let selectedSite = change?[NSKeyValueChangeKey.newKey] as? Site {
        
        title = selectedSite.name
        siteNameTextField.text = selectedSite.name
        
        if let notes = selectedSite.notes as? NSAttributedString {
          notesTextView.attributedText = notes
        } else {
          notesTextView.attributedText = nil
        }
        
        if let selectedLatitude = selectedSite.latitude {
          latitudeTextField.text = selectedLatitude.stringValue
        } else {
          latitudeTextField.text = nil
        }
        
        if let selectedLongitude = selectedSite.longitude {
          longitudeTextField.text = selectedLongitude.stringValue
        } else {
          longitudeTextField.text = nil
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
        selectedSite.name = siteNameTextField.text
        selectedSite.notes = notesTextView.attributedText
        selectedSite.latitude = NSDecimalNumber(string: latitudeTextField.text)
        selectedSite.longitude = NSDecimalNumber(string: latitudeTextField.text)
        try selectedSite.save()
        ViewContext.shared.refreshSiteTable = NSObject()
      } catch let error {
        print(error)
      }
    }
    
  }

}

extension SiteDetailController: UITextFieldDelegate {
  
}

extension SiteDetailController: UITextViewDelegate {
  
}
