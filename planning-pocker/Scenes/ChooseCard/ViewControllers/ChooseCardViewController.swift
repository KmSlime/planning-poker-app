//
//  ChooseCardViewController.swift
//  planning-pocker
//
//  Created by TPS on 06/21/22.
//

import UIKit
import SocketIO
import SwiftUI

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
    let socketManager = SocketIOManager()
    var selectedIndex: String?
    var isHostExist: Bool?
    var game: GameModel!
    private var leftMenuViewController: LeftMenuViewController!
    private var leftMenuRevealWidth: CGFloat = 300
    private var paddingForRotation: CGFloat = 150
    private var isExpanded = false
    private var leftMenuTrailingConstraint: NSLayoutConstraint!
    private var revealLeftMenuOnTop = true
    private var leftMenuShadowView: UIView!
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
        setupFakeData()
        setupUI()
    }

    // MARK: - Publics

    // MARK: - Private
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
    private func setupFakeData() {
        let dataCard = ["0", "1", "2", "2", "3", "5", "8", "13", "21", "2", "34", "55", "89", "?"]
        let mainPlayer = PlayerModel(id: 1, name: "nghia", roomId: 1, role: PlayerRole.host)
        let otherPlayers: [PlayerModel] = [  PlayerModel(id: 1, name: "Player A", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 2, name: "Player B", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 3, name: "Player C", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 4, name: "Player D", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 5, name: "Player E", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member)
        ]
//        let otherPlayers : [PlayerModel] =  []
        self.game = GameModel(roomName: "NewRoom",
                              roomId: 1,
                              cards: dataCard,
                              mainPlayer: mainPlayer,
                              otherPlayers: otherPlayers)
    }
    private func setupUI() { // load view everytime data changed
        setupTitleRoom()
        setupTitleIssue(isShow: false)
        setupOtherPlayer()
        setupLeftMenu()
    }
    private func setupTitleRoom() { // set room name
        gameNameLabel.text = game.roomName
    }
    private func setupTitleIssue(isShow: Bool) { // check game has issue or not, if not hidden issue name
        if isShow {
            issueNameLabel.isHidden = false
            issueNameLabel.text = game.currentIssue
        } else {
            issueNameLabel.isHidden = true
        }
    }
    private func setupOtherPlayer() { // check other players in room, else show Invite player
        guard let foundEmptyList = groupOtherPlayers.viewWithTag(101),
              let foundList = groupOtherPlayers.viewWithTag(102)
        else { return }
        foundEmptyList.isHidden = (game.isEmptyOtherPlayers() == true ? false : true)
        foundList.isHidden =  (game.isEmptyOtherPlayers() == true ? true : false)
    }
    private func setupBoardInfo() {
        boardInfoView.changeBoardInfo(isSelected: selectedIndex != nil ? true : false)
    }
    private func setupLeftMenu() { // set up left menu
        // Set up shadow
        self.leftMenuShadowView = UIView(frame: self.view.bounds)
        self.leftMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.leftMenuShadowView.backgroundColor = .black
        self.leftMenuShadowView.alpha = 0
        // Tap Gestures
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.leftMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if self.revealLeftMenuOnTop {
            view.insertSubview(self.leftMenuShadowView, at: 1)
        }
        self.view.bringSubviewToFront(leftMenuShadowView)
        // Insert LeftMenuViewController to ChooseCardViewController
        self.leftMenuViewController = LeftMenuViewController()
        self.leftMenuViewController.defaultHighLightedCell = 0
        view.insertSubview(self.leftMenuViewController!.view, at: self.revealLeftMenuOnTop ? 1 : 0)
        addChild(self.leftMenuViewController!)
        self.view.bringSubviewToFront(leftMenuViewController.view)
        self.leftMenuViewController!.didMove(toParent: self)
        self.leftMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if self.revealLeftMenuOnTop {
            self.leftMenuTrailingConstraint = self.leftMenuViewController.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: -self.leftMenuRevealWidth - self.paddingForRotation)
            self.leftMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.leftMenuViewController.view.widthAnchor.constraint(equalToConstant: self.leftMenuRevealWidth),
            self.leftMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leftMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    private func leftMenuState(expanded: Bool) {
        if expanded {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ? 0 : self.leftMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0.6
            }
        } else {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ?
                                 (-self.leftMenuRevealWidth - self.paddingForRotation)
                                 : 0) { _ in
                self.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0
            }
        }
    }
    private func animateLeftMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> Void) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: .layoutSubviews,
            animations: {
                if self.revealLeftMenuOnTop {
                    self.leftMenuTrailingConstraint.constant = targetPosition
                    self.view.layoutIfNeeded()
                } else {
                    self.view.subviews[1].frame.origin.x = targetPosition
                }
            },
            completion: completion)
    }

    // MARK: - Actions
    @IBAction func listIssueButton(_ sender: UIButton) {
        AppViewController.shared.pushToCreateIssue()
    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
        self.leftMenuState(expanded: self.isExpanded ? false : true)
    }
    @IBAction func invitePlayerButton(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen()
    }
}

// MARK: - Extensions
extension ChooseCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.listCardToSelectCollectionView {
            return game.cards.count
        } else if collectionView == self.cardMainPlayerCollectionView {
            return 1
        } else if collectionView == self.listCardOtherPlayersCollectionView {
            return game.otherPlayers.count
        }
       return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listCardToSelectCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardToSelect,
                                                          for: indexPath) as? CardToSelectCollectionViewCell
            cell?.config(name: game.cards[indexPath.row])
            cell?.configSelect(isSelected: (selectedIndex == game.cards[indexPath.row]) ?  true : false)
            return cell!
        } else if collectionView == self.cardMainPlayerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableView.CellIdentifiers.cardMainPlayer,
                                                          for: indexPath) as? CardMainPlayerCollectionViewCell
            cell?.config(name: game.mainPlayer.name)
            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
            return cell!
        } else if collectionView == self.listCardOtherPlayersCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TableView.CellIdentifiers.cardOtherPlayer,
                for: indexPath) as? CardOtherPlayersCollectionViewCell
            cell?.config(name: game.otherPlayers[indexPath.row].name)
            cell?.configSelect(isSelected: true)
            return cell!
        }
        return UICollectionViewCell()
    }
}

extension ChooseCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.listCardToSelectCollectionView {
            selectedIndex = (game.cards[indexPath.row] == selectedIndex ? nil : game.cards[indexPath.row])
            listCardToSelectCollectionView.reloadData()
            cardMainPlayerCollectionView.reloadData()
            setupBoardInfo()
        }
    }
}

extension ChooseCardViewController: UICollectionViewDelegateFlowLayout {
}

extension ChooseCardViewController: UIGestureRecognizerDelegate {
    @objc func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        print("TapGestureRecognizer")
        if sender.state == .ended {
            if self.isExpanded {
                self.leftMenuState(expanded: false)
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("gestureRecognizer")
        if(touch.view?.isDescendant(of: self.leftMenuViewController.view))! {
            return false
        }
        return true
    }
}
