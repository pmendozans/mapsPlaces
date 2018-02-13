//
//  CustomError.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation

struct CustomError {
    
    private var errorKey: String
    private var code: Int
    private var message: String
    private var reasonMessage: String
    private var domain: String
    
    init(errorKey: String = "", code: Int = 0, message: String, reasonMessage: String = "", domain: String = ""){
        self.errorKey = errorKey
        self.code = code
        self.message = message
        self.reasonMessage = reasonMessage
        self.domain = domain
    }
    
    func createCustomError() -> NSError {
        let userInfo: [AnyHashable: Any] = [
            NSLocalizedDescriptionKey :  NSLocalizedString(errorKey, value: message, comment: "") ,
            NSLocalizedFailureReasonErrorKey : NSLocalizedString(errorKey, value: reasonMessage, comment: "")
        ]
        let error = NSError(domain: domain, code: code, userInfo: userInfo as? [String : Any])
        return error
    }
}

