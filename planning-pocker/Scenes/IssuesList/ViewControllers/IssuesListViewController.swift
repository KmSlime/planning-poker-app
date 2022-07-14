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


    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        issuesListTableView.delegate = self
        issuesListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listIssue.removeAll()
        getDataIssueList()
    }
        
    override func viewDidAppear(_ animated: Bool) {
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
//        gameUrl = "UpaCkBj0EbypKfdwkzvIhJinF"
        let apiEndPoint = APIPath.Auth.getIssueList.rawValue + "\(gameUrl ?? "#")"
        let getIssueListRouter = APIRouter(path: apiEndPoint, method: .get, parameters: [:], contentType: .urlFormEncoded)
        APIRequest.shared.request(router: getIssueListRouter) { [weak self] error, response in
            guard error == nil else {
                self!.showAlert(title: "Opps", message: "Error - Something went wrong")
                print("Log Create New Game: Error code - \(String(describing: error?.code))")
                return
            }

            guard response != nil else {
                self!.listIssue = []
                return
            }
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
            self!.issuesListTableView.reloadData()
            
        }
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
            print("Print something from didSelectRowAt")
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
            cell.delegate = self
            cell.setValueCell(issueModel: listIssue[indexPath.row])
            cell.displayAveragePoint(value: receiveAveragePoint ?? "-")
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
            let routerCreateIssue = APIRouter(path: APIPath.Auth.createIssue.rawValue, method: .post, parameters: [
                "title": item,
               "url": gameUrl as? String,
               "key": "PP-" + String(listIssue.count + 1)
            ], contentType: .applicationJson)
            APIRequest.shared.request(router: routerCreateIssue) { [weak self] error, response in
                guard error == nil else {
                    print("error calling POST")
                    AppViewController.shared.showAlert(title: "Error", message: String(error?.code ?? 0))
                    return
                }
                guard let id = response?["id"].int,
                      let key = response?["key"].string,
                      let title = response?["title"].string else {
                    return
                }
                print(id)
                print(key)
                print(title)
                AppViewController.shared.popToPreviousScreen()
            }
        }
    }
}

extension IssuesListViewController: IssueItemTableViewCellDelegate {
    func issueItemTableViewCellDidVote(_ controller: IssueItemTableViewCell) {
        var indexPath = issuesListTableView.indexPathForRow(at: )
        print(indexPath)
//        listIssue[indexPath].status = true
        guard let issue = self.listIssue[1] as? Issue else { // check issue valid
            return
        }
        if issue.status {
            SocketIOManager.sharedInstance.voteIssue(issueTitle: issue.issueTitle!, issueId: issue.issueId!)
        } else {
            SocketIOManager.sharedInstance.disableVote() // on socket
        }
        
        print("Delegate from click vote button")
    }
}
