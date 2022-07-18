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
    let roomUrl: String?
    let role: PlayerRole?
    var isSelectedCard: Bool
    var vote: String = ""
    init(id: String, name: String, roomUrl: String, role: PlayerRole, vote: String, isSelectedCard: Bool ) {
        self.id = id
        self.name = name
        self.roomUrl = roomUrl
        self.role = role
        self.isSelectedCard = isSelectedCard
        self.vote = vote
    }
}

