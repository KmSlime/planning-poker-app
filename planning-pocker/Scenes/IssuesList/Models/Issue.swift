//
//  Issue.swift
//  planning-pocker
//
//  Created by Slime on 28/06/2022.
//

import UIKit

class Issue: NSObject {

    private var id: Int?
    private var key: String?
    private var title: String?
    private var descript: String?
    private var link: String?
    private var voteStatus: Bool? = false
    private var averagePoint: String?
    private var belongToGame: GameModel?

    override init() {

    }
    
//    init(issueId: Int, issueKey: String, idGame: String) {
//        self.id = id
//        self.issueKey = key
//        self.issueIdGame = idGame
//    }

    init(issueId: Int, issueKey: String, issueTitle: String, issueDescription: String, issueLink: String, issueVoteStatus: Bool, issueAveragePoint: String, ofGame: GameModel) {
        self.id = issueId
        self.key = issueKey
        self.title = issueTitle
        self.descript = issueDescription
        self.link = issueLink
        self.voteStatus = issueVoteStatus
        self.belongToGame = ofGame
        self.averagePoint = issueAveragePoint
    }

    public var issueBelongToGame: GameModel {
        get {
            return self.belongToGame!
        }
        set {
            return self.belongToGame = newValue
        }
    }

    public var issueId: Int {
        get {
            return self.id ?? -1
        }
        set {
            return self.id = newValue
        }
    }
    
   public var issueKey: String {
       get {
           return self.key ?? "PP-0"
       }
       set {
           return self.key = newValue
       }
   }
   
    public var issueTitle: String {
        get {
            return self.title ?? "#"
        }
        set {
            return self.title = newValue
        }
    }

    public var issueDescription: String {
        get {
            return self.descript ?? "#"
        }
        set {
            return self.descript = newValue
        }
    }

    public var issueLink: String {

        get {
            return self.link ?? "#"
        }
        set {
            return self.link = newValue
        }
    }
    
    public var issueVoteStatus: Bool {
        get {
            return self.voteStatus ?? false
        }
        set {
            return self.voteStatus = newValue
        }
    }

    public var issueAveragePoint: String {
        get {
            return self.averagePoint ?? "-"
        } set {
            return self.averagePoint = newValue
        }

    }
}
