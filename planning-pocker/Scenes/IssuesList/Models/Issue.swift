//
//  Issue.swift
//  planning-pocker
//
//  Created by Slime on 28/06/2022.
//

import UIKit

class Issue {
    
    var idIssue: Int?
    var linkIssue: String?
    var titleIssue: String?
    var idGameOfIssue: String?
    var descriptionIssue: String?

    init(idIssue: Int, linkIssue: String, titleIssue: String, idGameOfIssue: String, descriptionIssue: String) {
        self.idIssue = idIssue
        self.linkIssue = linkIssue
        self.titleIssue = titleIssue
        self.idGameOfIssue = idGameOfIssue
        self.descriptionIssue = descriptionIssue
    }
    
    public var id: Int {
        get {
            return self.idIssue!
        }
        set {
            return self.idIssue = newValue
        }
    }
    
    public var link: String {
        
        get {
            return self.linkIssue!
        }
        set {
            return self.linkIssue = newValue
        }
        
    }
    public var title: String {
        get {
            return self.titleIssue!
        }
        set {
            return self.titleIssue = newValue
        }
    }
    public var idGame: String {
        get {
            return self.idGameOfIssue!
        }
        set {
            return self.idGameOfIssue = newValue
        }
    }
    public var description: String {
        get {
            return self.descriptionIssue!
        }
        set {
            return self.descriptionIssue = newValue
        }
    }
    
    

}
