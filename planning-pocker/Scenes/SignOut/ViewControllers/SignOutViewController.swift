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
    
    // MARK: - Properties
    
    
    
    // MARK: - Overrides
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - Publics
    
    
    
    // MARK: - Private
    
    
    
    //MARK: - Setup UI
    
    
    
    // MARK: - Actions
    
    @IBAction func onClickCancelSignOutButton (_ sender: UIButton) {
        AppViewController.shared.popToPreviousScreen()
    }
    @IBAction func onClickConfirmSignOutButton (_ sender: UIButton) {
        AppViewController.shared.pushToWelcomeScreen()
        userDefaults.removeObject(forKey: "name")
    }

}

// MARK: - Extensions

// MARK: - protocols

