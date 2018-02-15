//
//  EditProfileViewController.swift
//  mapsPlaces
//
//  Created by Pablo Arturo Ruiz Mendoza on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import Cloudinary
import FirebaseStorage

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        self.openPhotoLibrary()
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Can't open photo library")
            return
        }
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func uploadImage(imageToUpload: UIImage) {
        profileImage.image = imageToUpload
        let imageData = UIImageJPEGRepresentation(imageToUpload, 0.5)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riversRef = storageRef.child("images/profile")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let uploadTask = riversRef.putData(imageData!, metadata: metaData) { (metadata, error) in
            print(metadata)
            print(error)
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()?.absoluteString
            print(downloadURL)
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        uploadImage(imageToUpload: image)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }
}
