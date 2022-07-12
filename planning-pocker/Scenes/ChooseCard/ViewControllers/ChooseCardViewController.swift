//
//  ChooseCardViewController.swift
//  planning-pocker
//
//  Created by TPS on 06/21/22.
//

import UIKit
import SocketIO
import SwiftUI
import MaterialComponents.MaterialSnackbar

class ChooseCardViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var groupOtherPlayers: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var issueNameLabel: UILabel!
    @IBOutlet weak var boardInfoView: BoardInfoView! {
        didSet {
            guard let subView = Bundle.main.loadNibNamed("BoardInfoView",
                                                         owner: boardInfoView,
                                                         options: nil)?.first as? BoardInfoView else { return }
            boardInfoView?.addSubview(subView)
            subView.frame = subView.superview!.bounds
            subView.layer.cornerRadius = 8
            setupBoardInfo()
        }
    }
    @IBOutlet weak var listCardToSelectCollectionView: UICollectionView!
    @IBOutlet weak var listCardOtherPlayersCollectionView: UICollectionView!
    @IBOutlet weak var cardMainPlayerCollectionView: UICollectionView!
    // MARK: - Properties
    var selectedIndex: String?
    var isHostExist: Bool?
    var room: RoomModel!
    var gameInfo: GameModel!

    // identify for collection view cell
    struct TableView {
        struct CellIdentifiers {
            static let cardToSelect = "CardToSelectCollectionViewCell"
            static let cardMainPlayer = "CardMainPlayerCollectionViewCell"
            static let cardOtherPlayer = "CardOtherPlayersCollectionViewCell"
        }
    }

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdentifier()
        listCardToSelectCollectionView.dataSource = self
        listCardToSelectCollectionView.delegate = self
        listCardOtherPlayersCollectionView.dataSource = self
        cardMainPlayerCollectionView.dataSource = self
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOtherPlayer()
        updateOtherPlayerSelectCard()
        updateOtherPlayerRemovedCard()
    }

    // MARK: - Publics

    // MARK: - Private
    private func updateOtherPlayer() {
        SocketIOManager.sharedInstance.updateOtherPlayers { (listUserIds) -> Void in
            self.room.otherPlayers.removeAll()
            for id in listUserIds {
                self.room.otherPlayers.append(PlayerModel(id: id, name: "Player " + id, roomId: self.room.roomId, role: PlayerRole.member))
            }
            self.showInvitePlayer()
            SnackBar.showSnackBar(message: "Room changed", color: UIColor(hexString: "#5bc0de"))
            self.listCardOtherPlayersCollectionView.reloadData()
        }
    }
    private func updateOtherPlayerSelectCard() {
        SocketIOManager.sharedInstance.updateCard { (userId) -> Void in
            for player in self.room.otherPlayers where player.id == userId {
                    player.isSelectedCard = true
                    self.listCardOtherPlayersCollectionView.reloadData()
            }
        }
    }
    private func updateOtherPlayerRemovedCard() {
        SocketIOManager.sharedInstance.updateCardRemoved { (userId) -> Void in
            for player in self.room.otherPlayers where player.id == userId {
                player.isSelectedCard = false
                self.listCardOtherPlayersCollectionView.reloadData()
            }
        }
    }
    private func setupIdentifier() { // register xib file for cell of collection view
        listCardToSelectCollectionView.register(UINib(nibName: TableView.CellIdentifiers.cardToSelect,
                                                      bundle: nil),
                                                forCellWithReuseIdentifier: TableView.CellIdentifiers.cardToSelect)
        listCardOtherPlayersCollectionView.register(UINib(nibName: TableView.CellIdentifiers.cardOtherPlayer,
                                                          bundle: nil),
                                                    forCellWithReuseIdentifier:
                                                        TableView.CellIdentifiers.cardOtherPlayer)
        cardMainPlayerCollectionView.register(UINib(nibName: TableView.CellIdentifiers.cardMainPlayer,
                                                    bundle: nil),
                                              forCellWithReuseIdentifier: TableView.CellIdentifiers.cardMainPlayer)
    }
    private func setupUI() { // load view every time data changed
        setupTitleRoom()
        setupTitleIssue(isShow: false)
        setupLeftMenu()
    }
    private func setupTitleRoom() { // set room name
        gameNameLabel.text = room.roomName
    }
    private func setupTitleIssue(isShow: Bool) { // check game has issue or not, if not hidden issue name
        if isShow {
            issueNameLabel.isHidden = false
            issueNameLabel.text = room.currentIssue
        } else {
            issueNameLabel.isHidden = true
        }
    }
    private func showInvitePlayer() { // check other players in room, else show Invite player
        guard let foundEmptyList = groupOtherPlayers.viewWithTag(101),
              let foundList = groupOtherPlayers.viewWithTag(102)
        else { return }
        foundEmptyList.isHidden = (room.otherPlayers.isEmpty == true ? false : true)
        foundList.isHidden =  (room.otherPlayers.isEmpty == true ? true : false)
    }
    private func setupBoardInfo() {
        boardInfoView.changeBoardInfo(isSelected: selectedIndex != nil ? true : false)
    }

    // MARK: - Actions
    @IBAction func listIssueButton(_ sender: UIButton) {
        AppViewController.shared.pushToShowIssueListScreen(url: gameInfo.url)
    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
        leftMenuState(expanded: MenuHolder.isExpanded ? false : true)
    }
    @IBAction func invitePlayerButton(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen(url: "game.getLinkRoom()")
    }
}

// MARK: - Extensions
extension ChooseCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.listCardToSelectCollectionView {
            return room.cards.count
        } else if collectionView == self.cardMainPlayerCollectionView {
            return 1
        } else if collectionView == self.listCardOtherPlayersCollectionView {
            return room.otherPlayers.count
        }
       return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listCardToSelectCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardToSelect,
                                                          for: indexPath) as? CardToSelectCollectionViewCell
            cell?.config(name: room.cards[indexPath.row])
            cell?.configSelect(isSelected: (selectedIndex == room.cards[indexPath.row]) ?  true : false)
            return cell!
        } else if collectionView == self.cardMainPlayerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardMainPlayer,
                                                          for: indexPath) as? CardMainPlayerCollectionViewCell
            cell?.config(name: room.mainPlayer.name)
            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
            return cell!
        } else if collectionView == self.listCardOtherPlayersCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TableView.CellIdentifiers.cardOtherPlayer,
                for: indexPath) as? CardOtherPlayersCollectionViewCell
            cell?.config(name: room.otherPlayers[indexPath.row].name)
            cell?.configSelect(isSelected: room.otherPlayers[indexPath.row].isSelectedCard ? true : false)
            return cell!
        }
        return UICollectionViewCell()
    }
}

extension ChooseCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.listCardToSelectCollectionView {
            if room.cards[indexPath.row] == selectedIndex {
                selectedIndex = nil
                SocketIOManager.sharedInstance.removeCard(userId: room.mainPlayer.id)
            } else {
                selectedIndex = room.cards[indexPath.row]
                SocketIOManager.sharedInstance.selectCard(userId: room.mainPlayer.id,  selectedIndex: room.cards[indexPath.row])
            }
            listCardToSelectCollectionView.reloadData()
            cardMainPlayerCollectionView.reloadData()
            setupBoardInfo()
        }
    }
}

extension ChooseCardViewController: UICollectionViewDelegateFlowLayout {
}
