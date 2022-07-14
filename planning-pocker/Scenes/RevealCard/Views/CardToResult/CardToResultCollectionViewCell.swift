//
//  CardToResultCollectionViewCell.swift
//  planning-pocker
//
//  Created by Hiep on 12/07/2022.
//

import UIKit

class CardToResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var numberLabel: UILabel!

    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
    }

    // MARK: - Publics
    func config(name: String) {
        numberLabel.text = name
    }
    func configSelect(isSelected: Bool) {
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor(hexString: "#000000").cgColor
        contentView.layer.backgroundColor = UIColor.white.cgColor
        numberLabel.textColor = UIColor(hexString: "#000000")
    }

    // MARK: - Private

    // MARK: - Actions
}
