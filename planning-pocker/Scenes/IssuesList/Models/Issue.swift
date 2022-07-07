//
//  Issue.swift
//  planning-pocker
//
//  Created by Slime on 28/06/2022.
//

import UIKit

class Issue: NSObject, Codable {

    var issueId: Int
    var issueKey: String
    var issueIdGame: String

    var issueTitle: String?
    var issueLink: String?
    var isVoted = false

    init(id: Int, key: String, idGame: String) {
        self.issueId = id
        self.issueKey = key
        self.issueIdGame = idGame
    }

    public var id: Int {
        get {
            return self.issueId
        }
        set {
            return self.issueId = newValue
        }
    }

    public var link: String {

        get {
            return self.issueLink!
        }
        set {
            return self.issueLink = newValue
        }

    }
    
    public var title: String {
        get {
            return self.issueTitle!
        }
        set {
            return self.issueTitle = newValue
        }
    }
    
    public var idGame: String {
        get {
            return self.issueIdGame
        }
        set {
            return self.issueIdGame = newValue
        }
    }
    public var key: String {
        get {
            return self.issueKey
        }
        set {
            return self.issueKey = newValue
        }
    }
    public var voted: Bool {
        get {
            return self.isVoted
        }
        set {
            return self.isVoted = newValue
        }
    }
}
