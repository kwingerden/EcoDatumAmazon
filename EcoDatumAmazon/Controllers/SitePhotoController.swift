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

class SitePhotoController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var cameraButton: UIButton!
  
  @IBOutlet weak var photoLibraryButton: UIButton!
  
  @IBOutlet weak var button: UIButton!
  
  @IBOutlet weak var stackView: UIStackView!
  
  private var currentlySelectedSite: Site?
  
  private var isObservingSelectedSiteKeyPath: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.roundedAndLightBordered()
    stackView.isHidden = true
    
    cameraButton.roundedAndLightBordered()
    photoLibraryButton.roundedAndLightBordered()
    
    button.roundedAndLightBordered()
    
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
      
  @IBAction func touchUpInside(_ sender: UIButton) {
    if sender == cameraButton {
      showImagePickerController(.camera)
    } else if sender == photoLibraryButton {
      showImagePickerController(.photoLibrary)
    } else if sender == button {
      performSegue(withIdentifier: "sitePhotos", sender: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    /*
    switch segue.destination {
      
    case is SitePhotosController:
      let viewController = segue.destination as! SitePhotosController
      if let site = currentlySelectedSite {
        viewController.site = site
      }
      
    default:
      LOG.error("Unknown segue destination: \(segue.destination)")
      
    }
 */
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if let keyPath = keyPath, keyPath == ViewContext.selectedSiteKeyPath {
      if let site = change?[NSKeyValueChangeKey.newKey] as? Site {
        
        if let photo = site.photo {
          imageView.image = UIImage(data: photo)
        } else {
          imageView.image = UIImage(named: "PlaceholderImage")
        }
      
        currentlySelectedSite = site
        stackView.isHidden = false
        
      } else {
        
        currentlySelectedSite = nil
        stackView.isHidden = true
        
      }
    }
  }
  
  private func save() {
    if let site = currentlySelectedSite,
      let image = imageView.image,
      let photo = image.jpegData(compressionQuality: 1) {
      site.photo = photo
      do {
        try site.save()
      } catch {
        LOG.error("Failed to save photo: \(error)")
      }
    } else {
      LOG.error("Failed to save image")
    }
  }
  
  private func showImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isCameraDeviceAvailable(.rear) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = sourceType
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    }
  }
  
}

extension SitePhotoController: UINavigationControllerDelegate {
  
}

extension SitePhotoController: UIImagePickerControllerDelegate {
 
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    var image: UIImage = imageView.image!
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      image = editedImage
    } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      image = pickedImage
    }
    imageView.image = image
    save() 
    picker.dismiss(animated: true, completion: nil)
    
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
}

