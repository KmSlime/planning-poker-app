//
//  SignOutViewController.swift
//  planning-pocker
//
//  Created by Hiep on 01/07/2022.
//

import UIKit

class SignOutViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var signOutView: UIView! {
        didSet {
            signOutView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var cancelSignOutButton: UIButton! {
        didSet {
            cancelSignOutButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var confirmSignOutButton: UIButton! {
        didSet {
            confirmSignOutButton.layer.cornerRadius = 5
        }
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func onClickCancelSignOutButton (_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func onClickConfirmSignOutButton (_ sender: UIButton) {
        userDefaults.removeObject(forKey: "fullName")
        userDefaults.removeObject(forKey: "id")

        UserDefaults.resetStandardUserDefaults()
        self.dismiss(animated: true)
        print(userDefaults.string(forKey: "fullName"))
        SocketIOManager.sharedInstance.closeConnection()
        AppViewController.shared.pushToWelcomeScreen()
        SocketIOManager.sharedInstance.initSocket(isRequestConnect: true)
    }
}
