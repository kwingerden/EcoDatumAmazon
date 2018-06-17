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

class MainMapController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private var fetchedResultsController: NSFetchedResultsController<Site>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
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
  
  @objc fileprivate func pressSiteButton(_ siteButton: SiteButton) {
    print(siteButton.site.name!)
  }
  
}

extension MainMapController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    guard let siteMapAnnotation = annotation as? SiteMapAnnotation,
      let siteId = siteMapAnnotation.site.id?.uuidString else {
      return nil
    }
    
    if let view = mapView.dequeueReusableAnnotationView(withIdentifier: siteId) as? MKMarkerAnnotationView {
      
      view.annotation = annotation
      return view
    
    } else {
      
      let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: siteId)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      let siteButton = SiteButton(type: .detailDisclosure)
      siteButton.addTarget(
        self,
        action: #selector(pressSiteButton(_:)),
        for: .touchUpInside)
      siteButton.site = siteMapAnnotation.site
      view.rightCalloutAccessoryView = siteButton
      
      return view
      
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
