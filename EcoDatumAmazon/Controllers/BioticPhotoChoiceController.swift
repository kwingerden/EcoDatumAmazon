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
      LOG.error("Unexpected EcoFactor: \(String(describing: ecoFactor))")
    }
    
    cameraButton.roundedAndLightBordered()
    photoLibraryButton.roundedAndLightBordered()
    nextButton.roundedAndLightBordered()
    imageView.roundedAndLightBordered()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
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
    dismiss(animated: true, completion: nil)
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

extension BioticPhotoChoiceController: UINavigationControllerDelegate {
  
}

extension BioticPhotoChoiceController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    
    var image: UIImage = imageView.image!
    if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
      image = editedImage
    } else if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
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



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
