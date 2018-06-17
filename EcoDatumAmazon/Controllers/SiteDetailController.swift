//
//  SiteDetailController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/15/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import CoreData
import Foundation
import MapKit
import UIKit

class SiteDetailController: UIViewController {
  
  @IBOutlet weak var siteNameTextField: UITextField!
  
  @IBOutlet weak var notesTextView: UITextView!
  
  @IBOutlet weak var latitudeTextField: UITextField!
  
  @IBOutlet weak var latitudeActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var longitudeTextField: UITextField!
  
  @IBOutlet weak var longitudeActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var gpsButtonItem: UIBarButtonItem!
  
  private var gpsTimer: Timer?
  
  private var currrentlySelectedSite: Site?
  
  private let locationManager = CLLocationManager()
  
  private let startGPSImage = UIImage(named: "ios-near-glyph")
  
  private let stopGPSImage = UIImage(named: "mus-stop-glyph")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    siteNameTextField.delegate = self
    siteNameTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    notesTextView.delegate = self
    notesTextView.roundedAndLightBordered()
    notesTextView.allowsEditingTextAttributes = true
    
    latitudeTextField.delegate = self
    longitudeTextField.delegate = self
    
    stackView.isHidden = true
    gpsButtonItem.isEnabled = false
  
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    doStopUpdatingLocation()
  }
  
  @IBAction func touchUpInside(_ sender: UIBarButtonItem) {
    if sender == gpsButtonItem {
      if gpsButtonItem.image == startGPSImage {
        startUpdatingLocation()
      } else {
        stopUpdatingLocation()
      }
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      
      if let newlySelectedSite = change?[NSKeyValueChangeKey.newKey] as? Site {
        
        doStopUpdatingLocation()
        
        title = newlySelectedSite.name
        siteNameTextField.text = newlySelectedSite.name
        
        if let notes = newlySelectedSite.notes as? NSAttributedString {
          notesTextView.attributedText = notes
        } else {
          notesTextView.attributedText = nil
        }
        
        if let selectedLatitude = newlySelectedSite.latitude {
          latitudeTextField.text = selectedLatitude.stringValue
        } else {
          latitudeTextField.text = nil
        }
        
        if let selectedLongitude = newlySelectedSite.longitude {
          longitudeTextField.text = selectedLongitude.stringValue
        } else {
          longitudeTextField.text = nil
        }
        
        currrentlySelectedSite = newlySelectedSite
        stackView.isHidden = false
        gpsButtonItem.isEnabled = true
      
      } else {
      
        title = nil
        currrentlySelectedSite = nil
        stackView.isHidden = true
        gpsButtonItem.isEnabled = false
      
      }
    }
  }
  
  private func startUpdatingLocation() {
    doStartUpdatingLocation()
    gpsButtonItem.image = stopGPSImage
    latitudeActivityIndicator.startAnimating()
    longitudeActivityIndicator.startAnimating()
    gpsTimer = Timer.scheduledTimer(
      timeInterval: 10,
      target: self,
      selector: #selector(stopUpdatingLocation),
      userInfo: nil,
      repeats: false)
  }
  
  @objc private func stopUpdatingLocation() {
    doStopUpdatingLocation()
    gpsButtonItem.image = startGPSImage
    latitudeActivityIndicator.stopAnimating()
    longitudeActivityIndicator.stopAnimating()
    if let gpsTimer = gpsTimer {
      gpsTimer.invalidate()
      self.gpsTimer = nil
    }
  }
  
  private func doStartUpdatingLocation() {
    locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
  }
  
  private func doStopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  private func save() {
    if let currrentlySelectedSite = currrentlySelectedSite {
      do {
        let siteNameChanged = currrentlySelectedSite.name != siteNameTextField.text
        var siteName = siteNameTextField.text
        if siteName == nil || siteName!.isEmpty {
          siteName = SITE_NAME_PLACEHOLDER
        }
        title = siteName
        currrentlySelectedSite.name = siteName
        currrentlySelectedSite.notes = notesTextView.attributedText
        currrentlySelectedSite.latitude = NSDecimalNumber(string: latitudeTextField.text)
        currrentlySelectedSite.longitude = NSDecimalNumber(string: latitudeTextField.text)
        let _ = try currrentlySelectedSite.save()
        if siteNameChanged {
          ViewContext.shared.refreshSiteTable = NSObject()
        }
      } catch let error {
        print(error)
      }
    }
  }
  
}

extension SiteDetailController: UITextFieldDelegate {
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    save()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == siteNameTextField, siteNameTextField.text == SITE_NAME_PLACEHOLDER {
      siteNameTextField.text = nil
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    save()
  }
  
}

extension SiteDetailController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    save()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    save()
  }
  
}

extension SiteDetailController: CLLocationManagerDelegate {
 
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      latitudeTextField.text = String(location.coordinate.latitude)
      longitudeTextField.text = String(location.coordinate.longitude)
      save()
      if location.horizontalAccuracy < 10 {
        stopUpdatingLocation()
      }
    }
  }
  
}


