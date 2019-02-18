//
//  SitePhotosDetailController.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 2/17/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation
import UIKit

class SitePhotoDetailController: UIViewController {
  
  var photo: SitePhoto!
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.done,
      target: self,
      action: #selector(doneButtonPressed))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.trash,
      target: self,
      action: #selector(trashButtonPressed))
    
    imageView.image = photo.image()
  }
  
  @objc func doneButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func trashButtonPressed() {
    let alert = UIAlertController(
      title: "Delete Data Confirmation",
      message: "Are you sure you want to delete this data value?",
      preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
      alertAction in
      do {
        try self.photo.delete()
        try self.photo.save()
      } catch {
        LOG.error("Failed to delete abiotic data: \(error)")
      }
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    present(alert, animated: true)
  }
  
}
