//
//  RevealCardViewController.swift
//  planning-pocker
//
//  Created by Hiep on 12/07/2022.
//

import UIKit

class RevealCardViewController: UIViewController {

    @IBOutlet weak var groupOtherPlayers: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var issueNameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var boardResultView: BoardResultView! {
        didSet {
            guard let subView = Bundle.main.loadNibNamed("BoardResultView",
                                                         owner: boardResultView,
                                                         options: nil)?.first as? BoardResultView else { return }
            boardResultView?.addSubview(subView)
            subView.frame = subView.superview!.bounds
            subView.layer.cornerRadius = 8
            setupBoardInfo()
        }
    }
    @IBOutlet weak var listCardToResultCollectionView: UICollectionView!
    @IBOutlet weak var listCardOtherPlayersCollectionView: UICollectionView!
    @IBOutlet weak var cardMainPlayerCollectionView: UICollectionView!
    // MARK: - Properties
    let socketManager = SocketIOManager()
    var selectedIndex: String?
    var isHostExist: Bool?
    //var room: RoomModel!
    var gameInfo: GameModel!

    // identify for collection view cell
    struct TableView {
        struct CellIdentifiers {
            static let cardToSelect = "CardToResultCollectionViewCell"
            static let cardMainPlayer = "CardMainPlayerCollectionViewCell"
            static let cardOtherPlayer = "CardOtherPlayersCollectionViewCell"
        }
    }

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdentifier()
//        listCardToResultCollectionView.dataSource = self
//        listCardToResultCollectionView.delegate = self
//        listCardOtherPlayersCollectionView.dataSource = self
//        cardMainPlayerCollectionView.dataSource = self
//        setupFakeData()
//        setupUI()
    }

    // MARK: - Publics

    // MARK: - Private
    private func setupIdentifier() { // register xib file for cell of collection view
        listCardToResultCollectionView.register(UINib(nibName: TableView.CellIdentifiers.cardToSelect,
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
//    private func setupFakeData() {
//        let dataCard = room.cards
//        let mainPlayer = PlayerModel(id: 1, name: "Hiep", roomId: 1, role: PlayerRole.host)
//        let otherPlayers: [PlayerModel] = [  PlayerModel(id: 1, name: "Player A", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 2, name: "Player B", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 3, name: "Player C", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 4, name: "Player D", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 5, name: "Player E", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member),
//           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member)
//        ]
////        let otherPlayers : [PlayerModel] =  []
////        self.room = roomModel(roomName: "NewRoom", roomId: 1, cards: dataCard, mainPlayer: mainPlayer, otherPlayers: otherPlayers)
//
//        //test receive
//        print("Log ChooseCard: \(gameInfo.url ?? "fail! Don't have URL")")
//        setupUI()
//    }
//    private func setupUI() { // load view every time data changed
//        setupTitleRoom()
//        setupTitleIssue(isShow: false)
//        setupOtherPlayer()
//        setupLeftMenu()
//    }
//    private func setupTitleRoom() { // set room name
//        gameNameLabel.text = room.roomName
//    }
//    private func setupTitleIssue(isShow: Bool) { // check game has issue or not, if not hidden issue name
//        if isShow {
//            issueNameLabel.isHidden = false
//            issueNameLabel.text = room.currentIssue
//        } else {
//            issueNameLabel.isHidden = true
//        }
//    }
//    private func setupOtherPlayer() { // check other players in room, else show Invite player
//        guard let foundEmptyList = groupOtherPlayers.viewWithTag(101),
//              let foundList = groupOtherPlayers.viewWithTag(102)
//        else { return }
//        foundEmptyList.isHidden = (room.isEmptyOtherPlayers() == true ? false : true)
//        foundList.isHidden =  (room.isEmptyOtherPlayers() == true ? true : false)
//    }
    private func setupBoardInfo() {
        boardResultView.changeBoardInfo(isSelected: selectedIndex != nil ? true : false)
    }

    // MARK: - Actions
    @IBAction func listIssueButton(_ sender: UIButton) {
        AppViewController.shared.pushToShowIssueListScreen(url: gameInfo.url)
    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
        leftMenuState(expanded: MenuHolder.isExpanded ? false : true)
    }
    @IBAction func invitePlayerButton(_ sender: UIButton) {
//        AppViewController.shared.pushToInvitePlayerScreen()
    }

}

// MARK: - Extensions
//extension RevealCardViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.listCardToResultCollectionView {
//            return room.cards.count
//        } else if collectionView == self.cardMainPlayerCollectionView {
//            return 1
//        } else if collectionView == self.listCardOtherPlayersCollectionView {
//            return room.otherPlayers.count
//        }
//       return 0
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.listCardToResultCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardToSelect,
//                                                          for: indexPath) as? CardToSelectCollectionViewCell
//            cell?.config(name: room.cards[indexPath.row])
//            cell?.configSelect(isSelected: (selectedIndex == room.cards[indexPath.row]) ?  true : false)
//            return cell!
//        } else if collectionView == self.cardMainPlayerCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardMainPlayer,
//                                                          for: indexPath) as? CardMainPlayerCollectionViewCell
//            cell?.config(name: room.mainPlayer.name)
//            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
//            return cell!
//        } else if collectionView == self.listCardOtherPlayersCollectionView {
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: TableView.CellIdentifiers.cardOtherPlayer,
//                for: indexPath) as? CardOtherPlayersCollectionViewCell
//            cell?.config(name: room.otherPlayers[indexPath.row].name)
//            cell?.configSelect(isSelected: true)
//            return cell!
//        }
//        return UICollectionViewCell()
//    }
//}
//
//extension RevealCardViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == self.listCardToResultCollectionView {
//            selectedIndex = (room.cards[indexPath.row] == selectedIndex ? nil : room.cards[indexPath.row])
//            listCardToResultCollectionView.reloadData()
//            cardMainPlayerCollectionView.reloadData()
//            setupBoardInfo()
//        }
//    }
//}
//
//extension RevealCardViewController: UICollectionViewDelegateFlowLayout {
//}
