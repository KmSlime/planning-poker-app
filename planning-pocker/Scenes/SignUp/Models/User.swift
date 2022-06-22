//
//  User.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/22/22.
//

import Foundation

class User{
    var userId: Int?
    var userEmail: String?
    var userPassword: String?
    var userFullName: String?
//    var token: String? //cái này chưa rõ????
    
    init(Id: Int, email:  String, password: String, fullName: String){
        self.userId = Id
        self.userEmail = email
        self.userPassword = password
        self.userFullName = fullName
    }
}
