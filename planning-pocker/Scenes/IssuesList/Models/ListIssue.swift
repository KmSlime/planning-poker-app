//
//  ListIssue.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 29/06/2022.
//

import Foundation

class ListIssue: NSObject {
    
    var issue = [Issue]()
    var votingIssueIndex: Int {
        get {
            return self.votingIssueIndex
        }
        set {
            return self.votingIssueIndex = newValue
        }
    }

    override init() {
        super.init()
    }

    var isHost: Bool {
        get {
            return self.isHost
        }
        set {
            return self.isHost = newValue
        }
    }

}
