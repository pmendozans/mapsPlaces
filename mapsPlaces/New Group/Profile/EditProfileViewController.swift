//
//  EditProfileViewController.swift
//  mapsPlaces
//
//  Created by Pablo Arturo Ruiz Mendoza on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Kingfisher

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let imagePicker = UIImagePickerController()
    private let storageManager = FirebaseStorageManager()
    private var profileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInformation()
    }
    
    private func loadUserInformation() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        usernameTextField.text = user.displayName
        if let profileUrl = user.photoURL {
            profileImage.kf.setImage(with: profileUrl)
        }
    }

    @IBAction func editProfile(_ sender: Any) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = usernameTextField.text!
        if let profileUrl = profileUrl {
            changeRequest?.photoURL = profileUrl
        }
        changeRequest?.commitChanges { (error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        self.openPhotoLibrary()
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
        progressView.isHidden = false
        progressView.progress = 0
        let userId = Auth.auth().currentUser?.uid
        let uploadTask = storageManager.uploadImage(imageToUpload: imageToUpload, userId: userId!, completion: { imageUrl in
            self.profileUrl = imageUrl
        }, errorHandler: {
            
        } )
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            self.progressView.progress = Float(percentComplete)
        }
        
        uploadTask.observe(.progress) { snapshot in
            self.profileImage.image = imageToUpload
            self.progressView.isHidden = true
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
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
