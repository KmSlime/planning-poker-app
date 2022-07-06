//
//  APIPath.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 05/07/2022.
//

enum APIPath {
    enum Auth: String {
        case signUp = "/api/account/v1/register"
        case signIn = "/api/account/v1/login"
        case signOut = "/api/account/v1/logout"
    }
}
