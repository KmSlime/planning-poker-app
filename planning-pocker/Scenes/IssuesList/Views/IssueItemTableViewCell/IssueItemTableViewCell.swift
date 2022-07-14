//
//  IssueItemTableViewCell.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/24/22.
//

import UIKit

class IssueItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var issueKeyLabel: UILabel!
    @IBOutlet weak var issueTitleLabel: UILabel!
    @IBOutlet weak var trashcanButton: UIButton!
    @IBOutlet weak var averagePointButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var voteButton: UIButton!

    // MARK: - Properties
    weak var delegate: IssueItemTableViewCellDelegate?
    var didDelete: ((UITableViewCell) -> Void)?
    var title: String?
    var indexOfIssue: Int?
    var issueVoteStatus: Bool = false

    // MARK: - Overrides
    override func awakeFromNib() {
    super.awakeFromNib()
        setupUI()
    }

    // MARK: - Overrides
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }

    // MARK: - Publics
    func setValueCell(issueModel: Issue) {
        issueTitleLabel.text = issueModel.title
        issueKeyLabel.text = issueModel.issueKey
    }

    func displayAveragePoint(value: String) {
        averagePointButton.setTitle(value, for: .normal)
    }

    // MARK: - Private
    private func setupUI() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView

        issueKeyLabel.font =  UIFont(name: "Poppins-Medium", size: 16.0)
        issueTitleLabel.font = UIFont(name: "Poppins-Medium", size: 16.0)

        backView.backgroundColor = UIColor.itemIssueCellBackground
        backView.layer.opacity = 0.77
        backView.layer.cornerRadius = 8
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backView.layer.shadowRadius = 2.5
        backView.layer.shadowOpacity = 0.23
        backView.layer.shouldRasterize = true
        backView.layer.rasterizationScale = UIScreen.main.scale
    }

    private func votingButtonUIHandle() {
        delegate?.issueItemTableViewCellDidVote(cell: self, index: indexOfIssue)
    }

    // MARK: - Actions
    @IBAction func voteIssue(_ sender: UIButton) {
        votingButtonUIHandle()

    }

    @IBAction func onCLickDeleteAIssue(_ sender: UIButton) {
        didDelete?(self)
    }
}
// MARK: - protocols
protocol IssueItemTableViewCellDelegate: AnyObject {
    func issueItemTableViewCellDidVote(cell: IssueItemTableViewCell, index: Int?)
}
