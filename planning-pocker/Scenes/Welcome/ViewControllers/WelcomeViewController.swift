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
        if userDefaults.object(forKey: "name") != nil {
            goToTheLoginButton.isHidden = true
            leftMenuButton.isHidden = false
        } else {
            goToTheLoginButton.isHidden = false
            leftMenuButton.isHidden = true
        }
    }
    private func setupLeftMenu() { // set up left menu
        // Set up shadow
        self.leftMenuShadowView = UIView(frame: self.view.bounds)
        self.leftMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.leftMenuShadowView.backgroundColor = .black
        self.leftMenuShadowView.alpha = 0
        // Tap Gestures
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.leftMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if self.revealLeftMenuOnTop {
            view.insertSubview(self.leftMenuShadowView, at: 15)
        }
        // Insert LeftMenuViewController to ChooseCardViewController
        self.leftMenuViewController = LeftMenuViewController()
        self.leftMenuViewController.defaultHighLightedCell = 0
        view.insertSubview(self.leftMenuViewController!.view, at: self.revealLeftMenuOnTop ? 20 : 0)
        addChild(self.leftMenuViewController!)
        self.leftMenuViewController!.didMove(toParent: self)
        self.leftMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if self.revealLeftMenuOnTop {
            self.leftMenuTrailingConstraint = self.leftMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.leftMenuRevealWidth - self.paddingForRotation)
            self.leftMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.leftMenuViewController.view.widthAnchor.constraint(equalToConstant: self.leftMenuRevealWidth),
            self.leftMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leftMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    private func leftMenuState(expanded: Bool) {
        if expanded {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ? 0 : self.leftMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0.6
            }
        } else {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ? (-self.leftMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0
            }
        }
    }
    private func animateLeftMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealLeftMenuOnTop {
                self.leftMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }

    // MARK: - Actions
    // For DELETE
    @IBAction func createNewGame(_ sender: UIButton) {
        AppViewController.shared.pushToCreateNewGameScreen()
    }

    @IBAction func chooseCard(_ sender: UIButton) {
        AppViewController.shared.pushToChooseCardScreen(newGameModel: nil)
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
    @IBAction func show_editIssueDetail(_ sender: UIButton) {
        AppViewController.shared.pushToEditIssueScreen()
    }

    @IBAction func onClickStartGameButton(_ sender: Any) {
        if userDefaults.object(forKey: "name") != nil {
            userDefaults.set(userDefaults.object(forKey: "name"), forKey: "name")
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

extension WelcomeViewController: UIGestureRecognizerDelegate {
    @objc func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        print("TapGestureRecognizer")
        if sender.state == .ended {
            if self.isExpanded {
                self.leftMenuState(expanded: false)
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("gestureRecognizer")
        if(touch.view?.isDescendant(of: self.leftMenuViewController.view))! {
            return false
        }
        return true
    }
}
