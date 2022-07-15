//
//  CardOtherPLayersCollectionViewCell.swift
//  planning-pocker
//
//  Created by TPS on 06/22/22.
//

import UIKit

class CardOtherPlayersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var backCard: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(name: String) {
        playerNameLabel.text = name
        playerNameLabel.font = UIFont(name: "Poppins-Medium", size: 14.0)
    }
    func configSelect(isSelected: Bool) {
        print("xxxxxxxxx change")
        pointLabel.isHidden = true
        resultView.isHidden = true
        playerNameLabel.textColor = UIColor.black
        cardImage.image = UIImage(named: "icon_card.png")
        backCard.image = UIImage(named: "icon_back_card.png")
        if isSelected {
            backCard.isHidden = true
            cardImage.isHidden = false
        } else {
            backCard.isHidden = false
            cardImage.isHidden = true
        }
        playerNameLabel.font = UIFont(name: "Poppins-Medium", size: 14.0)
    }
    func configFlipCard(point: String) {
        if point == "" {
            return
        } else {
            pointLabel.isHidden = false
            resultView.isHidden = false
            backCard.isHidden = true
            cardImage.isHidden = true
            self.pointLabel.text = point
            self.pointLabel.textColor = UIColor(hexString: "#00AAE7")
            self.pointLabel.font = UIFont(name: "Poppins-Medium", size: 14.0)
            self.resultView.layer.cornerRadius = 4
            self.resultView.layer.borderWidth = 1
            self.resultView.layer.borderColor = UIColor(hexString: "#00AAE7").cgColor
        }
       
    }

}
