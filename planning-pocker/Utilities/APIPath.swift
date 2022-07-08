//
//  APIPath.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 05/07/2022.
//

enum APIPath {
    enum Auth: String {
        case signIn = "/api/account/v1/login"
        case signOut = "/api/account/v1/logout"
        case signUp = "/api/auth/signup"
        case createNewGame = "/api/poker/create-name-poker"
        case getIssueList = "/api/issue/list/"
    }
}
