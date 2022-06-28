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
        
        
        //mượn tạm Hiệp cái flow này
//        AppViewController.shared.pushToCreateNewGameScreen()
        //        AppViewController.shared.pushToSignUpScreen()
                AppViewController.shared.pushToIssueListScreen()
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
    
    
    @IBAction func onClickStartGameButton(_ sender: Any) {
        
        AppViewController.shared.pushToChooseCard()
        
    }
    @IBAction func onClickLoginButton(_ sender: Any) {
        
        
        AppViewController.shared.pushToSignInScreen()
        
    }
}
