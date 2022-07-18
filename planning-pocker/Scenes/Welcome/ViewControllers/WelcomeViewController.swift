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
    @IBOutlet weak var startPokerPlanningGameButton: UIButton!
    @IBOutlet weak var startRetrospectiveButton: UIButton!
    @IBOutlet weak var leftMenuButton: UIButton!

    // MARK: - Properties
    var user: User!
    private var leftMenuViewController: LeftMenuViewController!
    private var leftMenuRevealWidth: CGFloat = 300
    private var paddingForRotation: CGFloat = 150
    private var isExpanded = false
    private var leftMenuTrailingConstraint: NSLayoutConstraint!
    private var revealLeftMenuOnTop = true
    private var leftMenuShadowView: UIView!

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }

    // MARK: - Publics

    // MARK: - Private

    private func setUpUI() {
        setupLeftMenu()

        // set properties for Login Button
        goToTheLoginButton.layer.borderWidth = 1
        goToTheLoginButton.layer.borderColor = UIColor(hexString: "#00AAE7").cgColor
        goToTheLoginButton.layer.cornerRadius = 5

        // set properties for Start Retrospective Button
        startRetrospectiveButton.layer.borderWidth = 1
        startRetrospectiveButton.layer.borderColor = UIColor(hexString: "#00AAE7").cgColor
        startRetrospectiveButton.layer.cornerRadius = 5

        // set properties for Start Poker Planning Game Button
        startPokerPlanningGameButton.layer.cornerRadius = 5
        if userDefaults.object(forKey: "id") != nil {
            goToTheLoginButton.isHidden = true
            leftMenuButton.isHidden = false
            leftMenuButton.isEnabled = true
        } else {
            goToTheLoginButton.isHidden = false
            leftMenuButton.isHidden = true
            leftMenuButton.isEnabled = false
        }
    }

    // MARK: - Actions

    @IBAction func onClickStartGameButton(_ sender: Any) {
        if userDefaults.object(forKey: "id") != nil {
//            userDefaults.object(forKey: "fullName")
            AppViewController.shared.pushToCreateNewGameScreen()
        } else {
            AppViewController.shared.pushToSignInScreen()
        }
    }
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
        AppViewController.shared.pushToInvitePlayerScreen(url: "")
    }
    @IBAction func editIssue(_ sender: UIButton) {
        AppViewController.shared.pushToEditIssueScreen()
    }
    @IBAction func leftMenu(_ sender: UIButton) {
        AppViewController.shared.pushToLeftMenu()
    }
    @IBAction func show_editIssueDetail(_ sender: UIButton) {
        AppViewController.shared.pushToEditIssueScreen()
    }
//    @IBAction func revealCard(_ sender: UIButton) {
//        AppViewController.shared.pushToRevealCard()
//    }

    @IBAction func onClickLoginButton(_ sender: Any) {

        AppViewController.shared.pushToSignInScreen()

    }
    @IBAction func onClickLeftMenuButton(_ sender: Any) {
        self.leftMenuState(expanded: self.isExpanded ? false : true)
    }
}
// MARK: - extensions
