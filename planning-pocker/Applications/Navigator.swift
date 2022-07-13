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
    func pushToChooseCardScreen(newRoomModel: RoomModel?, gameInfo: GameModel?)
    func pushToInvitePlayerScreen()
    func pushToCreateIssue()
    func pushToShowIssueListScreen(url: String?)
    func pushToEditIssueScreen()
    func pushToLeftMenu()
    func pushToCreateCustomDesk()
    func pushToSignOut()
    func pushToRevealCard()
    //MARK: - POP
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
    
    func pushToChooseCardScreen(newRoomModel: RoomModel? = nil, gameInfo: GameModel? = nil) {
        let chooseCardVC = ChooseCardViewController()
        chooseCardVC.gameInfo = gameInfo
        chooseCardVC.room = newRoomModel
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
    
    func pushToShowIssueListScreen(url: String? = nil) {
        let issueListVC = IssuesListViewController()
        issueListVC.gameUrl = url
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
    
    func pushToCreateCustomDesk() {
        let customDeskVC = CustomDeskViewController()
        navigationController?.pushViewController(customDeskVC, animated: true)
    }
    func pushToRevealCard() {
        let revealCardVC = RevealCardViewController()
        navigationController?.pushViewController(revealCardVC, animated: true)
    }
    
    //MARK: - POP ACTION
    func popToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }
    
}
