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
  
  @IBOutlet weak var stackView: UIStackView!
  
  private var currrentlySelectedSite: Site?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.roundedAndLightBordered()
    
    stackView.isHidden = true

    ViewContext.shared.addObserver(
      self,
      forKeyPath: ViewContext.selectedSiteKeyPath,
      options: [.initial, .new],
      context: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    if sender == cameraButton {
      showImagePickerController(.camera)
    } else if sender == photoLibraryButton {
      showImagePickerController(.photoLibrary)
    }
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
      
        currrentlySelectedSite = site
        stackView.isHidden = false
        
      } else {
        
        currrentlySelectedSite = nil
        stackView.isHidden = true
        
      }
    }
  }
  
  private func save() {
    if let site = currrentlySelectedSite,
      let image = imageView.image,
      let photo = UIImageJPEGRepresentation(image, 1) {
      site.photo = photo
    }
  }
  
  private func showImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
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
                             didFinishPickingMediaWithInfo info: [String: Any]) {
    
    var image: UIImage = imageView.image!
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      image = editedImage
    } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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

