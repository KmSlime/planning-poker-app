//
//  Navigator.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

protocol Navigator {
    func pushToWelcomeScreen()
    func pushToChooseCard()
    
    func pushToSignInScreen()
    func pushToSignUpScreen()
    func pushToCreateNewGameScreen()
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
    
    func pushToSignUpScreen() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func pushToChooseCard() {
        let vc = ChooseCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func pushToCreateNewGameScreen() {
        let createNewGameVC = CreateNewGameViewController()
        navigationController?.pushViewController(createNewGameVC, animated: true)
    }
    
    
}
