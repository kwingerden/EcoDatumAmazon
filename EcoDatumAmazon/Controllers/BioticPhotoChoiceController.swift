//
//  BioticPhotoChoiceController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 6/27/18.
//  Copyright © 2018 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class BioticPhotoChoiceController: UIViewController {
  
  var ecoFactor: EcoFactor!

  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var cameraButton: UIButton!
  
  @IBOutlet weak var photoLibraryButton: UIButton!
  
  @IBOutlet weak var nextButton: UIButton!
  
  private var bioticEcoData: BioticEcoData!
  
  private var selectedPhoto: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bioticEcoData = ecoFactor.bioticEcoData!
    
    switch ecoFactor.ecoData! {
    case .Biotic(let bioticEcoData):
      title = "\(bioticEcoData.bioticFactor!.rawValue) Photo"
    default:
      LOG.error("Unexpected EcoFactor: \(ecoFactor)")
    }
    
    imageView.roundedAndLightBordered()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.cancel,
      target: self,
      action: #selector(cancelButtonPressed))
  }
  
  @IBAction func touchUpInside(_ sender: UIButton) {
    
    switch sender {
      
    case cameraButton:
      showImagePickerController(.camera)
      
    case photoLibraryButton:
      showImagePickerController(.photoLibrary)
      
    case nextButton:
      if selectedPhoto != nil {
        performSegue(withIdentifier: "bioticNotesChoice", sender: nil)
      }
      
    default:
      LOG.error("Unexpected button: \(sender)")
      
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     switch segue.destination {
     case is BioticNotesChoiceController:
      let controller = segue.destination as! BioticNotesChoiceController
      let newBioticEcoData = bioticEcoData.new(selectedPhoto)
      let newEcoFactor = EcoFactor(
        collectionDate: ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Biotic(newBioticEcoData))
      controller.ecoFactor = newEcoFactor
     default:
      LOG.error("Unknown segue destination: \(segue.destination)")
     }
  }
  
  @objc func cancelButtonPressed() {
    let mainTabBarController = navigationController?.viewControllers.first {
      $0 is MainTabBarController
    }
    if let mainTabBarController = mainTabBarController {
      navigationController?.popToViewController(mainTabBarController, animated: true)
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

extension BioticPhotoChoiceController: UINavigationControllerDelegate {
  
}

extension BioticPhotoChoiceController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String: Any]) {
    
    var image: UIImage = imageView.image!
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      image = editedImage
    } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      image = pickedImage
    }
    imageView.image = image
    selectedPhoto = image
    picker.dismiss(animated: true, completion: nil)
    nextButton.isEnabled = true
    
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
}


