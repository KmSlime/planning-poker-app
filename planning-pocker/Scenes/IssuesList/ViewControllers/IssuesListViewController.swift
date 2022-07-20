//
//  IssuesListViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/24/22.
//

import UIKit
import SwiftUI
import DropDown

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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    let averagePointDropDownUICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 187, height: 142), collectionViewLayout: UICollectionViewLayout())
    let dropdownTriplePointTableView = DropDown()
    var listIssue: [Issue] = []
    var issueModel: Issue?
    var gameInIssue: GameModel?
    var sumAveragePoint: Int = 0
    var gameUrl: String?
    var currentSelectedIndex: IndexPath?
    var countIssue: Int = 0
    var cardData: [String] = ["0", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "?"]
    var averagePointSelected = false

    // MARK: - Override
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropdownTriplePointTableView.bottomOffset = CGPoint(x: -130, y: (dropdownTriplePointTableView.anchorView?.plainView.bounds.height)!)
        
        selectedDropdownItem()
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        dropdownTriplePointTableView.anchorView = tripleMenuButton
        setupDropDown()
        issuesListTableView.delegate = self
        issuesListTableView.dataSource = self
        averagePointDropDownUICollectionView.delegate = self
        averagePointDropDownUICollectionView.dataSource = self
        averagePointDropDownUICollectionView.register(UINib(nibName: "AverageButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AverageButtonCollectionViewCell")
        averagePointDropDownUICollectionView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listIssue.removeAll()
        getDataIssueList()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        
        // font
        countIssueLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        sumAveragePointLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        // other
        navigationItem.hidesBackButton = true
        spinner.hidesWhenStopped = true
    }

    private func setupDropDown() {
        dropdownTriplePointTableView.dataSource = [
            "Delete all issues"
        ]
        dropdownTriplePointTableView.width = 157
        self.dropdownTriplePointTableView.cellNib = UINib(nibName: "DropdownTriplePointTableViewCell", bundle: nil)
        
        dropdownTriplePointTableView.customCellConfiguration = { index, item, cell in
            guard cell is DropdownTriplePointTableViewCell else { return }
//            guard let cell = cell as? DropdownTriplePointTableViewCell else { return }
//            cell.optionLabel.text = self.dropdownTriplePointTableView.dataSource[index]
//            cell.myImageView.image = UIImage(systemName: "icon_trashcan")

        }
    }

    private func selectedDropdownItem() {
        dropdownTriplePointTableView.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Delete all issues" {
                AppViewController.shared.pushToDeleteAllIssue(url: gameUrl!, cardData: cardData)
            }
        }
    }

    private func getDataIssueList() {
        sumAveragePoint = 0
        let apiEndPoint = APIPath.Issue.getIssueList.rawValue + "\(gameUrl ?? "#")"
        let getIssueListRouter = APIRouter(path: apiEndPoint, method: .get, parameters: [:], contentType: .urlFormEncoded)
        APIRequest.shared.request(router: getIssueListRouter) { [weak self] error, response in
            guard error == nil else {
                self!.showAlert(title: "Opps", message: "Error - Something went wrong")
                print("Log Issue List: Error code - \(String(describing: error?.code))")
                return
            }

            guard response != nil else {
                self!.listIssue = []
                return
            }

            for item in response!.self.arrayValue {
                self!.issueModel = Issue()
                self!.issueModel?.issueId = item.dictionary!["id"]?.intValue ?? -1
                self!.issueModel?.issueKey = item.dictionary!["key"]?.stringValue ?? "PP-0"
                self!.issueModel?.issueTitle = item.dictionary!["title"]?.stringValue ?? "issue #"
                self!.issueModel?.issueDescription = item.dictionary!["description"]?.stringValue ?? ""
                self!.issueModel?.issueLink = item.dictionary!["link"]?.stringValue ?? "#"
                self!.issueModel?.issueVoteStatus = item.dictionary!["status"]?.boolValue ?? false
                self!.issueModel?.issueAveragePoint = (item.dictionary!["average"]?.rawString()! == "null" ? "-" : (item.dictionary!["average"]?.stringValue)!)

                self!.gameInIssue = GameModel()
                self!.gameInIssue?.id = item.dictionary!["game"]?.dictionary!["id"]?.intValue ?? -1
                self!.gameInIssue?.name = item.dictionary!["game"]?.dictionary!["name"]?.stringValue ?? "#"
                self!.gameInIssue?.url = item.dictionary!["game"]?.dictionary!["url"]?.stringValue ?? self!.gameUrl!
                self!.issueModel?.issueBelongToGame = self!.gameInIssue!

                self!.listIssue.append(self!.issueModel!)
            }
            // asc sort by number of key
            self!.listIssue.sort {
                ($0.issueKey.components(separatedBy: "-")[1]) < ($1.issueKey.components(separatedBy: "-")[1])
            }
            self!.countIssueLabel.text = String(self!.listIssue.count) + " issues"
            for item in self!.listIssue where item.issueAveragePoint != "-" {
                    self!.sumAveragePoint += Int(item.issueAveragePoint)!
            }
            self!.sumAveragePointLabel.text = String(self!.sumAveragePoint) + " points"
            self!.issuesListTableView.reloadData()
        }
        spinner.stopAnimating()
    }
    
    // MARK: - Actions
    @IBAction func backToChooseCard(_ sender: Any) {
        AppViewController.shared.popToPreviousScreen()
    }
    @IBAction func optionDeleteAll(_ sender: Any) {
        dropdownTriplePointTableView.show()
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
            AppViewController.shared.pushToEditIssueScreen(issue: listIssue[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

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
            cell.issueModel = listIssue[indexPath.row]
            cell.indexOfIssue = indexPath.row
            cell.setValueCell(issueModel: listIssue[indexPath.row])

            if cell.issueModel?.issueVoteStatus == true {
                cell.voteButton.setTitle("Voting now...", for: .normal)
                cell.voteButton.setTitleColor(.white, for: .normal)
                cell.voteButton.layer.backgroundColor = UIColor.blueButtonColor.cgColor
                cell.backView.backgroundColor = UIColor(hexString: "#C3EAF9")
                cell.trashcanButton.isHidden = true
            } else if cell.issueModel?.issueVoteStatus == false && cell.issueModel?.issueAveragePoint != "-" {
                cell.voteButton.setTitle("Vote again", for: .normal)
                cell.voteButton.setTitleColor(.black, for: .normal)
                cell.voteButton.layer.backgroundColor = UIColor.systemGray5.cgColor
                cell.backView.backgroundColor = UIColor.itemIssueCellBackground
                cell.trashcanButton.isHidden = false
            } else if cell.issueModel?.issueVoteStatus == false && cell.issueModel?.issueAveragePoint == "-" {
                cell.voteButton.setTitle("Vote this issue", for: .normal)
                cell.voteButton.setTitleColor(.black, for: .normal)
                cell.voteButton.layer.backgroundColor = UIColor.systemGray5.cgColor
                cell.backView.backgroundColor = UIColor.itemIssueCellBackground
                cell.trashcanButton.isHidden = false
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
            let routerCreateIssue = APIRouter(path: APIPath.Issue.createIssue.rawValue, method: .post, parameters: [
                "title": item,
                "url": gameUrl ?? "#",
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
    func issueItemTableViewCellDidVote(cell: IssueItemTableViewCell, index: Int?) {
        spinner.startAnimating()
        // api handle
        let indexOfIssueInTableView = index.self ?? -1
        let voteIssueEndpoint = APIPath.Issue.voteIssue.rawValue
        let voteIssueRouter = APIRouter(path: voteIssueEndpoint, method: .put, parameters: ["id": (cell.issueModel?.issueId)!], contentType: .applicationJson)
        APIRequest.shared.request(router: voteIssueRouter) { [weak self] error, response in
            guard error == nil else {
                print("Issue List: Error [\n \(String(describing: error!))]")
                AppViewController.shared.showAlert(tittle: "Opps", message: "Something went wrong!")
                return
            }

            let isVoteSuccess = response?.dictionary?["success"]?.boolValue ?? false
            if isVoteSuccess == true {
                if cell.issueModel?.issueVoteStatus == false {
                    SocketIOManager.sharedInstance.voteIssue(issueTitle: cell.issueModel?.issueTitle ?? "#", issueId: cell.issueModel?.issueId ?? -1)
                    AppViewController.shared.popupAlert(title: "Vote for issue \((cell.issueModel?.issueKey)!) successfully!", colorPopup: UIColor.blueButtonColor)
                    self!.tripleMenuButton.isHidden = true
                } else {
                    SocketIOManager.sharedInstance.disableVote() // on socket
                    AppViewController.shared.popupAlert(title: "Cancel vote for issue \((cell.issueModel?.issueKey)!) successfully!", colorPopup: UIColor.systemGreen)
                    self!.tripleMenuButton.isHidden = false
                }
                
                self!.listIssue.removeAll()
                self!.getDataIssueList()
            } else {
                AppViewController.shared.showAlert(tittle: "Opps", message: "Something went wrong!")
                return
            }
        }
        print("Log Vote Issue: vote for issue has id \(String(describing: cell.issueModel?.issueId))!")
    }

    func issueItemAveragePointClick(cell: IssueItemTableViewCell, index: Int?) {
        let xPosition = cell.voteButton.frame.origin.x
        let yPosition = cell.voteButton.frame.origin.y
        if averagePointSelected == false {
            averagePointDropDownUICollectionView.frame = CGRect(x: xPosition, y: yPosition, width: 187, height: 142)

            self.view.addSubview(averagePointDropDownUICollectionView)
            averagePointDropDownUICollectionView.translatesAutoresizingMaskIntoConstraints = false
            averagePointDropDownUICollectionView.topAnchor.constraint(equalTo: cell.voteButton.self.bottomAnchor, constant: 5)
//            averagePointDropDownUICollectionView.topAnchor.constraint(equalTo: self.tableView(issuesListTableView, cellForRowAt: index as IndexPath).bottomAnchor, constant: CGFloat(5))
            averagePointDropDownUICollectionView.isHidden = false
            averagePointSelected.toggle()
        } else {
            averagePointDropDownUICollectionView.isHidden = true
            averagePointSelected.toggle()
        }
    }
}

extension IssuesListViewController: UICollectionViewDelegate {

}

extension IssuesListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AverageButtonCollectionViewCell", for: indexPath) as? AverageButtonCollectionViewCell
        cell?.configDisplay(cardPoint: self.cardData[indexPath.row])
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AverageButtonCollectionViewCell {
            cell.configSelected()
        }
    }
}

extension IssuesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/4)-4, height: (view.frame.size.width/4)-3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
