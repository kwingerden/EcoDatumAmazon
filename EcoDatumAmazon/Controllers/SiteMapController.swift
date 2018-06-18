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

class SiteMapController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private var fetchedResultsController: NSFetchedResultsController<Site>?
  
  private let regionRadius: CLLocationDistance = 1000
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    loadAnnotations()
    if let site = ViewContext.shared.selectedSite {
      setRegion(site)
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      if let site = change?[NSKeyValueChangeKey.newKey] as? Site {
        setRegion(site)
      } else {
        loadAnnotations()
      }
    }
  }
  
  private func loadAnnotations() {
    mapView.removeAnnotations(mapView.annotations)
  
    do {
      try fetchedResultsController = Site.fetch()
    } catch let error as NSError {
      print("Failed to fetch sites: \(error), \(error.userInfo)")
    }
  
    if let sites = fetchedResultsController?.fetchedObjects {
      sites.forEach {
        if let annotation = SiteMapAnnotation(site: $0) {
          mapView.addAnnotation(annotation)
        }
      }
    }
  }
  
  private func setRegion(_ toSite: Site) {
    guard let latitude = toSite.latitude?.doubleValue,
      let longitude = toSite.longitude?.doubleValue else {
        return
    }
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(
      location.coordinate,
      regionRadius,
      regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
}

extension SiteMapController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    guard let siteMapAnnotation = annotation as? SiteMapAnnotation,
      let siteId = siteMapAnnotation.site.id?.uuidString else {
      return nil
    }
    
    if let view = mapView.dequeueReusableAnnotationView(withIdentifier: siteId) as? MKMarkerAnnotationView {
      view.annotation = annotation
      return view
    } else {
      let view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: siteId)
      view.canShowCallout = true
      view.leftCalloutAccessoryView = UIView()
      return view
    }
    
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if let siteMapAnnotation = view.annotation as? SiteMapAnnotation {
      ViewContext.shared.selectedSite = siteMapAnnotation.site
      ViewContext.shared.refreshSiteTable = NSObject()
    }
  }
  
}

fileprivate class SiteMapAnnotation: NSObject, MKAnnotation {
  
  let site: Site
  
  let coordinate: CLLocationCoordinate2D
  
  let title: String?
  
  let subtitle: String?
  
  init?(site: Site) {
    guard let latitude = site.latitude?.doubleValue,
      let longitude = site.longitude?.doubleValue else {
        return nil
    }
    self.site = site
    self.coordinate = CLLocationCoordinate2D(
      latitude: latitude,
      longitude: longitude)
    self.title = site.name
    self.subtitle = "\(latitude), \(longitude)"
    
    super.init()
  }
  
}

fileprivate class SiteButton: UIButton {
  
  var site: Site!
  
}
