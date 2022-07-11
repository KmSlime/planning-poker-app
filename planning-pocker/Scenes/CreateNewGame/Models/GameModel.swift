//
//  GameModel.swift
//  planning-pocker
//
//  Created by Slime on 07/07/2022.
//

import Foundation
class GameModel {
    private var gameId: Int? = -1
    private var gameName: String?
    private var gameURL: String?
    
    init() { }

    init(name: String, url: String) {
        self.gameName = name
        self.gameURL = url
    }
    
    init(id: Int, name: String, url: String) {
        self.gameId = id
        self.gameName = name
        self.gameURL = url
    }
    
    public var id: Int {
        get {
            return self.gameId!
        }
        set {
            return self.gameId = newValue
        }
    }

    public var name: String {
        get {
            return self.gameName!
        }
        set {
            return self.gameName = newValue
        }
    }
    
    public var url: String {
        get {
            return self.gameURL!
        }
        set {
            return self.gameURL = newValue
        }
    }
}
