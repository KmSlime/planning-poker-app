//
//  ChooseCardViewController.swift
//  planning-pocker
//
//  Created by TPS on 06/21/22.
//

import UIKit



class ChooseCardViewController: UIViewController {
    // MARK: - IBOutlets
    @IBAction func listIssueButton(_ sender: UIButton) {
    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
    }
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var issueNameLabel: UILabel!
    @IBOutlet weak var tableInfo: UIView!
    @IBOutlet weak var ListCardToSelect: UICollectionView!{
        didSet{
            ListCardToSelect.register(UINib(nibName: cardToSelectCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardToSelectCollectionViewIdentifier)
        }
    }
    @IBOutlet weak var ListCardOtherPlayers: UICollectionView!{
        didSet {
            ListCardOtherPlayers.register(UINib(nibName: cardOtherPlayersCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardOtherPlayersCollectionViewIdentifier)
            ListCardOtherPlayers.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var CardMainPlayer: UICollectionView!{
        didSet {
            CardMainPlayer.register(UINib(nibName: cardMainPlayerCollectionViewIdentifier, bundle: nil), forCellWithReuseIdentifier: cardMainPlayerCollectionViewIdentifier)
            CardMainPlayer.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Properties
    let dataCard = ["0","1","2", "2","3","5","8","13","21","34","55","89","?"]
    let dataOtherPlayers = ["Player A", "PLayer B", "PLayer C", "PLayer C", "PLayer C", "PLayer C", "PLayer C"]
    let dataMainPlayer = "Nghia"
    var selectedIndex : IndexPath?
    var isHostExist: Bool?
    let cardToSelectCollectionViewIdentifier = "CardToSelectCollectionViewCell"
    let cardMainPlayerCollectionViewIdentifier = "CardMainPlayerCollectionViewCell"
    let cardOtherPlayersCollectionViewIdentifier = "CardOtherPlayersCollectionViewCell"
    
    

    // MARK: - Overrides
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        ListCardToSelect.dataSource = self
        ListCardToSelect.delegate = self
        ListCardOtherPlayers.dataSource = self
        CardMainPlayer.dataSource = self
        setUpView()
        // Do any additional setup after loading the view.
    }


    // MARK: - Publics


    // MARK: - Private
    func setUpView() {
        tableInfo?.layer.backgroundColor = UIColor.primaryLightColor().cgColor
        tableInfo?.layer.cornerRadius = 10.0
        if selectedIndex != nil {
            if isHostExist == true {
                
                
            }
        }
        
    }


    // MARK: - Actions
}

// MARK: - extensions
extension ChooseCardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ListCardToSelect {
            return dataCard.count
        } else if collectionView == self.CardMainPlayer {
            return 1
        } else if collectionView == self.ListCardOtherPlayers {
            return dataOtherPlayers.count
        }
       return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ListCardToSelect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardToSelectCollectionViewIdentifier, for: indexPath) as? CardToSelectCollectionViewCell
            cell?.config(name: dataCard[indexPath.row])
            cell?.configSelect(isSelected: (selectedIndex == indexPath) ?  true : false)
            return cell!
        } else if collectionView == self.CardMainPlayer {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardMainPlayerCollectionViewIdentifier, for: indexPath) as? CardMainPlayerCollectionViewCell
            cell?.config(name: dataMainPlayer)
            cell?.configSelect(isSelected: (selectedIndex != nil) ?  true : false)
            return cell!
        } else if collectionView == self.ListCardOtherPlayers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOtherPlayersCollectionViewIdentifier, for: indexPath) as? CardOtherPlayersCollectionViewCell
            cell?.config(name: dataOtherPlayers[indexPath.row])
            cell?.configSelect(isSelected: true)
            return cell!
        }
        return UICollectionViewCell()
    }
  

    
}

extension ChooseCardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.ListCardToSelect {
            selectedIndex = selectedIndex == nil ? indexPath : nil
            collectionView.reloadData()
            self.CardMainPlayer.reloadData()
        }
    }
}

extension ChooseCardViewController : UICollectionViewDelegateFlowLayout {
}




