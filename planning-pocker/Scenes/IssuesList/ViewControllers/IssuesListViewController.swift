//
//  IssuesListViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/24/22.
//

import UIKit
import SwiftUI

class IssuesListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tripleMenuButton: UIButton!
    @IBOutlet weak var countIssueLabel: UILabel!
    @IBOutlet weak var countAveragePointLabel: UILabel!
    @IBOutlet weak var issuesListTableView: UITableView! {
        didSet {
            issuesListTableView.register(UINib(nibName: "IssueItemTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueItemTableViewCell")
            issuesListTableView.register(UINib(nibName: "ButtonItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonItemTableViewCell")
        }
    }
  
    // MARK: - Properties
    var listIssue = ListIssue()
    var gameUrl: String?
    var issueModel: Issue?
    var gameInIssue: GameModel?
    var currentSelectedIndex: IndexPath?
    var player: PlayerModel?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        issuesListTableView.delegate = self
        issuesListTableView.dataSource = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataIssueList()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        issuesListTableView.reloadData()
    }

    // MARK: - Private
    private func setupUI() {
        if player?.role == PlayerRole.member {
            tripleMenuButton.isHidden = true
        }
        
        // font
        countIssueLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        countAveragePointLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        
        // attribute
        countIssueLabel.text = String(listIssue.issue.count) + " issues"
        countAveragePointLabel.text = String(listIssue.issue.count) + " points" // change this for point

        // other
        navigationItem.hidesBackButton = true
    }
    
    private func getDataIssueList() {
        gameUrl = "UpaCkBj0EbypKfdwkzvIhJinF"
        let apiEndPoint = APIPath.Auth.getIssueList.rawValue + "\(gameUrl ?? "#")"
        let getIssueListRouter = APIRouter(path: apiEndPoint, method: .get, parameters: [:], contentType: .urlFormEncoded)
        APIRequest.shared.request(router: getIssueListRouter) { [weak self] error, response in

            for item in response!.self.arrayValue {
                self!.issueModel = Issue()
                self!.issueModel?.id = item.dictionary!["id"]?.intValue ?? -1
                self!.issueModel?.key = item.dictionary!["key"]?.stringValue ?? "PP-0"
                self!.issueModel?.title = item.dictionary!["title"]?.stringValue ?? "issue #"
                self!.issueModel?.issueDescription = item.dictionary!["description"]?.stringValue ?? ""
                self!.issueModel?.issueLink = item.dictionary!["link"]?.stringValue ?? "#"
                self!.issueModel?.issueVoteStatus = item.dictionary!["status"]?.boolValue

                self!.gameInIssue = GameModel()
                self!.gameInIssue?.id = item.dictionary!["game"]?.dictionary!["id"]?.intValue ?? -1
                self!.gameInIssue?.name = item.dictionary!["game"]?.dictionary!["name"]?.stringValue ?? "#"
                self!.gameInIssue?.url = item.dictionary!["game"]?.dictionary!["url"]?.stringValue ?? self!.gameUrl!
                self!.issueModel?.issueBelongToGame = self!.gameInIssue

                self!.listIssue.issue.append(self!.issueModel!)
            }
        }
    }

    // MARK: - Actions
    @IBAction func backToChooseCard(_ sender: Any) {
        AppViewController.shared.popToPreviousScreen()
    }
}

// MARK: - extensions
extension IssuesListViewController: UITableViewDelegate {

}

extension IssuesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == listIssue.issue.count {
            return 48
        } else {
            return 147
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIssue.issue.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == listIssue.issue.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonItemTableViewCell") as? ButtonItemTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IssueItemTableViewCell") as? IssueItemTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setValueCell(issueModel: listIssue.issue[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == listIssue.issue.count {
            let createIssueVC = CreateIssueViewController()
            createIssueVC.delegate = self
            navigationController?.pushViewController(createIssueVC, animated: true)
        } else {
            print("Print something from didSelectRowAt")
        }
    }
}

extension IssuesListViewController: createIssueViewControllerDelegate {
    func createIssueViewControllerDidCancel(_ controller: CreateIssueViewController) {
        AppViewController.shared.popToPreviousScreen()
    }

    func createIssueViewController(_ controller: CreateIssueViewController, didFinishAdding item: String) {
        if item.isEmpty {
            controller.warningLabel.text = "Tittle issue must have content"
            controller.warningLabel.isHidden = false
        } else {
            let newIssue = Issue(id: listIssue.issue.count + 1, key: "PP-" + String(listIssue.issue.count + 1), idGame: "1")
            newIssue.title = item
            listIssue.issue.append(newIssue)
            countIssueLabel.text = String(listIssue.issue.count) + " issues"
            issuesListTableView.reloadData()
            AppViewController.shared.popToPreviousScreen()
        }
    }
}

extension IssuesListViewController: IssueItemTableViewCellDelegate {
    func issueItemTableViewCellDidVote(_ controller: IssueItemTableViewCell) {
        print("Delegate from click vote button") // receive action click button from IssueItemTableViewCell, continue handle vote issue
    }
}
