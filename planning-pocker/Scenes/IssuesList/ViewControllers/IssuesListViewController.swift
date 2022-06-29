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
        }
    }
    
    // MARK: - Properties
    var isssue: Issue!
    var arrayTest: [Issue] = []
    
    
    // MARK: - Overrides
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        issuesListTableView.delegate = self
        issuesListTableView.dataSource = self
        
        
        for i in 0...10 {
            arrayTest.append(Issue(idIssue: i, linkIssue: "nil", titleIssue: "PP-\(i)", idGameOfIssue: "kakak", descriptionIssue: "test descript PP-\(i)"))
        }

        setupUI()
    

    }

    // MARK: - Publics


    // MARK: - Private
    private func setupUI() {

        
        //font
        countIssueLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
        countAveragePointLabel.font = UIFont(name: "Poppins-Medium", size: 12.0)
 
        
        //    backButton:
        //    tripleMenuButton:
        //    countIssueLabel
        //    countAveragePointLabel
        //    issuesListTableView
        
        //color
//        countIssueLabel.textColor = UIColor(hexString: "#0000003D")
//        countAveragePointLabel.textColor = UIColor(hexString: "#0000003D")
//
        //style
//        passwordTextField.layer.borderWidth = 1
//        emailTextField.layer.borderWidth = 1
//        rePasswordTextField.layer.borderWidth = 1
//        fullNameTextField.layer.borderWidth = 1
        
        //attribute
//        passwordTextField.layer.cornerRadius = 4
//        emailTextField.layer.cornerRadius = 4
//        rePasswordTextField.layer.cornerRadius = 4
//        fullNameTextField.layer.cornerRadius = 4
//
        //other
        navigationItem.hidesBackButton = true
    
        
        
    }


    // MARK: - Actions
    @IBAction func backToChooseCard(_ sender: Any) {
        AppViewController.shared.popToPreviousScreen()
    }
    
}

// cái này nằm ngoài class
    // MARK: - extensions
extension IssuesListViewController: UITableViewDelegate {
    
}

extension IssuesListViewController: UITableViewDataSource {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTest.count + 1;
//        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == arrayTest.count {
                //button
            print("button")
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IssueItemTableViewCell") as? IssueItemTableViewCell else { return UITableViewCell() }
            cell.setValueCell(issue: arrayTest[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
    
    // MARK: - protocols
