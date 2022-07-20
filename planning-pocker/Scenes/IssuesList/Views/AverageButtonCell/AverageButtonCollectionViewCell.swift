//
//  AverageButtonCollectionViewCell.swift
//  planning-pocker
//
//  Created by Slime on 19/07/2022.
//

import UIKit

class AverageButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundPointView: UIView!
    @IBOutlet weak var pointLabel: UILabel!
    
    var isPointSelected: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configSelected() {
        if isPointSelected == false {
            isPointSelected.toggle()
            backgroundPointView.makeRounded(borderWidth: 1, borderColor: UIColor.systemGray5)
            backgroundPointView.backgroundColor = .systemGray5
        } else {
            isPointSelected.toggle()
            backgroundPointView.makeRounded(borderWidth: 1, borderColor: UIColor.white)
            backgroundPointView.backgroundColor = .white
        }
    }

    func configDisplay(cardPoint: String) {
        pointLabel.text = cardPoint
    }
}
