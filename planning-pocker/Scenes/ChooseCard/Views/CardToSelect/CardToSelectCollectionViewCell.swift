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
        numberLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
    }

    // MARK: - Life cycles

    // MARK: - Publics
    func config(name: String) {
        numberLabel.text = name
    }
    func configSelect(isSelected: Bool) {
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.5
        if isSelected {
            contentView.layer.borderColor = UIColor(hexString: "#80D5F3").cgColor
            contentView.layer.backgroundColor = UIColor(hexString: "#00AAE7").cgColor
            numberLabel.textColor = .white
        } else {
            contentView.layer.borderColor = UIColor(hexString: "#80D5F3").cgColor
            contentView.layer.backgroundColor = UIColor.white.cgColor
            numberLabel.textColor = UIColor(hexString: "#80D5F3")
        }
    }
    
    func configLock(isLock: Bool, isSelected: Bool) {
        if isLock && isSelected {
            contentView.layer.borderColor = UIColor(hexString: "#a8aeb2").cgColor
            contentView.layer.backgroundColor = UIColor(hexString: "#a8aeb2").cgColor
            numberLabel.textColor = .white
        } else if (isLock == true && isSelected == false) {
            contentView.layer.borderColor = UIColor(hexString: "#a8aeb2").cgColor
            contentView.layer.backgroundColor = UIColor.white.cgColor
            numberLabel.textColor = UIColor(hexString: "#a8aeb2")
        }
    }

    // MARK: - Private

    // MARK: - Actions

}
