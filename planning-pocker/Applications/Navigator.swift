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
    func pushToCreateNewGameScreen(customDesk: String?, deskValue: [String]?)
    func pushToChooseCardScreen(newRoomModel: RoomModel?, gameInfo: GameModel?)
    func pushToInvitePlayerScreen(url: String)
    func pushToCreateIssue()
    func pushToShowIssueListScreen(url: String?, cardData: [String]?)
    func pushToEditIssueScreen(issue: Issue?)
    func pushToLeftMenu()
    func pushToCreateCustomDesk()
    func pushToSignOut()
    func pushToJoinRoom()
    func pushToDeleteIssue(id: Int?)
    func pushToDeleteAllIssue(url: String?)

    // MARK: - POP
    func popToPreviousScreen()
    func popToViewScreen(uiViewController: UIViewController?, data: Any?)
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
    
    func pushToCreateNewGameScreen(customDesk: String? = nil, deskValue: [String]? = nil) {
        let createNewGameVC = CreateNewGameViewController()
        if customDesk != nil && deskValue != nil {
            createNewGameVC.votingSystemValue.append((-1, customDesk!, deskValue!))
            let customDeckItem: (index: Int, disPlayValue: String, arrayCardValue: [String]) = (0, "Create custom desk..", [])
            createNewGameVC.votingSystemValue.append(customDeckItem)
        }
        navigationController?.pushViewController(createNewGameVC, animated: true)
    }
    func pushToInvitePlayerScreen(url: String) {
        let invitePlayerVC = InvitePlayerViewController()
        invitePlayerVC.url = url
        self.presentOnRoot(with: invitePlayerVC)
    }
    
    func pushToCreateIssue() {
        let createIssueVC = CreateIssueViewController()
        navigationController?.pushViewController(createIssueVC, animated: true)
    }
    
    func pushToShowIssueListScreen(url: String? = nil, cardData: [String]? = nil) {
        let issueListVC = IssuesListViewController()
        issueListVC.gameUrl = url
        if cardData != nil {
            issueListVC.cardData = cardData!
        }
        navigationController?.pushViewController(issueListVC, animated: true)
    }
    
    func pushToEditIssueScreen(issue: Issue? = nil) {
        let editIssueVC = IssueDetailViewController()
        editIssueVC.issueModel = issue
       
        navigationController?.pushViewController(editIssueVC, animated: true)
    }
    
    func pushToLeftMenu() {
    }
    
    func pushToSignOut() {
        let signOutVC = SignOutViewController()
        self.presentOnRoot(with: signOutVC)
    }
    
    func pushToCreateCustomDesk() {
        let customDeskVC = CustomDeskViewController()
        navigationController?.pushViewController(customDeskVC, animated: true)
    }

    func pushToJoinRoom() {
        let joinRoomVC = JoinRoomViewController()
        self.presentOnRoot(with: joinRoomVC)
    }
    func pushToDeleteIssue(id: Int?) {
        let deleteIssueVC = DeleteIssueViewController()
        deleteIssueVC.id = id
        navigationController?.pushViewController(deleteIssueVC, animated: true)
    }
    func pushToDeleteAllIssue(url: String? = nil) {
        let deleteAllIssueVC = DeleteAllIssueViewController()
        deleteAllIssueVC.url = url
        navigationController?.pushViewController(deleteAllIssueVC, animated: true)
    }
    
    // MARK: - POP ACTION
    func popToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }

    func popToViewScreen(uiViewController: UIViewController?, data: Any? = nil) {
        let anyView = uiViewController! as UIViewController
        navigationController?.popToViewController(anyView, animated: true)
    }

}
