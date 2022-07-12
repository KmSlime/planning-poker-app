//
//  GameModel.swift
//  planning-pocker
//
//  Created by TPS on 06/22/22.
//

import Foundation

class GameModel{

    var cards: [String]
    var otherPlayers: [PlayerModel]!
    var mainPlayer: PlayerModel!
    let roomName: String
    let roomId: String
    let isHost: Bool
    var indexSelectedCard: Int?
    var isModeVoteIssue: Bool?
    var listIssues: [String] = []
    var currentIssue: String!

    init(roomName: String, roomId: String, cards: [String], mainPlayer: PlayerModel, otherPlayers: [PlayerModel]) {
        self.mainPlayer = mainPlayer
        self.otherPlayers = otherPlayers
        self.roomId = roomId
        self.roomName = roomName
        self.cards = cards
        self.isHost = mainPlayer.role == PlayerRole.host ? true : false
        self.indexSelectedCard = nil
        self.isModeVoteIssue = false
    }

    func addPlayer(player: PlayerModel) {
        otherPlayers.append(player)
    }

    func removePlayer(player: PlayerModel) {
        guard let index = otherPlayers.firstIndex(where: { $0 === player }) else {
            return
        }
        otherPlayers.remove(at: index)
    }

    func updateAllMember(_ otherPlayers: [PlayerModel]) {
        self.otherPlayers.removeAll()
        self.otherPlayers = otherPlayers
    }

    func updateCard(index: Int) {
        indexSelectedCard = index
    }

    func updateModeVote(status: Bool) {
        isModeVoteIssue = status
    }

    func isHostExisted() -> Bool {
        for member in otherPlayers where member.role == PlayerRole.host {
            return false
        }
        return true
    }

    func checkAllMemberVote() -> Bool {
        for member in otherPlayers where member.vote == nil {
            return false
        }
        return true
    }

    // handle other players
    func isEmptyOtherPlayers() -> Bool {
        return otherPlayers.isEmpty == true ? true : false
    }

    // handle issues
    func isEmptyIssue() -> Bool {
        return listIssues.isEmpty == true ? true : false
    }

    func updateCurrentIssue(index: Int) {
        currentIssue = listIssues[index]
    }

    func getDuplicateCard() -> [String] {
        let duplicate = Array(Set(cards.filter({ (card: String) in cards.filter({ $0 == card }).count > 1 })))
        return duplicate
    }

    func revealCard() {
        if isModeVoteIssue! {
            // Todo
        } else {
            resetAllCard()
        }
    }

    func resetAllCard() {
        mainPlayer.vote = nil
        for member in otherPlayers {
            member.vote = nil
        }
    }
    
    func getLinkRoom() -> String {
        return APIRouter.baseURL + "/" + roomId
    }
}
