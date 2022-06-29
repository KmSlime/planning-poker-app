//
//  ChooseCardViewController.swift
//  planning-pocker
//
//  Created by TPS on 06/21/22.
//

import UIKit
import SocketIO



class ChooseCardViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var groupOtherPlayers: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var issueNameLabel: UILabel!
    @IBOutlet weak var boardInfo: BoardInfoView!{
        didSet {
            guard let boardInfoView = Bundle.main.loadNibNamed("BoardInfoView", owner: boardInfo, options: nil)?.first as? BoardInfoView else { return }
            boardInfo?.addSubview(boardInfoView)
            boardInfoView.frame = boardInfoView.superview!.bounds;
            boardInfoView.layer.cornerRadius = 8
            setUpBoardInfo()
        }
    }
    @IBOutlet weak var listCardToSelect: UICollectionView!{
        didSet{
            listCardToSelect.register(UINib(nibName: cardToSelectCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardToSelectCollectionViewIdentifier)
        }
    }
    @IBOutlet weak var listCardOtherPlayers: UICollectionView!{
        didSet {
            listCardOtherPlayers.register(UINib(nibName: cardOtherPlayersCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardOtherPlayersCollectionViewIdentifier)
            listCardOtherPlayers.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var cardMainPlayer: UICollectionView!{
        didSet {
            cardMainPlayer.register(UINib(nibName: cardMainPlayerCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardMainPlayerCollectionViewIdentifier)
            cardMainPlayer.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Properties
    var selectedIndex : String?
    var isHostExist: Bool?
    var game : GameModel!
    
    // identify for collection view cell
    let cardToSelectCollectionViewIdentifier = "CardToSelectCollectionViewCell"
    let cardMainPlayerCollectionViewIdentifier = "CardMainPlayerCollectionViewCell"
    let cardOtherPlayersCollectionViewIdentifier = "CardOtherPlayersCollectionViewCell"
    
    

    // MARK: - Overrides
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        listCardToSelect.dataSource = self
        listCardToSelect.delegate = self
        listCardOtherPlayers.dataSource = self
        cardMainPlayer.dataSource = self
        
        
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
        
        setUpView()
    }


    // MARK: - Publics


    // MARK: - Private
    func setUpView() { // load view everytime data changed
        setUpTitleRoom()
        setUpTitleIssue(isShow: false)
        setUpOtherPlayer()
        
        
    }
    
    func setUpTitleRoom() { // set room name
        gameNameLabel.text = game.roomName
    }
    
    func setUpTitleIssue(isShow : Bool) { // check game has issue or not, if not hidden issue name
        if isShow {
            issueNameLabel.isHidden = false
            issueNameLabel.text = game.currentIssue
        } else {
            issueNameLabel.isHidden = true
        }
    }
    
    func setUpOtherPlayer() { // check other players in room, else show Invite player
        guard let foundEmptyList = groupOtherPlayers.viewWithTag(101),
              let foundList = groupOtherPlayers.viewWithTag(102)
        else {return}
        foundEmptyList.isHidden = (game.isEmptyOtherPlayers() == true ? false : true)
        foundList.isHidden =  (game.isEmptyOtherPlayers() == true ? true : false)
    }
    
    func setUpBoardInfo() {
        boardInfo.changeBoardInfo(isSelected: selectedIndex != nil ? true : false)
    }


    // MARK: - Actions
    @IBAction func listIssueButton(_ sender: UIButton) {
        AppViewController.shared.pushToCreateIssue()
    }
    
    @IBAction func leftMenuButton(_ sender: UIButton) {

    }
    
    @IBAction func invitePlayerButton(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen()
    }
    
}

// MARK: - Extensions
extension ChooseCardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.listCardToSelect {
            return game.cards.count
        } else if collectionView == self.cardMainPlayer {
            return 1
        } else if collectionView == self.listCardOtherPlayers {
            return game.otherPlayers.count
        }
       return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listCardToSelect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardToSelectCollectionViewIdentifier, for: indexPath) as? CardToSelectCollectionViewCell
            cell?.config(name: game.cards[indexPath.row])
            cell?.configSelect(isSelected: (selectedIndex == game.cards[indexPath.row]) ?  true : false)
            return cell!
        } else if collectionView == self.cardMainPlayer {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardMainPlayerCollectionViewIdentifier, for: indexPath) as? CardMainPlayerCollectionViewCell
            cell?.config(name: game.mainPlayer.name)
            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
            return cell!
        } else if collectionView == self.listCardOtherPlayers {
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
        if collectionView == self.listCardToSelect {
            selectedIndex = (game.cards[indexPath.row] == selectedIndex ? nil : game.cards[indexPath.row])
            listCardToSelect.reloadData()
            cardMainPlayer.reloadData()
            setUpBoardInfo()
        }
    }
    
}

extension ChooseCardViewController : UICollectionViewDelegateFlowLayout {
}




