//
//  CardMainPlayerCollectionViewCell.swift
//  planning-pocker
//
//  Created by TPS on 06/22/22.
//

import UIKit

class CardMainPlayerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    
    @IBOutlet weak var backCard: UIImageView!
    @IBOutlet weak var cardImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(name: String){
        numberLabel.text = name
    }
    func configSelect(isSelected: Bool){
        cardImage.image = UIImage(named: "icon_card.png")
        backCard.image = UIImage(named: "icon_back_card.png")
        numberLabel.textColor = UIColor.black
        if isSelected {
            backCard.isHidden = true
            cardImage.isHidden = false
            
        } else {
            backCard.isHidden = false
            cardImage.isHidden = true
        }
    }

}
