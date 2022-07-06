//
//  AppViewController.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

class AppViewController: UIViewController {
    // MARK: - IBOutlets

    // MARK: - Properties
    static let shared = AppViewController()

    // MARK: - Overrides

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        pushToWelcomeScreen()
    }
    // MARK: - Publics
    func showAlert(tittle: String, message: String) {
        let alertController = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Private

    // MARK: - Actions

}

// cái này nằm ngoài class
    // MARK: - extensions
    // MARK: - protocols
