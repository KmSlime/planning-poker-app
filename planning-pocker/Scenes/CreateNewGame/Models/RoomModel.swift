//
//  GameModel.swift
//  planning-pocker
//
//  Created by TPS on 06/22/22.
//

import Foundation

class RoomModel {

    var cards: [String]
    var otherPlayers: [PlayerModel]!
    var mainPlayer: PlayerModel!
    let roomName: String
    let roomUrl: String
    var indexSelectedCard: String?
    var isModeVoteIssue: Bool?
    var listIssues: [String] = []
    var currentIssue: String!

    init(roomName: String, roomUrl: String, cards: [String], mainPlayer: PlayerModel, otherPlayers: [PlayerModel]) {
        self.mainPlayer = mainPlayer
        self.otherPlayers = otherPlayers
        self.roomUrl = roomUrl
        self.roomName = roomName
        self.cards = cards
        self.indexSelectedCard = nil
        self.isModeVoteIssue = false
    }
}
