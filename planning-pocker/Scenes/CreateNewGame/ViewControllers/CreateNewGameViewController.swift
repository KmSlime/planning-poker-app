//
//  CreateNewGameViewController.swift
//  planning-pocker
//
//  Created by Nguyen Hong Liem on 6/22/22.
//

import UIKit
import DropDown

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
    var newGame: GameModel?
    var testPlayer: PlayerModel!
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
    private func setupLeftMenu() { // set up left menu
        // Set up shadow
        self.leftMenuShadowView = UIView(frame: self.view.bounds)
        self.leftMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.leftMenuShadowView.backgroundColor = .black
        self.leftMenuShadowView.alpha = 0
        // Tap Gestures
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.leftMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if self.revealLeftMenuOnTop {
            view.insertSubview(self.leftMenuShadowView, at: 15)
        }
        // Insert LeftMenuViewController to ChooseCardViewController
        self.leftMenuViewController = LeftMenuViewController()
        self.leftMenuViewController.defaultHighLightedCell = 0
        view.insertSubview(self.leftMenuViewController!.view, at: self.revealLeftMenuOnTop ? 20 : 0)
        addChild(self.leftMenuViewController!)
        self.leftMenuViewController!.didMove(toParent: self)
        self.leftMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if self.revealLeftMenuOnTop {
            self.leftMenuTrailingConstraint = self.leftMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.leftMenuRevealWidth - self.paddingForRotation)
            self.leftMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.leftMenuViewController.view.widthAnchor.constraint(equalToConstant: self.leftMenuRevealWidth),
            self.leftMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leftMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    private func leftMenuState(expanded: Bool) {
        if expanded {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ? 0 : self.leftMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0.6
            }
        } else {
            self.animateLeftMenu(targetPosition: self.revealLeftMenuOnTop ? (-self.leftMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) {
                self.leftMenuShadowView.alpha = 0
            }
        }
    }
    private func animateLeftMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealLeftMenuOnTop {
                self.leftMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
    // MARK: - Actions
    @IBAction func createNewGame(_ sender: Any) {
        if hasErrorStatus().status == true {
            AppViewController.shared.showAlert(tittle: "Error", message: hasErrorStatus().messages!)
        } else {
            // create instance of newGameModel (later)

            // {id current user, full name of user}, game {name; id}
            testPlayer = PlayerModel(id: userDefaults.integer(forKey: "id"), name: userDefaults.string(forKey: "fullName")!, roomId: 1, role: PlayerRole.host)
            print(testPlayer as Any)
                newGame = GameModel(roomName: gameNameTextField.text!, roomId: 1, cards: [], mainPlayer: testPlayer, otherPlayers: [])
                AppViewController.shared.pushToChooseCardScreen(newGameModel: newGame)
        }
    }

    @IBAction func joinGame(_ sender: Any) {

    }

    @IBAction func showDropdownList(_ sender: Any) {
        dropdownDeleteTableView.show()

    }
    @IBAction func onClickLeftMenuButton(_ sender: UIButton) {
        self.leftMenuState(expanded: self.isExpanded ? false : true)
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
extension CreateNewGameViewController : UIGestureRecognizerDelegate {
    @objc func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        print("TapGestureRecognizer")
        if sender.state == .ended {
            if self.isExpanded {
                self.leftMenuState(expanded: false)
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("gestureRecognizer")
        if(touch.view?.isDescendant(of: self.leftMenuViewController.view))! {
            return false
        }
        return true
    }
}
    // MARK: - protocols
