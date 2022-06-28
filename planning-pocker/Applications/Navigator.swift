//
//  Navigator.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

protocol Navigator {
    
    //MARK: - PUSH
    func pushToWelcomeScreen(user: User?)
    func pushToSignInScreen()
    func pushToSignUpScreen()
    func pushToCreateNewGameScreen()
    func pushToChooseCard()
    func pushToInvitePlayer()
    func pushToCreateIssue()


    //MARK: - POP
    //    func pushToChooseCardScreen()
    func popToPreviousScreen()
}

 
extension AppViewController: Navigator {

    //MARK: - PUSH ACTION
    func pushToWelcomeScreen(user: User? = nil) {
        let welcomeScreenVC = WelcomeViewController()
        welcomeScreenVC.user = user
        navigationController?.pushViewController(welcomeScreenVC, animated: true)
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
    
    func pushToInvitePlayer() {
        let vc = InvitePlayerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func pushToCreateIssue() {
        let vc = CreateIssueViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK: - POP ACTION
    func popToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }

}

