//
//  DataManager.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/16/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import FirebaseAuth
import CoreData

class UserDataManager {
    
    private let entityName = "MPUser"
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func saveUserIfNotExists(user: User) {
        if fetchUser(byUid: user.uid) == nil {
            let userEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            let newUser = NSManagedObject(entity: userEntity, insertInto: managedContext)
            newUser.setValue(user.displayName, forKey: "username")
            newUser.setValue(user.email, forKey: "email")
            newUser.setValue(user.uid, forKey: "uid")
            newUser.setValue(user.phoneNumber, forKey: "phoneNumber")
            newUser.setValue(user.photoURL, forKey: "imageUrl")
            save()
        }
    }
    
    func updateUser(user: User) {
        guard let userToUpdate = fetchUser(byUid: user.uid) else {
            return
        }
        userToUpdate.setValue(user.displayName, forKey: "username")
        userToUpdate.setValue(user.photoURL, forKey: "imageUrl")
        save()
    }
    
    private func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchUser(byUid uid: String) -> MPUser?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uid = %@", uid)
        let userResults = try! managedContext.fetch(request)
        guard let user = userResults.first as? MPUser else {
            return nil
        }
        return user
    }
}
