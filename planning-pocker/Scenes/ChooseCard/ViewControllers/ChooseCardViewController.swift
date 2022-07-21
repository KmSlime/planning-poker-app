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
import SideMenu

class ChooseCardViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var chooseYourCardLabel: UILabel!
    @IBOutlet weak var averagePointLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var chooseCardLabel: UILabel!
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
    @IBOutlet weak var listCardToResultCollectionView: UICollectionView!
    @IBOutlet weak var listCardToSelectCollectionView: UICollectionView!
    @IBOutlet weak var listCardOtherPlayersCollectionView: UICollectionView!
    @IBOutlet weak var cardMainPlayerCollectionView: UICollectionView!
    // MARK: - Properties
    var selectedIndex: String?
    var isHostExist: Bool?
    var room: RoomModel!
    var gameInfo: GameModel!
    var isLockCardToSelect = false
    var isFlipCard = false
    var listCardResult: [String: Int] = [:]
    
    // identify for collection view cell
    struct TableView {
        struct CellIdentifiers {
            static let cardToSelect = "CardToSelectCollectionViewCell"
            static let cardMainPlayer = "CardMainPlayerCollectionViewCell"
            static let cardOtherPlayer = "CardOtherPlayersCollectionViewCell"
            static let cardToResult = "CardToResultCollectionViewCell"
        }
    }

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdentifier()
        listCardToSelectCollectionView.dataSource = self
        listCardToSelectCollectionView.delegate = self
        listCardOtherPlayersCollectionView.dataSource = self
        listCardOtherPlayersCollectionView.delegate = self
        cardMainPlayerCollectionView.dataSource = self
        cardMainPlayerCollectionView.delegate = self
        listCardToResultCollectionView.dataSource = self
        listCardToResultCollectionView.delegate = self
        setupUI()
        SocketIOManager.sharedInstance.reloadRoom()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOtherPlayer()
        updateOtherPlayerSelectCard()
        updateOtherPlayerRemovedCard()
        updateCardToSelect()
        updateBoardInfo()
        updateIssue()
        showResult()
        restartRoom()
    }
    // MARK: - Publics

    // MARK: - Private
    private func updateOtherPlayer() {
        print("Prepare")
        SocketIOManager.sharedInstance.updateOtherPlayers { (users) -> Void in
            self.room.otherPlayers.removeAll()
            for item in users {
                guard let userId = item["userId"],
                let userName = item["userName"],
                      let selectedCardValue = item["selectedCardValue"] else {
                    return
                }
                self.room.otherPlayers.append(PlayerModel(id: userId,
                                                          name: userName,
                                                          roomUrl: self.room.roomUrl,
                                                          role: PlayerRole.member,
                                                          vote: selectedCardValue,
                                                          isSelectedCard: selectedCardValue != "" ? true : false))
            }
            self.showInvitePlayer()
            SnackBar.showSnackBar(message: "Room changed", color: UIColor(hexString: "#5bc0de"))
            self.listCardOtherPlayersCollectionView.reloadData()
        }
    }
    private func updateOtherPlayerSelectCard() {
        SocketIOManager.sharedInstance.updateCard { (userId, selectCardValue) -> Void in
            for player in self.room.otherPlayers where player.id == userId {
                    player.isSelectedCard = true
                    player.vote = selectCardValue
                    self.listCardOtherPlayersCollectionView.reloadData()
            }
        }
    }
    private func updateOtherPlayerRemovedCard() {
        SocketIOManager.sharedInstance.updateCardRemoved { (userId) -> Void in
            for player in self.room.otherPlayers where player.id == userId {
                player.isSelectedCard = false
                player.vote = ""
                self.listCardOtherPlayersCollectionView.reloadData()
            }
        }
    }
    private func updateCardToSelect() {
        SocketIOManager.sharedInstance.lockSelectCard { () -> Void in
            self.isLockCardToSelect = true
            self.listCardToSelectCollectionView.allowsSelection = false
            self.chooseCardLabel.text = "Counting votes..."
            self.listCardToSelectCollectionView.reloadData()
            
        }
    }
    private func updateBoardInfo() {
        SocketIOManager.sharedInstance.showCountDown {
            self.boardInfoView.showCountDownText()
        }
    }
    private func updateIssue() {
        if room.currentIssue == "" {
            self.issueNameLabel.isHidden = true
        } else {
            self.issueNameLabel.isHidden = false
            self.issueNameLabel.text = "Voting: " + room.currentIssue
        }
        
        SocketIOManager.sharedInstance.updateIssue { issueTitle in
            print(issueTitle)
            self.issueNameLabel.isHidden = false
            self.room.currentIssue = issueTitle
            self.issueNameLabel.text = "Voting: " + issueTitle
        }
        SocketIOManager.sharedInstance.issueDisabled {
            self.issueNameLabel.isHidden = true
            self.room.currentIssue = ""
            self.issueNameLabel.text = ""
        }
    }
    private func showResult() {
        SocketIOManager.sharedInstance.getResult { averagePoint, selectedCardsSort in
            self.listCardToSelectCollectionView.isHidden = true
            self.listCardToResultCollectionView.isHidden = false
            self.chooseYourCardLabel.isHidden = true
            self.averageLabel.isHidden = false
            self.averagePointLabel.isHidden = false
            self.averagePointLabel.text = averagePoint
            self.listCardResult = selectedCardsSort
            self.boardInfoView.showStartNewVotingButton()
            self.listCardToSelectCollectionView.allowsSelection = true
                
            self.isFlipCard = true
            self.listCardToResultCollectionView.reloadData()
            self.listCardOtherPlayersCollectionView.reloadData()
            self.cardMainPlayerCollectionView.reloadData()
        }
    }
    private func restartRoom() {
        SocketIOManager.sharedInstance.resetDefault {
            self.listCardToSelectCollectionView.isHidden = false
            self.listCardToResultCollectionView.isHidden = true
            self.chooseYourCardLabel.isHidden = false
            self.chooseYourCardLabel.text = "Choose your card"
            self.averageLabel.isHidden = true
            self.averagePointLabel.isHidden = true
            self.averagePointLabel.text = ""
            self.listCardResult.removeAll()
            self.boardInfoView.showResetDefault()
            self.isLockCardToSelect = false
            self.selectedIndex = nil
                
            self.isFlipCard = false
            self.listCardToSelectCollectionView.reloadData()
            self.listCardToResultCollectionView.reloadData()
            self.listCardOtherPlayersCollectionView.reloadData()
            self.cardMainPlayerCollectionView.reloadData()
        }
    }
    
    private func setupIdentifier() { // register xib file for cell of collection view
        listCardToResultCollectionView.register(UINib(nibName: TableView.CellIdentifiers.cardToResult, bundle: nil), forCellWithReuseIdentifier: TableView.CellIdentifiers.cardToResult)
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
        self.listCardToResultCollectionView.isHidden = true
        self.chooseYourCardLabel.isHidden = false
        self.averageLabel.isHidden = true
        self.averagePointLabel.isHidden = true
        setupTitleRoom()
        setupTitleIssue(isShow: false)
    }
    private func setupTitleRoom() { // set room name
        gameNameLabel.text = room.roomName
        issueNameLabel.text = room.currentIssue == "" ? room.currentIssue : "Voting: " + room.currentIssue
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
        boardInfoView.showIconPickCard(isSelected: selectedIndex != nil ? true : false)
    }

    // MARK: - Actions
    @IBAction func listIssueButton(_ sender: UIButton) {
        AppViewController.shared.pushToShowIssueListScreen(url: room.roomUrl, cardData: room.cards)
    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
        let vc = LeftMenuViewController()
        vc.isGameStarted = true
        vc.url = room.roomUrl
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.alwaysAnimate = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        menu.statusBarEndAlpha = 0
        present(menu, animated: true)
    }
    @IBAction func invitePlayerButton(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen(url: room.roomUrl)
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
        } else if collectionView == self.listCardToResultCollectionView {
            return listCardResult.count
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
            
            cell?.configLock(isLock: isLockCardToSelect, isSelected: (self.selectedIndex == self.room.cards[indexPath.row]) ?  true : false)
            return cell!
        } else if collectionView == self.cardMainPlayerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardMainPlayer,
                                                          for: indexPath) as? CardMainPlayerCollectionViewCell
            cell?.config(name: room.mainPlayer.name)
            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
            if isFlipCard {
                cell?.configFlipCard(point: selectedIndex ?? "")
            }
            
            return cell!
        } else if collectionView == self.listCardOtherPlayersCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TableView.CellIdentifiers.cardOtherPlayer,
                for: indexPath) as? CardOtherPlayersCollectionViewCell
            cell?.config(name: room.otherPlayers[indexPath.row].name)
            cell?.configSelect(isSelected: room.otherPlayers[indexPath.row].isSelectedCard ? true : false)
            if isFlipCard {
                cell?.configFlipCard(point: room.otherPlayers[indexPath.row].vote)
            }
            return cell!
        } else if collectionView == self.listCardToResultCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardToResult, for: indexPath) as? CardToResultCollectionViewCell
            cell?.config(cardNumber: Array(listCardResult.keys)[indexPath.row], voteNumber: String(Array(listCardResult.values)[indexPath.row]) + " vote")
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
                SocketIOManager.sharedInstance.selectCard(userId: room.mainPlayer.id, selectedIndex: room.cards[indexPath.row])
            }
            listCardToSelectCollectionView.reloadData()
            cardMainPlayerCollectionView.reloadData()
            setupBoardInfo()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == self.listCardOtherPlayersCollectionView {
//            let leftTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 0, 0)
//            cell.layer.transform = leftTransform
//            cell.alpha = 0.5
//            UIView.animate(withDuration: 1, animations: {
//              cell.alpha = 1
//              cell.transform = .identity
//            })
//        } else
        if collectionView == self.listCardToResultCollectionView {
            
            let upTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
            cell.layer.transform = upTransform
            cell.alpha = 0.5
            UIView.animate(withDuration: 0.5, animations: {
              cell.alpha = 1
              cell.transform = .identity
            })
        }
    }
}

extension ChooseCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView != self.listCardToSelectCollectionView {
            let itemSize: CGSize? = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
                let spacing: CGFloat? = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing

            let count: Int = collectionView.numberOfItems(inSection: 0)
                let totalCellWidth = (itemSize?.width ?? 0.0) * CGFloat(count)
                let totalSpacingWidth = (spacing ?? 0.0) * CGFloat(((count - 1) < 0 ? 0 : count - 1))
                let leftInset: CGFloat = (collectionView.layer.bounds.width - (totalCellWidth + totalSpacingWidth)) / 2
                if leftInset < 0 {
                    let inset: UIEdgeInsets? = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
                    return inset!
                }
                let rightInset: CGFloat = leftInset
                let sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
                return sectionInset
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
           
       
    }
    
}
