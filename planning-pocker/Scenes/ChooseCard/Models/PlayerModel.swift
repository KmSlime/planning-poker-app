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
    let id_game : Int
    let role: PlayerRole?
    var vote: String?
    init(id: Int, name: String, id_game: Int, role: PlayerRole, vote: String) {
        self.id = id
        self.name = name
        self.id_game = id_game
        self.role = role
        self.vote = vote
    }
}
