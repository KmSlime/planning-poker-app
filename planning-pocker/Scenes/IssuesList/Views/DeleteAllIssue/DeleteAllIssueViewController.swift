//
//  DeleteAllIssueViewController.swift
//  planning-pocker
//
//  Created by Hiep on 14/07/2022.
//

import UIKit

class DeleteAllIssueViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var deleteAllIssueView: UIView! {
        didSet {
            deleteAllIssueView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var cancelDeleteAllButton: UIButton! {
        didSet {
            cancelDeleteAllButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var deleteAllIssueButton: UIButton! {
        didSet {
            deleteAllIssueButton.layer.cornerRadius = 5
        }
    }
    
    // MARK: - Properties
    var url: String?
    var cardData: [String]?
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAllIssueView.dropShadow(color: UIColor.black)
    
        // Do any additional setup after loading the view.
    }
    
   
    
    // MARK: - Private
    private func deleteAllIssueCallAPI() {
        let path = APIPath.Issue.deleteAllIssue.rawValue + ("\(url ?? "")")
        let deleteAllRouter = APIRouter(path: path, method: .delete, parameters: [:], contentType: .urlFormEncoded)
        APIRequest.shared.request(router: deleteAllRouter) { [weak self] error, response in
            guard error == nil else {
                print(error!)
                SnackBar.showSnackBar(message: "Delete all issues failed", color: .red)
                return
            }
            
        }
        self.dismiss(animated: true)
        SnackBar.showSnackBar(message: "Delete all issues successfully", color: .green)
        AppViewController.shared.popToPreviousScreen()
    }
    
    // MARK: - Actions
    @IBAction func onClickCancelDeleteAllIssueButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickDeleteAllIssueButton (_ sender: UIButton) {
        deleteAllIssueCallAPI()
    }
    
}
