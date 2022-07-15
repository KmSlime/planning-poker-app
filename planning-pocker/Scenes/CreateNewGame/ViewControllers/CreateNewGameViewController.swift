//
//  CreateNewGameViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/22/22.
//

import UIKit
import DropDown
import SocketIO

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
    let dropdownDeleteTableView = DropDown()
    var gameModel: GameModel?
    var newRoom: RoomModel?
    var mainPlayer: PlayerModel!
    var cardData: [String]!


    // MARK: - Overrides

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dropdownDeleteTableView.anchorView = votingSystemTextField
        votingSystemTextField.placeholder = votingSystemValue[0].disPlayValue
        cardData = votingSystemValue[0].arrayCardValue
        setUpDropdown()
    }
    override func viewWillAppear(_ animated: Bool) {
        dropdownDeleteTableView.reloadAllComponents()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropdownDeleteTableView.bottomOffset = CGPoint(x: 0, y: (dropdownDeleteTableView.anchorView?.plainView.bounds.height)!)
        dropdownDeleteTableView.width = dropdownDeleteTableView.anchorView?.plainView.bounds.width // get data from api
        selectedDropdownItem()

    }

    // MARK: - Publics
    func selectedDropdownItem() {
        dropdownDeleteTableView.selectionAction = {
            [unowned self] (index: Int, item: String) in
            dropdownDeleteTableView.backgroundColor =  UIColor.white
            votingSystemTextField.placeholder = item
            cardData = votingSystemValue[index].arrayCardValue
            print(cardData as Any)
            votingSystemTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        }
    }

    // MARK: - Private
    private func setupUI() {
        setupLeftMenu()
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
            dropdownDeleteTableView.dataSource.append(item.disPlayValue)
            if item.index + 1 == votingSystemValue.count {
                let customDeckItem: (index: Int, disPlayValue: String, arrayCardValue: [String]) = (0, "Create custom desk..", [])
                votingSystemValue.append(customDeckItem)
                dropdownDeleteTableView.dataSource.append(customDeckItem.disPlayValue)
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
            let routerCreateNewGame = APIRouter(path: APIPath.Auth.createNewGame.rawValue,
                                                method: .post,
                                                parameters: ["name": self.gameName! as Any, "idUser": userDefaults.value(forKey: "id") ?? -1],
                                                contentType: .applicationJson)
            APIRequest.shared.request(router: routerCreateNewGame) {
                [weak self] error, response in
                let message = response?.dictionary?["message"]?.stringValue ?? "Log Create new game: Error - Else case!!"
                if message != "Log Create new game: Error - Else case!!" {
                    SocketIOManager.sharedInstance.createRoom(roomName: self!.gameName!, roomUrl: message, userId: userDefaults.integer(forKey: "id"), cardData: self!.cardData, userName: userDefaults.string(forKey: "fullName")!)
                } else { print(message) }
            }
        }
    }

    @IBAction func joinGame(_ sender: Any) {
        AppViewController.shared.pushToJoinRoom()
    }

    @IBAction func showDropdownList(_ sender: Any) {
        votingSystemTextField.layer.borderColor = UIColor.blueButtonColor.cgColor
        dropdownDeleteTableView.show()

    }
    @IBAction func leftMenuButton(_ sender: UIButton) {
        leftMenuState(expanded: MenuHolder.isExpanded ? false : true)
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
