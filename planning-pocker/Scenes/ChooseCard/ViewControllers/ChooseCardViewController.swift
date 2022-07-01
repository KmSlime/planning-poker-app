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
    @IBOutlet weak var boardInfoView: BoardInfoView!{
        didSet {
            guard let subView = Bundle.main.loadNibNamed("BoardInfoView", owner: boardInfoView, options: nil)?.first as? BoardInfoView else { return }
            boardInfoView?.addSubview(subView)
            subView.frame = subView.superview!.bounds;
            subView.layer.cornerRadius = 8
            setUpBoardInfo()
        }
    }
    @IBOutlet weak var listCardToSelectCollectionView: UICollectionView!{
        didSet{
            listCardToSelectCollectionView.register(UINib(nibName: cardToSelectCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardToSelectCollectionViewIdentifier)
        }
    }
    @IBOutlet weak var listCardOtherPlayersCollectionView: UICollectionView!{
        didSet {
            listCardOtherPlayersCollectionView.register(UINib(nibName: cardOtherPlayersCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardOtherPlayersCollectionViewIdentifier)
            listCardOtherPlayersCollectionView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var cardMainPlayerCollectionView: UICollectionView!{
        didSet {
            cardMainPlayerCollectionView.register(UINib(nibName: cardMainPlayerCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardMainPlayerCollectionViewIdentifier)
            cardMainPlayerCollectionView.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Properties
    var selectedIndex : String?
    var isHostExist: Bool?
    var game : GameModel!
    
    private var leftMenuViewController: LeftMenuViewController!
    private var leftMenuRevealWidth: CGFloat = 300
    private var paddingForRotation: CGFloat = 150
    private var isExpaned = false
    
    private var leftMenuTrailingContraint: NSLayoutConstraint!
    private var revealLeftMenuOnTop = true
    private var leftMenuShadowView: UIView!
    
    // identify for collection view cell
    let cardToSelectCollectionViewIdentifier = "CardToSelectCollectionViewCell"
    let cardMainPlayerCollectionViewIdentifier = "CardMainPlayerCollectionViewCell"
    let cardOtherPlayersCollectionViewIdentifier = "CardOtherPlayersCollectionViewCell"
    
    

    // MARK: - Overrides
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        listCardToSelectCollectionView.dataSource = self
        listCardToSelectCollectionView.delegate = self
        listCardOtherPlayersCollectionView.dataSource = self
        cardMainPlayerCollectionView.dataSource = self
        
        let dataCard = ["0","1","2", "2","3","5","8","13","21","2","34","55","89","?"]
        let mainPlayer : PlayerModel = PlayerModel(id: 1, name: "nghia", roomId: 1, role: PlayerRole.host)
        let otherPlayers : [PlayerModel] =
        [  PlayerModel(id: 1, name: "Player A", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 2, name: "Player B", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 3, name: "Player C", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 4, name: "Player D", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 5, name: "Player E", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member),
           PlayerModel(id: 6, name: "Player F", roomId: 1, role: PlayerRole.member)
        ]
//        let otherPlayers : [PlayerModel] =  []
        self.game = GameModel(roomName: "NewRoom", roomId: 1, cards: dataCard, mainPlayer: mainPlayer, otherPlayers: otherPlayers)
        setupUI()
    }


    // MARK: - Publics


    // MARK: - Private
    private func setupUI() { // load view everytime data changed
        setupTitleRoom()
        setupTitleIssue(isShow: false)
        setupOtherPlayer()
        setupLeftMenu()
    }
    
    private func setupTitleRoom() { // set room name
        gameNameLabel.text = game.roomName
    }
    
    private func setupTitleIssue(isShow : Bool) { // check game has issue or not, if not hidden issue name
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
        else {return}
        foundEmptyList.isHidden = (game.isEmptyOtherPlayers() == true ? false : true)
        foundList.isHidden =  (game.isEmptyOtherPlayers() == true ? true : false)
    }
    
    private func setUpBoardInfo() {
        boardInfoView.changeBoardInfo(isSelected: selectedIndex != nil ? true : false)
    }
    
    private func setupLeftMenu() { // set up left menu
        // Set up shadow
        self.leftMenuShadowView = UIView(frame: self.view.bounds)
        self.leftMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.leftMenuShadowView.backgroundColor = .black
        self.leftMenuShadowView.alpha = 0
        
        // Tap Gestures
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.leftMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        
        if self.revealLeftMenuOnTop {
            view.insertSubview(self.leftMenuShadowView, at: 15)
        }
        
        // Insert LeftMenuViewController to ChooseCardViewController
        self.leftMenuViewController = LeftMenuViewController()
        self.leftMenuViewController.defaultHighLightedCell = 0
        view.insertSubview(self.leftMenuViewController!.view, at: self.revealLeftMenuOnTop ? 20 : 0)
        addChild(self.leftMenuViewController!)
        self.leftMenuViewController!.didMove(toParent: self)
        self.leftMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if self.revealLeftMenuOnTop {
            self.leftMenuTrailingContraint = self.leftMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.leftMenuRevealWidth - self.paddingForRotation)
            self.leftMenuTrailingContraint.isActive = true
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
                self.isExpaned = true
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0.6
            }
        } else {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ? (-self.leftMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpaned = false
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0
            }
        }
    }
    
    private func animateLeftMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealLeftMenuOnTop {
                self.leftMenuTrailingContraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }

    // MARK: - Actions
    @IBAction func listIssueButton(_ sender: UIButton) {
        AppViewController.shared.pushToCreateIssue()
    }
    
    @IBAction func leftMenuButton(_ sender: UIButton) {
        self.leftMenuState(expanded: self.isExpaned ? false : true)
    }
    
    @IBAction func invitePlayerButton(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen()
    }
    
}

// MARK: - Extensions
extension ChooseCardViewController : UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listCardToSelectCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardToSelectCollectionViewIdentifier, for: indexPath) as? CardToSelectCollectionViewCell
            cell?.config(name: game.cards[indexPath.row])
            cell?.configSelect(isSelected: (selectedIndex == game.cards[indexPath.row]) ?  true : false)
            return cell!
        } else if collectionView == self.cardMainPlayerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardMainPlayerCollectionViewIdentifier, for: indexPath) as? CardMainPlayerCollectionViewCell
            cell?.config(name: game.mainPlayer.name)
            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
            return cell!
        } else if collectionView == self.listCardOtherPlayersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOtherPlayersCollectionViewIdentifier, for: indexPath) as? CardOtherPlayersCollectionViewCell
            cell?.config(name: game.otherPlayers[indexPath.row].name)
            cell?.configSelect(isSelected: true)
            return cell!
        }
        return UICollectionViewCell()
    }
}

extension ChooseCardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.listCardToSelectCollectionView {
            selectedIndex = (game.cards[indexPath.row] == selectedIndex ? nil : game.cards[indexPath.row])
            listCardToSelectCollectionView.reloadData()
            cardMainPlayerCollectionView.reloadData()
            setUpBoardInfo()
        }
    }
    
}

extension ChooseCardViewController : UICollectionViewDelegateFlowLayout {
}

extension ChooseCardViewController : UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        print("TapGestureRecognizer")
        if sender.state == .ended {
            if self.isExpaned {
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




