//
//  CreateNewGameViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/22/22.
//

import UIKit
import DropDown
import SocketIO
import SideMenu

let userDefaults = UserDefaults.standard

class CreateNewGameViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var votingSystemTextField: UITextField!
    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var createGameButton: UIButton!
    @IBOutlet weak var joinGameButton: UIButton!
    @IBOutlet weak var votingSystemLabel: UILabel!

    // MARK: - Properties
    var messages: String?
    var status: Bool?
    var votingSystemValue: [(index: Int, disPlayValue: String, arrayCardValue: [String])] = [
        (0, "Fibonacci (0, 1, 2, 3, 5, 8, 13,21, 34, 55, 89, ?)", ["0", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "?"]),
        (1, "Power of (0, 1, 2, 4, 8, 16, 32, 64, ?)", ["0", "1", "2", "4", "8", "16", "32", "64", "?"])]
    var gameName: String?
    let dropdownSelectedTableView = DropDown()
    var gameModel: GameModel?
    var newRoom: RoomModel?
    var mainPlayer: PlayerModel!
    var cardData: [String]!

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dropdownSelectedTableView.anchorView = votingSystemTextField
        votingSystemTextField.placeholder = votingSystemValue[0].disPlayValue
        cardData = votingSystemValue[0].arrayCardValue
        setUpDropdown()
    }

    override func viewWillAppear(_ animated: Bool) {
        dropdownSelectedTableView.reloadAllComponents()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropdownSelectedTableView.bottomOffset = CGPoint(x: 0, y: (dropdownSelectedTableView.anchorView?.plainView.bounds.height)!)
        dropdownSelectedTableView.width = dropdownSelectedTableView.anchorView?.plainView.bounds.width // get data from api
        selectedDropdownItem()
    }

    // MARK: - Publics
    func selectedDropdownItem() {
        dropdownSelectedTableView.selectionAction = {
            [unowned self] (index: Int, item: String) in
            dropdownSelectedTableView.backgroundColor =  UIColor.white
            dropdownSelectedTableView.selectedTextColor = UIColor.white

            votingSystemTextField.placeholder = item
            cardData = votingSystemValue[index].arrayCardValue
            print(cardData as Any)

            votingSystemTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
            if index + 1 == votingSystemValue.count {
                let customDeskVC = CustomDeskViewController()
//                customDeskVC.deskValue = { [weak self] in
//
//                }
                self.presentOnRoot(with: customDeskVC)
            }
        }
    }

    // MARK: - Private
    private func setupUI() {
//        setupLeftMenu()
        gameNameTextField.customBorderRadius(borderColorByUIColor: UIColor.textFieldBorderColor, borderWidth: 1, borderRadius: 4)
        votingSystemTextField.customBorderRadius(borderColorByUIColor: UIColor.textFieldBorderColor, borderWidth: 1, borderRadius: 4)
        votingSystemLabel.textColor = .blueTextColor
        createGameButton.backgroundColor = UIColor.blueButtonColor
        joinGameButton.layer.borderWidth = 1
        joinGameButton.layer.borderColor = UIColor.blueButtonColor.cgColor
        joinGameButton.tintColor = UIColor.blueButtonColor
    }
    
    private func setUpDropdown() {
        // ko co api, set cung
        for item in votingSystemValue {
            dropdownSelectedTableView.dataSource.append(item.disPlayValue)
            if item.index + 1 == votingSystemValue.count {
                let customDeckItem: (index: Int, disPlayValue: String, arrayCardValue: [String]) = (0, "Create custom desk..", [])
                votingSystemValue.append(customDeckItem)
                dropdownSelectedTableView.dataSource.append(customDeckItem.disPlayValue)
                break
            }
        }
    }

    // MARK: - Actions
    @IBAction func createNewGame(_ sender: Any) {
        if hasErrorStatus().status == true {
            AppViewController.shared.showAlert(tittle: "Error", message: hasErrorStatus().messages!)
        } else {
            self.gameName = gameNameTextField.text!
            let routerCreateNewGame = APIRouter(path: APIPath.Issue.createNewGame.rawValue, method: .post, parameters: ["name": gameName!, "idUser": userDefaults.value(forKey: "id") ?? -1],
                                                contentType: .applicationJson)
            APIRequest.shared.request(router: routerCreateNewGame) { [weak self] error, response in
                guard error == nil else {
                    print("Log Create new game: Error [\n \(String(describing: error))]")
                    AppViewController.shared.showAlert(title: "Opps", message: "Error - Something went wrong")
                    return
                }
                let message = response?.dictionary?["message"]?.stringValue ?? "Log Create New Game: Else case!!"
                if message != "Log Create New Game: Else case!!" {
                    AppViewController.shared.popupAlert(title: "Create game successfully!", colorPopup: UIColor.blueButtonColor)
                    SocketIOManager.sharedInstance.createRoom(roomName: self!.gameName!, roomUrl: message, userId: userDefaults.integer(forKey: "id"), cardData: self!.cardData, userName: userDefaults.string(forKey: "fullName")!)
                } else {
                    AppViewController.shared.showAlert(title: "Opps", message: "Error - Something went wrong")
                    return
                }
            }
        }
    }

    @IBAction func joinGame(_ sender: Any) {
        AppViewController.shared.pushToJoinRoom()
    }

    @IBAction func showDropdownList(_ sender: Any) {
        votingSystemTextField.layer.borderColor = UIColor.blueButtonColor.cgColor
        dropdownSelectedTableView.show()

    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
        let menu = SideMenuNavigationController(rootViewController: LeftMenuViewController())
        menu.alwaysAnimate = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        menu.statusBarEndAlpha = 0
        present(menu, animated: true, completion: nil)
    }
}
    // MARK: - extensions

extension CreateNewGameViewController {

    // MARK: - Check Validation of Game's Name
    private func hasErrorStatus() -> (messages: String?, status: Bool?) {
        if gameNameTextField.text?.isEmpty == true {
            messages = "Game’s name is required."
            status = true
        } else if (gameNameTextField.text?.count)! > 50 {
            messages = "Game’s name is less than 50."
            status = true
        } else {
            messages = nil
            status = false
        }
        return (messages, status)
    }
}
    // MARK: - protocols
