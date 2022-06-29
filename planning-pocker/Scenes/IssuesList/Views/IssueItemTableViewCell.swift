//
//  IssueItemTableViewCell.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/24/22.
//

import UIKit

class IssueItemTableViewCell: UITableViewCell {
    

    // MARK: - IBOutlets
    @IBOutlet weak var issueNameLabel: UILabel!
    @IBOutlet weak var issueDescriptionLabel: UILabel!
    @IBOutlet weak var voteIssueButton: UIButton!
    @IBOutlet weak var trashcanButton: UIButton!
    @IBOutlet weak var pointDropdownButton: UIButton!
    
    
    // MARK: - Properties

    // MARK: - Overrides
    override func awakeFromNib() {
    super.awakeFromNib()
        setupUI()
    // Initialization code
    }
     
    // MARK: - Overrides
//    override func layoutMarginsDidChange() {
//        super.layoutMarginsDidChange()
//        self.layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Publics
    func setValueCell(issue: Issue) {
        self.issueNameLabel.text = issue.title
        self.issueDescriptionLabel.text = issue.description
        //thêm nữa thì Nghĩa tự thêm vào
        
    }

    // MARK: - Private
    private func setupUI() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 27, right: 0))

        issueNameLabel.textColor = UIColor(hexString: "#000000")
//    issueDescriptionLabel
//    voteIssueButton
//    trashcanButton
//    pointDropdownButton
//
        self.backgroundColor = UIColor.itemIssueCellBackground
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.23
        self.layer.shadowPath = UIBezierPath(roundedRect:
                                                self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 3)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }


    // MARK: - Actions

}

// cái này nằm ngoài class
    // MARK: - extensions

    
    // MARK: - protocols

