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
        case createNewGame = "/api/planning-poker/games"
        case getIssueList = "/api/planning-poker/issues/showIssue/"
        case voteIssue = "/api/issue/vote-issue/"
        case createIssue = "/api/planning-poker/issues"
        case getIssueDetail = "/api/issue/detail/"
        case deleteIssue = "/api/issue/"
    }
}
