//
//  APIPath.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 05/07/2022.
//

enum APIPath {
    enum Auth: String {
        case signIn = "/api/auth/signin"
        case signUp = "/api/auth/signup"
        case createNewGame = "/api/poker/createNamePoker"
        case getIssueList = "/api/issue/showIssue/"
        case getIssueDetail = "/api/issue/detail/"
        case deleteIssue = "/api/issue/"
    }
}
