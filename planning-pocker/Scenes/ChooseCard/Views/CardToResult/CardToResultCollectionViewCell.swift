//
//  CardToResultCollectionViewCell.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 14/07/2022.
//

import UIKit

class CardToResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backCardView: UIView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var countVoteNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        backCardView.layer.cornerRadius = 4
        backCardView.layer.borderColor = UIColor.black.cgColor
        backCardView.layer.borderWidth = 1.5
        
        cardNumberLabel.font = UIFont(name: "Poppins-Bold", size: 20.0)
        countVoteNumberLabel.font = UIFont(name: "Poppins-Medium", size: 14.0)
    }
    
    func config(cardNumber: String, voteNumber: String) {
        cardNumberLabel.text = cardNumber
        countVoteNumberLabel.text = voteNumber
    }
}
