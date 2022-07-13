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
    @IBOutlet weak var sumAveragePointLabel: UILabel!
    @IBOutlet weak var issuesListTableView: UITableView! {
        didSet {
            issuesListTableView.register(UINib(nibName: "IssueItemTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueItemTableViewCell")
            issuesListTableView.register(UINib(nibName: "ButtonItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonItemTableViewCell")
        }
    }
  
    // MARK: - Properties
    var listIssue: [Issue] = []
    var issueModel: Issue?
    var gameInIssue: GameModel?
    var receiveAveragePoint: String?
    var sumAveragePoint: String?
    var gameUrl: String?
    var currentSelectedIndex: IndexPath?
    var id: Int?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        issuesListTableView.delegate = self
        issuesListTableView.dataSource = self
        getDataIssueList()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
        
    override func viewDidAppear(_ animated: Bool) {
        issuesListTableView.reloadData()
        countIssueLabel.text = String(listIssue.count) + " issues"
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        
        // font
        countIssueLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        sumAveragePointLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        
        // attribute
        sumAveragePointLabel.text = String(listIssue.count) + " points" // change this for point

        // other
        navigationItem.hidesBackButton = true
    }
    
    private func getDataIssueList() {
        gameUrl = "kspqPBBp2kgf48EBBU4Ya1UM7"
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

                self!.listIssue.append(self!.issueModel!)
            }
            // asc sort by number of key
            self!.listIssue.sort {
                ($0.issueKey?.components(separatedBy: "-")[1])! < ($1.issueKey?.components(separatedBy: "-")[1])!
            }
        }
    }
    private func deleteIssue() {
        id = 2
        
        //let path = APIPath.Auth.deleteIssue.rawValue + (id as? String?)
        //let getDeleteIssueRouter = APIRouter(path: path, method: .delete, parameters: [:], contentType: .applicationJson)
    }

    // MARK: - Actions
    @IBAction func backToChooseCard(_ sender: Any) {
        AppViewController.shared.popToPreviousScreen()
    }
}

// MARK: - extensions
extension IssuesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == listIssue.count {
            return 48
        } else {
            return 147
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == listIssue.count {
            let createIssueVC = CreateIssueViewController()
            createIssueVC.delegate = self
            navigationController?.pushViewController(createIssueVC, animated: true)
        } else {
            AppViewController.shared.pushToEditIssueScreen()
        }
    }
}

extension IssuesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIssue.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == listIssue.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonItemTableViewCell") as? ButtonItemTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IssueItemTableViewCell") as? IssueItemTableViewCell else { return UITableViewCell() }
            cell.setValueCell(issueModel: listIssue[indexPath.row])
            cell.displayAveragePoint(value: receiveAveragePoint ?? "-")
            cell.deleteIssue = { issue in
//                self.listIssue.remove(at: issueModel)
//                self.issuesListTableView.reloadData()
            }
            return cell
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
            // Nghia goi api de them vao list
            let newIssue = Issue(id: listIssue.count + 1, key: "PP-" + String(listIssue.count + 1), idGame: "1")
            newIssue.title = item
            listIssue.append(newIssue)
            AppViewController.shared.popToPreviousScreen()
        }
    }
}

