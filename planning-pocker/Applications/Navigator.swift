//
//  Navigator.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

protocol Navigator {
    func pushToWelcomeScreen()
    func pushToSignInScreen(navi: UINavigationController?)
    func pushToChooseCard(navi: UINavigationController?)
    
}

extension AppViewController: Navigator {
    func pushToWelcomeScreen() {
        let vc = WelcomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToSignInScreen(navi: UINavigationController?) {
        let vc = SignInViewController()
        navi?.pushViewController(vc, animated: true)
    }
    
    func pushToChooseCard(navi: UINavigationController?) {
        let vc = ChooseCardViewController()
        navi?.pushViewController(vc, animated: true)
    }

}
