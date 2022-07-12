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
    let id: String
    let name: String
    let roomId: String?
    let role: PlayerRole?
    var isSelectedCard: Bool
    var vote: String!
    init(id: String, name: String, roomId: String, role: PlayerRole ) {
        self.id = id
        self.name = name
        self.roomId = roomId
        self.role = role
        self.isSelectedCard = false
    }
}

