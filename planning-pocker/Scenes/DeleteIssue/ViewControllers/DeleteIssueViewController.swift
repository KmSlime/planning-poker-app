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
    var issueModel: Issue?
    var id: Int?
    var gameInIssue: GameModel?
    var listIssue: [Issue] = []
    // MARK: - Overrides
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Publics
    // MARK: - Private
    private func deleteIssueCallAPI() {
        id = issueModel?.id
        let idPath = String(id!)
        let path = APIPath.Auth.deleteIssue.rawValue + ("\(idPath ?? "-1")")
        let deleteIssueRouter = APIRouter(path: path, method: .delete, parameters: [:], contentType: .urlFormEncoded)
        APIRequest.shared.request(router: deleteIssueRouter){ [weak self] error, response in
            guard error == nil else {
                print(error!)
                return
            }
            self!.listIssue.sort {
                ($0.issueKey?.components(separatedBy: "-")[1])! < ($1.issueKey?.components(separatedBy: "-")[1])!
            }
            AppViewController.shared.pushToShowIssueListScreen()
        }
        
    }
    // MARK: - Setup UI
    // MARK: - Actions
    @IBAction func onClickCancelDeleteIssueButton (_ sender: UIButton) {
        AppViewController.shared.popToPreviousScreen()
    }
    @IBAction func onClickDeleteIssueButton (_ sender: UIButton) {
        deleteIssueCallAPI()
    }
}
