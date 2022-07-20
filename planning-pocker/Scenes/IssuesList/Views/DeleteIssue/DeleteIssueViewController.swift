//
//  DeleteIssueViewController.swift
//  planning-pocker
//
//  Created by Hiep on 14/07/2022.
//

import UIKit

class DeleteIssueViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var deleteIssueView: UIView! {
        didSet {
            deleteIssueView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var cancelDeleteButton: UIButton! {
        didSet {
            cancelDeleteButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var deleteIssueButton: UIButton! {
        didSet {
            deleteIssueButton.layer.cornerRadius = 5
        }
    }
    
    // MARK: - Properties
    var id: Int?
    var url: String?
    var cardData: [String]?


    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Actions
    @IBAction func onClickCancelDeleteIssueButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickDeleteIssueButton (_ sender: UIButton) {
        let idPath = String(id!)
        let path = APIPath.Issue.editAndDeleteIssue.rawValue + ("\(idPath )")
        let deleteIssueRouter = APIRouter(path: path, method: .delete, parameters: [:], contentType: .urlFormEncoded)
        APIRequest.shared.request(router: deleteIssueRouter) { [weak self] error, response in
            guard error == nil else {
                print(error!)
                return
            }
        }
        self.dismiss(animated: true)
        AppViewController.shared.pushToShowIssueListScreen(url: url, cardData: cardData)

    }
}
