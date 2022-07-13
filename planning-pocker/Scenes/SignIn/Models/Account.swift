//
//  Account.swift
//  planning-pocker
//
//  Created by Hiep on 12/07/2022.
//

import Foundation

class Account {
    
    private var userEmail: String?
    private var userPassword: String?
    
    init(email: String, password: String) {
        self.userEmail = email
        self.userPassword = password
    }
    

    public var email: String {
        get {
            return self.userEmail!
        }
        set {
            return self.userEmail = newValue
        }
    }

    public var password: String {
        get {
            return self.userPassword!
        }
        set {
            return self.userPassword = newValue
        }
    }

}
