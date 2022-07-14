//
//  BoardResultView.swift
//  planning-pocker
//
//  Created by Hiep on 12/07/2022.
//

import UIKit

class BoardResultView: UIView {

    @IBOutlet weak var notiPickStack: UIStackView!

    @IBAction func newvotingButton(_ sender: UIButton) {
    }
    func changeBoardInfo(isSelected: Bool) {
        guard let itemNotifyPickStack = self.viewWithTag(101),
              let itemRealButton = self.viewWithTag(102) else {
            return
        }
        itemNotifyPickStack.isHidden = isSelected == true ? true : false
        itemRealButton.isHidden = isSelected == true ? false : true
    }

}
