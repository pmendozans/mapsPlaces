//
//  FirebaseStorageManager.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageManager {
    
    private let storage = Storage.storage()
    private let storageReference: StorageReference!
    
    init() {
        storageReference = storage.reference()
    }
    
    func uploadImage(imageToUpload: UIImage, userId: String, completion: ((URL?) -> Void)?, errorHandler: (() -> Void)?) -> StorageUploadTask {
        let imagesDirectory = storageReference.child("images/\(userId)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageData = UIImageJPEGRepresentation(imageToUpload, 0.5)
        let uploadTask = imagesDirectory.putData(imageData!, metadata: metaData) { metadata, error in
            guard let metaData = metadata else {
                errorHandler?()
                return
            }
            let downloadURL = metaData.downloadURL()
            completion?(downloadURL)
        }
        return uploadTask
    }
}
