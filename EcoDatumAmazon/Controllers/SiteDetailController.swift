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
  
  @IBOutlet weak var latitudeTextField: UITextField!
  
  @IBOutlet weak var latitudeActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var longitudeTextField: UITextField!
  
  @IBOutlet weak var longitudeActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var coordinateAccuracyTextField: UITextField!
  
  @IBOutlet weak var coordinateAccuracyActivityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var altitudeTextField: UITextField!
  
  @IBOutlet weak var altitudeActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var altitudeAccuracyTextField: UITextField!
  
  @IBOutlet weak var altitudeAccuracyActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var gpsButton: UIButton!
  
  private var gpsTimer: Timer?
  
  private let gpsTimeInterval: Double = 20
  
  private let gpsAcceptableHorizontalAccuracy: Double = 10

  private var currrentlySelectedSite: Site?
  
  private var locationManager: CLLocationManager?
  
  private let startGPSImage = UIImage(named: "ios-near-glyph")
  
  private let stopGPSImage = UIImage(named: "mus-stop-glyph")
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    siteNameTextField.delegate = self
    siteNameTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    latitudeTextField.delegate = self
    latitudeTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    longitudeTextField.delegate = self
    longitudeTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    coordinateAccuracyTextField.delegate = self
    coordinateAccuracyTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    altitudeTextField.delegate = self
    altitudeTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    altitudeAccuracyTextField.delegate = self
    altitudeAccuracyTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    stackView.isHidden = true
    
    locationManager = CLLocationManager()
    locationManager?.activityType = .other
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    locationManager?.delegate = self
    
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
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
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      
      if let site = change?[NSKeyValueChangeKey.newKey] as? Site {
        
        stopUpdatingLocation()
        
        if let parent = parent {
          parent.title = site.name
        }
        siteNameTextField.text = site.name
        
        if let selectedLatitude = site.latitude {
          latitudeTextField.text = selectedLatitude.stringValue
        } else {
          latitudeTextField.text = nil
        }
        
        if let selectedLongitude = site.longitude {
          longitudeTextField.text = selectedLongitude.stringValue
        } else {
          longitudeTextField.text = nil
        }
        
        if let selectedCoordinateAccuracy = site.coordinateAccuracy {
          coordinateAccuracyTextField.text = selectedCoordinateAccuracy.stringValue
        } else {
          coordinateAccuracyTextField.text = nil
        }
        
        if let selectedAltitude = site.altitude {
          altitudeTextField.text = selectedAltitude.stringValue
        } else {
          altitudeTextField.text = nil
        }
        
        if let selectedAltitudeAccuracy = site.altitudeAccuracy {
          altitudeAccuracyTextField.text = selectedAltitudeAccuracy.stringValue
        } else {
          altitudeAccuracyTextField.text = nil
        }
        
        currrentlySelectedSite = site
        stackView.isHidden = false
      
      } else {
      
        if let parent = parent {
          parent.title = nil
        }
        currrentlySelectedSite = nil
        stackView.isHidden = true
      
      }
    }
  }
  
  private func startUpdatingLocation() {
    doStartUpdatingLocation()
    gpsButton.setImage(stopGPSImage, for: .normal)
    
    latitudeActivityIndicator.startAnimating()
    longitudeActivityIndicator.startAnimating()
    coordinateAccuracyActivityIndicator.startAnimating()
    altitudeActivityIndicator.startAnimating()
    altitudeAccuracyActivityIndicator.startAnimating()
    
    gpsTimer = Timer.scheduledTimer(
      timeInterval: gpsTimeInterval,
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
    coordinateAccuracyActivityIndicator.stopAnimating()
    altitudeActivityIndicator.stopAnimating()
    altitudeAccuracyActivityIndicator.stopAnimating()
    
    if let gpsTimer = gpsTimer {
      gpsTimer.invalidate()
      self.gpsTimer = nil
    }
  }
  
  private func doStartUpdatingLocation() {
    guard let locationManager = locationManager else {
      let okAction = UIAlertAction(title: "OK", style: .default)
      let alertController = UIAlertController(
        title: "Location Failure",
        message: "Failed to obtain location manager. Location is not available.",
        preferredStyle: .alert)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
      return
    }
    locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    }
  }
  
  private func doStopUpdatingLocation() {
    locationManager?.stopUpdatingLocation()
  }
  
  private func save() {
    if let site = currrentlySelectedSite {
      do {
        let siteNameChanged = site.name != siteNameTextField.text
        var siteName = siteNameTextField.text?.trimmingCharacters(
          in: .whitespacesAndNewlines)
        if siteName == nil || siteName!.isEmpty {
          siteName = SITE_NAME_PLACEHOLDER
        }
        if let parent = parent {
          parent.title = siteName
        }
        site.name = siteName
        site.latitude = NSDecimalNumber(string: latitudeTextField.text)
        site.longitude = NSDecimalNumber(string: longitudeTextField.text)
        site.coordinateAccuracy = NSDecimalNumber(string: coordinateAccuracyTextField.text)
        site.altitude = NSDecimalNumber(string: altitudeTextField.text)
        site.altitudeAccuracy = NSDecimalNumber(string: altitudeAccuracyTextField.text)
        let _ = try site.save()
        if siteNameChanged {
          ViewContext.shared.refreshSiteTable = NSObject()
        }
      } catch let error as NSError {
        LOG.error("\(error), \(error.userInfo)")
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

extension SiteDetailController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    let okAction = UIAlertAction(title: "OK", style: .default)
    let alertController = UIAlertController(
      title: "Location Failure",
      message: "Failed to obtain location: \(error.localizedDescription)",
      preferredStyle: .alert)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  
    stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      latitudeTextField.text = String(location.coordinate.latitude)
      longitudeTextField.text = String(location.coordinate.longitude)
      coordinateAccuracyTextField.text = String(location.horizontalAccuracy)
      altitudeTextField.text = String(location.altitude)
      altitudeAccuracyTextField.text = String(location.verticalAccuracy)
      save()
      if location.horizontalAccuracy <= gpsAcceptableHorizontalAccuracy {
        stopUpdatingLocation()
      }
    }
  }
  
}
