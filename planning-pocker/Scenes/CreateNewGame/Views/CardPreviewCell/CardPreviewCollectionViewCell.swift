//
//  CardPreviewCollectionViewCell.swift
//  planning-pocker
//
//  Created by Slime on 19/07/2022.
//

import UIKit

class CardPreviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardLayoutView: UIView!
    var isCardSelected: Bool = false


    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentMode = .scaleAspectFit
        cardNumber.textColor = UIColor.blueButtonColor
        cardLayoutView.layer.borderWidth = 1.5
        cardLayoutView.layer.cornerRadius = 4
        cardLayoutView.layer.borderColor = UIColor.blueButtonColor.cgColor

    }

    func configName(cardNum: String) {
        cardNumber.text = cardNum
    }

    func configSelected() {
        if isCardSelected == false {
            cardLayoutView.backgroundColor = UIColor.blueButtonColor
            cardNumber.textColor = .white
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y-9, width: 33, height: 54)
            isCardSelected.toggle()
        } else {
            cardLayoutView.backgroundColor = .white
            cardNumber.textColor = UIColor.blueButtonColor
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y+9, width: 33, height: 54)
            isCardSelected.toggle()
        }
    }
}
