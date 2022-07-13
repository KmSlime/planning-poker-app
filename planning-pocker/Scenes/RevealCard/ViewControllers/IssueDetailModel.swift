//
//  IssueDetailModel.swift
//  planning-pocker
//
//  Created by Hiep on 13/07/2022.
//

import Foundation

class IssueDetail: NSObject {
    
    var issueId: Int?
    var issueKey: String?
    var issueTitle: String?
    var issueDescription: String? = ""
    var issueLink: String?
    
    override init() {
        
    }

    init(id: Int, key: String, title: String, description: String, link: String) {
        self.issueId = id
        self.issueKey = key
        self.issueTitle = title
        self.issueDescription = description
        self.issueLink = link
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
}

