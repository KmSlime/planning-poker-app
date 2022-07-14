//
//  BoardInfoView.swift
//  planning-pocker
//
//  Created by TPS on 06/23/22.
//

import UIKit

class BoardInfoView: UIView {
    var countDownValue = 3
    
    @IBOutlet weak var countDownLabel: UILabel! {
        didSet {
            countDownLabel.isHidden = true
            countDownLabel.text = String(countDownValue)
            countDownLabel.font = UIFont(name: "Poppins-Bold", size: 30.0)
        }
    }
    @IBOutlet weak var notiPickStack: UIStackView!

    @IBAction func revealButton(_ sender: UIButton) {
        SocketIOManager.sharedInstance.revealCard()
    }
    
    func showCountDownText() {
            guard let itemNotifyPickStack = self.viewWithTag(101),
                  let itemRealButton = self.viewWithTag(102),
                  let itemCountDownLabel = self.viewWithTag(103) as? UILabel else {
                return
            }
            itemNotifyPickStack.isHidden = true
            itemRealButton.isHidden =  true
            itemCountDownLabel.isHidden = false
            itemCountDownLabel.text = String(countDownValue)
            itemCountDownLabel.font = UIFont(name: "Poppins-Bold", size: 30.0)
            
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                DispatchQueue.main.async {
                    if self!.countDownValue > 0 {
                        self!.countDownValue -= 1
                        itemCountDownLabel.text = String(self!.countDownValue)
                    } else {
                        itemCountDownLabel.isHidden = true
                        self?.countDownValue = 3
                        return
                    }
                   
                }
            }
        
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
