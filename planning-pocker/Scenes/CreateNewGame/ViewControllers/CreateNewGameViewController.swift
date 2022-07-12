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
//    @IBOutlet weak var dropdownView: UIView!

    // MARK: - Properties
    var messages: String?
    var status: Bool?
    let dropdownDeleteTableView = DropDown()
    var arrayTest: [(id: Int, value: String)] = [(1, "Fibonacci (0, 1, 2, 3, 5, 8, 13,21, 34, 55, 89, ?)"),
                                                 (2, "Modified Fibonacci (0, 1/2, 1, 2, 3, 5, 8, 13, 20,..."),
                                                 (3, "T-Shirt (S, M, L, XL, XXL,...)"),
                                                 (4, "Power of ( 0, 1, 2, 3, 5, 8, 13,21, 34, 55, 89, ?)")]
    private var leftMenuViewController: LeftMenuViewController!
    private var leftMenuRevealWidth: CGFloat = 300
    private var paddingForRotation: CGFloat = 150
    private var isExpanded = false
    private var leftMenuTrailingConstraint: NSLayoutConstraint!
    private var revealLeftMenuOnTop = true
    private var leftMenuShadowView: UIView!
    // MARK: - Overrides

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dropdownDeleteTableView.anchorView = votingSystemTextField
        votingSystemTextField.placeholder = arrayTest[0].value
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
        dropdownDeleteTableView.selectionAction = { [unowned self] (_: Int, item: String) in
            dropdownDeleteTableView.backgroundColor =  UIColor.white
            votingSystemTextField.placeholder = item
        }
    }

    // MARK: - Private
    private func setupUI() {
        setupLeftMenu()
    }
    private func setUpDropdown() {
        // sau nay thay cai nay bang api
        for item in arrayTest {
            dropdownDeleteTableView.dataSource.append(item.value)
            if item.id == arrayTest.count {
                let customDeckItem: (id: Int, value: String) = (0, "Create custom desk..")
                arrayTest.append(customDeckItem)
                dropdownDeleteTableView.dataSource.append(customDeckItem.value)
                break
            }
        }
    }

    // MARK: - Actions
    @IBAction func createNewGame(_ sender: Any) {
        if hasErrorStatus().status == true {
            AppViewController.shared.showAlert(tittle: "Error", message: hasErrorStatus().messages!)
        } else {
            let roomName = self.gameNameTextField.text
            APIRequest.shared.request(router: APIRouter.createNewGame(name: roomName!, idUser: 2)) { _, response  in
                guard let response = response else {
                    return
                }
                let roomId = response["message"].stringValue
                SocketIOManager.sharedInstance.createRoom(roomName: roomName!, roomId: roomId, userId: Int.random(in: 1 ... 1000))
            }
        }
    }

    @IBAction func joinGame(_ sender: Any) {
        SocketIOManager.sharedInstance.enterJoinRoom(roomId: "BG852lKCXhI5CcxkJ8Ir1leJr", userId: Int.random(in: 1 ... 1000))
    }

    @IBAction func showDropdownList(_ sender: Any) {
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
