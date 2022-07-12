//
//  VotingSystemCell.swift
//  planning-pocker
//
//  Created by Slime on 01/07/2022.
//

import DropDown
import UIKit

class VotingSystemCell: DropDownCell {

    @IBOutlet weak var dropdownContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        dropdownContentLabel.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setVotingSystemLabel(systemName: String) {
        dropdownContentLabel.text = systemName
        
    }
    
}
