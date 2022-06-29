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
    var dataModel = ListIssue()
    var currentSelectedIndex : IndexPath?

    // MARK: - Overrides

    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        issuesListTableView.delegate = self
        issuesListTableView.dataSource = self
        setupUI()
    }

    // MARK: - Publics


    // MARK: - Private
    private func setupUI() {
        countIssueLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        countIssueLabel.text = String(dataModel.items.count) + " issues"
        
        countAveragePointLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        countAveragePointLabel.text = String(dataModel.items.count) + " points" // change this for point
        
        navigationItem.hidesBackButton = true
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
        if indexPath.row == dataModel.items.count {
            return 60
        } else {
            return 162
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.items.count + 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == dataModel.items.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonItemTableViewCell") as? ButtonItemTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IssueItemTableViewCell") as? IssueItemTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setValueCell(issue: dataModel.items[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == dataModel.items.count {
            let vc = CreateIssueViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
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
            let newIssue = Issue(id: dataModel.items.count + 1, key: "PP-" + String(dataModel.items.count + 1) , idGame: "1")
            newIssue.title = item
            dataModel.items.append(newIssue)
            countIssueLabel.text = String(dataModel.items.count) + " issues"
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
