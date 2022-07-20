//
//  dropdownTriplePointTableViewCell.swift
//  planning-pocker
//
//  Created by Slime on 18/07/2022.
//
import DropDown
import UIKit

class DropdownTriplePointTableViewCell: DropDownCell {

    @IBOutlet weak var myImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

//    func configDisplayCell(image: UIImage? = nil, descriptionCell: String? = nil) {
//        if image != nil {
//            myImageView.image = image
//        }
//        if descriptionCell != nil {
//            optionalLabel.text = descriptionCell
//        }
//    }
    
}
