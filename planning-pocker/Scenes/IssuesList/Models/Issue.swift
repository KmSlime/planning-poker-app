//
//  Issue.swift
//  planning-pocker
//
//  Created by Slime on 28/06/2022.
//

import UIKit

class Issue: NSObject {

    var issueId: Int?
    var issueKey: String?
    var issueTitle: String?
    var issueDescription: String? = ""
    var issueLink: String?
    var issueVoteStatus: Bool? = false
    var issueBelongToGame: GameModel?
    var issueIdGame: String = ""
    
    override init() {
        
    }
    
    init(id: Int, key: String, idGame: String) {
        self.issueId = id
        self.issueKey = key
        self.issueIdGame = idGame
    }

    init(id: Int, key: String, title: String, description: String, link: String, status: Bool, ofGame: GameModel) {
        self.issueId = id
        self.issueKey = key
        self.issueTitle = title
        self.issueDescription = description
        self.issueLink = link
        self.issueVoteStatus = status
        self.issueBelongToGame = ofGame
    }
    
    
    public var id: Int {
        get {
            return self.issueId!
        }
        set {
            return self.issueId = newValue
        }
    }
    
   public var key: String {
       get {
           return self.issueKey!
       }
       set {
           return self.issueKey = newValue
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
    
    public var link: String {

        get {
            return self.issueLink!
        }
        set {
            return self.issueLink = newValue
        }
    }
    
    public var status: Bool {
        get {
            return self.status
        }
        set {
            return self.status = newValue
        }
    }
}
