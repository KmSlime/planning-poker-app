//
//  BoardInfoView.swift
//  planning-pocker
//
//  Created by TPS on 06/23/22.
//

import UIKit

class BoardInfoView: UIView {

    
    @IBOutlet weak var notiPickStack: UIStackView!
    
    @IBAction func revealButton(_ sender: UIButton) {
    }
    func changeBoardInfo(isSelected: Bool) {
        guard let itemNotiPickStack = self.viewWithTag(101),
              let itemRealButton = self.viewWithTag(102) else {
            return
        }
        itemNotiPickStack.isHidden = isSelected == true ? true : false
        itemRealButton.isHidden = isSelected == true ? false : true
    }
}
