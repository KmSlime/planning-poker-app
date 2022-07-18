//
//  BoardInfoView.swift
//  planning-pocker
//
//  Created by TPS on 06/23/22.
//

import UIKit

class BoardInfoView: UIView {
    var timer: Timer?
    
    @IBOutlet weak var countDownLabel: UILabel! {
        didSet {
            countDownLabel.isHidden = true
            countDownLabel.font = UIFont(name: "Poppins-Bold", size: 30.0)
        }
    }
    @IBOutlet weak var notiPickStack: UIStackView!

    @IBAction func revealButton(_ sender: UIButton) {
        SocketIOManager.sharedInstance.revealCard()
    }
    
    func showIconPickCard(isSelected: Bool) {
        guard let itemNotifyPickStack = self.viewWithTag(101),
              let itemRealButton = self.viewWithTag(102),
                let itemCountDownLabel = self.viewWithTag(103) as? UILabel,
                let startNewVotingButton = self.viewWithTag(104) as? UIButton else {
            return
        }
        itemCountDownLabel.isHidden = true
        startNewVotingButton.isHidden = true
        itemNotifyPickStack.isHidden = isSelected == true ? true : false
        itemRealButton.isHidden = isSelected == true ? false : true
    }
    
    func showCountDownText() {
            guard let itemNotifyPickStack = self.viewWithTag(101),
                  let itemRealButton = self.viewWithTag(102),
                  let itemCountDownLabel = self.viewWithTag(103) as? UILabel,
                  let startNewVotingButton = self.viewWithTag(104) as? UIButton else {
                return
            }
            startNewVotingButton.isHidden = true
            itemNotifyPickStack.isHidden = true
            itemRealButton.isHidden =  true
            itemCountDownLabel.isHidden = false
            itemCountDownLabel.font = UIFont(name: "Poppins-Bold", size: 30.0)
        
            var numberCount: Int = 3
            itemCountDownLabel.text = String(numberCount)
            print("Before count: " + String(numberCount))
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                DispatchQueue.main.async {
                    if numberCount > 0 {
                        numberCount -= 1
                        itemCountDownLabel.text = String(numberCount)
                    } else {
                        itemCountDownLabel.isHidden = true
                        timer.invalidate()
                        SocketIOManager.sharedInstance.showResult()
                    }
                   
                }
            }
        numberCount = 3
    }
    
    func showStartNewVotingButton() {
        guard let itemNotifyPickStack = self.viewWithTag(101),
              let itemRealButton = self.viewWithTag(102),
              let itemCountDownLabel = self.viewWithTag(103) as? UILabel,
              let startNewVotingButton = self.viewWithTag(104) as? UIButton else {
            return
        }
        itemNotifyPickStack.isHidden = true
        itemRealButton.isHidden = true
        itemCountDownLabel.isHidden = true
        startNewVotingButton.isHidden = false
        startNewVotingButton.titleLabel?.text = "Start new voting"
        startNewVotingButton.addTarget(self, action: #selector(startNewVoting), for: .touchUpInside)
        
    }
    
    func showResetDefault() {
        guard let itemNotifyPickStack = self.viewWithTag(101),
              let itemRealButton = self.viewWithTag(102),
              let itemCountDownLabel = self.viewWithTag(103) as? UILabel,
              let startNewVotingButton = self.viewWithTag(104) as? UIButton else {
            return
        }
        itemNotifyPickStack.isHidden = false
        itemRealButton.isHidden = true
        itemCountDownLabel.isHidden = true
        startNewVotingButton.isHidden = true
        print("showResetDefault")
    }
    
    @objc func startNewVoting() {
        SocketIOManager.sharedInstance.startNewVoting()
    }
}
