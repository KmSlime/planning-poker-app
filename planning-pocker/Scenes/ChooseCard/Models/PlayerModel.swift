//
//  PlayerModel.swift
//  planning-pocker
//
//  Created by TPS on 06/23/22.
//

import Foundation

enum PlayerRole {
    case host
    case member
}

class PlayerModel {
    let id: Int
    let name: String
    let roomId : Int
    let role: PlayerRole?
    var vote: String!
    init(id: Int, name: String, roomId: Int, role: PlayerRole ) {
        self.id = id
        self.name = name
        self.roomId = roomId
        self.role = role
    }
}
