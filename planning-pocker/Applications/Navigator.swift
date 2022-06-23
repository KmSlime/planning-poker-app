//
//  Navigator.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

protocol Navigator {
    func pushToWelcomeScreen()
    func pushToSignInScreen()
}

extension AppViewController: Navigator {
    func pushToWelcomeScreen() {
        let vc = WelcomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToSignInScreen() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
