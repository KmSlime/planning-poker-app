//
//  CardMainPlayerCollectionViewCell.swift
//  planning-pocker
//
//  Created by TPS on 06/22/22.
//

import UIKit

class CardMainPlayerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var backCard: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(name: String){
        numberLabel.text = name
    }
    func configSelect(isSelected: Bool){
        backCard.layer.cornerRadius = 10.0
        numberLabel.textColor = UIColor.black
        cardImage.image = UIImage(named: "Card Icon.png")
        backCard.backgroundColor = UIColor.grayColor()
        if isSelected {
            backCard.isHidden = true
            cardImage.isHidden = false
        } else {
            backCard.isHidden = false
            cardImage.isHidden = true
        }
    }

}
