//
//  ListCardToSelectCollectionViewCell.swift
//  planning-pocker
//
//  Created by TPS on 06/21/22.
//

import UIKit

class CardToSelectCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var numberLabel: UILabel!
    
    // MARK: - Properties

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Life cycles


    // MARK: - Publics
    func config(name: String){
        numberLabel.text = name
    }
    func configSelect(isSelected: Bool){
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.5
        if isSelected {
            contentView.layer.borderColor = UIColor.primaryColor().cgColor
            contentView.layer.backgroundColor = UIColor.primaryColor().cgColor
            numberLabel.textColor = .white
        } else {
            contentView.layer.borderColor = UIColor.primaryColor().cgColor
            contentView.layer.backgroundColor = UIColor.white.cgColor
            numberLabel.textColor = UIColor.primaryColor()
        }
    }

    // MARK: - Private


    // MARK: - Actions

}

