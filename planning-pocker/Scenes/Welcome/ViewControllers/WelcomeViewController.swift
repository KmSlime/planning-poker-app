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
    // MARK: - Overrides

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
        } else {
            goToTheLoginButton.isHidden = false
            leftMenuButton.isHidden = true
        }
    }

    // MARK: - Actions

    @IBAction func onClickStartGameButton(_ sender: Any) {
        if userDefaults.object(forKey: "id") != nil {
            AppViewController.shared.pushToCreateNewGameScreen()
        } else {
            AppViewController.shared.pushToSignInScreen()
        }
    }
    @IBAction func onClickLoginButton(_ sender: Any) {

        AppViewController.shared.pushToSignInScreen()

    }
    @IBAction func onClickLeftMenuButton(_ sender: Any) {
        self.leftMenuState(expanded: self.isExpanded ? false : true)
    }
}
// MARK: - extensions
