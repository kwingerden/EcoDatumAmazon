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

class SitePlaceController: UIViewController {
  
  @IBOutlet weak var placeNameTextField: UITextField!
  
  @IBOutlet weak var placeNameActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var streetAddressTextField: UITextField!
  
  @IBOutlet weak var streetAddressActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var cityTextField: UITextField!
  
  @IBOutlet weak var cityActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var stateTextField: UITextField!
  
  @IBOutlet weak var stateActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var postalCodeTextField: UITextField!
  
  @IBOutlet weak var postalCodeActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var countryTextField: UITextField!
  
  @IBOutlet weak var countryActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var placeButton: UIButton!
  
  private var currrentlySelectedSite: Site?
  
  private var geocoder: CLGeocoder?
  
  private let startGeocodeImage = UIImage(named: "ios-near-glyph")
  
  private let stopGeocodeImage = UIImage(named: "mus-stop-glyph")
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    placeNameTextField.delegate = self
    placeNameTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    streetAddressTextField.delegate = self
    streetAddressTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    cityTextField.delegate = self
    cityTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    stateTextField.delegate = self
    stateTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    postalCodeTextField.delegate = self
    postalCodeTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    countryTextField.delegate = self
    countryTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    stackView.isHidden = true
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
    isObservingSelectedSiteKeyPath = true
  }
  
  @IBAction func touchUpInsideButton(_ sender: UIButton) {
    if sender == placeButton {
      if placeButton.image(for: .normal) == startGeocodeImage  {
        startGeocoding()
      } else {
        stopGeocoding()
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
        
        self.placeNameTextField.text = site.place
        self.streetAddressTextField.text = site.street
        self.cityTextField.text = site.city
        self.stateTextField.text = site.state
        self.postalCodeTextField.text = site.postalCode
        self.countryTextField.text = site.country
        
        currrentlySelectedSite = site
        stackView.isHidden = false
        
      } else {
        
        currrentlySelectedSite = nil
        stackView.isHidden = true
        
      }
    }
  }
  
  private func startGeocoding() {
    guard let site = currrentlySelectedSite,
      let latitude = site.latitude,
      let longitude = site.longitude else {
      LOG.error("Site not currently selected")
      return
    }
    
    placeButton.setImage(stopGeocodeImage, for: .normal)
    
    placeNameActivityIndicator.startAnimating()
    streetAddressActivityIndicator.startAnimating()
    cityActivityIndicator.startAnimating()
    stateActivityIndicator.startAnimating()
    postalCodeActivityIndicator.startAnimating()
    countryActivityIndicator.startAnimating()
    
    let location = CLLocation(
      latitude: latitude.doubleValue,
      longitude: longitude.doubleValue)
    geocoder = CLGeocoder()
    geocoder?.reverseGeocodeLocation(location) {
      (placemarks: [CLPlacemark]?, error: Error?) in
      if let error = error {
        LOG.error(error)
      } else if let placemark = placemarks?.first {
        self.placeNameTextField.text = placemark.name
        self.streetAddressTextField.text = placemark.thoroughfare
        self.cityTextField.text = placemark.locality
        self.stateTextField.text = placemark.administrativeArea
        self.postalCodeTextField.text = placemark.postalCode
        self.countryTextField.text = placemark.country
        self.save()
      }
      self.stopGeocoding()
    }
  }
  
  private func stopGeocoding() {
    if let geocoder = geocoder {
      geocoder.cancelGeocode()
    }
    
    placeButton.setImage(startGeocodeImage, for: .normal)
    
    placeNameActivityIndicator.stopAnimating()
    streetAddressActivityIndicator.stopAnimating()
    cityActivityIndicator.stopAnimating()
    stateActivityIndicator.stopAnimating()
    postalCodeActivityIndicator.stopAnimating()
    countryActivityIndicator.stopAnimating()
  }
  
  private func save() {
    if let site = currrentlySelectedSite {
      do {
        site.place = placeNameTextField.text
        site.street = streetAddressTextField.text
        site.city = cityTextField.text
        site.state = stateTextField.text
        site.postalCode = postalCodeTextField.text
        site.country = countryTextField.text
        let _ = try site.save()
      } catch let error as NSError {
        LOG.error("\(error), \(error.userInfo)")
      }
    }
  }
}

extension SitePlaceController: UITextFieldDelegate {
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    save()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    save()
  }
  
}
