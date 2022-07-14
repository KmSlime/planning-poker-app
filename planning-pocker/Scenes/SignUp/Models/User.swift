//
//  User.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/22/22.
//

import Foundation

class User {
    //static let shared = User()
    private var userId: Int?
    private var userEmail: String?
    private var userPassword: String?
    private var userFullName: String?
//    var token: String? //cái này chưa rõ????
    //init(){}
    init(id: Int, email:  String, password: String, fullName: String) {
        self.userId = id                                            
        self.userEmail = email
        self.userPassword = password
        self.userFullName = fullName
    }
    
    public var id: Int? {
        get {
            return self.userId!
        }
        set {
            return self.userId = newValue
        }
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

    public var fullName: String {
        get {
            return self.userFullName!
        }
        set {
            return self.userFullName = newValue
        }
    }

}
