//
//  Navigator.swift
//  planning-pocker
//
//  Created by Tinh Nguyen on 21/06/2022.
//

import UIKit

protocol Navigator {
    // MARK: - PUSH
    func pushToWelcomeScreen(user: User?)
    func pushToSignInScreen()
    func pushToSignUpScreen()
    func pushToCreateNewGameScreen()
    func pushToChooseCardScreen(newGameModel: GameModel?)
    func pushToInvitePlayerScreen()
    func pushToCreateIssue()
    func pushToShowIssueListScreen()
    func pushToEditIssueScreen()
    func pushToLeftMenu()
    func pushToSignOut()
    //MARK: - POP
    //    func pushToChooseCardScreen()
    func popToPreviousScreen()
}

extension AppViewController: Navigator {

    // MARK: - PUSH ACTION
    func pushToWelcomeScreen(user: User? = nil) {
        let welcomeScreenVC = WelcomeViewController()
        welcomeScreenVC.user = user
        navigationController?.pushViewController(welcomeScreenVC, animated: true)
    }
    func pushToSignInScreen() {
        let signInVC = SignInViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    func pushToSignUpScreen() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    func pushToChooseCardScreen(newGameModel: GameModel? = nil) {
        let chooseCardVC = ChooseCardViewController()
        chooseCardVC.game = newGameModel
        navigationController?.pushViewController(chooseCardVC, animated: true)
    }
    func pushToCreateNewGameScreen() {
        let createNewGameVC = CreateNewGameViewController()
        navigationController?.pushViewController(createNewGameVC, animated: true)
    }
    func pushToInvitePlayerScreen() {
        let invitePlayerVC = InvitePlayerViewController()
        navigationController?.pushViewController(invitePlayerVC, animated: true)
    }
    func pushToCreateIssue() {
        let createIssueVC = CreateIssueViewController()
        navigationController?.pushViewController(createIssueVC, animated: true)
    }
    func pushToShowIssueListScreen() {
        let issueListVC = IssuesListViewController()
        navigationController?.pushViewController(issueListVC, animated: true)
    }
    func pushToEditIssueScreen() {
        let editIssueVC = IssueDetailViewController() 
        navigationController?.pushViewController(editIssueVC, animated: true)
    }
    func pushToLeftMenu() {
        let leftMenuVC = LeftMenuViewController()
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        leftMenuVC.modalPresentationStyle = .overFullScreen
        present(leftMenuVC, animated: true, completion: nil)
    }

    func pushToSignOut() {
        let signOutVC = SignOutViewController()
        navigationController?.pushViewController(signOutVC, animated: true)
    }
    // MARK: - POP ACTION
    func popToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }

}
