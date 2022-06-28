//
//  WelcomeViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/21/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var goToTheLoginButton: UIButton!
    @IBOutlet weak var startPokerPlainningGameButton: UIButton!
    @IBOutlet weak var startRetrospectiveButton: UIButton!
    
    
    
    // MARK: - Properties
    var user: User!
    
    // MARK: - Overrides
    
    
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpUI()
        if user != nil {
            //Hiệp sài cái này để lấy thông tin user
            print(user.id)
        } else { print("nil cmnr") }
    }
    
    // MARK: - Publics
    
    
    
    // MARK: - Private

    
    
    private func SetUpUI() {
        // set properties for Login Button
        goToTheLoginButton.layer.borderWidth = 1
        goToTheLoginButton.layer.borderColor = UIColor(hexString: "#00AAE7").cgColor
        goToTheLoginButton.layer.cornerRadius = 5
        
        // set properties for Start Retrospective Button
        startRetrospectiveButton.layer.borderWidth = 1
        startRetrospectiveButton.layer.borderColor = UIColor(hexString: "#00AAE7").cgColor
        startRetrospectiveButton.layer.cornerRadius = 5
        
        // set properties for Start Poker Plainning Game Button
        startPokerPlainningGameButton.layer.cornerRadius = 5
    }
    
    // MARK: - Actions
    // For DELETE
    @IBAction func createNewGame(_ sender: UIButton) {
        AppViewController.shared.pushToCreateNewGameScreen()
    }
    
    @IBAction func chooseCard(_ sender: UIButton) {
        AppViewController.shared.pushToChooseCardScreen()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        AppViewController.shared.pushToSignUpScreen()
    }
    @IBAction func signIn(_ sender: UIButton) {
        AppViewController.shared.pushToSignInScreen()
    }
    @IBAction func showIssueList(_ sender: UIButton) {
        AppViewController.shared.pushToShowIssueListScreen()
    }
    @IBAction func createIssue(_ sender: UIButton) {
        AppViewController.shared.pushToCreateIssue()
    }
    @IBAction func invitePlayer(_ sender: UIButton) {
        AppViewController.shared.pushToInvitePlayerScreen()
    }
    @IBAction func editIssue(_ sender: UIButton) {
        AppViewController.shared.pushToEditIssueScreen()
    }
    @IBAction func leftMenu(_ sender: UIButton) {
        AppViewController.shared.pushToLeftMenu()
    }
    
    
    
    
    @IBAction func onClickStartGameButton(_ sender: Any) {
        
        AppViewController.shared.pushToChooseCardScreen()
        
    }
    @IBAction func onClickLoginButton(_ sender: Any) {
        
        
        AppViewController.shared.pushToSignInScreen()
        
    }
}
