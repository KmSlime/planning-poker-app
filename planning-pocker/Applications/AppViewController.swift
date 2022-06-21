//
//  AppViewController.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

class AppViewController: UIViewController {
    static let shared = AppViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        pushToWelcomeScreen()
    }
}

extension AppViewController: Navigator {
    func pushToWelcomeScreen() {
        let vc = WelcomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
