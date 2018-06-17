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
  
  @IBOutlet weak var gpsButton: UIButton!
  
  @IBOutlet weak var deleteButtonItem: UIBarButtonItem!
  
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
    deleteButtonItem.isEnabled = false
  
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    doStopUpdatingLocation()
  }
  
  @IBAction func touchUpInsideButton(_ sender: UIButton) {
    if sender == gpsButton {
      if gpsButton.image(for: .normal) == startGPSImage  {
        startUpdatingLocation()
      } else {
        stopUpdatingLocation()
      }
    }
  }
  
  @IBAction func touchUpInsideBarButton(_ sender: UIBarButtonItem) {
    if sender == deleteButtonItem,
      let site = currrentlySelectedSite {
      let okAction = UIAlertAction(
        title: "OK",
        style: .default) {
          (action) in
          do {
            try site.delete()
            ViewContext.shared.refreshSiteTable = NSObject()
          } catch let error as NSError {
            print(error)
          }
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
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      
      if let newlySelectedSite = change?[NSKeyValueChangeKey.newKey] as? Site {
        
        stopUpdatingLocation()
        
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
        deleteButtonItem.isEnabled = true
      
      } else {
      
        title = nil
        currrentlySelectedSite = nil
        stackView.isHidden = true
        deleteButtonItem.isEnabled = false
      
      }
    }
  }
  
  private func startUpdatingLocation() {
    doStartUpdatingLocation()
    gpsButton.setImage(stopGPSImage, for: .normal)
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
    gpsButton.setImage(startGPSImage, for: .normal)
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
        currrentlySelectedSite.longitude = NSDecimalNumber(string: longitudeTextField.text)
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


