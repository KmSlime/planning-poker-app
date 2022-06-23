//
//  GameModel.swift
//  planning-pocker
//
//  Created by TPS on 06/22/22.
//

import Foundation

class GameModel {
    var cards : [String]
    var otherPlayers : [PlayerModel]!
    var mainPlayer: PlayerModel!
    let gameName: String
    let gameId: Int
    let isHost: Bool
    var indexSelectedCard: Int?
    var isModeVoteIssue: Bool?
    
    init(gameName : String, gameId: Int, cards: [String], mainPlayer: PlayerModel, otherPlayers: [PlayerModel]) {
        self.mainPlayer = mainPlayer
        self.otherPlayers = otherPlayers
        self.gameId = gameId
        self.gameName = gameName
        self.cards = cards
        self.isHost = mainPlayer.role == PlayerRole.host ? true : false
        self.indexSelectedCard = nil
        self.isModeVoteIssue = false
    }
    
    func addPlayer(_ player: PlayerModel){
        self.otherPlayers.append(player)
    }
    
    func removePlayer(_ player: PlayerModel){
        guard let index = otherPlayers.firstIndex(where: {$0 === player}) else {
            return
        }
        self.otherPlayers.remove(at: index)
    }
    func updateAllMember(_ otherPlayers : [PlayerModel]){
        self.otherPlayers.removeAll()
        self.otherPlayers = otherPlayers
    }
    
    func updateCard(_ index: Int){
        self.indexSelectedCard = index
    }
    
    func updateModeVote(_ status: Bool){
        self.isModeVoteIssue = status
    }
    
    func isHostExisted() -> Bool {
        for member in otherPlayers {
            if member.role == PlayerRole.host {
                return false
            }
        }
        return true
    }
    func checkAllMemberVote() -> Bool{
        for member in otherPlayers {
            if member.vote == nil {
                return false
            }
        }
        return true
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
    
    
    
    
}
