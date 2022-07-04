//
//  ButtonItemTableViewCell.swift
//  planning-pocker
//
//  Created by Tieu Viet Trong Nghia on 29/06/2022.
//

import UIKit

class ButtonItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var textButton: UILabel!

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()

    }

    // MARK: - Override
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Private
    private func setupUI() {
        self.contentView.layer.cornerRadius = 4
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView

        textButton.font = UIFont(name: "Poppins-Medium", size: 16.0)
    }

}
